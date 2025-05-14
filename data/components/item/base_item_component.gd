class_name BaseItemComponent
extends Resource

static func added(_item: Item):
	pass

static func removed(_item: Item):
	pass

static func equip(_item: Item):
	pass

static func interact(_item: Item):
	pass

static func drop(_item: Item):
	pass

func get_component_name() -> String:
	return "BaseItemComponent"
