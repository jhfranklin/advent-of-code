input=: (<;._2)1!:1<'day02.in'
convert=: [: {&(4 2$1 0 _1 0 0 _1 0 1) 'DULR'&i.

part1=: 3 : 0
 step=. [: 0 0&>. [: 2 2&<. +
 presses=. +/\;$&.> y
 path=. step/\.&.|. 1 1,convert;y
 keypad=. 3 3$,":"0 >:i.9
 keypad {~ <"1 presses { path
)

part2=: 3 : 0
 step=. +^:(2 >: [: +/ [: | 2 2 -~ +)
 presses=. +/\;$&.> y
 path=. step/\.&.|. 2 0,convert;y
 keypad=. 5 5$'  1   234 56789 ABC   D'
 keypad {~ <"1 presses { path
)

part1 input
part2 input