extends Control

const GAME = "res://Scenes/Game/Game.tscn"

var logo_hovered: bool = false

@onready var credits_menu = $CreditsMenu
@onready var logo = $MarginContainer/Control/Logo
@onready var buttons: VBoxContainer = $Buttons
@onready var options_ui: Control = $OptionsUI

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
		"OptionsButton":
			options_ui.visible = true
			buttons.visible = false
			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			if logo_hovered:
				credits_menu.visible = not credits_menu.visible

func _on_logo_mouse_entered():
	logo_hovered = true
	
	create_tween()\
			.tween_property(logo, "scale", Vector2(1.05,1.05),0.2)\
			.set_trans(Tween.TRANS_SINE)


func _on_logo_mouse_exited():
	logo_hovered = false
	
	create_tween()\
			.tween_property(logo, "scale", Vector2(1.0,1.0),0.2)\
			.set_trans(Tween.TRANS_SINE)
