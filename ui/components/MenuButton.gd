extends Button

export(String, FILE, "*.tscn") var next_scene

func _ready() -> void:
	connect("pressed", self, "_on_menu_button_pressed", next_scene)
	pass

func _on_mouse_entered() -> void:
	Globals._play('hover')


func _on_button_up() -> void:
	Globals._play('select')
	get_tree().change_scene(next_scene)


func _on_NewGameButton_button_up() -> void:
	Globals._play('light-off')
	Globals._play('level-light-hum')
