extends EditorContextMenuPlugin

signal gdlint_pressed(script: GDScript, path: String)
signal gdformat_diff_pressed(script: GDScript, path: String)
signal gdparse_pressed(script: GDScript, path: String)
signal gdradon_pressed(script: GDScript, path: String)

const Constants := preload("constants.gd")
const FormatScriptShortcut := preload("format_script_shortcut.tres")


func _popup_menu(paths: PackedStringArray) -> void:
	for path in paths:
		if path.get_extension() == "gd":
			var editor_settings := EditorInterface.get_editor_settings()
			if editor_settings.get_setting(Constants.ENABLE_GDLINT_SETTING):
				add_context_menu_item("gdlint", gdlint_pressed.emit.bind(path))
			if editor_settings.get_setting(Constants.ENABLE_GDFORMAT_SETTING):
				add_context_menu_item_from_shortcut("gdformat", FormatScriptShortcut)
				add_context_menu_item("gdformat --diff", gdformat_diff_pressed.emit.bind(path))
			if editor_settings.get_setting(Constants.ENABLE_GDPARSE_SETTING):
				add_context_menu_item("gdparse", gdparse_pressed.emit.bind(path))
			if editor_settings.get_setting(Constants.ENABLE_GDRADON_SETTING):
				add_context_menu_item("gdradon", gdradon_pressed.emit.bind(path))
			return
