:- op(100, xfx, [has, 'does not', isa, can]).

:- dynamic (::)/2.

rule1 :: if
            Pokemon can 'use leech seed'
            or
            Pokemon can 'use razor leaf'
        then
            Pokemon isa grass_type : 0.9.

rule2 :: if
            Pokemon can 'use ember'
            or
            Pokemon can 'use flamethrower'
        then
            Pokemon isa fire_type : 0.9.

rule3 :: if
            Pokemon can 'use water gun'
            or
            Pokemon can 'use hydro pump'
        then
            Pokemon isa water_type : 0.9.

rule4 :: if
            Pokemon can 'use thunderbolt'
            or
            Pokemon can 'use thunder shock'
        then
            Pokemon isa electric_type : 0.9.

rule5 :: if
            Pokemon isa grass_type and
            Pokemon isa 'starter pokemon'
        then
            Pokemon isa bulbasaur : 0.8.

rule6 :: if
            Pokemon isa fire_type and
            Pokemon isa 'starter pokemon'
        then
            Pokemon isa charmander : 0.8.

rule7 :: if
            Pokemon isa water_type and
            Pokemon isa 'starter pokemon'
        then
            Pokemon isa squirtle : 0.8.

rule8 :: if
            Pokemon isa grass_type and
            Pokemon can 'use frenzy plant'
        then
            Pokemon isa venusaur : 0.95.

rule9 :: if
            Pokemon isa fire_type and
            Pokemon can 'use blast burn'
        then
            Pokemon isa charizard : 0.95.

rule10 :: if
            Pokemon isa water_type and
            Pokemon can 'use hydro cannon'
        then
            Pokemon isa blastoise : 0.95.

rule11 :: if
            Pokemon isa electric_type and
            Pokemon can 'say pika-pika'
        then
            Pokemon isa pikachu : 0.8.

rule12 :: if
            Pokemon isa grass_type
        then
            Pokemon isa ivysaur : 0.33.

rule13 :: if
            Pokemon isa fire_type
        then
            Pokemon isa charmeleon : 0.33.

rule14 :: if
            Pokemon isa water_type and
            Pokemon isa 'symbol of longevity'
        then
            Pokemon isa wartortle : 0.5.

rule15 :: if
            Pokemon isa electric_type and
            Pokemon has 'long tail'
        then
            Pokemon isa raichu : 0.5.

fact :: X isa pokemon : 0.9 :-
    member(X, [bulbasaur, ivysaur, venusaur, charmander, charmeleon, charizard, squirtle, wartortle, blastoise, pikachu, raichu]).

askable(_ can _, 'Pokemon' can 'Use').
askable(_ isa _, 'Pokemon' isa 'Type').
askable(_ has _, 'Pokemon' has 'Something').
askable(_ 'does not' _, 'Pokemon' 'does not' 'DoSomething').
