#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name FieldProcess
extends Process

var field: Field:
	get = _get_field


func _get_field() -> Field:
	if field == null:
		field = ContextUtils.get_parent_in_group(self, "fields")
		assert(field != null)
	return field
