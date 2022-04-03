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
var wheelchair_01: AudioStream = preload("res://assets/sound/Wheelchair/wheelchair-loop-01.wav")
var wheelchair_02: AudioStream = preload("res://assets/sound/Wheelchair/wheelchair-loop-02.wav")
var scythe_scraping: AudioStream = preload("res://assets/sound/Death/metal-scraping.wav")
var grunt_01: AudioStream = preload("res://assets/sound/UseItem/grunt-01.wav")
var grunt_02: AudioStream = preload("res://assets/sound/UseItem/grunt-02.wav")
var grunt_03: AudioStream = preload("res://assets/sound/UseItem/grunt-03.wav")
var gulp_01: AudioStream = preload("res://assets/sound/UseItem/gulp.wav")


var clink_sounds = [clink_01, clink_02, clink_03]
var hover_sounds = [hover_01, hover_02, hover_03]
var wheelchair_sounds = [wheelchair_01, wheelchair_02]
var grunt_sounds = [grunt_01, grunt_02, grunt_03]
var clink: AudioStream
var hover: AudioStream
var wheelchair: AudioStream
var grunt: AudioStream

var current_sound = ''
var death_current_sound: AudioStream

var time_alive_score = 0
var rounds_alive_score = 0


func _play_death_sound():
	if death_current_sound != scythe_scraping:
		death_current_sound = scythe_scraping
		$DeathsSound.set_stream(scythe_scraping)
		$DeathsSound.play()
		
func _change_death_sound_volume(value):
	$DeathsSound.set_volume_db(value)
	#print($DeathsSound.volume_db)
		
func _stop_death_sound(sound):
	if sound == death_current_sound:
		var new: AudioStream
		death_current_sound = new
		$DeathsSound.stop()


func _single_play(sound):
	if sound != current_sound:
		current_sound = sound
		match sound:
			'wheelchair':
				$AudioStreamPlayer.set_stream(wheelchair_sounds[randi() % wheelchair_sounds.size()])
				$AudioStreamPlayer.play()

func _stop_single_play(sound):
	if sound == current_sound:
		current_sound = ''
		$AudioStreamPlayer.stop()


func _play(sound):
	var audio: AudioStream
	var volume = 0.0
	match sound:
		'clink':
			audio = clink_sounds[randi() % clink_sounds.size()]
		'hover':
			audio = hover_sounds[randi() % hover_sounds.size()]
			volume = -10
		'select':
			audio = select_click_01
			volume = -20
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
		'useAdrenaline':
			audio = grunt_sounds[randi() % grunt_sounds.size()]
		'usePsychedelic':
			audio = gulp_01
	
	var sound_obj = sound_direct.instance()
	add_child(sound_obj)
	sound_obj.play_sound(audio, volume)




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

