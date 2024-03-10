#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends PopupPanel


func _ready() -> void:
	%VersionText.text = GameGlobals.RELEASE_TAG
	%SourceText.text = GameGlobals.SOURCE_URL


func _on_close_button_pressed() -> void:
	hide()
