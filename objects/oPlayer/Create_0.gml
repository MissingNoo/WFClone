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