class_name Upgrade
extends Node

signal menuclosed
#enum ATTACK_NAME{
	#THUNDERPILLAR,
	#LIGHTNINGORB
#}
#enum UPGRADE_TYPE{
	#NONE,
	#AREA,
	#DAMAGE,
	#ENERGYCOST,
	#SPEED
#}
var upgrade_dict = {
	Enums.ATTACK_NAME.THUNDERPILLAR: {
		"AtkName": "Thunder Pillar",
		"Scene": preload("res://prefabs/attacks/thunderpillar.tscn").instantiate(),
		"Desc": "This should never be seen"
		},
	Enums.ATTACK_NAME.LIGHTNINGORB: {
		"AtkName": "Lightning Orb",
		"Scene": preload("res://prefabs/attacks/lightningorb.tscn").instantiate(),
		"Desc": "A condensed ball of lightning which bounds back and forth."
	},
	Enums.ATTACK_NAME.ATTACK3:{
		"AtkName": "TESTATK3",
		"Scene": "NOSCENE",
		"Desc": "TESTATK3"
	},
	Enums.ATTACK_NAME.ATTACK4:{
		"AtkName": "TESTATK4",
		"Scene": "NOSCENE",
		"Desc": "TESTATK4"
	}
}
var upgrade_names = { #Need a better way for scaling
	Enums.UPGRADE_TYPE.NONE: {
		"Name": "None",
		"Mod": 0
			},
	Enums.UPGRADE_TYPE.AREA: {
		"Name": "Area",
		"Mod": 5
		},
	Enums.UPGRADE_TYPE.DAMAGE: {
		"Name": "Damage",
		"Mod": 5
			},
	Enums.UPGRADE_TYPE.ENERGYCOST: {
		"Name": "Energy Cost",
		"Mod": 5
		},
	Enums.UPGRADE_TYPE.SPEED: {
		"Name": "Speed",
		"Mod": 60.0
		}
}
var attack_name: Enums.ATTACK_NAME
var upgrade_name: Enums.UPGRADE_TYPE
var is_in_tree = false
var atknode: Attack

@onready var card_name: RichTextLabel = $NinePatchRect/CardName
@onready var card_desc: RichTextLabel = $NinePatchRect/CardDesc

#if groups in attacks not in tree, upgrade, otherwise add to tree

func _init(att_name: Enums.ATTACK_NAME = Enums.ATTACK_NAME.SHOCKWAVE, upgr_name: Enums.UPGRADE_TYPE = Enums.UPGRADE_TYPE.NONE):
	attack_name = att_name
	upgrade_name = upgr_name
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for attacks in get_tree().get_nodes_in_group("attacks"):
		#if attacks.attack_name == self.attack_name:
			#is_in_tree = true
			#atknode = attacks
	#upgrade_dict[attack_name]["UpgName"] = upgrade_names[upgrade_name]["Name"] + "\n+"+ str(upgrade_names[upgrade_name]["Mod"])
	##print(upgrade_dict)
	#updateLabels()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addAttack(): #TODO need to test
	var atk = upgrade_dict[attack_name]["Scene"]
	#print(get_tree().current_scene)
	get_tree().current_scene.add_child(atk)
	atk.inputname = "Attack"+ str(get_tree().get_nodes_in_group("attacks").size())
	menuclosed.emit()

func addUpgrade():
	print("upgrade")
	match upgrade_name:
		Enums.UPGRADE_TYPE.AREA:
			atknode.upgrade_area(upgrade_names[upgrade_name]["Mod"])
		Enums.UPGRADE_TYPE.DAMAGE:
			atknode.attack_damage += upgrade_names[upgrade_name]["Mod"] #TODO: Scale this per atk maybe
		Enums.UPGRADE_TYPE.ENERGYCOST:
			atknode.energy_cost -= upgrade_names[upgrade_name]["Mod"]
		Enums.UPGRADE_TYPE.SPEED:
			atknode.movement_speed += upgrade_names[upgrade_name]["Mod"]
	#something, atknode.upgradename += scaling
	menuclosed.emit()

func updateLabels():
	card_name.text = upgrade_dict[attack_name]["AtkName"]
	if is_in_tree:
		card_desc.text = upgrade_dict[attack_name]["UpgName"] #Upgrade Names
	else:
		card_desc.text = upgrade_dict[attack_name]["Desc"] #AttackDesc


func _on_button_button_down() -> void:
	if is_in_tree:
		addUpgrade()
	else:
		addAttack()
		
func setup():
	for attacks in get_tree().get_nodes_in_group("attacks"):
		if attacks.attack_name == self.attack_name:
			is_in_tree = true
			atknode = attacks
	upgrade_dict[attack_name]["UpgName"] = upgrade_names[upgrade_name]["Name"] + "\n+"+ str(upgrade_names[upgrade_name]["Mod"])
	updateLabels()
