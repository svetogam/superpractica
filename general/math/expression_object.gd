# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

# Incomplete. See test_expression_object.gd for what functionality is incomplete.

class_name ExpressionObject
extends RefCounted

const SYMBOL_MAP := {
	"plus": "+",
	"minus": "-",
	"multiply": "*",
	"divide": "/",
	"open_paren": "(",
	"close_paren": ")",
}
const WHITE_SPACE: Array = [" "]
var _element_list: Array = []
var _invalid := true


static func is_symbol(character: String) -> bool:
	return SYMBOL_MAP.values().has(character)


static func is_white_space(character: String) -> bool:
	return WHITE_SPACE.has(character)


func _init(string := "") -> void:
	if string != "":
		set_by_string(string)


func set_by_string(string: String) -> String:
	clear()

	var i: int = 0
	while i < string.length():
		#Add a number as one item
		if string[i].is_valid_int():
			var number := _get_first_number(string.substr(i))
			var number_length := _get_first_number_length(string.substr(i))
			_element_list.append(str(number))
			i += number_length

		#Add a symbol
		elif is_symbol(string[i]):
			_element_list.append(string[i])
			i += 1

		#Skip whitespace
		elif is_white_space(string[i]):
			i += 1

		else:
			_invalid = true
			return "invalid"

	if string == "":
		_invalid = true
		return "invalid"
	else:
		_invalid = false
		return "valid"


func _get_first_number(string: String) -> int:
	var number_length := _get_first_number_length(string)
	return int(string.left(number_length))


func _get_first_number_length(string: String) -> int:
	var i: int = 1
	while i < string.length() and string[i].is_valid_int():
		i += 1
	return i


func is_empty() -> bool:
	return _element_list.size() == 0


func is_valid() -> bool:
	return not _invalid


func is_identical(other: ExpressionObject) -> bool:
	if is_empty() or other.is_empty() or not is_valid() or not other.is_valid():
		return false
	if _element_list.size() != other._element_list.size():
		return false
	for i in _element_list.size():
		if _element_list[i] != other._element_list[i]:
			return false

	return true


func clear() -> void:
	_element_list = []
	_invalid = true


func get_value():
	return evaluate()


# INCOMPLETE
func evaluate() -> int:
	if is_empty() or not is_valid():
		return 0

	# INCOMPLETE
	return 1


func get_string(use_spaces := false) -> String:
	var output_string := ""
	for element in _element_list:
		if use_spaces and (str(element) == "+" or str(element) == "-"
				or str(element) == "*" or str(element) == "/"
		):
			output_string += " "
			output_string += str(element)
			output_string += " "
		else:
			output_string += str(element)

	return output_string


func get_numbers() -> Array:
	var numbers: Array = []
	for element in _element_list:
		if element.is_valid_int():
			numbers.append(int(element))
	return numbers
