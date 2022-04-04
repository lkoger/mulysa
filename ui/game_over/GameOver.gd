extends Control

var active = false

func _ready():
	visible = false
	modulate = Color(1,1,1,0)

func _process(delta):
	visible = active

func activate():
	active = true
	Utils.fade_in(self, 3)

func deactivate():
	active = false
	modulate = Color(1,1,1,0)
