@tool
extends EditorPlugin

const DEFAULT_BUILD_DATA_PATH := "res://"
var _exporter: BDGExporter


class BDGExporter extends EditorExportPlugin:
	signal exporting(features, is_debug, path, flags)

	func _get_name() -> String:
		return "BDGExporter"

	func _export_begin(
		features: PackedStringArray,
		is_debug: bool,
		path: String,
		flags: int
	) -> void:
		exporting.emit(features, is_debug, path, flags)


func _enter_tree() -> void:
	# Connect to run on export
	_exporter = BDGExporter.new()
	_exporter.exporting.connect(_store_build_data)
	add_export_plugin(_exporter)

	# Add project setting
	if not ProjectSettings.has_setting(YourBuild.PATH_SETTING):
		ProjectSettings.set_setting(YourBuild.PATH_SETTING, DEFAULT_BUILD_DATA_PATH)
	ProjectSettings.add_property_info({
		"name": YourBuild.PATH_SETTING,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR
	})
	ProjectSettings.set_initial_value(YourBuild.PATH_SETTING, DEFAULT_BUILD_DATA_PATH)


func _exit_tree() -> void:
	remove_export_plugin(_exporter)


func _store_build_data(features: PackedStringArray, is_debug: bool, path: String,
		flags: int
) -> void:
	var data: Dictionary
	data["git_branch"] = _get_git_branch()
	data["git_commit_hash"] = _get_git_commit_hash()
	data["git_commit_count"] = _get_git_commit_count()

	var json_string := JSON.stringify(data, "\t")
	var json := JSON.new()
	json.parse(json_string)
	var error := ResourceSaver.save(json, YourBuild.build_data_path)
	if error != OK:
		push_error("YourBuild Error: %s. Failed to write build data file."
				% error_string(error))

	# Show file in filesystem
	EditorInterface.get_resource_filesystem().scan()


func _get_git_branch() -> String:
	var output: Array = []
	OS.execute("git", PackedStringArray(["rev-parse", "--abbrev-ref", "HEAD"]), output)
	if output.is_empty() or output[0].is_empty():
		push_error("Failed to fetch version. "
				+ "Make sure you have git installed and project is inside "
				+ "a valid git directory.")
		return ""
	return output[0].trim_suffix("\n")


func _get_git_commit_hash() -> String:
	var output: Array = []
	OS.execute("git", PackedStringArray(["rev-parse", "HEAD"]), output)
	if output.is_empty() or output[0].is_empty():
		push_error("Failed to fetch version. "
				+ "Make sure you have git installed and project is inside "
				+ "a valid git directory.")
		return ""
	return output[0].trim_suffix("\n")


func _get_git_commit_count() -> int:
	var output: Array = []
	OS.execute("git", PackedStringArray(["rev-list", "--count", "HEAD"]), output)
	if output.is_empty() or output[0].is_empty():
		push_error("Failed to fetch version. "
				+ "Make sure you have git installed and project is inside "
				+ "a valid git directory.")
		return -1
	return output[0].trim_suffix("\n").to_int()
