class_name Runner extends Node

var targetIngredient : Ingredient
var gatherMin : int = 0
var gatherMax : int = 0

@onready var mission_timer = $MissionTimer
@onready var request_button_grid = $RequestButtonGrid

signal mission_complete(ingredient, quantity)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func randomize_quantity_retrieved() -> int:
	return randi_range(gatherMin, gatherMax)

func begin_resource_mission(requestedIngredient):
	targetIngredient = requestedIngredient
	gatherMin = requestedIngredient.gatherMin
	gatherMax = requestedIngredient.gatherMax
	
	for button in request_button_grid.get_children():
		if button.ingredient.Name != requestedIngredient.Name:
			button.visible = false
		else:
			button.disabled = true
	
	mission_timer.wait_time = requestedIngredient.sourceTime
	mission_timer.start()

func _on_mission_timer_timeout():
	for button in request_button_grid.get_children():
		button.visible = true
		button.disabled = false
	mission_complete.emit(targetIngredient, randomize_quantity_retrieved())

func _on_btn_request_death_petal_ingredient_clicked(ingredient):
	begin_resource_mission(ingredient)

func _on_btn_request_ectoplasm_ingredient_clicked(ingredient):
	begin_resource_mission(ingredient)

func _on_btn_request_fang_ingredient_clicked(ingredient):
	begin_resource_mission(ingredient)

func _on_btn_request_toxin_ingredient_clicked(ingredient):
	begin_resource_mission(ingredient)
