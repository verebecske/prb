-module(wombat_api).
-export([discover_me/2]).
-define(TIMEOUT,15000).

discover_me(NodeName,Cookie) ->
	TargetCookie = erlang:set_cookie(NodeName,Cookie),
	TargetNode = erlang:node(),
	Target = {wo_discover_dynamic_nodes, NodeName},
	Call = wombat_api,
	%Call = gen_server:call(target, {auto_discover_node, TargetNode, TargetCookie}, ?TIMEOUT),
	io:format("Try: ~n ~p ~n",[Call]),
	no_connection.

%	try Expr of
%		Pattern -> Expr1
%	catch
%		exit:{{nodedown, _}, _} -> no_connection
%    	exit:{noproc, _} -> no_connection
%	after 
%		set_cookie(NodeName,Cookie)
%	end.



