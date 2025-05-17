extends Node

func _ready() -> void:
	LimboConsole.register_command(give_command, "give", "Gives the player an item.")
	LimboConsole.add_argument_autocomplete_source("give", 0, give_autocomplete_0)

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
