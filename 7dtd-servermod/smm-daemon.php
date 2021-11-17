<?php
include("vars.inc.php");

$db = new SQLite3('smmControl.sqlite');
chown('smmControl.sqlite', 'nobody'); // Ensure that the website can also read/write to this file

$query = "CREATE TABLE IF NOT EXISTS smmcontrol (command TEXT, payload TEXT, executed INTEGER)";
$db->queryExec($query, $error) or die($error);

// ModName,ModPath,Activated,OriginationPath
$query = "CREATE TABLE IF NOT EXISTS installedmods (ModName TEXT, ModPath TEXT, Activated INTEGER, OriginationPath TEXT)";
$db->queryExec($query, $error) or die($error);

// Create default file is there is not web page just yet
if(!file_exists("$INSTALL_DIR/index.php"))
    file_put_contents("<html><head> <meta http-equiv=\"refresh\" content=\"30\" /></head><body><center>7DaysToDie is currently installing in the background.<br><br>This page will automatically refresh every 30 seconds until the server is installed.<center></body></html>", "$INSTALL_DIR/index.php");

// Ensure the Steam client is up-to-date
exec("steamcmd +quit");

// Install 7DTD if it isn't initialized
if(!file_exists("/7dtd.initialized"))
  {
    # Set up the installation directory
    if(!is_dir("$INSTALL_DIR/.local")) exec("mkdir -p $INSTALL_DIR/.local");
    if(!is_dir("$INSTALL_DIR/Mods")) exec("mkdir -p $INSTALL_DIR/Mods");
    // Set up Steam .local directory
    exec("rm -rf /root/.steam/.local && ln -s $INSTALL_DIR/.local /root/.steam/.local");

    // Install 7DTD
    install7dtd();

    // Install SMM
    reinstallsmm();

    touch("/7dtd.initialized");
  }

while(true)
{
  $query = "SELECT rowid,command,payload FROM smmcontrol WHERE executed = 0 ORDER by rowid asc LIMIT 1";
  $results = $db->queryExec($query, $error) or die($error);
  while($result = $results->fetchArray())
    {
      switch($result['command'])
        {
          case "startserver":
            startserver();
          break;

          case "restartserver":
          case "stopserver":
            // Make sure that the 7DTD server is currently started
            $SERVER_RUNNING_CHECK=exec('ps awwux | grep -v grep | grep 7DaysToDieServer.x86_64');
            // Break out if 7DTD server is already stopped
            if($SERVER_RUNNING_CHECK=='') break;

            // Make sure that telnet port is up and listening
            $TELNETPORT=exec("grep 'name=\"TelnetPort\"' $INSTALL_DIR/serverconfig.xml | awk '{print $3} | cut -d'\"' -f2");
            $TELNET_CHECK=exec("netstat -anptu | grep LISTEN | grep $TELNETPORT");

            // send the two commands needed to save the world and shutdown the server
            exec("$INSTALL_DIR/7dtd-sendcmd.sh \"saveworld\"");
            sleep(5);
            exec("$INSTALL_DIR/7dtd-sendcmd.sh \"shutdown\"");
            // Delete any core files that may have been created from gameserver crashes
            exec("rm -rf $INSTALL_DIR/core.*");

            // If we are restarting, we should set the touch file to start on next iteration, then sleep to give server a chance to shutdown
            if($result['command']=='restart')
              {
                sleep(15); // Give the server a chance to stop, before continuing to next iteration starting it back up
                startserver();
              }
          break;

          case "forcestopserver":
            // Make sure that the 7DTD server is currently started
            $SERVER_RUNNING_CHECK=exec("ps awwux | grep -v grep | grep 7DaysToDieServer.x86_64 | awk '{print \$1}'");
            // Break out if 7DTD server is already stopped
            if($SERVER_RUNNING_CHECK=='') break;

            exec("kill -9 $SERVER_RUNNING_CHECK");
          break;

          case "reinstallsmm":
          reinstallsmm(); exit;
          break;

          case "disablemod":
          break;

          case "disableallmods":
          break;

          case "enablemod":
          break;

          case "enableallmods":
          break;

          case "updatemod":
          break;

          case "removemod":
          break;

          case "addmod":
          break;

          case "update7dtd":
          install7dtd();
          break;

          case "backupmodpack":
          break;

          case "restoremodpack":
          break;

          case "backupserver":
          break;

          case "restoreserver":
          break;
        }
    }

sleep 1;
}

function startserver()
{
  global $INSTALL_DIR;
  exec("cd $INSTALL_DIR; ./7DaysToDieServer.x86_64 -configfile=$INSTALL_DIR/serverconfig.xml -logfile $INSTALL_DIR/7dtd.log -quit -batchmode -nographics -dedicated;");

}

function reinstallsmm()
{
  global $INSTALL_DIR;

  // Clone the docker-7dtd repo
  exec("cd /; rm -rf docker-7dtd; git clone https://github.com/XelaNull/docker-7dtd.git; cd $INSTALL_DIR/7dtd-servermod;");
  // Link all the files from the GIT repo to the HTML directory
  if(!is_dir("$INSTALL_DIR/html/images") exec("mkdir -p $INSTALL_DIR/html/images");
  @link("/docker-7dtd/7dtd-servermod/index.php", "$INSTALL_DIR/html/index.php");
  @link("/docker-7dtd/7dtd-servermod/vars.inc.php", "$INSTALL_DIR/html/vars.inc.php");
  @link("/docker-7dtd/7dtd-servermod/main.css", "$INSTALL_DIR/html/main.css");
  @link("/docker-7dtd/7dtd-servermod/images/smm_logo.png", "$INSTALL_DIR/html/images/smm_logo.png");
  @link("/docker-7dtd/7dtd-servermod/images/menu_adminips.jpg", "$INSTALL_DIR/html/images/menu_adminips.jpg");
  @link("/docker-7dtd/7dtd-servermod/images/menu_backupmodset.jpg", "$INSTALL_DIR/html/images/menu_backupmodset.jpg");
  @link("/docker-7dtd/7dtd-servermod/images/menu_backupserver.jpg", "$INSTALL_DIR/html/images/menu_backupserver.jpg");
  @link("/docker-7dtd/7dtd-servermod/images/menu_logs.jpg", "$INSTALL_DIR/html/images/menu_logs.jpg");
  @link("/docker-7dtd/7dtd-servermod/images/menu_modconfig.jpg", "$INSTALL_DIR/html/images/menu_modconfig.jpg");
  @link("/docker-7dtd/7dtd-servermod/images/menu_modselect.jpg", "$INSTALL_DIR/html/images/menu_modselect.jpg");
  @link("/docker-7dtd/7dtd-servermod/images/menu_serverconfig.jpg", "$INSTALL_DIR/html/images/menu_serverconfig.jpg");
  @link("/docker-7dtd/7dtd-servermod/images/menu_status.jpg", "$INSTALL_DIR/html/images/menu_status.jpg");
  @link("/docker-7dtd/7dtd-servermod/images/menu_update7dtd.jpg", "$INSTALL_DIR/html/images/menu_update27dtd.jpg");
  @link("/docker-7dtd/7dtd-servermod/images/menu_updatesmm.jpg", "$INSTALL_DIR/html/images/menu_updatesmm.jpg");
  @link("/docker-7dtd/7dtd-servermod/OLD", "$INSTALL_DIR/html/OLD");

  // Set file ownership to allow website to write to key files
  chown("$INSTALL_DIR/serverconfig.xml", "nobody");
  exec("chown nobody $INSTALL_DIR/Mods* -R");
}

function install7dtd()
{
  global $STEAMCMD_NO_VALIDATE, $STEAMCMD_BETA, $STEAMCMD_BETA_PASSWORD;
  global $INSTALL_DIR;

  # Set up extra variables we will use, if they are present
  if($STEAMCMD_NO_VALIDATE!="") $validate="validate"
  if($STEAMCMD_BETA!="") $beta="-beta $STEAMCMD_BETA"
  if($STEAMCMD_BETA_PASSWORD!="") $betapassword="-betapassword $STEAMCMD_BETA_PASSWORD"

  echo "Starting Steam to perform 7DTD game server install into $INSTALL_DIR"
  exec("steamcmd +login anonymous +force_install_dir $INSTALL_DIR +app_update 294420 $beta $betapassword $validate +quit");
}

?>
