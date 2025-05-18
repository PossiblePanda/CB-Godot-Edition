class_name DroppedItem
extends RigidBody3D

const DEFAULT_PICKUP_SOUND = preload("res://assets/sounds/sfx/interact/PickItem2.ogg")

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var stream: AudioStream = DEFAULT_PICKUP_SOUND

@export var item : Item: 
	set(val):
		item = val
		_update_enabled()
		
		_update_mesh()

func _ready() -> void:
	_update_enabled()


func _update_enabled() -> void:
	if item == null:
		freeze = true
		visible = false
		$InteractionPrompt.interactable = false
	else:
		freeze = false
		visible = true
		$InteractionPrompt.interactable = true

func _update_mesh():
	if not item: return
	
	if item.mesh:
		mesh_instance_3d.mesh = item.mesh
	
	if item.mesh_texture:
		var material = StandardMaterial3D.new()
		
		material.albedo_texture = item.mesh_texture
		
		mesh_instance_3d.material_override = material
	
	if item.pickup_sound:
		stream = item.pickup_sound

func _on_interaction_prompt_triggered() -> void:
	var inventory : InventoryComponent = Global.player.get_meta("InventoryComponent")
	inventory.add_item(item)
	
	var sound_player = AudioStreamPlayer3D.new()
	sound_player.stream = stream
	sound_player.position = global_position
	
	get_parent().add_child(sound_player)
	
	sound_player.play()
	
	item = null
	queue_free()
	await sound_player.finished
	sound_player.queue_free()
