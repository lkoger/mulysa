extends AudioStreamPlayer

var offset = 0

func remove_self():
	queue_free()

func play_sound(sound_stream, volume=0.0):
	set_stream(sound_stream)
	self.set_volume_db(volume)
	connect("finished",self,"remove_self")
	play(offset)
