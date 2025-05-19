## Base save class, handles saving to a file & other save logic.
class_name BaseSave
extends Resource

@export var save_version: int = 0
@export var save_name: String = "save"
@export_storage var last_saved: float # unix timestamp

func save_to_file(path: String):
	last_saved = Time.get_unix_time_from_system()
	ResourceSaver.save(self, path)
