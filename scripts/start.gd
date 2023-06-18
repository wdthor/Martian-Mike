extends StaticBody2D

@onready var spawn_position = $SpawnPosition

func get_spawn_position():
	return spawn_position.global_position
