class_name PressButton
extends ButtonBase

func _ready():
	interaction_prompt.triggered.connect(func():
		if enabled:
			interact.emit()
			
			sound.stream = interact_sound
		else:
			failed.emit()
			
			sound.stream = failed_sound
		sound.play()
		)
