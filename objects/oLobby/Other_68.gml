var r = get_response(async_load);
if (r == -1) { exit; }
switch (r[$ "type"]) {
    case "JoinLobby":
		fsm.change("OnLobby");
		room_goto(rLobby);
		break;
	case "ListLobbies":
		rooms = json_parse(r[$ "lobbies"]);
		break;
	case "UpdatePlayers":
		players = json_parse(r[$ "players"]);
		var remove = [];
		for (var i = 0; i < array_length(players); ++i) {
			array_push(remove, players[i][$ "username"]);
		}
		for (var i = 0; i < array_length(players); ++i) {
		    if (players[i][$ "username"] == global.username) { continue; }
			var exists = false;
			var name = players[i][$ "username"];
			with (oSlave) {
				if (!array_contains(remove, username)) {
					instance_destroy();
				}
			    if (username == name) {
				    exists = true;
				}
			}
			if (!exists) {
			    instance_create_depth(0, 0, oPlayer.depth, oSlave, {username : name});
			}
		}		
		break;
	case "LeaveLobby":
		fsm.change("Rooms");
		break;
	case "IsHost":
		ishost = r[$ "isHost"];
		break;
	case "StartGame":
		fsm.change("OnStage");
		break;
}
