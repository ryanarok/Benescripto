extends Node

var PALABRA = "palabra"
var REFRAN = "refrán"
var FRASE = "frase"

var voice_selected = 0
var pitch = 1
var volume = 0

var category_sizes : Array = [ 5, 1273, 753, 436, 29, 50, 378, 138, 19 ]
var selected_categories : Array = [ false, false, false, false, false, false, false, false, false]
var categories_amount : int = 0

var training_words : int = 10
var audio_probs : float = 50

var selected_words : int = 0

func get_line_id_by_rand(rand:int)->int:
	var id_ret=0
	for i in range(category_sizes.size()):
		if(selected_categories[i]):
			if(rand>category_sizes[i]):
				rand-=category_sizes[i]
			else :
				return id_ret + rand
		id_ret+=category_sizes[i]
				
	return -1
	
func get_line_number_by_id(id : int)-> int:
	var ln_ret = 1
	for i in range(category_sizes.size()):
		if id> category_sizes[i]:
			id-=category_sizes[i]
		else: return id
	return ln_ret
	
func get_category_by_id(id : int)->int:
	var cat_ret = 1
	for i in range(category_sizes.size()):
		if id> category_sizes[i]:
			cat_ret+=1
			id-=category_sizes[i]
		else: return cat_ret
	return cat_ret
	
func get_file_by_id(id : int)->String:
	var f_ret = 65
	f_ret += get_category_by_id(id)-1
	return "res://DB/"+char(f_ret)+".txt"

func get_line_in_file(path:String, line: int)-> String:
	var file = FileAccess.open(path, FileAccess.READ)
	
	var line_ret = ""
	for i in range(line):
		line_ret = file.get_line()
	
	return line_ret
	
func get_word_by_id(id:int )->String:
	return get_line_in_file(get_file_by_id(id), 2*(get_line_number_by_id(id)-1)+1)
	
func get_definition_by_id(id:int )->String:
	return get_line_in_file(get_file_by_id(id), 2*get_line_number_by_id(id))

func get_type_by_id(id:int)->String:
	var cat = get_category_by_id(id)
	if(cat<=3):
		return PALABRA
	elif(cat<=4):
		return REFRAN
	else :
		return FRASE

func throw_audio_dice():
	var rnd = randf_range(1, 100)
	if rnd <= audio_probs:
		return true
	else: return false
