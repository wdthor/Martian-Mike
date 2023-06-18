extends StaticBody2D

@onready var spawn_position = $SpawnPosition
@onready var start_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

func get_spawn_position():
	return spawn_position.global_position
