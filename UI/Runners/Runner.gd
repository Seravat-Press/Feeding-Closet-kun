## A handy pal that retrieves ingredients for their alchemist boss!
class_name Runner extends Control

signal mission_complete(ingredient, quantity)	## Emit when a fetch mission completes. 
signal runner_level_up							## Emit when the level up button is pressed. 

const FETCH_NUMBER = preload("res://UI/FetchNumber/FetchNumber.tscn")

## Preloaded tracks for runner noises. 
const RUNNER_AUDIO = [
	preload("res://audio/sfx/runner/runner_1.ogg"),
	preload("res://audio/sfx/runner/runner_2.ogg"),
	preload("res://audio/sfx/runner/runner_3.ogg"),
	preload("res://audio/sfx/runner/runner_4.ogg"),
	preload("res://audio/sfx/runner/runner_5.ogg"),
	preload("res://audio/sfx/runner/runner_6.ogg")
]

@export var BONUS_PER_LEVEL : int = 1		## Bonus # ingredients gathered per level. 
@export var COST_PER_LEVEL : int = 40		## Cost to level up the runner initially. 
@export var BONUS_COST_PER_LEVEL : int = 10	## Incremental adder to level-up cost. 
@export var currentLevel : int = 0			## Current runner level. 

#region Onready Variables
@onready var mission_timer_progress_bar = $VBoxContainer/MissionTimerProgressBar
@onready var mission_timer = $MissionTimer
@onready var request_button_grid = $RequestButtonGrid
@onready var runner_audio = $RunnerAudio
@onready var level_label = $VBoxContainer/VBoxContainer/HBoxContainer/LevelLabel
@onready var yield_label = $VBoxContainer/VBoxContainer/HBoxContainer2/YieldLabel
@onready var level_cost = $VBoxContainer/VBoxContainer/HBoxContainer3/LevelCost
@onready var num_spawn_location: Marker2D = $NumSpawnLocation
#endregion

var targetIngredient : IngredientFetch
var gatherQuantity : int = 0
var timeCalculated : float = 0.0
var costToLevel : int	## Tracker for the current cost ot level up. 

# Called when the node enters the scene tree for the first time.
func _ready():
	mission_timer_progress_bar.visible = false
	costToLevel = COST_PER_LEVEL
	update_labels()

## Update all of the level-related labels. 
func update_labels() -> void:
	level_label.text = str(currentLevel)
	yield_label.text = str(currentLevel * BONUS_PER_LEVEL)
	level_cost.text = str(costToLevel)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	# Update the progress bar based on the retrieval duration. 
	mission_timer_progress_bar.value = mission_timer.time_left / timeCalculated

## Calculate a random quantity of ingredients to retrieve. 
func randomize_quantity_retrieved() -> int:
	return randi_range(targetIngredient.gatherMin, targetIngredient.gatherMax)

## Call to begin a resource-gathering mission. 
func begin_resource_mission(requestedIngredient : IngredientFetch):
	targetIngredient = requestedIngredient
	
	# Turn off any ingredient buttons that are inactive. 
	for button in request_button_grid.get_children():
		if button.ingredient.get_ingredient_id() != requestedIngredient.get_ingredient_id():
			button.visible = false
		else:
			button.disabled = true

	# Calculate random number, calculate wait time from that. NOTE keep currentLevel * bonus in the timeout.
	gatherQuantity = randomize_quantity_retrieved()
	timeCalculated = (gatherQuantity * targetIngredient.get_ingredient_fetch_mod()) + targetIngredient.timeMod
	
	# Update the mission timer based on the calculated duration. 
	mission_timer_progress_bar.value = timeCalculated
	mission_timer.wait_time = timeCalculated
	mission_timer_progress_bar.visible = true
	mission_timer.start()

## Called when the mission timer elapses.
func _on_mission_timer_timeout():
	# Turn back on all of the other ingredient buttons. 
	for button in request_button_grid.get_children():
		button.visible = true
		button.disabled = false
	
	# Turn off the progress bar. 
	mission_timer_progress_bar.visible = false
	
	# Add the level bonus to the gather quantity. 
	gatherQuantity += (currentLevel * BONUS_PER_LEVEL)
	mission_complete.emit(targetIngredient.ingredientData, gatherQuantity)
	mission_timer.stop()
	#print("Mission for " + targetIngredient.get_ingredient_name() + " successful. " + str(gatherQuantity) + " retrieved.")
	
	# Create a number that indicates the gathered quantity. 
	var numLabel : FetchNumber = FETCH_NUMBER.instantiate()
	add_child(numLabel)
	numLabel.launch_number(gatherQuantity, num_spawn_location.global_position)
	
	# Play Runner audio
	runner_audio.stream = RUNNER_AUDIO.pick_random()
	runner_audio.play()
	

#region Ingredient Button Handlers
func _on_btn_request_death_petal_ingredient_clicked(ingredient : IngredientFetch):
	begin_resource_mission(ingredient)

func _on_btn_request_ectoplasm_ingredient_clicked(ingredient : IngredientFetch):
	begin_resource_mission(ingredient)

func _on_btn_request_fang_ingredient_clicked(ingredient : IngredientFetch):
	begin_resource_mission(ingredient)

func _on_btn_request_toxin_ingredient_clicked(ingredient : IngredientFetch):
	begin_resource_mission(ingredient)
#endregion


## Handle leveling up the runner. 
## NOTE: Currently, the button is always enabled, but processing is blocked by
## amount of congealed shadow. In the future, the button could react to shadometer amount. 
func _on_level_up_pressed():
	emit_signal("runner_level_up")

## Process leveling up. 
func handle_level_up(currShad : int) -> int:
	var newShad = currShad
	if newShad < costToLevel:
		# Cannot Level Up
		return newShad
	
	# Can Level up!
	currentLevel += 1
	newShad = currShad - costToLevel
	costToLevel = (currentLevel * BONUS_COST_PER_LEVEL) + COST_PER_LEVEL
	update_labels()
	return newShad

## Called on game over. 
func _on_closet_shop_devoured():
	mission_timer.paused = true
