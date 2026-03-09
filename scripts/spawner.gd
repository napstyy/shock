extends Node2D

@export var ghost_scene: PackedScene
@export var wraith_scene: PackedScene
@export var spawn_interval: float = 2.0
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = spawn_interval

func spawn() -> void:
	var enemy_scene = [ghost_scene, wraith_scene].pick_random()
	var enemy = enemy_scene.instantiate()
	var side = [-1, 1].pick_random()
	enemy.global_position = Vector2(320 + side * 320, 300)
	add_child(enemy)


func _on_timer_timeout():
	spawn()
