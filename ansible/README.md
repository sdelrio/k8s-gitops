# Ansible

## Setup

```bash
pip install -r requirements.txt
ansible-galaxy install roles -r requirements.yml
ansible-galaxy install collections -r requirements.yml
```

## Installl


# Vagrant

## Setup

```
vagrant up
```
Vagrant provision will take care of execute the ansible, in case you need some speciffic part, or reprovision make sure to include the vagrant inventory path. Samples:
```
ansible-playbook -i inventory/vagrant/ playbooks/install/k8s.yml

ansible-playbook -i inventory/vagrant/ kubespray/cluster.yml


```
