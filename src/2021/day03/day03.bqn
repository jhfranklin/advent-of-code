in←>'1'=•FLines "day03.in"

ToDecimal←2⊸×⊸+˜´∘⌽
gamma←(+˝>2÷˜≠)in
epsilon←¬gamma
gamma ×○ToDecimal epsilon # Part 1


Oxygen←0{1=≠𝕩 ? ToDecimal⥊𝕩 ; 
  col←𝕗⊏˘𝕩
  bit←(+´≥2÷˜≠)col
  (1+𝕗) _𝕣 𝕩/˜bit=col}

CO2←0{1=≠𝕩 ? ToDecimal⥊𝕩 ; 
  col←𝕗⊏˘𝕩
  bit←(+´<2÷˜≠)col
  (1+𝕗) _𝕣 𝕩/˜bit=col}

(Oxygen×CO2) in # Part 2

