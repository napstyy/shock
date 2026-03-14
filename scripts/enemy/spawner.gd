extends Node2D
@export var waves: Array[Wave]
@onready var timer: Timer = $Timer
@onready var wave_timer: Timer = $WaveTimer
var current_wave: int = 0
var spawn_queue: Array[PackedScene] = []

@export var time_between_waves: float = 3.0

func _ready() -> void:
	start_wave()

func start_wave() -> void:
	if current_wave >= waves.size():
		print("all waves done")
		return #stops running when waves r done
	spawn_queue.clear()
	for entry in waves[current_wave].enemies:
		for i in entry.count:
			spawn_queue.append(entry.scene)
	spawn_queue.shuffle()
	timer.start()

func spawn() -> void:
	if spawn_queue.is_empty():
		timer.stop()
		current_wave += 1
		wave_timer.wait_time = time_between_waves
		wave_timer.start()
		return #finishes spawning everything then goes to next wave
	var enemy = spawn_queue.pop_back().instantiate() #spawns
	var side = [-1, 1].pick_random()
	
	if enemy.spawn_from_air:
		# airspawn
		enemy.global_position = Vector2(320 + side * 320, 50)
	else:
		# groudnspawn
		enemy.global_position = Vector2(320 + side * 320, 300)
	
	add_child(enemy)

func _on_timer_timeout() -> void:
	spawn()

func _on_wave_timer_timeout() -> void:
	start_wave()
