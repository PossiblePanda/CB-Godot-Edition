class_name Item
extends Resource

@export var image: CompressedTexture2D
@export var item_name: String = "Name"
@export var component_names: Array[String] = []

func get_components() -> Array:
	var components: Array = []
	
	for component_name in component_names:
		var component = ItemManager.get_component(component_name)
		components.append(component)
	return components
