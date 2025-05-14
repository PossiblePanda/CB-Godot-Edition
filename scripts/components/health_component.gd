class_name HealthComponent
extends Node

signal health_changed
signal died

@export var _health: Dictionary[String,float] = {blood_loss = 0,injury = 0}
@export var heal_timer = 0
var _dead = false

func _process(delta: float) -> void:
	_health_update(delta)


func _ready() -> void:
	get_parent().set_meta(self.name,self)


func _health_update(delta: float):
	if _health["blood_loss"] >= 100:
		if not _dead:
			died.emit()
			_dead = true
		return
	
	if heal_timer > 0: #temporary flat rate for healing
		heal_timer -= delta
		health_set(max(_health["injury"] - 0.0005 * delta * 60,0.0),"injury")
	if _health["injury"] > 1.0: #slightly off compared to base game???
		var updated_blood_loss = _health["blood_loss"]
		updated_blood_loss = min(_health["blood_loss"] + (min(_health["injury"],3.5)/300.0)*delta,100)
		health_set(updated_blood_loss,"blood_loss")


func health_set(amount: float, type: String):
	_health[type] = amount
	health_changed.emit()


func health_manage(amount: float, type: String):
	health_set(_health[type] + amount,type)
