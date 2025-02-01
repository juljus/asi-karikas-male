/// @description Initialize game variables
// You can write your code in this editor

globalvar player_to_move, selected_piece, last_moved_piece, in_check, 
	check_temp, mate;
player_to_move = 1;
selected_piece = -1;
last_moved_piece = -1;
in_check = 0;
check_temp = 0;
mate = 0;

// Start with bot
if (global.use_bot and !global.play_as_white)
	alarm[0] = 3;