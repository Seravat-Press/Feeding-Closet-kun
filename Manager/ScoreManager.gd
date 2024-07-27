## Tracks and updates the high score. 
class_name ScoreManager extends Node

var currentHighScore : float = 0.0

var happyPeople : Array[String]
var sadPeople : Array[String]

## Checks a new score against the current high score. 
func check_new_score(newScore : float) -> bool:
	if newScore > currentHighScore:
		currentHighScore = newScore
		return true
	return false

## Add a happy person to the list.
func add_happy_person(newName : String) -> void:
	happyPeople.append(newName)

## Add a sad person to the list. 
func add_sad_person(newName : String) -> void:
	sadPeople.append(newName)
