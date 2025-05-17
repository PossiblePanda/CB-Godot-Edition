extends CharacterBody3D

var speed: float = 2.0
@onready var movement_target_position: Node3D = Global.player
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func distance_to_player(player : Player):
	return global_position.distance_to(player.global_position)


func _physics_process(delta):
	if distance_to_player(Global.player) > navigation_agent.target_desired_distance:
		set_movement_target(Global.player.global_position)
	
	var next_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * speed

	velocity = velocity.move_toward(new_velocity,.1 * delta * 60)
	move_and_slide()


func _on_navigation_agent_3d_target_reached() -> void:
	set_movement_target(global_position)
