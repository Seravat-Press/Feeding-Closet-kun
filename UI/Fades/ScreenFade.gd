## Handle screen fading between scenes. 
class_name ScreenFade extends MarginContainer

signal faded_out
signal faded_in

@onready var color_rect = $ColorRect

## Call to begin fading out the scene. 
func fade_out() -> void:
	$AnimationPlayer.play("fade_out")

## Called at the end of the fade_out animation. 
func fade_out_complete() -> void:
	emit_signal("faded_out")

## Call to begin fading in the scene. 
func fade_in() -> void:
	$AnimationPlayer.play("fade_in")

## Called at the end of the fade_in animation. 
func fade_in_complete() -> void:
	emit_signal("faded_in")
