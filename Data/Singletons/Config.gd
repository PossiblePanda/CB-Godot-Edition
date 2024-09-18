extends Node

signal setting_changed

var password = OS.get_unique_id()

var data = {
	mouse_sensitivity = {val = 50, string = "Mouse Sensitivity",min = 0, max = 200},
	test = {val = false, string = "Test"},
	head_bobbing = {val = true, string = "Head Bobbing"}
}

var config = ConfigFile.new()

func save():
	for key in data:
		config.set_value("Controls",key,data[key].val)
	
	config.save_encrypted_pass("user://options.cfg",password)

func _init() -> void:
	var err = config.load_encrypted_pass("user://options.cfg",password)
	if err != OK:
		return
	
	for key in config.get_section_keys("Controls"):
		data[key].val = config.get_value("Controls",key)
