##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name CameraPanner
extends SubscreenObject


func _on_press(_point: Vector2) -> void:
	start_grab()
	stop_active_input()


func _on_drag(_point: Vector2, change: Vector2) -> void:
	var camera = _subscreen.get_camera()
	if camera != null:
		camera.move_by(-change)
	stop_active_input()
