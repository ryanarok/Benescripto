extends CanvasLayer

func press_category(cat : int, toggled_on : bool):
	Global.selected_categories[cat] = toggled_on
	Global.categories_amount += (1 if toggled_on else -1)
	Global.selected_words += (Global.category_sizes[cat] if toggled_on else -Global.category_sizes[cat])

func _ready():
	Global.reset()
	Global.current_scene = "Main"
	Global.load_data()
	
	%TrainingWordsBox.value = Global.training_words
	%AudioProbsBox.value = Global.audio_probs

func _on_training_words_box_value_changed(value):
	Global.training_words = value

func _on_audio_probs_box_value_changed(value):
	Global.audio_probs = value

func _on_check_box_level_i_toggled(toggled_on):
	press_category(0,toggled_on)
func _on_check_box_level_ii_toggled(toggled_on):
	press_category(1,toggled_on)
func _on_check_box_level_iii_toggled(toggled_on):
	press_category(2,toggled_on)

func _on_check_box_phrases_1_toggled(toggled_on):
	press_category(3,toggled_on)

#EXPERIMENTAL#######
func _on_check_box_phrases_2_toggled(toggled_on):
	press_category(4,toggled_on)
	press_category(5,toggled_on)
	press_category(6,toggled_on)
func _on_check_box_phrases_3_toggled(toggled_on):
	press_category(5,toggled_on)
func _on_check_box_phrases_4_toggled(toggled_on):
	press_category(6,toggled_on)
func _on_check_box_phrases_5_toggled(toggled_on):
	press_category(7,toggled_on)
	press_category(8,toggled_on)
func _on_check_box_phrases_6_toggled(toggled_on):
	press_category(8,toggled_on)
# ###################

func _on_start_button_pressed():
	if DisplayServer.tts_get_voices_for_language("es").size() == 0:
		var wl : Label = %WarningLabel
		wl.text = "No hay voces disponibles,\npor favor, instale alguna"
		wl.add_theme_color_override("font_color", Color("c20000", 1))
		return
	if(Global.categories_amount>0):
		get_tree().change_scene_to_file("res://Scenes/Training.tscn")
	else:
		var wl : Label = %WarningLabel
		wl.add_theme_color_override("font_color", Color("c20000", 1))
		await get_tree().create_timer(0.5).timeout
		
		var tw = get_tree().create_tween()
		tw.tween_method(change_alpha, 1.0, 0.0, 1)
		
func change_alpha(alpha):
	var wl : Label = %WarningLabel
	wl.add_theme_color_override("font_color", Color("c20000", alpha))


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Options.tscn")
	
func _on_stats_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Stats.tscn")
