class_name GameSave
extends BaseSave

enum Difficulty {
	SAFE,
	EUCLID,
	KETER
}

@export var player_position: Vector3
@export var player_orientation: Vector3
@export var inventory: Array[Item] = []

## key: npc name, value: position
@export var npc_positions: Dictionary[String, Vector3]
## key: npc name, value: orientation
@export var npc_orientations: Dictionary[String, Vector3]

@export var difficulty: Difficulty

func save_to_file(name: String):
	last_saved = Time.get_unix_time_from_system()
	ResourceSaver.save(self, "%s/%s.tres" % [SaveManager.GAME_SAVE_PATH, name])
