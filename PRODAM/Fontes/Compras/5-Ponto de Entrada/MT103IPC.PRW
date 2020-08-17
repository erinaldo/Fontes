#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³MT103IPC  ³ Autor ³ TOTVS                  ³ Data ³ 03/11/15³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³      Ponto de entrada do programa MATA103.                 ³±±
±±³          ³      Utilizacao: na nota de entrada, no momento de import  ³±±
±±³          ³      dos itens do pedido de compras (SC7).                 ³±±
±±³          ³      Faz o tratamento dos campos especificos               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PRODAM                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT103IPC

//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
//Â³ Declaracao de variaveis.                                            Â³
//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
Local _nAux1, _dDota, _cDescProd

//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
//Â³ Atualiza o campo de data de dotação do Pedido de Compras            Â³
//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„ÃÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™

_dDota			:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XDTDOT"})
_cDescProd		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XDESCCO"})
_cDescCC		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XDESCCC"})

//_nxTotal		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_XTOTAL"})
//_nvUnit		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_VUNIT"})
//_nTotal		:= aScan (aHeader, {|x| AllTrim(x[2]) == "D1_TOTAL"})

If _dDota  > 0 
	aCols[paramixb[1], _dDota] := SC7->C7_XDTDOT
Endif
If _cDescProd > 0
	aCols[paramixb[1], _cDescProd] := SC7->C7_XDESCCO
EndIf

If _cDescCC > 0
	aCols[paramixb[1], _cDescCC] := SC7->C7_XDESCCC
EndIf

//If _nxTotal > 0
//	aCols[paramixb[1], _nxTotal] := SC7->C7_XTOTAL
//	aCols[paramixb[1], _nvUnit] := SC7->C7_PRECO
//	aCols[paramixb[1], _nTotal] := SC7->C7_TOTAL
//EndIf

Return(nil)