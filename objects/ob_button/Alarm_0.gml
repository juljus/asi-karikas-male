/// @description Button state
// You can write your code in this editor

if (text == "White")
{
	if (global.play_as_white)
		image_index = 2;
	else
		image_index = 0;
}
else if (text == "Black")
{
	if (global.play_as_white)
		image_index = 0;
	else
		image_index = 2;
}
else if (text == "vs. Bot")
{
	if (global.use_bot)
		image_index = 2;
	else
		image_index = 0;
}
else if (text == "2-player")
{
	if (global.use_bot)
		image_index = 0;
	else
		image_index = 2;
}

