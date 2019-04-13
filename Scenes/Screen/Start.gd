extends Node

func _ready():
		# Queue up some audio
	#var stream_ogg = load('res://Audio/Songs/Elvis_Herod_-_04_-_Fighting_Muzak.ogg')
	#var stream_player = $Start/AudioStreamPlayer
	#stream_player.play()
	pass

func _on_ArcadeButton2_pressed():
	var gs = get_node("/root/gamestate")
	gs.arcade_mode()
	gs.select_character(gs.CHARACTER.MAIN)
	gs.load_scene("levelselect")
