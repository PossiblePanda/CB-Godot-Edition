extends BaseConfig

@onready var h_slider: HSlider = $HSlider

func _ready() -> void:
	super()
	h_slider.value = Config.data[setting].val

func _on_h_slider_value_changed(value: float) -> void:
	Config.set_setting(setting, value)
	text = "%s (%d)" % [Config.data[setting].string, Config.data[setting].val]
