extends Node

var cards_drawn = 3
var card_arr = []
var pos_arr = [Vector2(160,180), Vector2(320,180), Vector2(480,180)]
var attack_arr: Array[Enums.ATTACK_NAME] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in get_tree().get_nodes_in_group("attacks"):
		attack_arr.append(x.attack_name)
	draw_upgrades()
#Card 1 is 160,180, 2: 320, 180, 4: 480, 180

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_upgrades():
	#Check total attacks
	var randomatk = randomize_attack()
	var randomupg = randomize_upgrade()
	match attack_arr.size():
		1:#if wave == 1/attackarrsize ==1, construct only new attacks
			#while attack_arr has randomatk, rerandomize, then check against other cards
			while attack_arr.has(randomatk) or has_card(randomatk):
				randomatk = randomize_attack()
			#add atk card
			var new_card = Upgrade.new(randomatk,Enums.UPGRADE_TYPE.NONE)
			card_arr.append(new_card)
			get_tree().current_scene.add_child(new_card)

		2,3:#else randomize. if attack,
			if attack_arr.has(randomatk): #TODO Check if has upgrade too
				#randomize upgrade
				while has_card_upg(randomatk,randomupg):
					randomupg = randomize_upgrade()

				var new_card = Upgrade.new(randomatk,randomupg)
				card_arr.append(new_card)
				get_tree().current_scene.add_child(new_card)
			else:
				#add attack #TODO also check against others cards previously drawn
				#attack_arr.append(randomatk) #append after choosing
				while attack_arr.has(randomatk) or has_card(randomatk):
					randomatk = randomize_attack()

				var new_card = Upgrade.new(randomatk,Enums.UPGRADE_TYPE.NONE)
				card_arr.append(new_card)
				get_tree().current_scene.add_child(new_card)
				#TODO: connectsignal, addattacktoarray on select, set pos

		4:#only upgrades
			#TODO: randomize func for only within attacks held
			randomatk = randomize_owned_attack()
			while has_card_upg(randomatk,randomupg):
					randomupg = randomize_upgrade()
			
			var new_card = Upgrade.new(randomatk,randomupg)
			card_arr.append(new_card)
			get_tree().current_scene.add_child(new_card)

func randomize_attack():
	var randomatkidx = RandomNumberGenerator.new().randi_range(0,Enums.ATTACK_NAME.size()-1)
	var randomatk= Enums.ATTACK_NAME.find_key(randomatkidx)
	return randomatk

func randomize_owned_attack():
	var randomatkidx = RandomNumberGenerator.new().randi_range(0,attack_arr.size()-1)
	var randomatk= Enums.ATTACK_NAME.find_key(randomatkidx)
	return randomatk

func randomize_upgrade():
	var randomupgidx = RandomNumberGenerator.new().randi_range(1,Enums.UPGRADE_TYPE.size()-1)
	var randomupg= Enums.UPGRADE_TYPE.find_key(randomupgidx)
	return randomupg

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
