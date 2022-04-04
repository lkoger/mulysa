extends CanvasLayer


func _ready():
	pass

func update_vignette(magnitude: float):
	# magnitude should be between 0 and 1
	$UIArea/Vigenette.modulate = Color(1,1,1, magnitude)
	
func game_over():
	$GameOver.activate()
