#!/bin/bash
set -e

# Set up extra variables we will use, if they are present
[ -z "$STEAMCMD_NO_VALIDATE" ]   && validate="validate"
[ -n "$STEAMCMD_BETA" ]          && beta="-beta $STEAMCMD_BETA"
[ -n "$STEAMCMD_BETA_PASSWORD" ] && betapassword="-betapassword $STEAMCMD_BETA_PASSWORD"

echo "Starting Steam to perform application install"
steamcmd +force_install_dir $INSTALL_DIR +login anonymous +app_update 294420 $beta $betapassword $validate +quit
touch /7dtd.initialized;

# Create 7DTD ServerMod Manager Installer
rm -rf $INSTALL_DIR/Mods/* $INSTALL_DIR/Mods-Available/*
cd $INSTALL_DIR/7dtd-servermod && chmod a+x install_mods.sh
./install_mods.sh $INSTALL_DIR

echo "Completed Upgrade.";
