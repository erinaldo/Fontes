#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"


User Function AjusAP()

Private _aSE2	:= {}
Private _aSE5	:= {}

Processa({||Md2Alter()}, "Ajusta Numero da AP", "Validacao dos dados, aguarde...")

Return

Static Function Md2Alter()
/*
********************************************************************************************************************************************
*/
//CONTAS A PAGAR
_cQuery	:= "SELECT COUNT(E2_NUMAP), E2_NUMAP "
_cQuery	+= "FROM "+RetSqlName("SE2")+ " "
_cQuery	+= "WHERE D_E_L_E_T_ <> '*' "
_cQuery	+= "AND E2_NUMAP <> '' "
_cQuery	+= "GROUP BY E2_NUMAP "
_cQuery	+= "HAVING COUNT(E2_NUMAP) > 10 "
_cQuery	+= "ORDER BY E2_NUMAP "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SE2TRB',.T.,.T.)

DbSelectarea("SE2TRB")
SE2TRB->(dbGoTop())
ProcRegua(RecCount())

Do While !EOF()

	IncProc("Processando registros DUPLICADOS...SE2")
	
	_cQuery := "SELECT * "
	_cQuery += "FROM "+RetSqlName("SE2")+ " "
	_cQuery += "WHERE E2_NUMAP = '"+SE2TRB->E2_NUMAP+"' "
	_cQuery += "ORDER BY E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SE2AJS',.T.,.T.)

	DbSelectarea("SE2AJS")
	SE2AJS->(dbGoTop())	
	ProcRegua(RecCount())

	Do While !EOF()

		IncProc("Processando NUMAP... SE2 "+SE2TRB->E2_NUMAP )
		
		DbSelectArea("SEF")
		DbSetOrder(8) //EF_FILIAL+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_FORNECE+EF_LOJA
		If DbSeek(xFilial("SEF")+ SE2AJS->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) )
			_cNumAp	:= SE2AJS->E2_NUMAP
			_cNumCq	:= SEF->EF_NUM
			_cConta	:= SEF->EF_CONTA
			_nValor	:= Str(SEF->EF_VALOR,14,2)
			DbSetOrder(1)
			DbSkip() // vai para o proximo registro
			If SEF->(EF_NUM+EF_CONTA+Str(SEF->EF_VALOR,14,2)) == _cNumCq+_cConta+_nValor
				If _cNumAp <> SEF->EF_NUMAP
					DbSelectArea("SE2")
					DbSetOrder(1)
					If DbSeek(xFilial("SE2")+ SE2AJS->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
						RecLock("SE2",.F.)
						SE2->E2_NUMAP	:= SEF->EF_NUMAP
						SE2->E2_BAIXA	:= SEF->EF_DATA
						MsUnlock()
						Aadd(_aSE2,SE2AJS->E2_NUMAP)
					EndIf
				EndIf
			EndIf
		EndIf

		DbSelectarea("SE2AJS")
		SE2AJS->(DbSkip())	
	EndDo

	DbSelectarea("SE2AJS")
	SE2AJS->(DbCloseArea())	

	DbSelectarea("SE2TRB")
	SE2TRB->(DbSkip())
EndDo

DbSelectarea("SE2TRB")
SE2TRB->(DbCloseArea())
/*
_nArqSE2 := fCreate("H:\Protheus_Data\1TOTVS\NUMAP\SE2.TXT")
For _nI := 1 to len(_aSE2)
	fWrite(_nArqSE2, _aSE2[_nI] + chr(10)+chr(13) , 30)
Next
*/
/*
********************************************************************************************************************************************
*/
//MOVIMENTACAO BANCARIO

_cQuery	:= "SELECT COUNT(E5_NUMAP), E5_NUMAP "
_cQuery	+= "FROM "+RetSqlName("SE5")+ " "
_cQuery	+= "WHERE D_E_L_E_T_ <> '*' "
_cQuery	+= "AND E5_NUMAP <> '' "
_cQuery	+= "GROUP BY E5_NUMAP "
_cQuery	+= "HAVING COUNT(E5_NUMAP) > 10 "
_cQuery	+= "ORDER BY E5_NUMAP "
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SE5TRB',.T.,.T.)

DbSelectarea("SE5TRB")
SE5TRB->(dbGoTop())
ProcRegua(RecCount())

Do While !EOF()

	IncProc("Processando registros DUPLICADOS...SE5")
	
	_cQuery := "SELECT * "
	_cQuery += "FROM "+RetSqlName("SE5")+ " "
	_cQuery += "WHERE E5_NUMAP = '"+SE5TRB->E5_NUMAP+"' "
	_cQuery += "ORDER BY E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'SE5AJS',.T.,.T.)

	DbSelectarea("SE5AJS")
	SE5AJS->(dbGoTop())	
	ProcRegua(RecCount())

	Do While !EOF()

		IncProc("Processando NUMAP... SE5 "+SE5TRB->E5_NUMAP )
		
		DbSelectArea("SEF")
		DbSetOrder(8) //EF_FILIAL+EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+EF_FORNECE+EF_LOJA
		If DbSeek(xFilial("SEF")+ SE5AJS->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) )
			_cNumAp	:= SE5AJS->E5_NUMAP
			_cNumCq	:= SEF->EF_NUM
			_cConta	:= SEF->EF_CONTA
			_nValor	:= Str(SEF->EF_VALOR,14,2)
			DbSetOrder(1)
			DbSkip() // vai para o proximo registro
			If SEF->(EF_NUM+EF_CONTA+Str(SEF->EF_VALOR,14,2)) == _cNumCq+_cConta+_nValor
				If _cNumAp <> SEF->EF_NUMAP
					DbSelectArea("SE5")
					DbSetOrder(7)
					If DbSeek(xFilial("SE5")+ SE5AJS->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
						RecLock("SE5",.F.)
						SE5->E5_NUMAP	:= SEF->EF_NUMAP
						MsUnlock()
						Aadd(_aSE5,SE5AJS->E5_NUMAP)
					EndIf
				EndIf
			EndIf
		EndIf

		DbSelectarea("SE5AJS")
		SE5AJS->(DbSkip())	
	EndDo

	DbSelectarea("SE5AJS")
	SE5AJS->(DbCloseArea())	

	DbSelectarea("SE5TRB")
	SE5TRB->(DbSkip())
EndDo

DbSelectarea("SE5TRB")
SE5TRB->(DbCloseArea())
/*
_nArqSE5 := fCreate("H:\Protheus_Data\1TOTVS\NUMAP\SE5.TXT")
For _nI := 1 to len(_aSE5)
	fWrite(_nArqSE5, _aSE5[_nI] + chr(10)+chr(13) , 30)
Next
*/
Return

/*

//AS QUERYS ABAIXO SAO PARA VERIFICAR A QUANTIDADE DE PROBLEMAS NAS TABELAS E DEPOIS FAZER UPDATE

SELECT COUNT(E5_NUMAP), E5_NUMAP
FROM SE5010
WHERE D_E_L_E_T_ <> '*'
AND E5_NUMAP <> ''
GROUP BY E5_NUMAP
HAVING COUNT(E5_NUMAP) > 1
ORDER BY E5_NUMAP

SELECT COUNT(E2_NUMAP), E2_NUMAP
FROM SE2010
WHERE D_E_L_E_T_ <> '*'
AND E2_NUMAP <> ''
GROUP BY E2_NUMAP
HAVING COUNT(E2_NUMAP) > 1
ORDER BY E2_NUMAP

SELECT SEF.EF_BANCO, SEF.EF_AGENCIA, SEF.EF_CONTA, SEF.EF_BENEF, SEF.EF_VALOR, SEF.EF_DATA, SEF.EF_NUMAP, SE2.E2_NUMAP, 
SE2.E2_NUMBOR, SE2.E2_FL, SE2.E2_TIPO, SE2.E2_NUM, SE2.E2_PREFIXO, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_RAZSOC, 
SE2.E2_VALOR, SE2.E2_EMISSAO, SE2.E2_VENCTO, SE2.E2_PORTADO, SEF.EF_NUM, SE2.E2_NUMBCO, SE2.E2_BAIXA
FROM SE2010 SE2, SEF010 SEF
WHERE SE2.E2_NUMAP = '110875'
--AND SEF.EF_NUMAP <> '110875'
AND SEF.EF_NUMAP <> ''
AND SE2.E2_NUMBCO = SEF.EF_NUM
AND SE2.E2_VALOR = SEF.EF_VALOR

UPDATE SE2010 SET E2_NUMAP = EF_NUMAP
FROM SE2010, SEF010
WHERE E2_NUMAP = '040325'
AND EF_NUMAP <> '040325'
AND EF_NUMAP <> ''
AND E2_NUMBCO = EF_NUM
AND E2_VALOR = EF_VALOR
*/