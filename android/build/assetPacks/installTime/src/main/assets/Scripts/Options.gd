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
	%VolumeSlider.value = Global.volume
	%PitchSlider.value = Global.pitch
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_listen_button_pressed():
	DisplayServer.tts_stop()
	DisplayServer.tts_speak("Hola, ¿qué tal?", es_voices[voiceSelector.selected])
