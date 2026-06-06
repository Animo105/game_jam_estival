extends Control

@onready var help_panel = %CommentJouer

func _ready() -> void:
	help_panel.hide()

func _on_play_pressed() -> void:
	pass # Replace with function body.
	

func _on_aide_pressed() -> void:
	help_panel.show()
	
func _on_quit_help_panel_pressed() -> void:
	help_panel.hide()

func _on_quitter_pressed() -> void:
	get_tree().quit()
