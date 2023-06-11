extends Node2D

@onready var start_position = $StartPosition

@onready var player = $Player

func _ready():
	# Get all nodes tagged as "traps"
	var traps = get_tree().get_nodes_in_group("traps")
	var my_array = [1,2,3, "hello"]
	my_array.append("world") # Add "world" at the end of the array
	my_array.remove_at(1) # Will remove 2 from the array
	my_array.erase("hello") # Will remove the value "hello" from the array
	print(my_array)
	print("Size of array : " + str(my_array.size()))

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
