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

const INITIAL_PROPERTY_1 := -1
const INITIAL_PROPERTY_2 := "initial_property_2"
var property_1 := INITIAL_PROPERTY_1
var property_2 := INITIAL_PROPERTY_2


func property_1_getter() -> int:
	return property_1


func property_2_getter() -> String:
	return property_2
