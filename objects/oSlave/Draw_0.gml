event_inherited();
scribble(username).draw(x, y + 20);
if (fishing) {
    draw_sprite_ext(sVara, 0, x, y, image_xscale, image_yscale, 0, c_white, 1);
	draw_line(x + lengthdir_x(sprite_get_width(sVara) * image_xscale, 0) - (53 * image_xscale), y + lengthdir_y(sprite_get_height(sVara) * image_yscale, 90), x + fishdistance, y);
	draw_sprite_ext(sAim, 0, x + (fishdistance), y, 1, 1, 0, c_white, 1);
}