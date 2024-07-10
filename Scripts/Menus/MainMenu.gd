extends Control

const GAME = "res://Scenes/Game/Game.tscn"

@onready var buttons = $Buttons

func _ready():
	connect_buttons()
	
func connect_buttons():
	for button in buttons.get_children():
		button.pressed.connect(_on_button_pressed.bind(button))

func _on_button_pressed(button: Button):
	match button.name:
		"QuitButton":
			get_tree().quit()
		"NewGameButton":
			get_tree().change_scene_to_file(GAME)
