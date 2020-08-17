#include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CN120CMP ºAutor  ³ Carlos A. Queiroz  º Data ³  01/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CN120CMP()
Local _aCabCMP  := PARAMIXB[1]
Local _aItemCMP := PARAMIXB[2]

DbSelectArea("SX3")
DbSetOrder(2)

If DbSeek("CN9_XNREDU")
	AAdd(_aCabCMP,x3Titulo())
	Aadd(_aItemCMP,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
EndIf
/*
While TRBCN9->(!Eof())
dbselectarea("CNA")
dbsetorder(3)
If dbseek(xFilial("CNA")+TRBCN9->CN9_NUMERO+TRBCN9->CN9_REVISA)

If !Empty(CNA->CNA_FORNEC)
//		RecLock("TRBCN9",.F.)
//		TRBCN9->CN9_XNREDU := Posicione("SA2",1,xFilial("SA2")+CNA->CNA_FORNEC+CNA->CNA_LJFORN,"A2_NREDUZ")
//		MsUnlock()
ElseIf !Empty(CNA->CNA_CLIENT)
//		RecLock("TRBCN9",.F.)
//		TRBCN9->CN9_XNREDU := Posicione("SA1",1,xFilial("SA1")+CNA->CNA_CLIENT+CNA->CNA_LOJACL,"A1_NREDUZ")
//		MsUnlock()
EndIf

EndIf

TRBCN9->(dbskip())
EndDo
*/
Return({_aCabCMP,_aItemCMP})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN120CMP  ºAutor  ³Microsiga           º Data ³  04/29/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CN120QCC()
local _cQuery  := ""
local _cQuery1 := PARAMIXB[1]
local _cQuery2 := PARAMIXB[2]
local _cQuery3 := PARAMIXB[3]
local _cQuery4 := PARAMIXB[4]
local _cQuery5 := PARAMIXB[5]

_cQuery1 := " SELECT CN9_NUMERO, MAX(CN9_REVISA) AS CN9_REVISA"
_cQuery1 += ", CN9_FILCTR, CN9_XNREDU "
_cQuery1 += " FROM " + RetSqlName("CN9") + " CN9 , "+ RetSqlName("CNN") + " CNN "
_cQuery1 += ", "+ RetSqlName("CPD") + " CPD "
_cQuery1 += " WHERE CN9_SITUAC   = '05' AND CN9_XNREDU = '' AND "
_cQuery1 += " CPD.CPD_FILAUT = '"+cFilAnt+"' AND "
_cQuery1 += " CPD.CPD_CONTRA = CN9.CN9_NUMERO AND "

If GetNewPar("MV_CNFVIGE","N") == "N"
	_cQuery1 += " ('"+DToS(dDataBase)+"' BETWEEN CN9_DTINIC AND CN9_DTFIM )  AND "
EndIf
_cQuery1+= " CNN.CNN_FILIAL = CN9_FILIAL AND "
_cQuery1+= " CNN.CNN_CONTRA = CN9_NUMERO AND "


_cQuery4 := " AND CNN.D_E_L_E_T_	= '' "
_cQuery4 += " AND CN9.D_E_L_E_T_	= '' "
_cQuery4 += " AND CPD.D_E_L_E_T_	= '' "
_cQuery4 += " GROUP BY CN9_NUMERO"

_cQuery4 += ", CN9_FILCTR, CN9_XNREDU "

_cQuery5 := " ORDER BY CN9_NUMERO,CN9_REVISA"

_cQuery5 += ", CN9_FILCTR, CN9_XNREDU "


_cQuery := _cQuery1
_cQuery += _cQuery2+" "+_cQuery4
_cQuery += " UNION "
_cQuery += _cQuery1
_cQuery += _cQuery3+" "+_cQuery4+" "+_cQuery5

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "CN9QRY", .F., .T.)

dbSelectArea("CN9QRY")

While CN9QRY->(!Eof())
	dbselectarea("CNA")
	dbsetorder(3)
	If dbseek(xFilial("CNA")+CN9QRY->CN9_NUMERO+CN9QRY->CN9_REVISA)
		
		If !Empty(CNA->CNA_FORNEC)
			dbselectarea("CN9")
			dbsetorder(1)
			If dbseek(xFilial("CN9")+CN9QRY->CN9_NUMERO+CN9QRY->CN9_REVISA)
				RecLock("CN9",.F.)
				CN9->CN9_XNREDU := Posicione("SA2",1,xFilial("SA2")+CNA->CNA_FORNEC+CNA->CNA_LJFORN,"A2_NREDUZ")
				MsUnlock()
			EndIf
		ElseIf !Empty(CNA->CNA_CLIENT)
			dbselectarea("CN9")
			dbsetorder(1)
			If dbseek(xFilial("CN9")+CN9QRY->CN9_NUMERO+CN9QRY->CN9_REVISA)
				RecLock("CN9",.F.)
				CN9->CN9_XNREDU := Posicione("SA1",1,xFilial("SA1")+CNA->CNA_CLIENT+CNA->CNA_LOJACL,"A1_NREDUZ")
				MsUnlock()
			EndIf
		EndIf
		
	EndIf
	
	CN9QRY->(dbskip())
EndDo

CN9QRY->(DbCloseArea())

_cQuery  := ""
_cQuery1 := PARAMIXB[1]
_cQuery2 := PARAMIXB[2]
_cQuery3 := PARAMIXB[3]
_cQuery4 := PARAMIXB[4]
_cQuery5 := PARAMIXB[5]

_cQuery1 := " SELECT CN9_NUMERO, MAX(CN9_REVISA) AS CN9_REVISA"
_cQuery1 += ", CN9_FILCTR, CN9_XNREDU "
_cQuery1 += " FROM " + RetSqlName("CN9") + " CN9 , "+ RetSqlName("CNN") + " CNN "
_cQuery1 += ", "+ RetSqlName("CPD") + " CPD "
_cQuery1 += " WHERE CN9_SITUAC   = '05' AND "
_cQuery1 += " CPD.CPD_FILAUT = '"+cFilAnt+"' AND "
_cQuery1 += " CPD.CPD_CONTRA = CN9.CN9_NUMERO AND "

If GetNewPar("MV_CNFVIGE","N") == "N"
	_cQuery1 += " ('"+DToS(dDataBase)+"' BETWEEN CN9_DTINIC AND CN9_DTFIM )  AND "
EndIf
_cQuery1+= " CNN.CNN_FILIAL = CN9_FILIAL AND "
_cQuery1+= " CNN.CNN_CONTRA = CN9_NUMERO AND "


_cQuery4 := " AND CNN.D_E_L_E_T_	= '' "
_cQuery4 += " AND CN9.D_E_L_E_T_	= '' "
_cQuery4 += " AND CPD.D_E_L_E_T_	= '' "
_cQuery4 += " GROUP BY CN9_NUMERO"

_cQuery4 += ", CN9_FILCTR, CN9_XNREDU "

_cQuery5 := " ORDER BY CN9_NUMERO,CN9_REVISA"

_cQuery5 += ", CN9_FILCTR, CN9_XNREDU "


_cQuery := _cQuery1
_cQuery += _cQuery2+" "+_cQuery4
_cQuery += " UNION "
_cQuery += _cQuery1
_cQuery += _cQuery3+" "+_cQuery4+" "+_cQuery5

Return _cQuery