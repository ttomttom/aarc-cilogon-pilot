#!/bin/bash

set -e
set -x

######################################################################################
# Dependencies                                                                       #
######################################################################################

yum -y install man wget vim

# installing java 8
if [ -z "`which java 2> /dev/null`" ]; then
    JAVA_HOME="/usr/java/default"
    wget -q --no-cookies --no-check-certificate \
        --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F;   \
        oraclelicense=accept-securebackup-cookie" \
        "http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm"
    rpm -iv jdk-8u45-linux-x64.rpm
    echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/bashrc
    echo 'export PATH=${JAVA_HOME}/bin:${PATH}' >> /etc/bashrc
fi

######################################################################################
# Jenkins Slave Config                                                               #
######################################################################################

## make sure jenkins:jenkins exists
sudo groupadd jenkins
sudo adduser -g jenkins jenkins

cp /etc/sudoers /tmp
chmod +w /tmp/sudoers

echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /tmp/sudoers
sed -i 's/^Defaults\s*requiretty$/#Defaults    requiretty/' /tmp/sudoers


chmod -w /tmp/sudoers
visudo -q -c -s -f /tmp/sudoers
\cp -f /tmp/sudoers /etc/

## add the above created ssh key into authorizes_keys
mkdir /home/jenkins/.ssh
## replace this file with the right pub key 
echo 'REPLACE_ME' >> /home/jenkins/.ssh/authorized_keys
chmod 700 /home/jenkins/.ssh
chmod 600 /home/jenkins/.ssh/authorized_keys
chown -R jenkins:jenkins /home/jenkins/.ssh
