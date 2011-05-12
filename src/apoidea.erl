-module(apoidea).
-export([start/0]).

start() -> 
    io:format("=========== Welcome to Apoidea ===========\nFor a list of available commands, type 'help'"),
    start1().

start1() ->
    UserCommand = io:get_line("\nApoidea> "),
    case UserCommand of
	"/help\n" -> io:format("Commands:\n/init - Initiates a connection.\n/download - Download a file.\n/back - Return to previous menu.\n/quit - Quit Apoidea.\n");
	"/init\n" -> io:format("\nInitialize\n\nEnter the IP-adress of the drone you want to connect to: "),
		     IPadress = io:get_line("\nApoidea> "),
		     IP_adress = string:substr(IPadress, 1, length(IPadress) - 1),
		     case IP_adress of
			 "/back" -> start1();
			 "/quit" -> init:stop();
			 Other -> {Key, Sock} = worker:init(IP_adress, 5678)
		     end,
		     start1();
	"/download\n" -> io:format("\nDownload\n\nEnter the name of the file you wish to download: "),
			 FileName = io:get_line("\nApoidea> "),
			 case FileName of
			     "/back\n" -> start1();
			     "/quit\n" -> init:stop();
			     Other -> worker:start_downloader(FileName, "", "")
			 end,
			 start1();
	"/quit\n" -> init:stop();
	"/back\n" -> start1();
	Other -> io:format("Invalid choise.\n")
    end,
    start1().