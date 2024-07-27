## Number that pops up and disappears. 
class_name FetchNumber extends Control

## String constant for the number.
const NUM_STR : String = "+ %d"

@export_range(-20.0, 20.0, 1.0) var maxRange : float = 0.0	## Max range for position variation. 
@export_range(-20.0, 20.0, 1.0) var minRange : float = 0.0	## Min range for position variation. 

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var number_label: Label = $NumberLabel

var numberVal : int
var initialVect : Vector2
var adjustVect : Vector2

@export var animationVect : Vector2		## Variable modified by the animation player. 

## Send a number moving.
func launch_number(newVal : int, startVect : Vector2):
	set_process(false)
	numberVal = newVal
	adjustVect = Vector2(randf_range(minRange,maxRange),randf_range(minRange,maxRange))
	initialVect = startVect + adjustVect
	self.global_position = initialVect
	number_label.text = NUM_STR % numberVal
	animation_player.play("spawn")
	set_process(true)
	
func _process(_delta):
	self.global_position = initialVect + animationVect

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
