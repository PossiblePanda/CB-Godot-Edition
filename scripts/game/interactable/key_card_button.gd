class_name KeyCardButton
extends ButtonBase

@export var card_level: int = 1
@export var no_card_sound: AudioStream

func _fail():
	failed.emit()

	sound.stream = failed_sound

func _no_card():
	failed.emit()
	Global.game.player.show_action_text("A keycard is required to operate this door.")

	sound.stream = no_card_sound

func _ready():
	interaction_prompt.triggered.connect(func():
		print(Global.game.player.held_item)
		if not enabled:
			_fail()
		if not Global.game.player.held_item:
			_no_card()
			sound.play()
			return
		if not Global.game.player.held_item is KeyCardItem:
			_no_card()
			sound.play()
			return
			
		if Global.game.player.held_item.card_level >= card_level:
			sound.stream = interact_sound
			
			interact.emit()
		else:
			Global.game.player.show_action_text("A keycard with security clearance %s or higher is required to operate this door." % str(card_level))
			_fail()
		
		Global.game.player.held_item = null
		
		sound.play()
		)
