extends CharacterBody2D
class_name BaseEnemy


signal enemy_died()

#Stats
@export var max_health: int = 100
@export var contact_damage: int = 10

var current_health: int


func _ready():
	current_health = max_health
	$Area2D.body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(contact_damage)


func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		die()


func die() -> void:
	emit_signal("enemy_died")
	queue_free()
