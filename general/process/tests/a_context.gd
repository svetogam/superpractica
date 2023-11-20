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


func small_callback(number: int) -> void:
	order.append("small_callback: " + str(number))


func big_callback(number_1: int, number_2: int) -> void:
	order.append("big_callback: " + str(number_1) + ", " + str(number_2))
