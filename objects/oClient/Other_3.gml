ini_open("settings");
ini_write_string("Settings", "Username", global.username);
ini_write_string("Settings", "Password", global.password);
ini_close();
sendMessageNew("Disconnect");