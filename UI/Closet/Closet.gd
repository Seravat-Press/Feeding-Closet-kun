## UI Element to handle the Closet hunger + textures. 
class_name Closet extends MarginContainer

enum HUNGER_STAGES {
	NONE,
	FIRST,
	SECOND,
	THIRD
}

signal hunger_changed(new_value)	## Emitted when the hunger value has changed. 
signal shop_devoured				## Emitted when all hunger levels are filled. 

const CLOSET_AUDIO = [
	preload("res://audio/sfx/closet-kun/closet_1.ogg"),
	preload("res://audio/sfx/closet-kun/closet_2.ogg"),
	preload("res://audio/sfx/closet-kun/closet_3.ogg")
]

const CLOSET_EAT = preload("res://audio/sfx/closet-kun/closet_eat.ogg")
const CLOSET_YUM = preload("res://audio/sfx/closet-kun/closet_yum.ogg")

const CS_10 : int = 10
const AMT_TIMER_PER_10_CS : float = 0.1

@export_dir var closetAssetPath

@export var hungerStage : HUNGER_STAGES = HUNGER_STAGES.NONE 		## Current hunger stage.
@export var storageNode : Storage		## The Storage node for feeding closet-kun
@export var minimumFeedCost : int = 10	## Minimum CS required to sate closet-kun

@export_group("Timer Values")
@export_range(1.0, 60.0, 0.5) var hungerTimerDuration : float = 30.0	## The time for each hunger stage

const GOOD_H_TEX = preload("res://assets/hunger/good_hunger.png")
const SPENT_H_TEX = preload("res://assets/hunger/spent_hunger.png")

@onready var closet_image = $VBoxContainer/ClosetImage
@onready var visual_hunger_timer = $VBoxContainer/VisualHungerTimer
@onready var hunger_1 = $VBoxContainer/HungerStates/Hunger1
@onready var hunger_2 = $VBoxContainer/HungerStates/Hunger2
@onready var hunger_3 = $VBoxContainer/HungerStates/Hunger3
@onready var feed_button = $VBoxContainer/ClosetImage/MarginContainer/btnFeed
@onready var feed_label = $VBoxContainer/ClosetImage/MarginContainer/feedLabel
@onready var closet_audio = $ClosetAudio


var closetFocused : bool = false

var activeTimer : Timer		## Currently Active Timer
var timerValue : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	# Install arbitrary value.
	visual_hunger_timer.install_hunger_values(10)

func initialize_closet() -> void:
	visual_hunger_timer.install_hunger_values(hungerTimerDuration)
	set_up_new_timer(hungerTimerDuration)
	hunger_1.texture = GOOD_H_TEX
	hunger_2.texture = GOOD_H_TEX
	hunger_3.texture = GOOD_H_TEX
	feed_label.text = "FEED [" + str(minimumFeedCost) + "]"
	set_process(true)
	
func _process(_delta) -> void: 
	if !activeTimer.paused:
		update_visual_hunger_timer()
		update_feed_button()
		
## Converts the active timer's time_left and displays it on the hunger timer. 
func update_visual_hunger_timer() -> void:
	var timeLeft = hungerTimerDuration * (activeTimer.time_left / hungerTimerDuration)
	visual_hunger_timer.update_hunger_timer(timeLeft)
	
## Call to set up a new timer and make that timer active. 
func set_up_new_timer(newDuration : float) -> void:
	if activeTimer != null:
		remove_child(activeTimer)
		activeTimer.queue_free()
		activeTimer = null
	
	var newTimer : Timer = Timer.new()
	newTimer.wait_time = newDuration
	newTimer.one_shot = true
	newTimer.autostart = 0
	newTimer.connect("timeout", Callable(self, "_on_hunger_timer_timeout"))
	activeTimer = newTimer
	add_child(activeTimer)
	update_visual_hunger_timer()
	activeTimer.start()
	
## Called when the hunger timer runs out. 
func _on_hunger_timer_timeout():
	if (hungerStage < 3):
		increase_hunger_stage()

## Call to increase the hunger stage and update the closet image. 
func increase_hunger_stage():
	hungerStage += 1
	closet_audio.stream = CLOSET_AUDIO.pick_random()
	closet_audio.play()
	update_closet_image()
	hunger_lvl_changed()
	if (hungerStage != HUNGER_STAGES.THIRD):
		set_up_new_timer(hungerTimerDuration)

## Call to decrease the hunger stage and update the closet image. 
func decrease_hunger_stage():
	if hungerStage > 0:
		hungerStage -= 1
		update_closet_image()
		hunger_lvl_changed()
		closet_audio.stream = CLOSET_YUM
		closet_audio.play()

## Update the closet texture based on the given hunger stage. 
func update_closet_image():
	closet_image.texture = load(closetAssetPath.path_join("ClosetStage" + str(hungerStage) + ".png"))

## Called when the hunger state is changed. 
func hunger_lvl_changed():
	hunger_changed.emit(hungerStage)
	match (hungerStage):
		HUNGER_STAGES.NONE:
			hunger_1.texture = GOOD_H_TEX
			hunger_2.texture = GOOD_H_TEX
			hunger_3.texture = GOOD_H_TEX
		HUNGER_STAGES.FIRST:
			hunger_1.texture = SPENT_H_TEX
			hunger_2.texture = GOOD_H_TEX
			hunger_3.texture = GOOD_H_TEX
		HUNGER_STAGES.SECOND:
			hunger_1.texture = SPENT_H_TEX
			hunger_2.texture = SPENT_H_TEX
			hunger_3.texture = GOOD_H_TEX
		HUNGER_STAGES.THIRD:
			hunger_1.texture = SPENT_H_TEX
			hunger_2.texture = SPENT_H_TEX
			hunger_3.texture = SPENT_H_TEX
			emit_signal("shop_devoured")

## Game's over; pause the timer. 
func _on_shop_devoured():
	activeTimer.paused = true

## Handle feeding Closet-kun dynamically based on shadometer value. 
func _on_btn_feed_button_pressed():
	# Check how much of the meter remains.
	var remainPercent : float = activeTimer.time_left / hungerTimerDuration
	var currShadometerVal : int = storageNode.get_shadometer()
	
	# Check if we can even spend shadometer. 
	if currShadometerVal < minimumFeedCost or (remainPercent > 0.9): 
		# We DO NOT have enough CS to feed.
		# OR
		# Less than 10% lost. 
		return

	# Stop the current timer to remain accurate. 
	activeTimer.paused = true
	
	# NOTE: Every 10cs is 10% of timer refilled
	
	# Grab the current time left. 
	var currWaitRemaining : float = activeTimer.time_left
	# Get multiplication factor for 10CS
	var gapPercent : float = (1.0 - remainPercent) / AMT_TIMER_PER_10_CS
	# Maximum Shadow to be spent to fill the timer all the way to max. 
	var maxShadSpend : int = floor(gapPercent * CS_10)
	
	var csSpendValue : int	# Amount of CS to spend. 
	
	# Check shadometer
	if maxShadSpend <= currShadometerVal:
		# We have enough CS to fill all the way. 
		csSpendValue = maxShadSpend
	else: 
		# We don't have enough CS to fill all the way, but we have minimum. 
		csSpendValue = currShadometerVal
		
	# Subtract the congealed shadow.
	storageNode.sub_shadow(csSpendValue) 
	
	# Convert CS Spent to additional wait time
	var addlWait = ((csSpendValue * AMT_TIMER_PER_10_CS) / CS_10) * hungerTimerDuration
	
	# Add the wait to the current wait and create a new timer. 
	var newWait = currWaitRemaining + addlWait
	set_up_new_timer(newWait)
	play_feed_audio()
	
## Play the feed audio on new CS. 
func play_feed_audio() -> void:
	closet_audio.stream = CLOSET_EAT
	closet_audio.play()
	
## If we don't have minimum CS to feed, turn off the feed button
func update_feed_button() -> void:
	if storageNode.get_shadometer() < minimumFeedCost:
		feed_button.disabled = true
	else:
		feed_button.disabled = false
		
## When the shadometer value is changed, check if it's above the threshold. 
func _on_storage_shadow_changed(_new_value):
	update_feed_button()

## Called when the mouse enters the closet image. 
func _on_closet_mouse_entered():
	closetFocused = true

## Called when the mouse enters the closet image. 
func _on_closet_mouse_exited():
	closetFocused = false

## Returns TRUE if the closet is being hovered by the mouse. 
func get_hovered() -> bool:
	return closetFocused

## Call to feed ingredients to Closet-kun.
func feed_ingredients(newIngredient : IngredientInventory) -> void:
	if (newIngredient.amountHeld >= Globals.CLOSET_STAGE_COST) and (hungerStage > 0):
		newIngredient.subtract_amount(Globals.CLOSET_STAGE_COST)
		decrease_hunger_stage()
