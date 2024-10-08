class_name InventorySlot
extends Control

@onready var item_texture = $ItemTexture
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

func _on_mouse_entered():
	hover_outline.show()
	tooltip.show()
	
	Global.game.player.inventory.hovered_slot = self
	
	hovered = true

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
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and hovered:
			held = true
	if Input.is_action_just_released("drag_item"):
		held = false

func _on_mouse_exited():
	hover_outline.hide()
	tooltip.hide()
	
	Global.game.player.inventory.hovered_slot = null
	
	hovered = false
