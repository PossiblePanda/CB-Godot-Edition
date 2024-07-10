class_name InventorySlot
extends Control

@onready var item_texture = $ItemTexture
@onready var hover_outline = $HoverOutline
@onready var tooltip = $Tooltip

@export var item: Item = null:
	set(val):
		if val != null:
			item_texture.texture = val.image
			tooltip.text = val.item_name
		else:
			print("Nah.")
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

func _on_mouse_exited():
	hover_outline.hide()
	tooltip.hide()
