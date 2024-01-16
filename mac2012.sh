#!/usr/bin/env bash

set -e

function log {
  local msg=$1
  echo "$(date -Is) $msg"
}

if [[ "$(cat /sys/class/power_supply/ADP1/online)" == "0" ]]; then
  echo "Charger is not plugged in: security updates will not run without power"
  exit 1
fi

log "applying security updates"
# https://askubuntu.com/questions/194/how-can-i-install-just-security-updates-from-the-command-line
# sudo unattended-upgrade --debug --dry-run
sudo unattended-upgrade

log "fixing trackpad natural scroll on apps (e.g. terminal and sublime)"
sudo apt remove xserver-xorg-input-synaptics -y

log "Wifi"
sudo apt install bcmwl-kernel-source -y

# log "fixing the theme and stuff"
# sed -i 's|^.*name="ThemeName".*$|    <property name="ThemeName" type="string" value="Adwaita-dark"/>|' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
# sed -i 's|^.*name="IconThemeName".*$|    <property name="IconThemeName" type="string" value="elementary-xfce-darker"/>|' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

##########################
# Mac Keyboard mapping
##########################

log "installing xmodmap"
sudo apt install xkeycaps -y
xmodmap -pke > ~/.Xmodmap
log "fixing Ctrl to Cmd for shortcuts"
echo "! bind left command key as another Ctrl key
remove mod4 = Super_L
keysym Super_L = Control_L
add Control = Control_L" >> ~/.Xmodmap
log "load Xmodmap"
xmodmap ~/.Xmodmap

log "fixing the trackpad speed, tap-to-click, and reverse scrolling"
sed -i 's|^.*name="Acceleration".*$|    <property name="Acceleration" type="double" value="4.200000"/>|' ~/.config/xfce4/xfconf/xfce-perchannel-xml/pointers.xml
sed -i 's|^.*name="libinput_Tapping_Enabled".*$|      <property name="libinput_Tapping_Enabled" type="int" value="1"/>|' ~/.config/xfce4/xfconf/xfce-perchannel-xml/pointers.xml
sed -i 's|^.*name="ReverseScrolling".*$|    <property name="ReverseScrolling" type="bool" value="true"/>|' ~/.config/xfce4/xfconf/xfce-perchannel-xml/pointers.xml

# select macbook pro (not sure this is necessary):
# sudo dpkg-reconfigure keyboard-configuration

log "fixing cycle_windows_key, cycle_reverse_windows_key, and switch_window_key"
# manually: open Window Manager / Keyboard tab and set
#   Cycle windows(223) Ctrl+Tab:
sed -i 's|^.* value="cycle_windows_key".*$|      <property name="\&lt;Primary\&gt;Tab" type="string" value="cycle_windows_key"/>|' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
#   Cycle windows Reverse(225) Shift+Ctrl+LeftTab:
sed -i 's|^.* value="cycle_reverse_windows_key".*$|      <property name="\&lt;Primary\&gt;\&lt;Shift\&gt;ISO_Left_Tab" type="string" value="cycle_reverse_windows_key"/>|' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
#   Switch window for same app Ctrl+`:
sed -i 's|^.* value="switch_window_key".*$|      <property name="\&lt;Primary\&gt;grave" type="string" value="switch_window_key"/>|' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml

log "configure terminal copy&paste shortcuts"
# terminal
# https://forum.xfce.org/viewtopic.php?id=12105
# https://unix.stackexchange.com/questions/271150/how-to-set-ctrlc-to-copy-ctrlv-to-paste-and-ctrlshiftc-to-kill-process-in-x
# subl ~/.config/xfce4/terminal/accels.scm
echo '(gtk_accel_path "<Actions>/terminal-window/copy" "<Primary>c")
(gtk_accel_path "<Actions>/terminal-window/paste" "<Primary>v")' >> ~/.config/xfce4/terminal/accels.scm

#################
# Sublime
#################
log "Installing sublime"
# https://www.sublimetext.com/docs/linux_repositories.html
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text -y

log "opening sublime to create default config files"
subl
sleep 2
log "closing sublime"
pkill sublime_text

log "Configuring sublime"

echo '// and are overridden in turn by syntax-specific settings.
{
  "open_files_in_new_window": "never",
  "tab_size": 2,
  "translate_tabs_to_spaces": true,
// Settings in here override those in "Default/Preferences.sublime-settings",
  "trim_trailing_white_space_on_save": "all",
}' >> ~/.config/sublime-text/Packages/User/Preferences.sublime-settings

echo '[
  { "keys": ["ctrl+left"], "command": "move_to", "args": {"to": "bol", "extend": false} },
  { "keys": ["ctrl+right"], "command": "move_to", "args": {"to": "eol", "extend": false} },
  { "keys": ["ctrl+up"], "command": "move_to", "args": {"to": "bof", "extend": false} },
  { "keys": ["ctrl+down"], "command": "move_to", "args": {"to": "eof", "extend": false} },
  { "keys": ["ctrl+g"], "command": "find_next" },
]' >> ~/.config/sublime-text/Packages/User/Default.sublime-keymap

#################
# useful software
#################
log "install git"
sudo apt install git -y
log "set git aliases"
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global user.email "$(whoami)@xubuntu"
git config --global user.name "$(whoami)"

log "installing chrome"
# found the url in https://www.google.com/chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb

log "installing Bluetooth"
sudo apt install bluez* -y
sudo apt install blueman -y
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo rfkill unblock bluetooth

sudo apt install virt-manager -y
# sudo mv xubuntu-22.04.3-desktop-amd64.iso /var/local

ssh-keygen -t ed25519 -C "$(whoami)@xubuntu" -N "" -f ~/.ssh/id_ed25519
log "remember to upload the following key to your github account:"
cat ~/.ssh/id_ed25519.pub

echo "to apply these changes run:"
echo "sudo reboot"

###############
# Users
###############
# sudo apt-get install gnome-system-tools

# https://askubuntu.com/questions/1191095/how-to-disable-internet-access-by-default-for-a-specific-user-account-but-somet
# sudo iptables -A OUTPUT -m owner --uid-owner john -j REJECT
# sudo apt-get install iptables-persistent

# sudo apt-get install ruby
# add this line to root's crontab:
# * * * * * IB_USER=john IB_TIMER_URL=http://192.168.0.1:9001/time_limit /root/internet_blocker.rb >> /tmp/internet_blocker.log 2>&1

################
# Useful
################

# picture editor
# sudo apt-get install gthumb

# webcam photos
# sudo apt-get install cheese

# sudo apt install supertux


# CHANGE DISK ENCRYPTION PASSWORD
# cat /etc/crypttab
# sudo cryptsetup luksAddKey /dev/sda3
# sudo cryptsetup luksRemoveKey /dev/sda3

# CHANGE USER PASSWORD
# passwd

# remove John's rule:
# iptables -L OUTPUT --line-numbers
# iptables -D INPUT 1

##################
# new users:
##################
# u1=john
# u2=bob
# sudo install --group=${u2} --owner=${u2} --mode=664 /home/${u1}/.Xmodmap /home/${u2}/.Xmodmap
# sudo install --group=${u2} --owner=${u2} --mode=644 /home/${u1}/.config/xfce4/terminal/accels.scm /home/${u2}/.config/xfce4/terminal/accels.scm
# sudo install --group=${u2} --owner=${u2} --mode=664 /home/${u1}/.config/sublime-text/Packages/User/Preferences.sublime-settings /home/${u2}/.config/sublime-text/Packages/User/Preferences.sublime-settings
# sudo install --group=${u2} --owner=${u2} --mode=664 /home/${u1}/.config/sublime-text/Packages/User/Default.sublime-keymap /home/${u2}/.config/sublime-text/Packages/User/Default.sublime-keymap

# PS1(Blue shades)
# echo 'PS1="\e[1;36m\u@mac \t\e[m \e[1;34m\w\e[m>"' >> ~/.bashrc
