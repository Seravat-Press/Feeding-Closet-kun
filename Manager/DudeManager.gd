## Manager for Dude-related functionality. 
## TODO could be a Node w/ dudes being added to UI nodes. 
class_name DudeManager extends Control

## Currently loaded dude
var currentDude : Dude
const preloadedDudeScene = preload("res://DataTypes/Dude/Dude.tscn")

# data arrays
var namesArray : Array
var texturesArray : Array
var ordersArray : Array[OrderFull]

# source for random generation
@export_dir var textureDirectory
@export_dir var orderDirectory
@export_file var namesFilePath

@export_range(0.1, 30.0, 0.1) var dudeSpawnCooldownMin : float = 5.0	## Minimum Time to spawn a dude
@export_range(0.1, 30.0, 0.1) var dudeSpawnCooldownMax : float = 10.0	## Maximum Time to spawn a dude
@export_range(0.1, 30.0, 0.1) var dudeStandTime : float = 5.0			## Amount of Time a dude hangs around
@export var introductionPoint : Node2D
@export var spawnPoint : Node2D

signal dude_spawned(dude)
signal dude_despawned(dude)

@onready var dude_spawn_cooldown = $DudeSpawnCooldown
@onready var dude_stand_timer = $DudeStandTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	build_data_arrays()
	dude_stand_timer.wait_time = dudeStandTime

func build_data_arrays():
	build_name_array()
	build_portrait_array()
	build_order_array()

func build_name_array():
	var list = FileAccess.open(namesFilePath, FileAccess.READ)
	while not list.eof_reached():
		var newName = list.get_line()
		if newName != "":
			namesArray.append(newName)

func build_portrait_array():
	var textureFilesArray = Globals.list_files_in_directory(textureDirectory)
	for textureFile in textureFilesArray:
		if not textureFile.get_extension() == "import":
			var newTexture = Globals.import_image(textureFile)
			texturesArray.append(newTexture)
	
func build_order_array():
	var orderFilesArray = Globals.list_files_in_directory(orderDirectory)
	for orderFile in orderFilesArray:
		var newOrder : OrderFull = ResourceLoader.load(orderFile)
		ordersArray.append(newOrder)

func spawn_dude():
	var dudeName = namesArray.pick_random()
	var dudeTexture = texturesArray.pick_random()
	var dudeOrder : OrderFull = ordersArray.pick_random().new_instance()
	var dudeSceneInstance = preloadedDudeScene.instantiate()
	## Connect Order Signals for Dude
	dudeOrder.connect("order_failed", Callable(dudeSceneInstance, "_on_dudes_order_failed"))
	dudeOrder.connect("order_completed", Callable(dudeSceneInstance, "_on_dudes_order_success"))
	
	## Set up the Dude
	dudeSceneInstance.setup(dudeName, dudeTexture, dudeOrder)
	add_child(dudeSceneInstance)
	currentDude = dudeSceneInstance

func despawn_current_dude():
	remove_child(currentDude)
	dude_despawned.emit(currentDude)

## Have the dude slide up to the counter
func move_dude(dude : Dude, point : Vector2):
	dude.set_begin(point)

func begin_spawning_dudes():
	dude_spawn_cooldown.stop()
	randomize_dude_cooldown()
	dude_spawn_cooldown.start()

func randomize_dude_cooldown():
	dude_spawn_cooldown.wait_time = randf_range(dudeSpawnCooldownMin, dudeSpawnCooldownMax)

func _on_dude_spawn_cooldown_timeout():
	spawn_dude()
	move_dude(currentDude, spawnPoint.position)
	var spawnTween = create_tween()
	spawnTween.tween_property(currentDude, "position", introductionPoint.position, 1).set_trans(Tween.TRANS_ELASTIC)
	await spawnTween.finished
	dude_spawned.emit(currentDude)
	dude_stand_timer.start()
	spawnTween.tween_callback(currentDude.queue_free)

func _on_dude_stand_timer_timeout():
	var despawnTween = create_tween()
	despawnTween.tween_property(currentDude, "position", spawnPoint.position, 0.2)
	await despawnTween.finished
	despawn_current_dude()
	dude_spawn_cooldown.stop()
	randomize_dude_cooldown()
	dude_spawn_cooldown.start()
	despawnTween.tween_callback(currentDude.queue_free)

func stop_spawning_dudes() -> void:
	dude_spawn_cooldown.stop()
