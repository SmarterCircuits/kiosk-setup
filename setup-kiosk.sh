#!/bin/bash

# Stop on errors
set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing kiosk packages..."
sudo apt install -y --no-install-recommends \
  xserver-xorg \
  x11-xserver-utils \
  xinit \
  openbox \
  chromium-browser \
  lightdm

echo "Enabling graphical boot..."
sudo systemctl set-default graphical.target
sudo systemctl enable lightdm

echo "Creating kiosk autostart for user $USER..."
mkdir -p ~/.config/lxsession/LXDE-pi/

cat > ~/.config/lxsession/LXDE-pi/autostart <<EOF
@xset s off
@xset -dpms
@xset s noblank
@chromium-browser --noerrdialogs --disable-infobars --kiosk https://smartercircuits.com/timesince.html
EOF

echo "Setting lightdm to autologin $USER..."
sudo sed -i 's/^#\?autologin-user=.*/autologin-user='"$USER"'/' /etc/lightdm/lightdm.conf
sudo sed -i 's/^#\?autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

echo "✅ Kiosk setup complete. Rebooting..."
sudo reboot
