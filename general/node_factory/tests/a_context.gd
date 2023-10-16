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

var order := []


func a_function(_a=null, _b=null, _c=null) -> void:
	order.append("function_called")


func another_function(_a=null, _b=null, _c=null) -> void:
	order.append("another_function_called")
