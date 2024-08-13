#!/bin/bash
#
# This file is called by install_7dtd.sh after an installation or upgrade of the 7DTD application software
export INSTALL_DIR=/data/7DTD
# Syntax: /replace.sh <file to modify> <old value> <new value> <search string #1 to find the correct line> <optional line search string #2>
#

/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "My Game Host" "SANITYS EDGE 8K [PvE] 150% Heavily-Modded 9/7" ServerName
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "A 7 Days to Die server" "Noob Friendly! 150% XP/Loot | 3 Land Claims\n\n60+ Server Mods:\nQuests, Tools/Weapons/Armor, Magazine Skillpoints, Zombies" ServerDescription
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml 'value=""' "value='As you step closer to your Sanitys Edge, you may like to know more of what you are getting into:\n\nThis is a Noob-friendly server with 150% XP and 150% Loot. Unlimited durability land claims.\n\nWe do have an underground community horde base with /lobby and free resources you can help yourself to. Be kind and dont take all of anything. Use the /lobby command to teleport there.\n\nWe have over 60 custom mods installed on this server. Check the Esc menu for a listing of some.\nRead a Magazine to gain a Skillpoint; Use a Magazine to learn it.\nPress E to pickup plants or hit to use Living off the Land.\n\nThe FOUR Rules:\n- Be respectful\n- No griefing of any kind will be tolerated\n- Looting other players bags not allowed\n- Glitching, cheating, and using exploits are not permitted.\n  * All actions on this server are logged.'" ServerLoginConfirmationText

/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "8" "48" ServerMaxPlayerCount
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "0" "2" 'name="ServerAdminSlots"'
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "My Game" "SANITYSEDGE" GameName
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "Navezgane" "RWG" GameWorld
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "My Game" "SANITYSEDGE" GameName
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "asdf" "SANITYSEDGE" 'name="WorldGenSeed"'
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "6144" "8192" 'name="WorldGenSize"'
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "1" "4" GameDifficulty
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "3" "2" ZombieMoveNight
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml 'value=""' "value=\"$TELNET_PW\"" ServerPassword
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml 'value=""' "value=\"$TELNET_PW\"" TelnetPassword
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "72" "31" AirDropFrequency
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "64" "90" 'name="MaxSpawnedZombies"'
/data/7DTD/7dtd-servermod/replace.sh $INSTALL_DIR/serverconfig.xml "50" "75" MaxSpawnedAnimals
