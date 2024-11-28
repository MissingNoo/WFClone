package pfs;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static pfs.Server.*;

public class Lobby {
    public List<User> players = new ArrayList<>();
    public String name;
    public String password;
    public boolean game_started = false;

    public Lobby(String name, String password) {
        System.out.println(getTimeStamp() + "New Lobby: " + name);
        this.name = name;
        this.password = password;
    }

    public void addPlayer(User user) {
        if (!players.contains(user)) {
            System.out.println(getTimeStamp() + user.username + " joined " + name);
            user.is_host = players.isEmpty();
            players.add(user);
            user.lobby = this;
            JSONObject senddata = new JSONObject();
            senddata.put("type", "JoinLobby");
            sendData(user, senddata);
            updatePlayers();
        }
    }

    public void delPlayer(User user) {
        System.out.println(getTimeStamp() + user.username + " left " + name);
        user.lobby = null;
        players.remove(user);
        if(user.is_host && !players.isEmpty()) players.getFirst().is_host = true;
        updatePlayers();
        if (players.isEmpty()) {
            System.out.println(getTimeStamp() + "Removing lobby " + name + " as it is empty");
            delLobby(this);
        }
    }

    public void updatePlayers(){
        JSONObject senddata = new JSONObject();
        String[] playerdata = {"{}", "{}", "{}", "{}"};
        try {
            for (int i = 0; i < players.size(); i++) {
                JSONObject current_player = new JSONObject();
                current_player.put("username", players.get(i).name);
                current_player.put("Fishing", players.get(i).Fishing);
                current_player.put("FishDistance", players.get(i).FishDistance);
                //current_player.put("username", players.get(i).username);
                //current_player.put("id", players.get(i).playerid);
                current_player.put("color", players.get(i).color);
                current_player.put("host", players.get(i).is_host);
                playerdata[i] = current_player.toString();
            }

            for (User player : players) {
                senddata.put("type", "UpdatePlayers");
                senddata.put("players", Arrays.toString(playerdata));
                JSONObject hostplayer = new JSONObject();
                hostplayer.put("type", "IsHost");
                hostplayer.put("isHost", player.is_host);
                sendData(player, senddata);
                sendData(player, hostplayer);
            }
        } catch (JSONException e) {
            System.out.println(e.getMessage());
        }
    }

    public void updatePosition(User user) {
        JSONObject data = new JSONObject();
        data.put("type", "MovePlayer");
        //data.put("username", user.username);
        data.put("username", user.name);
        data.put("x", user.x);
        data.put("y", user.y);
        data.put("vspd", user.vspd);
        data.put("hspd", user.hspd);
        for (User player : players) {
            if (player == user) continue;
            sendData(player, data);
        }
    }

    public void startGame() {
        System.out.println("Lobby " + name + " is starting");
        game_started = true;
        for (User player : players) {
            JSONObject senddata = new JSONObject();
            senddata.put("type", "StartGame");
            sendData(player, senddata);
        }
    }
}
