# Bootstrap
The script below should be all that is needed to set up your ubuntu macbook

Copy and paste these commands into the terminal:
```
sudo apt update && sudo apt upgrade -y
sudo apt install python3.12-venv curl -y
python3 -m venv ansible_venv
./ansible_venv/bin/python3 -m pip install --upgrade pip
./ansible_venv/bin/python3 -m pip install ansible-core
./ansible_venv/bin/ansible-galaxy collection install ansible.posix
./ansible_venv/bin/ansible-galaxy collection install community.general
./ansible_venv/bin/ansible-galaxy collection install community.crypto
mkdir ansible
curl -LO https://github.com/agustux/mac2012/archive/refs/tags/v1.0.15.tar.gz
tar -xvf $HOME/v1.0.15.tar.gz -C ~
ANSIBLE_CONFIG=mac2012-1.0.15/ansible.cfg ./ansible_venv/bin/ansible-playbook mac2012-1.0.15/installation.yml
ANSIBLE_CONFIG=mac2012-1.0.15/ansible.cfg ./ansible_venv/bin/ansible-playbook mac2012-1.0.15/configuration.yml
echo "remember to upload the following key to your github account:"
cat ~/.ssh/id_ed25519.pub
echo "reboot to finish applying these changes"
```
