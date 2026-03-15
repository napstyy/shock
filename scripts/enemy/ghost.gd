class_name Ghost
extends Enemy

@export var spawn_from_air: bool = true

func _ready() -> void:
	super()
	hp = 10
	speed = 30
	damage = 1

func move(target_pos: Vector2) -> void:
	var direction = (target_pos - global_position).normalized()
	velocity = direction * speed
	move_and_slide()


func _physics_process(delta: float) -> void:
	move(player.global_position)
	$AnimatedSprite2D.play("walk")
	

var is_attacking: bool = false

func attack() -> void:
	is_attacking = true
	set_physics_process(false)
	$AnimatedSprite2D.speed_scale = 4.0
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished
	is_attacking = false

func die() -> void:
	set_physics_process(false)
	if is_attacking:
		await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.speed_scale = 2.0
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	queue_free()
