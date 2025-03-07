# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

extends RefCounted

const INITIAL_VALUE := "initial"
var value: Variant = INITIAL_VALUE
var value_2: Variant = INITIAL_VALUE
var value_3: Variant = INITIAL_VALUE
var optional_value: Variant = INITIAL_VALUE


func set_to_5(optional_arg: Variant = null) -> void:
	value = 5
	if optional_arg != null:
		optional_value = optional_arg


func set_value(arg: Variant, optional_arg: Variant = null) -> void:
	value = arg
	if optional_arg != null:
		optional_value = optional_arg


func set_value_2(arg: Variant, optional_arg: Variant = null) -> void:
	value_2 = arg
	if optional_arg != null:
		optional_value = optional_arg


func set_value_3(arg: Variant, optional_arg: Variant = null) -> void:
	value_3 = arg
	if optional_arg != null:
		optional_value = optional_arg


func return_true(optional_arg: Variant = null) -> bool:
	if optional_arg != null:
		optional_value = optional_arg
	return true


func return_false(optional_arg: Variant = null) -> bool:
	if optional_arg != null:
		optional_value = optional_arg
	return false

