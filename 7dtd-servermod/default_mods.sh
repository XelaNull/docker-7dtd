function remap () {
rm -rf "$1"
echo "Setting Default for $1"
ln -s "`find $INSTALL_DIR/Mods-Available -name \"ModInfo.xml\" | sed 's|/ModInfo.xml||g' | grep "$1" | tail -1`"
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
