-module(apoidea).
-export([start/0]).
-define(DRONEPORT, 5678).

start() ->
    io:format("=========== Welcome to Apoidea ===========\nFor a list of available commands, type 'help'"),
    start1("", "", "").

start1(Key, IP, ClientListenSock) ->
    UserCommand = io:get_line("\nApoidea> "),
    case UserCommand of
		"/help\n" -> io:format("Commands:\n/init - Initiates a connection.\n/download - Download a file.\n/back - Return to previous menu.\n/quit - Quit Apoidea.\n");

	"/init\n" -> io:format("\nInitialize\n\nEnter the IP-adress of the drone you want to connect to: "),

	IPadress = io:get_line("\nApoidea> "),
	IP_adress = string:substr(IPadress, 1, length(IPadress) - 1),
	case IP_adress of
		"/back" -> start1(Key, IP, ClientListenSock);
		"/quit" -> init:stop();
		Other -> 
			CLS = network:listenInit(4567),
			Key_1 = worker:init(IP_adress, ?DRONEPORT), 
			start1(Key_1, IP_adress, CLS)
	end;

	"/download\n" -> io:format("\nDownload\n\nEnter the name of the file you wish to download: "),
	FileName1 = io:get_line("\nApoidea> "),
	FileName = string:substr(FileName1, 1, length(FileName1) -1),
	%io:format("Apoidea> socket: ~w~n", [IP]),
	case FileName of
		"/back\n" -> start1(Key, IP, ClientListenSock);
		"/quit\n" -> init:stop();
		Other ->
			{ok , SSock} = network:conn(IP, ?DRONEPORT),
			worker:start_downloader(FileName, Key, SSock, ClientListenSock)
		end,
		start1(Key, IP, ClientListenSock);
		"/quit\n" -> init:stop();
		"/back\n" -> start1(Key, IP, ClientListenSock);
		Other -> io:format("Invalid choise.\n")
    end,
	start1(Key, IP, ClientListenSock).
