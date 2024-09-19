extends Button

@onready var hovered_color = $White/HoveredColor

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	hovered_color.show()

func _on_mouse_exited():
	hovered_color.hide()
