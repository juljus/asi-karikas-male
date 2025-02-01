/// @description Draw button and text
// You can write your code in this editor

draw_self();
draw_text(x,y,text);

if (text == "1" or text == "2" or text == "3" or text == "4")
{
	if (ob_prompt.other_id.player == 1)
		sprite = sp_piece_white;
	else
		sprite = sp_piece_black;
	draw_sprite_stretched(sprite, real(text), x-20, y-20, 40, 40);	
}