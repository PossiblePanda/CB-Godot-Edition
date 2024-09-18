class_name Inventory
extends HFlowContainer

const INVENTORY_SLOT = preload("res://Scenes/UI/InventorySlot.tscn")

var hovered_slot: InventorySlot

@export var items: Array[Item] = []:
	set(val):
		for item in val:
			inventory_slots[len(val)].item = item
		items = val
@export var inventory_slots: Array[InventorySlot] = []

@export var slot_count: int = 10:
	set(val):
		slot_count = val
		update_slot_count()

func _ready():
	slot_count = 10
	
	for item in ItemManager.items:
		add_item(item)

func add_item(item: Item) -> bool:
	var itemslen = len(items)
	if not item:
		return false
	if itemslen < slot_count:
		items.append(item)
		inventory_slots[itemslen].item = item
		
	return false

func remove_item(item: Item):
	remove_item_index(items.find(item))

func remove_item_index(index: int):
	items.remove_at(index)
	inventory_slots[index].item = null

func update_slot_count():
	var curr_slot_count: int = 0
	for slot in get_children():
		if slot is InventorySlot:
			curr_slot_count += 1
	
	for i in range(curr_slot_count, slot_count):
		var slot = INVENTORY_SLOT.instantiate()
		
		inventory_slots.append(slot)
		
		add_child(slot)
