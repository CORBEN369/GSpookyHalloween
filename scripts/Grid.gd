extends Node2D

export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset

var possible_pieces = [
	preload("res://Pieces/BuriedSkellyPart.tscn"),
	preload("res://Pieces/HoleDugNoSkelly.tscn"),
	preload("res://Pieces/SkellyPartHit.tscn"),
	preload("res://Pieces/Dirt.tscn")
]
var all_pieces = []


func _ready():	
	all_pieces = make_grid()
	print_grid()
	#validate_grid_and_place_skelly()
	#print(all_pieces)
	
	
#make 2d array for grid based on global parameters in grid scene. 
func make_grid():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array
	
func print_grid():
	#looking at all the columns in the grid starting at zero
	for i in width:
		#looking through all the rows in the grid starting at zero
		for j in height:
			#choose a random number and store it.
			var rand = floor(rand_range(0, possible_pieces.size()))
			#instance that piece from the array.
			var piece = possible_pieces[rand].instance()
			add_child(piece)
			piece.position = grid_to_pixel(i, j)

	
#transform and grid position to a pixel position.
func grid_to_pixel(col, row):
	var new_x = x_start + offset * col
	var new_y = y_start + -offset * row
	return Vector2(new_x, new_y)
	
			
	
