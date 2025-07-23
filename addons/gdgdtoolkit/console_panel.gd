@tool
extends Control

@onready var lint_button: Button = %LintButton as Button
@onready var format_diff_button: Button = %FormatDiffButton as Button
@onready var complexity_button: Button = %ComplexityButton as Button
@onready var console: TextEdit = %Console as TextEdit
@onready var command: LineEdit = %Command as LineEdit
@onready var _normal_color := EditorInterface.get_editor_theme().get_color("font_color", "Editor")
@onready
var _success_color := EditorInterface.get_editor_theme().get_color("success_color", "Editor")
@onready var _error_color := EditorInterface.get_editor_theme().get_color("error_color", "Editor")


func _ready() -> void:
	# Set colors
	console.add_theme_color_override(
		"background_color", EditorInterface.get_editor_theme().get_color("dark_color_2", "Editor")
	)
	command.add_theme_color_override("font_uneditable_color", _normal_color)


func show_command_output(p_command: String, output: Array) -> void:
	command.text = p_command
	if not output.is_empty() and not output[0].is_empty():
		console.text = output[0].trim_suffix("\n")
	else:
		console.text = ""

	# Color text according to markers
	if command.text.contains("gdlint"):
		if console.text.contains("Failure:") or console.text.contains("Error:"):
			console.add_theme_color_override("font_readonly_color", _error_color)
		elif console.text.contains("Success:"):
			console.add_theme_color_override("font_readonly_color", _success_color)
		else:
			console.add_theme_color_override("font_readonly_color", _normal_color)
	else:
		console.add_theme_color_override("font_readonly_color", _normal_color)
