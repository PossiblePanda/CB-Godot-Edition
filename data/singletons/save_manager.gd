extends Node

# exported for debugging using remote view in the editor
@export var game_save: GameSave

const GAME_SAVE_PATH = "user://game_saves"
# TODO: make into setting
const AUTOSAVE_TIME = 5

signal game_save_changed(res: GameSave)
signal game_saved
signal begin_autosave

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(GAME_SAVE_PATH):
		DirAccess.make_dir_absolute(GAME_SAVE_PATH)
	
	while true:
		await get_tree().create_timer(5).timeout
		if game_save:
			begin_autosave.emit()
			save_game()

func load_game_save(save_name: String):
	var res: GameSave = ResourceStorage.load_resource("%s/%s.tres" % [GAME_SAVE_PATH, save_name], "GameSave")
        #ResourceLoader.load("%s/%s.tres" % [GAME_SAVE_PATH, save_name]) as GameSave
	res.save_name = save_name
	game_save = res
	
	game_save_changed.emit(res)

func create_game_save(save_name: String):
	var res: GameSave = GameSave.new()
	res.save_name = save_name
	
	res.save_to_file(save_name)

func save_game():
	assert(game_save, "No game save found. Has it been loaded yet?")
	game_save.save_to_file("%s.tres" % game_save.save_name)
	game_saved.emit()
