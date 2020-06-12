#include "Rwmake.ch" 
#include "TOPCONN.CH"
#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDICATE  บAutor  ณMicrosiga           บ Data ณ  11/29/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDICEP()

Private lInverte := .F.
Private cMarca
Private _nNRREG := 0

_lRet	:= .T.
_aArea	:= GetArea()
_cAlias := alltrim(substr(_aarea[1],2,2))

cQuery  := "SELECT DISTINCT ZS_END, ZS_BAIRRO, ZS_MUN, ZS_EST, ZS_CEP "
cQuery  += "FROM "+RetSQLname('SZS')+" SZS "
cQuery  += "WHERE SZS.D_E_L_E_T_ <> '*'"
If Len(ALLTRIM(M->&(_cAlias+"_CEP"))) == 5
	cQuery  += "AND ZS_CEP LIKE '"+ALLTRIM(SUBSTR(M->&(_cAlias+"_CEP"),1,5))+"%' "
Else
	cQuery  += "AND ZS_CEP LIKE '"+ALLTRIM(M->&(_cAlias+"_CEP"))+"' "
EndIf
TcQuery cQuery New Alias "TMPSZS"

cQuery  := "SELECT COUNT(ZS_CEP) AS REG "
cQuery  += "FROM "+RetSQLname('SZS')+" SZS "
cQuery  += "WHERE SZS.D_E_L_E_T_ <> '*'"
If Len(ALLTRIM(M->&(_cAlias+"_CEP"))) == 5
	cQuery  += "AND ZS_CEP LIKE '"+ALLTRIM(SUBSTR(M->&(_cAlias+"_CEP"),1,5))+"%' "
Else
	cQuery  += "AND ZS_CEP LIKE '"+ALLTRIM(M->&(_cAlias+"_CEP"))+"' "
EndIf
TcQuery cQuery New Alias "TMPREG"

DbSelectArea("TMPSZS")
DbGotop()
_aTmp := {}
aAdd(_aTmp,{"OK"        ,"C", 02,0})
aAdd(_aTmp,{"ENDER"     ,"C", 60,0})
aAdd(_aTmp,{"BAIRRO"    ,"C", 30,0})
aAdd(_aTmp,{"MUN"       ,"C", 30,0})
aAdd(_aTmp,{"EST"       ,"C", 02,0})
aAdd(_aTmp,{"CEP"       ,"C", 09,0})

dbCreate("TMPCEP",_aTmp)
dbUseArea(.T.,,"TMPCEP","TMPCEP",.F.)
_cIndTMP := CriaTrab(NIL,.F.)
_cChave  := "CEP"
IndRegua("TMPCEP",_cIndTMP,_cChave,,,"Indice Temporario...")

DbSelectArea("TMPSZS")
DbGotop()
ProcRegua(RecCount())
Do While !EOF()
	IncProc()
	RecLock("TMPCEP",.T.)
	TMPCEP->OK 		:= ""
	TMPCEP->ENDER	:= TMPSZS->ZS_END
	TMPCEP->BAIRRO 	:= TMPSZS->ZS_BAIRRO
	TMPCEP->MUN 	:= TMPSZS->ZS_MUN
	TMPCEP->EST 	:= TMPSZS->ZS_EST
	TMPCEP->CEP 	:= TMPSZS->ZS_CEP
	MsUnLock()
	DbSelectArea("TMPSZS")
	DbSkip()
EndDo

DbSelectArea("TMPREG")
DbGoTop()
If TMPREG->REG < 1
	msgbox("Nao ha registros!!!")
	DbSelectArea("TMPSZS")
	DbCloseArea()
	DbSelectArea("TMPREG")
	DbCloseArea()
	DbSelectArea("TMPCEP")
	DbCloseArea()
	fErase("TMPCEP.DBF")
	Return(.T.)
EndIf

DbSelectArea("TMPCEP")
DbGoTop()

cMarca  := GetMark()
nOpcA	:= 0
aCampos := {}
	
aAdd(aCampos,{"OK"		,"", ""          })
aAdd(aCampos,{"ENDER"	,"", "Endereco"  })
aAdd(aCampos,{"BAIRRO"	,"", "Bairro"    })
aAdd(aCampos,{"MUN"		,"", "Municipio" })
aAdd(aCampos,{"EST"		,"", "Estado"    })
aAdd(aCampos,{"CEP"		,"", "CEP"       })

Define MsDialog oDlg1 Title OemToAnsi("Endereco") From 01, 01 to 30, 060 of oMainWnd
oMark := MsSelect():New("TMPCEP","OK",,aCampos,@lInverte,@cMarca	,{015, 006, 205, 220})
oMark:oBrowse:lhasMark    := .F.
	
Activate MsDialog oDlg1 on init EnchoiceBar(oDlg1,{|| nOpcA := 1,oDlg1:End()},{|| nOpcA := 9, ODlg1:End()},,) Center

DbSelectArea("TMPSZS")
DbCloseArea()
DbSelectArea("TMPREG")
DbCloseArea()
		
If nOpcA == 1 //Grava Selecao de CEP
	DbSelectArea("TMPCEP")
	DbGoTop()
	_lRet := .F.
	nCont := 0
	Do While !EOF()
		Do Case
			Case marked(TMPCEP->OK)
				If Empty(TMPCEP->OK)
					nCont ++
					_lRet := .F.
				EndIf
			Case TMPCEP->OK == cMarca
				nCont ++
				_lRet := .F.
		EndCase
		DbSelectArea("TMPCEP")
		DbSkip()
	EndDo
	If nCont >= 2
		alert("nao pode ter mais de um selecionado!!!")
		DbSelectArea("TMPCEP")
		DbCloseArea()
		fErase("TMPCEP.DBF")
		RestArea(_aArea)
		Return(_lRet)	
	EndIf
	DbSelectArea("TMPCEP")
	DbGoTop()
	_lRet := .F.
	Do While !EOF()
		Do Case
			Case marked(TMPCEP->OK)
				If Empty(TMPCEP->OK)
					GravaSU5()
					_lRet := .T.
				EndIf
			Case TMPCEP->OK == cMarca
				GravaSU5()
				_lRet := .T.
		EndCase
		DbSelectArea("TMPCEP")
		DbSkip()
	EndDo
	
EndIf

DbSelectArea("TMPCEP")
DbCloseArea()
fErase("TMPCEP.DBF")

RestArea(_aArea)

Return(_lRet)

Static Function GravaSU5()

_cAlias := alltrim(substr(_aarea[1],2,2))

M->&(_cAlias+"_END")		:= TMPCEP->ENDER
M->&(_cAlias+"_BAIRRO") 	:= TMPCEP->BAIRRO
M->&(_cAlias+"_MUN") 		:= TMPCEP->MUN
M->&(_cAlias+"_EST") 		:= TMPCEP->EST
M->&(_cAlias+"_CEP") 		:= TMPCEP->CEP

Return