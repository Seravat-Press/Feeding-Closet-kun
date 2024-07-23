class_name DudeManager extends Node

## Currently loaded dude
var currentDude : Dude
var preloadedDudeScene = preload("res://DataTypes/Dude/Dude.tscn")

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
		var name = list.get_line()
		if name != "":
			namesArray.append(name)

func build_portrait_array():
	var textureFilesArray = Globals.list_files_in_directory(textureDirectory)
	for textureFile in textureFilesArray:
		if not textureFile.get_extension() == "import":
			var newTexture = Globals.import_image(textureFile)
			texturesArray.append(newTexture)
	
func build_order_array():
	var orderFilesArray = Globals.list_files_in_directory(orderDirectory)
	for orderFile in orderFilesArray:
		var newOrder : Order = ResourceLoader.load(orderFile)
		ordersArray.append(newOrder)

func spawn_dude():
	var dudeName = namesArray.pick_random()
	var dudeTexture = texturesArray.pick_random()
	var dudeOrder = ordersArray.pick_random()
	var dudeSceneInstance = preloadedDudeScene.instantiate()
	dudeSceneInstance.setup(dudeName, dudeTexture, dudeOrder)
	add_child(dudeSceneInstance)
	currentDude = dudeSceneInstance
	# TODO connect signals for dude elements (spawn)

func despawn_current_dude():
	remove_child(currentDude)
	# TODO connect signal for dude despawned
