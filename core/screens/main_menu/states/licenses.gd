# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	_connect_buttons()


func _on_licenses_back_button_pressed() -> void:
	_change_state("FromLicensesToAbout")


func _to_game_license_frame() -> void:
	_disconnect_buttons()
	%TransitionCamera.transition_to(%LicensesCamera, _connect_buttons)


func _to_engine_license_frame() -> void:
	_disconnect_buttons()
	%TransitionCamera.transition_to(%LicensesCamera2, _connect_buttons)


func _connect_buttons() -> void:
	%LicensesBackButton.pressed.connect(_on_licenses_back_button_pressed)
	%LicensesBackButton2.pressed.connect(_on_licenses_back_button_pressed)
	%GameLicenseButton.pressed.connect(_to_game_license_frame)
	%EngineLicenseButton.pressed.connect(_to_engine_license_frame)


func _disconnect_buttons() -> void:
	%LicensesBackButton.pressed.disconnect(_on_licenses_back_button_pressed)
	%LicensesBackButton2.pressed.disconnect(_on_licenses_back_button_pressed)
	%GameLicenseButton.pressed.disconnect(_to_game_license_frame)
	%EngineLicenseButton.pressed.disconnect(_to_engine_license_frame)


func _exit(_next_state: String) -> void:
	_disconnect_buttons()
