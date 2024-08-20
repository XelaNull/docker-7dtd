#!/bin/bash
. install_mods.func.sh

# Last Updated: 2024-08-11
# For 1.0

wget_download "https://illy.bz/fi/7dtd/server_fixes.tar.gz" server_fixes.tgz
cd $MODCOUNT; tar zxvf server_fixes.tgz; cd ..
git_clone https://github.com/Prisma501/Allocs-Webmap-for-CPM.git
mv $MODCOUNT/Allocs-Webmap-for-CPM/map.js $MODS_DIR/1/Mods/Allocs_WebAndMapRendering/webserver_legacy/js

git_clone https://github.com/Prisma501/CSMM-Patrons-Mod.git

wget_download "https://bitbucket.org/obsessive-coder/sevendaystodie-servertools/downloads/7dtd-ServerTools-G1.0.1.8.zip" ServerTools.zip extract_file # ServerTools

#wget_download "https://github.com/XelaNull/7DTD-Neopolitan/releases/download/A19.3_1.0d/2021-06-03_215241-Modlet_Collection-Shouden.zip" Neopolitan.zip extract_file

git_clone https://github.com/XelaNull/7DTD-WhiteRiver_ToC.git
git_clone https://github.com/XelaNull/7dtd-Origin-UI.git
git_clone https://github.com/XelaNull/7DTD-ShoudensModlets.git
git_clone https://github.com/XelaNull/7dtd-FixedModlets.git
git_clone https://github.com/XelaNull/7DTD-Bag_Bellows_Headshot.git
rm -rf $MODCOUNT/7DTD-Bag_Bellows_Headshot/Headshot_25*
git_clone https://github.com/XelaNull/7DTD-Zombiepedia_Skillpoints.git
git_clone https://github.com/XelaNull/7DTD-ZombieLootbag_Increase.git
git_clone https://github.com/XelaNull/7DTD-Magazine_Plants_Trader.git
git_clone https://github.com/XelaNull/7DTD-DarkerNights_BrighterLights.git
git_clone https://github.com/XelaNull/7DTD-SalvagedElectronics.git
git_clone https://github.com/XelaNull/7DTD-SanitysEdgeRules.git
git_clone https://github.com/XelaNull/7DTD-Skillbook_Skillpoints.git
rm -rf $MODCOUNT/7DTD-Skillbook_Skillpoints/All* $MODCOUNT/7DTD-Skillbook_Skillpoints/Most*

git_clone https://github.com/DonovanMods/donovan-7d2d-modlets.git
mv $MODCOUNT/donovan-7d2d-modlets/modlets/donovan-more* $MODCOUNT/donovan-7d2d-modlets/modlets/donovan-night* $MODCOUNT/donovan-7d2d-modlets/modlets/a-la-carte/donovan-betterbridges $MODCOUNT/donovan-7d2d-modlets/modlets/a-la-carte/donovan-betterbuffs $MODCOUNT/donovan-7d2d-modlets/modlets/a-la-carte/donovan-betterdyes $MODCOUNT/donovan-7d2d-modlets/modlets/a-la-carte/donovan-bettertraps $MODCOUNT/donovan-7d2d-modlets/modlets/a-la-carte/donovan-pickmeup $MODCOUNT/
rm -rf $MODCOUNT/donovan-7d2d-modlets
git_clone https://github.com/saminal1/samsmodsv1.0.git
rm -rf $MODCOUNT/samsmodsv1.0/SA* $MODCOUNT/samsmodsv1.0/SC* $MODCOUNT/samsmodsv1.0/SK* $MODCOUNT/samsmodsv1.0/SL* $MODCOUNT/samsmodsv1.0/SN* $MODCOUNT/samsmodsv1.0/SO* $MODCOUNT/samsmodsv1.0/SS* $MODCOUNT/samsmodsv1.0/SWorkingStuff
git_clone https://github.com/doughphunghus/7D2D-Doughs-Mods-a21.git
mv $MODCOUNT/7D2D-Doughs-Mods-a21/Doughs-Weather* $MODCOUNT/7D2D-Doughs-Mods-a21/Doughs-Lights* $MODCOUNT/7D2D-Doughs-Mods-a21/Doughs-Food-SousChefOfTheApocalypse $MODCOUNT/7D2D-Doughs-Mods-a21/Doughs-Ambiance-DarkNights $MODCOUNT/7D2D-Doughs-Mods-a21/Doughs-Ambiance-DarkIndoors $MODCOUNT/;
rm -rf $MODCOUNT/7*
git_clone https://github.com/JoeSloeMoe/LBU.git
git_clone https://github.com/arramus/A21-BushcraftBites.git
rm -rf $MODCOUNT/A20* $MODCOUNT/*.zip


git_clone https://KhaineUK@dev.azure.com/KhaineUK/KhaineV1XMLModlets/_git/KhaineV1XMLModlets
rm -rf $MODCOUNT/KhaineV1XMLModlets/KHV1-12* $MODCOUNT/KhaineV1XMLModlets/KHV1-60* $MODCOUNT/KhaineV1XMLModlets/KHV1-96* $MODCOUNT/KhaineV1XMLModlets/KHV1-A* $MODCOUNT/KhaineV1XMLModlets/KHV1-F* $MODCOUNT/KhaineV1XMLModlets/KHV1-Head* $MODCOUNT/KhaineV1XMLModlets/KHV1-Lock* $MODCOUNT/KhaineV1XMLModlets/KHV1-Pickup* $MODCOUNT/KhaineV1XMLModlets/KHV1-Remove* $MODCOUNT/KhaineV1XMLModlets/KHV1-S* $MODCOUNT/KhaineV1XMLModlets/KHV1-T* $MODCOUNT/KhaineV1XMLModlets/KHV1-Z*
git_clone https://gitlab.com/karlgiesing/7d2d-1.0-mods.git
mv $MODCOUNT/7d2d-1.0-mods/khzmusik_Trader_Lore $MODCOUNT/; rm -rf $MODCOUNT/7d2d-1.0-mods;
git_clone https://github.com/FilUnderscore/ImprovedHordes.git
rm -rf $MODCOUNT/ImprovedHordes/.git* $MODCOUNT/ImprovedHordes/A* $MODCOUNT/ImprovedHordes/S* $MODCOUNT/ImprovedHordes/J* $MODCOUNT/ImprovedHordes/L* $MODCOUNT/ImprovedHordes/s*