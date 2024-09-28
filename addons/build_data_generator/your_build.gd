class_name YourBuild
extends Node

const PATH_SETTING := "addons/BuildDataGenerator/build_data_path"
const BUILD_DATA_FILENAME := "build_data.json"
static var build_data_path: String:
	get:
		var dir_path := ProjectSettings.get_setting(PATH_SETTING)
		if dir_path != "res://":
			dir_path += "/"
		return dir_path + BUILD_DATA_FILENAME
static var json: JSON
static var git_branch: String:
	get:
		if json == null:
			_load_build_data()
			if json == null:
				return ""
		return json.data.git_branch
static var git_commit_hash: String:
	get:
		if json == null:
			_load_build_data()
			if json == null:
				return ""
		return json.data.git_commit_hash
static var git_commit_count: int:
	get:
		if json == null:
			_load_build_data()
			if json == null:
				return -1
		return json.data.git_commit_count
static var has_data: bool:
	get:
		return has_git_data
static var has_git_data: bool:
	get:
		return git_branch != "" or git_commit_hash != "" or git_commit_count != -1


static func get_git_commit_hash(length: int = 40) -> String:
	if not has_git_data:
		return ""
	return git_commit_hash.substr(0, length)


static func _load_build_data() -> JSON:
	var directory_path: String = ProjectSettings.get_setting(PATH_SETTING, "")
	if directory_path == "":
		push_error("YourBuild Error. Cannot find path setting. "
				+ "Try enabling the plugin.")
		return null

	if not ResourceLoader.exists(build_data_path):
		push_error("YourBuild Error. Cannot find data file. "
				+ "Try exporting once to generate it.")
		return null

	json = load(build_data_path)
	return json
