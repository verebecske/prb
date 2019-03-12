-module(automatic_connector).

-behaviour(gen_server).

-export([start_link/0]).
-export([alloc/0, free/1]).
-export([init/1, handle_info/2 ,handle_call/3, handle_cast/2]).

-record(state, {discovery_config}).

start_link() ->
	io:format("Hello automatic_connector start_link ~n"),
    Discovery_config = wombat_discovery_app:load_config(),
    State = #state{discovery_config = Discovery_config},
    gen_server:start_link({local, automatic_connector}, automatic_connector, State,[]).

init(_Args) ->
    io:format("Hello automatic_connector init, my args: ~p ~n",[_Args]),
    self() ! start_discovery,
    {ok, _Args}.

handle_info(start_discovery, {State,no_conig}) ->
    io:format("No Wombat Discovery plugin configuration found. ~n"),
    {noreply,State};

handle_info(start_discovery, State) ->
    case State of
        {state,{MyNode,MyCookie,RetryCount,RetryWait}} -> 
            io:format("Connecting to Wombat node: ~p ~n", [MyNode]),
            do_discover(MyNode, MyCookie, RetryCount, RetryWait);
        Conf -> io:format("invalid config: ~p ~n",[Conf])
    end,
    {noreply,State};

handle_info({try_again,Count}, State) ->
    io:format("Hello automatic_connector try_again"),
    {noreply,State}.

do_discover(Node,Cookie,Count,Wait) ->
    io:format("Trying to connect to ~p ~n", [Node]),
    Reply = wombat_api:discover_me(Node, Cookie),
    %Reply = ok,
    case Reply of
      ok -> io:format("Node successfully added ~n");
      {error, already_added, Msg} -> io:format("Warning: ~p ~nStopping. ~n", [Msg]);
      {error, _Reason, Msg} -> io:format("Error: ~p ~nStopping. ~n", [Msg]);
      no_connection ->
        io:format(
          "Wombat connection failed. Ensure the Wombat cookie is correct. ~nIf the node is already in Wombat, this may be OK. Retrying..."),
        timer:send_after({try_again, Count}, Wait)
    end.

alloc() ->
    gen_server:call(automatic_connector, alloc).

free(Ch) ->
    gen_server:cast(automatic_connector, {free, Ch}).

handle_call(alloc, _From, Chs) ->
    %{Ch, Chs2} = gen_server:alloc(Chs),
    io:format("Hello automatic_connector call"),
    {reply, Chs}.

handle_cast({free, Ch}, Chs) ->
    Chs2 = gen_server:free(Ch, Chs),
    {noreply, Chs2}.