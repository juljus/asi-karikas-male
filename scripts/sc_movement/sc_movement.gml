// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function get_moves(){
	/// Get valid moves for pieces
	// Pawn
	if (image_index == 0)
	{
		// White
		if (player == 1)
		{
			// Move forward if the cell is completely empty
			if (get_free(0, -1, 1) == 2)
			{
				spot(0, -1, 1);
		
				// If at starting position, allow double move
				if (y == ystart and get_free(0, -2, 2) == 2)
				spot(0, -2, 2);
			}
		
			// Capture diagonally
			if (get_free(-1, 0, 1) == 1)
			spot(-1, 0, 1);
			if (get_free(1, -1, 0) == 1)
			spot(1, -1, 0);
			
			// En passant
			passant(-1, 0, 1, -1, 1, 1);
			passant(1, -1, 0, 1, 0, 1);
		}
		// Black
		else if (player == 2)
		{
			// Move forward if the cell is completely empty
			if (get_free(0, 1, -1) == 2)
			{
				spot(0, 1, -1);
		
				// If at starting position, allow double move
				if (y == ystart and get_free(0, 2, -2) == 2)
				spot(0, 2, -2);
			}
		
			// Capture diagonally
			if (get_free(1, 0, -1) == 1)
			spot(1, 0, -1);
			if (get_free(-1, 1, 0) == 1)
			spot(-1, 1, 0);
			
			// En passant
			passant(-1, 1, 0, -1, 0, -1);
			passant(1, 0, -1, 1, -1, -1);
		}
	}
	
	// Knight
	else if (image_index == 1)
	{
		// Two adjacent cells, one at an angle
		spot(-1, -2, 3);
		spot(-2, -1, 3);
		spot(-3, 1, 2);
		spot(-3, 2, 1);
		
		spot(-2, 3, -1);
		spot(-1, 3, -2);
		spot(1, 2, -3);
		spot(2, 1, -3);
		
		spot(3, -1, -2);
		spot(3, -2, -1);
		spot(2, -3, 1);
		spot(1, -3, 2);
	}
	
	// Bishop
	else if (image_index == 2)
	{
		// Move diagonally, between cells
		spot_loop(-1, -1, 2);
		spot_loop(-2, 1, 1);
		spot_loop(-1, 2, -1);
		spot_loop(1, 1, -2);
		spot_loop(2, -1, -1);
		spot_loop(1, -2, 1);
	}
	
	// Rook
	else if (image_index == 3)
	{
		// Move to adjacent cells
		spot_loop(-1, 0, 1);
		spot_loop(0, -1, 1);
		spot_loop(1, -1, 0);
		spot_loop(1, 0, -1);
		spot_loop(0, 1, -1);
		spot_loop(-1, 1, 0);
	}
	
	// Queen
	else if (image_index == 4)
	{
		// Rook and bishop moves, repeated
		spot_loop(-1, -1, 2);
		spot_loop(-2, 1, 1);
		spot_loop(-1, 2, -1);
		spot_loop(1, 1, -2);
		spot_loop(2, -1, -1);
		spot_loop(1, -2, 1);
	
		spot_loop(-1, 0, 1);
		spot_loop(0, -1, 1);
		spot_loop(1, -1, 0);
		spot_loop(1, 0, -1);
		spot_loop(0, 1, -1);
		spot_loop(-1, 1, 0);
	}
	
	// King
	else if (image_index == 5)
	{
		// Rook and bishop moves, one at a time
		spot(-1, -1, 2);
		spot(-2, 1, 1);
		spot(-1, 2, -1);
		spot(1, 1, -2);
		spot(2, -1, -1);
		spot(1, -2, 1);
	
		spot(-1, 0, 1);
		spot(0, -1, 1);
		spot(1, -1, 0);
		spot(1, 0, -1);
		spot(0, 1, -1);
		spot(-1, 1, 0);
	}
}

function spot(dx, dy, dz){
	/// Mark the spot if available
	/// Return spot object ID if created, otherwise 0
	var free = get_free(dx, dy, dz)
	var dot = 0;
	if (free)
	{
		dot = instance_create_layer(
			cubic_to_screen(ix+dx, iy+dy)[0],
			cubic_to_screen(ix+dx, iy+dy)[1],
			"Instances", ob_move_dot
		);
	}
	return dot;
}

function spot_loop(dx, dy, dz){
	/// Repeated moves in one direction
	var _x = 0;
	var _y = 0;
	var _z = 0;
	
	while(true)
	{
		_x += dx;
		_y += dy;
		_z += dz;
		spot(_x, _y, _z);
		if (get_free(_x, _y, _z) < 2)
		return;
	}
}

function passant(own_x, own_y, own_z, other_x, other_y, dir){
	/// Check for en passant
	
	/*	own_x/y/z - Coordinates to move to, relative to piece position
		other_x/y - Coordinates of piece to capture
		dir - Direction of the opposing piece - +1 for down, -1 for up
	
	/*	Requirements for en passant:
		A pawn from opposing side that just moved 2 cells as a first move.
		The currently moving pawn must be able to move to the cell the other pawn skipped.
		The opposing pawn will be captured after the move.
	*/
	
	// Get object ID of pawn to be captured
	var other_id = instance_position(
		cubic_to_screen(ix+other_x, iy+other_y)[0],
		cubic_to_screen(ix+other_x, iy+other_y)[1],
		ob_piece_par
	)
			
	if (other_id and other_id == last_moved_piece
	and player != other_id.player and other_id.image_index == 0
	and other_id.x == other_id.xstart and other_id.y = other_id.ystart + dir * 112)
	{
		// Mark the spot if en passant requirements are fulfilled
		var dot = spot(own_x, own_y, own_z);
		dot.to_capture = other_id; // Set the other pawn to be captured
	}
}

function get_free(dx, dy, dz){
	/// Determine if a spot is free in relative position
	// Return values:
	// 0 - Cannot move there
	// 1 - Opposing piece at cell
	// 2 - Cell free
	
	var _x = ix + dx;
	var _y = iy + dy;
	var _z = iz + dz;
	
	// Make sure the coordinate is valid
	if (_x + _y + _z != 0)
	{
		show_debug_message("Invalid coord " + " " 
			+ string(_x) + " " + string(_y) + " " + string(_z));
		return 0;
	}
	
	// Make sure the tile is in bounds
	if (abs(_x) > 5 or abs(_y) > 5 or abs(_z) > 5)
	return 0;
	
	// Check if a piece is already in spot
	with (ob_piece_par)
	{
		if (ix == _x and iy == _y and iz == _z)
		{
			// Allow capture if opponent piece
			if (player == other.player)
			return 0;
			else
			return 1;
		}
	}
	
	return 2;
}

function move(_x, _y, _z){
	/// Move the piece to specified location
	
	last_moved_piece = id;
	moves += 1;
	
	// Capture piece
	with (ob_piece_par)
	{
		if (ix == _x and iy == _y and iz == _z)
		{
			instance_destroy();
		}
	}
	
	// Move
	ix = _x;
	iy = _y;
	iz = _z;
	x = cubic_to_screen(ix, iy)[0];
	y = cubic_to_screen(ix, iy)[1];
	
	instance_destroy(ob_move_dot);
	player_to_move = 3 - player_to_move;
	
	// Pawn promotion
	if (image_index == 0)
	{
		if (player == 1 and (iz == 5 or iy == -5))
		{
			image_index = 4;
		}
		if (player == 2 and (iz == -5 or iy == 5))
		{
			image_index = 4;
		}
	}
}