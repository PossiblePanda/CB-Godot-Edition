class_name UnequipOnInteractComponent
extends BaseItemComponent

func interact(_item: Item):
	if Global.game.player.held_item != null:
		Global.game.player.held_item = null
