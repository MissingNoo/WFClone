package pfs;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.List;

public class SGui extends JFrame{
    List<User> playerobj = new ArrayList<>();
    JList<String> playerlist;
    DefaultListModel players = new DefaultListModel();



    private JButton button1;
    private JPanel contentPane;
    private JLabel labellobby;

    public SGui() {
        setTitle("VCure-Server");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setContentPane(contentPane);
        pack();
        playerlist.setModel(players);
        button1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent actionEvent) {
                if (playerobj.get(playerlist.getSelectedIndex()).lobby != null) {
                    labellobby.setText(playerobj.get(playerlist.getSelectedIndex()).lobby.name);
                }
            }
        });
    }

    public void addPlayer(User user) {
        playerobj.add(user);
        players.addElement(user.username);
    }
}
