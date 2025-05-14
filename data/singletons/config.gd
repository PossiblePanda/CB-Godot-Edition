extends Node

signal setting_changed(key : String)

var password = OS.get_unique_id()
var config = ConfigFile.new()
var data = {
	mouse_sensitivity = {val = 50, string = "Mouse Sensitivity",min = 0, max = 200},
	fullscreen = {val = true, string = "Fullscreen", changed = func(val):
		if val:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		},
	head_bobbing = {val = true, string = "Head Bobbing"}
}


func save():
	for key in data:
		config.set_value("Controls",key,data[key].val)
	
	config.save_encrypted_pass("user://options.cfg",password)


func set_setting(setting_name: String, value: Variant):
	if not data.has(setting_name):
		push_error("No setting with the name %s" % setting_name)
		return
	
	data[setting_name].val = value
	
	if data[setting_name].has("changed"):
		var changed: Callable = data[setting_name].changed
		
		changed.call(value)
	
	setting_changed.emit(setting_name)


func toggle_setting(setting_name: String):
	if not data.has(setting_name):
		push_error("No setting with the name %s" % setting_name)
		return
	
	if not data[setting_name].val is bool:
		push_error("Can not toggle non-boolean value in the setting %s" % setting_name)
		return
	
	set_setting(setting_name, not data[setting_name].val)


func _init() -> void:
	var err = config.load_encrypted_pass("user://options.cfg",password)
	if err != OK:
		return
	
	for key in config.get_section_keys("Controls"):
		data[key].val = config.get_value("Controls",key)
