## Ingredient as it sits on a shelf. Can be dragged onto an order. 
@tool
class_name IngredientUI extends Control

const UNUSABLE_COLOR = Color(0.558, 0.558, 0.558, 0.424)	## Color when unuseable.
const USABLE_COLOR = Color(1,1,1,1)							## Color when useable.

signal picked_up(ingredient)	## Emitted when the [IngredientUI] is picked up. 
signal released(ingredient)		## Emitted when the [IngredientUI] is released. 

@export var ingredientData : IngredientInventory :	## Data for this order. 
	get:
		return ingredientData
	set(newIngredient):
		ingredientData = newIngredient
		if ingredientData == null:
			clear_ingredient_data()
		else:
			install_ingredient_data(newIngredient)

@export var canUse : bool = false		## TRUE if you can use this ingredient. 


#region Onready Variables
@onready var ing_name: Label = $Shelf/IngName
@onready var ing_count: Label = $Shelf/IngCount
@onready var full_tex: TextureRect = $Shelf/FullTex
@onready var hazy_tex: TextureRect = $HazyTex
@onready var shelf = $Shelf
#endregion

var mouseHeld : bool = false			## Grab state of the mouse hold. 

## Installs an Ingredient into this node. 
func install_ingredient_data(newData : IngredientInventory) -> void:
	await ready
	if newData != ingredientData:
		ingredientData = newData
	ingredientData.connect("ingredient_updated", Callable(self, "_on_ingredient_updated"))
	ing_name.text = ingredientData.get_ingredient_name()
	ing_count.text = str(ingredientData.amountHeld) + " / " + str(Globals.MAX_INGREDIENTS)
	full_tex.texture = load(ingredientData.get_tex())
	hazy_tex.texture = load(ingredientData.get_tex())
	hazy_tex.global_position = full_tex.global_position
	hazy_tex.visible = false
	set_usability(canUse)

## Clears all ingredient data in an IngredientUI
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
		# Hover the hazy texture where the mouse is.
		hazy_tex.global_position = get_global_mouse_position()

## Update the Ingredient UI based on the ingredient data changed. 
func _on_ingredient_updated() -> void:
	# NOTE: only accounts for count change. 
	ing_count.text = str(ingredientData.amountHeld) + " / " + str(Globals.MAX_INGREDIENTS)
	
## Detect GUI input on the ingredient UI. 
func _on_full_tex_gui_input(event: InputEvent) -> void:
	if canUse == false:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			# Mouse just clicked.
			mouseHeld = true
			hazy_tex.visible = true
			emit_signal("picked_up", self)
		elif event.button_index == 1 and not event.is_pressed():
			# Mouse just released. 
			mouseHeld = false
			hazy_tex.visible = false
			hazy_tex.global_position = full_tex.global_position
			emit_signal("released", self)
