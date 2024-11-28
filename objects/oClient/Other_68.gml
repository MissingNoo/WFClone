var r = get_response(async_load);
if (r == -1) { exit; }
switch (r[$ "type"]) {
    case "MovePlayer":
		var name = r[$ "username"];
		var xz = r[$ "x"];
		var yz = r[$ "y"];
		var hs = r[$ "hspd"];
		var vs = r[$ "vspd"];
		with (oSlave) {
		    if (username == name) {
			    hspd = hs;
			    vspd = vs;
			    xx = xz;
			    yy = yz;
			}
		}
		break;
}