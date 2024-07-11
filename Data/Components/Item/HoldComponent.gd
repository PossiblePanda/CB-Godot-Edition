class_name HoldComponent
extends ItemComponent

static func interact(item: Item):
	if Global.game.player.held_item != null:
		Global.game.player.held_item = null
		return
	Global.game.player.held_item = item
	Global.game.toggle_inventory()
