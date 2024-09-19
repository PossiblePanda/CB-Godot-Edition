class_name BaseConfig
extends Label

@export var setting : String = ""

func _ready() -> void:
	text = Config.data[setting].string
