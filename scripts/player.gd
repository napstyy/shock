extends Node2D

#@export var energy_bar: TextureProgressBar

signal energychanged(nrg)
signal hpchanged(hp)
signal playerdied
var health := 5:
	set(value):
		health = value
		hpchanged.emit(health)
var energy := 100.0:
	set(value):
		energy = clamp(value,0,100)
		energychanged.emit(energy)
var energyregen = 1.0
@onready var shockwave: Attack = $Shockwave
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not animated_sprite_2d.is_playing():
		animated_sprite_2d.play("idle")
func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	#body.queue_free()
	body.attack()
	health -= 1
	shockwave.attack_triggered()
	if health <= 0:
		gameover()


func gameover():
	print("You died")
	playerdied.emit()
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.visible = false
	#get_tree().reload_current_scene()


func _on_energy_regen_timer_timeout() -> void:
	energy += 1.0
	#energy_bar.value = energy
	#print(energy)

func play_attack_anim(string):
	animated_sprite_2d.play(string)
