class_name HealthComponent
extends Node

signal blood_loss_changed
signal injury_changed
signal died

@export var heal_timer = 0

var _dead = false
var blood_loss := 0.0:
	set(val):
		blood_loss = clamp(val,0.0,100.0)
		blood_loss_changed.emit()
var injury := 0.0:
	set(val):
		injury = clamp(injury,0.0,5.0)
		injury_changed.emit()

func _process(delta: float) -> void:
	_health_update(delta)


func _ready() -> void:
	get_parent().set_meta(self.name,self)


func _health_update(delta: float):
	if blood_loss >= 100:
		if not _dead:
			died.emit()
			_dead = true
		return
	if heal_timer > 0: #temporary flat rate for healing
		heal_timer -= delta
		injury = max(injury - 0.0005 * delta * 60,0.0)
	if injury > 1.0: #slightly off compared to base game???
		blood_loss = min(blood_loss + (min(injury,3.5)/300.0)*delta,100)
