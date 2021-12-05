in=.];._2 (1!:1<'day04.in')
draws=.".;._1',',0{in
boards=.((5 5,~25%~$)$]),".;._1}.in
win=.(([:<./"1>./"1)<.([:<./"1>./"2))draws i.boards
p1=.<./win
p2=.>./win
p1{draws*+/,((win i.p1){boards)*-.((win i.p1){boards)e.(1+p1){.draws NB. Part 1
p2{draws*+/,((win i.p2){boards)*-.((win i.p2){boards)e.(1+p2){.draws NB. Part 2
