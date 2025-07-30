#!/bin/bash
# Purging Snap:
for pkg in $(snap list | awk 'NR>1 {print $1}'); do
  sudo snap remove --purge "$pkg" || true
  sleep 2
done

sudo systemctl disable --now snapd
sudo apt purge snapd -y
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd ~/snap
cat << EOF | sudo tee -a /etc/apt/preferences.d/no-snap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
sudo chown root:root /etc/apt/preferences.d/no-snap.pref
sudo apt autoremove --purge -y
