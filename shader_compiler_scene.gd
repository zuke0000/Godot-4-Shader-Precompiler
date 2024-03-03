extends Node3D

## Here we grab every material and resource which we will cache behind a screen

const materials_path = "res://Assets/Materials/"
const shaders_path = "res://Assets/Shaders/"
var materials = [Resource]
var shaders = [Shader]
var total_shaders


# Called when the node enters the scene tree for the first time.
func _ready():
	materials = (list_files_in_directory(materials_path))
	print(materials)
	shaders = list_files_in_directory(shaders_path)
	print(shaders)
	set_material(0)
	update_text(0)
	total_shaders = materials.size() + shaders.size()
	
func update_text(index):
	$LoadingScreen/CenterContainer/Label.text = "Precompiling Shaders " +  str(index)+"/" + str(total_shaders)

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
## NOTE: Some materials will send an error when loaded due to missing files, I will eventually fix this. Ignore for now
@onready var mesh = $MeshInstance3D
func set_material(index):
	var mat = load(materials_path + materials[index])
	mesh.material_override = mat


## TODO: fix this :(
func set_shader(index):
	mesh.material = Material.new()
	mesh.material.shader = load(shaders_path + shaders[index])

var mat_index = 0
var shader_index = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#set_material(mat_index)
	#mat_index += 1
	#mat_index =  mat_index %materials.size()
	set_shader(shader_index)
	shader_index += 1
	shader_index = shader_index % shaders.size()
	update_text(mat_index)
	print('mat index:', mat_index)
	
	if mat_index == total_shaders:
		## TODO: here we should end the scene, something for me to take care
		pass
