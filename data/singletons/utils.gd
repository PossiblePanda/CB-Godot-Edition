extends Node

func wait(time: float) -> void:
	await get_tree().create_timer(time).timeout

func tween_fade_out(node: Node, duration: float = 1, delay: float = 0, trans: int = Tween.TRANS_LINEAR, property: String = "modulate:a") -> Tween:
	var tween = create_tween()
	tween\
		.tween_property(node, property, 0, duration)\
		.set_trans(trans)\
		.set_delay(delay)
	
	return tween

func tween_fade_in(node: Node, duration: float = 1, delay: float = 0, trans: int = Tween.TRANS_LINEAR, property: String = "modulate:a") -> Tween:
	var tween = create_tween()
	tween.tween_property(node, property, 1, duration)\
		.set_trans(trans)\
		.set_delay(delay)
	
	return tween 
