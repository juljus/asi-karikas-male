// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sc_movement(){
	// Pawn
	if (image_index == 0)
	{
		spot(ix, iy-1, iz+1);
	}
		
}

function spot(_x, _y, _z){
	var free = true;
	with (ob_piece_par)
	{
		if (ix == _x and iy == _y and iz == _z)
		{
			free = false;
			break;
		}
	}
}