//feather disable all
#region Server status
draw_sprite_ext(sNetworkingHud, 0, gw / 2, gh / 2 - infoOffset[0], 8, 6, 0, c_white, 1);
var _statusColor = "c_green";
var _serverOnline = "Server Online";
if (connected != 0) {
    _statusColor = "c_red";
    _serverOnline = "Server Offline";
}
var _title = "Server Status";
scribble($"[fa_middle][fa_center]{_title}").scale(3).draw(gw / 2, gh / 2 - infoOffset[0] - 100);
scribble($"[{_statusColor}][sNStatus][c_white]{_serverOnline}").scale(2).draw(gw / 2 - 170, gh / 2 - infoOffset[0] - 70);
scribble($"Loggedin: {loggedin ? "Yes" : "No"}").scale(2).draw(gw / 2 - 170, gh / 2 - infoOffset[0] - 20);
#endregion