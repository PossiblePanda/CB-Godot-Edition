extends CanvasLayer

const PROMPT_GROUP := "InteractionPrompt"
const MARGIN = 50
const POS_MULTIPLIER = Vector2(1, 1)

var tween : Tween
var current_prompt : InteractionPrompt

@onready var player: Player = $".."
@onready var camera_3d: Camera3D = $"../Neck/Camera3D"
@onready var blink_component : BlinkComponent = player.get_meta("BlinkComponent")
@onready var blink_rect: ColorRect = $Blink
@onready var blink_bar: Bar = $MarginContainer/VBoxContainer/HBoxContainer/BlinkBar
@onready var document_texture: TextureRect = $CenterContainer/DocumentTexture
@onready var held_item_rect: TextureRect = $CenterContainer/HeldItem
@onready var interact_texture: TextureRect = $InteractTexture

func _ready() -> void:
	blink_component.blink.connect(on_blink)
	blink_component.end_blink.connect(on_end_blink)
	player.document_changed.connect(on_document)
	player.held_item_changed.connect(on_held_item_changed)


func _process(_delta: float) -> void:
	blink_bar.value = blink_component.blink_meter
	_update_prompts()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_LEFT and current_prompt:
			current_prompt.triggered.emit()


func on_held_item_changed(item) -> void:
	if item == null:
		held_item_rect.texture = null
		held_item_rect.hide()
	else:
		held_item_rect.texture = item.image
		held_item_rect.show()


func on_document(document: Item) -> void:
	if document == null:
		document_texture.texture = null
		document_texture.hide()
	else:
		var document_component: DocumentComponent = document.get_component("DocumentComponent") as DocumentComponent
		document_texture.texture = document_component.document_image
		document_texture.show()


func on_blink() -> void:
	if tween and tween.is_running():
		await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(blink_rect,"color:a",1,.05)


func on_end_blink() -> void:
	if tween and tween.is_running():
		await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(blink_rect,"color:a",0,.05)


func _get_closest_prompt(prompts : Array[Node]):
	var closest_prompt : InteractionPrompt = null
	var dist : float = 999999
	for index in range(prompts.size() - 1, -1, -1):
		var prompt : InteractionPrompt = prompts[index]
		var current_dist = player.global_position.distance_to(prompt.global_position)
		if not prompt.can_interact(current_dist):
			prompts.remove_at(index)
			continue
		if current_dist > dist:
			continue
		dist = current_dist
		closest_prompt = prompt
	
	if closest_prompt:
		return closest_prompt
	else:
		return


func _update_prompts() -> void:
	var prompts : Array[Node] = get_tree().get_nodes_in_group(PROMPT_GROUP)
	var prompt : InteractionPrompt = _get_closest_prompt(prompts)
	
	if prompt:
		var pos = camera_3d.unproject_position(prompt.global_position)
		var window_size = DisplayServer.window_get_size()
		pos.x = clamp(pos.x*POS_MULTIPLIER.x, MARGIN, (window_size.x - MARGIN) - player.interact_texture.size.x)
		pos.y = clamp(pos.y*POS_MULTIPLIER.y, MARGIN, (window_size.y - MARGIN) - player.interact_texture.size.y)
		
		interact_texture.position = pos
		interact_texture.texture = prompt.interact_texture
		interact_texture.visible = true
		current_prompt = prompt
	else:
		interact_texture.texture = null
		interact_texture.visible = false
		current_prompt = null
