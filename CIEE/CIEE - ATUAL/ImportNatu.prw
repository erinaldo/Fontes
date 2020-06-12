#include "rwmake.ch"
#include "protheus.ch"

User Function ImportNatu()

cArq	:= "P:\Protheus_Data\system\NATU1.DBF"
_aErro	:= {}

if file(cArq)
	msgbox("Inicio do Processamento")

	Use Natu1 alias XX1
	
//	dbUseArea(.T.,,cArq,"XX1",.T.)
	cInd := CriaTrab(NIL,.F.)
	IndRegua("XX1",cInd,"ED_CODIGO",,,"Selecionando Registros...")
	ProcRegua(RecCount())

	DbSelectArea("SED")
	DbSetOrder(1)
	ProcRegua(RecCount())
	Do While !EOF()
		IncProc()
		DbSelectArea("XX1")
		If DbSeek(SED->ED_CODIGO)
			DbSelectArea("SED")
			RecLock("SED",.F.)
			SED->ED_CLASSE	:= XX1->ED_CLASSE
			SED->ED_SUP		:= XX1->ED_SUP
			SED->ED_TPMOV	:= XX1->ED_TPMOV
			SED->ED_SUPORC	:= XX1->ED_SUPORC
			SED->ED_DESORC	:= XX1->ED_DESORC
			SED->(MsUnlock())
		Else
			Aadd(_aErro,SED->ED_CODIGO)
		EndIf
		DbSelectArea("SED")
		SED->(DbSkip())
	EndDo
	msgbox("Fim processamento")
Else
	msgbox("Arquivo nao encontrado")
EndIf 

_nArq := fCreate("P:\Protheus_Data\system\NATU1.TXT")
For _nI := 1 to len(_aErro)
	fWrite(_nArq, _aErro[_nI] + chr(10)+chr(13) , 30)
Next

Return