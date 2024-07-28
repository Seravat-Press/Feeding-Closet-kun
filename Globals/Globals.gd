extends Node

const MAX_INGREDIENTS = 999	## Maximum number of ingredients. 
const CLOSET_STAGE_COST = 50	## Cost of ingredients in stack to decrease closet hunger stage. 

const GOOD_BOOP = preload("res://audio/sfx/good_boop.ogg")
const BAD_BOOP = preload("res://audio/sfx/bad_boop.ogg")

var scoreManager : ScoreManager

## Lists all files in a directory.
func list_files_in_directory(path) -> Array:
	var files = []
	var dir : DirAccess = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") && not file.get_extension() == "remap":
			if file.get_extension() == "import":
				file = file.get_slice(".import", 0)
			files.append(dir.get_current_dir().path_join(file))
	dir.list_dir_end()
	return files

## Imports an image file as a texture
func import_image(path : String) -> ImageTexture:
	var file = FileAccess.open(path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		print("Error loading image ", path)
		return
	var buffer = file.get_buffer(file.get_length())
	var image = Image.new()
	var error = image.load_png_from_buffer(buffer)
	if error != OK:
		print("Error loading image ", path, "error: ", error)
		return
	var texture = ImageTexture.create_from_image(image)
	return texture

## Dummy Wait
func wait(wait_time : float) -> void:
	await get_tree().create_timer(wait_time).timeout

## Application function to grab the score manager. 
func get_score_manager() -> ScoreManager:
	return scoreManager
