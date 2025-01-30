/// @description Initialize game
// You can write your code in this editor

// Font
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Game variables
globalvar player_to_move, selected_piece, last_moved_piece, in_check, 
	check_temp, mate;
player_to_move = 1;
selected_piece = -1;
last_moved_piece = -1;
in_check = 0;
check_temp = 0;
mate = 0;