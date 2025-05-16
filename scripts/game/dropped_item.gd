class_name DroppedItem
extends RigidBody3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

@export var item : Item : 
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

func _on_interaction_prompt_triggered() -> void:
	var inventory : InventoryComponent = Global.player.get_meta("InventoryComponent")
	inventory.add_item(item)
	item = null
