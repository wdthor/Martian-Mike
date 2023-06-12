extends Node2D

@onready var start_position = $StartPosition

@onready var player = $Player

func _ready():
	# Get all nodes tagged as "traps"
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
#		1st way to connect
#		trap.connect("touched_player", _on_trap_touched_player)
#		2nd way to connect (Godot4)
		trap.touched_player.connect(_on_trap_touched_player)

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_deathzone_body_entered(body):
	reset_position(body)
	
func reset_position(body):
	reset_player()


func _on_trap_touched_player():
	reset_player()
	
func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start_position.global_position
