#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends GutHookScript


func run():
	Game.debug.set_on()
	Game.debug.enable_precise_input(true)
	Game.debug.set_time_scale(Game.debug.TimeScales.FASTEST)
	Game.debug.set_animation_speed(Game.debug.AnimationSpeeds.INSTANT)
	Game.debug.set_delay_speed(Game.debug.DelayTimes.SKIP)
	#Game.debug.disable_graphics(true)
