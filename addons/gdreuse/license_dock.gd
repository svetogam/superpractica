@tool
extends Control

const Constants := preload("constants.gd")
const Notice := preload("notice.gd")
var focused_file := ""
var license_file := ""
var _loaded_file_lines: PackedStringArray
var _notices: Array[Notice]
var _license_ids: Array[String]
@onready var add_notice_button: Button = %AddNoticeButton as Button
@onready var add_license_button: Button = %AddLicenseButton as Button
@onready var delete_file_button: Button = %DeleteFileButton as Button


static func to_license_file(file: String) -> String:
	return file + ".license"


static func is_gdscript(file: String) -> bool:
	return file.get_extension() == "gd"


static func is_gdshader(file: String) -> bool:
	return file.get_extension() == "gdshader"


func _ready() -> void:
	# Fetch colors from editor theme
	%TextEdit.add_theme_color_override("background_color",
		EditorInterface.get_editor_theme().get_color("dark_color_1", "Editor")
	)
	%TextEdit.add_theme_color_override("font_readonly_color",
		EditorInterface.get_editor_theme().get_color("font_color", "Editor")
	)

	%NoticeOptionButton.item_selected.connect(_update_buttons.unbind(1))
	%LicenseOptionButton.item_selected.connect(_update_buttons.unbind(1))


func _update_buttons() -> void:
	var notice_string := get_selected_notice().get_string()
	var license_string := Constants.LICENSE_PREFIX + get_selected_license_id()
	add_notice_button.disabled = (
		%NoticeOptionButton.selected < 0
		or (focused_file == "" and license_file == "")
		or (not license_file.is_empty() and _loaded_file_lines.has(notice_string))
		or (is_gdscript(focused_file) and has_in_gdscript_header(notice_string))
		or (is_gdshader(focused_file) and has_in_gdshader_header(notice_string))
	)
	add_license_button.disabled = (
		%LicenseOptionButton.selected < 0
		or (focused_file == "" and license_file == "")
		or (not license_file.is_empty() and _loaded_file_lines.has(license_string))
		or (is_gdscript(focused_file) and has_in_gdscript_header(license_string))
		or (is_gdshader(focused_file) and has_in_gdshader_header(license_string))
	)


func focus_by_selection() -> void:
	var paths := EditorInterface.get_selected_paths()
	if not paths.is_empty():
		var filepath := paths[0]
		# Only reload if file to focus changes
		if filepath != focused_file:
			open_file(paths[0])
	else:
		close_file()


func add_notice_option(notice: Notice) -> void:
	_notices.append(notice)
	%NoticeOptionButton.add_item(notice.get_string())


func remove_notice_option(index: int) -> void:
	_notices.remove_at(index)
	%NoticeOptionButton.remove_item(index)


func add_license_option(license_id: String) -> void:
	_license_ids.append(license_id)
	%LicenseOptionButton.add_item(Constants.LICENSE_PREFIX + license_id)


func remove_license_option(index: int) -> void:
	_license_ids.remove_at(index)
	%LicenseOptionButton.remove_item(index)


func open_file(filepath: String) -> void:
	if not FileAccess.file_exists(filepath):
		close_file()
		return

	focused_file = filepath
	%FilenameLabel.show()
	%MainContainer.show()
	%NoSelectionContainer.hide()

	if is_gdscript(filepath) or is_gdshader(filepath):
		_load_code_file(filepath)
		%FilenameLabel.text = filepath.get_file()
		%DeleteFileButton.hide()
		%NoLicenseLabel.hide()
		if _loaded_file_lines.is_empty():
			%NoHeaderLabel.show()
			%TextEdit.hide()
		else:
			%NoHeaderLabel.hide()
			%TextEdit.show()
	else:
		var license_filepath := to_license_file(filepath)
		_load_license_file(license_filepath)
		%NoHeaderLabel.hide()
		if license_file.is_empty():
			%FilenameLabel.text = filepath.get_file()
			%DeleteFileButton.hide()
			%NoLicenseLabel.show()
			%TextEdit.hide()
		else:
			%FilenameLabel.text = license_filepath.get_file()
			%DeleteFileButton.show()
			%NoLicenseLabel.hide()
			%TextEdit.show()


func close_file() -> void:
	focused_file = ""
	license_file = ""
	_loaded_file_lines.clear()
	%FilenameLabel.hide()
	%MainContainer.hide()
	%NoSelectionContainer.show()


func reload_current_file() -> void:
	open_file(focused_file)


func get_selected_notice() -> Notice:
	return _notices[%NoticeOptionButton.selected]


func get_selected_license_id() -> String:
	return _license_ids[%LicenseOptionButton.selected]


func has_in_gdscript_header(string: String) -> bool:
	return _loaded_file_lines.has(Constants.GDSCRIPT_COMMENT + " " + string)


func has_in_gdshader_header(string: String) -> bool:
	return _loaded_file_lines.has(Constants.GDSHADER_COMMENT + " " + string)


func _load_license_file(filepath: String) -> void:
	var file := FileAccess.open(filepath, FileAccess.READ)
	_loaded_file_lines.clear()

	if file != null:
		var i: int = 0
		while file.get_position() < file.get_length():
			_loaded_file_lines.append(file.get_line())
			i += 1
			if i >= 100000:
				push_error("GDREUSE Error: Failed to read long .license file.")
				break

		%TextEdit.text = "\n".join(_loaded_file_lines)
		file.close()
		var error := file.get_error()
		if error != OK:
			push_error("GDREUSE Error: %s. Failed to close .license file."
					% error_string(error))
		license_file = filepath

	else:
		var error := FileAccess.get_open_error()
		if error != OK and error != ERR_FILE_NOT_FOUND:
			push_error("GDREUSE Error: %s. Failed to open .license file."
					% error_string(error))
		license_file = ""

	_update_buttons()


func _load_code_file(filepath: String) -> void:
	var comment_prefix: String
	if is_gdscript(filepath):
		comment_prefix = Constants.GDSCRIPT_COMMENT
	elif is_gdshader(filepath):
		comment_prefix = Constants.GDSHADER_COMMENT
	else:
		push_error("GDREUSE Error")
	var file := FileAccess.open(filepath, FileAccess.READ)
	_loaded_file_lines.clear()

	if file != null:
		var i: int = 0
		while file.get_position() < file.get_length():
			var line = file.get_line()
			if line.begins_with(comment_prefix):
				_loaded_file_lines.append(line)
			else:
				break
			i += 1
			if i >= 100000:
				push_error("GDREUSE Error: Failed to read long comment header.")
				break

		%TextEdit.text = "\n".join(_loaded_file_lines)
		file.close()
		var error := file.get_error()
		if error != OK:
			push_error("GDREUSE Error: %s. Failed to close code file."
					% error_string(error))

	else:
		var error := FileAccess.get_open_error()
		if error != OK:
			push_error("GDREUSE Error: %s. Failed to open code file."
					% error_string(error))

	_update_buttons()
