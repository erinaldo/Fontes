#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTGER003  ºAutor  ³Claudio Barros      º Data ³  07/18/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetivacao de lotes contabeis (pre para efetivado)         º±±
±±º          ³ chamando ponto de entrada CTB350EF                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTGER003()

Private cString := "CT2"

Pergunte("CTB350    ",.T.)

DbSelectArea("CT2")
DbSetOrder(1)

cIndex		:= CriaTrab(NIL,.F.)
cChave		:= CT2->(IndexKey())
nOldIndex	:= CT2->(IndexOrd())

IndRegua("CT2", cIndex, cChave,,"CT2_LOTE>=MV_PAR01 .AND. CT2_LOTE<=MV_PAR02 .AND. CT2_DATA>=MV_PAR03 .AND. CT2_DATA<=MV_PAR04 .AND. CT2_SBLOTE>=MV_PAR09 .AND. CT2_SBLOTE<=MV_PAR10 .AND. CT2_DOC>=MV_PAR13 .AND. CT2_DOC<=MV_PAR14","Selecionando Registros...")
nIndex := RetIndex("CT2")

_aTST := {}
aAdd(_aTST,{"LOTE"  ,"C", 06,0})
aAdd(_aTST,{"DOC"   ,"C", 06,0})
aAdd(_aTST,{"REG"   ,"C", 06,0})
cArq 		:= CriaTrab(_aTST,.T.)
dbUseArea(.T.,,cArq,"TST",.T.)
_cIndTST  	:= CriaTrab(NIL,.F.)
_cChave   	:= "REG+LOTE+DOC"
IndRegua("TST",_cIndTST,_cChave,,,"Indice Temporario...")

DbSelectArea("CT2")
_cReg := CT2->(Recno())
Do While !EOF()
	DbSelectArea("TST")
	RecLock("TST",.T.)
	TST->LOTE := CT2->CT2_LOTE
	TST->DOC  := CT2->CT2_DOC
	TST->REG  := alltrim(strzero(CT2->(Recno()),6))
	MsUnLock()
	DbSelectArea("CT2")
	DbSkip()
EndDo

DbSelectArea("CT2")
DbGoto(_cReg)

CTBA350()

DbSelectArea("TST")
DbCloseArea()
fErase(cArq+".DBF")
fErase(cIndex+OrdBagExt())

Return