class_name DocumentComponent
extends BaseItemComponent

@export var document_image: CompressedTexture2D

static func equip(item: Item):
	if not item.has_component("DocumentComponent"):
		push_error("Item has document component but isn't a DocumentItem!")
		
	if Global.game.player.current_document != null:
		Global.game.player.current_document = null
		return
		
	Global.game.player.current_document = item
	Global.game.toggle_inventory()

func get_component_name() -> String:
	return "DocumentComponent"
