extends Node

@export var up_down : Curve
@export var left_right : Curve

@onready var player: Player = $".."
@onready var neck: Node3D = $"../Neck"
@onready var camera: Camera3D = $"../Neck/Camera3D"
@onready var walking: AudioStreamPlayer3D = $"../Walking"
@onready var running: AudioStreamPlayer3D = $"../Running"

const SIN_SPEED = 7.75

var bobbing_time := 0.0
var footstep_time := 0.0

func _ready() -> void:
	Config.setting_changed.connect(func(key):
		if key == "head_bobbing":
			camera.rotation_degrees.z = 0
			camera.position.y = 0
		)

func update_bobbing(delta : float,player_speed : float):
	bobbing_time += delta * player_speed
	
	camera.position.y = up_down.sample(wrapf(bobbing_time, 0.0, 1.0)) * 0.2
	camera.rotation_degrees.z = left_right.sample(wrapf(bobbing_time / 2, 0.0, 1.0))

func update_footstep(delta : float,player_speed : float):
	footstep_time += delta * player_speed
	
	if footstep_time > .5:
		if player.sprinting:
			running.play()
		else:
			walking.play()
		
		footstep_time = -.5

func _process(delta: float) -> void:
	if player.velocity.abs().length() > 0:
		var player_speed = clampf(player.velocity.abs().length() / 2.8,0.5,10)
		
		if Config.data.head_bobbing.val:
			update_bobbing(delta,player_speed)
		
		update_footstep(delta,player_speed)
