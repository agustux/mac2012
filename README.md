# bootstrap
Run these commands:
```
sudo apt install python3.10-venv
sudo apt install curl
python3 -m venv ansible_venv
./ansible_venv/bin/python3 -m pip install --upgrade pip
./ansible_venv/bin/python3 -m pip install ansible-core
./ansible_venv/bin/ansible-galaxy collection install ansible.posix
./ansible_venv/bin/ansible-galaxy collection install community.general
./ansible_venv/bin/ansible-galaxy collection install community.crypto
curl -LO https://github.com/agustux/mac2012/archive/refs/tags/v0.0.1.tar.gz
tar -xvf $HOME/v0.0.1.tar.gz -C ~/ansible
ANSIBLE_CONFIG=ansible/ansible.cfg ./ansible_venv/bin/ansible-playbook ansible/installation.yml
ANSIBLE_CONFIG=ansible/ansible.cfg ./ansible_venv/bin/ansible-playbook ansible/configuration.yml
echo "remember to upload the following key to your github account:"
cat ~/.ssh/id_ed25519.pub
echo "to apply these changes run:"
echo "sudo reboot"
```
