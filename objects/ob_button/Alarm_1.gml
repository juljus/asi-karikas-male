/// @description Respond to prompt
// You can write your code in this editor

if (response == "Yes")
{
	if (text == "Restart")
		room_restart();
	else if (text == "Quit")
		room_goto(rm_menu);
}



