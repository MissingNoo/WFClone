#region Fishing
fishchance = 0;
#endregion
spd = oLobby.player_speed;
if (!instance_exists(oCamWorld)) {
    instance_create_depth(x, y, depth, oCamWorld);
}
sendtimer = 10;

state = new SnowState("Idle");
state.add("Idle", {
	enter : function() {
	},
	step : function() {
		var leftright = -input_check("left") + input_check("right");
		var updown = -input_check("up") + input_check("down");
		if (leftright != 0 or updown != 0) {
		    state.change("Walk");
		}
		var fishaction = input_check("action");
		if (fishaction) {
		    state.change("Fishing");
		}
	},
	draw : function() {
	},
});
state.add("Walk", {
	enter : function() {
	},
	step : function() {
		sendtimer = clamp(sendtimer - 1, 0, 20);
		spd = oLobby.player_speed;
		var leftright = -input_check("left") + input_check("right");
		var updown = -input_check("up") + input_check("down");
		if (leftright == 0 and updown == 0) {
		    state.change("Idle");
		}
		var hspd = leftright * spd;
		var vspd = updown * spd;
		if (hspd < 0) {
		    image_xscale = -0.3;
		}
		else if (hspd > 0) {
		    image_xscale = 0.3;
		}
		if (input_check_pressed("left") or input_check_pressed("right") or input_check_pressed("down") or input_check_pressed("up")) {
		    sendMessageNew("MovePlayer", {x, y, hspd, vspd});
		}
		if (input_check_released("left") or input_check_released("right") or input_check_released("down") or input_check_released("up")) {
		    sendMessageNew("MovePlayer", {x, y, hspd, vspd});
		}
		if (leftright != 0 or updown != 0) {
		    sprite_index = sWalk;
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
	},
	draw : function() {
	},
});
state.add("Fishing", {
	enter : function() {
		fishchance = 0.01;
		fishdistance = 10;
		sendrod = true;
	},
	step : function() {
		var cancel = input_check("cancel");
		if (cancel) {
		    state.change("Idle");
		}
		if (input_check("action")) {
		    fishdistance = clamp(fishdistance + 1, 5, 100);
		}
		else if(sendrod) {
			sendrod = false;
			sendMessageNew("FishDistance", {fishdistance});
		}
		if ((fishchance > 1 and irandom_range(0, 100) <= fishchance) or fishchance >= 25) {
		    state.change("Caught");
		}
		else {
			fishchance += 0.01;
		}
	},
	draw : function() {
		draw_sprite_ext(sVara, 0, x, y, image_xscale, image_yscale, 0, c_white, 1);
		draw_line(x + lengthdir_x(sprite_get_width(sVara) * image_xscale, 0) - (53 * image_xscale), y + lengthdir_y(sprite_get_height(sVara) * image_yscale, 90), x + fishdistance, y);
		draw_sprite_ext(sAim, 0, x + (fishdistance), y, 1, 1, 0, c_white, 1);
		scribble(fishchance).draw(x, y - 16);
	},
});
state.add("Caught", {
	enter : function() {
		percent = 1;
		failpercent = -3;
        
	},
	step : function() {
		if (device_mouse_check_button(0, mb_left)) {
		    percent += 0.5;
		}
		failpercent += 0.15;
		if (failpercent > percent) {
		    state.change("Idle");
		}
	},
	draw : function() {
	},
	gui : function() {
		scribble("teste").draw(x, y);
		draw_rectangle(10, 30, (100 * percent) / 100, 50, false);
		draw_rectangle_color(10, 10, (100 * failpercent) / 100, 50, c_red, c_red, c_red, c_red, false);
		draw_rectangle(10, 30, 100, 50, true);
	}
});