extends Node

const LOADING_SCREEN = preload("res://scenes/menus/loading.tscn")
const HINT_DIR = "res://data/resources/loading_hints/"

var hints: Array[LoadingHint] = []

func _ready():
	register_hint_dir()

func load_scene(path: String):
	var screen: Loading = LOADING_SCREEN.instantiate()
	screen.next_scene = path
	
	get_tree().root.add_child(screen)

func register_hint(hint: LoadingHint):
	hints.append(hint)

func get_hints_in_dir(path: String):
	var dir_access: DirAccess = DirAccess.open(path)
	var _hints: Array[LoadingHint] = []
	
	for file in dir_access.get_files():
		if file.ends_with(".tres"):
			var hint: LoadingHint = ResourceLoader.load(path+file)
			_hints.append(hint)
	return _hints

func register_hints(arr: Array[LoadingHint]):
	for hint in arr:
		register_hint(hint)

func register_hint_dir(path: String = HINT_DIR):
	var _hints = get_hints_in_dir(path)
	
	register_hints(_hints)
