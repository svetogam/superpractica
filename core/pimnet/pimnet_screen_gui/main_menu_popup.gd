extends PopupPanel


func _on_continue_button_pressed() -> void:
	%MainMenuPopup.visible = false


func _on_settings_button_pressed() -> void:
	pass


func _on_quit_button_pressed() -> void:
	Game.call_deferred("enter_level_select")
