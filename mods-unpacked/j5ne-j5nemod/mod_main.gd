extends Node

const AUTHORNAME_MODNAME_LOG_NAME := "j5ne-j5nemod:Main"
const AUTHORNAME_MODNAME_DIR:= "j5ne-j5nemod"

var mod_dir_path

func _ready() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir() + AUTHORNAME_MODNAME_DIR + "/"
	
	ModLoaderLog.info(mod_dir_path, AUTHORNAME_MODNAME_LOG_NAME)
	
	ItemManager.register_item_dir(mod_dir_path+"items"+"/")
	ItemManager.register_component_dir(mod_dir_path+"components/item/")
