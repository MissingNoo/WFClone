package pfs;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.nio.charset.Charset;

import org.json.JSONException;
import org.json.JSONObject;

import javax.sound.midi.SysexMessage;

import static pfs.Server.*;

@SuppressWarnings("unused")
public class User implements Runnable {
    public SocketChannel channel;
    private boolean connected = true;
    public String username = "";
    public String name = "";
    public int playerid;
    public boolean is_host = false;
    public Lobby lobby;
    public String color = "white";
    public int x = 0;
    public int y = 0;
    public int hspd = 0;
    public int vspd = 0;
    public boolean alive = true;

    public User(Server server, SocketChannel channel) {
        this.channel = channel;
    }

    @Override
    public void run() {
        while (connected) {
            ByteBuffer buffer;
            try {
                buffer = ByteBuffer.allocate(1024);
                var read = channel.read(buffer);
                if (buffer.hasArray()) {
                    String data = new String(buffer.array(), Charset.defaultCharset());
                    try {
                        JSONObject json;
                        JSONObject senddata = new JSONObject();
                        try { json = new JSONObject(data); }
                        catch (JSONException err){ json = new JSONObject("{type : null, username : \"-1\", playerid : \"-1\"}"); }
                        if (!json.get("username").toString().equals(username) && !username.isEmpty()) {
                            json.put("type", "Disconnect");
                        }
                        System.out.println(json);
                        switch (json.get("type").toString()) {
                            case "CreateLobby":
                                createLobby(this, json.getString("name"), json.getString("password"));
                                break;
                            case "JoinLobby":
                                joinLobby(this, json.getString("name"), json.getString("password"));
                                break;
                            case "ListLobbies":
                                listLobbies(this);
                                break;
                            case "Disconnect":
                                connected = false;
                                System.out.println(getTimeStamp() + "Player " + username + "/" + channel.socket().getInetAddress().toString() + " has disconnected.");
                                removeClient(this);
                                try {
                                    channel.close();
                                } catch (IOException ex1) {
                                    System.out.println(ex1.getMessage());
                                }
                                break;
                            case "UpdatePlayers":
                                lobby.updatePlayers();
                                break;
                            case "LeaveLobby":
                                lobby.delPlayer(this);
                                senddata.put("type", "LeaveLobby");
                                break;
                            case "SelectCharacter":
                                color = json.getString("color");
                                lobby.updatePlayers();
                                break;
                            case "StartGame":
                                if (is_host) {
                                    lobby.startGame();
                                }
                                break;
                            case "MovePlayer":
                                x = json.getInt("x");
                                y = json.getInt("y");
                                hspd = json.getInt("hspd");
                                vspd = json.getInt("vspd");
                                lobby.updatePosition(this);
                                break;
                            case "SetUsername":
                                //senddata.put("type", "Connect");
                                //senddata.put("id", playerid);
                                username = json.getString("username");
                                name = json.getString("name");
                                break;
                            default:
                                break;
                        }
                        if (!senddata.optString("type").isEmpty()) {
                            System.out.println(getTimeStamp() + "Sending: " + senddata);
                            sendData(this, senddata);
                        }
                    }catch (Exception err){
                        System.out.println(err.getMessage());
                    }
                }
            } catch (IOException ex) {
                System.out.println(getTimeStamp() + channel.socket().getInetAddress().toString() + " has disconnected.");
                connected = false;
                removeClient(this);
                try {
                    channel.close();
                } catch (IOException ex1) {
                    System.out.println(ex1.getMessage()); //ex1.printStackTrace();
                }
            }
        }
    }
}