extends "res://addons/AutoExportVersion/VersionProvider.gd"

func get_version(_features: PackedStringArray, _is_debug: bool, _path: String, _flags: int
) -> String:
	return get_git_commit_hash(40)
