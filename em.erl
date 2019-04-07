-module(em).
-compile(export_all).

getEqu()->
    io:format("Enter an equation"),
    Input = io:get_line("Input:"),
    io:fwrite("~w", [Input]),
    FTokenize = tokenize(Input),
    io:format("~w\n", [FTokenize]).

tokenize([]) ->
    [];
tokenize([H|T]) when H=:=$+ ->
    [{binOp, plus} | tokenize(T)];
tokenize([H|T]) when H=:=$- ->
    [{binOp, minus} | tokenize(T)];
tokenize([H|T]) when H=:=$* ->
    [{binOp, multiply} | tokenize(T)];
tokenize([H|T]) when H=:=$/ ->
    [{binOp, divide} | tokenize(T)];
tokenize([H|T]) when H=:=$~ ->
    [{unOp, neg} | tokenize(T)];
tokenize([H|T]) when H=:=$( ->
    [{sym, lbracket} | tokenize(T)];
tokenize([H|T]) when H=:=$) ->
    [{sym, rbracket} | tokenize(T)];
tokenize([H|T]) when (H >= $0) and (H =< $9) ->
    {N, Rem} = getNumber([H|T], 0),
    [{num, N} | tokenize(Rem)];
tokenize([H|T]) ->
    tokenize(T).

getNumber([], NumSafe) ->
    {NumSafe, []};
getNumber([First|Second], NumSafe) when (First >= $0) and (First =< $9) ->
    NewNumSafe = NumSafe*10+(First-$0),
    getNumber(Second, NewNumSafe);
getNumber([First|Second], NumSafe) ->
    {NumSafe, [First|Second]}.