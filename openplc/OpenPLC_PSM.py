#                  - OpenPLC Python SubModule (PSM) -
# 
# PSM is the bridge connecting OpenPLC core to Python programs. PSM allows
# you to directly interface OpenPLC IO using Python and even write drivers 
# for expansion boards using just regular Python.
#
# PSM API is quite simple and just has a few functions. When writing your
# own programs, avoid touching on the "__main__" function as this regulates
# how PSM works on the PLC cycle. You can write your own hardware initialization
# code on hardware_init(), and your IO handling code on update_inputs() and
# update_outputs()
#
# To manipulate IOs, just use PSM calls psm.get_var([location name]) to read
# an OpenPLC location and psm.set_var([location name], [value]) to write to
# an OpenPLC location. For example:
#     psm.get_var("QX0.0")
# will read the value of %QX0.0. Also:
#     psm.set_var("IX0.0", True)
# will set %IX0.0 to true.
#
# Below you will find a simple example that uses PSM to switch OpenPLC's
# first digital input (%IX0.0) every second. Also, if the first digital
# output (%QX0.0) is true, PSM will display "QX0.0 is true" on OpenPLC's
# dashboard. Feel free to reuse this skeleton to write whatever you want.

#import all your libraries here
import psm
import time
from w1thermsensor import W1ThermSensor, Sensor
from Adafruit_PureIO.smbus import SMBus
import RPi.GPIO as GPIO

#global variables
ESP_I2C_address = 0x21
bus = SMBus(1)

# 2 classes to easy the use of I2C data streams
# encode data to be sent
class I2C_Encoder:
    # because ESP Slave I2C library wait for buffer[128] size
    PACKER_BUFFER_LENGTH = 128

    def __init__(self):
        self._total_length = None
        self._is_written = None
        self._index = None
        self._buffer = [0] * self.PACKER_BUFFER_LENGTH
        self._frame_start = 0x02
        self._frame_end = 0x04
        self.reset()

    def reset(self):
        # Reset the packing process.
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
        # Closes the packet by adding crc8 and length
        # After that, use read()
        # skip field for CRC byte
        self._index += 1
        # add frame end
        self._buffer[self._index] = self._frame_end
        # calc and write total length
        self._index += 1
        self._total_length = self._index
        self._buffer[1] = self._total_length

        # ignore crc and end byte
        payload_range = self._total_length - 2
        # ignore start and length byte [2:payload_range]
        self._buffer[self._index - 2] = crc8(self._buffer[2:payload_range])
        self._is_written = True
        return self._buffer

    def read(self):
        # Read the packet
        if not self._is_written:
            raise Exception("ERROR: You need to finish process by using .end() method before read buffer")

        return self._buffer


# decodes data received from I2C data stream
class I2C_Decoder:
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
        self._data = None
        self._length = None
        self._buffer = None
        self._last_error = None
        self._debug = False
        self._frame_start = 0x02
        self._frame_end = 0x04

    def write(self, stream):
        # get the i2c data from slave
        # clear any previous
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

        # check if provided crc8 is good
        # ignore start, length, crc and end byte
        crc = crc8(data[2:self._length - 2])
        if crc != data[self._length - 2]:
            self._last_error = self.error_codes["INVALID_CRC"]
            raise Exception("ERROR: Unpacker invalid crc8")
        self._data = data[2:self._length - 2]
        
        return self._data

    def get_last_error(self):
        """
        @brief get the last error code and message
        @return list [error_code, error_text]
        """
        return self._last_error, self.error_decodes[self._last_error]


# routine to calculate CRC8
def crc8(data: list):
    crc = 0

    for _byte in data:
        extract = _byte
        for j in range(8, 0, -1):
            _sum = (crc ^ extract) & 0x01
            crc >>= 1
            if _sum:
                crc ^= 0x8C
            extract >>= 1

    return crc


# read data from EPS32
def read_from_esp32(i2caddress: hex, size: int):
    decoder = I2C_Decoder()
    try:
        # get data sent by ESP32, in raw format.
        stream = bus.read_bytes(i2caddress, size)
        # convert to a list to ease handling
        data = decoder.write(stream)
        return data

    except Exception as e:
        print("ERROR: {}".format(e))


# write data to ESP32
def write_to_esp32(i2caddress: hex, data: str):
    encoder = I2C_Encoder()
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
    sensors = W1ThermSensor.get_available_sensors([Sensor.DS18B20])
    GPIO.setmode(GPIO.BOARD)
    GPIO.setup(13, GPIO.OUT, initial=GPIO.LOW)


def update_inputs():
    global sensors
    temperature1 = int(sensors[0].get_temperature())
    psm.set_var("IW0", temperature1)
    temperature2 = int(sensors[1].get_temperature())
    psm.set_var("IW1", temperature2)
    write_to_esp32(ESP_I2C_address, "haiii")
    time.sleep(0.05) # dunno if this is the best place to put it
    data = read_from_esp32(ESP_I2C_address, 32)
    psm.set_var("IW2", data[0])


def update_outputs():
    pump_active = psm.get_var("QX0")
    if pump_active == 1:
        GPIO.output(13, GPIO.HIGH)
    else:
        GPIO.output(13, GPIO.LOW)
    

if __name__ == "__main__":
    hardware_init()
    while (not psm.should_quit()):
        update_inputs()
        update_outputs()
        time.sleep(0.1) #You can adjust the psm cycle time here
    psm.stop()

