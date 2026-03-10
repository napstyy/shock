extends Node

var attack_arr: Array[Enums.ATTACK_NAME] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in get_tree().get_nodes_in_group("attacks"):
		attack_arr.append(x.attack_name)

#Card 1 is 160,180, 2: 320, 180, 4: 480, 180

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_upgrades():
	#Check total attacks
	#if wave == 1, construct only attacks
	#else randomize. if attack,
	pass
