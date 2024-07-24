# user: openplc
# pw: 0p3nPLC123!
#
# timezone: EU/Vienna
# keyboard: german
#
# ===============================================

sudo su
cd /home/openplc/

# Updating & upgrading all pre-installed packages, aswell as adding our own
apt update
apt upgrade -y
apt install -y neofetch git cockpit python3-pip

# Installing WiringPi (needed for GPIO control)
curl -OL https://github.com/WiringPi/WiringPi/releases/download/3.6/wiringpi_3.6_arm64.deb
dpkg -i wiringpi_3.6_arm64.deb
gpio -v

# Installing the OpenPLC Runtime
git clone https://github.com/thiagoralves/OpenPLC_v3.git
cd OpenPLC_v3
./install.sh rpi

# Creating a virtual Python3 environment for all of our scripts (TODO: ADD PACKAGE VERSIONS!)
mkdir /home/openplc/venv
python3 -m venv /home/openplc/venv
/home/openplc/venv/pip install w1thermsensor smbus adafruit-blinka adafruit-extended-bus

# temp workaround? bcuz fuck using venvs righttt
pip3 install pymodbus==2.2.0 pyserial==3.4 w1thermsensor==2.3.0 smbus adafruit-blinka adafruit-extended-bus --break-system-packages

# Enabling and configuring the i2c and onewire interfaces
modprobe i2c-gpio
modprobe w1-gpio
# TODO: PERSISTENT ALTERNATIVE IN /boot/firmware/config.txt !!!
dtoverlay w1-gpio gpiopin=4 pullup=0
dtoverlay w1-gpio gpiopin=17 pullup=0

# (Auto-)starting all needed services
systemctl enable openplc cockpit
systemctl start openplc cockpit

reboot


