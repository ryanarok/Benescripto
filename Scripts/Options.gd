extends CanvasLayer

@onready var voiceSelector = %VoiceSelector
var es_voices = DisplayServer.tts_get_voices_for_language("es")

func load_voices():
	var idx = 1
	for voice in es_voices:
		voiceSelector.add_item("Voz "+str(idx), idx-1)
		idx+=1
		
func _ready():
	load_voices()
	%VolumeSlider.value = Global.data.volume
	%PitchSlider.value = Global.data.pitch
	
func _process(delta):
	pass


func _on_back_button_pressed():
	Global.save_data()
	
	if Global.current_scene=="Main":
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	else:
		visible = false
		get_parent().visible = true


func _on_listen_button_pressed():
	DisplayServer.tts_stop()
	DisplayServer.tts_speak("Hola, ¿qué tal?", es_voices[voiceSelector.selected], Global.data.volume , Global.data.pitch, Global.data.rate)


func _on_volume_slider_value_changed(value):
	Global.data.volume = value


func _on_pitch_slider_value_changed(value):
	Global.data.pitch = value


func _on_rate_slider_value_changed(value):
	Global.data.rate = value
