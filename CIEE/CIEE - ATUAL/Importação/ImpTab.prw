#include "rwmake.ch"
#include "TOPCONN.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO13    ºAutor  ³Microsiga           º Data ³  05/21/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ImpTab()

DbSelectArea("SZY")
DbGotop()
DbSetOrder(1) //Cartao + Emissao

alert("Inicio SZY")

Do While !EOF()
	
	If SZY->ZY_DATA < CTOD("01/01/10")
		DbSeek(xFilial("SZY")+ZY_CARTAO+"20100101",.T.)
	EndIf
	RecLock("SZY",.F.)
	SZY->ZY_CONTA	:= Posicione("CT1",2,xFilial("CT1")+SZY->ZY_ITEM  ,"CT1_CONTA") 
	SZY->ZY_CONTAC	:= Posicione("CT1",2,xFilial("CT1")+SZY->ZY_ITEMC ,"CT1_CONTA")
	MsUnLock()
	SZY->(DbSkip())

EndDo

/*
DbSelectArea("SE5")
DbGotop()
DbSetOrder(1)//data
DbSeek(xFilial("SE5")+"20100101",.T.)

alert("Inicio SE5")

Do While !EOF()

	RecLock("SE5",.F.)
//	SE5->E5_DEBITO  := Posicione("CT1",2,xFilial("CT1")+SE5->E5_ITEMD ,"CT1_CONTA") //SE5->E5_ITEMD
	SE5->E5_CREDITO := Posicione("CT1",2,xFilial("CT1")+SE5->E5_ITEMC ,"CT1_CONTA") //SE5->E5_ITEMC
	MsUnLock()
	SE5->(DbSkip())
	
EndDo


DbSelectArea("SE2")
DbGotop()
DbSetOrder(5)//Emissao
DbSeek(xFilial("SE2")+"20100101",.T.)

alert("Inicio SE2")

Do While !EOF() .and. SE2->E2_EMISSAO >= CTOD("01/01/10")

	RecLock("SE2",.F.)
	SE2->E2_CCONTAB	:= Posicione("CT1",2,xFilial("CT1")+SE2->E2_REDUZ   ,"CT1_CONTA") //SE2->E2_REDUZ
	SE2->E2_CCONTCR	:= Posicione("CT1",2,xFilial("CT1")+SE2->E2_RED_CRE ,"CT1_CONTA") //SE2->E2_RED_CRE
	MsUnLock()
	SE2->(DbSkip())

EndDo

DbSelectArea("SA2")
DbSetOrder(1)//Codigo
DbGotop()

alert("Inicio SA2")

Do While !EOF()

	RecLock("SA2",.F.)
	SA2->A2_CONTA := Posicione("CT1",2,xFilial("CT1")+SA2->A2_REDUZ ,"CT1_CONTA") //SA2->A2_REDUZ
	MsUnLock()
	SA2->(DbSkip())

EndDo

DbSelectArea("SA6")
DbSetOrder(1)//Codigo
DbGotop()

alert("Inicio SA6")

Do While !EOF()

	RecLock("SA6",.F.)
	SA6->A6_CONTA := Posicione("CT1",2,xFilial("CT1")+SA6->A6_CONTABI ,"CT1_CONTA") //SA6->A6_CONTABI
	MsUnLock()
	SA6->(DbSkip())
EndDo

DbSelectArea("CT2")
DbGotop()
DbSetOrder(1)//data
DbSeek(xFilial("CT2")+"20100101",.T.)

alert("Inicio CT2")

Do While !EOF()

	RecLock("CT2",.F.)
	CT2->CT2_DEBITO := Posicione("CT1",2,xFilial("CT1")+CT2->CT2_ITEMD ,"CT1_CONTA") //CT2->CT2_ITEMD
	CT2->CT2_CREDIT := Posicione("CT1",2,xFilial("CT1")+CT2->CT2_ITEMC ,"CT1_CONTA") //CT2->CT2_ITEMC
	MsUnLock()
	CT2->(DbSkip())
	
EndDo

DbSelectArea("SZM")
DbGotop()

alert("Inicio SZM")

Do While !EOF()

	RecLock("SZM",.F.)
	SZM->ZM_DEBITO := Posicione("CT1",2,xFilial("CT1")+SZM->ZM_ITEMD ,"CT1_CONTA") //SZM->ZM_ITEMD
	MsUnLock()
	SZM->(DbSkip())
	
EndDo
*/

alert("Fim Processamento")