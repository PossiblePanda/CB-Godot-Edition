class_name UnequipOnInteractComponent
extends ItemComponent

static func interact(item: Item):
	if Global.game.player.held_item != null:
		Global.game.player.held_item = null
