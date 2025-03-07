# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name VerificationState
extends State

var verification: Verification:
	get:
		assert(_target != null)
		return _target
var verifier: Verifier:
	get:
		assert(_target.verifier != null)
		return _target.verifier
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
		assert(_target.pimnet != null)
		return _target.pimnet


func verify() -> void:
	verification.verify()


func reject() -> void:
	verification.reject()
