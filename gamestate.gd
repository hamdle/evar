extends Node

enum MODE { ARCADE }
enum CHARACTER { MAIN }

var current_level_key = "none"
const number_of_levels = 18
var level_map = {
	"none": null,
	"start": "res://Scenes/Screen/Start.tscn",
	"howtoplay": "res://Scenes/Screen/HowToPlay.tscn",
	"controls": "res://Scenes/Screen/Controls.tscn",
	"credits": "res://Scenes/Screen/Credits.tscn",
	"levelselect": "res://Scenes/Screen/Arcade.tscn",
	"winscreen": "res://Scenes/Screen/WinScreen.tscn",
	
	"level1": "res://Scenes/Arcade/Level1.tscn",
	"level2": "res://Scenes/Arcade/Level2.tscn",
	"level3": "res://Scenes/Arcade/Level3.tscn",
	"level4": "res://Scenes/Arcade/Level4.tscn",
	"level5": "res://Scenes/Arcade/Level5.tscn",
	"level6": "res://Scenes/Arcade/Level6.tscn",
	
	"level7": "res://Scenes/Arcade/Level7.tscn",
	"level8": "res://Scenes/Arcade/Level8.tscn",
	"level9": "res://Scenes/Arcade/Level9.tscn",
	"level10": "res://Scenes/Arcade/Level10.tscn",
	"level11": "res://Scenes/Arcade/Level11.tscn",
	"level12": "res://Scenes/Arcade/Level12.tscn",
	
	"level13": "res://Scenes/Arcade/Level13.tscn",
	"level14": "res://Scenes/Arcade/Level14.tscn",
	"level15": "res://Scenes/Arcade/Level15.tscn",
	"level16": "res://Scenes/Arcade/Level16.tscn",
	"level17": "res://Scenes/Arcade/Level17.tscn",
	"level18": "res://Scenes/Arcade/Level18.tscn",
}

var level_data = {
	"level1": "4-0",
	"level2": "0-0",
	"level3": "0-0",
	"level4": "0-0",
	"level5": "0-0",
	"level6": "0-0",
	
	"level7": "0-0",
	"level8": "0-0",
	"level9": "0-0",
	"level10": "0-0",
	"level11": "0-0",
	"level12": "0-0",
	
	"level13": "0-0",
	"level14": "0-0",
	"level15": "0-0",
	"level16": "0-0",
	"level17": "0-0",
	"level18": "0-0",
}

var time_tables = {
	"level1": [10,5],
	"level2": [14,10],
	"level3": [38,28],
	"level4": [17,12],
	"level5": [22,15],
	"level6": [15,10],
	
	"level7": [10,5],
	"level8": [10,5],
	"level9": [10,5],
	"level10": [10,5],
	"level11": [10,5],
	"level12": [10,5],
	
	"level13": [10,5],
	"level14": [10,5],
	"level15": [10,5],
	"level16": [10,5],
	"level17": [10,5],
	"level18": [10,5],
}

var current_scene_instance = null
var current_mode = null
var current_character = null

# Stat variables
var local_jumps = 0
var local_launches = 0
var local_moves = 0

# Audio
var audio_player

func _ready():
	# Get main scene
	var root = get_tree().get_root()
	current_scene_instance = root.get_child(root.get_child_count() - 1)
	# Bypass project settings > main scene
	# load_scene("arcade")
	
	# Default mode
	arcade_mode()
	# Default Druplicon character
	select_character(CHARACTER.MAIN)
	
	# Init audio stream
	audio_player = AudioStreamPlayer.new()
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -10)
	# Add audio track stream
	#current_scene_instance.add_child(audio_player)
	#audio_player.stream = load("res://Audio/Tracks/song_for_someone.ogg")
	#audio_player.play()
	

# Scene loading
func load_next_scene():
	var i = current_level_key.to_int() + 1
	var key = "level" + str(i)
	print(key)
	if i > number_of_levels:
		load_scene("levelselect")
	elif key == "level7":
		load_scene("winscreen")
	else:
		load_scene(key)
	pass

func reload_scene():
	load_scene(current_level_key)
	pass
	
func load_scene(key):
	current_level_key = key
	var res = level_map[current_level_key]
	
	# Change background color
	# Black
	#VisualServer.set_default_clear_color(Color(0,0,0))
	#match key:
	#	"none":
	#		VisualServer.set_default_clear_color(Color("#131313"))
	#	"start":
	#		VisualServer.set_default_clear_color(Color("#131313"))
	#	"character":
	#		VisualServer.set_default_clear_color(Color("#131313"))
	#	"levelselect":
	#		VisualServer.set_default_clear_color(Color("#131313"))
	
	call_deferred("_deferred_load_scene", res)

func _deferred_load_scene(res):
	
	# Get Audio stream
	#var root = get_tree().get_root()
	#var stream = current_scene_instance.get_child(root.get_child_count())
	
	# Stop audio from playing music first
	audio_player.stop()
	# Immediately release current scene
	current_scene_instance.free()
	
	# Reset level stats
	local_jumps = 0
	local_launches = 0
	local_moves = 0
	
	# Load level resource
	var s = ResourceLoader.load(res)
	# And create an instance
	current_scene_instance = s.instance()
	# Add instance to node tree
	get_tree().get_root().add_child(current_scene_instance)
	# SceneTree.change_scene() API compatibility
	get_tree().set_current_scene(current_scene_instance)
	# Make sure the node tree is not paused
	get_tree().paused = false
	
	# Load audio tracks and music
	var audio_clip = get_level_audio_track(res)
	if audio_clip != null:
		get_tree().get_root().add_child(audio_player)
		audio_player.stream = load(audio_clip)
		audio_player.play()

# Complete level
func level_won(finish_time):
	# Create level entry
	var entry = calc_level_data(finish_time)
	update_level_data(entry, finish_time)
	# Unlock next level
	unlock_next_level()
	
func unlock_next_level():
	var i = current_level_key.to_int() + 1
	var key = "level" + str(i)
	# Unlock level (code 4) if there is no data
	if i <= number_of_levels:
		if level_data[key] == "0-0":
			level_data[key] = "4-0"

# Support func - returns: is this a actual gameplay level?
func get_level_audio_track(res):
	# TODO: rewrite this using a for loop
	if res == level_map["level1"]:
		return "res://Audio/SFX/level_start_1.wav"
	if res == level_map["level2"]:
		return "res://Audio/SFX/level_start_2.wav"
	if res == level_map["level3"]:
		return "res://Audio/SFX/level_start_3.wav"
	if res == level_map["level4"]:
		return "res://Audio/SFX/level_start_4.wav"
	if res == level_map["level5"]:
		return "res://Audio/SFX/level_start_5.wav"
	if res == level_map["level6"]:
		return "res://Audio/SFX/level_start_6.wav"
	#if res == level_map["levelselect"]:
	#	return "res://Audio/SFX/level_start_3.wav"
		
	return null

func play_countdown_music():
	#audio_player.stop()
	#audio_player.stream = load("res://Audio/Tracks/really_dangerous.ogg")
	#audio_player.play()
	pass
	
# Game mode
func arcade_mode():
	current_mode = MODE.ARCADE

# Character select
func select_character(character):
	current_character = character

func calc_level_data(finish_time):
	# Calculate level_data entry
	var scores = time_tables[current_level_key]
	var star_rating = "1"
	if finish_time < scores[0]:
		star_rating = "2"
	if finish_time < scores[1]:
		star_rating = "3"
	
	var entry = star_rating + "-" + format_time(finish_time)
	return entry

# entry is a fully formed str
# ex. "2-00:01:23"
func update_level_data(entry, finish_time):
	# TODO - check if better than current entry
	level_data[current_level_key] = entry

# Time formatter
func format_time(time):
	#var formatted = String()
	var formatted = str(stepify(time, 0.001))
	# Convert to 0:00
	#var b = time - int(time)
	#var c = stepify(b, 0.01)
	#var d = int(c * 100)
	#formatted = str(int(time)) + ":" + str(d)
	
	return formatted