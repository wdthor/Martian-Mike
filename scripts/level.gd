extends Node2D

@export var next_level: PackedScene = null
@export var is_final_level: bool = false
@export var mirror = false
@export var level_time = 5 # seconds needed to finish the level

@onready var start = $Start
@onready var exit  = $Exit
@onready var death_zone = $Deathzone
# Timer HUD (Heads Up Display)
@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer

var player = null

var timer_node = null
var time_left # actual time left

var win = false

func _ready():
	# Get first node tagged as "player" (created in Groups)
	# And assign it to player
	# Note : another way of doing @onready
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		if mirror:
			reverse_position()
		player.global_position = start.get_spawn_position()

	# Get nodes tagged as "traps" (created in Groups)
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
#		1st way to connect
#		trap.connect("touched_player", _on_trap_touched_player)
#		2nd way to connect (Godot4)
		trap.touched_player.connect(_on_trap_touched_player)
	
	# connect signals manually created to be reused on _ready
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_deathzone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	
	# Creates a new Timer and add it to the Level scene
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()
	
	# Another ex of creating a node manually
#	var cshape = CollisionShape2D.new()
#	cshape.name = "cshape name"
#	add_child(cshape)

func _on_level_timer_timeout():
	if !win:
		time_left -=1
		
		if time_left < 0:
			reset_player()
			time_left = level_time
		hud.set_time_label(time_left)


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
	
# We create the signal manually,
# so we don't have to connect a signal every time we create a new level
func _on_exit_body_entered(body):
	# check the body is Player (classname Player)
	if body is Player:
		# change_scene_to_packed() can be null and will throw an error
		if is_final_level || (next_level != null):
			exit.animate()
			player.active = false
			win = true
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(next_level)
			
func reverse_position():
	player.animated_sprite.flip_h = -1
	start.start_sprite.flip_h = -1
	start.spawn_position.set_position(Vector2(-12, -24))
	start.collision_shape.set_position(Vector2(-12, -3))
