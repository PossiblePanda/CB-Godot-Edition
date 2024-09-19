class_name DocumentComponent
extends ItemComponent

static func equip(item: Item):
	if item is not DocumentItem:
		push_error("Item has document component but isn't a DocumentItem!")
		
	if Global.game.player.current_document != null:
		Global.game.player.current_document = null
		return
	Global.game.player.current_document = item
	Global.game.toggle_inventory()
