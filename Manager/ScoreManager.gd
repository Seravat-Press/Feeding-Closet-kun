## Tracks and updates the high score. 
class_name ScoreManager extends Node

signal new_high_score(score)

var currentHighScore : float = 0.0

# TODO tie to end game screen

## Checks a new score against the current high score. 
func check_new_score(newScore : float):
	if newScore > currentHighScore:
		currentHighScore = newScore
		emit_signal("new_high_score", currentHighScore)
