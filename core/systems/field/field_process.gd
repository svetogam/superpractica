# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name FieldProcess
extends Process

var field: Field:
	get:
		if field == null:
			field = CSLocator.with(self).find(Game.SERVICE_FIELD)
			assert(field != null)
		return field
