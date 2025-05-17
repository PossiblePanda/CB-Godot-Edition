extends Node

var items: Array[Item] = []
var components: Dictionary = {}

const ITEM_DIR = "res://data/resources/items/"
const COMPONENT_DIR = "res://data/components/item/"

func _ready():
	register_item_dir()
	register_components()
	
	#register_item_component("document", "res://Data/Components/Item/DocumentComponent.gd")
	#register_item_component("can_hold", "res://Data/Components/Item/HoldComponent.gd")

func register_item(item: Item):
	items.append(item)

func register_component(path: String, file: String):
	if file.ends_with(".gd"):
		components[file.replace(".gd","")] = load(path+file)

func register_component_dir(path: String):
	var dir_access: DirAccess = DirAccess.open(path)
	
	for file in dir_access.get_files():
		register_component(path, file)

func register_components():
	register_component_dir(COMPONENT_DIR)

func get_items_in_dir(path: String):
	var dir_access: DirAccess = DirAccess.open(path)
	var dir_items: Array[Item] = []
	
	for file in dir_access.get_files():
		if file.ends_with(".tres"):
			var item: Item = ResourceLoader.load(path+file)
			items.append(item)
	return dir_items

func get_item_by_name(item_name: String) -> Item:
	for item in items:
		if item.item_name.to_lower() == item_name.to_lower():
			return item
	
	return

func register_hints(arr: Array[Item]):
	for item in arr:
		register_item(item)

func register_item_dir(path: String = ITEM_DIR):
	var dir_items = get_items_in_dir(path)
	
	for i in dir_items:
		print(i)
		#print(item.item_name)
	
	register_hints(dir_items)
