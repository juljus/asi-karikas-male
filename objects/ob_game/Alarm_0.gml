/// @description Bot move
// You can write your code in this editor

/*get_best_move(color):
    return [[start_pos], [end_pos], [tar_piece]]*/

var bot_move;
if (player_to_move == 1)
	bot_move = get_best_move("white");
else if (player_to_move == 2)
	bot_move = get_best_move("black");
	
show_debug_message(string(bot_move));
	
with(instance_nearest( 
	cubic_to_screen(bot_move[0][0], bot_move[0][0])[0],
	cubic_to_screen(bot_move[0][1], bot_move[0][1])[1],
	ob_piece_par)
)

{
	move(bot_move[1][0], bot_move[1][1], bot_move[1][2]);
}




