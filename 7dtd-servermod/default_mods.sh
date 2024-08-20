function remap () {
cd /data/7DTD/Mods
rm -rf "$1"
echo "Setting Default for $1"
ln -s "`find $INSTALL_DIR/Mods-Available -name \"ModInfo.xml\" | sed 's|/ModInfo.xml||g' | grep "$1" | tail -1`"
cd /data/7DTD
}

cd $INSTALL_DIR/Mods

remap Allocs_CommandExtensions
remap Allocs_CommonFunc
remap Allocs_WebAndMapRendering
remap 1CSMM_Patrons
remap ServerTools
remap Origin_UI
remap 60Slot_Bag_30Reserve
remap 7DTD-8CraftQueue
remap 7DTD-FasterCrafting
remap Faster_Bellows
remap Pickup_Plants
remap 7DTD-SewingKit
remap 7DTD-Acid
remap WhiteRiverToC__REQUIRED
remap WhiteRiverToC_Tazas_Axe
remap WhiteRiverToC_Spirit
remap WhiteRiverToC_Rick
remap WhiteRiverToC_Remington
remap WhiteRiverToC_Pavlichenko
remap WhiteRiverToC_Molino
remap WhiteRiverToC_Leon
remap WhiteRiverToC_Kuva
remap WhiteRiverToC_Jason
remap WhiteRiverToC_Gupta
remap WhiteRiverToC_Everdeen
remap WhiteRiverToC_Dundee
remap WhiteRiverToC_Daryl
remap WhiteRiverToC_Deschain
remap WhiteRiverToC_Callinicus
remap WhiteRiverToC_Bunyan
remap WhiteRiverToC_Brass
remap WhiteRiverToC_BlackBart
remap WhiteRiverToC_Bear
remap WhiteRiverToC_Bambi
remap WhiteRiverToC_Amelia
remap Death_by_Campfire
remap Delmod_Stack_Sizes
remap DrPrepper
remap Frobscottle
remap Headshot_15
remap KHV1-HPBars
remap 7DTD-MeatRendering
remap 7DTD-Quenchiest_Cactus_Juice
remap 7DTD-ServerRules
remap Terrain_Based_Movement_Speed
remap Trader_Refresh_1Day
remap ZLoot_Increase
remap Xal_SetZombiesAttackAnimals
remap Zombiepedia_Skillpoints
remap Vanilla_Expanded_Storage
#remap 7DTD-SteelTrussingSheet
remap KHV1-LogSpikes
