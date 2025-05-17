extends Node

func _ready() -> void:
	LimboConsole.register_command(give_command, "give", "Gives the player an item.")

func give_command(item_name: String):
	if not Global.ingame:
		LimboConsole.error("Player is not in-game")
		return
	
	var item: Item = ItemManager.get_item_by_name(item_name)
	
	if not item:
		LimboConsole.error("Unknown Item: %s" % item_name)
		return
	
	var inventory_component: InventoryComponent = Global.game.player.get_meta("InventoryComponent")
	inventory_component.add_item(item)

	LimboConsole.info("Given item %s to the player." % item_name)
