input=: (".;._2)1!:1<'day03.in'

test=: [: *./ (_1 +/\. ]) > [: , _1 ]\ ]

+/test"1 input NB. Part 1
+/(test"1) _3]\ ,|: input NB. Part 2
