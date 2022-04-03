extends Control

func _on_MusicSlider_value_changed(value):
	Globals._change_music_volume()
	
func _on_SFXSlider_value_changed(value):
	Globals._change_sfx_volume(value)
