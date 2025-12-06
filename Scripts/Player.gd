extends Node2D
@export var speed = 400

func _physics_process(delta: float):
	var input_direction : Vector2 = Input.get_vector("left", "right", "up", "down")
	var velocity : Vector2 = input_direction * speed * delta
	position += velocity
