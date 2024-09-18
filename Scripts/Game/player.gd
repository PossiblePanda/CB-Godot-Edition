class_name Player
extends CharacterBody3D

@export var DNA: Array[String] = ["D-9341", "Class-D"]
@export var health: Array[float] = [100, 100]

@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var neck: Node3D = $Neck
@onready var footstep: AudioStreamPlayer3D = $Footstep
@onready var breath: AudioStreamPlayer3D = $Neck/Breath
@onready var exhausted: AudioStreamPlayer3D = $Neck/Exhausted

@onready var blink_update: Timer = $BlinkUpdate
@onready var sprint_update: Timer = $SprintUpdate
@onready var sprint_regeneration_update: Timer = $SprintRegenerationUpdate

@onready var action_text = $"../CanvasLayer/ActionText"
@onready var interact_texture = $"../CanvasLayer/InteractTexture"
@onready var document_texture = $"../CanvasLayer/CenterContainer/DocumentTexture"
@onready var held_item_rect = $"../CanvasLayer/CenterContainer/HeldItem"
@onready var blink_bar: Bar = $"../CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/BlinkBar"
@onready var sprint_bar: Bar = $"../CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer2/SprintBar"
@onready var blink_color: ColorRect = $"../CanvasLayer/Blink"

@onready var inventory: Inventory = $"../CanvasLayer/Inventory"

const BLINK_TIME = 0.1
const EXHAUSTED = preload("res://Assets/Sounds/SFX/player/exhausted.ogg")
const BREATH_1 = preload("res://Assets/Sounds/SFX/player/breath1.ogg")
const BREATH_2 = preload("res://Assets/Sounds/SFX/player/breath2.ogg")
const BREATH_3 = preload("res://Assets/Sounds/SFX/player/breath3.ogg")

var current_health: Array[float] = health

var current_document: DocumentItem:
	set(val):
		if val == null:
			document_texture.texture = null
			document_texture.hide()
		else:
			document_texture.texture = val.document_image
			document_texture.show()
			
		current_document = val

var held_item: Item:
	set(val):
		if val == null:
			held_item_rect.texture = null
			held_item_rect.hide()
		else:
			held_item_rect.texture = val.image
			held_item_rect.show()
		
		held_item = val

var interact_visible: bool = false:
	set(val):
		interact_texture.visible = val
		
		interact_visible = val

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 3


var can_see: bool = true
var blinking: bool = false

var sprinting: bool = false
var can_sprint: bool = true

var regular_breath_sounds = [BREATH_1, BREATH_2, BREATH_3]

signal blink
signal sprint_started
signal sprint_ended

func _ready():
	blink_update.timeout.connect(func():
		if blink_bar.value > blink_bar.minvalue:
			can_see = true
			blink_bar.value -= 1
			return
		if blinking == false:
			full_blink()
		)
		
	sprint_update.timeout.connect(func():
		if sprinting:
			if sprint_bar.value > sprint_bar.minvalue:
				sprint_bar.value -= 1
				
				if not breath.playing and sprint_bar.value <= sprint_bar.maxvalue / 2:
					breath.stream = regular_breath_sounds.pick_random()
					breath.play()
			else:
				stop_sprint()
				can_sprint = false
				
				exhausted.stream = EXHAUSTED
				exhausted.play()
				
				await Utils.wait(3)
				
				can_sprint = true
		)
		
	sprint_regeneration_update.timeout.connect(func():
		if not sprinting and can_sprint:
			sprint_bar.value += 1
		)
		
	breath.finished.connect(func():
		for sound in regular_breath_sounds:
			if sound == breath.stream and sprinting:
				breath.stream = regular_breath_sounds.pick_random()
				breath.play()
		)

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction and Global.game.pause_menu.visible == false and inventory.visible == false:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	if direction and is_on_floor():
		pass
	elif footstep.is_playing():
		footstep.stop()
	
	move_and_slide()

var action_tween: Tween

func show_action_text(text: String) -> void:
	if action_tween:
		action_tween.stop()
	
	action_text.visible = true
	action_text["theme_override_colors/font_color"] = Color(0.878, 0.878, 0.878, 1)
	
	action_text.text = text
	action_tween = Utils.tween_fade_out(action_text, 6, 0, 0, "theme_override_colors/font_color:a")
	await action_tween.finished
	
	action_text.visible = false

func _input(_event):
	if Input.is_action_just_pressed("blink"):
		show_blink()
	elif Input.is_action_just_released("blink"):
		hide_blink()
	if Input.is_action_just_pressed("sprint"):
		if sprint_bar.value > 0:
			start_sprint()
	elif Input.is_action_just_released("sprint"):
		stop_sprint()

func full_blink():
	await show_blink()
	await hide_blink()

func start_sprint():
	if sprinting == false and can_sprint:
		sprinting = true
		sprint_started.emit()
		sprint_update.paused = not sprinting
		sprint_regeneration_update.paused = sprinting
		
		speed += 4
		
		breath.stream = regular_breath_sounds.pick_random()

func stop_sprint():
	if sprinting == true:
		sprinting = false
		sprint_ended.emit()
		sprint_update.paused = not sprinting
		sprint_regeneration_update.paused = sprinting
		
		speed -= 4

func show_blink():
	blinking = true
	can_see = false
	
	blink_bar.value = blink_bar.minvalue # Remove all segments from bar when blinking
	blink_update.start() # Reset timer
	blink.emit()
	
	await Utils.tween_fade_in(blink_color, BLINK_TIME, 0, 0, "color:a").finished

func hide_blink():
	blinking = false
	can_see = true
	
	await Utils.tween_fade_out(blink_color, BLINK_TIME, 0, 0, "color:a").finished
	blink_bar.value = blink_bar.maxvalue # Reset bar to max

func add_dna(dna_string: String)->void:
	DNA.append(dna_string)

func has_dna(dna_string: String) -> bool:
	return DNA.has(dna_string)

## Health manager.
func health_manage(amount: float, type: int):
	if current_health[type] + amount <= health[type]:
		current_health[type] += amount
	else:
		current_health = health
	if current_health[type] <= 0:
		get_parent().toggle_pause()
