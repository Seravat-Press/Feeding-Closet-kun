class_name LoseScreen extends MarginContainer

signal play_again

const HR_STR = "%d hrs"
const MIN_STR = "%d min"
const SEC_STR = "%.2f sec"
@onready var hr_label: Label = $VBoxContainer/HBoxContainer/HrLabel
@onready var min_label: Label = $VBoxContainer/HBoxContainer/MinLabel
@onready var sec_label: Label = $VBoxContainer/HBoxContainer/SecLabel
@onready var hr_sep = $VBoxContainer/HBoxContainer/HrSep
@onready var min_sep = $VBoxContainer/HBoxContainer/MinSep

func _ready():
	self.visible = false
	
## Called when the game is lost. 
func _on_lose(sElapsed : float):
	var sec : float = (int(sElapsed) % 60) + (float(int(sElapsed * 100) % 100) / 100)
	var min : int = int(floor(sElapsed / 60))
	var hr : int = int(floor(min / 60))
	
	# Hide Hours if 0
	if hr == 0:
		hr_label.visible = false
		hr_sep.visible = false
	
	# Hide minutes if 0
	if min == 0:
		min_label.visible = false
		min_sep.visible = false

	# Update Labels
	hr_label.text = HR_STR % hr
	min_label.text = MIN_STR % min
	sec_label.text = SEC_STR % sec
	self.visible = true


func _on_play_again_button_pressed():
	emit_signal("play_again")
	queue_free()


func _on_exit_button_pressed():
	get_tree().quit()
