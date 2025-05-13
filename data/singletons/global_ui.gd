extends CanvasLayer

const GLOBAL_UI = preload("res://scenes/ui/global_ui.tscn")

func _ready() -> void:
	var ui = GLOBAL_UI.instantiate()
	var godot_version: Label = ui.get_node("MarginContainer/VBoxContainer/GodotVersion")
	var game_name: Label = ui.get_node("MarginContainer/VBoxContainer/GameName")
	
	var version_info = Engine.get_version_info()
	
	add_child(ui)
	
	godot_version.text = "Godot v%d.%d.%d-%s (%s)" % [version_info.major, version_info.minor, version_info.patch, version_info.status, version_info.build]
	game_name.text = "Containment Breach: Godot Edition | %s" % Global.GAME_VERSION
