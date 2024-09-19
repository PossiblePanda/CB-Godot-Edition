class_name Door
extends Node3D

@export var door1: Node3D
@export var door2: Node3D

@export var stream_player: AudioStreamPlayer3D

@export var buttons: Array[ButtonBase]

@export var open_sounds: Array[AudioStream]
@export var close_sounds: Array[AudioStream]

@export var move_amount: float = 1.79

@export var tween_time: float = 1.25

var open: bool = false

func toggle_door(play_sound: bool = true):
	if open:
		close_door(play_sound)
		return
	open_door(play_sound)

func open_door(play_sound: bool = true):
	open = true
	
	for button in buttons:
		button.interaction_prompt.interactable = false
	
	if play_sound:
		stream_player.stream = open_sounds.pick_random()
		stream_player.play()
	
	if door1:
		create_tween()\
			.tween_property(door1, "position:x", -move_amount,tween_time)\
			.set_trans(Tween.TRANS_LINEAR)
	
	if door2:
		create_tween()\
			.tween_property(door2, "position:x", move_amount,tween_time)\
			.set_trans(Tween.TRANS_LINEAR)
	
	await Utils.wait(tween_time)
	
	for button in buttons:
		button.interaction_prompt.interactable = true

func close_door(play_sound: bool = true):
	open = false
	
	for button in buttons:
		button.interaction_prompt.interactable = false
	
	if door1:
		create_tween()\
			.tween_property(door1, "position:x", 0,tween_time)\
			.set_trans(Tween.TRANS_LINEAR)
	
	if door2:
		create_tween()\
			.tween_property(door2, "position:x", 0,tween_time)\
			.set_trans(Tween.TRANS_LINEAR)
	if play_sound:
		stream_player.stream = close_sounds.pick_random()
		stream_player.play()
	
	await Utils.wait(tween_time)
	
	for button in buttons:
		button.interaction_prompt.interactable = true

func _ready():
	for button in buttons:
		button.interact.connect(func():
			toggle_door()
			)
