#!/usr/bin/php
<?php
/*
7DTD Server Daemon
Used to start/stop the server software or autoreveal.
This daemon is meant to run-once and then look for touch files to determine if any action is needed.

Syntax:
./7dtd-daemon.php <absolute_path_to_7dtd_game_install_directory>

Touchfiles that this daemon uses:
 - server.expected_status, possible values: start,stop,restart,force_stop
*/

// Error out if we were not provided a valid directory path
if(!is_dir(@$argv[1])) { echo "Invalid installation directory provided.\nSyntax: ./7dtd-daemon.php <absolute_path_to_7dtd_game_install_directory>\n"; exit; }

// Set the installation directory variable
$INSTALL_DIR=$argv[1];

// Loop until Infinity
while (1) {
// ####### MAIN BLOCK OF CODE ######## //

# Set default on the three touch files, if they don't already exist
if(!is_file($INSTALL_DIR.'/server.expected_status')) { file_put_contents($INSTALL_DIR.'/server.expected_status','start'); chown($INSTALL_DIR.'/server.expected_status','steam'); }

// Read in the current values of the three touch files
$server_expected_status = trim(file_get_contents($INSTALL_DIR.'/server.expected_status'));

// If 7DTD Server is installed, Switch for server expected_status
if(is_file($INSTALL_DIR.'/7DaysToDieServer.x86_64')) switch($server_expected_status)
  {
    case "restart":
    case "stop":
    // Make sure that the 7DTD server is currently started
    $SERVER_RUNNING_CHECK=exec('ps awwux | grep -v grep | grep 7DaysToDieServer.x86_64');
    // Break out if 7DTD server is already stopped
    if($SERVER_RUNNING_CHECK=='') break;

    // Make sure that telnet port is up and listening
    $TELNETPORT=exec("grep 'name=\"TelnetPort\"' $INSTALL_DIR/serverconfig.xml | awk '{print $3} | cut -d'\"' -f2");
    $TELNET_CHECK=exec("netstat -anptu | grep LISTEN | grep $TELNETPORT");

    // send the two commands needed to save the world and shutdown the server
    exec("/7dtd-sendcmd.sh \"saveworld\"");
    sleep(5);
    exec("/7dtd-sendcmd.sh \"shutdown\"");
    exec("rm -rf /data/7DTD/core.*");

    // If we are restarting, we should set the touch file to start on next iteration, then sleep to give server a chance to shutdown
    if($server_exected_status=='restart')
      {
        file_put_contents($INSTALL_DIR.'/server.expected_status','start'); // Set this script to start the server back up
        sleep(15); // Give the server a chance to stop, before continuing to next iteration starting it back up
      }
    break;

    // The hope and intention is that this should never be needed. But as the old saying goes:
    //    The road to hell is paved with good intentions....
    case "force_stop":
      // Kill the sudo process running the server daemon
      $SUDO_SERVER_PID=exec("ps awwux | grep -v grep | grep 7DaysToDieServer.x86_64 | grep sudo | awk '{print \$2}'");
      if($SUDO_SERVER_PID!='') { echo "Stopping SUDO Server PID: $SUDO_SERVER_PID\n"; exec("kill -9 $SUDO_SERVER_PID"); }
      // If the core server is still running, we should kill it manually too
      $SERVER_PID=exec("ps awwux | grep -v grep | grep 7DaysToDieServer.x86_64 | grep -v sudo | awk '{print \$2}'");
      if($SERVER_PID!='') { echo "Stopping Server Pid: $SERVER_PID\n"; exec("kill -9 $SERVER_PID"); }
    break;
  }

sleep(1);
// ####### MAIN BLOCK OF CODE ######## //
}

?>
