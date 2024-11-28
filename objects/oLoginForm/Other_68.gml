var r = get_response(async_load);
if (r == -1) { exit; }
switch (r[$ "type"]) {
	case "Connect":
		global.playerid = r[$ "id"];
		break;
}