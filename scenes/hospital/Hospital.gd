extends Node2D

onready var death_scene = preload("res://components/Death/Death.tscn")

func _ready():
	var death = death_scene.instance()
	death.nav_node = get_node("Navigation2D")
	add_child(death)
	var i = randi() % $death_spawns.get_child_count()
	death.global_position = $death_spawns.get_children()[i].global_position
