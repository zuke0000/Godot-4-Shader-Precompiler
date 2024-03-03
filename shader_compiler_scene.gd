extends Node3D

## Here we grab every material and resource which we will cache behind a screen

const materials_path = "res://Assets/Materials/"
const shaders_path = "res://Assets/Shaders/"
var materials = [Resource]
var shaders = [Shader]

# Called when the node enters the scene tree for the first time.
func _ready():
	materials = (list_files_in_directory(materials_path))
	print(materials)
	shaders = list_files_in_directory(shaders_path)
	print(shaders)
	cache_shaders()


## TODO: This should recursively search each folder in the directory and add it to the list. 
func list_files_in_directory(path):
	var files = []
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	return files

## Here we will start caching the materials and resources 

@onready var mesh = $MeshInstance3D
func cache_shaders():
	pass
	## TODO
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	## TODO: 
	pass
