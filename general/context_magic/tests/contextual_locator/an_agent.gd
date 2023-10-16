##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

extends Node

const INITIAL_VALUE := "initial"
var value = INITIAL_VALUE
var value_2 = INITIAL_VALUE
var value_3 = INITIAL_VALUE
var locator: ContextualLocator
var last_given_arg = null
var event_order := []


func auto_callback(found_value, optional_arg=null) -> void:
	value = found_value
	event_order.append("auto_callback")
	if optional_arg != null:
		last_given_arg = optional_arg


func auto_callback_2(found_value, optional_arg=null) -> void:
	value_2 = found_value
	event_order.append("auto_callback_2")
	if optional_arg != null:
		last_given_arg = optional_arg


func auto_callback_3(found_value, optional_arg=null) -> void:
	value_3 = found_value
	event_order.append("auto_callback_3")
	if optional_arg != null:
		last_given_arg = optional_arg


func copy_value_2_to_value_3(_a=null, _b=null) -> void:
	value_3 = value_2
