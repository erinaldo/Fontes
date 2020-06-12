#include "rwmake.ch"

User Function TSTEME()

Local _cArea		:= GetArea()
Local cPerg			:= "TSTEME"
Local cChave		:= ""
Local cFileTRB		:= ""

Local _aProdut		:= {}
Local _aProd		:= {}
Local _aFornec		:= {}
Local _aForn		:= {}
Local aCompCot		:= {}
Local aCampos		:= {}

PutSx1(cPerg,"01","Crit. Filtro","","","mv_ch1","N",1,0,0,"C","naovazio()","","","","mv_par01","Processo","","","","Cotacao","","","","","","","","","","","",{{""}},{{""}},{{""}},"")
PutSx1(cPerg,"02","Processo"    ,"","","mv_ch2","C",1,0,0,"G",""          ,"","","","mv_par02",""        ,"","","",""       ,"","","","","","","","","","","",{{""}},{{""}},{{""}},"")

if !Pergunte(cPerg,.T.)
	MsgAlert("Cancelado pelo operador !")
	RestArea(_cArea)
	Return
endif

DbSelectArea("SC8")
DbSetOrder(1)

cQry	:= " SELECT " + chr(13)
cQry	+= " C8_PRODUTO, " + chr(13)
cQry	+= " C8_FORNECE, " + chr(13)
cQry	+= " C8_LOJA, " + chr(13)
cQry	+= " C8_NUM, " + chr(13)
cQry	+= " C8_ITEM, " + chr(13)
cQry	+= " C8_UM, " + chr(13)
cQry	+= " C8_QUANT, " + chr(13)
cQry	+= " C8_PRECO " + chr(13)
cQry	+= "FROM " + RetSqlName("SC8") + chr(13)

if mv_par01 = 1
	cQry	+= " WHERE C8_NUM = '"+SC8->C8_NUM + "' " + chr(13)
else
	cQry	+= " WHERE C8_NUM = '"+SC8->C8_NUM + "' " + chr(13)
EndIf

cQry	+= " AND D_E_L_E_T_ <> '*' " + chr(13)
cQry	+= " ORDER BY C8_PRODUTO, C8_FORNECE, C8_LOJA " + chr(13)

If chkfile("TRB")
	TRB->(DbCloseArea())
EndIf

cQry	:= ChangeQuery(cQry)
DbUseArea(.T.,"TOPCONN", TcGenQry(,,cQry), "TRB", .T., .F.)

TRB->(DbGotop())

if TRB->(EOF())
	MsgAlert("Nao ha dados para exportacao !")
	RestArea(_cArea)
	Return
EndIf

While TRB->(EOF())
	AADD(_aProdut,TRB->C8_PRODUTO)
	AADD(_aFornec,( TRB->C8_FORNECE + TRB->C8_LOJA ))
	TRB->(DbSkip())
EndDo

if Len(_aProdut) > 1
	aSort(_aProdut)
	AADD(_aProd, _aProdut[1] )
	b	:= 1
	
	for a:= 1 to len(_aProdut)
		If _aProd[b] <> _aProdut[a]
			AADD(_aProd, _aProdut[a])
			b++
		EndIf
	next
	
	_aProdut := {}
	_aProdut := aClone(_aProd)
endif


if Len(_aFornec) > 1
	aSort(_aFornec)
	AADD(_aForn, _aFornec[1] )
	b	:= 1
	
	for a:= 1 to len(_aFornec)
		If _aForn[b] <> _aFornec[a]
			AADD(_aForn, _aFornec[a])
			b++
		EndIf
	next
	
	_aFornec := {}
	_aFornec := aClone(_aForn)
endif

aCompCot	:= Array(len(_aProdut), len(_aFornec) )

DbSelectArea("TRB")
aCampos	:= TRB->(dbStruct())
cArqTmp	:= CriaTrab(aCampos,.T.)
IndRegua("TRB", cArqTmp, "C8_PRODUTO+C8_FORNECE+C8_LOJA",,,"Selecionando Registros...",.t.)

For a	:= 1 to len(_aProdut)
	For b	:= 1 to len(_aFornec)
		If TRB->(DbSeek(_aProdut[a] + _aFornec[b]))
			aCompCot[a,b]	:= TRB->C8_PRECO
		Else
			aCompCot[a,b]	:= 0
		EndIf
	Next b
Next a


MsgAlert("parou")

RestArea(_cArea)

Return