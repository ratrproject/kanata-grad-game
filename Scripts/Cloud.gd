extends Sprite2D

@export var frameCount = 6
@export var minSpeed = 50
@export var maxSpeed = 100
@export var minSize = 2.5
@export var maxSize = 4.5

var xDir = 1
var speed = 0
var dying = false
var onScreen = false

var maxDistance = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	var frame = randi() % frameCount
	self.frame = frame
	
	var size = randf_range(minSize,maxSize)
	self.scale = Vector2(size,size)
	
	speed = randf_range(minSpeed,maxSpeed)
	
	var xflip = randi() % 2
	self.flip_h = xflip
	
	var yflip = randi() % 2
	self.flip_v = yflip
	
	xDir = -1
	#var dir = randi() % 2
	#if dir == 0:
	#	xDir = 1
	#else:
	#	xDir = -1
	
	var color_rang = randf_range(0.8, 1.1)
	modulate = Color(color_rang,color_rang,color_rang)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = xDir * speed	
	position.x += velocity * delta
	
	if global_position.x < $"../..".global_position.x - maxDistance:
		call_deferred("queue_free")
	elif global_position.x > $"../..".global_position.x  + $"../..".width + maxDistance:
		call_deferred("queue_free")
