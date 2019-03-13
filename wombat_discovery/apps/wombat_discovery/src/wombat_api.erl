-module(wombat_api).

-export([discover_me/2]).
-define(TIMEOUT,15000).

discover_me(NodeName,Cookie) ->
	erlang:set_cookie(NodeName,Cookie),
	TargetCookie = erlang:get_cookie(),
	TargetNode = erlang:node(),
	%Target = {wo_discover_dynamic_nodes, NodeName},
	Target = {tas, 'tas@127.0.0.1'},
	Request = {auto_discover_node, TargetNode, TargetCookie},
	
	io:format("Ping? ~p ~n", [net_adm:ping('tas@127.0.0.1')]),

	try gen_server:call(Target, Request, ?TIMEOUT) of
		Ans -> io:format("Hello api try ~p ~n",[Ans]), Ans
	catch
		exit:Msg -> io:format("Hello api catch ~p ~n",[Msg]), no_connection;
		exit:{{nodedown, _}, _} -> no_connection;
    	exit:{noproc, _} -> no_connection
	after 
		erlang:set_cookie(NodeName,TargetCookie)
	end.



