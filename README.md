# bootstrap
Run these commands:
```
sudo apt install python3.10-venv -y
sudo apt install curl -y
python3 -m venv ansible_venv
./ansible_venv/bin/python3 -m pip install --upgrade pip
./ansible_venv/bin/python3 -m pip install ansible-core
./ansible_venv/bin/ansible-galaxy collection install ansible.posix
./ansible_venv/bin/ansible-galaxy collection install community.general
./ansible_venv/bin/ansible-galaxy collection install community.crypto
mkdir ansible
curl -LO https://github.com/agustux/mac2012/archive/refs/tags/v1.0.0a.tar.gz
tar -xvf $HOME/v1.0.0a.tar.gz -C ~
ANSIBLE_CONFIG=ansible/ansible.cfg ./ansible_venv/bin/ansible-playbook ansible/installation.yml
ANSIBLE_CONFIG=ansible/ansible.cfg ./ansible_venv/bin/ansible-playbook ansible/configuration.yml
echo "remember to upload the following key to your github account:"
cat ~/.ssh/id_ed25519.pub
echo "to apply these changes run:"
echo "sudo reboot"
```
