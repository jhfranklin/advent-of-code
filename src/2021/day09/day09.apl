input←↑,¨(10∘⊥⍣¯1⍎¨)¨⊃⎕NGET'day09.in'1
lows←({n←⍵ ⋄ (⍺[1]↑n)←10 ⋄ (⍺[2]↑⍉n)←10 ⋄ ⌊/2⌷[2]4 2⍴n}⌺3 3)>⊢
+/,(lows×1∘+) input ⍝ Part 1

ids←(⊢+0∘≠)(⍴⍴((×∘(+\)⍨),∘lows)) ⍝ creates IDs for the low points, starting from 2
map←ids+(9∘≠×(0∘=ids)) ⍝ creates map, 1s are unseen locs, 2+ are low points, 0 are barriers

fill←(⍴⍴({⊃({⍵/⍨⍵>1}(9⍴0 1)/,⍵)}⌺3 3))×1∘=
step←fill+(⊢×0∘=∘fill)
flood←step⍣≡

floodgrid←flood map input
×/3↑(⊂∘⍒⌷⊢)(+/∘,floodgrid∘=)¨1↓⍳⌈/,floodgrid←flood map input ⍝ Part 2
