# user: openplc
# pw: 0p3nPLC123!
#
# timezone: EU/Vienna
# keyboard: german
#
# ===============================================

sudo su
cd /home/openplc/

apt update
apt upgrade -y
apt install -y neofetch git cockpit

curl -OL https://github.com/WiringPi/WiringPi/releases/download/3.6/wiringpi_3.6_arm64.deb
dpkg -i wiringpi_3.6_arm64.deb
gpio -v

git clone https://github.com/thiagoralves/OpenPLC_v3.git
cd OpenPLC_v3
./install.sh rpi

systemctl enable openplc cockpit
systemctl start openplc cockpit

