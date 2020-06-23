#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun??o    ³MT120ISC  ³ Autor ³ TOTVS                  ³ Data ³ 03/11/15³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³  Este Ponto de Entrada traz conteudo de campos criados na  ³±±
±±³          ³  solicitacao de compras, para os itens do pedido de compras³±±
±±³          ³  Campos Especificos.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PRODAM                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


//EM AMBIENTE DESENVOLVIMENTO
//O PONTO DE ENTRADA ESTA VALIDADO POREM O PROCESSO AINDA NAO
//ESTA FALTANDO UM ENTENDIMENTO REFERENTE AO GCT

User Function MT120ISC()
            
Local nPos
Local aAliasOri                                    

Private _nPosSolic := _nPosChave := _nOrderSC1 := 0

///******************************************************************************
///** Guarda Ambiente Original
///******************************************************************************
aAliasOri := GETAREA()


///******************************************************************************
///** Rotina Principal
///******************************************************************************
_nPosSolic	:= aScan(aHeader,{|x|AllTrim(x[2]) == "C7_NUMSC"})
_nPosItem	:= aScan(aHeader,{|x|AllTRim(x[2]) == "C7_ITEMSC"})
_nPosDtDot 	:= aScan(aHeader,{|x|AllTrim(x[2]) == "C7_XDTDOT"})
_nOrderSC1	:= SC1->( RetIndex() )

SC1->( dbSetOrder(1) )	/// Ordem "FILIAL+PEDIDO"

For nPos := 1 to Len(aCols)
	SC1->( dbSeek(xFilial("SC1")+aCols[nPos][_nPosSolic]+aCols[nPos][_nPosItem]))
	If SC1->( Found() )
		aCols[nPos][_nPosDtDot] 	:= SC1->C1_XDTDOT
	EndIf
Next nPos

SC1->( dbSetOrder(_nOrderSC1) )	/// Ordem "FILIAL+PEDIDO"

///ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
///³ Retorna Ambiente Original		   										  ³
///ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        
RESTAREA(aAliasOri)

Return Nil
