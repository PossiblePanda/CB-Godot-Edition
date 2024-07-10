extends TextureRect

const MAIN_MENU = "res://Scenes/Menus/MainMenu.tscn"

@onready var game = $"../.."
@onready var buttons = $Buttons

func _ready():
	connect_buttons()
	
func connect_buttons():
	for button in buttons.get_children():
		button.pressed.connect(_on_button_pressed.bind(button))

func _on_button_pressed(button: Button):
	match button.name:
		"Resume":
			game.toggle_pause()
		"Quit":
			get_tree().paused = false
			get_tree().change_scene_to_file(MAIN_MENU)
