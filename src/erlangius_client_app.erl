-module(erlangius_client_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).




-define(PORT, 2372).
%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    %% GET SHAREDKEY:HOST ARRAY FROM CONFIG
    {ok, Socket} = gen_udp:open(?PORT),
    Hosts = [],
    erlangius_client:start_link({Socket, Hosts, []}),
    erlangius_client_sup:start_link().

stop(_State) ->
    ok.
