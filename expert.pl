:- op(900, xfx, ::).
:- op(801, xfx, 'with certainty').
:- op(800, xfx, was).
:- op(870, fx, if).
:- op(880, xfx, then).
:- op(550, xfy, or).
:- op(540, xfy, and).
:- op(300, fx, 'derived by').
:- op(600, xfx, from).
:- op(600, xfx, by).

:- op(700, xfx, is).
:- op(900, fx, not).

:- style_check(-singleton).

explore(Goal, Trace, Goal is true was 'found as a fact' 'with certainty' Cert, Cert) :-
    fact :: Goal : Cert.

explore(Goal, Trace, Goal is TruthValue 'with certainty' Cert was 'derived by' Rule from Answer, Cert) :-
    Rule :: if Condition then Goal : Cert1,
    \+ member(Goal by Rule, Trace),
    explore(Condition, [Goal by Rule | Trace], Answer, Cert2),
    truth(Answer, TruthValue),
    Cert is Cert1 * Cert2.

explore(Goal1 and Goal2, Trace, Answer1 and Answer2, Cert) :-
    !,
    explore(Goal1, Trace, Answer1, Cert1),
    explore(Goal2, Trace, Answer2, Cert2),
    Cert is min(Cert1, Cert2).

explore(Goal1 or Goal2, Trace, Answer1 and Answer2, Cert) :-
    explore(Goal1, Trace, Answer1, Cert1),
    explore(Goal2, Trace, Answer2, Cert2),
    Cert is max(Cert1, Cert2).

explore(Goal, Trace, Goal is Answer 'with certainty' Cert was told, Cert) :-
    useranswer(Goal, Trace, Answer, Cert).

truth(Question is TruthValue 'with certainty' Cert was Found, TruthValue) :-
    !.

truth(Question is TruthValue was Found 'with certainty' Cert, TruthValue) :-
    !.

truth(Question is TruthValue was Found, TruthValue) :-
    !.

truth(Answer1 and Answer2, TruthValue) :-
    truth(Answer1, true),
    truth(Answer2, true),
    !,
    TruthValue = true
    ;
    TruthValue = false.

positive(Answer) :-
    truth(Answer, true).

negative(Answer) :-
    truth(Answer, false).

getreply(Reply) :-
    read(Answer),
    means(Answer, Reply),
    !
    ;
    nl,
    write('Answer unknown, try again.'),
    nl,
    getreply(Reply).

means(yes, yes).
means(y, yes).
means(no, no).
means(n, no).
means(why, why).
means(w, why).

useranswer(Goal, Trace, Answer, Cert) :-
    askable(Goal, _),
    freshcopy(Goal, Copy),
    useranswer(Goal, Copy, Trace, Answer, Cert, 1).

useranswer(Goal, _, _, _, _, N) :-
    N > 1,
    instantiated(Goal),
    !,
    fail.

useranswer(Goal, Copy, _, Answer, Cert, _) :-
    wastold(Copy, Answer, Cert, _),
    instance_of(Copy, Goal),
    !.

useranswer(Goal, _, _, true, Cert, N) :-
    wastold(Goal, true, Cert, M),
    M >= N.

useranswer(Goal, Copy, _, Answer, Cert, _) :-
    end_answers(Copy),
    instance_of(Copy, Goal),
    !,
    fail.

useranswer(Goal, _, Trace, Answer, Cert, N) :-
    askuser(Goal, Trace, Answer, Cert, N).

askuser(Goal, Trace, Answer, Cert, N) :-
    askable(Goal, ExternFormat),
    format(Goal, ExternFormat, Question, [], Variables),
    ask(Goal, Question, Variables, Trace, Answer, Cert, N).

ask(Goal, Question, Variables, Trace, Answer, Cert, N) :-
    nl,
    (
        Variables = [],
        !,
        write('')
        ;
        write('Any (more) solution to: ')
    ),
    write(Question),
    write(' is true with certainty = '),
    read(Cert),
    !,
    process(Cert, Goal, Question, Variables, Trace, Answer, N).

process(why, Goal, Question, Variables, Trace, Answer, N) :-
    showtrace(Trace),
    ask(Goal, Question, Variables, Trace, Answer, Cert, N).

process(Cert, Goal, Question, Variables, Trace, Answer, N) :-
    nextindex(Next),
    Next1 is Next + 1,
    (
        askvars(Variables),
        assertz(wastold(Goal, true, Cert, Next))
        ;
        freshcopy(Goal, Copy),
        useranswer(Goal, Copy, Trace, Answer, Cert, Next1)
    ).

format(Var, Name, Name, Vars, [Var/Name | Vars]) :-
    var(Var),
    !.

format(Atom, Name, Atom, Vars, Vars) :-
    atomic(Atom),
    !,
    atomic(Name).

format(Goal, Form, Question, Vars0, Vars) :-
    Goal =..[Functor | Args1],
    Form =..[Functor | Forms],
    formatall(Args1, Forms, Args2, Vars0, Vars),
    Question =..[Functor | Args2].

formatall([], [], [], Vars, Vars).

formatall([X | XL], [F | FL], [Q | QL], Vars0, Vars) :-
    formatall(XL, FL, QL, Vars0, Vars1),
    format(X, F, Q, Vars1, Vars).

askvars([]).

askvars([Variable/Name | Variables]) :-
    nl,
    write(Name),
    write(' = '),
    read(Variable),
    askvars(Variables).

showtrace([]) :-
    nl,
    write('This was your question'),
    nl.

showtrace([Goal by Rule | Trace]) :-
    nl,
    write('To investigate, by '),
    write(Rule),
    write(', '),
    write(Goal),
    showtrace(Trace).

instantiated(Term) :-
    numbervars(Term, 0, 0).

instance_of(Term, Term1) :-
    freshcopy(Term1, Term2),
    numbervars(Term2, 0, _),
    !,
    Term = Term2.

freshcopy(Term, FreshTerm) :-
    asserta(copy(Term)),
    retract(copy(FreshTerm)),
    !.

nextindex(Next) :-
    retract(lastindex(Last)),
    !,
    Next is Last + 1,
    assert(lastindex(Next)).

:-  assertz(lastindex(0)),
    assertz(wastold(dummy, false, 0, 0)),
    assertz(end_answers(dummy)).

present(Answer, Cert) :-
    nl,
    showconclusion(Answer),
    write(' with certainty = '),
    write(Cert),
    nl,
    write('Would you like to see how? '),
    getreply(Reply),
    (
        Reply = yes,
        !,
        show(Answer)
        ;
        true
    ).

showconclusion(Answer1 and Answer2) :-
    !,
    showconclusion(Answer1),
    write('and '),
    showconclusion(Answer2).

showconclusion(Conclusion 'with certainty' Cert was Found) :-
    write(Conclusion).

showconclusion(Conclusion was Found 'with certainty' Cert) :-
    write(Conclusion).

showconclusion(Conclusion was Found) :-
    write(Conclusion).

show(Solution) :-
    nl,
    show(Solution, 0),
    !.

show(Answer1 and Answer2, H) :-
    !,
    show(Answer1, H),
    tab(H),
    write('and '),
    nl,
    show(Answer2, H).

show(Answer 'with certainty' Cert was Found, H) :-
    tab(H),
    writeans(Answer),
    write(' with certainty = '),
    write(Cert),
    nl,
    tab(H + 2),
    write('was '),
    show1(Found, H).

show(Answer was Found 'with certainty' Cert, H) :-
    tab(H),
    writeans(Answer),
    write(' with certainty = '),
    write(Cert),
    nl,
    tab(H + 2),
    write('was '),
    show1(Found, H).

show(Answer was Found, H) :-
    tab(H),
    writeans(Answer),
    nl,
    tab(H + 2),
    write('was '),
    show1(Found, H).

show1(Derived from Answer, H) :-
    !,
    write(Derived),
    write(' from '),
    nl,
    H1 is H + 4,
    show(Answer, H1).

show1(Found, _) :-
    write(Found),
    nl.

writeans(Goal is true) :-
    !,
    write(Goal).

writeans(Answer) :-
    write(Answer).

expert :-
    getquestion(Question),
    (
        answeryes(Question)
        ;
        answerno(Question)
    ).

answeryes(Question) :-
    markstatus(negative),
    explore(Question, [], Answer, Cert),
    positive(Answer),
    markstatus(positive),
    present(Answer, Cert),
    nl,
    write('More solutions? '),
    getreply(Reply),
    Reply = no.

answerno(Question) :-
    retract(no_positive_answer_yet),
    !,
    explore(Question, [], Answer, Cert),
    negative(Answer),
    present(Answer, Cert),
    nl,
    write('More negative solutions? '),
    getreply(Reply),
    Reply = no.

markstatus(negative) :-
    assert(no_positive_answer_yet).

markstatus(positive) :-
    retract(no_positive_answer_yet),
    !
    ;
    true.

getquestion(Question) :-
    nl,
    write('Question, please:'),
    nl,
    read(Question).

fact :-
    getFact(Fact, Cert),
    Format =.. [fact :: Fact : Cert],
    assertz(Format).

getFact(Fact, Cert) :-
    nl,
    write('Add fact: '),
    read(Fact),
    write('Certainty = '),
    read(Cert).

rule :-
    getRule(Rule, Cert),
    Format =.. [rule :: Rule : Cert],
    assertz(Format).

getRule(Rule, Cert) :-
    nl,
    write('Add rule: '),
    read(Rule),
    write('Certainty = '),
    read(Cert).
