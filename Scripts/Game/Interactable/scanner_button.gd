class_name ScannerButton
extends ButtonBase

@export var required_dna: Array[String] = ["Class-D"]

func _fail():
	failed.emit()

	sound.stream = failed_sound

func check_has_item_dna(dna_string: String) -> bool:
	if not Global.game.player.held_item:
		return false
	
	if not "dna" in Global.game.player.held_item:
		return false
		
	if Global.game.player.held_item.has_dna(dna_string):
		return true
	return false

func _ready():
	interaction_prompt.triggered.connect(func():
		if not enabled:
			_fail()
			return
		
		var has_dna := false
		for dna in required_dna:
			if Global.game.player.has_dna(dna):
				has_dna = true
		
		var has_item_dna := false
		for dna in required_dna:
			if check_has_item_dna(dna):
				has_item_dna = true
		
		if has_dna or has_item_dna:
			sound.stream = interact_sound
			Global.game.player.show_action_text('You place the palm of your hand onto the scanner. The scanner reads: "DNA Verified. Access granted."')
			
			interact.emit()
		else:
			Global.game.player.show_action_text('You placed your palm onto the scanner. The scanner reads: "DNA does not match with known sample. Access denied."')
			_fail()
		
		Global.game.player.held_item = null
		
		sound.play()
		)
