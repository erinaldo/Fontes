#include "rwmake.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA43   บAutor  ณMicrosiga           บ Data ณ  05/21/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA43()

PRIVATE aCampos4 := {}
PRIVATE aCampos5 := {}
PRIVATE aNomeArq := {"",""}

PRIVATE cParams		:= ""
PRIVATE cOpcoes		:= "1;0;1;Reserva Financeira"

Private cPerg 	:= "CFIN43    "

nTotal1 := 0
nTotal2 := 0
nTotal3 := 0
nTotal4 := 0
lRet	:= .T.

oOk   := LoadBitmap( GetResources(), "LBOK" )
oNo   := LoadBitmap( GetResources(), "LBNO" )


_fCriaSx1()

If !pergunte(cPerg,.T.)
	Return
EndIf

_dDtFech := ""
aData	:= {}

_cQuery	:= "SELECT ZX_DTFECH AS DTFECH "
_cQuery	+= "FROM " + RetSqlName("SZX")+" "
_cQuery	+= "WHERE D_E_L_E_T_ <> '*' "
_cQuery	+= "AND SUBSTRING(ZX_DTFECH,1,6) = '"+mv_par02+mv_par01+"' "
_cQuery	+= "GROUP BY ZX_DTFECH "
_cQuery	+= "ORDER BY ZX_DTFECH "
TCQUERY _cQuery ALIAS "TMPDT" NEW

DbSelectArea("TMPDT")
DbGotop()
Do While !EOF()
	_dDtFech := STOD(TMPDT->DTFECH)
	aAdd(aData,{.F.,_dDtFech	})
	TMPDT->(DbSkip())
EndDo

DbSelectArea("TMPDT")
TMPDT->(DbCloseArea())

If Empty(Len(aData))
	_cMsg := "Nใo existe movimento para esta data !!!"
	MsgBox(OemToAnsi(_cMsg), "Aviso", "ALERT")
	Return	
EndIf

DEFINE MSDIALOG oDlg FROM  31,58 TO 250,300 TITLE "Qual Data deseja Imprimir?" PIXEL
@ 05,05 LISTBOX oLbx1 FIELDS HEADER "","Data" SIZE 115, 85 OF oDlg PIXEL ON DBLCLICK (U_MARKDAT())
	
oLbx1:SetArray(aData)
oLbx1:bLine := { || {If(aData[oLbx1:nAt,1],oOk,oNo),aData[oLbx1:nAt,2] } }
oLbx1:nFreeze  := 1
	
DEFINE SBUTTON FROM 94, 020 TYPE 1  ENABLE OF oDlg ACTION Processa({||  U_ExecDat() },"Processando Registros...")
DEFINE SBUTTON FROM 94, 060 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.,oDlg:End())
	
ACTIVATE MSDIALOG oDlg CENTERED

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  06/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImportacao de Extrato Bancario                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ExecDat()

oDlg:End()

Private lInverte := .F.
Private cMarca

For _nI := 1 to Len(aData)
	If aData[_nI,1]
		oLbx1:nAt := _nI
	EndIf
Next _nI

//cParams := DTOS(mv_par01)
_dDt := aData[oLbx1:nAt,2]
cParams  := Dtos(aData[oLbx1:nAt,2])

IF Select("cArqX") > 0
	dbSelectArea("cArqX")
	dbCloseArea()
	Ferase("cArqX"+GetDBExtension())
	Ferase("cArqX"+OrdBagExt())
EndIf

IF Select("cArqY") > 0
	dbSelectArea("cArqY")
	dbCloseArea()
	Ferase("cArqY"+GetDBExtension())
	Ferase("cArqY"+OrdBagExt())
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ TOTAL CDB                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCampos4 :=	{{"BANCO"	, "C", 15, 0, OemToAnsi("Banco")			},;
			{"CDBPRE"	, "N", 14, 2, OemToAnsi("CDB PRE")	   		},;
			{"CDBPOS"	, "N", 14, 2, OemToAnsi("CDB POS")			},;
			{"BRAM"		, "N", 14, 2, OemToAnsi("BRAM")				}}

dbCreate("cArqX",aCampos4)
aNomeArq[1] := "cArqX"
dbUseArea (.T.,,aNomeArq[1],"cArqX", NIL, .F.)
IndRegua("cArqX",aNomeArq[1],"BANCO",,,OemToAnsi("Selecionando Registros..."))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ TOTAL CDB                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IncProc("TOTAL CDB")

DbSelectArea("SZX")
DbSetOrder(1)
DbGotop()
If DbSeek(xFilial("SZX")+Dtos(_dDt))
	_cBanco	:= ""
	While Dtos(SZX->ZX_DTFECH) == Dtos(_dDt)
		
		IF SZX->ZX_TPAPL == "PRV"
			dBSkip()
			Loop
		EndIf

		If SZX->ZX_NOMBCO == _cBanco
			// Grava registros no arquivo temporario
			dbSelectArea("cArqX")
			RecLock("cArqX",.F.)
			Do Case
				Case SZX->ZX_TPAPL == "PRE"
					cArqX->CDBPRE	+= SZX->ZX_VLATU 
				Case SZX->ZX_TPAPL == "POS"
					cArqX->CDBPOS	+= SZX->ZX_VLATU 
				Case SZX->ZX_TPAPL == "BRA"
					cArqX->BRAM		+= SZX->ZX_VLATU 
			EndCase
			MsUnLock()
		Else
			// Grava registros no arquivo temporario
			dbSelectArea("cArqX")
			RecLock("cArqX",.T.)
			cArqX->BANCO	:= SZX->ZX_NOMBCO
			Do Case
				Case SZX->ZX_TPAPL == "PRE"
					cArqX->CDBPRE	:= SZX->ZX_VLATU 
				Case SZX->ZX_TPAPL == "POS"
					cArqX->CDBPOS	:= SZX->ZX_VLATU 
				Case SZX->ZX_TPAPL == "BRA"
					cArqX->BRAM		:= SZX->ZX_VLATU 
			EndCase
			MsUnLock()
			_cBanco	:= SZX->ZX_NOMBCO
		EndIf
	
		Do Case
			Case SZX->ZX_TPAPL == "PRE"
				nTotal1	+= SZX->ZX_VLATU 
			Case SZX->ZX_TPAPL == "POS"
				nTotal2	+= SZX->ZX_VLATU 
			Case SZX->ZX_TPAPL == "BRA"
				nTotal3	+= SZX->ZX_VLATU 
		EndCase
	
		nTotal4 += SZX->ZX_VLATU //Total Geral
		dbSelectArea("SZX")
		dbSkip()
	EndDo
Else
	_cMsg := "Nใo existe movimento para esta data !!!"
	MsgBox(OemToAnsi(_cMsg), "Aviso", "ALERT")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ TOTAL BANCO                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCampos5 :=	{{"BANCO"	, "C", 15, 0, OemToAnsi("Banco")		},;
			{"EM"		, "N", 14, 4, OemToAnsi("Em %")	   		},;
			{"VALOR"	, "N", 14, 2, OemToAnsi("Valor")		},;
			{"QTDEST"	, "N", 14, 2, OemToAnsi("Qtde.Estag")	}}

dbCreate("cArqY",aCampos5)
aNomeArq[2] := "cArqY"
dbUseArea (.T.,,aNomeArq[2],"cArqY", NIL, .F.)
IndRegua("cArqY",aNomeArq[2],"BANCO",,,OemToAnsi("Selecionando Registros..."))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ TOTAL BANCO                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IncProc("TOTAL BANCOS")

DbSelectArea("SZX")
DbSetOrder(1)
DbGotop()
_cBanco		:= ""
_nTotGer	:= 0
If DbSeek(xFilial("SZX")+Dtos(_dDt))
	While Dtos(SZX->ZX_DTFECH) == Dtos(_dDt)

		IF SZX->ZX_TPAPL == "PRV"
			dBSkip()
			Loop
		EndIf

		If SZX->ZX_NOMBCO == _cBanco
			// Grava registros no arquivo temporario
			dbSelectArea("cArqY")
			RecLock("cArqY",.F.)
			cArqY->VALOR	+= SZX->ZX_VLATU 
			cArqY->EM		:= 0
			cArqY->QTDEST	+= 0
			MsUnLock()
		Else
			// Grava registros no arquivo temporario
			dbSelectArea("cArqY")
			RecLock("cArqY",.T.)
			cArqY->BANCO	:= SZX->ZX_NOMBCO
			cArqY->EM		:= 0
			cArqY->VALOR	:= SZX->ZX_VLATU 
			cArqY->QTDEST	:= 0
			MsUnLock()
			_cBanco	:= SZX->ZX_NOMBCO
		EndIf
		
		_nTotGer += SZX->ZX_VLATU
		dbSelectArea("SZX")
		dbSkip()
	EndDo

	dbSelectArea("cArqY")
	dbGotop()

	Do While !EOF()
		dbSelectArea("cArqY")
		RecLock("cArqY",.F.)
		cArqY->EM		:= Round((cArqY->VALOR/_nTotGer)*100,4)
		MsUnLock()
		dbSelectArea("cArqY")
		dbSkip()
	EndDo	

EndIf

CALLCRYS("CRY043", cParams, cOpcoes)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บAutor  ณMicrosiga           บ Data ณ  05/21/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSx1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt     ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid ,var01     ,def01    ,defspa01,defeng01,cnt01 ,var02,def02 ,defspa02,defeng02,cnt02   ,var03,def03      ,defspa03,defeng03,cnt03  ,var04,def04           ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3 ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Mes"       ,""       ,""       ,"mv_ch1","C" ,02 ,00 ,0  ,"G",""    ,"mv_par01",""       ,""      ,""      ,""    ,""   ,""   ,""      ,""      ,""       ,""   ,""         ,""      ,""     ,""     ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"","","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Ano"       ,""       ,""       ,"mv_ch2","C" ,04 ,00 ,0  ,"G",""    ,"mv_par02",""       ,""      ,""      ,""    ,""   ,""   ,""      ,""      ,""       ,""   ,""         ,""      ,""     ,""     ,""   ,""              ,""      ,""      ,""   ,""   ,""     ,""      ,""     ,""   ,"","","","",""})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA11   บAutor  ณMicrosiga           บ Data ณ  06/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImportacao de Extrato Bancario                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MARKDAT()
If aData[oLbx1:nAt,1]
	aData[oLbx1:nAt,1] := .F.
Else
	For _nI := 1 to Len(aData)
		aData[_nI,1] := .F.	
	Next _nI
	aData[oLbx1:nAt,1] := .T.
EndIf
oLbx1:Refresh(.T.)
Return
