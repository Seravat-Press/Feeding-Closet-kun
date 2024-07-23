## UI Element to handle the Closet hunger + textures. 
class_name Closet extends Node

@export var hungerStage : int = 0		## Current hunger stage. NOTE may become an enum? 
@export var hungerTimerDuration = 30	## The time for each hunger stage

@onready var hunger_timer = $HungerTimer
@onready var closet_image = $ClosetImage
@onready var hunger_state_label = $HungerStateLabel
@onready var visual_hunger_timer = $VisualHungerTimer

signal hunger_changed(new_value)	## Emitted when the hunger value has changed. 

# Called when the node enters the scene tree for the first time.
func _ready():
	hunger_timer.wait_time = hungerTimerDuration
	hunger_timer.one_shot = 0
	hunger_timer.autostart = 0

func _process(_delta) -> void: 
	visual_hunger_timer.update_hunger_timer(hunger_timer.time_left / hunger_timer.wait_time)

## Called when the hunger timer runs out. 
func _on_hunger_timer_timeout():
	if (hungerStage < 3):
		increase_hunger_stage()

## Resets the hunger timer. 
func reset_hunger_timer():
	hunger_timer.stop()
	hunger_timer.start(hungerTimerDuration)

## Call to increase the hunger stage and update the closet image. 
func increase_hunger_stage():
	hungerStage += 1
	update_closet_image()
	hunger_changed.emit(hungerStage)

## Call to decrease the hunger stage and update the closet image. 
func decrease_hunger_stage():
	if hungerStage > 0:
		hungerStage -= 1
		update_closet_image()
		hunger_changed.emit(hungerStage)

## Update the closet texture based on the given hunger stage. 
func update_closet_image():
	closet_image.texture = load("" + "Stage" + str(hungerStage))

## Called when the hunger state is changed. 
func _on_hunger_changed():
	hunger_state_label.text = str(hungerStage)
