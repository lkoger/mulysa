extends Button

export(String, FILE, "*.tscn") var next_scene

func _on_MenuButton_button_up():
	Globals._play('select')
	get_tree().change_scene(next_scene)

func _on_NewGameButton_button_up():
	Globals._play('light-off')
	Globals._play('level-light-hum')


func _on_MenuButton_mouse_entered():
	Globals._play('hover')
