extends CharacterBody2D

@export var gravity = 400
@export var jump_force = 200
@export var speed = 125

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
#		Prevents increasing the velocity more
		if velocity.y > 500:
			velocity.y = 500
		print(velocity.y)
		
	if Input.is_action_just_pressed("jump"):
		velocity.y += -jump_force

#	Input.get_axis will return -1 if move_left, 1 if move_right, 0 if none or both of them
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	move_and_slide()
