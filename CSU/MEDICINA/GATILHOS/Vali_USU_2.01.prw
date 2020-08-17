User Function val_usu2()

_aArea := GetArea()
_usu   :=""

DbselectArea("TMK")
dbGoTop()
DbSetOrder(1)

while !Eof()
   IF Subs(cUsuario,7,7) = TMK->TMK_USUARI
      _usu := TMK->TMK_CODUSU
      Exit     
   Endif
   DbSkip()
Enddo

RestArea(_aArea)
Return _usu