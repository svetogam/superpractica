# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Verification
extends Node
## Base class for running verifications to complete a task in a Level.
##
## This class is like [Process], but for verifications.


signal completed
signal verified
signal rejected

var row_numbers: Array
var verifier: Verifier:
	get:
		if verifier == null:
			verifier = CSLocator.with(self).find(Game.SERVICE_VERIFIER)
			assert(verifier != null)
		return verifier
var pimnet: Pimnet:
	get:
		assert(verifier.pimnet != null)
		return verifier.pimnet
var verification_panel: PanelContainer:
	get:
		assert(pimnet.overlay != null)
		assert(pimnet.overlay.verification_panel != null)
		return pimnet.overlay.verification_panel


func _init() -> void:
	add_to_group("verifications")


func _enter_tree() -> void:
	for filled_number in verification_panel.filled_row_numbers:
		row_numbers.erase(filled_number)
	CSConnector.with(self).register(Game.AGENT_VERIFICATION)

	assert(row_numbers.size() > 0)


func run(target: Node, p_row_numbers: Array,
		verified_callback: Callable, rejected_callback := Callable()
) -> Verification:
	assert(not is_inside_tree())
	assert(p_row_numbers.size() > 0)

	row_numbers = p_row_numbers
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
