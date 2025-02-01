/// @description Button effect
// You can write your code in this editor


switch(text)
{
	case "Start": room_goto(rm_game); break;
	case "White": global.play_as_white = 1; break;
	case "Black": global.play_as_white = 0; break;
	case "vs. Bot": global.use_bot = 1; break;
	case "2-player": global.use_bot = 0; break;
	case "Quit":
		if (last_moved_piece == -1 or mate)
			room_goto(rm_menu);
		else if (!instance_exists(ob_prompt))
		{
			instance_create_layer(
				360, 360, 
				"PromptBackground", 
				ob_prompt,
				{prompt : "quit", other_id : id}
			); 
		} break;
	case "Restart": 
		if (last_moved_piece == -1 or mate)
			room_restart();
		else if (!instance_exists(ob_prompt))
		{
			instance_create_layer(
				360, 360, 
				"PromptBackground", 
				ob_prompt,
				{prompt : "restart", other_id : id}
			);
		} break;
	
	default:
		if (instance_exists(ob_prompt))
		{
			// If it is part of a prompt, return the value to the caller
			ob_prompt.other_id.alarm[1] = 1;
			ob_prompt.other_id.response = text;
			layer_destroy_instances(layer_get_id(ob_prompt.obj_layer));
			instance_destroy(ob_prompt);
		}
			
}

with (ob_button)
	alarm[0] = 1; // Update button state