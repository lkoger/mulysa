extends Button

export(String, FILE, "*.tscn") var next_scene

func _ready() -> void:
	pass

func _on_mouse_entered() -> void:
	Globals._play('hover')


func _on_button_up() -> void:
	Globals._play('select')


func _on_NewGameButton_button_up() -> void:
	Globals._play('light-off')
