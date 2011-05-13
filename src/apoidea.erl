-module(apoidea).
-export([start/0]).

start() -> 
    io:format("=========== Welcome to Apoidea ===========\nFor a list of available commands, type 'help'"),
    start1("", "").

start1(Key, Sock) ->
    UserCommand = io:get_line("\nApoidea> "),
    case UserCommand of
	"/help\n" -> io:format("Commands:\n/init - Initiates a connection.\n/download - Download a file.\n/back - Return to previous menu.\n/quit - Quit Apoidea.\n");
	"/init\n" -> io:format("\nInitialize\n\nEnter the IP-adress of the drone you want to connect to: "),
		     IPadress = io:get_line("\nApoidea> "),
		     IP_adress = string:substr(IPadress, 1, length(IPadress) - 1),
		     case IP_adress of
			 "/back" -> start1(Key, Sock);
			 "/quit" -> init:stop();
			 Other -> {Key_1, Sock_1} = worker:init(IP_adress, 5678), start1(Key_1, Sock_1)
		     end;
	"/download\n" -> io:format("\nDownload\n\nEnter the name of the file you wish to download: "),
			 FileName = io:get_line("\nApoidea> "),
			 FileName_1 = string:substr(FileName, 1, length(FileName) - 1),
			 case FileName of
			     "/back\n" -> start1(Key, Sock);
			     "/quit\n" -> init:stop();
			     Other -> worker:start_downloader(FileName_1, Key, Sock)
			 end,
			 start1(Key, Sock);
	"/quit\n" -> init:stop();
	"/back\n" -> start1(Key, Sock);
	Other -> io:format("Invalid choise.\n")
    end,
    start1(Key, Sock).