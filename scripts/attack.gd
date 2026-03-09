class_name Attack
extends Node

enum MOVEMENT_TYPE {
	STATIONARY, #Doesn't Move
	REPEATING, #Moves between 2 or more points
	ONESHOT, #Moves to point and then teleports to origin, origin should be the first point of the array
	BOUNCE #Takes an initial vector & moves until hit edge of screen, if no initial vector chooses a random one
}
enum ATTACK_NAME{
	THUNDERPILLAR,
	LIGHTNINGORB
}
@export var attack_name: ATTACK_NAME
@export var attack_areas: Array[Area2D]
@export var attack_damage: int
@export var energy_cost: int

@export var movement_type: MOVEMENT_TYPE
@export var movement_points: Array[Vector2]
@export var movement_speed:float

@export var attack_sprites: Array[AnimatedSprite2D]

var inputname := ""
var nextpoint := -1
var direction := Vector2.ZERO
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if movement_points.is_empty() or movement_points[0]==Vector2.ZERO:
		direction = Vector2(RandomNumberGenerator.new().randf(),RandomNumberGenerator.new().randf())
	else:
		direction = movement_points[0].normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("Attack1"):
		attack_triggered()

func _physics_process(delta: float) -> void:
	attack_movement(delta)

	
func attack_triggered():
	if player.energy - energy_cost >= 0:
		player.energy -= energy_cost
		print(player.energy)
		#attack_sprite.visible = true
		#attack_sprite.play(default)
		#await attack_sprite.animationfinished
		for areas in attack_areas:
			var enemies = areas.get_overlapping_bodies()
			#print(areas.get_overlapping_bodies())
			for enemy in enemies:
				enemy.take_damage(attack_damage) #TEST

func attack_movement(delta):
	match movement_type:
		MOVEMENT_TYPE.STATIONARY:
			pass
		MOVEMENT_TYPE.ONESHOT:
			self.position = self.position.move_toward(movement_points[1],movement_speed*delta)
			#print(self.position.move_toward(movement_points[1],movement_speed*delta))
			if self.position.is_equal_approx(movement_points[1]):
				self.position = movement_points[0]
		MOVEMENT_TYPE.REPEATING:
			for point in range(movement_points.size()):
				if self.position.is_equal_approx(movement_points[point]):
					nextpoint = (point+1)%movement_points.size()
			self.position = self.position.move_toward(movement_points[nextpoint], movement_speed*delta)
		MOVEMENT_TYPE.BOUNCE:
			var screensize = get_viewport().get_visible_rect().size
			self.position += direction * movement_speed * delta
			if self.position.x < 0 or self.position.x > screensize.x:
				direction.x *= -1
			if self.position.y < 0 or self.position.y > screensize.y:
				direction.y *= -1
