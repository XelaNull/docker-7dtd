#!/bin/bash
. install_mods.func.sh

# Last Updated: 2024-08-11
# For 1.0

#((MODCOUNT++))
#mkdir $MODS_DIR/$MODCOUNT
#mv /data/7DTD/7dtd-servermod/best_mod.zip $MODS_DIR/$MODCOUNT
#cd $MODS_DIR/$MODCOUNT
#unzip best_mod.zip

wget_download "https://illy.bz/fi/7dtd/server_fixes.tar.gz" server_fixes.tgz extract_file
git_clone https://github.com/Prisma501/Allocs-Webmap-for-CPM.git
mv $MODCOUNT/map.js $MODS_DIR/1/Mods/Allocs_WebAndMapRendering/webserver/js

git_clone https://github.com/Prisma501/CSMM-Patrons-Mod.git

wget_download "https://bitbucket.org/obsessive-coder/sevendaystodie-servertools/downloads/7dtd-ServerTools-G1.0.1.8.zip" ServerTools.zip extract_file # ServerTools

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
git_clone https://github.com/XelaNull/7DTD-Skillbook_Skillpoints.git

git_clone https://github.com/DonovanMods/donovan-7d2d-modlets.git
rm -rf $MODCOUNT/.github* $MODCOUNT/ZIPs $MODCOUNT/scripts $MODCOUNT/.gitignore $MODCOUNT/C* $MODCOUNT/L* $MODCOUNT/*.txt
mv $MODCOUNT/modlets/* $MODCOUNT/; rm -rf $MODCOUNT/modlets; mv $MODCOUNT/a-la-carte/* $MODCOUNT/; rm -rf $MODCOUNT/a-la-cart;
mkdir $MODCOUNT/KEEP; mv $MODCOUNT/donovan-betterbuffs $MODCOUNT/donovan-betterbridges $MODCOUNT/donovan-betterdyes $MODCOUNT/bettertraps $MODCOUNT/donovan-pickmeup $MODCOUNT/donovan-morehorde $MODCOUNT/donovan-nightfog $MODCOUNT/KEEP/;
rm -rf $MODCOUNT/donovan-*; mv $MODCOUNT/KEEP/* $MODCOUNT/; rm -rf $MODCOUNT/KEEP;
git_clone https://github.com/saminal1/samsmodsv1.0.git
rm -rf $MODCOUNT/SA* $MODCOUNT/SC* $MODCOUNT/SK* $MODCOUNT/SL* $MODCOUNT/SN* $MODCOUNT/SO* $MODCOUNT/SS* $MODCOUNT/SWorkingStuff
git_clone https://github.com/doughphunghus/7D2D-Doughs-Mods-a21.git
mkdir $MODCOUNT/KEEP; mv $MODCOUNT/Doughs-Weather* $MODCOUNT/Doughs-Lights $MODCOUNT/Doughs-Food-SousChefOfTheApocalypse $MODCOUNT/Doughs-Ambiance-DarkNights $MODCOUNT/Doughs-Ambiance-DarkIndoors KEEP/;
rm -rf $MODCOUNT/Doughs-*; mv $MODCOUNT/KEEP/* $MODCOUNT/; rm -rf $MODCOUNT/KEEP
git_clone https://github.com/JoeSloeMoe/LBU.git
git_clone https://github.com/arramus/A21-BushcraftBites.git
rm -rf $MODCOUNT/A20* $MODCOUNT/*.zip


git_clone https://KhaineUK@dev.azure.com/KhaineUK/KhaineV1XMLModlets/_git/KhaineV1XMLModlets
rm -rf $MODCOUNT/KHV1-12* $MODCOUNT/KHV1-60* $MODCOUNT/KHV1-96* $MODCOUNT/KHV1-A* $MODCOUNT/KHV1-F* $MODCOUNT/KHV1-Head* $MODCOUNT/KHV1-Lock* $MODCOUNT/KHV1-Pickup* $MODCOUNT/KHV1-Remove* $MODCOUNT/KHV1-S* $MODCOUNT/KHV1-T* $MODCOUNT/KHV1-Z*
git_clone https://gitlab.com/karlgiesing/7d2d-1.0-mods.git
mkdir $MODCOUNT/KEEP; mv $MODCOUNT/khzmusik_Trader_Lore $MODCOUNT/KEEP; rm -rf $MODCOUNT/khz*;
mv $MODCOUNT/KEEP/* $MODCOUNT/; rm -rf $MODCOUNT/KEEP
git_clone https://github.com/FilUnderscore/ImprovedHordes.git
rm -rf $MODCOUNT/.git* $MODCOUNT/A* $MODCOUNT/S* $MODCOUNT/J* $MODCOUNT/L* $MODCOUNT/s*