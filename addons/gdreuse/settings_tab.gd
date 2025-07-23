@tool
extends Control

const Constants := preload("constants.gd")
const Notice := preload("notice.gd")
@onready var add_notice_button: Button = %AddNoticeButton as Button
@onready var year_line_edit: LineEdit = %YearLineEdit as LineEdit
@onready var holder_line_edit: LineEdit = %HolderLineEdit as LineEdit
@onready var notices_list: ItemList = %NoticesList as ItemList
@onready var add_license_button: Button = %AddLicenseButton as Button
@onready var license_line_edit: LineEdit = %LicenseLineEdit as LineEdit
@onready var licenses_list: ItemList = %LicensesList as ItemList
@onready var license_buttons: HFlowContainer = %LicenseButtons as HFlowContainer


func _ready() -> void:
	%YearOptionButton.item_selected.connect(_on_year_item_selected)
	%YearOptionButton.item_selected.connect(_update_notice_addability.unbind(1))
	holder_line_edit.text_changed.connect(_update_notice_addability.unbind(1))
	year_line_edit.text_changed.connect(_update_notice_addability.unbind(1))
	license_line_edit.text_changed.connect(_update_license_addability.unbind(1))


func _on_year_item_selected(index: int) -> void:
	if index == Notice.CUSTOM_YEAR:
		year_line_edit.show()
	else:
		year_line_edit.hide()


func _update_notice_addability() -> void:
	var notice := make_notice_object()
	add_notice_button.disabled = not is_notice_addable(notice)


func _update_license_addability() -> void:
	add_license_button.disabled = not is_license_addable(license_line_edit.text)


func make_notice_object() -> Notice:
	var notice := Notice.new()
	notice.prefix_option = %PrefixOptionButton.selected
	notice.year_option = %YearOptionButton.selected
	if notice.year_option == Notice.CUSTOM_YEAR:
		notice.year_text = year_line_edit.text
	notice.holder_text = holder_line_edit.text
	return notice


func is_notice_addable(notice: Notice) -> bool:
	var notices_data = ProjectSettings.get_setting(Constants.NOTICES_SETTING, [])
	return notice.is_valid() and not notices_data.has(notice.get_data_string())


func is_license_addable(license_id: String) -> bool:
	var licenses_data = ProjectSettings.get_setting(Constants.LICENSE_IDS_SETTING, [])
	return not license_id.is_empty() and not licenses_data.has(license_id)


func get_license_button(license_id: String) -> Button:
	for button in license_buttons.get_children():
		if button.text == license_id:
			return button
	return null
