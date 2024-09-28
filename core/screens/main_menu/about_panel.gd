#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends PopupPanel


func _ready() -> void:
	%VersionText.text = Game.version_tag
	%WebsiteLink.text = Game.WEBSITE_URL
	%WebsiteLink.uri = Game.WEBSITE_URL
	%SourceLink.text = Game.REPO_URL
	%SourceLink.uri = Game.REPO_URL
	%SourceCommitLink.text = ("This Build: [" + YourBuild.get_git_commit_hash(8) + "]")
	%SourceCommitLink.uri = Game.REPO_URL + "/src/commit/" + YourBuild.git_commit_hash


func _on_close_button_pressed() -> void:
	hide()
