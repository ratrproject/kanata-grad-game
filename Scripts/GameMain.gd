extends Node2D

enum State { NONE, FIRING, LAUNCH, END }

var state = State.NONE

var elapsed_time : float = 0.0
var gigis_fired : int = 1

var playerObj = preload("res://Player/doki.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = playerObj.instantiate()
	$Launcher.add_child(player)
	#$MainCamera.target = player
	changeToFiring()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed_time += delta

func firing_selected(value):
	var cursor = get_tree().get_nodes_in_group("Cursor")[0]
	var dokiHead = get_tree().get_nodes_in_group("DokiHead")[0]
	var dir = cursor.global_position - dokiHead.global_position	
	changeToLaunch(value, dir)

func changeToFiring():
	if state != State.FIRING:
		state = State.FIRING
		get_tree().call_group('Firing', 'state_entered')
	
func changeToLaunch(value, direction):
	if state != State.LAUNCH:
		state = State.LAUNCH
		get_tree().call_group('Launch', 'state_entered', value, direction)
	
func character_stopped():
	var player = playerObj.instantiate()
	$Launcher.add_child(player)
	$MainCamera.target = player
	changeToFiring()
	gigis_fired += 1
	
func goal_reached():
	var goals : Array = get_tree().get_nodes_in_group('Goal')
	goals = goals.filter(func(node): return node.dying == false)
	if goals.size() == 0:
		if state != State.END:
			state = State.END
			get_tree().call_group("EndMenu", "update_time", elapsed_time, gigis_fired)
			$CanvasLayer._changeState($CanvasLayer.States.END)
