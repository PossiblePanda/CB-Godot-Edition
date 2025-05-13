extends Node

@warning_ignore("unused_signal")
signal game_entered

const GAME_VERSION = "alpha-0"

var ingame: bool = false
var game: Game = null

var player: Player = null

func _init():
	DiscordRPC.app_id = 1261084467783798805
	DiscordRPC.details = "Open source SCP: Containment Breach recreation"
	DiscordRPC.large_image = "cbge_logo"
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	
	if DiscordRPC.get_is_discord_working():
		DiscordRPC.refresh()

func _process(_delta: float):
	if Input.is_action_just_pressed("fullscreen"):
		Config.toggle_setting("fullscreen")
