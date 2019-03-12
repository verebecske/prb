%%%-------------------------------------------------------------------
%% @doc wombat_discovery public API
%% @end
%%%-------------------------------------------------------------------

-module(wombat_discovery_app).
-copyright("2019, Erlang Solutions Ltd.").
-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, load_config/0]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
	io:format("Hello wombat_discovery_app start ~n"),
    wombat_discovery_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

load_config() ->
	io:format("Hello wombat_discovery_app load_config ~n"),

	Sys_nodename = os:getenv("WOMBAT_NODENAME"),
	Sys_cookie = os:getenv("WOMBAT_COOKIE"),

	{ok, App_nodename} = application:get_env(wombat_discovery,wombat_nodename), 
	App_cookie = application:get_env(wombat_discovery,wombat_cookie, wombat), 

	Retry_count = application:get_env(wombat_discovery,retry_count, 20),
	Retry_wait = application:get_env(wombat_discovery,retry_wait, 30000),

%	case [{sys_nodename, sys_cookie}, {app_nodename, app_cookie}] of
%		[{nil, nil}, {nil, _}] -> no_config;
%		[{sys_nodename, sys_cookie}, _] when sys_nodename /= nil -> 
%			sys_not_nil_cookie =
%			case sys_cookie do
%			nil -> :wombat
%			_ -> String.to_atom(sys_cookie)
%			end
%	io:format("Hello wombat_discovery_app load_config end"),

	no_config.