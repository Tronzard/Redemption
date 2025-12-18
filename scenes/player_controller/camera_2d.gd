extends Camera2D

@export var deadzone_size: Vector2 = Vector2(100, 60)
@export var easing_speed: float = 5.0
@export var max_look_ahead: float = 60.0
@export var look_ahead_smooth: float = 5.0
@export var idle_recenter_time: float = 3.0

var target_position: Vector2
var current_look_ahead: float = 0.0
var look_dir: int = 0
var idle_timer: float = 0.0
var follow_player: bool = true  # NEW: toggle following player

func _ready():
	target_position = global_position

func _process(delta: float):
	if not follow_player:
		return # skip player-follow logic during cinematic

	var player = get_parent()
	var player_pos = player.global_position

	# Determine horizontal direction input
	var direction = 0
	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1

	if direction != 0:
		look_dir = direction
		idle_timer = 0.0
	else:
		idle_timer += delta

	var desired_look = look_dir * max_look_ahead
	current_look_ahead = lerp(current_look_ahead, desired_look, look_ahead_smooth * delta)

	# Deadzone and easing
	if abs(offset.x) > deadzone_size.x / 2:
		target_position.x = player_pos.x
	elif idle_timer < idle_recenter_time:
		target_position.x = lerp(target_position.x, player_pos.x, easing_speed * delta)

	if abs(offset.y) > deadzone_size.y / 2:
		target_position.y = player_pos.y
	elif idle_timer < idle_recenter_time:
		target_position.y = lerp(target_position.y, player_pos.y, easing_speed * delta)

	# Recenter when idle
	if idle_timer >= idle_recenter_time:
		current_look_ahead = lerp(current_look_ahead, 0.0, look_ahead_smooth * delta)
		target_position = player_pos

	# Horizontal look-ahead
	var final_pos = Vector2(target_position.x + current_look_ahead, target_position.y)

	# Smoothly update camera
	global_position = global_position.lerp(final_pos, easing_speed * delta)
