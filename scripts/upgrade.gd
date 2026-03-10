class_name Upgrade
extends Node

enum ATTACK_NAME{
	THUNDERPILLAR,
	LIGHTNINGORB
}
enum UPGRADE_TYPE{
	NONE,
	AREA,
	DAMAGE,
	ENERGYCOST,
	SPEED
}
var upgrade_dict = {
	ATTACK_NAME.THUNDERPILLAR: {
		"AtkName": "Thunder Pillar",
		"Scene": preload("res://prefabs/attacks/thunderpillar.tscn").instantiate(),
		"Desc": "This should never be seen"
		}
}
var upgrade_names = { #Need a better way for scaling
	UPGRADE_TYPE.NONE: {
		"Name": "None",
		"Mod": 0
			},
	UPGRADE_TYPE.AREA: {
		"Name": "Area",
		"Mod": 5
		},
	UPGRADE_TYPE.DAMAGE: {
		"Name": "Damage",
		"Mod": 5
			},
	UPGRADE_TYPE.ENERGYCOST: {
		"Name": "Energy Cost",
		"Mod": 5
		},
	UPGRADE_TYPE.SPEED: {
		"Name": "Speed",
		"Mod": 60.0
		}
}
var attack_name: ATTACK_NAME
var upgrade_name: UPGRADE_TYPE
var is_in_tree = false
var atknode: Attack

@onready var card_name: RichTextLabel = $NinePatchRect/CardName
@onready var card_desc: RichTextLabel = $NinePatchRect/CardDesc

#if groups in attacks not in tree, upgrade, otherwise add to tree

func _init(att_name: ATTACK_NAME = ATTACK_NAME.THUNDERPILLAR, upgr_name: UPGRADE_TYPE = UPGRADE_TYPE.AREA):
	attack_name = att_name
	upgrade_name = upgr_name
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for attacks in get_tree().get_nodes_in_group("attacks"):
		if attacks.attack_name == self.attack_name:
			is_in_tree = true
			atknode = attacks
	upgrade_dict[attack_name]["UpgName"] = upgrade_names[upgrade_name]["Name"] + "\n+"+ str(upgrade_names[upgrade_name]["Mod"])
	#print(upgrade_dict)
	updateLabels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addAttack(): #TODO need to test
	var atk = upgrade_dict[attack_name]["Scene"]
	get_tree().root.get_child(0).add_child(atk)
	atk.inputname = "Attack"+ str(get_tree().get_nodes_in_group("attacks").size())
	#close menu

func addUpgrade():
	print("upgrade")
	match upgrade_name:
		UPGRADE_TYPE.AREA:
			atknode.upgrade_area(upgrade_names[upgrade_name]["Mod"])
		UPGRADE_TYPE.DAMAGE:
			atknode.attack_damage += upgrade_names[upgrade_name]["Mod"] #TODO: Scale this per atk maybe
		UPGRADE_TYPE.ENERGYCOST:
			atknode.energy_cost -= upgrade_names[upgrade_name]["Mod"]
		UPGRADE_TYPE.SPEED:
			atknode.movement_speed += upgrade_names[upgrade_name]["Mod"]
	#something, atknode.upgradename += scaling
	#close menu

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
