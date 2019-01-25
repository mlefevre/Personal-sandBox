#!/bin/sh
CUSTOM_MEMORY_OPTS="-Xms1024m -Xmx2048m -Xss1024k -XX:MaxPermSize=512m -XX:NewSize=512m"
if [ "$1" = "start" ]; then
    CUSTOM_JMX_OPTS="-Dcom.sun.management.jmxremote=true -Djava.rmi.server.hostname=192.168.23.2 -Dcom.sun.management.jmxremote.port=18500 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
fi
DEBUG_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8888"
CUSTOM_JAVA_OPTS=""
ALFRESCO_DIR_PATH="/home/mlefevre/DEVENV/alfresco-4.2.7"

JAVA_HOME=$ALFRESCO_DIR_PATH/java
JRE_HOME=$ALFRESCO_DIR_PATH/java

JAVA_OPTS="-Dalfresco.home=$ALFRESCO_DIR_PATH -XX:+DisableExplicitGC -Djava.awt.headless=true"
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8 -Duser.language=en -Duser.region=US -Dhttps.protocols=TLSv1 $DEBUG_OPTS"

# Custom JAVA_OPTS for memory and jmx
JAVA_OPTS="$JAVA_OPTS  $CUSTOM_MEMORY_OPTS $CUSTOM_JMX_OPTS $CUSTOM_JAVA_OPTS"

export JAVA_HOME
export JRE_HOME
export JAVA_OPTS
