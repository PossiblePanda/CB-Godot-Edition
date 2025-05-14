class_name HealthComponent
extends Node

signal health_changed
signal died

@export var health: Array[float] = [100, 100]

var current_health: Array[float] = health

func _ready() -> void:
	get_parent().set_meta(self.name,self)


func health_manage(amount: float, type: int):
	if current_health[type] + amount <= health[type]:
		current_health[type] += amount
	else:
		current_health = health
	if current_health[type] <= 0:
		died.emit()
	health_changed.emit()
