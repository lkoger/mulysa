extends Node

onready var fade_tween = get_node("FadeTween")

func _ready():
	pass

func fade_in(object, duration):
	fade_tween.interpolate_property(object, "modulate", object.modulate, Color(1,1,1,1), duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fade_tween.start()

func fade_out(object, duration):
	fade_tween.interpolate_property(object, "modulate", object.modulate, Color(1,1,1,0), duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fade_tween.start()
