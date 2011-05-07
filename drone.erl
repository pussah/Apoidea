%% @author ??? <???@student.uu.se>
%% @copyright 2011 The Awesome Team
%% @doc The drone of the swarm
%% Equivalent to a tracker in the BitTorrent world.
%% bla bla bla, more info goes here

-module(drone).
-export([start/0, start/1]).
-include_lib("eunit/include/eunit.hrl").

start() -> start(5678).
	
%% @doc Starts a drone
%% Starts the drone on port Port.
start(Port) ->
	io:format("<drone> starting drone~n"),
	network:listen(Port, fun accept_worker/1),
	io:format("<drone> dying~n").
	
	
%% @doc Handles an incoming connection
%% Callback which is called when an incoming connection
%% is made from a worker.
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
	io:format("<drone> received content: ~s~n", [Content]),
	
	io:format("<drone> closing connection to worker~n"),
	network:close(Sock).
