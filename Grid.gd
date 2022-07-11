extends Node2D

#Grid Variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset
#preload pieces and store in array
var possible_pieces = [
#preload("res://scripts/BGPiece.tscn"),
preload("res://scripts/PurplePiece.tscn")
	]

var all_pieces = []

#Ready function to get it all started
func _ready():
	all_pieces = make_2d_array()
	print(all_pieces)
	spawn_pieces()

#make 2d Array
func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array
	
#function to spawn pieces
func spawn_pieces():
	for i in width:
		for j in height:
			#choose a random number and store it
			var rand = floor(rand_range(0, possible_pieces.size()))
			#Instance piece from array
			var piece = possible_pieces[rand].instance()
			add_child(piece)
			#place its position
			piece.position = grid_to_pixel(i, j)			
			
	
#helper function to calculate grid position to pixel position
func grid_to_pixel(column, row):
	var new_x = x_start + offset * column
	var new_y = y_start + -offset * row
	#send this vector to back to who called it. func grid_to_pixel
	return Vector2(new_x, new_y)
			

	
	



