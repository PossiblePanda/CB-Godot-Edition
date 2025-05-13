class_name BlinkComponent
extends Node

signal blink
signal blinking_changed

const BLINK_METER_MAX := 20
const BLINK_METER_MIN := 0
const BLINK_TIME := 0.1

var can_see: bool:
	get:
		return not blinking
	set(_val):
		return
var blinking: bool = false:
	set(val):
		blinking_changed.emit()
		blinking = val
var blink_meter = 20
var tween : Tween

@onready var blink_update: Timer = $"../BlinkUpdate"

func _ready():
	get_parent().set_meta(self.name,self)
	blink_update.timeout.connect(blink_update_timeout)


func blink_update_timeout():
	if blink_meter > 0:
		blink_meter -= 1
		return
	if blinking == false:
		full_blink()


func show_blink():
	blinking = true
	
	blink_meter = BLINK_METER_MIN
	blink_update.start()
	blink.emit()
	
	#await Utils.tween_fade_in(blink_color, BLINK_TIME, 0, 0, "color:a").finished


func hide_blink():
	blinking = false
	can_see = true
	
	#await Utils.tween_fade_out(blink_color, BLINK_TIME, 0, 0, "color:a").finished
	blink_meter = 20 # Reset bar to max


func full_blink():
	await show_blink()
	await hide_blink()
