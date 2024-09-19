class_name Loading
extends Control

@export var hint: LoadingHint
@export var next_scene: String = "res://scenes/menus/main_menu.tscn"

var loaded: bool = false

signal finished_loading
signal scene_changed

func _ready():
	hint = LoadManager.hints.pick_random()
	ResourceLoader.load_threaded_request(next_scene)
	
	$Hint/HintTitle.text = hint.title
	$Hint/HintText.text = hint.text.pick_random()
	
	$Image.texture = hint.image
	$Image.position.x = hint.get_pos_x(size)
	$Image.position.y = hint.get_pos_y(size)
	
	$BackgroundImage.visible = not hint.disabled_background
	
	

func _input(event):
	if loaded:
		if event is InputEventKey or event is InputEventMouseButton:
			var packed_scene = ResourceLoader.load_threaded_get(next_scene)
			get_tree().change_scene_to_packed(packed_scene)

func _process(delta):
	var progress = []
	ResourceLoader.load_threaded_get_status(next_scene, progress)
	$ProgressBar.value = roundi(progress[0]*30)
	$ProgressText.text = "LOADING - " + str(roundi(progress[0]*100))+" %"
	
	if progress[0] == 1 and not loaded:
		finished_loading.emit()
		loading_finished()

func loading_finished() -> void:
	loaded = true
	$ContinueText.show()
