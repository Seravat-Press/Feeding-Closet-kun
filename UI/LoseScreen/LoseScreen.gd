class_name LoseScreen extends Node

signal play_again

const PREV_SCORE = "[center]Too bad!\nCurrent High Score: \n%.2f[/center]"
const HR_STR = "%d hrs"
const MIN_STR = "%d min"
const SEC_STR = "%.2f sec"
@onready var hr_label: Label = $FullWindow/VBoxContainer/HBoxContainer/HrLabel
@onready var min_label: Label = $FullWindow/VBoxContainer/HBoxContainer/MinLabel
@onready var sec_label: Label = $FullWindow/VBoxContainer/HBoxContainer/SecLabel
@onready var hr_sep = $FullWindow/VBoxContainer/HBoxContainer/HrSep
@onready var min_sep = $FullWindow/VBoxContainer/HBoxContainer/MinSep

@onready var happy_list = $HappyContainer/ScrollContainer/HappyList
@onready var sad_list = $SadContainer/ScrollContainer/SadList

@onready var high_score_label = $HighScoreLabel
@onready var previous_score_label = $PreviousScoreLabel

@onready var full_window = $FullWindow
@onready var sad_container = $SadContainer
@onready var happy_container = $HappyContainer
@onready var lose_music = $LoseMusic

func _ready():
	for childNode in get_children():
		if !(childNode is AudioStreamPlayer):
			childNode.visible = false
	lose_music.play()
	
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
	
	check_high_score(sElapsed)
	fill_happy_container()
	fill_sad_container()
	full_window.visible = true
	sad_container.visible = true
	happy_container.visible = true

## Check the new score against the current high score. 
func check_high_score(newScore : float) -> void:
	if Globals.scoreManager.check_new_score(newScore):
		high_score_label.visible = true
		previous_score_label.visible = false
	else:
		high_score_label.visible = false
		previous_score_label.text = PREV_SCORE % Globals.scoreManager.currentHighScore
		previous_score_label.visible = true

## Fill all of the happy names!
func fill_happy_container() -> void:
	for happyPerson in Globals.scoreManager.happyPeople:
		var newLabel : Label = Label.new()
		newLabel.text = happyPerson
		happy_list.add_child(newLabel)

## Fill all of the sad names!
func fill_sad_container() -> void:
	for sadPerson in Globals.scoreManager.sadPeople:
		var newLabel : Label = Label.new()
		newLabel.text = sadPerson
		sad_list.add_child(newLabel)
	
func _on_play_again_button_pressed():
	emit_signal("play_again")


func _on_exit_button_pressed():
	get_tree().quit()
