## Manager for Dude-related functionality. 
class_name DudeManager extends Control

const TIMER_INCREMENT : float = 0.5
const STAND_INCREMENT : float = 0.5
const MINIMUM_STAND_TIME : float = 1.0
const MINIMUM_SPAWN_TIME : float = 1.0

const TEXTURE_DIRECTORY : String = "res://assets/dudes/"

const DUDE_AUDIO = [
	preload("res://audio/sfx/dudes/dudes_1.ogg"),
	preload("res://audio/sfx/dudes/dudes_2.ogg"),
	preload("res://audio/sfx/dudes/dudes_3.ogg"),
	preload("res://audio/sfx/dudes/dudes_4.ogg"),
	preload("res://audio/sfx/dudes/dudes_5.ogg")
]

## Currently loaded dude
var currentDude : Dude
const preloadedDudeScene = preload("res://DataTypes/Dude/Dude.tscn")

# data arrays
var namesArray : Array
var texturesArray : Array

# source for random generation
@export_dir var textureDirectory
@export_file var namesFilePath

@export_range(0.1, 30.0, 0.1) var dudeSpawnCooldownMin : float = 5.0	## Minimum Time to spawn a dude
@export_range(0.1, 30.0, 0.1) var dudeSpawnCooldownMax : float = 10.0	## Maximum Time to spawn a dude
@export_range(0.1, 30.0, 0.1) var dudeStandTime : float = 5.0			## Amount of Time a dude hangs around
@export var introductionPoint : Node2D
@export var spawnPoint : Node2D
@export var orderManager : OrderManager

signal dude_spawned(dude)
signal dude_despawned(dude)

@onready var dude_spawn_cooldown = $DudeSpawnCooldown
@onready var dude_stand_timer = $DudeStandTimer
@onready var dude_audio = $DudeAudio

var rollingDudeSpawnModifier : float = 0.0	## Increase to make dudes spawn faster. 
var rollingDudeStandModifier : float = 0.0 	## Increase to make dudes stick around less. 

# Called when the node enters the scene tree for the first time.
func _ready():
	build_data_arrays()
	dude_stand_timer.wait_time = dudeStandTime

func build_data_arrays():
	build_name_array()
	build_portrait_array()

func build_name_array():
	var list = FileAccess.open(namesFilePath, FileAccess.READ)
	while not list.eof_reached():
		var newName = list.get_line()
		if newName != "":
			namesArray.append(newName)

func build_portrait_array():
	var textureFilesArray = Globals.list_files_in_directory(TEXTURE_DIRECTORY)
	for textureFile in textureFilesArray:
		var newTexture = load(textureFile)
		texturesArray.append(newTexture)

func spawn_dude():
	var dudeName = namesArray.pick_random()
	var dudeTexture = texturesArray.pick_random()
	var dudeOrder : OrderFull = orderManager.get_random_order_instance()
	var dudeSceneInstance = preloadedDudeScene.instantiate()
	## Connect Order Signals for Dude
	dudeOrder.connect("order_failed", Callable(dudeSceneInstance, "_on_dudes_order_failed"))
	dudeOrder.connect("order_completed", Callable(dudeSceneInstance, "_on_dudes_order_success"))
	
	## Set up the Dude
	dudeSceneInstance.setup(dudeName, dudeTexture, dudeOrder)
	add_child(dudeSceneInstance)
	currentDude = dudeSceneInstance
	dude_audio.stream = DUDE_AUDIO.pick_random()
	dude_audio.play()

func despawn_current_dude():
	remove_child(currentDude)
	dude_despawned.emit(currentDude)

## Have the dude slide up to the counter
func move_dude(dude : Dude, point : Vector2):
	dude.set_begin(point)

## Called when the game timer reaches its threshold. 
func _on_game_timer_threshold_reached() -> void:
	rollingDudeSpawnModifier += TIMER_INCREMENT
	rollingDudeStandModifier += STAND_INCREMENT
	
func begin_spawning_dudes():
	dude_spawn_cooldown.stop()
	# Set Initial Dude Spawn Time
	dude_spawn_cooldown.wait_time = 0.1
	dude_spawn_cooldown.start()

func randomize_dude_cooldown():
	dude_spawn_cooldown.wait_time = max(MINIMUM_SPAWN_TIME,(randf_range(dudeSpawnCooldownMin, dudeSpawnCooldownMax) - rollingDudeSpawnModifier))

func _on_dude_spawn_cooldown_timeout():
	spawn_dude()
	move_dude(currentDude, spawnPoint.position)
	var spawnTween = create_tween()
	spawnTween.tween_property(currentDude, "position", introductionPoint.position, 1).set_trans(Tween.TRANS_ELASTIC)
	await spawnTween.finished
	dude_spawned.emit(currentDude)
	dude_stand_timer.wait_time = max(MINIMUM_STAND_TIME, dudeStandTime - rollingDudeStandModifier)
	dude_stand_timer.start()

func _on_dude_stand_timer_timeout():
	var despawnTween = create_tween()
	despawnTween.tween_property(currentDude, "position", spawnPoint.position, 0.2).set_trans(Tween.TRANS_ELASTIC)
	await despawnTween.finished
	despawn_current_dude()
	dude_spawn_cooldown.stop()
	randomize_dude_cooldown()
	dude_spawn_cooldown.start()

func stop_spawning_dudes() -> void:
	despawn_current_dude()
	dude_stand_timer.paused = true
	dude_spawn_cooldown.paused = true
