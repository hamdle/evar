extends Node

func _ready():
		# Queue up some audio
	#var stream_ogg = load('res://Audio/Songs/Elvis_Herod_-_04_-_Fighting_Muzak.ogg')
	#var stream_player = $Start/AudioStreamPlayer
	#stream_player.play()
	pass


func _on_PlayButton_pressed():
	var gs = get_node("/root/gamestate")
	gs.arcade_mode()
	gs.select_character(gs.CHARACTER.MAIN)
	gs.load_scene("levelselect")

func _on_PlayButton_mouse_entered():
	var sp = $Sprite
	sp.flip_h = true

func _on_PlayButton_mouse_exited():
	var sp = $Sprite
	sp.flip_h = false


func _on_HowToPlayButton_pressed():
	var gs = get_node("/root/gamestate")
	gs.load_scene("howtoplay")


func _on_ControlsButton_pressed():
	var gs = get_node("/root/gamestate")
	gs.load_scene("controls")


func _on_CreditsButton_pressed():
	var gs = get_node("/root/gamestate")
	gs.load_scene("credits")
