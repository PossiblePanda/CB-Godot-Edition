class_name HealthComponent
extends BaseComponent

signal blood_loss_changed
signal injury_changed
signal died

@export var heal_timer = 0
@export var blood_loss := 0.0:
	set(val):
		blood_loss = clamp(val,0.0,100.0)
		blood_loss_changed.emit()
@export var injury := 0.0:
	set(val):
		injury = clamp(injury,0.0,5.0)
		injury_changed.emit()

var _dead = false

func _process(delta: float) -> void:
	_health_update(delta)


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
