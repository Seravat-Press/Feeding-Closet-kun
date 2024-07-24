## Holds all of the ingredientUIs
class_name Shelves extends MarginContainer

signal released_ingredient(ingredient)

@onready var ingredients = $Ingredients

var pickedUpIngredient : IngredientUI

var ingredientNodes : IngredientUI

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_signals_to_ingredients()
	for ing in ingredients.get_children():
		ingredientNodes.append(ing)

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

func _on_add_items(newItem : Ingredient, quantity : int) -> void:
	for ing in ingredientNodes:
		if newItem.ID == ing.ingredientNode.ID:
			pass ## TODO fix this
