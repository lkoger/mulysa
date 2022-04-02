extends Area2D

onready var active = true

func _ready():
	pass

func _on_Adrenaline_body_entered(body):
	# Need to check if body has a "handle_pyschedelic" function.
	# If so, pass self to it.
	if active:
		if body.has_method("handle_adrenaline"):
			body.handle_adrenaline(self)
			_disappear()

# I only have this in here in case we want to add logic to do an animation
# or something when it's picked up, instead of just immediately disappearing.
func _disappear():
	active = false
	$Tween.interpolate_property(self, "scale", scale, Vector2(0.2,0.2), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	$Tween.start()
	


func _on_Tween_tween_all_completed():
	queue_free()
