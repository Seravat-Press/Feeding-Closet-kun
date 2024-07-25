## This class manages the storage of the alchemist shop. Handles Ingredients and Coalesced Shadow.
## This serves UI. 
class_name Storage extends Node

signal shadow_changed(new_value) ## Amount of shadow has been changed.

@export var shadometer : int = 0					## Money. 

var ingredientStorage : Array[IngredientUI]	## Ingredients in Storage. 

func _ready():
	print("Current Ingredient Storage: " + str(ingredientStorage))

## Adds Shadow to the Shadometer.
func add_shadow(moreShadow : int):
	shadometer += moreShadow
	update_shadow()

## Subtracts shadow from the Shadometer. Bounds at 0. 
func sub_shadow(lessShadow : int):
	shadometer -= lessShadow
	if shadometer < 0:
		shadometer = 0
	update_shadow()

## Emit a signal to UI nodes to update the shadometer. 
func update_shadow() -> void:
	emit_signal("shadow_changed", shadometer)

## Received from OrderManager
func _on_add_shadow(addAmount : int) -> void:
	add_shadow(addAmount)

func set_ingredients(allIngredients : Array[IngredientUI]):
	ingredientStorage = allIngredients
	
func add_ingredient():
	pass
	
func remove_ingredient():
	pass

## Called when the runners finish their tasks. 
func _on_add_items(newItem : Ingredient, quantity : int) -> void:
	for ing in ingredientStorage:
		if ((newItem.ID == ing.ingredientData.ingredientData.ID) and
			(ing.canUse == true)):
			ing.ingredientData.add_amount(quantity)
