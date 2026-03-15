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

#whole thing with this is we check if the enemy is attacking
#if yes, we wait until that ends so we can kill it
#bc it should die anyways
#if not then we go as normal

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
