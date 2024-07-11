extends Node3D

## The maximimum distance the activation node can be from the Prompt
@export var max_distance: float = 3
## The interaction texture
@export var interact_texture: CompressedTexture2D = preload("res://Assets/Textures/ui/handicon.png")

const MARGIN = 250
const POS_MULTIPLIER = Vector2(1, 1)

signal triggered

var distance: float
var can_interact: bool = false

func _process(delta):
	if Global.game.player != null:
		distance = Global.game.player.global_position.distance_to(global_position)
			
		can_interact = check_can_interact()
		
		Global.game.player.interact_texture.visible = can_interact
		
		Global.game.player.interact_texture.texture = interact_texture
		
		if can_interact:
			var pos = Global.game.player.camera.unproject_position(global_position)
			
			pos.x = clamp(pos.x*POS_MULTIPLIER.x, MARGIN, (Global.game.player.blink_color.size.x - MARGIN) - Global.game.player.interact_texture.size.x)
			pos.y = clamp(pos.y*POS_MULTIPLIER.y, MARGIN, (Global.game.player.blink_color.size.y - MARGIN) - Global.game.player.interact_texture.size.y)
			
			print(pos)
			
			Global.game.player.interact_texture.position = pos
			print(Global.game.player.interact_texture.visible)
	
func handle_activation():
	if not can_interact:
		return
	triggered.emit()

func check_can_interact() -> bool:
		if distance <= max_distance:
			print("Yers")
			return true
			
		return false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			handle_activation()
