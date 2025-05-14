class_name Item
extends Resource

@export var image: CompressedTexture2D
@export var item_name: String = "Name"
@export var components: Array[BaseItemComponent] = []

func has_component(name: String) -> bool:
	for component in components:
		if component.get_component_name() == name:
			return true
	
	return false

func get_component(name: String) -> BaseItemComponent:
	assert(has_component(name), "Item does not have component %s" % name)
	
	for component in components:
		if component.get_component_name() == name:
			return component
	
	return
