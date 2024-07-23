class_name RequestIngredientButton extends Button

@export var ingredient : Ingredient

signal ingredient_clicked(ingredient)

func _on_button_up():
	print("Requesting ingredient: " + ingredient.Name)
	ingredient_clicked.emit(ingredient)
