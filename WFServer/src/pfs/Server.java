package pfs;
import org.json.JSONObject;

import java.io.IOException;
import java.io.*;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Server {
    public static List<User> clients;
    public static List<Lobby> lobbies;
    private int lastid = 0;

    public Server(int port) {
        Server.clients = new ArrayList<>();
        Server.lobbies = new ArrayList<>();
        boolean running = false;

        System.out.print(getTimeStamp() + "[Server] Trying to Listen on Port : " + port + "...");
        ServerSocketChannel socket;
        try {
            ServerSocketChannel channel = ServerSocketChannel.open();
            channel.socket().bind(new java.net.InetSocketAddress(port));
            System.out.println("Success!");
            channel.configureBlocking(false);
            socket = channel;
            running = true;
        } catch (IOException e) {
            System.err.println("Failed!");
            socket = null;
        }

        // Server loop
        //noinspection LoopConditionNotUpdatedInsideLoop
        while (running) try {
            // Sleep the thread
            Thread.sleep(1);
            // Check for new connections
            SocketChannel newChannel = socket.accept();
            // If a connection is found, create a User and add it to
            // the client list
            if (newChannel != null) {
                System.out.println(getTimeStamp() + "New Connection " + newChannel.socket().getInetAddress().toString());
                User c = new User(this, newChannel);
                //c.playerid = lastid;
                //lastid++;
                Thread t = new Thread(c);
                t.start();
                clients.add(c);
            }
        } catch (InterruptedException | IOException e) {
            System.out.println(e.getMessage());
        }
    }

    public static void removeClient(User user) {
        if (user.lobby != null) user.lobby.delPlayer(user);
        clients.remove(user);
    }

    public static void sendData(User user, JSONObject json){
        try {
            String data = json.toString() + ";";
            OutputStream out = user.channel.socket().getOutputStream();
            BufferedOutputStream bout = new BufferedOutputStream(out);
            byte[] buf = data.getBytes();
            bout.flush();
            bout.write(buf);
            bout.flush();
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }

    public static void createLobby(User owner, String name, String password) {
        Lobby l = new Lobby(name, password);
        l.addPlayer(owner);
        lobbies.add(l);
    }

    public static void delLobby(Lobby lobby) {
        lobbies.remove(lobby);
    }

    public static void joinLobby(User user, String name, String password) {
        for (Lobby lobby : lobbies) {
            if (lobby.name.equals(name) && lobby.password.equals(password)) {
                user.lobby = lobby;
                lobby.addPlayer(user);
                break;
            }
        }
    }

    public static void listLobbies(User user) {
        List<String> lobbyList = new ArrayList<>();
        for (Lobby lobby : lobbies) {
            JSONObject lobbyinfo = new JSONObject();
            lobbyinfo.put("name", lobby.name);
            lobbyinfo.put("protected", !lobby.password.isEmpty());
            lobbyinfo.put("totalplayers", lobby.players.size());
            lobbyList.add(lobbyinfo.toString());
        }
        JSONObject data = new JSONObject();
        data.put("type", "ListLobbies");
        data.put("lobbies", lobbyList.toString());
        sendData(user, data);
    }

    public static String getTimeStamp(){
        int hour = LocalDateTime.now().getHour();
        int minute = LocalDateTime.now().getMinute();
        int second = LocalDateTime.now().getSecond();
        String hourstring = String.valueOf(hour);
        if (hour < 9) {
            hourstring = "0" + hour;
        }
        String minutestring = String.valueOf(minute);
        if (minute < 9) {
            minutestring = "0" + minute;
        }
        String secondstring = String.valueOf(second);
        if (second < 9) {
            secondstring = "0" + second;
        }
        return "[" + hourstring + ":" + minutestring + ":" + secondstring + "] ";
    }

    public static void main(String... args) {
        //noinspection InstantiationOfUtilityClass

        new Server(21321);
    }

}