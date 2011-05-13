%% @author Christoffer Brodd-Reijer <christoffer.brodd-reijer.3663@student.uu.se>
%% @copyright 2011 The Awesome Team
%% @doc The worker of the swarm
%% <p>
%% Equivalent to a peer/seeder in the BitTorrent world.
%% bla bla bla, more info goes here
%% </p>

-module(worker).
-export([start_uploader/2, start_downloader/3, init/2, content/0, listen/1]).
-include_lib("eunit/include/eunit.hrl").


content() ->
    Content = 
	[
		{"Filename1", 10, [1, 2, 3]},
		{"Filename2", 2, all},
		{"Filename3", 2, [1]}
	],
    utils:generate_content_string(Content).

%% @doc Starts a worker and listens for requests
%% <p>
%% Dummy function for starting a predefined worker which
%% connects to a hive and then listens for connections.
%% </p>
start_uploader(Key, Sock) -> 
    
    io:format("<uploader> starting~n"),
    network:send(Sock, Key, content()),
    io:format("<uploader> listening for requests~n"),
    listen(Sock).

listen(Sock) ->
    network:listen(6789, fun send_piece/1),
    listen(Sock).

%% @doc Starts a worker and sends a request
%% <p>
%% Dummy function for starting a predefined worker which
%% connects to a hive and then requests a file.
%% </p>
start_downloader(FileName, Key, Sock) ->
	io:format("<downloader> starting~n"),
	io:format("<downloader> sending request for file~n"),
	%{ok, Sock} = network:conn("localhost", 5678),
	network:send(Sock, Key, "request"), %Stuck here...
	io:format("<downloader> listening for piece~n"),
	network:listen(4567, fun accept_piece/1),
	io:format("<downloader> dying~n").


%% @doc Starts a worker
%% <p>
%% Starts a worker, carrying the content Content and
%% connects to the drone on Address:Port.
%% </p>
init(Address, Port) ->
	io:format("<worker> entering hive~n"),
	case network:conn(Address, Port) of
	
		{error, Reason} ->
			io:format("<worker> could not enter hive: ~s~n", [Reason]);
			
		{ok, Sock} ->
			io:format("<worker> connected to drone~n"),
			case network:handshake(Sock) of
			
				{error, Reason} ->
					io:format("<worker> could not handshake with drone: ~s~n", [Reason]);
					
				{Key, Sock} ->
					io:format("<worker> entered hive successfully~n"),
					% TODO: handle errors
					io:format("<worker> sending content list~n"),
					spawn(worker, start_uploader, [Key, Sock]),
					timer:sleep(1000),
					io:format("<worker> closing connection~n"),
					network:close(Sock),
					io:format("<worker> socket: ~w~n", [Sock]),
					Key
			end
	end.
	
	
%% @doc Handles an incoming request
%% <p>
%% Callback which is called when an incoming connection
%% is made from the drone to send a piece.
%% </p>
send_piece(Sock) ->
	io:format("<worker> incoming request from drone~n"),
	
	% TODO: handle errors
	Response = network:recv(Sock, ""),
	io:format("<worker> received request: ~s~n", [Response]),
	
	% sleep in order to let the other worker get ready for us
	timer:sleep(1000),
	
	{ok, SSock} = network:conn("localhost", 4567),
	network:send(SSock, "Key", "AwesomePiece"),
	network:close(SSock),
	
	io:format("<worker> closing connection to drone~n"),
	network:close(Sock),
	eol.
	
%% @doc Handles an incoming piece
%% <p>
%% Callback which is called when an incoming connection
%% is made from another worker which is about to send a piece.
%% </p>
accept_piece(Sock) ->
	io:format("<worker> incoming piece from worker~n"),
	
	% TODO: handle errors
	Response = network:recv(Sock, ""),
	io:format("<worker> received piece: ~s~n", [Response]),
	
	io:format("<worker> closing connection to worker~n"),
	network:close(Sock),
	eol.
