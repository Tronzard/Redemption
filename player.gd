extends CharacterBody2D

@export var gravity: float = 280.0
@export var coin_layer_path: NodePath

@onready var coin_layer: TileMapLayer = get_node(coin_layer_path)

@onready var movement: Node = $Movement
@onready var animation: Node = $Animation
@onready var combat: Node = $Combat


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
	if coin_layer == null:
		return

	var local_pos: Vector2 = coin_layer.to_local(global_position)
	var tile_pos: Vector2i = coin_layer.local_to_map(local_pos)
	var source_id: int = coin_layer.get_cell_source_id(tile_pos)

	if source_id != -1:
		coin_layer.erase_cell(tile_pos)
		increase_points()


func increase_points() -> void:
	pass
