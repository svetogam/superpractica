##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

extends Process

var was_setup := false


func setup() -> void:
	var context = get_parent()
	was_setup = true
	if context != null:
		context.order.append("process_setup")


func _enter_tree():
	var context = get_parent()
	context.order.append("process_entered")


func _ready():
	var context = get_parent()
	context.order.append("process_ready")


func _exit_tree():
	var context = get_parent()
	context.order.append("process_exited")
