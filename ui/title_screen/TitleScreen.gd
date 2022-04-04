extends Control

var frame_1 = preload("res://assets/0000.jpg")
var frame_2 = preload("res://assets/0001.jpg")
var frame_3 = preload("res://assets/0002.jpg")

func _ready() -> void:
	Globals.clear_all_audio()
	Globals._play('light-on')
	Globals._play('title-light-hum')
	
func _process(delta):
	var time_left = $Timer.time_left
	if (time_left >= 5.0 and time_left <= 5.2) or (time_left >= 4.6 and time_left <=4.8):
		_set_frame(frame_3)
	elif (time_left >= 3.0 and time_left <= 3.2):
		_set_frame(frame_2)
	else:
		_set_frame(frame_1)

func _set_frame(frame):
	$Background.texture = frame

func _on_Timer_timeout() -> void:
	$Timer.start()
