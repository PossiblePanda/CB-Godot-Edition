@tool
extends EditorPlugin

var window
var surface_spinbox
var mesh_instance

func _enter_tree():
	window = VBoxContainer.new()
	window.name = "Extract Surface Tool"

	var label = Label.new()
	label.text = "Surface Index:"
	window.add_child(label)

	surface_spinbox = SpinBox.new()
	surface_spinbox.min_value = 0
	surface_spinbox.max_value = 100  # Adjust this based on your needs
	surface_spinbox.value = 0
	window.add_child(surface_spinbox)

	var button = Button.new()
	button.text = "Extract Surface"
	button.connect("pressed", _on_button_pressed)
	window.add_child(button)

	add_control_to_dock(DOCK_SLOT_RIGHT_UL, window)
	window.show()

func _exit_tree():
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, window)
	window.queue_free()

func _on_button_pressed():
	if not mesh_instance or not mesh_instance is MeshInstance3D:
		push_error("Please select a MeshInstance3D node.")
		return
	
	var mesh = mesh_instance.mesh
	if not mesh:
		push_error("Selected node does not have a mesh.")
		return

	var surface_index = int(surface_spinbox.value)
	if surface_index >= mesh.get_surface_count():
		push_error("Mesh does not have enough surfaces.")
		return
	
	var new_mesh = ArrayMesh.new()
	new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh.surface_get_arrays(surface_index))
	
	var new_mesh_instance = MeshInstance3D.new()
	new_mesh_instance.mesh = new_mesh
	new_mesh_instance.name = mesh_instance.name+"_"+str(surface_index)
	
	# Set new_mesh_instance's transform to match mesh_instance's global transform
	new_mesh_instance.global_transform = mesh_instance.global_transform
	
	# Add new_mesh_instance as a child to the parent of mesh_instance
	if mesh_instance.get_parent():
		mesh_instance.get_parent().add_child(new_mesh_instance)
	else:
		# If no parent, add to the root of the scene
		get_tree().get_root().add_child(new_mesh_instance)
		
	new_mesh_instance.owner = get_tree().edited_scene_root
	
	print("New mesh with surface %d created." % surface_index)

	# Ensure the editor updates and displays the new node
	new_mesh_instance.show()

func _handles(object):
	return object is MeshInstance3D

func make_visible(visible):
	if visible:
		window.show()
	else:
		window.hide()

func _edit(object):
	print(object)
	mesh_instance = object
