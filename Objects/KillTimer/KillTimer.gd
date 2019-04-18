extends Node2D

signal killtimer_expired

var count_down = 5
var prev_count_down = 0
var counting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Container/TimerLabel.visible = false
	
	var player = get_tree().get_root().get_node("World/Player")
	self.connect("killtimer_expired", player, "_on_killtimer_expired")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counting:
		# Update the shot clock on screen
		count_down = $Timer.time_left
		$Container/TimerLabel.set_text(String(ceil(count_down)))
		
		if ceil(prev_count_down) != ceil(count_down):
			
			# Check for second tick to play sound
			var audio_player = AudioStreamPlayer.new()
			$Container.add_child(audio_player)
			audio_player.stream = load("res://Audio/SFX/Blip_select 9.wav")
			audio_player.play()
		
		prev_count_down = count_down
	
	show_kill_timer()

func show_kill_timer():
	var new_loc = Vector2()
	
	new_loc.x = $Container.rect_position.x - $Container.get_global_transform_with_canvas().get_origin().x
	new_loc.y = $Container.rect_position.y - $Container.get_global_transform_with_canvas().get_origin().y
	$Container.rect_position = new_loc

func start_countdown():
	# Show the countdown timer
	$Container/TimerLabel.visible = true
	# Start the clock
	$Timer.start();
	counting = true
	# Play countdown music
	#var gs = get_node("/root/gamestate")
	#gs.play_countdown_music()
	
func _on_key_carry():
	if not counting:
		start_countdown()

func _on_Timer_timeout():
	# Update timer display to show 0
	count_down = $Timer.time_left
	$Container/TimerLabel.set_text(String(ceil(count_down)))
	
	emit_signal("killtimer_expired")
