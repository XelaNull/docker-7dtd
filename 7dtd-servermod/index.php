<?php
include "vars.inc.php";

mainscreen();

function mainscreen($CONTENT)
{
global $INSTALL_DIR, $SERVER_IP, $SERVER_PORT, $SERVER_STATUS, $SERVER_NAME;

$CONTENT="This is the page content.<br>";
$SERVER_IP="x.x.x.x";
$SERVER_PORT="####";
$SERVER_STATUS="Online";
$SERVER_NAME="My Real Super-Duper Awesome Server Name";

?>
<html>

<head>
  <link rel="stylesheet" href="main.css">
  <title></title>
</head>

<body>
<div class="page-wrapper">
        <div class="left-column">
                <img src=images/smm_logo.jpg>
                <br>
                <h3>SETTINGS</h3>
                        <div class="leftmenu" onclick="location.href='index.html';"><img src=menu_status.jpg> Status</div>
                        <div class="leftmenu" onclick="location.href='index.html';"><img src=menu_serverconfig.jpg> Server Config</div>
                        <div class="leftmenu" onclick="location.href='index.html';"><img src=menu_modselect.jpg> Mod Selections</div>
                        <div class="leftmenu" onclick="location.href='index.html';"><img src=menu_modconfig.jpg> Mod Config</div>
                        <div class="leftmenu" onclick="location.href='index.html';"><img src=menu_logs.jpg> Logs</div>


                <h3>ADMINISTRATION</h3>
                        <div class="leftmenu" onclick="location.href='index.html';"><img src=menu_adminips.jpg> Admin IP Whitelist</div>
                        <div class="leftmenu" onclick="location.href='index.html';"><img src=menu_update7dtd.jpg> Update 7DTD</div>
                        <div class="leftmenu" onclick="location.href='index.html';"><img src=menu_updatesmm.jpg> Update SMM</div>
                        <div class="leftmenu" onclick="location.href='index.html';"><img src=menu_backupmodsets.jpg> Backup Mod Selections</div>
                        <div class="leftmenu" onclick="location.href='index.html';"><img src=menu_backupserver.jpg> Backup Server</div>

                <div class="left-bottom">
                        <font size=4>[Logout]</font>
                </div>
        </div>

        <div class="top-right">
                <span style="position:relative; top: 10px; left: 10px;"><img src=images/7dtd_logo.png height=120px></span>
                <div style="color: #000000; padding-right: 15px; padding-top: 15px; float: right; top: -5px;">

<?php
echo "\t\t<span style=\"font-size: 32px; text-shadow: 1px 2px #212121;\">$SERVER_NAME</span><br>";
echo "\t\t<span style=""><b>Status:</b> $SERVER_STATUS | <b>IP:</b> $SERVER_IP | <b>Port:</b> $SERVER_PORT</span>";
?>
                </div>
        </div>

        <div class="bottom-right">
                <div class="pad"><?php echo $CONTENT; ?></div>
        </div>
</div>


</body>
</html>
<?php

}


?>
