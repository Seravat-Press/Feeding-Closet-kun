## UI Line for each Ingredient in a recipe. Hidden when the ingredient is completed. 
class_name IngredientLine extends HBoxContainer

@onready var ing_tex: TextureRect = $IngTex
@onready var ing_name: Label = $IngName
@onready var ing_count: Label = $IngCount

## Set up the scene data with all of the ingredient data. 
func install_ingredient(ingredientData : Ingredient):
	ing_tex.texture = load(ingredientData.imgRect)
	ing_name.text = ingredientData.Name
	ing_count.text = str(ingredientData.Amount)

## When the ingredient completes, turn off this scene. 
func _on_ingredient_complete():
	self.visible = false
