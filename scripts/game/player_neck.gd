extends Node3D

#credit - Yo Soy Freeman - see link
#https://yosoyfreeman.github.io/article/godot/tutorial/achieving-better-mouse-input-in-godot-4-the-perfect-camera-controller

const MAX_PITCH =  70
const MIN_PITCH = -70

@onready var camera_3d: Camera3D = $Camera3D
@onready var player: Player = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_use_accumulated_input(false)

func _unhandled_input(event)->void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		aim_look(event)


#Handles aim look with the mouse.
func aim_look(event: InputEventMouseMotion)-> void:
	var viewport_transform: Transform2D = get_tree().root.get_final_transform()
	var motion: Vector2 = event.xformed_by(viewport_transform).relative
	var degrees_per_unit: float = 0.001
	
	motion *= Config.data.mouse_sensitivity.val
	motion *= degrees_per_unit
	
	add_yaw(motion.x)
	add_pitch(motion.y)
	clamp_pitch()

#Rotates the character around the local Y axis by a given amount (In degrees) to achieve yaw.
func add_yaw(amount)->void:
	if is_zero_approx(amount):
		return
	
	player.rotate_object_local(Vector3.DOWN, deg_to_rad(amount))
	player.orthonormalize()


#Rotates the head around the local x axis by a given amount (In degrees) to achieve pitch.
func add_pitch(amount)->void:
	if is_zero_approx(amount):
		return
	
	rotate_object_local(Vector3.LEFT, deg_to_rad(amount))
	orthonormalize()


#Clamps the pitch between MIN_PITCH and MAX_PITCH.
func clamp_pitch()->void:
	if rotation.x > deg_to_rad(MIN_PITCH) and rotation.x < deg_to_rad(MAX_PITCH):
		return
	
	rotation.x = clamp(rotation.x, deg_to_rad(MIN_PITCH), deg_to_rad(MAX_PITCH))
	orthonormalize()
