extends CharacterBody2D

signal on_death(enemy)

@export var MaxHealth : float = 100
var health : float
var dying = false
var activated = false

@export var States : Array
var current_state

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
	if(States.size() > 0):
		current_state = get_node(States[0])
		current_state.activate()
	
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
	
func _physics_process(delta):
	if current_state:
		current_state._process_state(self, delta)
		if current_state.is_complete():
			current_state.queue_free()
			States.pop_front()
			if(States.size() > 0):
				current_state = get_node(States[0])
				current_state.activate()
			else:
				current_state = null
