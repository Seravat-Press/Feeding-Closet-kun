class_name LoseScreen extends MarginContainer

const HR_STR = "%d hrs"
const MIN_STR = "%d min"
const SEC_STR = "%f sec"
@onready var hr_label: Label = $VBoxContainer/HBoxContainer/HrLabel
@onready var min_label: Label = $VBoxContainer/HBoxContainer/MinLabel
@onready var sec_label: Label = $VBoxContainer/HBoxContainer/SecLabel

func _ready():
	self.visible = false
	
func _on_lose(sElapsed : float):
	var sec : float = (int(sElapsed) % 60)
	var min : int = int(floor(sElapsed / 60))
	var hr : int = int(floor(min / 60))
	hr_label.text = HR_STR % hr
	min_label.text = MIN_STR % min
	# TODO Timer shows milliseconds
	self.visible = true
