%% @author Christoffer Brodd-Reijer <christoffer.brodd-reijer.3663@student.uu.se>
%% @copyright 2011 The Awesome Team
%% @doc The worker of the swarm
%% <p>
%% Equivalent to a peer/seeder in the BitTorrent world.
%% bla bla bla, more info goes here
%% </p>

-module(worker).
-export([start/0, start/3]).
-include_lib("eunit/include/eunit.hrl").

	
%% @doc Starts a worker
%% <p>
%% Dummy function for starting a predefined worker.
%% </p>
start() -> 
	% TODO: how do we represent content?
	% Should be a list of files the worker has and the number 
	% of pieces the worker possesses.
	Content = 
	[
		{"Filename1", 10, [1, 2, 3]},
		{"Filename2", 2, all},
		{"Filename3", 2, [1]}
	],
	start("localhost", 5678, utils:generate_content_string(Content)).

	
%% @doc Starts a worker
%% <p>
%% Starts a worker, carrying the content Content and
%% connects to the drone on Address:Port.
%% </p>
start(Address, Port, Content) ->
	io:format("<worker> entering hive~n"),
	case network:conn(Address, Port) of
		{error, Reason} ->
			io:format("<worker> could not enter hive: ~s~n", [Reason]);
		{Key, Sock} ->
			io:format("<worker> entered hive successfully~n"),
			% TODO: handle errors
			network:send(Sock, Key, Content),
			io:format("<worker> dying~n"),
			network:close(Sock)
	end.
