class_name InteractionPrompt
extends Node3D

## The maximimum distance the activation node can be from the Prompt
@export var max_distance: float = 3
## The interaction texture
@export var interact_texture: CompressedTexture2D = preload("res://assets/textures/ui/handicon.png")
@export var interactable: bool = true

@warning_ignore("unused_signal")
signal triggered

func _ready() -> void:
	add_to_group("InteractionPrompt",true)


func can_interact(distance) -> bool:
	if get_tree().paused:
		return false
	if not interactable:
		return false
	if distance > max_distance:
		return false
		
	return true
