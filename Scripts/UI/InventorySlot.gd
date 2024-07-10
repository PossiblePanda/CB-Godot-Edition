class_name InventorySlot
extends Control

@onready var hover_outline = $HoverOutline

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	hover_outline.show()

func _on_mouse_exited():
	hover_outline.hide()
