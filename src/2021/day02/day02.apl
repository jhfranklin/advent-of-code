input←' '(≠⊆⊢)¨⊃⎕NGET'day02.in'1
d←(⊃⊃)¨input ⍝ direction
m←⍎⍤(⊃¯1∘↑)¨input ⍝ magnitude
(+/m×'f'=d)×(+/m×'d'=d)-+/m×'u'=d ⍝ part 1
