# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control


func _ready() -> void:
	if OS.get_name() == "Web":
		%QuitButton.hide()

	# Present info
	%WebsiteLink.text = Game.WEBSITE_URL
	%WebsiteLink.uri = Game.WEBSITE_URL
	%SourceLink.text = Game.REPO_URL
	%SourceLink.uri = Game.REPO_URL
	var version_text: String
	if not YourBuil.has_data():
		version_text = Game.version_tag + "+"
		%BuildPanel.hide()
	else:
		if YourBuil.has_git_tag():
			version_text = YourBuil.git_tag
		else:
			version_text = Game.version_tag + "+" + str(YourBuil.git_commit_count)
		%CommitLabel.text = "[" + YourBuil.get_git_commit_hash(8) + "]"
		%DateLabel.text = YourBuil.get_date_string()
	%VersionText.text = version_text
	%TitleVersion.text = version_text + " Demo"
	%EngineLicense.text = Engine.get_license_text()

	$StateChart.set_expression_property("transition_duration", %TransitionCamera.duration)


func _connect_buttons() -> void:
	%TopicsButton.pressed.connect(_on_topics_button_pressed)
	%InfoButton.pressed.connect(_on_info_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)
	%InfoBackButton.pressed.connect(_on_info_back_button_pressed)
	%CreditsButton.pressed.connect(_on_credits_button_pressed)
	%LicensesButton.pressed.connect(_on_licenses_button_pressed)
	%CreditsBackButton.pressed.connect(_on_credits_back_button_pressed)
	%LicensesBackButton.pressed.connect(_on_licenses_back_button_pressed)
	%LicensesBackButton2.pressed.connect(_on_licenses_back_button_pressed)
	%GameLicenseButton.pressed.connect(_on_game_licenses_button_pressed)
	%EngineLicenseButton.pressed.connect(_on_engine_licenses_button_pressed)


func _disconnect_buttons() -> void:
	%TopicsButton.pressed.disconnect(_on_topics_button_pressed)
	%InfoButton.pressed.disconnect(_on_info_button_pressed)
	%QuitButton.pressed.disconnect(_on_quit_button_pressed)
	%InfoBackButton.pressed.disconnect(_on_info_back_button_pressed)
	%CreditsButton.pressed.disconnect(_on_credits_button_pressed)
	%LicensesButton.pressed.disconnect(_on_licenses_button_pressed)
	%CreditsBackButton.pressed.disconnect(_on_credits_back_button_pressed)
	%LicensesBackButton.pressed.disconnect(_on_licenses_back_button_pressed)
	%LicensesBackButton2.pressed.disconnect(_on_licenses_back_button_pressed)
	%GameLicenseButton.pressed.disconnect(_on_game_licenses_button_pressed)
	%EngineLicenseButton.pressed.disconnect(_on_engine_licenses_button_pressed)


func _on_camera_viewing_state_entered() -> void:
	_connect_buttons()


func _on_camera_viewing_state_exited() -> void:
	_disconnect_buttons()


func _on_page_child_state_exited() -> void:
	$StateChart.send_event("move_camera")


func _on_licenses_page_child_state_exited() -> void:
	$StateChart.send_event("move_camera")


func _on_topics_button_pressed() -> void:
	Game.request_enter_level_select.emit()


func _on_quit_button_pressed() -> void:
	Game.request_exit_game.emit()


func _on_info_button_pressed() -> void:
	$StateChart.send_event("view_info")
	%TransitionCamera.transition_to(%InfoCamera)


func _on_info_back_button_pressed() -> void:
	$StateChart.send_event("view_start")
	%TransitionCamera.transition_to(%StartCamera)


func _on_credits_button_pressed() -> void:
	$StateChart.send_event("view_credits")
	%TransitionCamera.transition_to(%CreditsCamera)


func _on_licenses_button_pressed() -> void:
	$StateChart.send_event("view_licenses")
	%TransitionCamera.transition_to(%GameLicensesCamera)


func _on_credits_back_button_pressed() -> void:
	$StateChart.send_event("view_info")
	%TransitionCamera.transition_to(%InfoCamera)


func _on_licenses_back_button_pressed() -> void:
	$StateChart.send_event("view_info")
	%TransitionCamera.transition_to(%InfoCamera)


func _on_game_licenses_button_pressed() -> void:
	$StateChart.send_event("view_game_licenses")
	%TransitionCamera.transition_to(%GameLicensesCamera)


func _on_engine_licenses_button_pressed() -> void:
	$StateChart.send_event("view_engine_licenses")
	%TransitionCamera.transition_to(%EngineLicensesCamera)
