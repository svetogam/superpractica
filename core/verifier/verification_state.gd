##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name VerificationState
extends State

var verification: Process
var verifier: Node
var pack: Node
var screen_verifier: Node


func _on_setup() -> void:
	_setup_shortcuts()


func _setup_shortcuts() -> void:
	verification = _target
	assert(verification != null)
	verifier = verification.verifier
	assert(verifier != null)
	pack = verification.pack
	assert(pack != null)
	screen_verifier = verification.screen_verifier
	assert(screen_verifier != null)


func verify() -> void:
	verification.verify()


func reject() -> void:
	verification.reject()
