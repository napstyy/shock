extends Node2D
@export var waves: Array[Wave]
@onready var timer: Timer = $Timer
@onready var wave_timer: Timer = $WaveTimer
@onready var wave_label: RichTextLabel = $RichTextLabel


var current_wave: int = 0
var spawn_queue: Array[PackedScene] = []

@export var time_between_waves: float = 3.0
var upgrade_menu


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
	#print(get_tree().get_nodes_in_group("enemies")) #TEST
	if spawn_queue.is_empty() and not get_tree().get_nodes_in_group("enemies").is_empty():
		return
	elif spawn_queue.is_empty() and get_tree().get_nodes_in_group("enemies").is_empty():
		timer.stop()
		current_wave += 1
		
		#TEST
		if current_wave == 10:
			wave_label.text = "You win!"
			wave_label.visible = true
			return #TEST Probably bring up game over screen
		upgrade_menu = preload("res://prefabs/upgrademenu.tscn").instantiate()
		get_tree().current_scene.add_child(upgrade_menu)
		upgrade_menu.upgradeclosed.connect(_on_upgrade_closed)
		#wave_timer.wait_time = time_between_waves
		#wave_timer.start()
		return #finishes spawning everything then goes to next wave
	var enemy = spawn_queue.pop_back().instantiate() #spawns
	var side = [-1, 1].pick_random()
	
	if enemy.spawn_from_air:
		# airspawn
		enemy.global_position = Vector2(320 + side * 320, 50+float(randi_range(-50,200)))
		#print(enemy.global_position)
	else:
		# groudnspawn
		enemy.global_position = Vector2(320 + side * 320, 300)
	
	add_child(enemy)

func _on_timer_timeout() -> void:
	timer.wait_time = 1.5 + randf_range(0.3,1.3) #TEST
	spawn()

func _on_wave_timer_timeout() -> void:
	wave_label.visible = false #TEST
	start_wave()

func _on_upgrade_closed(): #TEST
	wave_timer.wait_time = time_between_waves
	wave_timer.start()
	wave_label.text = "Wave " + str(current_wave+1)
	wave_label.visible = true
