extends Node2D

@onready var start = $Start

var player = null

func _ready():
	# Get first node tagged as "player" (created in Groups)
	# And assign it to player
	# Note : another way of doing @onready
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.get_spawn_position()

	# Get nodes tagged as "traps" (created in Groups)
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
	player.global_position = start.get_spawn_position()
