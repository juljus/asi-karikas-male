/// @description Init prompt
// You can write your code in this editor

// Cancel if a prompt already exists
if (instance_number(ob_prompt) > 1)
	instance_destroy();

//other_id = 0; // Object that called the prompt
obj_layer = "PromptButtons";
// value = "";

/*  Keyword for the purpose of the prompt
	"promotion" - Pawn promotion
	"restart" - Restart the game
	"quit" - End game and exit to menu */
// prompt = "";



// Create text for buttons
var obj;
switch(prompt)
{
	case "promotion":
		obj = instance_create_layer(x, y-64, obj_layer, ob_text);
		obj.text = "Promote pawn to";
		
		obj = instance_create_layer(x-64, y, obj_layer, ob_button);
		obj.text = "4"; // Queen
		
		obj = instance_create_layer(x+64, y, obj_layer, ob_button);
		obj.text = "3"; // Rook
		
		obj = instance_create_layer(x-64, y+64, obj_layer, ob_button);
		obj.text = "2"; // Bishop
		
		obj = instance_create_layer(x+64, y+64, obj_layer, ob_button);
		obj.text = "1"; // Knight
		break;
		
	case "restart":
		obj = instance_create_layer(x, y-32, obj_layer, ob_text);
		obj.text = "End the game and start a new one?";
		
		obj = instance_create_layer(x-64, y+32, obj_layer, ob_button);
		obj.text = "Yes";
		
		obj = instance_create_layer(x+64, y+32, obj_layer, ob_button);
		obj.text = "No";
		break;
		
	case "quit":
		obj = instance_create_layer(x, y-32, obj_layer, ob_text);
		obj.text = "End the game and return to menu?";
		
		obj = instance_create_layer(x-64, y+32, obj_layer, ob_button);
		obj.text = "Yes";
		
		obj = instance_create_layer(x+64, y+32, obj_layer, ob_button);
		obj.text = "No";
		break;
}
		