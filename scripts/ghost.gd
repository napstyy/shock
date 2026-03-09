class_name Ghost
extends Enemy

func _physics_process(delta: float) -> void:
	move(player.global_position)
