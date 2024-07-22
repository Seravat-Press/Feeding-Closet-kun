class_name DudeManager extends Node

## Currently loaded dude
var currentDude : Dude
var preloadedDude = preload("res://DataTypes/Dude/Dude.gd")

# data arrays
var namesArray : Array
var texturesArray : Array
var ordersArray : Array

# source for random generation
@export_dir var textureDirectory
@export_dir var orderDirectory
@export var namesFilePath : String

# Called when the node enters the scene tree for the first time.
func _ready():
	build_data_arrays()

func build_data_arrays():
	build_name_array()
	build_portrait_array()
	build_order_array()

func build_name_array():
	var list = FileAccess.open(namesFilePath, FileAccess.READ)
	while not list.eof_reached():
		namesArray.append(list.get_line())

func build_portrait_array():
	var textureFilesArray = Globals.list_files_in_directory(textureDirectory)
	for textureFile in textureFilesArray:
		var newTexture : Texture2D = ResourceLoader.load(textureFile)
		texturesArray.append(newTexture)
	
func build_order_array():
	var orderFilesArray = Globals.list_files_in_directory(orderDirectory)
	for orderFile in orderFilesArray:
		var newOrder : Order = ResourceLoader.load(orderFile)
		ordersArray.append(newOrder)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_dude():
	var dudeName = namesArray.pick_random()
	var dudeTexture = texturesArray.pick_random()
	var dudeOrder = ordersArray.pick_random()
	var dudeInstance = preloadedDude.instantiate(dudeName, dudeTexture, dudeOrder)
	add_child(dudeInstance)
	currentDude = dudeInstance
	# TODO connect signals for dude elements (spawn)

func despawn_current_dude():
	remove_child(currentDude)
	# TODO connect signal for dude despawned
