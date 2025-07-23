@tool
extends EditorPlugin

const TAB_INDENT: int = 0
const FAILURE_CODE: int = -1
const Constants := preload("constants.gd")
const ConsolePanel := preload("console_panel.tscn")
const ScriptMenuPlugin := preload("script_menu_plugin.gd")
const FileMenuPlugin := preload("file_menu_plugin.gd")
const ConsolePanelShortcut := preload("console_panel_shortcut.tres")
const FormatScriptShortcut := preload("format_script_shortcut.tres")
var console_panel: Control
var script_menu_plugin: EditorContextMenuPlugin
var file_menu_plugin: EditorContextMenuPlugin


func _enter_tree() -> void:
	# Settings
	var editor_settings := EditorInterface.get_editor_settings()
	if not editor_settings.has_setting(Constants.ENABLE_GDLINT_SETTING):
		editor_settings.set_setting(Constants.ENABLE_GDLINT_SETTING, true)
	editor_settings.set_initial_value(Constants.ENABLE_GDLINT_SETTING, true, false)
	if not editor_settings.has_setting(Constants.ENABLE_GDFORMAT_SETTING):
		editor_settings.set_setting(Constants.ENABLE_GDFORMAT_SETTING, true)
	editor_settings.set_initial_value(Constants.ENABLE_GDFORMAT_SETTING, true, false)
	if not editor_settings.has_setting(Constants.ENABLE_GDPARSE_SETTING):
		editor_settings.set_setting(Constants.ENABLE_GDPARSE_SETTING, false)
	editor_settings.set_initial_value(Constants.ENABLE_GDPARSE_SETTING, false, false)
	if not editor_settings.has_setting(Constants.ENABLE_GDRADON_SETTING):
		editor_settings.set_setting(Constants.ENABLE_GDRADON_SETTING, false)
	editor_settings.set_initial_value(Constants.ENABLE_GDRADON_SETTING, false, false)
	if not editor_settings.has_setting(Constants.GDLINT_PATH_SETTING):
		editor_settings.set_setting(Constants.GDLINT_PATH_SETTING, "gdlint")
	editor_settings.set_initial_value(Constants.GDLINT_PATH_SETTING, "gdlint", false)
	editor_settings.add_property_info(
		{
			"name": Constants.GDLINT_PATH_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_GLOBAL_FILE
		}
	)
	if not editor_settings.has_setting(Constants.GDFORMAT_PATH_SETTING):
		editor_settings.set_setting(Constants.GDFORMAT_PATH_SETTING, "gdformat")
	editor_settings.set_initial_value(Constants.GDFORMAT_PATH_SETTING, "gdformat", false)
	editor_settings.add_property_info(
		{
			"name": Constants.GDFORMAT_PATH_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_GLOBAL_FILE
		}
	)
	if not editor_settings.has_setting(Constants.GDPARSE_PATH_SETTING):
		editor_settings.set_setting(Constants.GDPARSE_PATH_SETTING, "gdparse")
	editor_settings.set_initial_value(Constants.GDPARSE_PATH_SETTING, "gdparse", false)
	editor_settings.add_property_info(
		{
			"name": Constants.GDPARSE_PATH_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_GLOBAL_FILE
		}
	)
	if not editor_settings.has_setting(Constants.GDRADON_PATH_SETTING):
		editor_settings.set_setting(Constants.GDRADON_PATH_SETTING, "gdradon")
	editor_settings.set_initial_value(Constants.GDRADON_PATH_SETTING, "gdradon", false)
	editor_settings.add_property_info(
		{
			"name": Constants.GDRADON_PATH_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_GLOBAL_FILE
		}
	)
	if not editor_settings.has_setting(Constants.PRIORITIZE_GDFORMATRC_SETTING):
		editor_settings.set_setting(Constants.PRIORITIZE_GDFORMATRC_SETTING, true)
	editor_settings.set_initial_value(Constants.PRIORITIZE_GDFORMATRC_SETTING, true, false)
	if not editor_settings.has_setting(Constants.FORMAT_ON_SAVE_SETTING):
		editor_settings.set_setting(Constants.FORMAT_ON_SAVE_SETTING, false)
	editor_settings.set_initial_value(Constants.FORMAT_ON_SAVE_SETTING, false, false)

	# Console panel
	console_panel = ConsolePanel.instantiate()
	add_control_to_bottom_panel(console_panel, "GDgdtoolkit", ConsolePanelShortcut)
	_setup_console_panel()

	# Context menus
	file_menu_plugin = FileMenuPlugin.new()
	add_context_menu_plugin(EditorContextMenuPlugin.CONTEXT_SLOT_FILESYSTEM, file_menu_plugin)
	file_menu_plugin.gdlint_pressed.connect(_on_file_gdlint_pressed)
	file_menu_plugin.gdformat_pressed.connect(_on_file_gdformat_pressed)
	file_menu_plugin.gdformat_diff_pressed.connect(_on_file_gdformat_diff_pressed)
	file_menu_plugin.gdparse_pressed.connect(_on_file_gdparse_pressed)
	file_menu_plugin.gdradon_pressed.connect(_on_file_gdradon_pressed)

	script_menu_plugin = ScriptMenuPlugin.new()
	add_context_menu_plugin(EditorContextMenuPlugin.CONTEXT_SLOT_SCRIPT_EDITOR, script_menu_plugin)
	script_menu_plugin.add_menu_shortcut(FormatScriptShortcut, _on_script_gdformat_pressed)
	script_menu_plugin.gdlint_pressed.connect(_on_script_gdlint_pressed)
	script_menu_plugin.gdformat_diff_pressed.connect(_on_script_gdformat_diff_pressed)
	script_menu_plugin.gdparse_pressed.connect(_on_script_gdparse_pressed)
	script_menu_plugin.gdradon_pressed.connect(_on_script_gdradon_pressed)

	# Format on save
	resource_saved.connect(_on_resource_saved)


func _exit_tree() -> void:
	# Console panel
	remove_control_from_bottom_panel(console_panel)
	console_panel.queue_free()

	# Context menus
	remove_context_menu_plugin(file_menu_plugin)
	remove_context_menu_plugin(script_menu_plugin)

	# Format on save
	resource_saved.disconnect(_on_resource_saved)


func _on_resource_saved(resource: Resource) -> void:
	if (
		resource is GDScript
		and EditorInterface.get_editor_settings().get_setting(Constants.ENABLE_GDFORMAT_SETTING)
		and EditorInterface.get_editor_settings().get_setting(Constants.FORMAT_ON_SAVE_SETTING)
	):
		run_gdformat_script(resource)


#==========================================================
# Commands
#==========================================================


func run_gdlint(paths: PackedStringArray) -> void:
	var command = EditorInterface.get_editor_settings().get_setting(Constants.GDLINT_PATH_SETTING)
	var output: Array = []
	var exit_code := OS.execute(command, paths, output, true)

	var command_text := get_command_text(command, paths)
	if exit_code == FAILURE_CODE:
		push_error("GDgdtoolkit Error: Failed to execute command: %s" % command_text)
	console_panel.show_command_output(command_text, output)


func run_gdformat_diff(paths: PackedStringArray) -> void:
	var command = EditorInterface.get_editor_settings().get_setting(Constants.GDFORMAT_PATH_SETTING)
	var args := paths + PackedStringArray(["--diff"])
	var line_length_arg := get_line_length_arg()
	if line_length_arg != "":
		args.append(line_length_arg)
	var space_indent_arg := get_space_indent_arg()
	if space_indent_arg != "":
		args.append(space_indent_arg)
	var output: Array = []
	var exit_code := OS.execute(command, args, output, true)

	var command_text := get_command_text(command, args)
	if exit_code == FAILURE_CODE:
		push_error("GDgdtoolkit Error: Failed to execute command: %s" % command_text)
	console_panel.show_command_output(command_text, output)


func run_gdformat_files(paths: PackedStringArray) -> void:
	var command = EditorInterface.get_editor_settings().get_setting(Constants.GDFORMAT_PATH_SETTING)
	var args := paths
	var line_length_arg := get_line_length_arg()
	if line_length_arg != "":
		args.append(line_length_arg)
	var space_indent_arg := get_space_indent_arg()
	if space_indent_arg != "":
		args.append(space_indent_arg)
	var output: Array = []
	var exit_code := OS.execute(command, args, output, true)

	var command_text := get_command_text(command, args)
	if exit_code == FAILURE_CODE:
		push_error("GDgdtoolkit Error: Failed to execute command: %s" % command_text)
	console_panel.show_command_output(command_text, output)


func run_gdformat_script(script: GDScript) -> void:
	var path := ProjectSettings.globalize_path(script.resource_path)
	var command = EditorInterface.get_editor_settings().get_setting(Constants.GDFORMAT_PATH_SETTING)
	var args := PackedStringArray([path])
	var line_length_arg := get_line_length_arg()
	if line_length_arg != "":
		args.append(line_length_arg)
	var space_indent_arg := get_space_indent_arg()
	if space_indent_arg != "":
		args.append(space_indent_arg)

	# Run check first
	var checking_args := args + PackedStringArray(["--check"])
	var output: Array = []
	var exit_code := OS.execute(command, checking_args, output, true)
	var command_text := get_command_text(command, checking_args)

	# Format only if there will be any change
	if exit_code != FAILURE_CODE and output[0].contains("reformatted"):
		output = []
		command_text = get_command_text(command, args)
		exit_code = OS.execute(command, args, output, true)

		# Hack to reload script immediately
		if exit_code != FAILURE_CODE:
			if script == (EditorInterface.get_script_editor().get_current_script()):
				var formatted_source := FileAccess.get_file_as_string(path)
				var text_edit := (
					EditorInterface.get_script_editor().get_current_editor().get_base_editor()
				)
				reload_script(text_edit, formatted_source)

	if exit_code == FAILURE_CODE:
		push_error("GDgdtoolkit Error: Failed to execute command: %s" % command_text)
	console_panel.show_command_output(command_text, output)


func run_gdparse(path: String) -> void:
	var command = EditorInterface.get_editor_settings().get_setting(Constants.GDPARSE_PATH_SETTING)
	var args := PackedStringArray([path, "--pretty"])
	var output: Array = []
	var exit_code := OS.execute(command, args, output, true)

	var command_text := get_command_text(command, args)
	if exit_code == FAILURE_CODE:
		push_error("GDgdtoolkit Error: Failed to execute command: %s" % command_text)
	console_panel.show_command_output(command_text, output)


func run_gdradon(paths: PackedStringArray) -> void:
	var command = EditorInterface.get_editor_settings().get_setting(Constants.GDRADON_PATH_SETTING)
	var args := PackedStringArray(["cc"]) + paths
	var output: Array = []
	var exit_code := OS.execute(command, args, output, true)

	var command_text := get_command_text(command, args)
	if exit_code == FAILURE_CODE:
		push_error("GDgdtoolkit Error: Failed to execute command: %s" % command_text)
	console_panel.show_command_output(command_text, output)


# Source: https://github.com/godotengine/godot/pull/83267
static func reload_script(text_edit: TextEdit, source_code: String) -> void:
	var column := text_edit.get_caret_column()
	var row := text_edit.get_caret_line()
	var scroll_position_h := text_edit.get_h_scroll_bar().value
	var scroll_position_v := text_edit.get_v_scroll_bar().value

	text_edit.text = source_code
	text_edit.set_caret_column(column)
	text_edit.set_caret_line(row)
	text_edit.scroll_horizontal = int(scroll_position_h)
	text_edit.scroll_vertical = scroll_position_v

	text_edit.tag_saved_version()


static func get_command_text(command: String, args: PackedStringArray) -> String:
	return command + " " + " ".join(args)


func get_line_length_arg() -> String:
	var editor_settings := EditorInterface.get_editor_settings()
	if (
		editor_settings.get_setting(Constants.PRIORITIZE_GDFORMATRC_SETTING)
		and (
			FileAccess.file_exists("res://gdformatrc")
			or FileAccess.file_exists("res://.gdformatrc")
		)
	):
		return ""

	var line_length = editor_settings.get_setting(Constants.LINE_LENGTH_SETTING)
	return "--line-length=" + str(line_length)


func get_space_indent_arg() -> String:
	var editor_settings := EditorInterface.get_editor_settings()
	if (
		(
			editor_settings.get_setting(Constants.PRIORITIZE_GDFORMATRC_SETTING)
			and (
				FileAccess.file_exists("res://gdformatrc")
				or FileAccess.file_exists("res://.gdformatrc")
			)
		)
		or (editor_settings.get_setting(Constants.INDENT_TYPE_SETTING) == TAB_INDENT)
	):
		return ""

	var indent_size = editor_settings.get_setting(Constants.INDENT_SIZE_SETTING)
	return "--use-spaces=" + str(indent_size)


#==========================================================
# Console Panel
#==========================================================


func _setup_console_panel() -> void:
	console_panel.console.add_theme_font_override(
		"font", EditorInterface.get_editor_theme().get_font("output_source", "EditorFonts")
	)
	console_panel.command.add_theme_font_override(
		"font", EditorInterface.get_editor_theme().get_font("output_source", "EditorFonts")
	)
	var editor_settings := EditorInterface.get_editor_settings()
	var output_font_size = editor_settings.get_setting(Constants.OUTPUT_FONT_SIZE_SETTING)
	console_panel.console.add_theme_font_size_override("font_size", output_font_size)
	console_panel.command.add_theme_font_size_override("font_size", output_font_size)
	editor_settings.settings_changed.connect(_on_editor_settings_changed)

	console_panel.lint_button.pressed.connect(_on_lint_button_pressed)
	console_panel.format_diff_button.pressed.connect(_on_format_diff_button_pressed)
	console_panel.complexity_button.pressed.connect(_on_complexity_button_pressed)

	if not editor_settings.get_setting(Constants.ENABLE_GDLINT_SETTING):
		console_panel.lint_button.hide()
	if not editor_settings.get_setting(Constants.ENABLE_GDFORMAT_SETTING):
		console_panel.format_diff_button.hide()
	if not editor_settings.get_setting(Constants.ENABLE_GDRADON_SETTING):
		console_panel.complexity_button.hide()


func _on_lint_button_pressed() -> void:
	var project_path := ProjectSettings.globalize_path("res://")
	run_gdlint([project_path])


func _on_format_diff_button_pressed() -> void:
	var project_path := ProjectSettings.globalize_path("res://")
	run_gdformat_diff([project_path])


func _on_complexity_button_pressed() -> void:
	var project_path := ProjectSettings.globalize_path("res://")
	run_gdradon([project_path])


func _on_editor_settings_changed() -> void:
	var editor_settings := EditorInterface.get_editor_settings()
	for setting_name in editor_settings.get_changed_settings():
		var value = editor_settings.get_setting(setting_name)
		match setting_name:
			Constants.OUTPUT_FONT_SIZE_SETTING:
				console_panel.console.add_theme_font_size_override("font_size", value)
				console_panel.command.add_theme_font_size_override("font_size", value)
			Constants.ENABLE_GDLINT_SETTING:
				console_panel.lint_button.visible = value
			Constants.ENABLE_GDFORMAT_SETTING:
				console_panel.format_diff_button.visible = value
			Constants.ENABLE_GDRADON_SETTING:
				console_panel.complexity_button.visible = value


#==========================================================
# Context Menus
#==========================================================


func _on_file_gdlint_pressed(paths: PackedStringArray) -> void:
	var global_paths: PackedStringArray
	for path in paths:
		if path.get_extension() == "gd" or DirAccess.dir_exists_absolute(path):
			global_paths.append(ProjectSettings.globalize_path(path))
	run_gdlint(global_paths)


func _on_file_gdformat_pressed(paths: PackedStringArray) -> void:
	var global_paths: PackedStringArray
	for path in paths:
		if path.get_extension() == "gd" or DirAccess.dir_exists_absolute(path):
			global_paths.append(ProjectSettings.globalize_path(path))
	run_gdformat_files(global_paths)


func _on_file_gdformat_diff_pressed(paths: PackedStringArray) -> void:
	var global_paths: PackedStringArray
	for path in paths:
		if path.get_extension() == "gd" or DirAccess.dir_exists_absolute(path):
			global_paths.append(ProjectSettings.globalize_path(path))
	run_gdformat_diff(global_paths)


func _on_file_gdparse_pressed(paths: PackedStringArray) -> void:
	var global_path := ProjectSettings.globalize_path(paths[0])
	run_gdparse(global_path)


func _on_file_gdradon_pressed(paths: PackedStringArray) -> void:
	var global_paths: PackedStringArray
	for path in paths:
		if path.get_extension() == "gd" or DirAccess.dir_exists_absolute(path):
			global_paths.append(ProjectSettings.globalize_path(path))
	run_gdradon(global_paths)


func _on_script_gdlint_pressed(_script: GDScript, path: String) -> void:
	var global_path := ProjectSettings.globalize_path(path)
	run_gdlint(PackedStringArray([global_path]))


func _on_script_gdformat_pressed(script: GDScript) -> void:
	run_gdformat_script(script)


func _on_script_gdformat_diff_pressed(_script: GDScript, path: String) -> void:
	var global_path := ProjectSettings.globalize_path(path)
	run_gdformat_diff(PackedStringArray([global_path]))


func _on_script_gdparse_pressed(_script: GDScript, path: String) -> void:
	var global_path := ProjectSettings.globalize_path(path)
	run_gdparse(global_path)


func _on_script_gdradon_pressed(_script: GDScript, path: String) -> void:
	var global_path := ProjectSettings.globalize_path(path)
	run_gdradon(PackedStringArray([global_path]))
