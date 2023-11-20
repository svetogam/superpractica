##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name FieldMetanavigComponent
extends FieldInterfaceComponent


#Virtual
func build() -> MemState:
	assert(false)
	return null


#Virtual
func load_state(_state: MemState) -> void:
	assert(false)
