extends CharacterBody2D

@export var player: CharacterBody2D
@export var speed: int = 50
@export var chase_speed: int = 150
@export var acceleration: int = 200

@onready var ray_cast_h: RayCast2D = $Path2D/PathFollow2D/AnimatedSprite2D/RayCastHorizontal
@onready var ray_cast_down: RayCast2D = $Path2D/PathFollow2D/AnimatedSprite2D/RayCastDown

@onready var timer: Timer = $Timer
@onready var sprite: AnimatedSprite2D = $Path2D/PathFollow2D/AnimatedSprite2D

var direction: Vector2
var left_bounds: Vector2
var right_bounds: Vector2
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

enum STATES {
	WANDER,
	CHASE,
}

var current_state = STATES.WANDER


func _ready() -> void:
	sprite.play("default")
	left_bounds = self.global_position  + Vector2(-200, 0)
	right_bounds = self.global_position  + Vector2(200, 0)


func _physics_process(delta: float) -> void:
	handle_movement(delta)
	change_direction()
	look_for_player()
	handle_gravity(delta)


func look_for_player() -> void:
	if ray_cast_h.is_colliding():
		var collider = ray_cast_h.get_collider()
		if collider == player:
			chase_player()
		elif current_state == STATES.CHASE:
			stop_chase()
	
	elif current_state == STATES.CHASE:
		stop_chase()


func chase_player() -> void:
	timer.stop()
	current_state = STATES.CHASE

func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()


func handle_movement(delta: float) -> void:
	if current_state == STATES.WANDER:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	
	elif current_state == STATES.CHASE:
		velocity = velocity.move_toward(direction * chase_speed, acceleration * delta)
	
	move_and_slide()


func change_direction() -> void:
	# Look for ledges
	if not ray_cast_down.is_colliding():
		# turn around, priority
		if direction.x == 1:
			direction = Vector2(-1, 0)
			sprite.scale.x = 1
		else:
			direction = Vector2(1, 0)
			sprite.scale.x = -1

		return

	if current_state == STATES.WANDER:
		if direction.x == 1:
			# moving right
			if self.position.x >= right_bounds.x:
				# flip to moving left
				direction = Vector2(-1, 0)
				sprite.scale.x = 1

		elif direction.x == -1:
			# moving left
			if self.position.x <= left_bounds.x:
				# flip to moving right
				direction = Vector2(1, 0)
				sprite.scale.x = -1

		else:
			# move left by default
			direction = Vector2(1, 0)

	else:
		# Chase state. Follow player
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			# flip to moving right
			sprite.scale.x = -1
		else:
			# flip moving to left
			sprite.scale.x = 1

func _on_timer_timeout() -> void:
	current_state = STATES.WANDER


func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = gravity * delta
	
