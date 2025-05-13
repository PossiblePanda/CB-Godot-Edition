class_name Bar
extends Control

@onready var h_box_container = $Panel/MarginContainer/HBoxContainer

@export var min_value: int = 0
@export var max_value: int = 20
@export var value: int = max_value:
	set(val):
		for child in h_box_container.get_children():
			child.visible = bool(child.get_index()+1 <= val)
		
		value = clampi(val, min_value, max_value)
