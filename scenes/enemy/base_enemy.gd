extends Node
class_name BaseEnemy

signal enemy_died()
signal give_contact_damage(contact_damage)

#Stats
@export var max_health: int = 10

var current_health: int


func _ready():
	current_health = max_health


func _on_body_entered(p_body):
	if p_body is Player:
		emit_signal("give_contact_damage")


func take_damage(p_amount: int) -> void:
	current_health -= p_amount
	if current_health <= 0:
		die()


func die() -> void:
	emit_signal("enemy_died")
	push_error("enemy die")
	queue_free()
