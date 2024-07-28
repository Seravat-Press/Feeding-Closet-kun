## Holds all of the ingredientUIs
class_name Shelves extends MarginContainer

signal released_ingredient(ingredient)

@onready var ingredients = $Ingredients

var pickedUpIngredient : IngredientUI

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_signals_to_ingredients()

## Set up ingredient signals
func connect_signals_to_ingredients() -> void:
	for ingredient in ingredients.get_children():
		ingredient.connect("picked_up", Callable(self,"_on_ingredient_picked_up"))
		ingredient.connect("released", Callable(self,"_on_ingredient_released"))

## IngredientUI emits signal for "picked_up" and passes itself. 
func _on_ingredient_picked_up(upIngredient : IngredientUI) -> void:
	pickedUpIngredient = upIngredient

## IngredientUI emits signal for "released" and passes itself.
func _on_ingredient_released(downIngredient : IngredientUI) -> void:
	if downIngredient == pickedUpIngredient:
		emit_signal("released_ingredient", pickedUpIngredient.ingredientData)
		pickedUpIngredient = null

## Returns whether or not an item is picked up. 
func check_if_item_picked() -> bool:
	return true if (pickedUpIngredient != null) else false

func get_ingredient_nodes() -> Array[IngredientUI]:
	var ingredientNodes : Array[IngredientUI] = []
	for ing in ingredients.get_children():
		ingredientNodes.append(ing)
	return ingredientNodes
