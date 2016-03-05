#!/bin/bash 
#File requies a variable $JAVADIR to be passed to it
#Default if not passed to the script will install to /usr/java
if [ -z "$JAVADIR" ]; then
  JAVADIR=/usr/java
fi

mkdir -p $JAVADIR
cd $JAVADIR

## This script will download java 

## Last JDK7 version: JDK7u79
BASE_URL_7=http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79
JDK_VERSION=${BASE_URL_7: -8}

if [ ! -x /usr/bin/wget ] ; then
  sudo yum install -y -q wget &> /dev/null
fi

declare -a PLATFORMS=( "-linux-x64.tar.gz") # Versions Not Used "-windows-x64.exe" "-windows-i586.exe" "-docs-all.zip"  "-linux-i586.tar.gz"

for platform in "${PLATFORMS[@]}"
do 
  wget --quiet --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" ${BASE_URL_7}${platform}
  tar zxf ${JDK_VERSION}${platform}
  rm ${JDK_VERSION}${platform}
done

# Modded Variables
JAVA_HOME=${JAVADIR}/jdk1.7.0_79

# Write The Environmental Variables for java
customJavaEnvVarsLocation=/etc/profile.d/customEnvVariablesJava7.sh
if [ ! -x $customJavaEnvVarsLocation ] ; then
  sudo bash -c "echo #CREATED BY jdk7_fill_install.sh >> $customJavaEnvVarsLocation"
  sudo bash -c "echo export JAVA_HOME=$JAVA_HOME >> $customJavaEnvVarsLocation"
  sudo bash -c "echo export PATH=$PATH:$JAVA_HOME/bin >> $customJavaEnvVarsLocation"
fi

source $customJavaEnvVarsLocation





