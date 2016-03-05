#!/bin/bash
## Let the fun begin

# MODULES
# JAVA    - Installs Java 
# ENV     - Configures Environmental Variables
# USER    - 
# ANT     - Does ANT deployment to upgrade your installation
# SERVICE - Deploys a SystemD service to keep server up Full Time


# Only Root
if [[ $EUID -ne 0 ]];
  then
    echo "Please run as a root user" 1>&2
    exit 1
fi

#Load Variables To Make the Magic Happen
source Variables.sh
echo "Variables Loaded"

## Java First Most Things Need It
for var in "$@"
do
  if [ $var = java ] || [ $var = -java ] ;
    then
      {
        echo "Installing Java 7 at $JAVADIR triggered by $var"
        chmod +755 ./java/jdk7_full_install.sh
        source ./java/jdk7_full_install.sh
      }
  fi
done

##Creating Files Owned By Our Special User

##JAVA_HOME and JAVA must exist for anything under this line

# if JAVA_HOME is not set we're not happy
if [ -z "$JAVA_HOME" ]; then
  echo "You must set the JAVA_HOME variable before running CARBON."
  exit 1
fi
