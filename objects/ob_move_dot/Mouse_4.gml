/// @description Move piece
// You can write your code in this editor
if (!instance_exists(ob_prompt))
{
	if (instance_exists(to_capture))
		instance_destroy(to_capture);
	with (selected_piece)
	{
		move(other.ix, other.iy, other.iz);
	}
}