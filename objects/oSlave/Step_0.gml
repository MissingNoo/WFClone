//feather disable all
if (vspd != 0 or hspd != 0) {
    sprite_index = sWalk;
	if (hspd > 0) {
	    image_xscale = 0.3;
	}
	if (hspd < 0) {
	    image_xscale = -0.3;
	}
}
else {
	sprite_index = sIdle;
}
if (!place_meeting(x + hspd, y, oCollision)) {
    x += hspd;
}
else {
	if (!place_meeting(x + sign(hspd), y, oCollision)) {
	    x += sign(hspd);
	}
}
if (!place_meeting(x, y + vspd, oCollision)) {
    y += vspd;
}
else {
	if (!place_meeting(x, y+ sign(vspd), oCollision)) {
	    y += sign(vspd);
	}
}
if (vspd == 0 and hspd == 0 or x < -100) {
    var xdist = xx - x;
	if (xdist * sign(xdist) > 20) {
	    x = xx;
	}
	var ydist = yy - y;
	if (ydist * sign(ydist) > 20) {
	    y = yy;
	}
}