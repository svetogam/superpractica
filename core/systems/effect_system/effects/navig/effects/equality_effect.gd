# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends ScreenEffect

@onready var _equality_sprite := %EqualitySprite as Sprite2D
@onready var _inequality_sprite := %InequalitySprite as Sprite2D


func set_type(type: String) -> void:
	if type == "equality":
		_equality_sprite.show()
		_inequality_sprite.hide()
	elif type == "inequality":
		_equality_sprite.hide()
		_inequality_sprite.show()
	else:
		assert(false)
