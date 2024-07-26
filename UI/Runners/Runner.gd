class_name Runner extends Control

signal mission_complete(ingredient, quantity)
signal runner_level_up

var targetIngredient : IngredientFetch
var gatherQuantity : int = 0

const RUNNER_AUDIO = [
	preload("res://audio/sfx/runner/runner_1.ogg"),
	preload("res://audio/sfx/runner/runner_2.ogg"),
	preload("res://audio/sfx/runner/runner_3.ogg"),
	preload("res://audio/sfx/runner/runner_4.ogg"),
	preload("res://audio/sfx/runner/runner_5.ogg"),
	preload("res://audio/sfx/runner/runner_6.ogg")
]

@export var BONUS_PER_LEVEL : int = 1
@export var COST_PER_LEVEL : int = 40
@export var BONUS_COST_PER_LEVEL : int = 10
@export var currentLevel : int = 0

@onready var mission_timer_progress_bar = $VBoxContainer/MissionTimerProgressBar

@onready var mission_timer = $MissionTimer
@onready var request_button_grid = $RequestButtonGrid
@onready var runner_audio = $RunnerAudio

@onready var level_label = $VBoxContainer/VBoxContainer/HBoxContainer/LevelLabel
@onready var yield_label = $VBoxContainer/VBoxContainer/HBoxContainer2/YieldLabel
@onready var level_cost = $VBoxContainer/VBoxContainer/HBoxContainer3/LevelCost

var costToLevel : int

# Called when the node enters the scene tree for the first time.
func _ready():
	mission_timer_progress_bar.visible = false
	costToLevel = COST_PER_LEVEL
	update_labels()

func update_labels() -> void:
	level_label.text = str(currentLevel)
	yield_label.text = str(currentLevel * BONUS_PER_LEVEL)
	level_cost.text = str(costToLevel)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	mission_timer_progress_bar.value = mission_timer.time_left / mission_timer.wait_time

func randomize_quantity_retrieved() -> int:
	return randi_range(targetIngredient.gatherMin, targetIngredient.gatherMax)

func begin_resource_mission(requestedIngredient : IngredientFetch):
	targetIngredient = requestedIngredient
	
	mission_timer_progress_bar.visible = true
	for button in request_button_grid.get_children():
		if button.ingredient.get_ingredient_id() != requestedIngredient.get_ingredient_id():
			button.visible = false
		else:
			button.disabled = true

	mission_timer_progress_bar.value = requestedIngredient.sourceTime
	mission_timer.wait_time = requestedIngredient.sourceTime
	mission_timer.start()

func _on_mission_timer_timeout():
	for button in request_button_grid.get_children():
		button.visible = true
		button.disabled = false
	mission_timer_progress_bar.visible = false
	gatherQuantity = randomize_quantity_retrieved() + (currentLevel * BONUS_PER_LEVEL)
	mission_complete.emit(targetIngredient.ingredientData, gatherQuantity)
	mission_timer.stop()
	print("Mission for " + targetIngredient.get_ingredient_name() + " successful. " + str(gatherQuantity) + " retrieved.")
	runner_audio.stream = RUNNER_AUDIO.pick_random()
	runner_audio.play()

func _on_btn_request_death_petal_ingredient_clicked(ingredient : IngredientFetch):
	begin_resource_mission(ingredient)

func _on_btn_request_ectoplasm_ingredient_clicked(ingredient : IngredientFetch):
	begin_resource_mission(ingredient)

func _on_btn_request_fang_ingredient_clicked(ingredient : IngredientFetch):
	begin_resource_mission(ingredient)

func _on_btn_request_toxin_ingredient_clicked(ingredient : IngredientFetch):
	begin_resource_mission(ingredient)


func _on_level_up_pressed():
	emit_signal("runner_level_up")

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
	
