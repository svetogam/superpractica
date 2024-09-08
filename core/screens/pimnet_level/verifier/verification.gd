#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name Verification
extends Node
## Base class for running verifications to complete a task in a Level.
##
## This class is like [Process], but for verifications.


signal completed
signal verified
signal rejected

var verifier: Verifier:
	get:
		if verifier == null:
			verifier = CSLocator.with(self).find(Game.SERVICE_VERIFIER)
			assert(verifier != null)
		return verifier
var goal_verifier: GoalVerifier:
	get:
		assert(verifier.goal_verifier != null)
		return verifier.goal_verifier
var verification_panel: PanelContainer:
	get:
		assert(goal_verifier.verification_panel != null)
		return goal_verifier.verification_panel
var pimnet: Pimnet:
	get:
		assert(verifier.pimnet != null)
		return verifier.pimnet


func _init() -> void:
	add_to_group("verifications")


func _enter_tree() -> void:
	ContextualConnector.register(self)


func run(target: Node, verified_callback: Callable, rejected_callback := Callable()
) -> Verification:
	assert(not is_inside_tree())

	verified.connect(verified_callback)
	if not rejected_callback.is_null():
		rejected.connect(rejected_callback)
	target.add_child(self)
	return self


func verify() -> void:
	assert(is_inside_tree())

	verified.emit()
	_complete()


func reject() -> void:
	assert(is_inside_tree())

	rejected.emit()
	_complete()


func _complete() -> void:
	completed.emit()
	queue_free()
