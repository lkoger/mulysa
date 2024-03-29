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
var get_pills: AudioStream = preload("res://assets/sound/UseItem/getpills.wav")
var tv_static: AudioStream = preload("res://assets/sound/Environmental/tv-static.wav")
var old_man_scream: AudioStream = preload("res://assets/sound/Death/old-man-scream.wav")
var heartbeat_01: AudioStream = preload("res://assets/sound/Environmental/heartbeat-01.wav")
var heartbeat_02: AudioStream = preload("res://assets/sound/Environmental/heartbeat-02.wav")


#var clink_sounds = [clink_01, clink_02, clink_03]
var hover_sounds = [hover_01, hover_02, hover_03]
var wheelchair_sounds = [wheelchair_01, wheelchair_02]
var grunt_sounds = [grunt_01, grunt_02, grunt_03]
var heartbeat_sounds = [heartbeat_01, heartbeat_02]
var clink: AudioStream
var hover: AudioStream
var wheelchair: AudioStream
var grunt: AudioStream
var heartbeat: AudioStream

var current_sound = ''
var death_current_sound = ''

var time_alive_score = 0.0
var adrenaline_taken = 0
var psychedelics_taken = 0

var default_sfx_volume = 0.0
var played_light_on_already = false



func _ready():
	randomize()

func _play_death_sound():
	if death_current_sound != 'scythe_scraping':
		death_current_sound = 'scythe_scraping'
		$DeathsSound.set_stream(scythe_scraping)
		$DeathsSound.play()
		
func _change_death_sound_volume(value):
	$DeathsSound.set_volume_db(value)
		
func _stop_death_sound():
	death_current_sound = ''
	$DeathsSound.stop()
	_play('light-off')


func _single_play():
	if current_sound != 'wheelchair':
		current_sound = 'wheelchair'
		$AudioStreamPlayer.set_volume_db(default_sfx_volume)
		$AudioStreamPlayer.set_stream(wheelchair_sounds[randi() % wheelchair_sounds.size()])
		$AudioStreamPlayer.play()

func _stop_single_play():
	current_sound = ''
	$AudioStreamPlayer.stop()


func _change_sfx_volume(new_volume):
	default_sfx_volume = new_volume
#	death_sound_max_volume = default_sfx_volume
#	death_sound_min_volume = death_sound_max_volume - 30


func _play(sound):
	var audio: AudioStream
	var volume = default_sfx_volume
	match sound:
#		'clink':
#			audio = clink_sounds[randi() % clink_sounds.size()]
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
			if played_light_on_already:
				return
			else:
				played_light_on_already = true
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
			audio = get_pills
		'old-man-scream':
			volume = -5
			audio = old_man_scream
		'heartbeat':
			audio = heartbeat_sounds[randi() % heartbeat_sounds.size()]
	var sound_obj = sound_direct.instance()
	$sounds.add_child(sound_obj)
	sound_obj.play_sound(audio, volume)


func clear_all_audio():
	for child in $sounds.get_children():
		child.queue_free()

func get_song_time_left():
	if $AudioStreamPlayer.playing:
		return $AudioStreamPlayer.stream.get_length() - $AudioStreamPlayer.get_playback_position()
	else:
		return INF

func fade_out_music(time_to_fade):
	if $AudioStreamPlayer.is_playing():
		$Tween.interpolate_property($AudioStreamPlayer, "volume_db", 0.0, -50.0, time_to_fade)
		$Tween.start()

func clear_score():
	time_alive_score = 0.0
	adrenaline_taken = 0
	psychedelics_taken = 0

func increment_time_score():
	time_alive_score += 1.0

func increment_adrenaline():
	adrenaline_taken += 1

func increment_psychedelics():
	psychedelics_taken += 1

