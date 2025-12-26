extends BaseEnemy

@onready var sprite: AnimatedSprite2D = $Path2D/PathFollow2D/AnimatedSprite2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var ray_cast: RayCast2D = $Path2D/PathFollow2D/AnimatedSprite2D/RayCast2D


var direction := 1  
@export var speed := 0.5 
@export var player: CharacterBody2D


func _ready() -> void:
	sprite.play("default")


func _process(delta: float) -> void:
	path_follow.progress_ratio += delta * 0.08
	
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider == player:
			path_follow.progress_ratio += delta * 0.2
		else:
			path_follow.progress_ratio += delta * 0.08
	
	else:
		path_follow.progress_ratio += delta * 0.08


func _physics_process(_delta: float) -> void:
	if path_follow.progress_ratio >= 0.5:
		sprite.flip_h = false
		ray_cast.scale.x =  1
		
	else:
		sprite.flip_h = true
		ray_cast.scale.x = - 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	_on_body_entered(body)
