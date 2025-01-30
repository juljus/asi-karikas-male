// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/*
X - left to right
Y - top-right to bottom-left
Z - bottom-right to top-left
Starting point (0; 0; 0) at board center
X + Y + Z = 0
*/

function screen_to_cubic(_x,_y){
	/// Get cubic coordinates for the board using on-screen position
	origin = 360;
	hex_size = 32;
	x1 = (_x - origin) / hex_size;
    y1 = (_y - origin) / hex_size;

	var q = (2/3 * x1);
	var r = (-1/3 * x1 + sqrt(3)/3 * y1);
    var s = -q - r;

    // Round to the nearest cubic coordinate
    var q_round = round(q);
    var r_round = round(r);
    var s_round = round(s);

    // Calculate the largest difference
    var dq = abs(q_round - q);
    var dr = abs(r_round - r);
    var ds = abs(s_round - s);

    // Adjust rounding to ensure q + r + s = 0
    if (dq > dr && dq > ds) {
        q_round = -r_round - s_round;
    } else if (dr > ds) {
        r_round = -q_round - s_round;
    } else {
        s_round = -q_round - r_round;
    }

	ix = q_round;
	iy = r_round;
	iz = s_round;
}

function cubic_to_screen(q, r){
	/// Get on-screen position from cubic coordinates
	origin = 360;
	hex_size = 32;
    var x1 = origin + hex_size * (3 / 2 * q);
    var y1 = origin + hex_size * (1.75 / 2 * q + 1.75 * r);
	
	return [x1, y1];
}

function move_to_position(){
	/// Shortcut for pieces to move to correct position on screen
	x = cubic_to_screen(ix, iy)[0];
	y = cubic_to_screen(ix, iy)[1];
}