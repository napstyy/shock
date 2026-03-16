extends Node2D

@onready var player: Node2D = %player
@onready var v_box_container: VBoxContainer = $TextureRect/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.playerdied.connect(gameover)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func gameover():
	v_box_container.visible = true
	get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
