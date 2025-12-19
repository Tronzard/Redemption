extends Node

@export var speed: float = 100.0
@export var jump_force: float = 150.0
@export var slide_speed: float = 160.0
@export var slide_time: float = 0.4
@export var max_jumps: int = 1

# Movement state
var jump_count: int = 0
var slide_direction: float = 0.0
var is_sliding: bool = false
var slide_timer: float = 0.0
var slide_request: bool = false
var was_in_air: bool = false


func process_movement(player: CharacterBody2D, delta: float) -> void:
	was_in_air = not player.is_on_floor()

	#normal movement
	var direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var slide_held: bool = Input.is_action_pressed("ui_down")
	var slide_pressed: bool = Input.is_action_just_pressed("ui_down")

	# Slide buffering
	if not player.is_on_floor() and slide_held:
		slide_request = true
	if not slide_held:
		slide_request = false

	# Start slide
	if player.is_on_floor() and not is_sliding and direction != 0.0:
		if slide_pressed or slide_request:
			is_sliding = true
			slide_timer = slide_time
			slide_request = false
			
			# Direction lock
			slide_direction = direction
			if slide_direction == 0.0:
				slide_direction = -1.0 if player.get_node("AnimatedSprite2D").flip_h else 1.0

	# Update slide
	if is_sliding:
		slide_timer -= delta
		player.velocity.x = slide_direction * slide_speed
		if slide_timer <= 0.0:
			is_sliding = false
	else:
		player.velocity.x = lerp(player.velocity.x, direction * speed, 10.0 * delta)

	# Jump
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
		is_sliding = false
		jump_count += 1
		player.velocity.y = -jump_force

	# Reset jump
	if player.is_on_floor():
		jump_count = 0
