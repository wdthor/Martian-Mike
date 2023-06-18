extends CharacterBody2D
class_name Player # name given to player

@export var gravity = 400
@export var jump_force = 200
@export var speed = 125

@onready var animated_sprite = $AnimatedSprite2D

# The player can move
var active = true

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
#		Prevents increasing the velocity more
		if velocity.y > 500:
			velocity.y = 500
	
	var direction = 0
	if active == true:
		if Input.is_action_just_pressed("jump") && is_on_floor():
			jump(jump_force)

	#	Input.get_axis will return -1 if move_left, 1 if move_right, 0 if none or both of them
		direction = Input.get_axis("move_left", "move_right")
#	Flip the sprite left if direction == -1 or flip right
#	If no key is pressed, direction = 0
	if direction != 0:
		animated_sprite.flip_h = direction == -1
	velocity.x = direction * speed
	move_and_slide()
	
	update_animations(direction)
	
func jump(force):
	velocity.y = -force
	
func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
