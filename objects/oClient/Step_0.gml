//feather disable all
infoOffset[0] = lerp(infoOffset[0], infoOffset[1], 0.25);
if (keyboard_check_pressed(vk_f4)) {
	showinfo = !showinfo;
	if (showinfo) {
		infoOffset[1] = 0;
	}
	else {
		infoOffset[1] = gh / 2 + 200;
	}
}