extends Camera3D

const SIN_SPEED = 7.75

@export var up_down : Curve
@export var left_right : Curve

var bobbing_time := 0.0
var footstep_time := 0.0

@onready var player: Player = $"../.."
@onready var walking: AudioStreamPlayer3D = $"../../Walking"
@onready var running: AudioStreamPlayer3D = $"../../Running"

func _ready() -> void:
	Config.setting_changed.connect(func(key):
		if key == "head_bobbing":
			rotation_degrees.z = 0
			position.y = 0
		)


func update_bobbing(delta : float,player_speed : float):
	bobbing_time += delta * player_speed
	
	position.y = up_down.sample(wrapf(bobbing_time, 0.0, 1.0)) * 0.2
	rotation_degrees.z = left_right.sample(wrapf(bobbing_time / 2, 0.0, 1.0))


func update_footstep(delta : float,player_speed : float):
	footstep_time += delta * player_speed
	if footstep_time >= .5:
		if player.sprinting:
			running.play()
		else:
			walking.play()
		
		footstep_time = footstep_time - 1


func _process(delta: float) -> void:
	if player.input_dir.length() > 0 and player.is_moving:
		var player_speed = clampf(player.input_dir.length() * player.speed / 2.8,0.5,10)
		
		if Config.data.head_bobbing.val:
			update_bobbing(delta,player_speed)
		
		update_footstep(delta,player_speed)
