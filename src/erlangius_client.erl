-module(erlangius_client).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link(State) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, State, []).

send_request(Args) ->
    gen_server:cast(?SERVER, {request, Args}).

%% [{User-Name, Hassan}, {User-password, HassanSecret}, ... ]



%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(State) ->
    {ok, State}.




handle_call(_Request, _From, State) ->
    {reply, ok, State}.



handle_cast(_Msg, State) ->
    {noreply, State}.

handle_cast({request, Args}, State) ->
    Code = 1,
    PacketId = 1,
    Authenticator = get_authenticator(),
    Avps = get_avps(Args),
    Length = byte_size(Avps) + 20,
    Payload = <<Code, PacketId, Length:2/binary, Authenticator:16/binary, Avps>>,
    {Socket, Hosts , Requests } = State,
    [ { {Host, Port} , Secret} | _ ] = Hosts,
    ok = gen_udp:send(Socket, Host, Port, Payload),
    {noreply, {Socket, Hosts, [{request, Args} | Requests]}).

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

get_avps(Args) ->
    get_avps(Args, <<>>).

get_avps([], Acc) ->
    Acc;
get_avps([{Type, Value} | Args], Acc) ->
    Len = byte_size(Value),
    get_avps(Args, <<Acc/binary, Type, Len, Value>>).

    
get_authenticator() ->
    <<"1234567890123456">>.
