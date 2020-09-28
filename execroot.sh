#!/bin/bash -xe
export PATH=$PATH:/usr/local/bin

yum -y install python3 wget
pip3 install ansible-bender selinux ansible
wget https://download.opensuse.org/repositories/devel%3A/kubic%3A/libcontainers%3A/stable/CentOS_7/x86_64/conmon-2.0.21-1.el7.x86_64.rpm
rpm -ivh conmon-2.0.21-1.el7.x86_64.rpm
cd /etc/yum.repos.d/
wget https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/CentOS_7/devel:kubic:libcontainers:stable.repo
yum -y install buildah podman
sed -i -e "s/^mountopt = \"nodev,metacopy=on\"/mountopt = \"nodev\"/" /etc/containers/storage.conf
systemctl start podman
cd /home/cloud-user/workspace/ansible
ansible-bender build main.yml

podman tag tamu222i:exment-web docker.io/tamu222i/exment-web:latest
podman login -u tamu222i -p `cat ../decrypted-data.txt`
podman push docker.io/tamu222i/exment-web:latest