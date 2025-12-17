extends Node2D

var tilemapFront = []
var tilemapMid = []
var tilemapBack = []
@export var tileWidth = 2000
@export var ScrollSpeed = 100
@export var FrontScrollSpeed = 120
@export var MidScrollSpeed = 80
@export var BackScrollSpeed = 40

var stopped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for j in $Background/Front.get_children().size(): 
		var tile = $Background/Front.get_children()[j]
		if tile.script.resource_path == 'res://Scripts/Map/WorldTile.gd':
			tile.id = j
			tilemapFront.push_back(tile)
			
	for j in $Background/Mid.get_children().size(): 
		var tile = $Background/Mid.get_children()[j]
		if tile.script.resource_path == 'res://Scripts/Map/WorldTile.gd':
			tile.id = j
			tilemapMid.push_back(tile)
		
	for j in $Background/Back.get_children().size(): 
		var tile = $Background/Back.get_children()[j]
		if tile.script.resource_path == 'res://Scripts/Map/WorldTile.gd':
			tile.id = j
			tilemapBack.push_back(tile)
			
	var checkpoints = $Checkpoints.get_children()
	for checkpoint in checkpoints:
		checkpoint.visible = true

func _process(delta):
	$Background/Front.position -= Vector2(FrontScrollSpeed * delta, 0)
	$Background/Mid.position -= Vector2(MidScrollSpeed * delta, 0)
	$Background/Back.position -= Vector2(BackScrollSpeed * delta, 0)

	if !stopped:
		$Checkpoints.position -= Vector2(ScrollSpeed * delta, 0)	

func _shift_front(new_tile):
	var v = new_tile.id
	
	if v > 0:
		var tile = tilemapFront.pop_front()
		tile.global_position.x = tilemapFront[tilemapFront.size()-1].global_position.x + tileWidth
		tilemapFront.push_back(tile)
		
	elif v < 0:
		var tile = tilemapFront.pop_back()
		tile.global_position.x = tilemapFront[0].global_position.x - tileWidth
		tilemapFront.push_front(tile)

	for j in tilemapFront.size():
		tilemapFront[j].id = j


func _shift_mid(new_tile):
	var v = new_tile.id
	
	if v > 0:
		var tile = tilemapMid.pop_front()
		tile.global_position.x = tilemapMid[tilemapMid.size()-1].global_position.x + tileWidth
		tilemapMid.push_back(tile)
		
	elif v < 0:
		var tile = tilemapMid.pop_back()
		tile.global_position.x = tilemapMid[0].global_position.x - tileWidth
		tilemapMid.push_front(tile)

	for j in tilemapMid.size():
		tilemapMid[j].id = j

func _shift_back(new_tile):
	var v = new_tile.id
	
	if v > 0:
		var tile = tilemapBack.pop_front()
		tile.global_position.x = tilemapBack[tilemapBack.size()-1].global_position.x + tileWidth
		tilemapBack.push_back(tile)
		
	elif v < 0:
		var tile = tilemapBack.pop_back()
		tile.global_position.x = tilemapBack[0].global_position.x - tileWidth
		tilemapBack.push_front(tile)

	for j in tilemapBack.size():
		tilemapBack[j].id = j

func hit_checkpoint():
	stopped = true
	
func cleared_checkpoint():
	stopped = false
