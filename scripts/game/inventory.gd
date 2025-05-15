class_name Inventory
extends HFlowContainer

const INVENTORY_SLOT = preload("res://scenes/ui/inventory_slot.tscn")

@export var inventory_slots: Array[InventorySlot] = []

var hovered_slot: InventorySlot

@onready var inventory_component : InventoryComponent = Global.player.get_meta("InventoryComponent")

func _ready() -> void:
	print(inventory_component)


func _on_items_changed(_item) -> void:
	print("Item")
	for index in len(inventory_component.items):
		print(index)
		inventory_slots[index].item = inventory_component.items[index]


func _update_slot_count():
	var curr_slot_count: int = 0
	for slot in get_children():
		if slot is InventorySlot:
			curr_slot_count += 1
	
	for i in range(curr_slot_count, inventory_component.slot_count):
		var slot = INVENTORY_SLOT.instantiate()
		
		inventory_slots.append(slot)
		
		add_child(slot)


func _on_inventory_component_slot_count_changed() -> void:
	_update_slot_count()
