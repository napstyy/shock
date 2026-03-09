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
var attack_name: ATTACK_NAME
var upgrade_name: UPGRADE_TYPE
var is_in_tree = false
var atknode: Attack
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
	updateLabels()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addAttack():
	#match atktype:
	#something, add child
	print("attack")
	pass
func addUpgrade():
	print("upgrade")
	match upgrade_name:
		UPGRADE_TYPE.AREA:
			atknode.upgrade_area(5)
			pass
		UPGRADE_TYPE.DAMAGE:
			atknode.attack_damage += 5 #TODO: Scale this per atk maybe
		UPGRADE_TYPE.ENERGYCOST:
			atknode.energy_cost -= 5
	#something, atknode.upgradename += scaling
	pass

func updateLabels():
	pass


func _on_button_button_down() -> void:
	if is_in_tree:
		addUpgrade()
	else:
		addAttack()
