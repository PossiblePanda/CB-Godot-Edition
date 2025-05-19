extends Node
## Made by Yni Viar
## The Author grant this project license to use the code under CC-BY-SA 3.0 or GPL 3 (based on your choose)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Secure resource loader
func load_resource(path: String, type: String) -> Resource:
	if FileAccess.file_exists(path):
		var file: FileAccess = FileAccess.open(path, FileAccess.READ)
		var incoming_string: String = file.get_as_text()
		var json_binding: JSON = JSON.new()
		var error = json_binding.parse(incoming_string)
		if error == OK:
			var data_received = json_binding.data
			if typeof(data_received) == TYPE_DICTIONARY && check_class_existance(type) != "":
				var resource_to_save = load(check_class_existance(type)).new()
				#var res_names: Array[Dictionary] = resource_to_save.get_property_list()
				for i in range(data_received.size()):
					#if resource_to_save.is_class(res_names[i]["name"]) || res_names[i]["name"].contains("resource") || res_names[i]["name"] == "script" || res_names[i]["name"].contains(".gd"):
						#continue
					resource_to_save.set(data_received.keys()[i], data_received[data_received.keys()[i]])
				return resource_to_save
			else:
				printerr("Error reading data.")
				return null
		else:
			printerr("Not a JSON")
			return null
	else:
		printerr("File not exist")
		return null

## Secure resource saver
func save_resource(path: String, resource_to_save: Resource):
	var res_names: Array[Dictionary] = resource_to_save.get_property_list()
	var data_to_save: Dictionary = {}
	for i in range(res_names.size()):
		if resource_to_save.is_class(res_names[i]["name"]) || res_names[i]["name"].contains("resource") || res_names[i]["name"] == "script" || res_names[i]["name"].contains(".gd"):
			continue
		data_to_save[res_names[i]["name"]] = resource_to_save.get(res_names[i]["name"])
	var json_binding: JSON = JSON.new()
	var resulting_json = json_binding.stringify(data_to_save)
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_line(resulting_json)
	file.close()

func check_class_existance(type: String) -> String:
	var scripts_path: Array[Dictionary] = ProjectSettings.get_global_class_list()
	for i in range(scripts_path.size()):
		if scripts_path[i]["class"] == type:
			return scripts_path[i]["path"]
	return ""
