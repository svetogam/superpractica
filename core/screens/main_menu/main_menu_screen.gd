# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Control


func _ready() -> void:
	if OS.get_name() == "Web":
		%QuitButton.hide()

	# Present Data
	%WebsiteLink.text = Game.WEBSITE_URL
	%WebsiteLink.uri = Game.WEBSITE_URL
	%SourceLink.text = Game.REPO_URL
	%SourceLink.uri = Game.REPO_URL
	var version_text: String
	if YourBuil.has_git_tag():
		version_text = YourBuil.git_tag
		%SourceCommitLink.text = ("This Build: " + YourBuil.git_tag
				+ " [" + YourBuil.get_git_commit_hash(8) + "]")
		%SourceCommitLink.uri = Game.REPO_URL + "/src/tag/" + YourBuil.git_tag
	elif YourBuil.has_data():
		version_text = Game.version_tag + "+" + str(YourBuil.git_commit_count)
		%SourceCommitLink.text = "This Build: [" + YourBuil.get_git_commit_hash(8) + "]"
		%SourceCommitLink.uri = Game.REPO_URL + "/src/commit/" + YourBuil.git_commit_hash
	else:
		version_text = Game.version_tag + "+"
		%SourceCommitLink.text = "Local Build"
	%VersionText.text = version_text
	%TitleVersion.text = version_text + " Demo"
	%EngineLicense.text = Engine.get_license_text()

	$StateMachine.activate()
