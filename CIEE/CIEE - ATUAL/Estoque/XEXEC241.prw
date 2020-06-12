# include "rwmake.ch"
# include "Topconn.ch"
# include "PROTHEUS.CH"

User Function XEXEC241()

ALERT("INICIO")

aCab	:= {}
aItem 	:= {}
aTotItens 	:= {}
_nQtde	:= 0
cCR		:= ""
lMsErroAuto := .f.

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST"

aCab:={	{"D3_TM"		,"501"		,NIL},;
		{"D3_EMISSAO"	,dDataBase	,NIL}}

For i := 1 To 1
/*	
	AADD(aItem,{	{"D3_COD"		,"01.0.001"			, NIL},;
					{"D3_UM"		,"UN"				, NIL},;
					{"D3_QUANT"		,1					, NIL},;
					{"D3_LOCAL"		,"01"				, NIL},;
					{"D3_LOTECTL"	,""					, NIL}})
*/

	aItem	:=	{	{"D3_COD"		,"01.0.001"	,NIL},;
					{"D3_UM"     	,"UN"   	,NIL},;
					{"D3_QUANT"	 	,1	    	,NIL},;
					{"D3_LOCAL"  	,"01"		,NIL},;
					{"D3_LOTECTL"	,""			,NIL}}



Next i

//MATA241(aCab,aItem,3)

//If lMsErroAuto
//	MostraErro()
//EndIf


aadd(aTotItens, aItem)

//If len(aTotItens) > 0
//	Begin Transaction
	MSEXECAUTO({|x,y,z| MATA241(x,y,z)}, aCab, aTotItens,3)
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
		break
	EndIf
//	End Transaction
//EndIf

ALERT("FIM")

Return