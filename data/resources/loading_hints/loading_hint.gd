class_name LoadingHint
extends Resource

enum AlignmentX { LEFT, CENTER, RIGHT }
enum AlignmentY { BOTTOM, CENTER, TOP }

@export var title: String
@export var image: CompressedTexture2D
@export var alignment_x: AlignmentX = AlignmentX.CENTER
@export var alignment_y: AlignmentY = AlignmentY.CENTER
@export var disabled_background: bool = false
@export var text: Array[String]

func get_pos_x(ScreenSize: Vector2) -> float:
	match alignment_x:
		AlignmentX.LEFT:
			return 0
		AlignmentX.CENTER:
			return ScreenSize.x/2
		AlignmentX.RIGHT:
			return ScreenSize.x - image.get_width()
	return 0

func get_pos_y(ScreenSize: Vector2) -> float:
	match alignment_y:
		AlignmentY.TOP:
			return 0
		AlignmentY.CENTER:
			return ScreenSize.y/2
		AlignmentY.BOTTOM:
			return ScreenSize.y - image.get_height()
	return 0
