extends Node

signal game_entered

var ingame: bool = false
var game: Game = null

var mouse_sensitivity : int = 50

func _init():
	DiscordRPC.app_id = 1261084467783798805
	DiscordRPC.details = "Open source SCP: Containment Breach recreation"
	DiscordRPC.large_image = "cbge_logo"
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	
	DiscordRPC.refresh()
