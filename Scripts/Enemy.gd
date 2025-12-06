extends CharacterBody2D

@export var MaxHealth : float = 100
var health : float
var dying = false

func _ready():
	health = MaxHealth

func take_damage(damage):
	if dying:
		return
		
	health -= damage
	if health < 0:
		die()
	else:
		$DamageAnimation.play("Damage")

func die():
	dying = true
	$SpawnPoint.queue_free()
	$DamageAnimation.play("Death")

func remove():
	queue_free()
