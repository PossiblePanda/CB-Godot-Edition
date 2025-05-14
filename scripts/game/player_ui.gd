extends CanvasLayer

var tween : Tween

@onready var player: Player = $".."
@onready var blink_component : BlinkComponent = player.get_meta("BlinkComponent")
@onready var blink_rect: ColorRect = $Blink
@onready var blink_bar: Bar = $MarginContainer/VBoxContainer/HBoxContainer/BlinkBar

func _ready() -> void:
	blink_component.connect("blink",on_blink)
	blink_component.connect("end_blink",on_end_blink)


func _process(_delta: float) -> void:
	blink_bar.value = blink_component.blink_meter


func on_blink():
	if tween and tween.is_running():
		await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(blink_rect,"color:a",1,.05)

func on_end_blink():
	if tween and tween.is_running():
		await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(blink_rect,"color:a",0,.05)
