#!/bin/bash
export INSTALL_DIR=/data/7DTD
set -e

# Install Steam
cd /home/steam
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
tar zxf steamcmd_linux.tar.gz

# Set up the installation directory
[[ ! -d $INSTALL_DIR/.local ]] && mkdir -p $INSTALL_DIR/.local;
[[ ! -d $INSTALL_DIR/Mods ]] && mkdir -p $INSTALL_DIR/Mods;
chown steam:steam $INSTALL_DIR $INSTALL_DIR/.local /home/steam -R
ln -s $INSTALL_DIR/.local /home/steam/.local

# Set up extra variables we will use, if they are present
[ -z "$STEAMCMD_NO_VALIDATE" ]   && validate="validate"
[ -n "$STEAMCMD_BETA" ]          && beta="-beta $STEAMCMD_BETA"
[ -n "$STEAMCMD_BETA_PASSWORD" ] && betapassword="-betapassword $STEAMCMD_BETA_PASSWORD"

echo "Starting Steam to perform application install"
su steam -c "/home/steam/steamcmd.sh +login anonymous \
  +force_install_dir $INSTALL_DIR +app_update 294420 \
  $beta $betapassword $validate +quit"
touch /7dtd.initialized;

# Create 7DTD ServerMod Manager Installer
#echo '#!/bin/bash' > /install_servermodmgr.sh
#echo 'export INSTALL_DIR=/data/7DTD; cd $INSTALL_DIR; [[ -d $INSTALL_DIR/7dtd-servermod ]] && rm -rf 7dtd-servermod' >> /install_servermodmgr.sh
#echo 'git clone https://github.com/XelaNull/7dtd-servermod.git && \' >> /install_servermodmgr.sh
#echo 'cd 7dtd-servermod && chmod a+x install_mods.sh && ./install_mods.sh $INSTALL_DIR' >> /install_servermodmgr.sh
#chmod a+x /install_servermodmgr.sh
#/install_servermodmgr.sh

# Install all the mods that go along with the 7DTD ServerMod Manager
cd $INSTALL_DIR
ln -s /7dtd-servermod 7dtd-servermod
cd 7dtd-servermod
./install_mods.sh $INSTALL_DIR

chown steam:steam $INSTALL_DIR /home/steam -R
echo "Completed Installation.";
IPADDRESS=`/sbin/ifconfig | grep broad | awk '{print \$2}'`;
echo "Your server should now be accessible at: http://<Your_IP>7dtd"; exec "$@"
