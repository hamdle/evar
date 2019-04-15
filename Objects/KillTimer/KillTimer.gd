extends Node2D

signal killtimer_expired

var count_down = 5
var counting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Container/TimerLabel.visible = false
	
	var player = get_tree().get_root().get_node("World/Player")
	self.connect("killtimer_expired", player, "_on_killtimer_expired")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counting:
		count_down = $Timer.time_left
		$Container/TimerLabel.set_text(String(round(count_down)))
	
	show_kill_timer()

func show_kill_timer():
	var new_loc = Vector2()
	
	new_loc.x = $Container.rect_position.x - $Container.get_global_transform_with_canvas().get_origin().x
	new_loc.y = $Container.rect_position.y - $Container.get_global_transform_with_canvas().get_origin().y
	$Container.rect_position = new_loc

func start_countdown():
	$Container/TimerLabel.visible = true
	$Timer.start();
	counting = true
	
func _on_key_carry():
	if not counting:
		start_countdown()

func _on_Timer_timeout():
	emit_signal("killtimer_expired")
	pass # Replace with function body.
