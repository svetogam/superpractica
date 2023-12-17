#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

extends Process

var order: Array = []
var parent: Node = null


func _init() -> void:
	order.append("setup")


func _enter_tree() -> void:
	parent = get_parent()
	order.append("setup_with_parent")


func _ready() -> void:
	order.append("running")
