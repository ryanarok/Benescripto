extends CanvasLayer



func _ready():
	
	
	%CorrectResults.text = str(Global.last_results.words.correct + Global.last_results.phrases.correct)
	%WrongResults.text = str(Global.last_results.words.wrong + Global.last_results.phrases.wrong)
	
	Global.data.stats.words.correct+=Global.last_results.words.correct
	Global.data.stats.words.wrong+=Global.last_results.words.wrong
	Global.data.stats.phrases.correct+=Global.last_results.phrases.correct
	Global.data.stats.phrases.wrong+=Global.last_results.phrases.wrong
	Global.save_data()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
