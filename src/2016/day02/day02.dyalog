data←⊃⎕NGET'day02.in'1
extract←{(((1⌊⊢)∘(¯1⌈⊢))⍤+)/⌽⍵}
row←{2-extract('U'⍷⍵)-'D'⍷⍵}
column←{2+extract('R'⍷⍵)-'L'⍷⍵}
getnumber←{(⍺,⍵)⌷3 3⍴⍳9}
(row getnumber column)¨data  ⍝ part 1
