class_name InventoryComponent
extends BaseComponent

signal item_added(item : Item)
signal item_removed(item : Item)
signal slot_count_changed

const INVENTORY_SLOT = preload("res://scenes/ui/inventory_slot.tscn")
const DROPPED_ITEM = preload("res://scenes/game/dropped_item.tscn")

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
		assert(item, "Unknown item.")
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
	item.duplicate(true)
	
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


func remove_item_index(index: int) -> void:
	print(index)
	items[index] = null


func drop_item(item) -> void:
	remove_item(item)
	var dropped_item = DROPPED_ITEM.instantiate()
	Global.game.add_child(dropped_item)
	
	dropped_item.position = Global.player.position
	dropped_item.position.y = dropped_item.position.y + dropped_item.collision_shape.shape.size.y / 2
	dropped_item.item = item


func move_item(item : Item,to : int) -> void:
	if to > slot_count + 1:
		return
	var old_location = items.find(item)
	if old_location == -1:
		return
	items[old_location] = null
	if items[to]:
		var item2 = items[to]
		items[old_location] = item2
	
	items[to] = item
	item_added.emit(item)
