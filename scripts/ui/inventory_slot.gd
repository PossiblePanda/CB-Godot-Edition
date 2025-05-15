class_name InventorySlot
extends Control

@onready var item_texture : TextureRect = $ItemTexture
@onready var hover_outline = $HoverOutline
@onready var tooltip = $Tooltip

var hovered: bool = false
var held: bool = false

@export var item: Item = null:
	set(val):
		if val != null:
			item_texture.texture = val.image
			tooltip.text = val.item_name
		else:
			item_texture.texture = null
			tooltip.text = ""
			tooltip.hide()
		item = val

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)


func _process(_delta: float) -> void:
	if held:
		item_texture.top_level = true
		item_texture.position = get_global_mouse_position() + Vector2(3,3)
	else:
		item_texture.top_level = false
		item_texture.position = Vector2(3,3)

func _input(event):
	if event is InputEventMouseButton:
		if event.double_click:
			if item == null:
				return
			if not hovered:
				return
			
			for component in item.components:
				component.equip(item)
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and hovered and held == false and not Global.game.player.inventory.held_item:
			Global.game.player.inventory.held_item = self
			held = true
	if Input.is_action_just_released("drag_item"):
		held = false
		
		if Global.game.player.inventory.held_item != self:
			return
		
		Global.game.player.inventory.held_item = null
		
		if Global.game.player.inventory.hovered_slot == null:
			if not item:
				return
			var inventory_component : InventoryComponent = Global.game.player.get_meta("InventoryComponent")
			inventory_component.drop_item(item)
		elif Global.game.player.inventory.hovered_slot != self:
			if not item:
				return
			var inventory_component : InventoryComponent = Global.game.player.get_meta("InventoryComponent")
			var move_to = Global.game.player.inventory.hovered_slot
			inventory_component.move_item(item,Global.game.player.inventory.inventory_slots.find(move_to))


func _on_mouse_entered():
	hover_outline.show()
	tooltip.show()
	
	Global.game.player.inventory.hovered_slot = self
	hovered = true


func _on_mouse_exited():
	hover_outline.hide()
	tooltip.hide()
	
	Global.game.player.inventory.hovered_slot = null
	hovered = false
