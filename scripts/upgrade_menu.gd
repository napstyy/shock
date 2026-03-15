extends Node

var cards_drawn = 3
var card_arr = []
var node_arr = []
var stationaryattacks = [
	Enums.ATTACK_NAME.THUNDERPILLAR, 
	Enums.ATTACK_NAME.BARRIERARC, 
	Enums.ATTACK_NAME.SPLITBOLT, 
	Enums.ATTACK_NAME.ROLLINGTHUNDER,
	Enums.ATTACK_NAME.SPARKGEYSER,
	Enums.ATTACK_NAME.CIRCUITBEAM,
	Enums.ATTACK_NAME.OVERLOAD,
	Enums.ATTACK_NAME.IONSTORM,
	Enums.ATTACK_NAME.VOLTSPHERE
	]
var pos_arr = [Vector2(160,180), Vector2(320,180), Vector2(480,180)]
var attack_arr: Array[Enums.ATTACK_NAME] = []
@onready var card_1: Upgrade = $Card1
@onready var card_2: Upgrade = $Card2
@onready var card_3: Upgrade = $Card3




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in get_tree().get_nodes_in_group("attacks"):
		attack_arr.append(x.attack_name)
	node_arr = [card_1,card_2,card_3]
	for nodes in node_arr:
		nodes.menuclosed.connect(_on_menu_closed)
	for i in range(node_arr.size()):
		draw_upgrades(i)
#Card 1 is 160,180, 2: 320, 180, 4: 480, 180

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_released("Attack2"): #TEST
			#draw_upgrades()
	pass

func draw_upgrades(idx): #TODO: When adding attacks, if there are no new ones in the pool, it errors
	#Check total attacks
	var randomatk = randomize_attack()
	var randomupg = randomize_upgrade()
	match attack_arr.size():
		1:#if only 1 attack, THIS WORKS
			#while attack_arr has randomatk, rerandomize, then check against other drawn cards
			while attack_arr.has(randomatk) or has_card(randomatk):
				randomatk = rerandomize_attack()
			#add atk card
			#node_arr[idx].attack_name = randomatk
			#node_arr[idx].upgrade_name = Enums.UPGRADE_TYPE.NONE
			#node_arr[idx].setup()
			#card_arr.append(node_arr[idx])
			add_card(idx,randomatk,Enums.UPGRADE_TYPE.NONE)
			#get_tree().current_scene.add_child(new_card)
			#print("I triggered")
			

		2,3:#else randomize. if attack,
			if attack_arr.has(randomatk):
				#randomize upgrade
				if stationaryattacks.has(randomatk) and randomupg == Enums.UPGRADE_TYPE.SPEED:#check for stationary
					randomupg = rerandomize_upgrade(randomatk)
				while has_card_upg(randomatk,randomupg):
					randomupg = rerandomize_upgrade(randomatk)

				#node_arr[idx].attack_name = randomatk
				#node_arr[idx].upgrade_name = randomupg
				#node_arr[idx].setup()
				#card_arr.append(node_arr[idx])
				add_card(idx,randomatk,randomupg)
			else:
				#add attack #TODO also check against others cards previously drawn
				#attack_arr.append(randomatk) #append after choosing
				while attack_arr.has(randomatk) or has_card(randomatk):
					randomatk = rerandomize_attack()

				#node_arr[idx].attack_name = randomatk
				#node_arr[idx].upgrade_name = Enums.UPGRADE_TYPE.NONE
				#node_arr[idx].setup()
				#card_arr.append(node_arr[idx])
				add_card(idx,randomatk,Enums.UPGRADE_TYPE.NONE)
				#TODO: connectsignal, addattacktoarray on select, set pos

		4:#only upgrades
			#TODO: randomize func for only within attacks held
			randomatk = randomize_owned_attack()
			if stationaryattacks.has(randomatk) and randomupg == Enums.UPGRADE_TYPE.SPEED:#Check for stationary
					randomupg = rerandomize_upgrade(randomatk)
			while has_card_upg(randomatk,randomupg):
					randomupg = rerandomize_upgrade(randomatk)
			#node_arr[idx].attack_name = randomatk
			#node_arr[idx].upgrade_name = randomupg
			#node_arr[idx].setup()
			#card_arr.append(node_arr[idx])
			add_card(idx,randomatk,randomupg)

func _on_menu_closed():
	print("close_menu")
	queue_free()

func add_card(index, atk, upg):
	node_arr[index].attack_name = atk
	node_arr[index].upgrade_name = upg
	node_arr[index].setup()
	card_arr.append(node_arr[index])

func randomize_attack():
	var randomatk = RandomNumberGenerator.new().randi_range(1,Enums.ATTACK_NAME.size()-1)
	#var randomatk= Enums.ATTACK_NAME.find_key(randomatkidx)
	return randomatk

func randomize_owned_attack():
	var randomatk = RandomNumberGenerator.new().randi_range(0,attack_arr.size()-1)
	#var randomatk= Enums.ATTACK_NAME.find_key(randomatkidx)
	return randomatk

func randomize_upgrade():
	var randomupg = RandomNumberGenerator.new().randi_range(1,Enums.UPGRADE_TYPE.size()-1)
	#var randomupg= Enums.UPGRADE_TYPE.find_key(randomupgidx)
	return randomupg

func rerandomize_attack():
	var tempatkarr = []
	for attack in Enums.ATTACK_NAME:
		tempatkarr.append(Enums.ATTACK_NAME[attack])
	for x in attack_arr:
		if tempatkarr.has(x):
			var idx = tempatkarr.find(x)
			tempatkarr.pop_at(idx)
	for x in card_arr:
		if tempatkarr.has(x.attack_name):
			var idx = tempatkarr.find(x.attack_name)
			tempatkarr.pop_at(idx)
	tempatkarr.pop_at(0) #Get rid of shockwave
	return tempatkarr.pick_random()

func rerandomize_upgrade(atk):
	var tempupgarr = []
	for upgrades in Enums.UPGRADE_TYPE:
		tempupgarr.append(Enums.UPGRADE_TYPE[upgrades])
	if stationaryattacks.has(atk): #Stationary shouldnt have speed
		var idx = tempupgarr.find(Enums.UPGRADE_TYPE.SPEED)
		tempupgarr.pop_at(idx)
	for x in card_arr:
		if x.attack_name == atk:
			if tempupgarr.has(x.upgrade_name):
				var idx = tempupgarr.find(x.upgrade_name)
				tempupgarr.pop_at(idx)
	tempupgarr.pop_at(0) #Get rid of none
	if tempupgarr.is_empty():
		print("NO MORE ATTACKS REMAINING")
	return tempupgarr.pick_random()

func has_card(atk):
	if not card_arr.is_empty():
		var has_atk = false
		for x in card_arr:
			if x.attack_name == atk:
				has_atk = true
		return has_atk
	elif card_arr.is_empty():
		return false

func has_card_upg(atk, upg):
	if not card_arr.is_empty():
		var has_upg = false
		for x in card_arr:
			if x.attack_name == atk:
				if x.upgrade_name == upg:
					has_upg = true
		return has_upg
	elif card_arr.is_empty():
		return false
