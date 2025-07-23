@tool
extends EditorPlugin

const FAILURE_CODE: int = -1
const DOCK_SLOT := DOCK_SLOT_LEFT_UR # Same as default for Import dock
const Constants := preload("constants.gd")
const Notice := preload("notice.gd")
const LicenseDock := preload("license_dock.tscn")
const SettingsTab := preload("settings_tab.tscn")
const ConsolePanel := preload("console_panel.tscn")
const DeleteFileDialog := preload("delete_file_dialog.tscn")
const ConsolePanelShortcut := preload("console_panel_shortcut.tres")
var license_dock: Control
var settings_tab: Control
var console_panel: Control
var delete_file_dialog: Window
var filesystem_dock: FileSystemDock
var notices_data: PackedStringArray
var license_ids_data: PackedStringArray


func _enter_tree() -> void:
	# Settings
	var editor_settings := EditorInterface.get_editor_settings()
	if not editor_settings.has_setting(Constants.REUSE_PATH_SETTING):
		editor_settings.set_setting(Constants.REUSE_PATH_SETTING, "reuse")
	editor_settings.set_initial_value(Constants.REUSE_PATH_SETTING, "reuse", false)
	editor_settings.add_property_info(
		{
			"name": Constants.REUSE_PATH_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_GLOBAL_FILE
		}
	)

	# License dock
	license_dock = LicenseDock.instantiate()
	add_control_to_dock(DOCK_SLOT, license_dock)
	_setup_license_dock()

	# ProjectSettings tab
	settings_tab = SettingsTab.instantiate()
	add_control_to_container(CONTAINER_PROJECT_SETTING_TAB_RIGHT, settings_tab)
	load_project_settings()
	_setup_notices_tab()
	_setup_licenses_tab()

	# Console panel
	console_panel = ConsolePanel.instantiate()
	add_control_to_bottom_panel(console_panel, "GDREUSE", ConsolePanelShortcut)
	_setup_console_panel()

	# Delete-file dialog
	delete_file_dialog = DeleteFileDialog.instantiate()
	delete_file_dialog.set_unparent_when_invisible(true)
	delete_file_dialog.confirmed.connect(_on_delete_license_file_confirmed)

	# Filesystem features
	filesystem_dock = EditorInterface.get_file_system_dock()
	filesystem_dock.files_moved.connect(_on_file_moved)
	filesystem_dock.file_removed.connect(_on_file_removed)


func _exit_tree() -> void:
	# License dock
	remove_control_from_docks(license_dock)
	license_dock.queue_free()

	# ProjectSettings tab
	remove_control_from_container(CONTAINER_PROJECT_SETTING_TAB_RIGHT, settings_tab)
	settings_tab.queue_free()

	# Console panel
	remove_control_from_bottom_panel(console_panel)
	console_panel.queue_free()

	# Delete-file dialog
	delete_file_dialog.queue_free()

	# Filesystem features
	filesystem_dock.files_moved.disconnect(_on_file_moved)
	filesystem_dock.file_removed.disconnect(_on_file_removed)


func _input(event: InputEvent) -> void:
	# React to file selection after selection is updated
	if event.is_pressed():
		license_dock.focus_by_selection.call_deferred()


func save_project_settings() -> void:
	ProjectSettings.set_setting(Constants.NOTICES_SETTING, notices_data)
	ProjectSettings.set_setting(Constants.LICENSE_IDS_SETTING, license_ids_data)
	var error := ProjectSettings.save()
	if error != OK:
		push_error("GDREUSE Error: %s. Failed to save ProjectSettings."
				% error_string(error))


func load_project_settings() -> void:
	# Notices
	for notice_data in ProjectSettings.get_setting(Constants.NOTICES_SETTING, []):
		var notice := Notice.new(notice_data)
		if not notice.is_valid():
			push_warning("GDREUSE Warning: Ignoring invalid notice: "
					+ notice.get_data_string())
			continue
		add_notice_template(notice)

	# License IDs
	for license_id in ProjectSettings.get_setting(Constants.LICENSE_IDS_SETTING, []):
		add_license_id(license_id)


#==========================================================
# Commands
#==========================================================


func annotate_notice(filepath: String, notice: Notice) -> void:
	var command = EditorInterface.get_editor_settings().get_setting(Constants.REUSE_PATH_SETTING)
	var args := PackedStringArray([
		"annotate",
		"--copyright-prefix",
		notice.get_prefix_command(),
		"--copyright",
		notice.holder_text,
		ProjectSettings.globalize_path(filepath),
	])
	if notice.year_option == 1:
		args.append("--exclude-year")
	elif notice.year_option == 2:
		args.append("--year")
		args.append(notice.year_text)
	if license_dock.is_gdscript(filepath):
		args.append("--style")
		args.append("python")
	elif license_dock.is_gdshader(filepath):
		args.append("--style")
		args.append("cpp")
	else:
		args.append("--force-dot-license")
	var output: Array = []
	var exit_code := OS.execute(command, args, output, true)

	var command_text := get_command_text(command, args)
	if exit_code == FAILURE_CODE:
		push_error("GDREUSE Error: Failed to execute command: %s" % command_text)
		return
	console_panel.show_command_output(command_text, output)


func annotate_license(filepath: String, license_id: String) -> void:
	var command = EditorInterface.get_editor_settings().get_setting(Constants.REUSE_PATH_SETTING)
	var args := PackedStringArray([
		"annotate",
		"--license",
		license_id,
		ProjectSettings.globalize_path(filepath)
	])
	if license_dock.is_gdscript(filepath):
		args.append("--style")
		args.append("python")
	elif license_dock.is_gdshader(filepath):
		args.append("--style")
		args.append("cpp")
	else:
		args.append("--force-dot-license")
	var output: Array = []
	var exit_code := OS.execute(command, args, output, true)

	var command_text := get_command_text(command, args)
	if exit_code == FAILURE_CODE:
		push_error("GDREUSE Error: Failed to execute command: %s" % command_text)
		return
	console_panel.show_command_output(command_text, output)


func download_licenses() -> void:
	var command = EditorInterface.get_editor_settings().get_setting(Constants.REUSE_PATH_SETTING)
	var args := PackedStringArray(["download", "--all"])
	var output: Array = []
	var exit_code := OS.execute(command, args, output, true)

	var command_text := get_command_text(command, args)
	if exit_code == FAILURE_CODE:
		push_error("GDREUSE Error: Failed to execute command: %s" % command_text)
		return
	console_panel.show_command_output(command_text, output)


func run_lint() -> void:
	var command = EditorInterface.get_editor_settings().get_setting(Constants.REUSE_PATH_SETTING)
	var args := PackedStringArray(["lint"])
	var output: Array = []
	var exit_code := OS.execute(command, args, output, true)

	var command_text := get_command_text(command, args)
	if exit_code == FAILURE_CODE:
		push_error("GDREUSE Error: Failed to execute command: %s" % command_text)
		return
	console_panel.show_command_output(command_text, output)


static func get_command_text(command: String, args: PackedStringArray) -> String:
	return command + " " + " ".join(args)


#==========================================================
# Notices Tab
#==========================================================

func _setup_notices_tab() -> void:
	settings_tab.add_notice_button.icon = EditorInterface.get_editor_theme().get_icon(
			"Add", "EditorIcons")
	settings_tab.add_notice_button.pressed.connect(_on_notice_submitted)
	settings_tab.year_line_edit.text_submitted.connect(_on_notice_submitted.unbind(1))
	settings_tab.holder_line_edit.text_submitted.connect(_on_notice_submitted.unbind(1))
	settings_tab.notices_list.item_selected.connect(_on_notice_item_selected)


func _on_notice_submitted() -> void:
	var notice: Notice = settings_tab.make_notice_object()
	if settings_tab.is_notice_addable(notice):
		add_notice_template(notice)
		save_project_settings()
		settings_tab.year_line_edit.clear()
		settings_tab.holder_line_edit.clear()


func _on_notice_item_selected(index: int) -> void:
	# Odd items are remove-buttons
	if index % 2 == 1:
		@warning_ignore("integer_division")
		var notice_index = (index - 1) / 2
		remove_notice_template(notice_index)
		save_project_settings()


func add_notice_template(notice: Notice) -> void:
	notices_data.append(notice.get_data_string())

	settings_tab.notices_list.add_item(notice.get_string())
	settings_tab.notices_list.add_icon_item(
			EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons"))

	license_dock.add_notice_option(notice)


func remove_notice_template(notice_index: int) -> void:
	notices_data.remove_at(notice_index)

	# Remove both the notice and the remove-button after it
	settings_tab.notices_list.remove_item(notice_index * 2)
	settings_tab.notices_list.remove_item(notice_index * 2)

	license_dock.remove_notice_option(notice_index)


#==========================================================
# Licenses Tab
#==========================================================

func _setup_licenses_tab() -> void:
	settings_tab.add_license_button.icon = EditorInterface.get_editor_theme().get_icon(
			"Add", "EditorIcons")
	settings_tab.add_license_button.pressed.connect(_on_license_submitted)
	settings_tab.license_line_edit.text_submitted.connect(_on_license_submitted.unbind(1))
	settings_tab.licenses_list.item_selected.connect(_on_license_item_selected)

	for license_id in Constants.SPDX_LICENSE_IDS:
		var license_button := Button.new()
		license_button.text = license_id
		settings_tab.license_buttons.add_child(license_button)
		license_button.pressed.connect(_on_license_button_pressed.bind(license_button))
		license_button.disabled = license_ids_data.has(license_id)


func _on_license_submitted() -> void:
	var license = settings_tab.license_line_edit.text
	if settings_tab.is_license_addable(license):
		add_license_id(license)
		save_project_settings()
		settings_tab.license_line_edit.clear()


func _on_license_item_selected(index: int) -> void:
	# Odd items are remove-buttons
	if index % 2 == 1:
		@warning_ignore("integer_division")
		var data_index = (index - 1) / 2
		remove_license_id(data_index)
		save_project_settings()


func _on_license_button_pressed(button: Button) -> void:
	button.disabled = true
	add_license_id(button.text)
	save_project_settings()


func add_license_id(license_id: String) -> void:
	license_ids_data.append(license_id)

	settings_tab.licenses_list.add_item(Constants.LICENSE_PREFIX + license_id)
	settings_tab.licenses_list.add_icon_item(
			EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons"))

	license_dock.add_license_option(license_id)


func remove_license_id(index: int) -> void:
	var license_id := license_ids_data[index]
	license_ids_data.remove_at(index)

	# Remove both the notice and the remove-button after it
	settings_tab.licenses_list.remove_item(index * 2)
	settings_tab.licenses_list.remove_item(index * 2)

	var button = settings_tab.get_license_button(license_id)
	if button != null:
		button.disabled = false

	license_dock.remove_license_option(index)


#==========================================================
# License Dock
#==========================================================

func _setup_license_dock() -> void:
	license_dock.add_notice_button.icon = EditorInterface.get_editor_theme().get_icon(
			"Add", "EditorIcons")
	license_dock.add_license_button.icon = EditorInterface.get_editor_theme().get_icon(
			"Add", "EditorIcons")
	license_dock.delete_file_button.icon = EditorInterface.get_editor_theme().get_icon(
			"Remove", "EditorIcons")
	license_dock.delete_file_button.pressed.connect(_on_delete_file_pressed)
	license_dock.add_notice_button.pressed.connect(_on_add_notice_pressed)
	license_dock.add_license_button.pressed.connect(_on_add_license_pressed)
	EditorInterface.get_resource_filesystem().filesystem_changed.connect(
			license_dock.reload_current_file)
	license_dock.close_file()


func _on_delete_file_pressed() -> void:
	delete_file_dialog.set_text_for_file(license_dock.license_file)
	EditorInterface.popup_dialog_centered(delete_file_dialog)


func _on_delete_license_file_confirmed() -> void:
	_delete_license_file(license_dock.license_file)
	license_dock.reload_current_file()


func _on_add_notice_pressed() -> void:
	var notice = license_dock.get_selected_notice()
	annotate_notice(license_dock.focused_file, notice)
	license_dock.reload_current_file()


func _on_add_license_pressed() -> void:
	var license_id = license_dock.get_selected_license_id()
	annotate_license(license_dock.focused_file, license_id)
	license_dock.reload_current_file()


#==========================================================
# Console Panel
#==========================================================

func _setup_console_panel() -> void:
	console_panel.console.add_theme_font_override(
		"font", EditorInterface.get_editor_theme().get_font(
			"output_source", "EditorFonts"
		)
	)
	console_panel.command.add_theme_font_override(
		"font", EditorInterface.get_editor_theme().get_font(
			"output_source", "EditorFonts"
		)
	)
	var editor_settings := EditorInterface.get_editor_settings()
	var output_font_size = editor_settings.get_setting(Constants.OUTPUT_FONT_SIZE_SETTING)
	console_panel.console.add_theme_font_size_override("font_size", output_font_size)
	console_panel.command.add_theme_font_size_override("font_size", output_font_size)
	editor_settings.settings_changed.connect(_on_editor_settings_changed)

	console_panel.download_button.pressed.connect(_on_download_button_pressed)
	console_panel.lint_button.pressed.connect(_on_lint_button_pressed)


func _on_download_button_pressed() -> void:
	download_licenses()

	# Show in filesystem immediately
	EditorInterface.get_resource_filesystem().scan()


func _on_lint_button_pressed() -> void:
	run_lint()


func _on_editor_settings_changed() -> void:
	var editor_settings := EditorInterface.get_editor_settings()
	for setting_name in editor_settings.get_changed_settings():
		var value = editor_settings.get_setting(setting_name)
		match setting_name:
			Constants.OUTPUT_FONT_SIZE_SETTING:
				console_panel.console.add_theme_font_size_override("font_size", value)
				console_panel.command.add_theme_font_size_override("font_size", value)


#==========================================================
# Filesystem Features
#==========================================================

func _on_file_moved(old_file: String, new_file: String) -> void:
	var old_license_file := old_file + ".license"
	if FileAccess.file_exists(old_license_file):
		var new_license_file := new_file + ".license"
		var error := DirAccess.rename_absolute(old_license_file, new_license_file)
		if error != OK:
			push_error("GDREUSE Error: %s. Failed to move .license file."
					% error_string(error))


func _on_file_removed(file: String) -> void:
	_delete_license_file(file + ".license")


func _delete_license_file(filepath: String) -> void:
	if FileAccess.file_exists(filepath):
		var error := DirAccess.remove_absolute(filepath)
		if error != OK:
			push_error("GDREUSE Error: %s. Failed to delete .license file."
					% error_string(error))
