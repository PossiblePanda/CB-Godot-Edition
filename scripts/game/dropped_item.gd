class_name DroppedItem
extends RigidBody3D

@export var item : Item : 
	set(val):
		item = val
		_update_enabled()

func _ready() -> void:
	_update_enabled()


func _update_enabled() -> void:
	if item == null:
		freeze = true
		visible = false
		$InteractionPrompt.interactable = false
	else:
		freeze = false
		visible = true
		$InteractionPrompt.interactable = true


func _on_interaction_prompt_triggered() -> void:
	var inventory : Inventory = Global.player.get_node("CanvasLayer/InventoryCenterContainer/Inventory")
	inventory.add_item(item)
	item = null
