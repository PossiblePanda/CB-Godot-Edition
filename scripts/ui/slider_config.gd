extends BaseConfig

@onready var h_slider: HSlider = $HSlider

func _ready() -> void:
	super()
	h_slider.value = Config.data[setting].val

func _on_h_slider_value_changed(value: float) -> void:
	Config.data[setting].val = value
	text = Config.data[setting].string + " (" + str(Config.data[setting].val) + ")"
	Config.setting_changed.emit(setting)
