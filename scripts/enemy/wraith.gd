class_name Wraith
extends Enemy

@export var spawn_from_air: bool = false

func _ready() -> void:
	super()
	hp = 20
	speed = 40
	damage = 2


func _physics_process(delta: float) -> void:
	move(player.global_position)
	$AnimatedSprite2D.play("walk")
