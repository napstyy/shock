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
		"Icon": "res://assets/atkthumbnails/PillarsThumb.png",
		"Desc": "This should never be seen"
		},
	Enums.ATTACK_NAME.LIGHTNINGORB: {
		"AtkName": "Lightning Orb",
		"Scene": preload("res://prefabs/attacks/lightningorb.tscn").instantiate(),
		"Icon": "res://assets/atkthumbnails/LightningOrbThumb.png",
		"Desc": "A condensed ball of lightning which bounds back and forth."
	},
	Enums.ATTACK_NAME.BARRIERARC:{
		"AtkName": "Barrier Arc",
		"Scene": preload("res://prefabs/attacks/barrierarc.tscn").instantiate(),
		"Icon": "res://assets/atkthumbnails/BarrierArcThumb.png",
		"Desc": "An arc of electricity that strikes the top left"
	},
	Enums.ATTACK_NAME.SPLITBOLT:{
		"AtkName": "Split Bolt",
		"Scene": preload("res://prefabs/attacks/splitbolt.tscn").instantiate(),
		"Icon": "res://assets/atkthumbnails/SplitBoltThumb.png",
		"Desc": "The bolt splits to hit two areas to the left"
	},
	Enums.ATTACK_NAME.ROLLINGTHUNDER:{
		"AtkName": "Rolling Thunder",
		"Scene": preload("res://prefabs/attacks/rollingthunder.tscn").instantiate(),
		"Icon": "res://assets/atkthumbnails/RollingThunderThumb.png",
		"Desc": "Travels along the ground to the right"
	},
	Enums.ATTACK_NAME.SPARKGEYSER:{
		"AtkName": "Spark Geyser",
		"Scene": preload("res://prefabs/attacks/sparkgeyser.tscn").instantiate(),
		"Icon": "res://assets/atkthumbnails/SparkGeyserThumb.png",
		"Desc": "Attacks closely to the right, and further to the left"
	},
	Enums.ATTACK_NAME.CIRCUITBEAM:{
		"AtkName": "Circuit Beam",
		"Scene": preload("res://prefabs/attacks/circuitbeam.tscn").instantiate(),
		"Icon": "res://assets/atkthumbnails/CircuitBeamThumb.png",
		"Desc": "Shoots a long beam diagonally to the right"
	},
	Enums.ATTACK_NAME.OVERLOAD:{
		"AtkName": "Overload",
		"Scene": preload("res://prefabs/attacks/overload.tscn").instantiate(),
		"Icon": "res://assets/atkthumbnails/OverloadThumb.png",
		"Desc": "High energy cost but destroys everything on the ground"
	},
	Enums.ATTACK_NAME.IONSTORM:{
		"AtkName": "Ion Storm",
		"Scene": preload("res://prefabs/attacks/ion_storm.tscn").instantiate(),
		"Icon": "res://assets/atkthumbnails/IonStormThumb.png",
		"Desc": "Four small orbs attack incoming airborne threats"
	},
	Enums.ATTACK_NAME.VOLTSPHERE:{
		"AtkName": "Volt Sphere",
		"Scene": preload("res://prefabs/attacks/voltsphere.tscn").instantiate(),
		"Icon": "res://assets/atkthumbnails/VoltSphereThumb.png",
		"Desc": "An explosive orb that strikes the top right"
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
	#Enums.UPGRADE_TYPE.DAMAGE: {
		#"Name": "Damage",
		#"Mod": 5
			#},
	Enums.UPGRADE_TYPE.ENERGYCOST: {
		"Name": "Energy Cost",
		"Mod": -5
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
@onready var card_img: TextureRect = $NinePatchRect/CardImg
@onready var attack_slots = get_tree().current_scene.get_node("AttackSlots")

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
	#print(upgrade_dict)
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

	_add_attack_icon()
	menuclosed.emit()


func _add_attack_icon():
	print("working")
	var attack_slots = get_node("/root/Main/AttackSlots") #finds hbox
	
	if attack_slots == null:
		push_error("attacks not found bro")
		return
	var slot_index = attack_slots.get_child_count() + 1
	#its +2 bc we always start with pillars

	#adding vbox to add numbers near the icons
	var vbox = VBoxContainer.new()
	vbox.custom_minimum_size = Vector2(24, 32)
	vbox.add_theme_constant_override("separation", 0)#ts removes the lil gap
	#
	#create the icon and load the text
	var icon = TextureRect.new()
	icon.texture = load(upgrade_dict[attack_name]["Icon"])
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.custom_minimum_size = Vector2(20, 20)

	#number label stuff
	var label = Label.new()
	label.text = str(slot_index)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color(0.03,0.16,0.22))
	var font = load("res://assets/fonts/Jacquard24-Regular.ttf")
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", 12)

	#building the icon
	vbox.add_child(icon)
	vbox.add_child(label)
	attack_slots.add_child(vbox)


func addUpgrade():
	print("upgrade")
	match upgrade_name:
		Enums.UPGRADE_TYPE.AREA:
			atknode.upgrade_area(upgrade_names[upgrade_name]["Mod"])
		#Enums.UPGRADE_TYPE.DAMAGE:
			#atknode.attack_damage += upgrade_names[upgrade_name]["Mod"] #TODO: Scale this per atk maybe
		Enums.UPGRADE_TYPE.ENERGYCOST:
			atknode.energy_cost += upgrade_names[upgrade_name]["Mod"]
		Enums.UPGRADE_TYPE.SPEED:
			atknode.movement_speed += upgrade_names[upgrade_name]["Mod"]
	#something, atknode.upgradename += scaling
	#autoload 
	menuclosed.emit()

func updateLabels():
	card_name.text = upgrade_dict[attack_name]["AtkName"]
	card_img.texture = load(upgrade_dict[attack_name]["Icon"])
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
	if upgrade_names[upgrade_name]["Mod"]>=0:
		upgrade_dict[attack_name]["UpgName"] = upgrade_names[upgrade_name]["Name"] + "\n+"+ str(upgrade_names[upgrade_name]["Mod"])
	else:
		upgrade_dict[attack_name]["UpgName"] = upgrade_names[upgrade_name]["Name"] + "\n"+ str(upgrade_names[upgrade_name]["Mod"])
	updateLabels()
