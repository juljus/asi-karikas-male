/// @description Get available moves
// You can write your code in this editor

if (player_to_move == player and !instance_exists(ob_prompt))
{
	instance_destroy(ob_move_dot);
	if (selected_piece == id)
		selected_piece = -1;
	else
	{
		selected_piece = id;
		get_moves();
	}
}