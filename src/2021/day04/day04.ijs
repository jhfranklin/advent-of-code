in=.];._2 (1!:1<'day04.in')
draws=.".;._1',',0{in
boards=.;/".;._1}.in
mark=.([:+/=/) NB. dyad which creates marks on board y which match any of x
wins=.boards&{{;(+./@:(*./"1) +. +./@:(*./"2))@(y&mark)&.>x}}&.><@]\draws
findwin =. [i.~[:;[: +/&.>] NB. dyad to find when position x wins in series y (e.g. find when 1st place wins)
winningpos =. 1 findwin wins
winningboard =. >boards{~I.>winningpos{wins
(winningpos{draws)*+/,winningboard(]*[:-.mark)~(1+winningpos){.draws NB. Part 1
losingpos=.wins findwin~ $boards
losingboard=.>boards{~I.0=>wins{~_1+losingpos
(losingpos{draws)*+/,losingboard(]*[:-.mark)~(1+losingpos){.draws NB. Part 2
