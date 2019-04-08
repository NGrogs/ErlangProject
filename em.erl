% Neil Grogan C00205522
% Erlang Project expression manipulator
% Due: 5/4/19

-module(em).
-compile(export_all).

expMal()->
    io:format("Enter an equation to calculate"),
    Input = io:get_line("Input:"),
    io:fwrite("~w",[Input]),
    FTokenize = tokenize(Input),
    io:format("~w\n",[FTokenize]),
    FParser = expression(FTokenize),
    io:format("~w\n",[FParser]),
    FCalc = calc(FParser),
    io:format("~w\n",[FCalc]).

tokenize([]) ->
    [];
tokenize([H|T]) when H=:=$+ ->
    [{binOp,plus} | tokenize(T)];
tokenize([H|T]) when H=:=$- ->
    [{binOp,minus} | tokenize(T)];
tokenize([H|T]) when H=:=$* ->
    [{binOp,multiply} | tokenize(T)];
tokenize([H|T]) when H=:=$/ ->
    [{binOp,divide} | tokenize(T)];
tokenize([H|T]) when H=:=$~ ->
    [{unOp,neg} | tokenize(T)];
tokenize([H|T]) when H=:=$( ->
    [{sym,lbracket} | tokenize(T)];
tokenize([H|T]) when H=:=$) ->
    [{sym,rbracket} | tokenize(T)];
tokenize([H|T]) when (H >= $0) and (H =< $9) ->
    {N,Rem} = getNumber([H|T], 0),
    [{num,N} | tokenize(Rem)];
tokenize([H|T]) ->
    tokenize(T).


getNumber([],NumSafe) ->
    {NumSafe,[]};
getNumber([First|Second], NumSafe) when (First >= $0) and (First =< $9) ->
    NewNumSafe = NumSafe*10+(First-$0),
    getNumber(Second,NewNumSafe);
getNumber([First|Second], NumSafe) ->
    {NumSafe, [First|Second]}.


expression([]) ->[] ;
expression([{sym,rbracket}]) -> [];
expression([{sym,rbracket} | Rest]) ->expression(Rest);
expression([{unOp,neg} | Rest]) ->
	Rtree = expression(Rest),
	{{unOp,neg},Rtree};
expression([{num,X},{sym,rbracket}, H | T]) ->
	Rtree = expression(T),
	{H,{num,X}, Rtree} ;
expression([{num,X},{sym,rbracket}]) -> {num,X};
expression([{num,X},{binOp,Op},{sym,lbracket} | Rest]) ->
	Rtree = expression(Rest),
	{{binOp,Op},{num,X},Rtree};
expression([{sym,lbracket} | Rest]) -> expression(Rest);
expression([{num,X}, {binOp,Op}, {num,Y}, {sym,rbracket}, H|T ]) ->

	if H == {binOp,plus} ->
        Rtree = expression(T),
        {H,{{binOp,Op},{num,X},{num,Y}}, Rtree};

        H == {binOp,minus} ->
            Rtree = expression(T),
            {H,{{binOp,Op},{num,X},{num,Y}}, Rtree};
        
        H == {binOp,divide} ->
            Rtree = expression(T),
            {H,{{binOp,Op},{num,X},{num,Y}}, Rtree};

        H == {binOp,multiply} ->
            Rtree = expression(T),
            {H,{{binOp,Op},{num,X},{num,Y}}, Rtree};
        true->
            {{binOp, Op},{num,X},{num,Y}}

        end;
expression([{num,X},{binOp,Op},{num,Y}, {sym,rbracket}]) -> {{binOp,Op},{num,X},{num,Y}}.

calc({num,X}) ->
    X;
calc({{unOp,neg},Tree}) ->
    Ans = calc(Tree),
    -Ans;
calc({T,Ltree,Rtree}) ->
    if T=={binOp,plus} ->
            Right = calc(Rtree),
            Left = calc(Ltree),
            Res = Left + Right,
            calc({num,Res});
        T=={binOp,minus} ->
            Right = calc(Rtree),
            Left = calc(Ltree),
            Res = Left - Right,
            calc({num,Res});
        T=={binOp,multiply} ->
            Right = calc(Rtree),
            Left = calc(Ltree),
            Res = Left * Right,
            calc({num,Res});
        T=={binOp,divide} ->
            Right = calc(Rtree),
            Left = calc(Ltree),
            Res = Left / Right,
            calc({num,Res});
        true ->
        0
        end.