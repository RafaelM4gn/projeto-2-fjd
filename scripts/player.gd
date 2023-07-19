extends KinematicBody2D

export var max_speed = 100 
export var dash_speed = 150
export var dash_duration = 0.5 # afeta animacao
var dash_elapsed_time = 0.0
var walk_elapsed_time = 0.0
var is_dashing = false
var can_dash = true
var dash_direction = Vector2()
var current_dash_speed = 0
var current_speed = 0

signal dashing(is_dashing)

func _physics_process(delta):
	var direction = Vector2(0, 0)

	if is_dashing:
		dash_elapsed_time += delta # update elapsed time
		if dash_elapsed_time < dash_duration * 0.3: # Primeiros 20% do tempo do dash
			current_dash_speed = 200
		elif dash_elapsed_time < dash_duration * 0.6: # Entre 20% e 50% do tempo do dash
			current_dash_speed = 150
		else: # Restante do tempo do dash
			current_dash_speed = 50
		
		move_and_slide(dash_direction * current_dash_speed)
	else:
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
			
			
		if direction.x == 1:
			$PushRight.set_enabled(true)
		else:
			$PushRight.set_enabled(false)
			
		if $PushRight.is_colliding():
			var object = $PushRight.get_collider()
			object.move_and_slide(Vector2(30,0) * max_speed * delta)
			
		if direction.x == -1:
			$PushLeft.set_enabled(true)
		else:
			$PushLeft.set_enabled(false)
			
		if $PushLeft.is_colliding():
			var object = $PushLeft.get_collider()
			object.move_and_slide(Vector2(-30,0) * max_speed * delta)
			
		if direction.y == 1:
			$PushDown.set_enabled(true)
		else:
			$PushDown.set_enabled(false)
			
		if $PushDown.is_colliding():
			var object = $PushDown.get_collider()
			object.move_and_slide(Vector2(0,30) * max_speed * delta)
			
		if direction.y == -1:
			$PushUp.set_enabled(true)
		else:
			$PushUp.set_enabled(false)
			
		if $PushUp.is_colliding():
			var object = $PushUp.get_collider()
			object.move_and_slide(Vector2(0,-30) * max_speed * delta)

		if direction.length() > 0:
			walk_elapsed_time += delta
			var acceleration_factor = min(walk_elapsed_time / 0.1, 1)
			current_speed = max_speed * acceleration_factor
			direction = direction.normalized()
		else:
			walk_elapsed_time = 0

		move_and_slide(direction * current_speed)

		# Alterar a direção do personagem (esquerda ou direita)
		if direction.x > 0:
			$AnimatedSprite.scale.x = 1
		elif direction.x < 0:
			$AnimatedSprite.scale.x = -1

		# Selecionar animação baseada no movimento
		if direction.length() > 0:
			play_animation("walk")
		else:
			play_animation("idle")

		# Executar o dash quando o botão for pressionado
		if Input.is_action_just_pressed("dash") and can_dash:
			start_dash(direction)

func start_dash(direction):
	if !is_dashing and direction.length() > 0 and can_dash:
		is_dashing = true
		emit_signal("dashing", is_dashing)
		can_dash = false # for test
		dash_direction = direction.normalized()
		dash_elapsed_time = 0.0 # Reset elapsed time
		
		# Definir animação de dash e velocidade
		set_dash_animation_frame(direction, 0)
		$AnimatedSprite.speed_scale = 4.0
		$AnimatedSprite.play()
		
		get_tree().create_timer(dash_duration).connect("timeout", self, "end_dash")


func end_dash():
	is_dashing = false
	emit_signal("dashing", is_dashing)
	play_animation("idle")

func set_dash_animation_frame(direction, frame_index):
	var dash_animation = "dash_horizontal"
	if direction.x == 0:
		if direction.y < 0:
			dash_animation = "dash_up"
		elif direction.y > 0:
			dash_animation = "dash_down"
	
	$AnimatedSprite.animation = dash_animation
	$AnimatedSprite.frame = frame_index


func play_animation(base_animation_name):
	var animation_name = base_animation_name
	if animation_name == "idle":
		$AnimatedSprite.speed_scale = 2.25  # Velocidade normal para outras animações
	else:
		$AnimatedSprite.speed_scale = 1.0  # Velocidade normal para outras animações
	if can_dash:
		animation_name += "_with_dash"
	
	
	$AnimatedSprite.play(animation_name)

func allow_dash():
	can_dash = true
