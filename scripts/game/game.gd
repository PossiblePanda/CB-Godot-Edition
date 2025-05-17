class_name Game
extends Node3D

@onready var player: Player = $Player

func _init():
	Global.game = self
	Global.ingame = true
	Global.game_entered.emit()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
	elif Input.is_action_just_pressed("inventory"):
		toggle_inventory()

func toggle_inventory():
	var vis = Global.player.inventory.visible
	if Global.player.pause_menu.visible:
		return
		
	Global.player.inventory.visible = not vis
	get_tree().paused = not vis
	
	Input.mouse_mode = 2 * int(vis) as Input.MouseMode
	if vis == false:
		player.held_item = null
		player.current_document = null

func toggle_pause():
	var vis = Global.player.pause_menu.visible
	
	if Global.player.inventory.visible:
		Global.player.inventory.visible = false
		
	Global.player.pause_menu.visible = not vis
	get_tree().paused = not vis
	Global.player.options.visible = false
	
	
	Input.mouse_mode = 2*int(vis) as Input.MouseMode
