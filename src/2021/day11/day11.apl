grid←⍎¨↑⊃⎕NGET'day11.in'1

countadjacent←({+/,⍵}⌺3 3)-⊢ ⍝ takes boolean array and counts how many adjacent values there are
flash←9∘≥×(××((countadjacent 9∘<)+⊢))
step←(flash⍣≡)1∘+
zeroes←+/(,0∘=)
turn←{((⊃⍵)+zeroes next),⊂next←step ⊃2⌷⍵}

⊃(turn⍣100) 0,⊂grid ⍝ Part 1
0{0=+/,⍵ : ⍺ ⋄ (⍺+1)∇step ⍵} grid ⍝ Part 2
