input=: <@}:;._1' ',1!:1<'day01.in'
dirs=: */\0j_1+0j2*'L'={.&>input    NB. directions as complex numbers
lens=: ".@}.&>input                 NB. length of movement
md=: [:+/[:|+.                      NB. Manhattan distance
md+/dirs*lens                       NB. Part 1
path=: +/\lens#dirs                 NB. Complete path taken
md ({~{.@I.@:-.@~:) path            NB. Part 2
