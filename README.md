# Bootstrap
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
curl -LO https://github.com/agustux/mac2012/archive/refs/tags/v1.0.10.tar.gz
tar -xvf $HOME/v1.0.10.tar.gz -C ~
ANSIBLE_CONFIG=mac2012-1.0.10/ansible.cfg ./ansible_venv/bin/ansible-playbook mac2012-1.0.10/installation.yml
ANSIBLE_CONFIG=mac2012-1.0.10/ansible.cfg ./ansible_venv/bin/ansible-playbook mac2012-1.0.10/configuration.yml
echo "remember to upload the following key to your github account:"
cat ~/.ssh/id_ed25519.pub
echo "to apply these changes run:"
echo "sudo reboot"
```
