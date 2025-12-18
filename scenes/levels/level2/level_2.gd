extends Node2D

@export var coin_layer_path: NodePath
@onready var coin_layer: TileMapLayer = get_node(coin_layer_path)
@onready var collected: Label = $UICanvasLayer/CoinUI/CoinContainer/Collected
@onready var total: Label = $UICanvasLayer/CoinUI/CoinContainer/Total
@onready var final_door: TileMapLayer = $FinalDoor
@onready var player: CharacterBody2D = $Player


var total_coin_count: int
var collected_coins: int = 0


func _ready() -> void:
	total_coin_count = coin_layer.get_used_cells().size()
	total.text ="/ " + str(total_coin_count)
	collected.text = str(collected_coins)


#test, remove
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P:
			unlock_gate()


func _on_player_check_pickup(p_player_global_pos: Vector2) -> void:
	if coin_layer == null:
		return

	var local_pos: Vector2 = coin_layer.to_local(p_player_global_pos)
	var tile_pos: Vector2i = coin_layer.local_to_map(local_pos)
	var source_id: int = coin_layer.get_cell_source_id(tile_pos)

	if source_id != -1:
		coin_layer.erase_cell(tile_pos)
		increase_points()


func increase_points() -> void:
	collected_coins += 1
	collected.text = str(collected_coins)
	
	if total_coin_count == collected_coins:
		unlock_gate()


func unlock_gate() -> void:
	var camera = player.get_camera()
	var original_offset = camera.global_position

	camera.follow_player = false
	player.set_process(false)

	#final door null
	var pan_tween = camera.create_tween().set_parallel(false)
	pan_tween.tween_property(camera, "global_position", final_door.global_position, 0.5)
	pan_tween.tween_property(final_door, "modulate:a", 0.0, 2)
	pan_tween.tween_property(camera, "global_position", original_offset, 0.5)
	await pan_tween.finished
	final_door.queue_free()
	
	camera.follow_player = true
	player.set_process(true)
