#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIBANAT   ºAutor  ³Microsiga           º Data ³  06/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIBANAT_A()

DbSelectArea("SED")
DbGotop()
DbSetOrder(1)

cBuffer := ""
_cAux2	:= ""

Do While !EOF()

	cBuffer	:= Alltrim(SED->ED_FECHA)
	If Empty(cBuffer)
		DbSelectArea("SED")
		SED->(DbSkip())
		Loop
	EndIf

	_nCont	:= 8
	_cAux1	:= ""
	_cAux2	:= ""
	For _nI := 1 to Len(Alltrim(cBuffer)) step 6

		cBuffer := Substr(cBuffer,1,6)

		If Substr(cBuffer,5,2) == "82"
			_cAux1	:= Substr(cBuffer,1,4)+ Str((Val(Substr(cBuffer,5,2))-10),2)
		Else
			_cAux1	:= cBuffer
		EndIf

		_cAux2		+=	_cAux1 + ";"
	
		cBuffer 	:=	Substr(Alltrim(SED->ED_FECHA),_nCont,(At(";",Alltrim(SED->ED_FECHA))-1))
		_nCont		+= 7

		If Empty(cBuffer)
			Exit
		EndIf

	Next _nI

	RecLock("SED",.F.)
	SED->ED_FECHA	:= _cAux2
	MsUnLock()

	DbSelectArea("SED")
	SED->(DbSkip())

EndDo


//_cUseReq :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

Return