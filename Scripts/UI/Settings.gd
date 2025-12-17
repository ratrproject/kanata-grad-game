extends Control

var is_full_screen = true;
var music_volume = 100;
var sfx_volume = 100;
var voice_volume = 100;
var window_size = 0

var shake_on : bool = true

signal on_back_pressed

@export var master_bus_name := "Master"
@export var sfx_bus_name := "SFX"
@export var music_bus_name := "Music"
@export var voice_bus_name := "Voices"
@onready var _master_bus := AudioServer.get_bus_index(master_bus_name)
@onready var _sfx_bus := AudioServer.get_bus_index(sfx_bus_name)
@onready var _music_bus := AudioServer.get_bus_index(music_bus_name)
@onready var _voice_bus := AudioServer.get_bus_index(voice_bus_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	
	if OS.has_feature('web'):
		$GridContainer/FullscreenLabel.visible = false
		$GridContainer/FullScreenCheck.visible = false
		
	var settings = $GridContainer.get_children()
	settings = settings.filter(func(element): return element.visible && !(element is Label))
	settings.push_back($BackButton)
	
	for i in settings.size():
		var above = (i-1) % settings.size()
		var below = (i+1) % settings.size()
		
		settings[i].focus_neighbor_top = settings[above].get_path()
		settings[i].focus_neighbor_bottom = settings[below].get_path()
	
func _on_shake_on_toggled(toggled_on, save_setting = true):
	shake_on = toggled_on
	
	if save_setting:
		_save_settings()
		
func _on_full_screen_on_toggled(toggled_on, save_setting = true):
	is_full_screen = toggled_on
	if is_full_screen:
		if get_window().mode != Window.MODE_EXCLUSIVE_FULLSCREEN:
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
			get_window().move_to_center()
	else:
		if get_window().mode != Window.MODE_WINDOWED:
			get_window().mode = Window.MODE_WINDOWED
			get_window().move_to_center()
			get_window().size = Vector2i(1280, 720)
		
	if save_setting:
		_save_settings()

func _on_resolution_item_selected(index, save_setting = true):
	match index:
		0:
			get_window().size = Vector2i(1920, 1080)
			get_window().move_to_center()
		1:
			get_window().size = Vector2i(1280, 720)
			get_window().move_to_center()
		2:
			get_window().size = Vector2i(854, 480)
			get_window().move_to_center()
	
	window_size = index
	
	if save_setting:
		_save_settings()
	
func _on_music_slider_drag_ended(value, save_setting = true):
	music_volume = value
	AudioServer.set_bus_volume_db(_music_bus, linear_to_db(music_volume / 100))
	
	if save_setting:
		_save_settings()

func _on_sfx_slider_drag_ended(value, save_setting = true):
	sfx_volume = value
	AudioServer.set_bus_volume_db(_sfx_bus, linear_to_db(sfx_volume / 100))
	
	if save_setting:
		_save_settings()

func _on_voice_slider_drag_ended(value, save_setting = true):
	voice_volume = value
	AudioServer.set_bus_volume_db(_voice_bus, linear_to_db(voice_volume / 100))
	
	if save_setting:
		_save_settings()

func _save_settings():
	var config = ConfigFile.new()

	# Store some values.
	config.set_value("Player", "ShakeOn", shake_on)
	config.set_value("Player", "FullScreen", is_full_screen)
	config.set_value("Player", "WindowSize", window_size)
	config.set_value("Player", "MusicVolume", music_volume)
	config.set_value("Player", "SFXVolume", sfx_volume)
	config.set_value("Player", "VoicesVolume", voice_volume)

	# Save it to a file (overwrite if already exists).
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://settings.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		return

	#$GridContainer/ShakeCheck.set_block_signals(true)
	$GridContainer/FullScreenCheck.set_block_signals(true)
	$GridContainer/MusicSlider.set_block_signals(true)
	$GridContainer/SFXSlider.set_block_signals(true)
	$GridContainer/VoiceSlider.set_block_signals(true)
	
	# Iterate over all sections.
	for player in config.get_sections():
		# Fetch the data for each section.
		
		
		#shake_on = config.get_value("Player", "ShakeOn")
		#$GridContainer/ShakeCheck.button_pressed = shake_on
		
		if !OS.has_feature('web'):
			var isFullScreen = config.get_value("Player", "FullScreen")
			$GridContainer/FullScreenCheck.button_pressed = isFullScreen
			_on_full_screen_on_toggled(isFullScreen, false)
		
		#window_size = config.get_value("Player", "WindowSize")
		#$MarginContainer/VBoxContainer/GridContainer/ResolutionDropdown.select(window_size)
		#_on_resolution_item_selected(window_size, false)
		
		var music_vol = config.get_value("Player", "MusicVolume")
		if music_vol != null:
			$GridContainer/MusicSlider.value = music_vol
			_on_music_slider_drag_ended(music_vol, false)
		else:
			$GridContainer/MusicSlider.value = 100
			_on_music_slider_drag_ended(100, false)
		
		var sfx_vol = config.get_value("Player", "SFXVolume")
		if sfx_vol != null:
			$GridContainer/SFXSlider.value = sfx_vol
			_on_sfx_slider_drag_ended(sfx_vol, false)
		else:
			$GridContainer/SFXSlider.value = 100
			_on_sfx_slider_drag_ended(100, false)
		
		var voice_vol = config.get_value("Player", "VoicesVolume")
		if voice_vol != null:
			$GridContainer/VoiceSlider.value = voice_vol
			_on_voice_slider_drag_ended(voice_vol, false)
		else:
			$GridContainer/VoiceSlider.value = 100
			_on_voice_slider_drag_ended(100, false)
		
	#$GridContainer/ShakeCheck.set_block_signals(false)
	$GridContainer/FullScreenCheck.set_block_signals(false)
	$GridContainer/MusicSlider.set_block_signals(false)
	$GridContainer/SFXSlider.set_block_signals(false)
	$GridContainer/VoiceSlider.set_block_signals(false)
	
func _on_quit_pressed():
	get_tree().quit()

func _on_resume_button_pressed():
	$"..".unpause()

func _on_button_pressed():
	emit_signal("on_back_pressed")

func _grab_focus():
	var settings = $GridContainer.get_children()
	settings = settings.filter(func(element): return element.visible && !(element is Label))
	settings[0].grab_focus()
