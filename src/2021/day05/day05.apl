in←(⍎¨∊∘⎕D⊆⊢)¨⊃⎕NGET'day05.in'1
length←{1+⌈/|⍺-⍵}
range←⊣,⊣-∘(⍳∘|××)-
path←{x1 y1 x2 y2←⍵ ⋄ l←(2↑⍵) length (2↓⍵) ⋄ ((l,1)⍴x1 range x2),(l,1)⍴y1 range y2}
diagcheck←(=/0 1 0 1∘/)∨(=/1 0 1 0∘/)

+/1<3⌷[2]{⍺,≢⍵}⌸⊃⍪/path¨in /⍨ diagcheck¨in ⍝ Part 1
+/1<3⌷[2]{⍺,≢⍵}⌸⊃⍪/path¨in ⍝ Part 2
