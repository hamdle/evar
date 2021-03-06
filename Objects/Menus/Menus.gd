extends Node

var start_time
var pause_time
var paused = false
var showing_menu = false

func _ready():
	start_time = OS.get_ticks_msec()
	
	$Die.visible = false
	$Win.visible = false
	$Pause.visible = false

func _input(event):
	# Escape to Start screen shortcut
	if not showing_menu:
		if Input.is_action_just_pressed("escape"):
			_level_pause()

func player_died():
	# Set menu location
	#var player = get_tree().get_root().get_node("World/Player")
	var new_loc = Vector2()

	new_loc.x = $Die.rect_position.x - $Die.get_global_transform_with_canvas().get_origin().x
	new_loc.y = $Die.rect_position.y - $Die.get_global_transform_with_canvas().get_origin().y
	$Die.rect_position = new_loc
	
	$Die.visible = true
	_level_over($Die)
	
	# Play game over sound
	var audio_player = AudioStreamPlayer.new()
	$Die.add_child(audio_player)
	audio_player.stream = load("res://Audio/SFX/die_menu.wav")
	audio_player.play()
	
func player_win():
	$Win.visible = true
	
	# Set finish time
	var gs = get_node("/root/gamestate")
	var finish_time = (OS.get_ticks_msec() - start_time) / 1000.0
	var time_label = $Win/TimeLabel
	time_label.text = gs.calc_level_data(finish_time)
	#+ " J" + String(gs.local_jumps) \
	#+ " L" + String(gs.local_launches) \
	#+ " M" + String(gs.local_moves)
	
	# Set menu location
	#var player = get_tree().get_root().get_node("World/Player")
	var new_loc = Vector2()

	new_loc.x = $Win.rect_position.x - $Win.get_global_transform_with_canvas().get_origin().x
	new_loc.y = $Win.rect_position.y - $Win.get_global_transform_with_canvas().get_origin().y
	$Win.rect_position = new_loc
	
	# Update gamestate data
	gs.level_won(finish_time)
	
	# Set level over
	_level_over($Win)
	
	# Play win sound
	var audio_player = AudioStreamPlayer.new()
	$Win.add_child(audio_player)
	audio_player.stream = load("res://Audio/SFX/win_menu.wav")
	audio_player.volume_db = -10
	audio_player.play()

func _level_pause():
	paused = not paused
	
	if paused == false:
		start_time = start_time + (OS.get_ticks_msec() - pause_time)
	
	pause_time = OS.get_ticks_msec()
	
	# Show current time
	var current_time = (pause_time - start_time) / 1000.0
	var time_label = $Pause/TimeLabel
	time_label.text = String(current_time)
	# Set menu location
	#var player = get_tree().get_root().get_node("World/Player")
	var new_loc = Vector2()

	new_loc.x = $Pause.rect_position.x - $Pause.get_global_transform_with_canvas().get_origin().x
	new_loc.y = $Pause.rect_position.y - $Pause.get_global_transform_with_canvas().get_origin().y
	$Pause.rect_position = new_loc
	
	$Pause.visible = paused
	get_tree().paused = paused
	
	# Play jump sound
	var audio_player = AudioStreamPlayer.new()
	$Pause.add_child(audio_player)
	audio_player.stream = load("res://Audio/SFX/pause_menu.wav")
	audio_player.play()

func _level_over(menu):
	get_tree().paused = true
	showing_menu = true
	
	

# Signals

func _on_PlayAgainButton_pressed():
	var gs = get_node("/root/gamestate")
	gs.reload_scene()

func _on_NextLevelButton_pressed():
	var gs = get_node("/root/gamestate")
	gs.load_next_scene()

func _on_QuitButton_pressed():
	var gs = get_node("/root/gamestate")
	gs.load_scene("levelselect")

func _on_ResumeButton_pressed():
	_level_pause()

func _on_MenuButton_pressed():
	var gs = get_node("/root/gamestate")
	gs.load_scene("levelselect")
