data←⊃⎕NGET'day02.sample'1
extract←{(((1⌊⊢)∘(¯1⌈⊢))⍤+)/⌽⍵}
row←{2-extract('U'⍷⍵)-'D'⍷⍵}
column←{2+extract('R'⍷⍵)-'L'⍷⍵}
getnumber←{(⍺,⍵)⌷3 3⍴⍳9}
(row getnumber column)¨data ⍝ part 1

Movements←{(('R'⍷⍵)-'L'⍷⍵)+(('U'⍷⍵)-'D'⍷⍵)×0j1}
path←¯2J0,Movements¨data

RestrictedSum←{(1+{2≥+/|9 11○⍵}⍺+⍵)⊃⍵,⍺+⍵}
ConvertToCode←{(5 5⍴0 0 1 0 0 0 2 3 4 0 5 6 7 8 9 0 'A' 'B' 'C' 0 0 0 'D' 0 0)⌷⍨3+11 9○⍵}