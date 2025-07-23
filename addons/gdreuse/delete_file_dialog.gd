@tool
extends ConfirmationDialog


func set_text_for_file(filepath: String) -> void:
	dialog_text = ('Delete the file "%s"? (This action cannot be undone.)'
			% filepath.get_file())
