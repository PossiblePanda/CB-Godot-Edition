extends Node

var items: Array[Item] = []

const ITEM_DIR = "res://Data/Resources/Items/"

func _ready():
	register_item_dir()

func register_item(item: Item):
	items.append(item)

func get_items_in_dir(path: String):
	var dir_access: DirAccess = DirAccess.open(path)
	var items: Array[Item] = []
	
	for file in dir_access.get_files():
		if file.ends_with(".tres"):
			var item: Item = ResourceLoader.load(path+file)
			items.append(item)
	return items

func register_hints(arr: Array[Item]):
	for item in arr:
		register_item(item)

func register_item_dir(path: String = ITEM_DIR):
	var items = get_items_in_dir(path)
	
	register_hints(items)
