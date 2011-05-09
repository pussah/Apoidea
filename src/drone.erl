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
	
	% TODO: handle errors
	Greeting = network:recv(Sock, ""),
	io:format("<drone> received greeting: ~s~n", [Greeting]),
	
	case Greeting of
	
		 % handshake
		"init" ->
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
			io:format("<drone> receiving content~n"),
			case network:recv(Sock, "") of
				{error, Reason} -> io:format("<drone> no content~n");
				Content ->
					parse_contents(utils:generate_content_list(Content)),
					io:format("<drone> closing connection to worker~n"),
					network:close(Sock)
			end;
			
		% file request
		"request" ->
			io:format("<drone> received request for piece~n"),
			
			{ok, SSock} = network:conn("localhost", 6789),
			network:send(SSock, "Key", "send file"),
			network:close(SSock),
	
			io:format("<drone> closing connection to worker~n"),
			network:close(Sock)
			
		end,
	ok.
			
	
%% @doc TODO
%% <p>
%% TODO
%% </p>
parse_contents([]) -> io:format("<drone> content: end~n");
parse_contents([H|T]) ->
	save_file(H),
	parse_contents(T).
	
%% @doc TODO
%% <p>
%% TODO
%% </p>
save_file({Name, Pieces, Possessions}) -> 
	io:format("<drone> file: ~s (~w pieces, possessions: ~w)~n", [Name, Pieces, Possessions]).
