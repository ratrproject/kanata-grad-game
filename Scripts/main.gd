extends Node2D

var current_level = 1
var max_level = 1
var best_times : Array

var MainMenu = preload("res://Scenes/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	load_main_menu()

func load_level(level, changeTrack = true):
	current_level = level
	for n in $Node2D.get_children():
		$Node2D.remove_child(n)
		n.queue_free()
		
	Spawning.reset_bullets()
	
	var LevelObj = load("res://Levels/level_" + str(level) + ".tscn")
	var lvl = LevelObj.instantiate()
	$Node2D.add_child(lvl)
	
	if (changeTrack || $Jukebox/MenuBGM.playing):
		for n in $Jukebox.get_children():
			n.stop()
		$Jukebox/LevelBGM.play()

func restart_level():
	load_level(current_level, false)
	
func load_main_menu(as_credits = false):
	for n in $Node2D.get_children():
		$Node2D.remove_child(n)
		n.queue_free()
		
	Spawning.reset_bullets()
	
	var menu = MainMenu.instantiate()
	$Node2D.add_child(menu)
	
	for n in $Jukebox.get_children():
		n.stop()
	$Jukebox/MenuBGM.play()
	
func exit_level():
	load_main_menu()

func next_level():
	if current_level >= 12:
		load_main_menu(true)
	else:
		load_level(current_level + 1)

func save():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)

	var save_dict = {
		"key" : "Progress",
		"max_level" : max_level,
		"best_times" : best_times,
	}
	
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(save_dict)

	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	var save_nodes = get_tree().get_nodes_in_group("Persist")
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		
		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
			
		# Get the data from the JSON object.
		var node_data = json.data
		
		if node_data["key"] == "Progress":
			max_level = node_data["max_level"]
			best_times = node_data["best_times"]
			
func _on_victory():
	if best_times.size() < current_level:
		best_times.push_back($Node2D/GameMain.elapsed_time)
	elif best_times[current_level-1] >= $Node2D/GameMain.elapsed_time:
		best_times[current_level-1] = $Node2D/GameMain.elapsed_time
	
	if current_level + 1 > max_level:
		max_level = current_level + 1
	
	save()
