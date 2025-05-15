class_name InventoryComponent
extends BaseComponent

signal item_added(item : Item)
signal item_removed(item : Item)
signal slot_count_changed

const INVENTORY_SLOT = preload("res://scenes/ui/inventory_slot.tscn")

@export var items: Array[Item] = []:
	set(val):
		items = val
@export var slot_count: int = 10:
	set(val):
		slot_count = val
		items.resize(val)
		slot_count_changed.emit()

func _ready():
	super()
	_setup.call_deferred()


func _setup() -> void:
	slot_count = slot_count # update setter
	
	for item in ItemManager.items:
		add_item(item)


func get_amount_of_items() -> int:
	var count = 0
	for item in items:
		if item:
			count += 1
	return count


func get_empty_slot() -> int:
	for index in len(items):
		if items[index] == null:
			return index
	return -1


func add_item(item: Item) -> bool:
	if not item:
		return false
	if get_amount_of_items() < slot_count:
		var pos = get_empty_slot()
		if pos == -1:
			return false
		items[pos] = item
		item_added.emit(item)
		
	return false

func remove_item(item: Item) -> void:
	remove_item_index(items.find(item))
	item_removed.emit(item)


func drop_item() -> void:
	pass


func remove_item_index(index: int) -> void:
	items.remove_at(index)
