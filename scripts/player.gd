extends KinematicBody2D

export var speed = 200
export var dash_speed = 600
export var dash_duration = 0.3
var is_dashing = false
var can_dash = false
var dash_direction = Vector2()

func _physics_process(delta):
	var direction = Vector2(0, 0)

	if is_dashing:
		move_and_slide(dash_direction * dash_speed)
	else:
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
		direction = direction.normalized()
		move_and_slide(direction * speed)

		if Input.is_action_just_pressed("dash"):
			start_dash(direction)

func start_dash(direction):
	if !is_dashing and direction.length() > 0 and can_dash:
		is_dashing = true
		can_dash = false  # Consumir o dash
		dash_direction = direction.normalized()
		get_tree().create_timer(dash_duration).connect("timeout", self, "end_dash")

func end_dash():
	is_dashing = false

func allow_dash():
	can_dash = true

