#!/bin/bash

# Should be placed in $EIS_HOME/bin


EIS_HOME="/u01/ellucian/EllucianIdentityService/"
JAVA_HOME="/usr/java/jdk1.7.0_97/"

USER="eisserviceuser"
PRODUCT_CODE="EIS"
LOCK_FILE="$EIS_HOME/wso2carbon.lck"
PID_FILE="$EIS_HOME/wso2carbon.pid"
CMD="$EIS_HOME/bin/wso2server.sh"

export EIS_HOME=$EIS_HOME
export JAVA_HOME=$JAVA_HOME




# Status the service
status() {
  if (test -f $PID_FILE )
    then
      PID=`cat $PID_FILE`
    ps -fp $PID > /dev/null 2>&1
    PIDVAL=$?
    else
      PIDVAL=3
  fi
  if (test $PIDVAL -eq 0)
    then
      echo "$PRODUCT_CODE server is running..."
    else
      echo "$PRODUCT_CODE server is stopped."
  fi
  return $PIDVAL
}

# Start the service
start(){
  if ( test -f $PID_FILE )
    then
      PID=`cat $PID_FILE`
      ps -fp $PID > /dev/null 2>&1
      PIDVAL=$?
    else
      PIDVAL=3
  fi
  
  if (test $PIDVAL -eq 0 )
    then
      echo -n "$PRODUCT_CODE server is running..."
    else
      echo -n "Starting $PRODUCT_CODE server: "
      touch $LOCK_FILE
      $CMD > /dev/null 2>&1 &
      sleep 5
      if  ( test -f $PID_FILE )
        then
          PID=`cat $PID_FILE`
          ps -f $PID > /dev/null 2>&1
          PIDVAL=$?
          
          if (test $PIDVAL -eq 0 )
            then
              echo "success"
            else
              echo "failure"
          fi
        else
        echo "failure"
        PIDVAL=2
      fi
  fi
  echo
  return $PIDVAL
}

# Restart the service
restart(){
  if (test -f $PID_FILE )
    then
      PID=`cat $PID_FILE`
      ps -fp $PID > /dev/null 2>&1
      PIDVAL=$?
      if (test $PIDVAL -eq 0 )
        then
          echo -n "Restarting $PRODUCT_CODE server:"
          
          kill $PID -sigterm
          #su - $USER -c "$CMD --stop > /dev/null 2>&1 &"
          rm -f $LOCK_FILE
          sleep 10
          
          touch $LOCK_FILE
          su - $USER -c "$CMD > /dev/null 2>&1 &"
          sleep 5
          
          
          PID=`cat $PID_FILE`
          ps -fp $PID > /dev/null 2>&1
          PIDVAL=$?
          
          if (test $PIDVAL -eq 0 )
            then 
              echo "success"
              PIDVAL=0
            else
              echo "failure"
              PIDVAL=2
          fi 
        else
          # Start If Not Running - Exists but not running
          echo "$PRODUCT_CODE server is not running. Restarting:"
          
          touch $LOCK_FILE
          $CMD > /dev/null 2>&1 &
          sleep 5
          
          if  ( test -f $PID_FILE )
            then
              PID=`cat $PID_FILE`
              ps -f $PID > /dev/null 2>&1
              PIDVAL=$?
          
              if (test $PIDVAL -eq 0 )
                then
                  echo "success"
                else
                  echo "failure"
              fi
            else
              echo "failure"
              PIDVAL=2
          fi
      fi
    else
      #Start if not running - PID file doesn't exist
      echo "$PRODUCT_CODE server is not running. Restarting:"
      
      touch $LOCK_FILE
      $CMD > /dev/null 2>&1 &
      sleep 5
      
      if  ( test -f $PID_FILE )
        then
          PID=`cat $PID_FILE`
          ps -f $PID > /dev/null 2>&1
          PIDVAL=$?
      
          if (test $PIDVAL -eq 0 )
            then
              echo "success"
            else
              echo "failure"
          fi
        else
          echo "failure"
          PIDVAL=2
      fi
  fi
  echo
  return $PIDVAL
}

# Stop the service
stop(){
  if (test -f $PID_FILE )
    then
      PID=`cat $PID_FILE`
      ps -fp $PID > /dev/null 2>&1
      PIDVAL=$?
      if (test $PIDVAL -eq 0 )
        then
          echo -n "Stopping $PRODUCT_CODE server:"
          
          kill -sigterm $PID
          #su - $USER -c "$CMD --stop > /dev/null 2>&1 &"
          rm -f $LOCK_FILE
          sleep 10
          
          PID=`cat $PID_FILE`
          ps -fp $PID > /dev/null 2>&1
          PIDVAL=$?
          
          if (test $PIDVAL -eq 0 )
            then 
              echo "failure"
              PIDVAL=2
            else
              echo "success"
              PIDVAL=0
          fi 
        else
          echo "$PRODUCT_CODE server is not running."
          PIDVAL=0
      fi
    else
      echo "$PRODUCT_CODE server is not running."
    PIDVAL=0
  fi
  echo
  return $PIDVAL
}

### This is the logic

case "$1" in 
  start)
     start
    ;;
  stop)
     stop
    ;;
  status)
    status
    ;;
  restart)
    restart
    ;;
  reload)
    restart
    ;;
  condrestart)
    restart
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|reload|status}"
    exit 1
esac
exit $?
