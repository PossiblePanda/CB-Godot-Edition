class_name Game
extends Node3D

@onready var blink_bar: Bar = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/BlinkBar
@onready var sprint_bar: Bar = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer2/SprintBar

@onready var blink_color: ColorRect = $CanvasLayer/Blink

@onready var pause_menu: TextureRect = $CanvasLayer/PauseMenu
@onready var options_ui: Control = $CanvasLayer/PauseMenu/OptionsUI
@onready var inventory: Inventory = $CanvasLayer/Inventory

@onready var player: Player = $Player

func _init():
	Global.game = self
	Global.game_entered.emit()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
	elif Input.is_action_just_pressed("inventory"):
		toggle_inventory()

func toggle_inventory():
	var vis = inventory.visible
	if pause_menu.visible:
		return
		
	inventory.visible = not vis
	get_tree().paused = not vis
	
	Input.mouse_mode = 2*int(vis)
	if vis == false:
		player.held_item = null
		player.current_document = null

func toggle_pause():
	var vis = pause_menu.visible
	
	if inventory.visible:
		inventory.visible = false
		
	pause_menu.visible = not vis
	get_tree().paused = not vis
	options_ui.visible = false
	
	Input.mouse_mode = 2*int(vis)
