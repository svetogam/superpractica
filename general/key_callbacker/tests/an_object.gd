##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

extends RefCounted

const INITIAL_VALUE := "initial"
var value = INITIAL_VALUE
var value_2 = INITIAL_VALUE
var value_3 = INITIAL_VALUE
var optional_value = INITIAL_VALUE


func set_to_5(optional_arg=null) -> void:
	value = 5
	if optional_arg != null:
		optional_value = optional_arg


func set_value(arg, optional_arg=null) -> void:
	value = arg
	if optional_arg != null:
		optional_value = optional_arg


func set_value_2(arg, optional_arg=null) -> void:
	value_2 = arg
	if optional_arg != null:
		optional_value = optional_arg


func set_value_3(arg, optional_arg=null) -> void:
	value_3 = arg
	if optional_arg != null:
		optional_value = optional_arg


func return_true(optional_arg=null) -> bool:
	if optional_arg != null:
		optional_value = optional_arg
	return true


func return_false(optional_arg=null) -> bool:
	if optional_arg != null:
		optional_value = optional_arg
	return false

