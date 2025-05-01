# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Verifier
extends Node

signal started
signal completed
signal aborted

const START_DELAY := 0.4
@export var effect_layer: CanvasLayer
@export var pimnet: Pimnet
var _verifications_running: int = 0


func _enter_tree() -> void:
	assert(effect_layer != null)
	assert(pimnet != null)

	CSConnector.with(self).connect_setup(Game.AGENT_VERIFICATION, _register_verification)
	CSLocator.with(self).register(Game.SERVICE_VERIFIER, self)


func _register_verification(verification: Verification) -> void:
	verification.completed.connect(_on_verification_completed)

	_verifications_running += 1
	if _verifications_running == 1:
		verification.start_delay = START_DELAY
		started.emit()


func _on_verification_completed() -> void:
	assert(_verifications_running > 0)

	_verifications_running -= 1
	if _verifications_running == 0:
		completed.emit()


func abort() -> void:
	assert(_verifications_running >= 0)

	if _verifications_running > 0:
		_verifications_running = 0
		for child in get_children():
			child.queue_free()
		aborted.emit()


func is_running() -> bool:
	assert(_verifications_running >= 0)

	return _verifications_running > 0
