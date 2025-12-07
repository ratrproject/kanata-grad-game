extends CharacterBody2D

signal on_death(enemy)

@export var MaxHealth : float = 100
var health : float
var dying = false
var activated = false

func _ready():
	health = MaxHealth
	$CollisionShape2D.disabled = true
	$SpawnPoint.active = false
	visible = false

func activate():
	$CollisionShape2D.set_deferred("disabled", false)
	$SpawnPoint.active = true
	visible = true
	activated = true

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
	$CollisionShape2D.disabled = true
	$SpawnPoint.queue_free()
	$DamageAnimation.play("Death")

func remove():
	on_death.emit(self)
	queue_free()
