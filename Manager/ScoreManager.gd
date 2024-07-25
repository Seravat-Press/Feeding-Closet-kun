## Tracks and updates the high score. 
class_name ScoreManager extends Node

signal new_high_score(score)

var currentHighScore : float = 0.0

var happyPeople : Array[String]
var sadPeople : Array[String]

# TODO tie to end game screen

## Checks a new score against the current high score. 
func check_new_score(newScore : float) -> bool:
	if newScore > currentHighScore:
		currentHighScore = newScore
		return true
	return false

func add_happy_person(newName : String) -> void:
	happyPeople.append(newName)

func add_sad_person(newName : String) -> void:
	sadPeople.append(newName)
