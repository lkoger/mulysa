extends Control

func _ready() -> void:
	Globals._play('light-on')
	Globals._play('title-light-hum')


func _on_VideoPlayer_finished() -> void:
	$VideoPlayer.play()
