## This class manages the storage of the alchemist shop. Handles Ingredients and Coalesced Shadow.
## This serves UI. 
class_name Storage extends Node

@export var ingredientStorage : Array[Ingredient]	## Ingredients in Storage. 
@export var shadometer : int						## Money. 

signal shadow_changed(new_value)

func _ready():
	pass

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
	shadow_changed.emit(shadometer)
