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

var verifier: Node:
	get = _get_verifier
var screen_verifier: ScreenVerifier:
	set = _do_not_set,
	get = _get_screen_verifier


func _init() -> void:
	add_to_group("verifications")


func _enter_tree() -> void:
	ContextualConnector.register(self)


func run(target: Node, verified_callback: Callable, rejected_callback: Callable
) -> Verification:
	assert(not is_inside_tree())

	verified.connect(verified_callback)
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


func _get_verifier() -> Node:
	if verifier == null:
		verifier = CSLocator.with(self).find(GameGlobals.SERVICE_VERIFIER)
		assert(verifier != null)
	return verifier


func _get_screen_verifier() -> ScreenVerifier:
	assert(verifier.screen_verifier != null)
	return verifier.screen_verifier


static func _do_not_set(_value: Variant) -> void:
	assert(false)
