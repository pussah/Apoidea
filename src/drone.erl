%% @author ??? <???@student.uu.se>
%% @copyright 2011 The Awesome Team
%% @doc The drone of the swarm
%% <p>
%% Equivalent to a tracker in the BitTorrent world.
%% bla bla bla, more info goes here
%% </p>

-module(drone).
-export([start/0, start/1]).
-include_lib("eunit/include/eunit.hrl").

%% @doc Starts a drone
%% <p>
%% Dummy function for starting a predefined drone.
%% </p>
start() -> start(5678).
	
%% @doc Starts a drone
%% <p>
%% Starts the drone on port Port.
%% </p>
start(Port) ->
	io:format("<drone> starting drone~n"),
	network:listen(Port, fun accept_worker/1),
	io:format("<drone> dying~n").
	
	
%% @doc Handles an incoming connection
%% <p>
%% Callback which is called when an incoming connection
%% is made from a worker.
%% </p>
accept_worker(Sock) ->
	io:format("<drone> worker connected~n"),

	io:format("<drone> sending challenge~n"),
	% TODO: handle errors
	network:send(Sock, "", "knock knock"),
	
	% TODO: handle errors
	Response = network:recv(Sock, ""),
	io:format("<drone> received response: ~s~n", [Response]),
		
	io:format("<drone> ending handshake~n"),
	% TODO: handle errors
	network:send(Sock, "", "eol"),
		
	% TODO: handle errors
	Content = network:recv(Sock, ""),
	parse_contents(utils:generate_content_list(Content)),
	
	io:format("<drone> closing connection to worker~n"),
	network:close(Sock).
	
%% @doc TODO
%% <p>
%% TODO
%% </p>
parse_contents([]) -> io:format("<drone> content: end~n");
parse_contents([H|T]) ->
	io:format("<drone> content: ~s~n", [parse_content(H)]),
	parse_contents(T).
	
%% @doc TODO
%% <p>
%% TODO
%% </p>
parse_content({Name, Pieces, Possessions}) -> 
	io_lib:format("File: ~s (~w pieces, possessions: ~w)", [Name, Pieces, Possessions]).
