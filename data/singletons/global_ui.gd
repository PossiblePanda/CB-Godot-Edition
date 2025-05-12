extends CanvasLayer

const GLOBAL_UI = preload("res://scenes/ui/global_ui.tscn")

func _ready() -> void:
	add_child(GLOBAL_UI.instantiate())
