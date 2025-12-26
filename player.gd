extends CharacterBody2D
class_name Player

signal check_pickup(player_global_position: Vector2)
signal game_over()

@export var gravity: float = 280.0
@export var health: int = 3

@onready var movement: Node = $Movement
@onready var animation: Node = $Animation
@onready var combat: Node = $Combat
@onready var camera_2d: Camera2D = $Camera2D
@onready var hearts = $Camera2D/ui/HP.get_children()
@onready var mana = $Camera2D/ui/MP.get_children()


@export var max_hp := 3
@export var max_mp := 3

var hp := max_hp
var mp := 0 

@export var hp_full_region := Rect2(20.383, 1.519, 12.662, 10.679)
@export var hp_empty_region := Rect2(32.403, 1.519, 12.662, 10.679)
@export var mp_full_region := Rect2(20.026, 37.628, 11.537, 10.891)
@export var mp_empty_region := Rect2(31.481, 37.628, 11.537, 10.891)

var health_points: Array = [1, 1, 1]
var mana_points: Array = [1, 1, 1]

@onready var hp_ui: Node = $Camera2D/ui/HP


func _ready() -> void:
	update_hearts()
	update_mana()


func update_hearts():
	for i in range(max_hp):
		var sprite: Sprite2D = hearts[i]
		sprite.region_rect = hp_full_region if i < hp else hp_empty_region

func update_mana():
	for i in range(max_mp):
		var sprite: Sprite2D = mana[i]
		sprite.region_rect = mp_full_region if i < mp else mp_empty_region


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


func _on_idle_walk_enemy_give_contact_damage() -> void:
	push_error("enter")
	health -= 1
	
	for child in range (health_points.size() -1, -1, -1):
		if health_points[child] == 1:
			health_points[child] = 0
			
			var sprite = hp_ui.get_children()[child]
			sprite.region_rect = hp_empty_region
			break
			
	#add damage hit triggers, sound / animation
	
	if health <= 0:
		push_error("Dead")
		handle_game_over() 


func handle_game_over() -> void:
	emit_signal("game_over")
	pass
