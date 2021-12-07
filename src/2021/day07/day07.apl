input←⍎¨','(≠⊆⊢)⊃⊃⎕NGET'day07.in' 1
⌊/+⌿|input∘.-0,⍳⌈/input ⍝ Part 1
⌊/+⌿(+/⍳)¨|input∘.-0,⍳⌈/input ⍝ Part 2
