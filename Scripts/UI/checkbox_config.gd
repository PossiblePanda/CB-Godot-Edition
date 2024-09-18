extends BaseConfig

@onready var button: Button = $Button
@onready var check: Sprite2D = $Button/White/Check

func _ready() -> void:
	super()
	check.visible = Config.data[setting].val

func _on_button_pressed() -> void:
	Config.data[setting].val = not Config.data[setting].val
	check.visible = Config.data[setting].val
	Config.setting_changed.emit(setting)
