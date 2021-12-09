input←↑,¨(10∘⊥⍣¯1⍎¨)¨⊃⎕NGET'day09.in'1
lows←({n←⍵ ⋄ (⍺[1]↑n)←10 ⋄ (⍺[2]↑⍉n)←10 ⋄ ⌊/2⌷[2]4 2⍴n}⌺3 3)>⊢
+/,(lows×1∘+) input ⍝ Part 1

ids←(⊢+0∘≠)(⍴⍴((×∘(+\)⍨),∘lows)) ⍝ creates IDs for the low points, starting from 2
map←ids+(9∘≠×(0∘=ids)) ⍝ creates map, 1s are unseen locs, 2+ are low points, 0 are barriers

neighbours←{n←⍺⋄({⊂+/,n=(3 3⍴0 1)×⍵}⌺3 3)⍵} ⍝ gets direct neighbours
filler←{⍺×(⍺ neighbours ⍵)×⍵=1} ⍝ Creates cells to be filled
fill←{⍺({(⍺@(⍸0≠(⍺ filler ⍵)))⍵}⍣≡)⍵} ⍝ fills ⍵ with ⍺
basinsize←{+/,⍺(⊣=fill)⍵}

×/3↑(⊂∘⍒⌷⊢)(basinsize∘(map input))¨1↓⍳⌈/,map input ⍝ Part 2
