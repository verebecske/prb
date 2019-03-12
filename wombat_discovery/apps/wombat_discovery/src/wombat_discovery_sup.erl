%%%-------------------------------------------------------------------
%% @doc wombat_discovery top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(wombat_discovery_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
	io:format("Hello wombat_discovery_sup start_link ~n"),
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
%init([]) ->
%    {ok, { {one_for_one, 0, 1}, []} }.

%init(_Args) ->
%    SupFlags = {one_for_one, 0, 1},
%    ChildSpecs = [{automatic_connector,
%                  ,
%                   permanent, brutal_kill, worker,
%                   [wombat_discovery]}],
%	ChildSpecs = [{id, automatic_connector},
%                  {mfargs,{automatic_connector,start_link,[]}},
%                  {restart_type,permanent},
%                  {shutdown,2000},
%                  {child_type,worker}],
%	ChildSpecs = %[{automatic_connector, {automatic_connector, start_link, []}, permanent, 5000, worker,[automatic_connector]}],
%	 #{id => automatic_connector,
%      start => {gen_server, start_link, [ automatic_connector]},
%      restart => permanent,
%      modules => [automatic_connector]},
%    {ok, {SupFlags, []}}.   

%%====================================================================
%% Internal functions
%%====================================================================

init([]) ->
	io:format("Hello wombat_discovery_sup init ~n"),
    {ok, {{one_for_one, 5, 10},
          [
          child(automatic_connector, start_link, [])
          ]}}.

%%%=============================================================================
%%% Internal functions
%%%=============================================================================

-spec child(Mod :: module(),
            Fun :: atom(),
            Args :: [term()]) -> supervisor:child_spec().
child(Mod, Fun, Args) ->
    {Mod, {Mod, Fun, Args}, permanent, 5000, worker, [Mod]}.
