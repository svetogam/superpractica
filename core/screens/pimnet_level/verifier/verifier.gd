# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Verifier
extends Node

signal verifications_started
signal verifications_completed

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
		verifications_started.emit()


func _on_verification_completed() -> void:
	_verifications_running -= 1
	assert(_verifications_running >= 0)

	if not is_running():
		verifications_completed.emit()


func is_running() -> bool:
	return _verifications_running > 0
