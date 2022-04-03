extends Control

func _ready() -> void:
	Globals._play('light-on')
	Globals._play('title-light-hum')
	# Connect the pressed() method of every scene to this scene
#	for button in get_tree().get_nodes_in_group("button"):
#		button.connect("pressed", self, "_on_menu_button_pressed", [button.next_scene])


func _on_NewGameButton_button_up() -> void:
	Globals._play('light-off')
	Globals._play('level-light-hum')
