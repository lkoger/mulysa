extends Node2D

onready var active = true
var item_type = "Adrenaline"

func _ready():
	pass

func _disappear():
	active = false
	queue_free()

func interact(body):
	if active:
		if body.has_method("handle_adrenaline"):
			body.handle_adrenaline(self)
			_disappear()
