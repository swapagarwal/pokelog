:- op(100, xfx, [has, gives, 'does not', eats, lays, isa]).
:- op(100, xf, [swims, flies]).

:- dynamic (::)/2.

rule1 :: if
            Animal has hair
            or
            Animal gives milk
        then
            Animal isa mammal : 0.9.

rule2 :: if
            Animal has feathers
            or
            Animal flies and
            Animal lays eggs
        then
            Animal isa bird : 0.8.

rule3 :: if
            Animal isa mammal and
            (
                Animal eats meat
                or
                Animal has 'pointed teeth' and
                Animal has claws and
                Animal has 'forward pointing eyes'
            )
        then
            Animal isa carnivore : 0.7.

rule4 :: if
            Animal isa carnivore and
            Animal has 'tawny colour' and
            Animal has 'dark spots'
        then
            Animal isa cheetah : 0.6.

rule5 :: if
            Animal isa carnivore and
            Animal has 'tawny colour' and
            Animal has 'black stripes'
        then
            Animal isa tiger : 0.5.

rule6 :: if
            Animal isa bird and
            Animal 'does not' fly and
            Animal swims
        then
            Animal isa penguin : 0.4.

rule7 :: if
            Animal isa bird and
            Animal isa 'good flyer'
        then
            Animal isa albatross : 0.3.

rule8 :: if
            bottle_empty
        then
            john_drunk : 1.

rule9 :: if
            john_drunk
        then
            bottle_empty : 1.

rule10 :: if
            Animal isa loop
        then
            Animal isa loop : 1.

fact :: X isa animal : 0.9 :-
    member(X, [cheetah, tiger, penguin, albatross]).

askable(_ gives _, 'Animal' gives 'What').
askable(_ flies, 'Animal' flies).
askable(_ lays eggs, 'Animal' lays eggs).
askable(_ eats _, 'Animal' eats 'What').
askable(_ has _, 'Animal' has 'Something').
askable(_ 'does not' _, 'Animal' 'does not' 'DoSomething').
askable(_ swims, 'Animal' swims).
askable(_ isa 'good flyer', 'Animal' isa 'good flyer').
