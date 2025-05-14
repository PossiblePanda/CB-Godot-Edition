class_name HoldComponent
extends BaseItemComponent

static func equip(item: Item):
	if Global.game.player.held_item:
		Global.game.player.held_item = null
		return
		
	Global.game.player.held_item = item
	Global.game.toggle_inventory()
