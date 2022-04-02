extends Button

export(String, FILE, "*.tscn") var next_scene

func _ready() -> void:
	pass


func _on_mouse_entered() -> void:
	Globals._play('hover')
