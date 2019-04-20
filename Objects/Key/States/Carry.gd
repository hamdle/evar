extends Node

signal key_carry

enum STATE { NULL, HIDE, SHOW, CARRY, THROW }

const UP = Vector2(0, -1)
const GRAVITY = 12

export var carry_offset = Vector2(0, -50)

func enter(key):
	print(key.name + " CARRY")
	key.character.has_key = true
	var col = key.get_node("CollisionShape2D")
	col.disabled = true
	
	#var audio_player = AudioStreamPlayer.new()
	#key.add_child(audio_player)
	#audio_player.stream = load("res://Audio/SFX/key_carry.wav")
	#audio_player.play()
	
	# Make the key able to trigger col with black hole
	var player = get_tree().get_root().get_node("World/Player")
	player.set_key_thrown()
	
	# Connect signal for Carry state
	var killTimer = get_tree().get_root().get_node("World/KillTimer")
	self.connect("key_carry", killTimer, "_on_key_carry")
	emit_signal("key_carry")
	
func exit(key):
	pass
	
func update(key, delta):
	key.position = key.character.position + carry_offset
	
func handleInput(key, event):
	pass
