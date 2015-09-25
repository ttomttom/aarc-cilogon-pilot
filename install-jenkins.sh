#!/bin/bash

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
# Jenkins                                                                            #
######################################################################################

sudo wget -q -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins

######################################################################################
# Jenkins Config                                                                     #
######################################################################################

#enable ssl
KS_PASS="changeit"

sudo openssl req -newkey rsa:2048 -x509 -nodes -out jenkinscert.pem -keyout jenkinskey.pem -days 365  -subj "/C=XX/L=Example/O=Jenkins/CN=`hostname`"

sudo openssl pkcs12 -export -in jenkinscert.pem -inkey jenkinskey.pem -out jenkinscert.p12 -name jenkins  -passout pass:${KS_PASS}

sudo keytool -importkeystore -noprompt -srckeystore jenkinscert.p12 -srcstorepass ${KS_PASS} -destkeystore jenkins-keystore -srcstoretype pkcs12 -storepass ${KS_PASS}

sudo mv jenkins-keystore /var/lib/jenkins/
sudo chmod 400 /var/lib/jenkins/jenkins-keystore
sudo chown jenkins:jenkins /var/lib/jenkins/jenkins-keystore

## change /etc/sysconfig/jenkins
## JENKINS_HTTPS_KEYSTORE="/var/lib/jenkins/jenkins-keystore"
## JENKINS_HTTPS_KEYSTORE_PASSWORD="changeit"
## JENKINS_HTTPS_PORT="8443" 
## JENKINS_HTTPS_LISTEN_ADDRESS="0.0.0.0"

## Config basic authnetication in Jenkins
##  - enable basic security via web interface
##  - enable authnetication via jenkins stored passwords with self-registration
##  - added a user for myself
##  - disabled self-signing afterwards to stop other people from registering

######################################################################################
# Jenkins Slave Config                                                               #
######################################################################################

## Make sure to have an ssh key ready to talk to slaves.
##
## This has to be uploaded into the running jenkins instance through the web UI
## in the Credentials section. My configuration only worked if I entered the 
## ssh private key directly in the form, instead of referencing it from a file
ssh-keygen -q -t rsa -N '' -f /tmp/jenkins_rsa

## Install every Jenkins plugin needed to run our exported jobs
## These plugins are:
##
## Parameterized Trigger plugin
## Scriptler
## Copy Artifact Plugin
## Workspace Cleanup Plugin
## Environment Injector Plugin
## ChuckNorris Plugin
## Update SVN plugin
## Environment File Plugin

