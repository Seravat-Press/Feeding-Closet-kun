## The main game module. Grabs different scenes. 
class_name Main extends Node

const MUSIC = preload("res://audio/music/an_ode_to_closet_kun.ogg")

const shopScene := preload("res://Main/Shop/ShopScene.tscn")
const startScreen := preload("res://UI/StartScreen/StartScreen.tscn")

@export var SkipMenu : bool = false		## Editor option to go straight into the shop scene. 

@onready var screen_fade = $ScreenFade
@onready var score_manager = $ScoreManager

var currentScene : Node
var nextScene : Node

func _ready():
	Globals.scoreManager = score_manager
	if SkipMenu:
		setup_next_scene(shopScene)
		currentScene = nextScene
		add_child(currentScene)
		move_child(currentScene,0)
		currentScene.start()
	else:
		setup_start_screen()
	
## Setup the start screen and queue it to open. 
func setup_start_screen(): 
	setup_next_scene(startScreen)
	currentScene = nextScene
	print(currentScene)
	add_child(currentScene)
	move_child(currentScene,0)

## Call to start the ShopScene. 
func _on_game_start() -> void:
	setup_next_scene(shopScene)
	screen_fade.fade_out()

## Call to clear the current game instance and start a new one. 
func _on_game_restart() -> void:
	setup_next_scene(shopScene) 
	screen_fade.fade_out()

## Called when the [ScreenFade] has faded in. 
func _on_screen_fade_faded_in():
	currentScene.start()

## Called when the [ScreenFade] has faded out. 
func _on_screen_fade_faded_out():
	remove_child(currentScene)
	currentScene.queue_free()
	currentScene = null
	install_next_scene()

## Sets up the next scene. Allows for early instantiation. 
func setup_next_scene(newScene : PackedScene) -> void:
	nextScene = newScene.instantiate()

## Installs the next scene
func install_next_scene() -> void:
	currentScene = nextScene
	currentScene.connect("ready", Callable(self, "_on_new_scene_ready"))
	add_child(currentScene)
	move_child(currentScene,0)

## Called when the new scene is ready. 
func _on_new_scene_ready() -> void:
	screen_fade.fade_in()

## Signaled by the start screen. 
func _on_start_pressed() -> void:
	_on_game_start()
