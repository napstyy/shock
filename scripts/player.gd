extends Node2D

#@export var energy_bar: TextureProgressBar

var health := 5
var energy := 100.0:
	set(value):
		energy = clamp(value,0,100)
var energyregen = 1.0

func _ready() -> void:
	pass
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	body.queue_free()
	health -= 1
	if health <= 0:
		gameover()


func gameover():
	print("You died")
	get_tree().reload_current_scene()


func _on_energy_regen_timer_timeout() -> void:
	energy += 1.0
	#energy_bar.value = energy
	#print(energy)
