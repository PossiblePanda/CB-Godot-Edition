class_name Bar
extends Control

@onready var h_box_container = $Panel/MarginContainer/HBoxContainer

@export var minvalue: int = 0
@export var maxvalue: int = 20
@export var value: int = maxvalue:
	set(val):
		for child in h_box_container.get_children():
			child.visible = bool(child.get_index()+1 <= val)
		
		value = clampi(val, minvalue, maxvalue)
