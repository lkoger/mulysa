extends Light2D


func _ready():
	pass


func _on_Area2D_area_entered(area):
	if area.name == "Death":
		$Tween.interpolate_property(self, "energy", energy, 0.1, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN)
		$Tween.start()
	elif area.name == "LightActivationArea":
		visible = true


func _on_Area2D_area_exited(area):
	if area.name == "Death":
		if $Tween.is_active():
			$Tween.remove_all()
		$Tween.interpolate_property(self, "energy", energy, 1.0, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	elif area.name == "LightActivationArea":
		visible = false
