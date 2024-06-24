extends CanvasLayer



func _ready():
	%WT.text = str(Global.data.stats.words.correct + Global.data.stats.words.wrong)
	%WC.text = str(Global.data.stats.words.correct)
	%WW.text = str(Global.data.stats.words.wrong)
	
	%PT.text = str(Global.data.stats.phrases.correct + Global.data.stats.phrases.wrong)
	%PC.text = str(Global.data.stats.phrases.correct)
	%PW.text = str(Global.data.stats.phrases.wrong)
	
	%TT.text = str(Global.data.stats.words.correct + Global.data.stats.words.wrong + Global.data.stats.phrases.correct + Global.data.stats.phrases.wrong)
	%TC.text = str(Global.data.stats.words.correct + Global.data.stats.phrases.correct)
	%TW.text = str(Global.data.stats.words.wrong + Global.data.stats.phrases.wrong)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
