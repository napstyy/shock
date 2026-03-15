class_name Geist
extends Enemy

@export var spawn_from_air: bool = true

func _ready() -> void:
	super()
	hp = 10
	speed = 50
	damage = 1

func move(target_pos: Vector2) -> void:
	var direction = (target_pos - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func attack() -> void:
	$AnimatedSprite2D.play("attack")

func _physics_process(delta: float) -> void:
	move(player.global_position)
	$AnimatedSprite2D.play("walk")
