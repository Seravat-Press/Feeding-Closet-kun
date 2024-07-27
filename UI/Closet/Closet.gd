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

@export_dir var closetAssetPath

@export var hungerStage : HUNGER_STAGES = HUNGER_STAGES.NONE 		## Current hunger stage.
@export var hungerTimerDuration = 30	## The time for each hunger stage
@export var storageNode : Storage		## The Storage node for feeding the closet
@export var feedCost : int				## How much CS required to sate the closet

const GOOD_H_TEX = preload("res://assets/hunger/good_hunger.png")
const SPENT_H_TEX = preload("res://assets/hunger/spent_hunger.png")

@onready var hunger_timer = $HungerTimer
@onready var closet_image = $VBoxContainer/ClosetImage
@onready var visual_hunger_timer = $VBoxContainer/VisualHungerTimer
@onready var hunger_1 = $VBoxContainer/HungerStates/Hunger1
@onready var hunger_2 = $VBoxContainer/HungerStates/Hunger2
@onready var hunger_3 = $VBoxContainer/HungerStates/Hunger3
@onready var feed_button = $VBoxContainer/ClosetImage/MarginContainer/btnFeed
@onready var feed_label = $VBoxContainer/ClosetImage/MarginContainer/feedLabel
@onready var closet_audio = $ClosetAudio


var closetFocused : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_closet()

func initialize_closet() -> void:
	hunger_timer.wait_time = hungerTimerDuration
	hunger_timer.one_shot = 0
	hunger_timer.autostart = 0
	hunger_1.texture = GOOD_H_TEX
	hunger_2.texture = GOOD_H_TEX
	hunger_3.texture = GOOD_H_TEX
	feed_button.disabled = true
	feed_label.text = "FEED [" + str(feedCost) + "]"
	
func _process(_delta) -> void: 
	if !hunger_timer.paused:
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
	hunger_lvl_changed()
	closet_audio.stream = CLOSET_AUDIO.pick_random()
	closet_audio.play()

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

func _on_shop_devoured():
	hunger_timer.paused = true

func _on_btn_feed_button_up():
	storageNode.sub_shadow(feedCost)
	# Reset hunger time
	hunger_timer.stop()
	hunger_timer.wait_time = hungerTimerDuration
	visual_hunger_timer.update_hunger_timer(hungerTimerDuration)
	closet_audio.stream = CLOSET_EAT
	closet_audio.play()
	hunger_timer.start()
	if storageNode.shadometer < feedCost:
		feed_button.disabled = true

func _on_storage_shadow_changed(_new_value):
	if storageNode.shadometer >= feedCost:
		feed_button.disabled = false

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
