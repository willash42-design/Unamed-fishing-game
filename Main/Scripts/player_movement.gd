


extends CharacterBody2D

@export var speed: float = 120.0
@export var tile_size: int = 16

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var moving := false
var target_position := Vector2.ZERO
var facing := Vector2.DOWN

func _physics_process(delta):
	if moving:
		var distance = position.distance_to(target_position)
		var step = min(speed * delta, distance)

		var collision = move_and_collide(facing * step)

		if collision:
			moving = false
			stop_walking()
			return

		if distance <= step:
			position = target_position
			moving = false

	if not moving:
		var direction := Vector2.ZERO

		if Input.is_action_pressed("move_up"):
			direction = Vector2.UP
		elif Input.is_action_pressed("move_down"):
			direction = Vector2.DOWN
		elif Input.is_action_pressed("move_left"):
			direction = Vector2.LEFT
		elif Input.is_action_pressed("move_right"):
			direction = Vector2.RIGHT

		if direction != Vector2.ZERO:
			start_movement(direction)
		else:
			stop_walking()

func start_movement(direction: Vector2):
	facing = direction
	target_position = position + direction * tile_size
	moving = true

	var animation = ""

	if direction == Vector2.UP:
		animation = "Walk_Up"
	elif direction == Vector2.DOWN:
		animation = "Walk_Down"
	elif direction == Vector2.LEFT:
		animation = "Walk_Left"
	elif direction == Vector2.RIGHT:
		animation = "Walk_Right"

	if sprite.animation != animation:
		sprite.play(animation)
	elif not sprite.is_playing():
		sprite.play()

func stop_walking():
	sprite.stop()
	sprite.frame = 0
