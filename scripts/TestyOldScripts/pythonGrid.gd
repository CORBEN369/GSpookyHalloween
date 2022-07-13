extends Node2D

#Grid Variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset
var grid = [[]]
var grid_size_r = 15
var grid_size_c = 10
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var num_of_skellys = 2
var digs_left = 10
var game_over = false
var num_of_skellys_dug = 0
var skelly_positions = [[]]
var all_valid

#Ready function to get it all started. should be at the bottom instead?
func _ready():
	create_grid()
	#spawn_pieces()
	
func validate_grid_and_place_skelly(start_row, end_row, start_col, end_col):
	#Will check row or column to see if it is safe to place a  skelly there.
	all_valid = true
	for r in range(start_row, end_row):
		for c in range(start_col, end_col):
			if grid[r][c] != ".":
				all_valid = false
				break
	if all_valid:
		skelly_positions.append([start_row, end_row, start_col, end_col])
		for r in range(start_row, end_row):
			for c in range(start_col, end_col):
				grid[r][c] = "O"
	return all_valid

func try_to_place_skelly_on_grid(row, col, direction, length):
	#Based on direction will call helper method to try and place a skelly on the grid.  
	var start_row = row
	var end_row = row + 1
	var start_col = col
	var end_col = col + 1
	for r in range(start_row, end_row):
		for c in range( start_col, end_col):	
			if direction == "left":
				if col - length < 0:
					return false
				start_col = col - length + 1

			elif direction == "right":
				if col + length >= grid_size_c:
					return false
				end_col = col + length

			elif direction == "up":
				if row - length < 0:
					return false
				start_row = row - length + 1

			elif direction == "down":
				if row + length >= grid_size_r:
					return false
				end_row = row + length

			return validate_grid_and_place_skelly(start_row, end_row, start_col, end_col)

#make 2d Array Grid. 
func create_grid():
	#Will create a 10 x 15 grid and randomly place down ships or different sizes and in different directions. 
	var rows = grid_size_r
	var cols = grid_size_c
	var grid = []
	
	for r in range(rows):
		var row = []
		for c in range(cols):
			row.append(".")
		grid.append(row)
		
	var num_of_skellys_placed = 0
	skelly_positions = []
	while num_of_skellys_placed != num_of_skellys:
		randomize()
		var random_row = rand_range(0, rows - 1)
		var random_col = rand_range(0, cols -1)
		var direction = ["left", "right", "up", "down"]
		var dir = direction[randi() % direction.size()]
		var skelly_size = rand_range(2, 4)
		if try_to_place_skelly_on_grid(random_row, random_col, dir, skelly_size):
			num_of_skellys_placed +=1
				
func print_grid():
	
	alphabet = [alphabet.size() + 1] 
	for row in range(grid.size()):
		print(alphabet[row].size())
		for col in range(grid[row].size()):
			if grid[row][col] == "O":
				if print_debug("O"):
					print("O")
				else:
					print(".")
			else:
				print(grid[row][col])
		print("")
	print(" ")
	for i in range(len(grid[0])):
		print(str(i))
	print("")
	
func accept_valid_dig_placement():
	 #Will get valid row and column to place bullet shot
	
	var is_valid_placement = false
	var placement
	var row = -1
	var col = -1
	while is_valid_placement == false:
		placement = input("Enter row (A-J) and column (0-9) such as A3: ")
		placement = placement.upper()
		if len(placement) <= 0 or len(placement) > 2:
			print("Error: Please enter only one row and column such as A3")
			continue
		row = placement[0]
		col = placement[1]
		if not row.isalpha() or not col.isnumeric():
			print("Error: Please enter letter (A-J) for row and (0-9) for column")
			continue
		row = alphabet.find(row)
		if not (-1 < row < grid_size_r):
			print("Error: Please enter letter (A-J) for row and (0-9) for column")
			continue
		col = int(col)
		if not (-1 < col < grid_size_c):
			print("Error: Please enter letter (A-J) for row and (0-9) for column")
			continue
		if grid[row][col] == "#" or grid[row][col] == "X":
			print("You have already shot a bullet here, pick somewhere else")
			continue
		if grid[row][col] == "." or grid[row][col] == "O":
			is_valid_placement = true
	return [row][col]

func check_for_skelly_dug():
	 #If all parts of a skelly have been dug it is revealed and we later increment skellys_dug
   
	for position in skelly_positions:
		var row
		var col
		var start_row = position[0]
		var end_row = position[1]
		var start_col = position[2]
		var end_col = position[3]
		if start_row <= row and start_row <= end_row:
			if start_col <= col and start_col <= end_col:
			# Skelly found, now check if its all revealed
				for r in range(start_row, end_row):
					for c in range(start_col, end_col):
						if grid[r][c] != "X":
							return false
	return true	
	
func dig_hole():
	#Updates grid and skellys based on where the shovel landed to dig. Has no return but will use accept_valid_bullet_placement.
	 #Updates grid and skellys based on where the hole was dug
	var row
	var col   
	grid[row][col] = accept_valid_dig_placement()
	print("")
	print("----------------------------")

	if grid[row][col] == ".":
		print("You missed, no skelly was dug")
		grid[row][col] = "#"
	elif grid[row][col] == "O":
		print("You hit!")
		grid[row][col] = "X"
		if check_for_skelly_dug():
			print("You found a skelly!")
			num_of_skellys_dug += 1
		else:
			print("A skelly was dug")

	digs_left -= 1
	
func check_for_game_over():
	 #If all skellys have been dug or we run out of turns it is game over.
  
	if num_of_skellys == num_of_skellys_dug:
		print("Congrats you won!")
		game_over = true
	elif digs_left <= 0:
		print("Sorry, you lost! You ran out of bullets, try again next time!")
		game_over = true
	

	



