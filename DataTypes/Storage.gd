## This class manages the storage of the alchemist shop. Handles Ingredients and Coalesced Shadow.
## This serves UI. 
class_name Storage extends Node

## Shadow lost on an order fail. 
const SHAD_LOST : int = 3

signal shadow_changed(new_value : int) 		## Amount of shadow has been changed.
signal shadow_val_added(val_added : int)	## Shadometer modified by this value. 

@export var shadometer : int = 0					## Money. 

var ingredientStorage : Array[IngredientUI]	## Ingredients in Storage. 

## Adds Shadow to the Shadometer.
func add_shadow(moreShadow : int):
	#printerr("\nAdding CS: " + str(moreShadow))
	shadometer += moreShadow
	emit_signal("shadow_val_added", moreShadow)
	#printerr("Total CS: " + str(shadometer))
	update_shadow()

## Subtracts shadow from the Shadometer. Bounds at 0. 
func sub_shadow(lessShadow : int):
	var newLess : int = lessShadow
	shadometer -= lessShadow
	#printerr("\nSubtracting CS: " + str(lessShadow))
	if shadometer < 0:
		newLess = abs(shadometer)
		shadometer = 0
	emit_signal("shadow_val_added", -1 * newLess)
	#printerr("Total CS: " + str(shadometer))
	update_shadow()

## Emit a signal to UI nodes to update the shadometer. 
func update_shadow() -> void:
	emit_signal("shadow_changed", shadometer)

## Updates the shadow amount
func set_new_shadow(newShadow : int) -> void:
	shadometer = newShadow
	update_shadow()

## Returns the current value of the shadometer.
func get_shadometer() -> int:
	return shadometer

## Received from OrderManager
func _on_add_shadow(addAmount : int, _orderNode : OrderUi) -> void:
	add_shadow(addAmount)

## Sets up all of the ingredients. 
func set_ingredients(allIngredients : Array[IngredientUI]):
	ingredientStorage = allIngredients

## Called when the runners finish their tasks. 
func _on_add_items(newItem : Ingredient, quantity : int) -> void:
	for ing in ingredientStorage:
		if ((newItem.ID == ing.ingredientData.ingredientData.ID) and
			(ing.canUse == true)):
			ing.ingredientData.add_amount(quantity)

## Zero out all ingredient quantities. 
func zero_out_ingredients() -> void:
	for ing in ingredientStorage:
		ing.ingredientData.update_amount(0)

## Decrease CS values whenever an order is failed. 
func _on_order_fail() -> void:
	sub_shadow(SHAD_LOST)
