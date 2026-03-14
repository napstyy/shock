class_name Ghost
extends Enemy

@export var spawn_from_air: bool = false

func _physics_process(delta: float) -> void:
	move(player.global_position)
	$AnimatedSprite2D.play("walk")
