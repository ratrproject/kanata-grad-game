extends Node2D

var height : float = 100
var width : float = 100

@export var maxClouds = 10
@export var initialClouds = 3
@export var SpawnDistance = 1111
@export var cloudRange : Rect2
var rng : RandomNumberGenerator

const Cloud = preload("res://Scenes/cloud.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	width = width * $Sprite2D.scale.x
	height = height * $Sprite2D.scale.y
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	$Sprite2D.visible = false
	
	for _i in range(initialClouds):
		_spawnCloud(_random_inside_rect())

func get_random_position_off_screen():
	var cam = $"../MainCamera/Camera2D"
	var cam_pos = cam.get_global_position()

	var randx = rng.randi_range(0,1)
	var randy = rng.randf_range(0, cloudRange.size.y)
	
	if randx == 0:
		randx = -1
	
	var x = cam_pos.x + randx * SpawnDistance
	var y = global_position.y - randy
	
	return Vector2(x,y)

func _random_inside_rect():
	var randx = rng.randf_range(0, width)
	var randy = rng.randf_range(0, height)
	
	return global_position + Vector2(randx, randy)

func _spawnCloud(pos):
	if $Clouds.get_child_count() < maxClouds:
		var cloud = Cloud.instantiate()
		$Clouds.add_child(cloud)
		cloud.global_position = pos

func _on_timer_timeout():
	_spawnCloud(_random_inside_rect())
