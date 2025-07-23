extends EditorContextMenuPlugin

signal gdlint_pressed(paths: PackedStringArray)
signal gdformat_pressed(paths: PackedStringArray)
signal gdformat_diff_pressed(paths: PackedStringArray)
signal gdparse_pressed(paths: PackedStringArray)
signal gdradon_pressed(paths: PackedStringArray)

const Constants := preload("constants.gd")


func _popup_menu(paths: PackedStringArray) -> void:
	for path in paths:
		if path.get_extension() == "gd" or DirAccess.dir_exists_absolute(path):
			var editor_settings := EditorInterface.get_editor_settings()
			if editor_settings.get_setting(Constants.ENABLE_GDLINT_SETTING):
				add_context_menu_item("gdlint", gdlint_pressed.emit)
			if editor_settings.get_setting(Constants.ENABLE_GDFORMAT_SETTING):
				add_context_menu_item("gdformat", gdformat_pressed.emit)
				add_context_menu_item("gdformat --diff", gdformat_diff_pressed.emit)
			if (
				editor_settings.get_setting(Constants.ENABLE_GDPARSE_SETTING)
				and paths.size() == 1
				and not DirAccess.dir_exists_absolute(path)
			):
				add_context_menu_item("gdparse", gdparse_pressed.emit)
			if editor_settings.get_setting(Constants.ENABLE_GDRADON_SETTING):
				add_context_menu_item("gdradon", gdradon_pressed.emit)
			return
