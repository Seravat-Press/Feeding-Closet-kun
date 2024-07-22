## This class manages the storage of the alchemist shop. Handles Ingredients and Coalesced Shadow.
## This serves UI. 
class_name Storage extends Node

@export var ingredientStorage : Array[Ingredient]	## Ingredients in Storage. 
@export var shadometer : int						## Money. 

func _ready():
	pass

## Adds Shadow to the Shadometer.
func add_shadow(newShadow : int):
	shadometer += newShadow
	update_shadow()

## Subtracts shadow from the Shadometer. Bounds at 0. 
func sub_shadow(lessShadow : int):
	shadometer -= lessShadow
	if shadometer < 0:
		shadometer = 0
	update_shadow()

## Emit a signal to UI nodes to update the shadometer. 
func update_shadow() -> void:
	## TODO emit signal for shadow update to UI
	pass
