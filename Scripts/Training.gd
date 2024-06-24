extends CanvasLayer

var rnd 

var current_word_id
var is_audio : bool

var is_answer : bool = false

var correct_answers = 0
var wrong_answers = 0

@onready var wrongBar = %WrongBar
@onready var correctBar = %CorrectBar

@onready var listenCont = %ListenContainer
@onready var definCont = %DefinitionContainer

@onready var phraseEdit = %PhraseEdit
@onready var wordEdit = %WordEdit

@onready var audioPlayer : AudioStreamPlayer = %AudioPlayer

var ACCEPTED_SOUND = load("res://Sounds/Accepted.wav")
var WRONG_SOUND = load("res://Sounds/Wrong Error.wav")

var voices = DisplayServer.tts_get_voices_for_language("es")

@onready var optionsMenu = load("res://Scenes/Options.tscn").instantiate()

func _ready():
	%TotalWords.text = str(Global.training_words)
	Global.current_scene = "Training"
	optionsMenu.visible = false
	add_child(optionsMenu)
	
	wrongBar.max_value = Global.training_words
	correctBar.max_value = Global.training_words
	wrongBar.value = wrong_answers
	correctBar.value = wrong_answers+correct_answers
	next_word()

func change_by_audio_and_type():
	
	%DefinitionLabel.text = Global.get_definition_by_id(current_word_id)
	
	set_header(current_word_id)
	
	if(is_audio):
		listenCont.visible = true
	else:
		listenCont.visible = false
		
	var type = Global.get_type_by_id(current_word_id)
	
	if type == Global.PALABRA:
		wordEdit.visible = true
		phraseEdit.visible = false
		%WordEdit.grab_focus()
	else:
		wordEdit.visible = false
		phraseEdit.visible = true
		%FakeLineEdit.grab_focus()

func next_word():
	rnd = randi_range(1, Global.selected_words)
	current_word_id = Global.get_line_id_by_rand(rnd)
	
	is_audio = true
	if is_audio:
		_on_listen_button_pressed()
		
	change_by_audio_and_type()
	
func set_header(id:int):
	var head = %Header
	var type = Global.get_type_by_id(id)
	if type ==Global.PALABRA:
		if is_audio:
			head.text = "Escucha la palabra\ncon el significado siguiente: "
		else:
			head.text = "La definición de la palabra es:"
	elif type == Global.REFRAN:
		head.text = "Escucha el siguinte refrán:"
	else: head.text = "Escucha la siguiente frase de:"

func set_answer(id:int):
	var head = %Header
	var type = Global.get_type_by_id(id)
	
	if type ==Global.PALABRA:
		head.text = "La palabra era:"
	elif type == Global.REFRAN:
		head.text = "El refran decía:"
	else: head.text = "La frase decía:"
	
	%DefinitionLabel.text = Global.get_word_by_id(current_word_id)

func clear_spaces(str:String)->String:
	for i in range(str.length()):
		if str[i]!=" ":
			str = str.substr(i)
			break
	for i in range(str.length()-1, 0, -1):
		if str[i]!=" ":
			str = str.substr(0, i+1)
			break
	return str

func check_answer():
	var submited_text : String = %WordEdit.text if Global.get_type_by_id(current_word_id) == Global.PALABRA else %PhraseEdit.text
	
	var word = Global.get_word_by_id(current_word_id)
	
	submited_text = clear_spaces(submited_text)
	
	var validwords : Array
	
	var ini = 0
	
	for i in range(word.length()):
		if word[i]==",":
			validwords.push_back(word.substr(ini, i-ini))
			ini = i + 1
		elif  i == word.length()-1:
			validwords.push_back(word.substr(ini, i-ini+1))
	
	var correct = false
	for w in validwords:
		w = clear_spaces(w)
	
	for w in validwords:
		if submited_text == w:
			correct = true
		
	if correct:
		if Global.get_category_by_id(current_word_id) <= 3:
			Global.last_results.words.correct+=1
		else:
			Global.last_results.phrases.correct+=1
		audioPlayer.set_stream(ACCEPTED_SOUND)
		audioPlayer.play()
		correct_answers+=1
	else:
		if Global.get_category_by_id(current_word_id) <= 3:
			Global.last_results.words.wrong+=1
		else:
			Global.last_results.phrases.wrong+=1
		audioPlayer.set_stream(WRONG_SOUND)
		audioPlayer.play()
		wrong_answers+=1

func _on_submit_button_pressed():
	
	DisplayServer.tts_stop()
	
	definCont.visible = true
	listenCont.visible = false
	
	if is_answer:
		%FakeLineEdit.editable = true
		%WordEdit.editable = true
		%WordEdit.text = ""
		phraseEdit.text = ""
		%FakeLineEdit.text = ""
		if correct_answers + wrong_answers == Global.training_words:
			get_tree().change_scene_to_file("res://Scenes/Finish.tscn")
		else:
			%SubmitButton.text = "Comprobar"
			is_answer = false
			next_word()
	else:
		%FakeLineEdit.editable = false
		%WordEdit.editable = false
		%SubmitButton.text = "Siguiente"
		%SubmitButton.grab_focus()
		
		check_answer()
		
		correctBar.value = correct_answers + wrong_answers
		wrongBar.value = wrong_answers
		%CurrentWord.text = str(correct_answers + wrong_answers)
		set_answer(current_word_id)
		is_answer = true
		
func _on_listen_button_pressed():
	DisplayServer.tts_stop()
	DisplayServer.tts_speak(Global.get_word_by_id(current_word_id), voices[Global.data.voice_selected],  Global.data.volume , Global.data.pitch, Global.data.rate)

func _on_options_button_pressed():
	visible = false
	optionsMenu.visible = true

func _on_phrase_edit_text_changed():
	var txt :String = phraseEdit.text
	if txt.ends_with("\n"):
		phraseEdit.text = txt.substr(0, txt.length()-1)
		_on_submit_button_pressed()

func _on_word_edit_text_submitted(new_text):
	_on_submit_button_pressed()

func _on_word_edit_2_text_changed(new_text):
	phraseEdit.text = new_text
	pass # Replace with function body.
