extends Node

const MAX_INGREDIENTS = 999	## Maximum number of ingredients. 

## Lists all files in a directory.
func list_files_in_directory(path) -> Array:
	var files = []
	var dir : DirAccess = DirAccess.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()
	return files
