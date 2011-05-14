-module(storage).
-export([start/0, table/0, add_file/2, find_file/2, add_crap/0]).
-include_lib("eunit/include/eunit.hrl").



table() ->
	ets:new('FileList', [bag]).

add_file(FileMap, {IP, Port, Name, Peices, Possessions}) ->
	ets:insert(FileMap, {Name, IP, Port, Peices, Possessions}).

find_file(FileMap, FileName) ->
	ets:lookup(FileMap, FileName).

all(FileMap) ->
	ets:match(FileMap, {'$1', '$2', '$3', '$4', '$5'}).

add_crap() ->
	FileMap = table(),
	add_file(FileMap, {"localhost", 80, "Testfile", 10, all}),
	add_file(FileMap, {"192.168.0.1", 1234, "WoW.exe", 100, [1,2,3,4,5,6, 95]}),
	add_file(FileMap, {"192.168.0.2", 1235, "Porn.exe", 2, [1]}),
	add_file(FileMap, {"192.168.0.3", 1236, "NotAVirus.bat", 5, [1,2,3,4]}),
	add_file(FileMap, {"192.168.0.1", 1234, "Wc3.exe", 50, all}),
	add_file(FileMap, {"192.168.0.4", 5432, "Testfile", 10, all}),
	X = find_file(FileMap, "Testfile"),
	io:format("~n-Testfile- found at: ~p ~n", [X]),
	Y = all(FileMap),
	io:format("~n-The entire FileMap: ~p ~n", [Y]).
