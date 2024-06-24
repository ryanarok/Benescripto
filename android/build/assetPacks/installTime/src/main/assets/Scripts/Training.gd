extends CanvasLayer

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
@onready var wordEditCont = %WordEditContainer

func _ready():
	wrongBar.max_value = Global.training_words
	correctBar.max_value = Global.training_words
	wrongBar.value = wrong_answers
	correctBar.value = wrong_answers+correct_answers
	next_word()

func change_by_audio_and_type():
	print(wrongBar.max_value)
	print(wrongBar.value)
	%DefinitionLabel.text = Global.get_definition_by_id(current_word_id)
	
	set_header(current_word_id)
	
	if(is_audio):
		definCont.visible = false
		listenCont.visible = true
	else:
		definCont.visible = true
		listenCont.visible = false
		
	var type = Global.get_type_by_id(current_word_id)
	
	if type == Global.PALABRA:
		wordEditCont.visible = true
		phraseEdit.visible = false
	else:
		wordEditCont.visible = false
		phraseEdit.visible = true

func next_word():
	
	var rnd = randi_range(1, Global.selected_words)
	current_word_id = Global.get_line_id_by_rand(rnd)
	
	is_audio = Global.throw_audio_dice()
	if Global.get_type_by_id(current_word_id)!=Global.PALABRA:
		is_audio = true
		
	change_by_audio_and_type()
	
func set_header(id:int):
	var head = %Header
	var type = Global.get_type_by_id(id)
	if type ==Global.PALABRA:
		if is_audio:
			head.text = "Escucha la siguiente palabra: "
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
			
func _on_submit_button_pressed():
	
	
	definCont.visible = true
	listenCont.visible = false
	
	if is_answer:
		if correct_answers + wrong_answers == Global.training_words:
#################

###FINISH###

################
			pass	
		else:
			%SubmitButton.text = "Comprobar"
			is_answer = false
			next_word()
	else:
		%SubmitButton.text = "Siguiente"
		var submited_text = %WordEdit.text if Global.get_type_by_id(current_word_id) == Global.PALABRA else %PhraseEdit.text
		if submited_text == Global.get_word_by_id(current_word_id):
			correct_answers+=1
		else:
			wrong_answers+=1
		
		correctBar.value = correct_answers + wrong_answers
		wrongBar.value = wrong_answers
		set_answer(current_word_id)
		is_answer = true
		
	%WordEdit.text = ""
	%PhraseEdit.text = ""	

func _on_listen_button_pressed():
	var voices = DisplayServer.tts_get_voices()
	DisplayServer.tts_stop()
	DisplayServer.tts_speak(Global.get_word_by_id(current_word_id), voices[Global.voice_selected].id)
