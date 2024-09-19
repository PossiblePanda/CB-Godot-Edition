extends Node

const AUTHORNAME_MODNAME_LOG_NAME := "j5ne-j5nemod:Main"
const AUTHORNAME_MODNAME_DIR:= "j5ne-j5nemod"

static var mod_dir_path

static func _static_init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir() + AUTHORNAME_MODNAME_DIR + "/"

static func equip(item: Item):
	pass

static func interact(item: Item):
	print("Gasa")
	var scene: PackedScene = load(mod_dir_path+"scenes/Part.tscn")
	var node: Node3D = scene.instantiate()
	
	Global.game.add_child(node)
	
	node.position = Global.game.player.position + Vector3(0,0.5,0)
