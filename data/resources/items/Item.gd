class_name Item
extends Resource

@export var image: CompressedTexture2D
@export var item_name: String = "Name"
@export var component_names: Array[String] = []

var components: Array = []: 
	get:
		components = []
		
		for component_name in component_names:
			var component = ItemManager.components[component_name]
			
			components.append(component)
		
		return components
