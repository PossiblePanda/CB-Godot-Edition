class_name DocumentItem
extends Item

@export var document_image: CompressedTexture2D

func get_components() -> Array:
	var components: Array = []
	
	for component_name in component_names:
		var component = ItemManager.get_component(component_name)
		components.append(component)
	return components
