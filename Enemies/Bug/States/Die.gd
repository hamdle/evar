extends Node

enum STATE { NULL, IDLE, PATROL, ATTACK, DIE }

const UP = Vector2(0, -1)
const GRAVITY = 12

export var carry_offset = Vector2(0, -50)

func enter(bug):
	print(bug.name + " DIE")
	
	var audio_player = AudioStreamPlayer.new()
	bug.add_child(audio_player)
	audio_player.stream = load("res://Audio/SFX/Blip_select 9.wav")
	audio_player.play()
	
	bug.die()
	pass

func exit(bug):
	pass
	
func update(bug, delta):
	pass
	
func handleInput(bug, event):
	pass
