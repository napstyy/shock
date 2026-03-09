class_name Enemy
extends CharacterBody2D

var hp: float = 10
var speed: float = 80
var damage: float = 1

var player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func move(target_pos: Vector2) -> void:
	var direction = sign(target_pos.x - global_position.x)
	velocity.x = direction * speed
	move_and_slide()

func take_damage(amount: float) -> void:
	hp -= amount
	if hp <= 0:
		die()

func die() -> void:
	queue_free()
