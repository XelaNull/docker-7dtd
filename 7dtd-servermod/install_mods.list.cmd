#!/bin/bash
. install_mods.func.sh

# Last Updated: 2024-08-11
# For 1.0

#((MODCOUNT++))
#mkdir $MODS_DIR/$MODCOUNT
#mv /data/7DTD/7dtd-servermod/best_mod.zip $MODS_DIR/$MODCOUNT
#cd $MODS_DIR/$MODCOUNT
#unzip best_mod.zip

wget_download https://github.com/Prisma501/CSMM-Patrons-Mod/releases/download/1.0-25.0/CPM_25.0.zip CPM.zip extract_file

wget_download "https://illy.bz/fi/7dtd/server_fixes.tar.gz" server_fixes.tgz extract_file

wget_download "https://bitbucket.org/obsessive-coder/sevendaystodie-servertools/downloads/7dtd-ServerTools-G1.0.1.6.zip" ServerTools.zip extract_file # ServerTools

#wget_download "https://github.com/XelaNull/7DTD-Neopolitan/releases/download/A19.3_1.0d/2021-06-03_215241-Modlet_Collection-Shouden.zip" Neopolitan.zip extract_file

git_clone https://github.com/XelaNull/7DTD-WhiteRiver_ToC.git
git_clone https://github.com/XelaNull/7dtd-Origin-UI.git
git_clone https://github.com/XelaNull/7DTD-ShoudensModlets.git
git_clone https://github.com/XelaNull/7dtd-FixedModlets.git
git_clone https://github.com/XelaNull/7DTD-Bag_Bellows_Headshot.git
git_clone https://github.com/XelaNull/7DTD-Zombiepedia_Skillpoints.git
git_clone https://github.com/XelaNull/7DTD-ZombieLootbag_Increase.git
git_clone https://github.com/XelaNull/7DTD-Magazine_Plants_Trader.git
git_clone https://github.com/XelaNull/7DTD-DarkerNights_BrighterLights.git
git_clone https://github.com/XelaNull/7DTD-SalvagedElectronics.git
git_clone https://github.com/XelaNull/7DTD-SanitysEdgeRules.git
git_clone https://github.com/XelaNull/7dtd-Origin-UI.git