# Bootstrap
The script below should be all that is needed to set up your ubuntu macbook

Copy and paste these commands into the terminal:
```
sudo apt update && sudo apt full-upgrade -y
sudo apt install python3.12-venv curl -y
python3 -m venv ansible_venv
./ansible_venv/bin/python3 -m pip install --upgrade pip
./ansible_venv/bin/python3 -m pip install ansible-core
./ansible_venv/bin/ansible-galaxy collection install ansible.posix
./ansible_venv/bin/ansible-galaxy collection install community.general
./ansible_venv/bin/ansible-galaxy collection install community.crypto
mkdir ansible
curl -LO https://github.com/agustux/mac2012/archive/refs/tags/v1.1.1.tar.gz
tar -xvf $HOME/v1.1.1.tar.gz -C ~
ANSIBLE_CONFIG=mac2012-1.1.1/ansible.cfg ./ansible_venv/bin/ansible-playbook mac2012-1.1.1/installation.yml
ANSIBLE_CONFIG=mac2012-1.1.1/ansible.cfg ./ansible_venv/bin/ansible-playbook mac2012-1.1.1/configuration.yml
echo "remember to upload the following key to your github account:"
cat ~/.ssh/id_ed25519.pub
echo "reboot to finish applying these changes"
```

NOTES:

The configuration.yml playbook installs the Blur My Shell and OpenWeather Refined GNOME Extensions by default. Append "--skip-tags gnome-extensions" to that line to skip their installation.

The playbooks remap the keyboard to imitate a mac's. Append "--skip-tags mac-keyboard" when running the configuration.yml to skip any configuration to the keyboard.

By default, ubuntu has not been able to manage thermals effectively and the CPU is prone to running very hot without the kernel bothering to turn up the fan. The scripts keep the fans at a constant 4650 RPMs (75%). Append "--skip-tags mac-fan" when running the configuration.yml to not add the scripts that overclock the fans.

The playbooks install and configure performance enhancement tools to run as close to it's rated high frequency as possible while sacrificing battery life. Append "--skip-tags performance" when executing both playbooks to skip this configuration.

TO SKIP ALL MAC RELATED CONFIGURATIONS, run the following:
```
sudo apt update && sudo apt full-upgrade -y
sudo apt install python3.12-venv curl -y
python3 -m venv ansible_venv
./ansible_venv/bin/python3 -m pip install --upgrade pip
./ansible_venv/bin/python3 -m pip install ansible-core
./ansible_venv/bin/ansible-galaxy collection install ansible.posix
./ansible_venv/bin/ansible-galaxy collection install community.general
./ansible_venv/bin/ansible-galaxy collection install community.crypto
mkdir ansible
curl -LO https://github.com/agustux/mac2012/archive/refs/tags/v1.1.1.tar.gz
tar -xvf $HOME/v1.1.1.tar.gz -C ~
ANSIBLE_CONFIG=mac2012-1.1.1/ansible.cfg ./ansible_venv/bin/ansible-playbook mac2012-1.1.1/installation.yml --skip-tags "xkeycaps,mac-keyboard,debconf-utils"
ANSIBLE_CONFIG=mac2012-1.1.1/ansible.cfg ./ansible_venv/bin/ansible-playbook mac2012-1.1.1/configuration.yml --skip-tags "mac-keyboard,xmodmap,mac-fan,dconf"
```
Reference for Thinkpad fingerprint reader:
https://askubuntu.com/questions/511876/how-do-i-install-a-fingerprint-reader-on-lenovo-thinkpad