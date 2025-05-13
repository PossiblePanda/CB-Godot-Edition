extends CanvasLayer

@onready var player: Player = $".."
@onready var blink_component : BlinkComponent = player.get_meta("BlinkComponent")

@onready var blink_bar: Bar = $MarginContainer/VBoxContainer/HBoxContainer/BlinkBar

func _process(_delta: float) -> void:
	blink_bar.value = blink_component.blink_meter
