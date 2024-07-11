class_name ButtonBase
extends MeshInstance3D

@export var enabled: bool = true

@export var interact_sound: AudioStream
@export var failed_sound: AudioStream


@onready var sound = $Sound
@onready var interaction_prompt: InteractionPrompt = $InteractionPrompt

signal interact
signal failed
