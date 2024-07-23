## Ingredient as it sits on a shelf. Can be dragged onto an order. 
@tool
class_name IngredientUI extends Control

const UNUSABLE_COLOR = Color(0.558, 0.558, 0.558, 0.424)
const USABLE_COLOR = Color(1,1,1,1)

signal picked_up(ingredient)
signal released(ingredient)

@export var ingredientData : Ingredient :	## Data for this order. 
	get:
		return ingredientData
	set(newIngredient):
		ingredientData = newIngredient
		if ingredientData == null:
			clear_ingredient_data()
		else:
			install_ingredient_data(newIngredient)

@onready var ing_name: Label = $Shelf/IngName
@onready var ing_count: Label = $Shelf/IngCount
@onready var full_tex: TextureRect = $Shelf/FullTex
@onready var hazy_tex: TextureRect = $HazyTex
@onready var shelf = $Shelf

var mouseHeld : bool = false	## Grab state of the mouse hold. 
var canUse : bool = false		## TRUE if you can use this ingredient. 

func _ready(): 
	set_usability(true)

## Installs an Ingredient into this node. 
func install_ingredient_data(newData : Ingredient) -> void:
	await ready
	if newData != ingredientData:
		ingredientData = newData
	ing_name.text = ingredientData.Name
	ing_count.text = str(ingredientData.Amount) + " / " + str(Globals.MAX_INGREDIENTS)
	full_tex.texture = load(ingredientData.imgRect)
	hazy_tex.texture = load(ingredientData.imgRect)
	hazy_tex.global_position = full_tex.global_position
	hazy_tex.visible = false

func clear_ingredient_data() -> void: 
	ing_name.text = ""
	ing_count.text = ""
	full_tex.texture = null
	
## Use to set the useability of an ingredient. 
func set_usability(useable : bool) -> void: 
	canUse = useable
	if canUse:
		shelf.modulate = USABLE_COLOR
	else:
		shelf.modulate = UNUSABLE_COLOR

func _process( _delta : float ):
	if Engine.is_editor_hint():
		return
		
	if mouseHeld:
		# Hover the hazy texture where the mouse is
		hazy_tex.global_position = get_global_mouse_position()


## Detect GUI input on the ingredient UI. 
func _on_full_tex_gui_input(event: InputEvent) -> void:
	if canUse == false:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			mouseHeld = true
			hazy_tex.visible = true
			emit_signal("picked_up", self)
		elif event.button_index == 1 and not event.is_pressed():
			mouseHeld = false
			hazy_tex.visible = false
			hazy_tex.global_position = full_tex.global_position
			emit_signal("released", self)
