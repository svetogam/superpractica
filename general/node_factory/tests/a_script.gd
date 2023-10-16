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

var was_setup := false
var setup_vars := []


func _ready() -> void:
	var context = get_parent()
	context.order.append("script_ready")


func setup() -> void:
	was_setup = true
	var context = get_parent()
	if context != null:
		context.order.append("setup")


func setup_with_numbers(number_1:=1, number_2:=2, number_3:=3) -> void:
	setup_vars = [number_1, number_2, number_3]
	setup()
