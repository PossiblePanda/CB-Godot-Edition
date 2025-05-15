class_name BaseItemComponent
extends Resource

func added(_item: Item):
	pass

func removed(_item: Item):
	pass

func equip(_item: Item):
	pass

func interact(_item: Item):
	pass

func drop(_item: Item):
	pass

func get_component_name() -> String:
	return "BaseItemComponent"
