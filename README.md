# Bootstrap
The script below should be all that is needed to start it.

Copy and paste these commands into the terminal:
```
sudo apt-get update
sudo apt-get upgrade -y
sudo apt install python3.12-venv -y
sudo apt install curl -y
python3 -m venv ansible_venv
./ansible_venv/bin/python3 -m pip install --upgrade pip
./ansible_venv/bin/python3 -m pip install ansible-core
./ansible_venv/bin/ansible-galaxy collection install ansible.posix
./ansible_venv/bin/ansible-galaxy collection install community.general
./ansible_venv/bin/ansible-galaxy collection install community.crypto
mkdir ansible
curl -LO https://github.com/agustux/mac2012/archive/refs/tags/v1.0.13.tar.gz
tar -xvf $HOME/v1.0.13.tar.gz -C ~
ANSIBLE_CONFIG=mac2012-1.0.13/ansible.cfg ./ansible_venv/bin/ansible-playbook mac2012-1.0.13/installation.yml
ANSIBLE_CONFIG=mac2012-1.0.13/ansible.cfg ./ansible_venv/bin/ansible-playbook mac2012-1.0.13/configuration.yml
echo "remember to upload the following key to your github account:"
cat ~/.ssh/id_ed25519.pub
echo "to apply these changes run:"
echo "sudo reboot"
```
# Regarding AAC and other codecs with AirPods:
The installation and configuration YAMLs should have done the job to
install and configure the right codecs to get sound to work with paired AirPods. However, we had to manually remove the "aac" part in /usr/share/wireplumber/wireplumber.conf (added by configuration.yml) and restart wireplumber with ```systemctl restart wireplumber --user```.

Note: editing /usr/share/wireplumber/wireplumber.conf required sudo access