#!/bin/sh
export INSTALL_DIR=/data/7DTD
export LD_LIBRARY_PATH=.
cd $INSTALL_DIR
if [[ `ps awwux | grep -v grep | grep loop_start_7dtd | wc -l` > 2 ]]; then exit; fi
while true; do
  if [ -f /7dtd.initialized ]; then break; fi;
  sleep 6;
done

rm -rf $INSTALL_DIR/core.*;
while true; do
if [[ -f $INSTALL_DIR/7DaysToDieServer.x86_64 ]] && [[ `cat $INSTALL_DIR/server.expected_status` == "start" ]]; then
  SERVER_PID=`ps awwux | grep -v grep | grep 7DaysToDieServer.x86_64`;
  [[ -z $SERVER_PID ]] && $INSTALL_DIR/7DaysToDieServer.x86_64 -configfile=$INSTALL_DIR/serverconfig.xml -logfile $INSTALL_DIR/7dtd.log -quit -batchmode -nographics -dedicated;
fi
sleep 2
done
