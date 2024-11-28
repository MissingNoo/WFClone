//feather disable all
var title_start_offset = (sprite_get_height(sNetworkingHud) * form_scale_y) / 2;
var _x = gw - form_x;
var _y = gh  - form_y;
draw_sprite_ext(sNetworkingHud, 0, _x, _y, form_scale_x, form_scale_y, 0, c_white, 1);
_y += title_offset - title_start_offset;
scribble("[fa_center][fa_top]Login").scale(title_scale).draw(_x, _y);
_y += add_offset;
textbox({
	x: _x,
	y: _y,
	text: "Username",
	variable: "username",
	instance: oLoginForm,
	width : 100,
	color : oLoginForm.selected == 0 ? c_yellow : c_white,
	func : function() { 
		keyboard_string = oLoginForm.username;
		oLoginForm.selected = 0;
	}
});

_y += add_offset + button_yoffset;
networking_button({
	_x : _x,
	_y,
	text: "Set name",
	func: function(){
		global.username = oLoginForm.username;
		oClient.loggedin = true;
		sendMessageNew("setusername", {name : global.username});
		ini_open("settings");
		ini_write_string("Settings", "Username", global.username);
		ini_close();
		instance_create_depth(0, 0, 0, oLobby);
		instance_destroy(oLoginForm);
	}
});