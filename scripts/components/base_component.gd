class_name BaseComponent
extends Node

func _ready() -> void:
	get_parent().set_meta(self.name,self)
