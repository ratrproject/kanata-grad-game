extends Node2D

var tilemap = []
@export var tileWidth = 2000
@export var ScrollSpeed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	for j in self.get_children().size(): 
		tilemap.append([])
		var tile = self.get_children()[j]
		if tile.script.resource_path == 'res://Scripts/WorldTile.gd':
			tile.id = j
			tilemap[j] = tile

func _process(delta):
	position -= Vector2(ScrollSpeed * delta, 0)

func _shift_grid(new_tile):
	var v = new_tile.id
	
	if v > 0:
		var tile = tilemap.pop_front()
		tile.global_position.x = tilemap[tilemap.size()-1].global_position.x + tileWidth
		tilemap.push_back(tile)
		
	elif v < 0:
		var tile = tilemap.pop_back()
		tile.global_position.x = tilemap[0].global_position.x - tileWidth
		tilemap.push_front(tile)

	for j in tilemap.size():
		tilemap[j].id = j
