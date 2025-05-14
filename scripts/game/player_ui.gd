extends CanvasLayer

var tween : Tween

@onready var player: Player = $".."
@onready var blink_component : BlinkComponent = player.get_meta("BlinkComponent")
@onready var blink_rect: ColorRect = $Blink
@onready var blink_bar: Bar = $MarginContainer/VBoxContainer/HBoxContainer/BlinkBar
@onready var document_texture: TextureRect = $CenterContainer/DocumentTexture
@onready var held_item_rect: TextureRect = $CenterContainer/HeldItem

func _ready() -> void:
	blink_component.blink.connect(on_blink)
	blink_component.end_blink.connect(on_end_blink)
	player.document_changed.connect(on_document)
	player.held_item_changed.connect(on_held_item_changed)


func _process(_delta: float) -> void:
	blink_bar.value = blink_component.blink_meter


func on_held_item_changed(item):
	if item == null:
		held_item_rect.texture = null
		held_item_rect.hide()
	else:
		held_item_rect.texture = item.image
		held_item_rect.show()


func on_document(document : DocumentItem):
	if document == null:
		document_texture.texture = null
		document_texture.hide()
	else:
		document_texture.texture = document.document_image
		document_texture.show()


func on_blink():
	if tween and tween.is_running():
		await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(blink_rect,"color:a",1,.05)


func on_end_blink():
	if tween and tween.is_running():
		await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(blink_rect,"color:a",0,.05)
