extends CharacterBody3D

#TODO current state machine is temporary and needs to be replaced
enum States {IDLE,PATROL,SEARCHING,CHASING} 

var state : States
var speed: float = 2.0
var spotted_player := false
var last_spotted_player := false
var last_player_position : Vector3
var idle_time = 0
var is_moving = false
var patrol_point : Node3D
var last_patrol_point : Node3D

var state_entered : Dictionary[States,Callable] = {
	States.IDLE: _on_idle_entered,
	States.PATROL: _on_patrol_entered,
	States.SEARCHING: _on_searching_entered,
	States.CHASING: _on_chasing_entered,
}

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var model: Node3D = $Model
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var patrol_points: Node = $/root/Game/PatrolPoints
@onready var head: Node3D = $Model/Head

@onready var sounds: Dictionary = {"spotted": $Spotted}

func _ready() -> void:
	change_state(States.IDLE)


func _physics_process(delta: float) -> void:
	_update_spotted()
	match state:
		States.IDLE:
			if velocity.length() > 0 and is_moving:
				navigation_agent.set_target_position(global_position)
				is_moving = false
			idle_time += delta
			if idle_time >= 1:
				change_state(States.PATROL)
		States.PATROL:
			if patrol_point and navigation_agent.is_navigation_finished():
				change_state(States.IDLE)
				patrol_point = null
				return
			if not patrol_point:
				new_patrol_point()
				navigation_agent.set_target_position(patrol_point.global_position)
				is_moving = true
		States.SEARCHING: #unimplemented
			change_state(States.IDLE)
		States.CHASING:
			if spotted_player:
				last_player_position = Global.player.global_position
				navigation_agent.set_target_position(last_player_position)
				is_moving = true
			elif navigation_agent.is_navigation_finished():
				change_state(States.SEARCHING)
	_update_movement(delta)


func _process(delta: float) -> void:
	if last_spotted_player == false and spotted_player == true:
		sounds["spotted"].play()
	_update_animations(delta)


func change_state(change_to : States) -> void:
	state = change_to
	state_entered[state].call()


func _on_idle_entered():
	idle_time = 0

func _on_patrol_entered():
	pass

func _on_searching_entered():
	pass

func _on_chasing_entered():
	last_player_position = Global.player.global_position
	navigation_agent.set_target_position(last_player_position)


func _update_movement(_delta) -> void:
	var next_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * speed
	navigation_agent.velocity = new_velocity

func _update_spotted() -> void:
	_update_ray()
	
	var direction = head.global_position.direction_to(Global.player.global_position)
	var facing = head.global_transform.basis.tdotz(direction)
	var fov = cos(deg_to_rad(70))
	if (ray_collider_is_player() and facing > fov) or _distance_to_player(Global.player) < 1:
		last_spotted_player = spotted_player
		spotted_player = true
		change_state(States.CHASING)
	else:
		last_spotted_player = spotted_player
		spotted_player = false


func _update_ray() -> void:
	ray_cast_3d.target_position = ray_cast_3d.to_local(Global.player.global_position)
	ray_cast_3d.target_position.y += 2
	ray_cast_3d.force_raycast_update()


func _update_animations(delta) -> void:
	var is_walking_string := "parameters/conditions/is_walking"
	var hand_out_string := "parameters/Walk Blend/hand_out_add/add_amount"
	var hand_out_string2 := "parameters/Idle Blend/Hand Out Blend/add_amount"
	var current_hand_out = animation_tree.get(hand_out_string)
	var vel = velocity; vel.y = 0
	
	if velocity.length() > 1:
		animation_tree.set(is_walking_string,true)
	else:
		animation_tree.set(is_walking_string,false)
	
	if spotted_player:
		animation_tree.set(hand_out_string,lerp(current_hand_out,1.0,15 * delta))
		animation_tree.set(hand_out_string2,lerp(current_hand_out,1.0,15 * delta))
	else:
		animation_tree.set(hand_out_string,lerp(current_hand_out,0.0,15 * delta))
		animation_tree.set(hand_out_string2,lerp(current_hand_out,0.0,15 * delta))
	
	if vel.length() > 1 or spotted_player:
		var target = transform.origin + vel
		if spotted_player:
			target = Global.player.global_position
			target.y = model.global_position.y
		var old_rot = model.rotation #horrible method but it works so
		model.look_at(target,Vector3.UP)
		var new_rot = model.rotation
		new_rot.x = old_rot.x
		new_rot.z = new_rot.z
		model.rotation = old_rot 
		model.rotation.y = lerp_angle(model.rotation.y,new_rot.y,15 * delta)


func new_patrol_point() -> void:
	var patrol_array = patrol_points.get_children()
	patrol_point = patrol_array[randi_range(0,patrol_array.size() - 1)]
	while patrol_point == last_patrol_point:
		patrol_point = patrol_array[randi_range(0,patrol_array.size() - 1)]


func ray_collider_is_player() -> bool:
	return ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().is_in_group("Players")


func _distance_to_player(player : Player):
	return global_position.distance_to(player.global_position)


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity,.1)
	move_and_slide()
