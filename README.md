# AARC CILogon Pilot (Jenkins)

This repository contains the automated deployment scripts used to set up
a [CILogon](http://www.cilogon.org/) Pilot for the [AARC](https://aarc-project.eu/) 
project. For more information on the usage of these sources see this 
[wiki](https://wiki.nikhef.nl/grid/CILogon_Pre-Pilot_Work).
 
In order to make use of this code you will need a running [Jenkins](https://jenkins-ci.org/) 
instance to coordinate the deployment. See details below.

## Prepare Jenkins

To prepare the right environment you will need one Jenkins Master and three Slaves.

### Master

The `install-jenkins.sh` script offers some automation for deploying a Jenkins instance. 
Some of the work, however still need to be done manually through the web UI. Namely, you
will have to configure security (authnetication and authorization strategies) depending
on your setup, and install a list of required Jenkins Plugins. 

See the comments in `install-jenkins.sh` for more details.

### Slaves

For the purpose of this pilot we need three Jenkins Slaves for the three components of 
the setup oulined in the [wiki](https://wiki.nikhef.nl/grid/CILogon_Pre-Pilot_Work): 
Demonstration Portal, Delegation Service and Shibboleth IdP. To set up a Slave
following these steps :

- execute the corresponding template script from the `templates/` directory on the Slave 
node, in order to install required software 
- execute the `install-slave.sh` script  on the Slave node, to prepare the environment 
for the Jenkins Slave Agent. Make sure to add the right ssh key into the script before
executing!
- add Slave manually on the [Jenkins UI](https://wiki.jenkins-ci.org/display/JENKINS/Step+by+step+guide+to+set+up+master+and+slave+machines) 
(remember to configure the right ssh credentials on Jenkins)

## Add deployment jobs

The `jenkins/` directory contains all the relevant configurations and deplyment jobs. 
You have to add this into your running Jenkins instance by copying its content over your 
Jenkins installation directory (usually found under /var/lib/jenkins). Make sure to copy 
only the subdirectories of `jenkins/` into /var/lib/jenkins, not the `jenkins/` directory 
itself (you don't want to end up with /var/lib/jenkins/jenkins).

After the directories are in place you have to reload the new configuration either by 
restarting the jenkins service, or by reloading the configurations from the Jenkins UI.

## Run deployment jobs

After adding the deployment jobs you should be able to see and edit them from the 
Jenkins UI. In order to run these scripts start the top level jobs described at the
[wiki](https://wiki.nikhef.nl/grid/CILogon_Pre-Pilot_Work_-_Jenkins)
