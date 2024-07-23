## Ingredient as it sits on a shelf. Can be dragged onto an order. 
class_name IngredientUI extends Control

@export var ingredientData : Ingredient		## Data for this order. 

@onready var ing_name: Label = $Shelf/IngName
@onready var ing_count: Label = $Shelf/IngCount
@onready var full_tex: TextureRect = $Shelf/FullTex
@onready var hazy_tex: TextureRect = $HazyTex

var mouseHeld : bool = false	## Grab state of the mouse hold. 

func _ready(): 
	if ingredientData != null:
		# NOTE: Just a hack to get it to debug. 
		install_ingredient_data(ingredientData)

## Installs an Ingredient into this node. 
func install_ingredient_data(newData : Ingredient) -> void:
	ingredientData = newData
	ing_name.text = ingredientData.Name
	ing_count.text = str(ingredientData.Amount) + " / " + str(Globals.MAX_INGREDIENTS)
	full_tex.texture = load(ingredientData.imgRect)
	hazy_tex.texture = load(ingredientData.imgRect)
	hazy_tex.global_position = full_tex.global_position
	hazy_tex.visible = false


func _process( _delta : float ):
	if mouseHeld:
		# Hover the hazy texture where the mouse is
		hazy_tex.global_position = get_global_mouse_position()


## Detect GUI input on the ingredient UI. 
func _on_full_tex_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			mouseHeld = true
			hazy_tex.visible = true
		elif event.button_index == 1 and not event.is_pressed():
			mouseHeld = false
			hazy_tex.visible = false
			hazy_tex.global_position = full_tex.global_position
