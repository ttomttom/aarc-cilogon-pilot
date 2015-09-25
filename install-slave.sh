#!/bin/bash

set -e
set -x

JAVA_HOME="/usr/java/default"

######################################################################################
# Dependencies                                                                       #
######################################################################################

yum -y install man wget vim

# installing java 8
JAVA_LINK=`curl -s http://www.java.com/en/download/linux_manual.jsp 2>/dev/null | grep -m 1 'Linux x64 RPM'| cut -d '"' -f 4`

if [ -n $JAVA_LINK ]; then
        wget -q -O sun-java.rpm ${JAVA_LINK}
        rpm -iv sun-java.rpm
        echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/bashrc
        echo 'export PATH=${JAVA_HOME}/bin:${PATH}' >> /etc/bashrc
else
        echo "Could not find the right JAVA_LINK"
        exit 1;
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
