/// @description Initialize piece
// You can write your code in this editor

image_speed = 0; // Disable animation
screen_to_cubic(x,y); // Get board coordinates

moves = 0;

// Black or white piece
if (sprite_index == sp_piece_white)
	player = 1;
else if (sprite_index == sp_piece_black)
	player = 2;