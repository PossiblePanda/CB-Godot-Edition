extends Control

const SLIDER_TEMPLATE = preload("res://scenes/ui/slider_template.tscn")
const CHECKBOX_TEMPLATE = preload("res://scenes/ui/checkbox_template.tscn")

@export var buttons: VBoxContainer
@onready var v_box_container: VBoxContainer = $Main/MarginContainer/VBoxContainer

func new_slider(key):
	var template = SLIDER_TEMPLATE.instantiate()
	var slider : HSlider = template.get_node("HSlider")
	slider.min_value = Config.data[key].min
	slider.max_value = Config.data[key].max
	template.setting = key
	
	return template

func _ready() -> void:
	for key in Config.data:
		match type_string(typeof(Config.data[key].val)):
			"int":
				var template = new_slider(key)
				var slider : HSlider = template.get_node("HSlider")
				slider.rounded = true
				
				v_box_container.add_child(template)
			"float":
				var template = new_slider(key)
				v_box_container.add_child(template)
			"bool":
				var template = CHECKBOX_TEMPLATE.instantiate()
				template.setting = key
				
				v_box_container.add_child(template)

func _on_back_button_pressed() -> void:
	Config.save()
	visible = false
	
	if buttons:
		buttons.visible = true

func _on_hidden() -> void:
	Config.save()
	if buttons:
		buttons.visible = true
