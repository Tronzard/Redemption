extends CharacterBody2D

signal  check_pickup(player_global_position: Vector2)

@export var gravity: float = 280.0

@onready var movement: Node = $Movement
@onready var animation: Node = $Animation
@onready var combat: Node = $Combat
@onready var camera_2d: Camera2D = $Camera2D


func _physics_process(delta: float) -> void:
	#Gravity Implementation
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	#Contoller Updates
	movement.process_movement(self, delta)
	combat.process_combat(self)
	animation.process_animation(self)

	move_and_slide()

	check_coin_pickup()


func check_coin_pickup() -> void:
	emit_signal("check_pickup", global_position)


func get_camera() -> Camera2D:
	return camera_2d
