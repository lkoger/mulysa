extends Node2D

var push_bar_door_01: AudioStream = preload("res://assets/sound/Door/push-bar-door-01.wav")
var push_bar_door_02: AudioStream = preload("res://assets/sound/Door/push-bar-door-02.wav")
var clink_01: AudioStream = preload("res://assets/sound/Medicine/clink-01.wav")
var clink_02: AudioStream = preload("res://assets/sound/Medicine/clink-02.wav")
var clink_03: AudioStream = preload("res://assets/sound/Medicine/clink-03.wav")
var hover_01: AudioStream = preload("res://assets/sound/UI/hover-01.wav")
var hover_02: AudioStream = preload("res://assets/sound/UI/hover-02.wav")
var hover_03: AudioStream = preload("res://assets/sound/UI/hover-03.wav")
var select_click_01: AudioStream = preload("res://assets/sound/UI/select-click-01.wav")

var clink_sounds = [clink_01, clink_02, clink_03]
var clink = clink_sounds[0]
var hover_sounds = [hover_01, hover_02, hover_03]
var hover = hover_sounds[0]
var push_bar_sounds = [push_bar_door_01, push_bar_door_02]
var push_bar = push_bar_sounds[0]

var current_song = ""
var next_song = ""

var time_alive_score = 0
var rounds_alive_score = 0


func _play(sound):
	match sound:
		'clink':
			$AudioStreamPlayer.set_stream(clink)
			$AudioStreamPlayer.play()
			clink = clink_sounds[randi() % clink_sounds.size()]
		'hover':
			$AudioStreamPlayer.set_stream(hover)
			$AudioStreamPlayer.play()
			hover = hover_sounds[randi() % hover_sounds.size()]
		'select':
			$AudioStreamPlayer.set_stream(select_click_01)
			$AudioStreamPlayer.play()


#func _on_AudioStreamPlayer_finished():
#	if next_song != "":
#		_play(next_song)
#		next_song = ""
#	else:
#		$AudioStreamPlayer.play()

func get_song_time_left():
	if $AudioStreamPlayer.playing:
		return $AudioStreamPlayer.stream.get_length() - $AudioStreamPlayer.get_playback_position()
	else:
		return INF

func fade_out_music(time_to_fade):
	if $AudioStreamPlayer.is_playing():
		$Tween.interpolate_property($AudioStreamPlayer, "volume_db", 0.0, -50.0, time_to_fade)
		$Tween.start()




func increment_time_score():
	time_alive_score += 1

func increment_round_score():
	rounds_alive_score += 1

