extends RefCounted

const DELIMITER := "\\"
const CUSTOM_YEAR: int = 2
var prefix_option: int = -1
var year_option: int = -1
var year_text := ""
var holder_text := ""


func _init(data_string := "") -> void:
	if data_string != "":
		if data_string.count(DELIMITER) != 3:
			push_error("GDREUSE Error: Failed to init Notice from string.")
			return
		var data := data_string.split(DELIMITER)
		prefix_option = int(data[0])
		year_option = int(data[1])
		year_text = data[2]
		holder_text = data[3]


func get_data_string() -> String:
	return (
		str(prefix_option) + DELIMITER
		+ str(year_option) + DELIMITER
		+ year_text + DELIMITER
		+ holder_text
	)


func get_string() -> String:
	var year_space = ""
	if get_year_string() != "":
		year_space = " "
	return get_prefix_string() + " " + get_year_string() + year_space + holder_text


func get_prefix_string() -> String:
	match prefix_option:
		0:
			return "SPDX-FileCopyrightText:"
		1:
			return "SPDX-FileCopyrightText: (C)"
		2:
			return "SPDX-FileCopyrightText: ©"
		3:
			return "SPDX-FileCopyrightText: Copyright"
		4:
			return "SPDX-FileCopyrightText: Copyright (C)"
		5:
			return "SPDX-FileCopyrightText: Copyright ©"
		6:
			return "Copyright"
		7:
			return "Copyright (C)"
		8:
			return "Copyright ©"
		9:
			return "©"
	push_error("GDREUSE Error")
	return "ERROR"


func get_prefix_command() -> String:
	match prefix_option:
		0:
			return "spdx"
		1:
			return "spdx-c"
		2:
			return "spdx-symbol"
		3:
			return "spdx-string"
		4:
			return "spdx-string-c"
		5:
			return "spdx-string-symbol"
		6:
			return "string"
		7:
			return "string-c"
		8:
			return "string-symbol"
		9:
			return "symbol"
	push_error("GDREUSE Error")
	return "ERROR"


func get_year_string() -> String:
	match year_option:
		0:
			return "[current year]"
		1:
			return ""
		2:
			return year_text
	push_error("GDREUSE Error")
	return "ERROR"


func is_valid() -> bool:
	if prefix_option < 0 or prefix_option > 9:
		return false
	if year_option < 0 or year_option > 2:
		return false
	if year_option == CUSTOM_YEAR and year_text == "":
		return false
	if holder_text == "":
		return false
	if year_text.contains(DELIMITER):
		return false
	if holder_text.contains(DELIMITER):
		return false
	return true
