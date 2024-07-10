class_name Inventory
extends HFlowContainer

@export var items: Array[Item] = []
@export var inventory_slots: Array[InventorySlot] = []

const INVENTORY_SLOT = preload("res://Scenes/UI/InventorySlot.tscn")

@export var slot_count: int:
	set(val):
		slot_count = val
		update_slot_count()

func _ready():
	slot_count = 10
	
	add_item(ItemManager.items[0])

func add_item(item: Item) -> bool:
	var itemslen = len(items)
	if itemslen < slot_count:
		items.append(item)
		inventory_slots[itemslen].item = item
		
	return false

func update_slot_count():
	var curr_slot_count: int = 0
	for slot in get_children():
		if slot is InventorySlot:
			curr_slot_count += 1
	
	for i in range(curr_slot_count, slot_count):
		var slot = INVENTORY_SLOT.instantiate()
		
		inventory_slots.append(slot)
		
		add_child(slot)
