input←⊃⎕NGET'day08.in'1

+/,↑{2 3 4 7∘.=≢¨(¯4↑' '∘(≠⊆⊢))⍵}¨input ⍝ Part 1

sortsignals←(⊂∘⍋⌷⊢)¨10↑' '∘(≠⊆⊢)
sig1←{⊃(2=≢¨⍵)/⍵}
sig4←{⊃(4=≢¨⍵)/⍵}
sig1intersect←{(≢∩∘(sig1 ⍵))¨⍵}
sig4intersect←{(≢∩∘(sig4 ⍵))¨⍵}
id←{⊃×⌿(≢¨⍵)({(≢∩∘(sig1 ⍵))¨⍵}⍵)({(≢∩∘(sig4 ⍵))¨⍵}⍵)}
getdigit←{¯1+(⍳10)+.×36 8 10 30 32 15 18 12 56 48∘.=id ⍵}
values←(⊂∘⍋⌷⊢)¨¯4↑' '∘(≠⊆⊢)
getoutput←{10⊥(getdigit sortsignals ⍵)+.×⍨(values∘.≡sortsignals)⍵}
+/getoutput¨input ⍝ Part 2
