# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VerificationState
extends State

var verification: Verification:
	get:
		assert(_target != null)
		return _target
var verifier: LevelProgram:
	get:
		assert(_target.verifier != null)
		return _target.verifier
var pimnet: Pimnet:
	get:
		assert(_target.pimnet != null)
		return _target.pimnet
var verification_panel: PanelContainer:
	get:
		assert(pimnet.overlay != null)
		assert(pimnet.overlay.verification_panel != null)
		return pimnet.overlay.verification_panel


func verify() -> void:
	verification.verify()


func reject() -> void:
	verification.reject()
