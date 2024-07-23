## The main game module
class_name Main extends Node

@onready var closet_timer = $Closet/HungerTimer
@onready var closet = $Closet
@onready var storage = $Storage

func _ready():
	start_game()

func start_game():
	$DudeManager.spawn_dude()
	closet.reset_hunger_timer()
	storage.add_shadow(100)
