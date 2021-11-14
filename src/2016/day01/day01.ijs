data=.}:&.><;._1' ',1!:1<'day01.in'
directions=.0j1**/\>(0j_1+0j2*'L'={.)&.>data NB. convert to complex directions and fold
lengths=.".>}.&.>data	
+/+.+/directions*lengths NB. part 1
path=.+/\lengths#directions
+/+.(0(=i.1:)~:path){path NB. part 2
