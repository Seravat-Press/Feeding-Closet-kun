class_name Runner extends Control

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

@onready var mission_timer_progress_bar = $VBoxContainer/MissionTimerProgressBar

@onready var mission_timer = $MissionTimer
@onready var request_button_grid = $RequestButtonGrid
@onready var runner_audio = $RunnerAudio

signal mission_complete(ingredient, quantity)

# Called when the node enters the scene tree for the first time.
func _ready():
	mission_timer_progress_bar.visible = false

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
	gatherQuantity = randomize_quantity_retrieved()
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
