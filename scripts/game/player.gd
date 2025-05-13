class_name Player
extends CharacterBody3D

@export var health: Array[float] = [100, 100]

@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3D
@onready var breath: AudioStreamPlayer3D = $Neck/Breath
@onready var exhausted: AudioStreamPlayer3D = $Neck/Exhausted

@onready var sprint_update: Timer = $SprintUpdate
@onready var sprint_regeneration_update: Timer = $SprintRegenerationUpdate
@onready var exhaustion_timer: Timer = $ExhaustionTimer

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var action_text = $CanvasLayer/ActionText
@onready var interact_texture = $CanvasLayer/InteractTexture
@onready var document_texture = $CanvasLayer/CenterContainer/DocumentTexture
@onready var held_item_rect = $"CanvasLayer/CenterContainer/HeldItem"
@onready var blink_bar: Bar = $"CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/BlinkBar"
@onready var sprint_bar: Bar = $"CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer2/SprintBar"
@onready var blink_color: ColorRect = $"CanvasLayer/Blink"

@onready var pause_menu: TextureRect = $CanvasLayer/PauseMenu
@onready var options: Control = $CanvasLayer/PauseMenu/Options
@onready var inventory: Inventory = $CanvasLayer/Inventory

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
var input_dir := Vector2.ZERO

var can_see: bool = true
var blinking: bool = false

var sprinting: bool = false
var can_sprint: bool = true

signal sprint_started
signal sprint_ended

func _ready():
	sprint_update.timeout.connect(func():
		if sprinting:
			if sprint_bar.value > sprint_bar.min_value:
				sprint_bar.value -= 1
				
				@warning_ignore("integer_division")
				if not breath.playing and sprint_bar.value <= sprint_bar.max_value / 2:
					breath.play()
			else:
				stop_sprint()
				can_sprint = false
				
				exhausted.play()
				
				exhaustion_timer.start()
				await exhaustion_timer.timeout
				
				can_sprint = true
		)
		
	sprint_regeneration_update.timeout.connect(func():
		if not sprinting and can_sprint:
			sprint_bar.value += 1
		)


func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction and pause_menu.visible == false and inventory.visible == false:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if direction and is_on_floor():
		pass
	
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

func _input(event):
	if Input.is_action_just_pressed("blink"):
		self.get_meta("BlinkComponent").show_blink()
	elif Input.is_action_just_released("blink"):
		self.get_meta("BlinkComponent").hide_blink()
		
	if Input.is_action_just_pressed("sprint"):
		if sprint_bar.value > 0:
			start_sprint()
	elif Input.is_action_just_released("sprint"):
		stop_sprint()
		
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			if held_item:
				for component in held_item.components:
					component.interact(held_item)
		elif event.button_mask == MOUSE_BUTTON_RIGHT:
			if held_item:
				held_item = null
			if current_document:
				current_document = null

func start_sprint():
	if sprinting == false and can_sprint:
		sprinting = true
		sprint_started.emit()
		sprint_update.paused = not sprinting
		sprint_regeneration_update.paused = sprinting
		
		speed += 4

func stop_sprint():
	if sprinting == true:
		sprinting = false
		sprint_ended.emit()
		sprint_update.paused = not sprinting
		sprint_regeneration_update.paused = sprinting
		
		speed -= 4

func _init() -> void:
	Global.player = self

## Health manager.
func health_manage(amount: float, type: int):
	if current_health[type] + amount <= health[type]:
		current_health[type] += amount
	else:
		current_health = health
	if current_health[type] <= 0:
		get_parent().toggle_pause()
