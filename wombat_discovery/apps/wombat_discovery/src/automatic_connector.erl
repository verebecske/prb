-module(automatic_connector).

-behaviour(gen_server).

-export([start_link/0]).
-export([alloc/0, free/1]).
-export([init/1, handle_call/3, handle_cast/2]).

start_link() ->
	io:format("Hello automatic_connector start_link ~n"),
    gen_server:start_link({local, automatic_connector}, automatic_connector, [],[]).

alloc() ->
    gen_server:call(automatic_connector, alloc).

free(Ch) ->
    gen_server:cast(automatic_connector, {free, Ch}).

init(_Args) ->
	io:format("Hello automatic_connector init ~n"),
    {ok, gen_server:channels()}.

handle_call(alloc, _From, Chs) ->
    {Ch, Chs2} = gen_server:alloc(Chs),
    {reply, Ch, Chs2}.

handle_cast({free, Ch}, Chs) ->
    Chs2 = gen_server:free(Ch, Chs),
    {noreply, Chs2}.