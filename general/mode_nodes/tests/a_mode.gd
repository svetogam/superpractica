##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

extends Mode

var pre_started := 0
var started := 0
var ended := 0


#Virtual
func _pre_start() -> void:
	pre_started = _target.pre_started_value
	ended = 0


#Virtual
func _start() -> void:
	started = _target.started_value


#Virtual
func _end() -> void:
	ended = _target.ended_value
