class_name Wraith
extends Enemy

func _ready() -> void:
	super()
	hp = 20
	speed = 40
	damage = 2


func _physics_process(delta: float) -> void:
	move(player.global_position)
