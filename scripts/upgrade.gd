class_name Upgrade
extends Node

enum ATTACK_NAME{
	THUNDERPILLAR
}
enum UPGRADE_TYPE{
	AREA,
	DAMAGE,
	ENERGYCOST,
	SPEED
}
var attack_name: ATTACK_NAME
#if groups in attacks not in tree, upgrade, otherwise add to tree

func _init(att_name: ATTACK_NAME = ATTACK_NAME.THUNDERPILLAR, upgr_name: UPGRADE_TYPE = UPGRADE_TYPE.DAMAGE):
	attack_name = att_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
