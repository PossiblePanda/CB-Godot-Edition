class_name BlinkComponent
extends BaseComponent

signal blink
signal end_blink

const BLINK_METER_MAX := 20
const BLINK_METER_MIN := 0

var can_see: bool:
	get:
		return not blinking
	set(_val):
		return
var blinking: bool = false:
	set(val):
		blinking = val
var blink_meter = 20

@onready var blink_timer: Timer = %BlinkTimer
@onready var blink_update: Timer = %BlinkUpdate

func _ready():
	super()
	blink_update.timeout.connect(_blink_update_timeout)


func _blink_update_timeout():
	if blink_meter > 0:
		blink_meter -= 1
		return
	if blinking == false:
		full_blink()


func _await_blink_timer():
	if not blink_timer.is_stopped():
		await blink_timer.timeout
	
	blink_timer.start()
	await blink_timer.timeout


func show_blink():
	if blinking == true:
		return
	blinking = true
	
	blink_meter = BLINK_METER_MIN
	blink_update.start()
	blink.emit()
	
	_await_blink_timer()


func hide_blink():
	if blinking == false:
		return
	blinking = false
	
	end_blink.emit()
	
	_await_blink_timer()
	blink_meter = 20 # Reset bar to max


func full_blink():
	show_blink()
	hide_blink()
