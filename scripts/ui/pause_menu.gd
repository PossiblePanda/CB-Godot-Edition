extends TextureRect

const MAIN_MENU = "res://scenes/menus/main_menu.tscn"

@onready var game = $"../../.."
@onready var buttons = $Buttons
@onready var options: Control = $Options

func _ready():
	connect_buttons()
	
func connect_buttons():
	for button in buttons.get_children():
		button.pressed.connect(_on_button_pressed.bind(button))

func _on_button_pressed(button: Button):
	match button.name:
		"Resume":
			game.toggle_pause()
			options.visible = false
		"Quit":
			get_tree().paused = false
			get_tree().change_scene_to_file(MAIN_MENU)
		"Options":
			options.visible = true
			buttons.visible = false
