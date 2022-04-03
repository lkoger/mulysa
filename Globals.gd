extends Node2D

var sound_direct = preload("res://sound_direct.tscn")

var door_open: AudioStream = preload("res://assets/sound/Door/door-open.wav")
var door_close: AudioStream = preload("res://assets/sound/Door/door-close.wav")
var clink_01: AudioStream = preload("res://assets/sound/Medicine/clink-01.wav")
var clink_02: AudioStream = preload("res://assets/sound/Medicine/clink-02.wav")
var clink_03: AudioStream = preload("res://assets/sound/Medicine/clink-03.wav")
var hover_01: AudioStream = preload("res://assets/sound/UI/hover-01.wav")
var hover_02: AudioStream = preload("res://assets/sound/UI/hover-02.wav")
var hover_03: AudioStream = preload("res://assets/sound/UI/hover-03.wav")
var title_light_hum: AudioStream = preload("res://assets/sound/UI/light-hum.wav")
var light_on: AudioStream = preload("res://assets/sound/UI/light-on.wav")
var light_off: AudioStream = preload("res://assets/sound/UI/light-off.wav")
var select_click_01: AudioStream = preload("res://assets/sound/UI/select-click-01.wav")
var level_light_hum: AudioStream = preload("res://assets/sound/Environmental/light-hum.wav")

var clink_sounds = [clink_01, clink_02, clink_03]
var clink = clink_sounds[0]
var hover_sounds = [hover_01, hover_02, hover_03]
var hover = hover_sounds[0]

var current_song = ""
var next_song = ""

var time_alive_score = 0
var rounds_alive_score = 0


func _play(sound):
	var audio: AudioStream
	match sound:
		'clink':
			audio = clink_sounds[randi() % clink_sounds.size()]
		'hover':
			audio = hover_sounds[randi() % hover_sounds.size()]
		'select':
			audio = select_click_01
		'door-open':
			audio = door_open
		'door-close':
			audio = door_close
		'light-on':
			audio = light_on
		'light-off':
			audio = light_off
		'level-light-hum':
			audio = level_light_hum
		'title-light-hum':
			audio = title_light_hum
	
	var sound_obj = sound_direct.instance()
	add_child(sound_obj)
	sound_obj.play_sound(audio)




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

