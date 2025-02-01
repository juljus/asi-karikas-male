/// @description HUD
// You can write your code in this editor

if (player_to_move == 1)
	draw_text(x, y, "White's turn");
else if (player_to_move == 2)
	draw_text(x, y, "Black's turn");
	
if (in_check)
	draw_text(x, y+24, "Check!");
	
if (mate)
{
	if (in_check)
		draw_text(x, y+48, "Checkmate!");
	else
		draw_text(x, y+48, "Stalemate!");
		
	if (player_to_move == 1)
		draw_text(x, y+72, "Black won!");
	else if (player_to_move == 2)
		draw_text(x, y+72, "White won!");
}