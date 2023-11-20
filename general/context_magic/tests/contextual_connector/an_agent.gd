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

signal number_done(number)
signal string_done(string)

var was_setup := false


func do_number(number: int) -> void:
	number_done.emit(number)


func do_string(string: String) -> void:
	string_done.emit(string)
