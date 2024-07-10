extends Node3D

@onready var blink_bar: Bar = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/BlinkBar
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var inventory_menu = $CanvasLayer/Inventory

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
	elif Input.is_action_just_pressed("inventory"):
		toggle_inventory()

func toggle_inventory():
	var vis = inventory_menu.visible
	if pause_menu.visible:
		return
		
	inventory_menu.visible = not vis
	get_tree().paused = not vis
	
	Input.mouse_mode = 2*int(vis)

func toggle_pause():
	var vis = pause_menu.visible
	
	if inventory_menu.visible:
		inventory_menu.visible = false
		
	pause_menu.visible = not vis
	get_tree().paused = not vis
	
	Input.mouse_mode = 2*int(vis)
