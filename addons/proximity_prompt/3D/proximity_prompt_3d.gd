extends Sprite3D

enum ActivationType {
	Click, ## Activated by clicking
	KeyPress,  ## Activated by pressing the activation key
	Both, ## Activated by clicking, or a key press
	}

## The node that is required to be near the prompt to be functional.
@export var activation_node: Node3D
## The maximimum distance the activation node can be from the Proximity Prompt
@export var max_distance: float
## Activated by clicking, or an activation key.
@export var activation_type: ActivationType = ActivationType.Both
## Make sure to set this if you use requires_line_of_sight or requires_direct_look
@export var line_of_sight_node: Node3D
## Requires the proximity prompt to be visible to activate
@export var requires_line_of_sight: bool = true
## The tolerance for how forgiving the line of sight is.
@export var los_tolerance: int = 20
## Requires you to look directly at the prompt to activate it
@export var requires_direct_look: bool = false

var distance: float
var can_interact: bool = false

func _process(delta):
	if activation_node:
		distance = activation_node.global_position.distance_to(global_position)
			
		can_interact = check_can_interact()
			
		visible = can_interact
		
func handle_activation():
	if not can_interact:
		return

func check_can_interact() -> bool:
		if distance <= max_distance:
			if requires_line_of_sight and is_facing(activation_node, los_tolerance):
				return true
			
		return false

func is_facing(target, threshold): 
	var facing_dir = global_transform.basis.z
	var my_pos = global_transform.origin 
	if abs(my_pos.direction_to(target).x - facing_dir.x) < threshold:
		if abs(my_pos.direction_to(target).y - facing_dir.y) < threshold:
			return true

func _input(event):
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			if activation_type == ActivationType.Click or ActivationType.Both:
				handle_activation()
