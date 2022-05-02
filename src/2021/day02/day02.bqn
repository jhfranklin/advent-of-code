in←•FLines "day02.in"

distances←(•BQN·≍ ¯1⊸⊏)¨ in
forwards←(+´"forward"⊸⍷)¨ in
ups←(+´"up"⊸⍷)¨ in
downs←1-forwards+ups
position←+´forwards×distances
depth←+´downs -○(×⟜distances) ups
position×depth # Part 1

aim←+`downs -○(×⟜distances) ups
newdepth←+´distances×forwards×aim
position×newdepth # Part 2

