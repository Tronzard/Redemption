extends CharacterBody2D

# --- Player parameters ---
@export var speed: float = 100.0
@export var jump_force: float = 150.0
@export var gravity: float = 280.0

@export var slide_speed: float = 220.0
@export var slide_time: float = 0.4

@export var max_jumps: int = 2

# ✅ Drag your Coin TileMapLayer here in the editor
@export var coin_layer_path: NodePath
@onready var coin_layer: TileMapLayer = get_node(coin_layer_path)

# --- State variables ---
var jump_count: int = 0
var is_sliding: bool = false
var slide_timer: float = 0.0
var slide_request: bool = false
var is_attacking: bool = false
var was_in_air: bool = false
var is_landing: bool = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	was_in_air = not is_on_floor()

	if not is_on_floor():
		velocity.y += gravity * delta
		is_sliding = false
	else:
		velocity.y = 0
		jump_count = 0

	var direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	var slide_held: bool = Input.is_action_pressed("ui_down")
	var slide_pressed: bool = Input.is_action_just_pressed("ui_down")

	if not is_on_floor() and slide_held:
		slide_request = true

	if not slide_held:
		slide_request = false

	if is_on_floor() and not is_sliding and direction != 0:
		if slide_pressed or slide_request:
			is_sliding = true
			slide_timer = slide_time
			slide_request = false

	if is_sliding:
		slide_timer -= delta

		var slide_dir: float = direction
		if slide_dir == 0.0:
			slide_dir = float(sign(velocity.x))
			if slide_dir == 0.0:
				slide_dir = -1.0 if anim.flip_h else 1.0

		velocity.x = lerp(velocity.x, slide_dir * slide_speed, 10 * delta)

		if slide_timer <= 0.0:
			is_sliding = false
	else:
		velocity.x = lerp(velocity.x, direction * speed, 10 * delta)

	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
		is_sliding = false
		jump_count += 1
		velocity.y = -jump_force

	if Input.is_action_just_pressed("ui_attack") and not is_attacking:
		is_attacking = true
		if is_sliding:
			anim.play("attack_slide")
		elif not is_on_floor():
			anim.play("attack_jump")
		elif direction != 0:
			anim.play("attack_run")
		else:
			anim.play("attack_idle")

	move_and_slide()

	# ✅ SAFE COIN COLLECTION
	check_coin_pickup()

	if was_in_air and is_on_floor():
		is_landing = true
		anim.play("land")

	update_animation(direction)


func check_coin_pickup() -> void:
	if coin_layer == null:
		return

	var local_pos = coin_layer.to_local(global_position)
	var tile_pos = coin_layer.local_to_map(local_pos)

	var source_id = coin_layer.get_cell_source_id(tile_pos)

	if source_id != -1:
		coin_layer.erase_cell(tile_pos)
		increase_points()


# ✅ EMPTY SCORE FUNCTION
func increase_points() -> void:
	pass


func update_animation(direction: float) -> void:
	if direction != 0:
		anim.flip_h = direction < 0
	elif velocity.x != 0:
		anim.flip_h = velocity.x < 0

	if is_attacking:
		if not anim.is_playing() or not anim.animation.begins_with("attack"):
			is_attacking = false
		else:
			return

	if is_landing:
		if is_sliding and is_on_floor():
			is_landing = false
		elif direction != 0 and is_on_floor():
			is_landing = false
		elif is_attacking:
			is_landing = false
		elif not anim.is_playing() or anim.animation != "land":
			is_landing = false
		else:
			return

	if is_sliding and is_on_floor():
		anim.play("slide")
		return

	if not is_on_floor():
		if velocity.y < 0:
			if jump_count == 1:
				anim.play("jump")
			else:
				anim.play("double_jump")
		else:
			anim.play("fall")
		return

	if direction == 0:
		anim.play("idle")
	else:
		anim.play("run")

#test
