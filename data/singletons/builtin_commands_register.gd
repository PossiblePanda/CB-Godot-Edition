extends Node

func _ready() -> void:
	LimboConsole.register_command(give_command, "give", "gives the player an item")
	LimboConsole.add_argument_autocomplete_source("give", 0, give_autocomplete_0)
	
	LimboConsole.register_command(speed_command, "speed", "sets the player's speed")
	
	LimboConsole.register_command(inventory_slots_command, "inventory_slots", "set the player's amount of inventory slots")

func give_command(item: String):
	if not Global.ingame:
		LimboConsole.error("Player is not in-game")
		return
	
	var split = item.split(":")
	if len(split) < 2:
		LimboConsole.error("Must provide namespace and item name in the format {namespace}:{item name}")
		return
		
	var item_namespace = split[0]
	var item_id = split[1]
	
	print(Register.get_registry())
	
	var item_res: Item = Register.get_item(item_id, item_namespace)
	
	if not item_res:
		LimboConsole.error("Unknown Item: %s" % item)
		return
	
	var inventory_component: InventoryComponent = Global.game.player.get_meta("InventoryComponent")
	inventory_component.add_item(item_res)

	LimboConsole.info("Given item %s to the player." % item_res.item_name)

func give_autocomplete_0():
	var item_names: Array[String] = []
	
	for namespace_name in Register.get_registry().keys():
		var new_items: Dictionary = Register.get_registry()[namespace_name]["items"]
		
		for item: Item in new_items.values():
			item_names.append("%s:%s" % [namespace_name, item.id])
		
	return item_names

func speed_command(speed: float = 3):
	if not Global.ingame:
		LimboConsole.error("Player is not in-game")
		return
		
	Global.game.player.speed = speed
	
	LimboConsole.info("Set the player's speed to %s" % speed)
	
func inventory_slots_command(slot_count: int = 10):
	if not Global.ingame:
		LimboConsole.error("Player is not in-game")
		return
	
	var inventory_component: InventoryComponent = Global.game.player.get_meta("InventoryComponent")
	
	inventory_component.slot_count = slot_count
	
	LimboConsole.info("Set the player's inventory slot count to %s" % slot_count)
