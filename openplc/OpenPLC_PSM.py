#!/usr/bin/env python

#                  - OpenPLC Python SubModule (PSM) -
# 
# PSM is the bridge connecting OpenPLC core to Python programs. PSM allows
# you to directly interface OpenPLC IO using Python and even write drivers 
# for expansion boards using just regular Python.

__author__ = "David Koch"
__version__ = "0.2.1"

import time

import psm
from w1thermsensor import W1ThermSensor, Sensor
from Adafruit_PureIO.smbus import SMBus


PSM_CYCLE_TIME: float = 0.1  # in secs
ESP_I2C_address: int = 0x21
bus: SMBus = SMBus(1)


class I2C_Encoder:
    """
    Encodes data to be sent through the I2C data stream
    """

    PACKER_BUFFER_LENGTH: int = 128

    def __init__(self):
        self._total_length: int | None = None
        self._is_written: bool | None = None
        self._index: int | None = None
        self._buffer: list[int] = [0] * self.PACKER_BUFFER_LENGTH
        self._frame_start: int = 0x02
        self._frame_end: int = 0x04
        self.reset()

    def reset(self):
        """
        Resets the packing process
        """
        self._buffer[0] = self._frame_start
        # field for total length on index 1. data starts on field 2
        self._index = 2
        self._is_written = False

    def write(self, data: int):
        # write data in prepared buffer
        # do not allow write after .end()
        if self._is_written:
            raise Exception("ERROR: You need to restart process by using.reset() method before writing to buffer")

        self._buffer[self._index] = data
        self._index += 1

    def end(self):
        """
        Closes the frame by adding crc8 and length and returns the full frame buffer
        :return: The finished frame buffer
        """
        self._index += 1
        self._buffer[self._index] = self._frame_end
        self._index += 1
        self._total_length = self._index
        self._buffer[1] = self._total_length

        # ignore start, length, crc and end byte [2:total-2]
        self._buffer[self._index - 2] = crc8(self._buffer[2:self._total_length - 2])
        self._is_written = True

        return self._buffer

    def read(self):
        # Read the packet
        if not self._is_written:
            raise Exception("ERROR: You need to finish process by using .end() method before read buffer")

        return self._buffer


class I2C_Decoder:
    """
    Decodes data received from the I2C data stream
    """

    error_codes = {
        "INVALID_CRC": 1,
        "INVALID_LENGTH": 2,
        "INVALID_START": 3,
        "INVALID_END": 4,
    }

    error_decodes = {
        1: "INVALID_CRC",
        2: "INVALID_LENGTH",
        3: "INVALID_START",
        4: "INVALID_END",
    }

    def __init__(self):
        self._data: list[int] | None = None
        self._length: int | None = None
        self._buffer: list[int] | None = None
        self._last_error: int | None = None
        self._debug: bool = False
        self._frame_start: int = 0x02
        self._frame_end: int = 0x04

    def write(self, stream) -> list[int]:
        """
        get the i2c data from slave
        :param stream:
        :return:
        """
        # clear any previous data in the buffer
        self._buffer = []
        self._last_error = None
        data = list(stream)

        # check if start and end bytes are correct
        if data[0] != self._frame_start:
            self._last_error = self.error_codes["INVALID_START"]
            raise Exception("ERROR: invalid start byte")
        self._length = data[1]
        if data[self._length - 1] != self._frame_end:
            self._last_error = self.error_codes["INVALID_END"]
            raise Exception("ERROR: invalid end byte")

        # check if the provided crc8 is good
        # ignore start, length, crc and end byte
        crc: int = crc8(data[2:self._length - 2])
        if crc != data[self._length - 2]:
            self._last_error = self.error_codes["INVALID_CRC"]
            raise Exception("ERROR: Unpacker invalid crc8")
        self._data = data[2:self._length - 2]
        
        return self._data

    def get_last_error(self) -> (int, str):
        """
        Get the last error code and message
        :return: list [error_code, error_text]
        """
        return self._last_error, self.error_decodes[self._last_error]


def crc8(data: list[int]) -> int:
    """
    Calculates the CRC8 value of a list of bytes
    :param data: List of bytes
    :return: CRC8 value of the list of bytes
    """
    crc: int = 0

    for byte in data:
        for j in range(8, 0, -1):
            sum = (crc ^ byte) & 0x01
            crc >>= 1
            if sum:
                crc ^= 0x8C
            byte >>= 1

    return crc


def read_from_esp32(i2caddress: int, size: int) -> list[int]:
    """
    Reads data from the ESP32 slave
    :param i2caddress: The I2C slave address to be read from
    :param size: The size of the slave frame in bytes
    :return: List of received data bytes
    """
    decoder: I2C_Decoder = I2C_Decoder()
    try:
        # get data sent by the ESP32 in raw format
        stream = bus.read_bytes(i2caddress, size)
        data: list[int] = decoder.write(stream)
        return data

    except Exception as e:
        print("ERROR: {}".format(e))


# write data to ESP32
def write_to_esp32(i2caddress: int, data: str):
    """
    Writes data to the ESP32 slave
    :param i2caddress: The I2C slave address to be written to
    :param data: The data to be sent
    """
    encoder: I2C_Encoder = I2C_Encoder()
    try:
        # only if there is data
        if len(data) > 0:
            for c in data:
                encoder.write(ord(c))
        stream = encoder.end()

        # send stream to slave
        bus.write_bytes(i2caddress, bytearray(stream))

    except Exception as e:
        print("{}".format(e))


def hardware_init():
    global sensors
    psm.start()
    sensors: list[W1ThermSensor] = W1ThermSensor.get_available_sensors([Sensor.DS18B20])


def update_inputs():
    global sensors

    temperature1: int = int(sensors[0].get_temperature())
    psm.set_var("IW0", temperature1)

    temperature2: int = int(sensors[1].get_temperature())
    psm.set_var("IW1", temperature2)

    write_to_esp32(ESP_I2C_address, "haiii")
    time.sleep(0.05)  # dunno if this is the best place to put it
    data: list[int] = read_from_esp32(ESP_I2C_address, 32)
    psm.set_var("IW2", data[0])


def update_outputs():
    # code for outputs goes here
    pass
    

if __name__ == "__main__":
    hardware_init()
    while not psm.should_quit():
        update_inputs()
        update_outputs()
        time.sleep(PSM_CYCLE_TIME)
    psm.stop()
