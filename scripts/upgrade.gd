class_name Upgrade
extends Node

enum ATTACK_NAME{
	THUNDERPILLAR
}
enum UPGRADE_TYPE{
	NONE,
	AREA,
	DAMAGE,
	ENERGYCOST,
	SPEED
}
var attack_name: ATTACK_NAME
var upgrade_name: UPGRADE_TYPE
var is_in_tree = false
var atknode: Attack
#if groups in attacks not in tree, upgrade, otherwise add to tree

func _init(att_name: ATTACK_NAME = ATTACK_NAME.THUNDERPILLAR, upgr_name: UPGRADE_TYPE = UPGRADE_TYPE.DAMAGE):
	attack_name = att_name
	upgrade_name = upgr_name
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for attacks in get_tree().get_nodes_in_group("attacks"):
		if attacks.attack_name == self.attack_name:
			is_in_tree = true
			atknode = attacks
	updateLabels()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addAttack(atktype):
	#match atktype:
	#something, add child
	pass
func addUpgrade(upgtype):
	#match upgtype
	#something, atknode.upgradename += scaling
	pass

func updateLabels():
	pass

func onClick():
	#if is_in_tree:
	#addUpgrade
	#else:
	#addAttack
	pass
