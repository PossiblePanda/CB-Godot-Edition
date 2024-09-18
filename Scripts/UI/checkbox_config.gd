extends Label

@onready var button: Button = $Button
@onready var check: Sprite2D = $Button/White/Check

@export var setting : String = ""

func _ready() -> void:
	check.visible = Config.data[setting].val
	text = Config.data[setting].string

func _on_button_pressed() -> void:
	Config.data[setting].val = not Config.data[setting].val
	check.visible = Config.data[setting].val
