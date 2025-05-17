extends Node

const MAIN_NAMESPACE = "cbge"

# Private Variables / Functions
var _registry_template: Dictionary[String, Dictionary] = { # not a constant to allow mod makers to add new keys during runtime
	"items": {}
}

var _registry: Dictionary[String, Dictionary] = {
	MAIN_NAMESPACE: _registry_template
}

func _load_all_resources(folder: String) -> Array[Resource]:
	var res: Array[Resource] = []
	for file in DirAccess.get_files_at(folder):
		var path = folder + "/" + file
		var r = load(path)
		if r is Resource:
			res.append(r)
	return res

# Public Variables / Functions
func add_to_registry(namespace_name: String, key: String, id: String, value: Variant, overwrite: bool = false):
	if not _registry.has(namespace_name): 
		push_error("Namespace not found with name %s" % namespace_name)
		return
	
	if not _registry[namespace_name].has(key): 
		push_error("Namespace %s does not have a key with the name %s" % [namespace_name, key])
		return
	
	if _registry[namespace_name][key].has(id) and not overwrite:
		push_warning("Namespace %s with the key %s already contains a value with the ID %s. Use the overwrite parameter to overwrite this." % [namespace_name, key, id])
		return
		
	_registry[namespace_name][key][id] = value

func get_from_registry(namespace_name: String, key: String, id: String) -> Variant:
	if not _registry.has(namespace_name): 
		push_error("Namespace not found with name %s" % namespace_name)
		return
	
	if not _registry[namespace_name].has(key): 
		push_error("Namespace %s does not have a key with the name %s" % [namespace_name, key])
		return
	
	if not _registry[namespace_name][key].has(id):
		push_error("Namespace %s with the key %s does not contain a value with the ID %s" % [namespace_name, key, id])
		return
	
	return _registry[namespace_name][key][id]

func get_all_from_registry(namespace_name: String, key: String) -> Array[Item]:
	if not _registry.has(namespace_name): 
		push_error("Namespace not found with name %s" % namespace_name)
		return []
	
	if not _registry[namespace_name].has(key): 
		push_error("Namespace %s does not have a key with the name %s" % [namespace_name, key])
		return []
	
	return _registry[namespace_name][key]

func register_item(namespace_name: String, item: Item, overwrite: bool = false):
	add_to_registry(namespace_name, "items", item.id, item, overwrite)

func register_item_resources(namespace_name: String, path: String, overwrite: bool = false):
	var all_resources = _load_all_resources(path)

	for res in all_resources:
		if res is Item:
			add_to_registry(namespace_name, "items", res.id, res, overwrite)

func get_item(id: String, namespace_name: String = MAIN_NAMESPACE) -> Item:
	return get_from_registry(namespace_name, "items", id)

func get_all_items_namespace(namespace_name: String = MAIN_NAMESPACE) -> Array[Item]:
	return get_all_from_registry(namespace_name, "items")

func get_all_items() -> Array[Item]:
	var items: Array[Item] = []
	
	for namespace_name in get_registry().keys():
		var new_items: Dictionary = get_registry()[namespace_name]["items"]
		
		items.append_array(new_items.values())
		
	return items

func get_registry() -> Dictionary[String, Dictionary]:
	return _registry

func _ready() -> void:
	register_item_resources(MAIN_NAMESPACE, "res://data/resources/items")
