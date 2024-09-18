extends Control

const SLIDER_TEMPLATE = preload("res://Scenes/Menus/SliderTemplate.tscn")
const CHECKBOX_TEMPLATE = preload("res://Scenes/Menus/CheckboxTemplate.tscn")

@export var buttons: VBoxContainer

@onready var v_box_container: VBoxContainer = $Main/Black/VBoxContainer

func _ready() -> void:
	for key in Config.data:
		match type_string(typeof(Config.data[key].val)): #some copy pasting here
			"int":
				var template = SLIDER_TEMPLATE.instantiate()
				var slider : HSlider = template.get_node("HSlider")
				slider.min_value = Config.data[key].min
				slider.max_value = Config.data[key].max
				slider.rounded = true
				template.setting = key
				
				v_box_container.add_child(template)
			"float":
				var template = SLIDER_TEMPLATE.instantiate()
				var slider : HSlider = template.get_node("HSlider")
				slider.min_value = Config.data[key].min
				slider.max_value = Config.data[key].max
				template.setting = key
				
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
