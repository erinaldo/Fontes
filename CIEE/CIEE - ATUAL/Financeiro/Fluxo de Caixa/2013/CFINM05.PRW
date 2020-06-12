#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA100ROT º Autor ³ Andy               º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para Acoes Relacionadas da Movimentacao   º±±
±±º          ³ Bancaria FINA100                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function FA100ROT()
Local aMat := {}
aMat:=PARAMIXB[1]
Aadd(aMat, { "Lib.Docto Contabilidade","U_CFINM05", 0 , 5})

Return(aMat)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINM05   º Autor ³ Andy               º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio FIN CTB                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINM05()
//U_CFINC05()
U_CFINR05()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINC05   º Autor ³ Andy               º Data ³  17/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio FIN CTB                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINC05()

Local cTabSE2	:= RetSqlName('SE2')
Local cTabSE5	:= RetSqlName('SE5')
Local cFilSE2	:= xFilial("SE2")
Local cFilSE5	:= xFilial("SE5")
Local aPags		:= {}
Local cQuery	:= ""
Local aArea		:= GetArea()

cQuery:=""
cQuery+=" ORDER BY E5_DATA, DOCUMENTO "

TcQuery cQuery New Alias (cAlias:=GetNextAlias())

While (cAlias)->(!Eof())
	aAdd(aPags,{(cAlias)->EMISSAO, (cAlias)->FORNECEDOR, (cAlias)->DOCUMENTO, (cAlias)->VENCIMENTO, (cAlias)->VALOR, (cAlias)->BANCO, (cAlias)->CONTA})
	(cAlias)->(dbSkip())
Enddo

(cAlias)->(dbCloseArea())

If Len(aPags) > 0
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 300,778 TITLE "Movimentação Bancária " PIXEL
	@ 05,05 LISTBOX oLbx1 FIELDS HEADER "EMISSAO" , "FORNECEDOR", "DOCUMENTO", "VENCIMENTO", "VALOR", "BANCO", "CONTA CORRENTE"  SIZE 345, 85 OF oDlg PIXEL
	//	ON DBLCLICK (U_MARKSZ8())
	
	oLbx1:SetArray(aPags)
	oLbx1:bLine := { || {aPags[oLbx1:nAt,1], aPags[oLbx1:nAt,2], aPags[oLbx1:nAt,3], aPags[oLbx1:nAt,4], Transform(aPags[oLbx1:nAt,5],"@E 999,999,999.99"), aPags[oLbx1:nAt,6], aPags[oLbx1:nAt,7] } }
	//	oLbx1:nFreeze  := 1
	
	oLbx1:Refresh(.T.)
	
	DEFINE SBUTTON FROM 94, 292 TYPE 6  ENABLE OF oDlg ACTION (U_CFINR05()          ,oDlg:End() ) //type 6 = imprimir
	DEFINE SBUTTON FROM 94, 320 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.           ,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	MsgInfo("Não Há Registros!","Atenção")
Endif

RestArea(aArea)


Return


/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| CFINR05     		 | Autor   |  AF Custom           | Data   |    09/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Descricao 	| Relatorio Demonstrativo x Fluxo de Caixa                                       |
+---------------+--------------------------------------------------------------------------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function CFINR05()
Local 	oReport
Private _lSair
While .T.
	_lSair:= .T.
	If TRepInUse()
		CRIASX1()
		pergunte("CFINR05XXX",.F.)
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
	If _lSair
		Exit
	EndIf
EndDo
Return


/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| ReportDef()  		 | Autor   |  AF Custom           | Data   |    05/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
Static Function ReportDef()
Local oReport
Local oSection

oReport:= TReport():New("CFINR05","Liberação de Documento à Contabilidade","CFINR05XXX",{|oReport| PrintReport(oReport)},"Liberação de Documento à Contabilidade")
oReport:SetPortrait(.T.)
oReport:DisableOrientation()
oSection := TRSection():New(oReport,"Liberação de Documento à Contabilidade","SE5")

Return oReport

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| PrintReport() 	 | Autor   |  AF Custom           | Data   |    05/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
Static Function PrintReport(oReport)

Local cTabSE2	:= RetSqlName('SE2')
Local cTabSE5	:= RetSqlName('SE5')
Local cFilSE2	:= xFilial("SE2")
Local cFilSE5	:= xFilial("SE5")
Local aPags		:= {}
Local cQuery	:= ""
Local aArea		:= GetArea()

Local oSection  := oReport:Section(1)
Local cQuery	:= ''
Local cAlias	:= ''
Local nX		:= 0
Local nLen		:= 0
Local _lVazio	:=.F.

Private _nLinDad	:= 1

//---------------------------------------------------------------------------
// Montando Query com Select e Union em SE5 e SE2 indicado pelos mv_par...
//---------------------------------------------------------------------------

If MV_PAR09 == 1 // FL
	cQuery:=" SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, RTRIM(LTRIM(E5_PREFIXO)) + ' ' + RTRIM(LTRIM(E5_NUMERO)) AS DOCUMENTO, E2_VENCREA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA "
	cQuery+=" FROM " + cTabSE5
	cQuery+=" INNER JOIN " + cTabSE2 + " ON "
	cQuery+=" E5_FILIAL	 = E2_FILIAL 	AND "
	cQuery+=" E5_TIPO 	 = E2_TIPO 		AND "
	cQuery+=" E5_NUMERO  = E2_NUM 		AND "
	cQuery+=" E5_PREFIXO = E2_PREFIXO 	AND "
	cQuery+=" E5_CLIFOR  = E2_FORNECE 	AND "
	cQuery+=" E5_LOJA 	 = E2_LOJA          "
	cQuery+=" WHERE E2_VENCREA 	BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'" // '20130104'
	cQuery+=" AND	E5_CLIFOR  	BETWEEN '" + MV_PAR03 		+ "' AND '" + MV_PAR04 + "'"
	cQuery+=" AND	E5_BANCO 	BETWEEN '" + MV_PAR05 		+ "' AND '" + MV_PAR06 + "'"
	cQuery+=" AND	E5_CONTA 	BETWEEN '" + MV_PAR07 		+ "' AND '" + MV_PAR08 + "'"
	cQuery+=" AND 	E5_RECPAG = 'P' "
//	cQuery+=" AND 	E5_RECPAG = 'P' AND E5_RECONC ='x' "	
	cQuery+=" AND NOT (E5_DOCUMEN LIKE '%DIF CARTA%') "
	cQuery+=" AND (E5_TIPO LIKE '%FL%' AND (E5_PREFIXO LIKE '%FL%' OR E5_PREFIXO LIKE '%FLI%')) "
	cQuery+=" AND "+cTabSE2+".D_E_L_E_T_=' ' "
	cQuery+=" AND "+cTabSE5+".D_E_L_E_T_=' ' "
EndIf
If MV_PAR10 == 1 // TED
	If Empty(cQuery)
		cQuery:=" SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, E5_NUMCHEQ AS DOCUMENTO, E5_DATA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA "
	Else
		cQuery+=" UNION ALL "
		cQuery+=" SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, E5_NUMCHEQ AS DOCUMENTO, E5_DATA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA "
	EndIf
	cQuery+=" FROM " + cTabSE5
	cQuery+=" WHERE E5_DATA 	BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"
	cQuery+=" AND	E5_CLIFOR  	BETWEEN '" + MV_PAR03 		+ "' AND '" + MV_PAR04 + "'"
	cQuery+=" AND	E5_BANCO 	BETWEEN '" + MV_PAR05 		+ "' AND '" + MV_PAR06 + "'"
	cQuery+=" AND	E5_CONTA 	BETWEEN '" + MV_PAR07 		+ "' AND '" + MV_PAR08 + "'"
	cQuery+=" AND 	E5_RECPAG = 'P' "
//	cQuery+=" AND 	E5_RECPAG = 'P' AND E5_RECONC ='x' "	
	cQuery+=" AND NOT (E5_DOCUMEN LIKE '%DIF CARTA%') "
	cQuery+=" AND (E5_MOEDA LIKE '%TR%' OR E5_MOEDA LIKE '%TE%') AND (E5_NATUREZ LIKE '%6.04.01%' OR E5_NATUREZ LIKE '%33040101%') "
	cQuery+=" AND "+cTabSE5+".D_E_L_E_T_=' ' "
EndIf

If MV_PAR11 == 1 // CARTA
	If Empty(cQuery)
		cQuery:=" SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, E5_DOCUMEN AS DOCUMENTO, E5_DATA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA "
	Else
		cQuery+=" UNION ALL "
		cQuery+=" SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, E5_DOCUMEN AS DOCUMENTO, E5_DATA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA "
	EndIf
	cQuery+=" FROM " + cTabSE5
	cQuery+=" WHERE E5_DATA 	BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"
	cQuery+=" AND	E5_CLIFOR  	BETWEEN '" + MV_PAR03 		+ "' AND '" + MV_PAR04 + "'"
	cQuery+=" AND	E5_BANCO 	BETWEEN '" + MV_PAR05 		+ "' AND '" + MV_PAR06 + "'"
	cQuery+=" AND	E5_CONTA 	BETWEEN '" + MV_PAR07 		+ "' AND '" + MV_PAR08 + "'"
	cQuery+=" AND 	E5_RECPAG = 'P' "
//	cQuery+=" AND 	E5_RECPAG = 'P' AND E5_RECONC ='x' "	
	cQuery+=" AND 	E5_XTIPO = 'A1' "
	cQuery+=" AND NOT (E5_DOCUMEN LIKE '%DIF CARTA%') "
	cQuery+=" AND E5_MOEDA LIKE '%BA%' "
	cQuery+=" AND "+cTabSE5+".D_E_L_E_T_=' ' "
EndIf
If MV_PAR12 == 1 // AP
	If Empty(cQuery)
		cQuery:=" SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, 'AP ' + E5_NUMAP AS DOCUMENTO, E5_DTDISPO AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA "
	Else
		cQuery+=" UNION ALL "
		cQuery+=" SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, 'AP ' + E5_NUMAP AS DOCUMENTO, E5_DTDISPO AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA "
	EndIf
	cQuery+=" FROM " + cTabSE5
	cQuery+=" WHERE E5_DATA 	BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"
	cQuery+=" AND	E5_CLIFOR  	BETWEEN '" + MV_PAR03 		+ "' AND '" + MV_PAR04 + "'"
	cQuery+=" AND	E5_BANCO 	BETWEEN '" + MV_PAR05 		+ "' AND '" + MV_PAR06 + "'"
	cQuery+=" AND	E5_CONTA 	BETWEEN '" + MV_PAR07 		+ "' AND '" + MV_PAR08 + "'"
//	cQuery+=" AND 	E5_RECPAG = 'P' AND E5_RECONC ='x' "
	cQuery+=" AND 	E5_RECPAG = 'P' "
	cQuery+=" AND 	E5_SITUACA <> 'C' "	
	cQuery+=" AND 	E5_TIPODOC = 'CH' "
	cQuery+=" AND NOT (E5_DOCUMEN LIKE '%DIF CARTA%') "
	cQuery+=" AND E5_NUMAP <> '' AND E5_NUMCHEQ <> '' "
	cQuery+=" AND "+cTabSE5+".D_E_L_E_T_=' ' "
EndIf
If MV_PAR13 == 1 // BORDERO
	If Empty(cQuery)
		cQuery:=" SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, 'BORD '+ E5_DOCUMEN AS DOCUMENTO, E2_VENCREA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA "
	Else
		cQuery+=" UNION ALL "
		cQuery+=" SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, 'BORD '+ E5_DOCUMEN AS DOCUMENTO, E2_VENCREA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA "
	EndIf
	cQuery+=" FROM " + cTabSE5
	cQuery+=" INNER JOIN " + cTabSE2 + " ON "
	cQuery+=" E5_FILIAL	 = E2_FILIAL 	AND "
	cQuery+=" E5_TIPO 	 = E2_TIPO 		AND "
	cQuery+=" E5_NUMERO  = E2_NUM 		AND "  
	cQuery+=" E5_PARCELA = E2_PARCELA   AND "
	cQuery+=" E5_PREFIXO = E2_PREFIXO 	AND "
	cQuery+=" E5_CLIFOR  = E2_FORNECE 	AND "
	cQuery+=" E5_LOJA 	 = E2_LOJA          "
	cQuery+=" WHERE E2_VENCREA 	BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"
	cQuery+=" AND	E5_CLIFOR  	BETWEEN '" + MV_PAR03 		+ "' AND '" + MV_PAR04 + "'"
	cQuery+=" AND	E5_BANCO 	BETWEEN '" + MV_PAR05 		+ "' AND '" + MV_PAR06 + "'"
	cQuery+=" AND	E5_CONTA 	BETWEEN '" + MV_PAR07 		+ "' AND '" + MV_PAR08 + "'"
	cQuery+=" AND 	E5_RECPAG = 'P' AND E5_RECONC ='x' "
	cQuery+=" AND NOT (E5_DOCUMEN LIKE '%DIF CARTA%') "
	cQuery+=" AND E5_DOCUMEN <> '' AND E5_TIPODOC IN ('VL','CH','BA') "
	cQuery+=" AND "+cTabSE2+".D_E_L_E_T_=' ' "
	cQuery+=" AND "+cTabSE5+".D_E_L_E_T_=' ' "	
EndIf

If Empty(cQuery)
	_lVazio:=.T.
Else
	cQuery+=" ORDER BY E5_DATA, DOCUMENTO "
	TcQuery cQuery New Alias (cAlias:=GetNextAlias())
EndIf

//-----------------------------------------------------------------------
// Montando Matriz de Impressão _aMatImp baseado no resultado do Query
//-----------------------------------------------------------------------
_aMatImp := {}

If !_lVazio
	
	If MV_PAR14 == 1 // Sintetico

		//	AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil,Nil,Nil})
		_nTotal := 0
		While (cAlias)->(!Eof())
				AADD(_aMatImp,{	SubStr((cAlias)->EMISSAO,7,2)+"/"+SubStr((cAlias)->EMISSAO,5,2)+"/"+SubStr((cAlias)->EMISSAO,1,4),;
				(cAlias)->FORNECEDOR,;
				(cAlias)->DOCUMENTO,;
				SubStr((cAlias)->VENCIMENTO,7,2)+"/"+SubStr((cAlias)->VENCIMENTO,5,2)+"/"+SubStr((cAlias)->VENCIMENTO,1,4),;
				(cAlias)->VALOR,;
				(cAlias)->BANCO,;
				(cAlias)->CONTA})
				
				_nTotal+=(cAlias)->VALOR
				
				(cAlias)->(dbSkip())
		Enddo
		AADD(_aMatImp,{ Nil, Nil, Nil, Nil, Nil, Nil, Nil })
		AADD(_aMatImp,{	Nil, "Total", Nil, Nil,	_nTotal, Nil, Nil })
		AADD(_aMatImp,{ Nil, Nil, Nil, Nil, Nil, Nil, Nil })
		
		(cAlias)->(dbCloseArea())
		
	Else
		
		//	AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil,Nil,Nil})
		_nTotal := 0
		While (cAlias)->(!Eof())
			If SubStr((cAlias)->DOCUMENTO,1,4) == "BORD"
				_nKonta   := 0
				_nBordero := 0
				_cBordero := (cAlias)->DOCUMENTO
				While (cAlias)->(!Eof()) .And. _cBordero == (cAlias)->DOCUMENTO
					AADD(_aMatImp,{	SubStr((cAlias)->EMISSAO,7,2)+"/"+SubStr((cAlias)->EMISSAO,5,2)+"/"+SubStr((cAlias)->EMISSAO,1,4),;
					(cAlias)->FORNECEDOR,;
					(cAlias)->DOCUMENTO,;
					SubStr((cAlias)->VENCIMENTO,7,2)+"/"+SubStr((cAlias)->VENCIMENTO,5,2)+"/"+SubStr((cAlias)->VENCIMENTO,1,4),;
					(cAlias)->VALOR,;
					(cAlias)->BANCO,;
					(cAlias)->CONTA})
					
					_nKonta+=1
					_nTotal+=(cAlias)->VALOR
					_nBordero+=(cAlias)->VALOR
					
					(cAlias)->(dbSkip())
				EndDo
				
				If _nKonta > 1
					AADD(_aMatImp,{	Nil, "Total Bordero", Nil, Nil,	_nBordero, Nil, Nil })
					AADD(_aMatImp,{ Nil, Nil, Nil, Nil, Nil, Nil, Nil})
				EndIf
			Else
				AADD(_aMatImp,{	SubStr((cAlias)->EMISSAO,7,2)+"/"+SubStr((cAlias)->EMISSAO,5,2)+"/"+SubStr((cAlias)->EMISSAO,1,4),;
				(cAlias)->FORNECEDOR,;
				(cAlias)->DOCUMENTO,;
				SubStr((cAlias)->VENCIMENTO,7,2)+"/"+SubStr((cAlias)->VENCIMENTO,5,2)+"/"+SubStr((cAlias)->VENCIMENTO,1,4),;
				(cAlias)->VALOR,;
				(cAlias)->BANCO,;
				(cAlias)->CONTA})
				
				_nTotal+=(cAlias)->VALOR
				
				(cAlias)->(dbSkip())
			EndIf
		Enddo
		AADD(_aMatImp,{ Nil, Nil, Nil, Nil, Nil, Nil, Nil })
		AADD(_aMatImp,{	Nil, "Total", Nil, Nil,	_nTotal, Nil, Nil })
		AADD(_aMatImp,{ Nil, Nil, Nil, Nil, Nil, Nil, Nil })
		
		(cAlias)->(dbCloseArea())
		
	EndIf
	
EndIf

If Len(_aMatImp) <> 0
	
	_cTitle:="Liberação de Documentos à Contabilidade - " + Iif(MV_PAR14==1,"(Sintético)","(Analítico)")
	oReport:SetTitle(Alltrim(_cTitle))
	
	TRCell():New(oSection,"EMISSAO"			,"", "Emissão "				,/*Picture*/			,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,1]  	})
	TRCell():New(oSection,"FORNECEDOR"		,"", "Fornecedor "			,/*Picture*/			,30		,/*lPixel*/,{|| _aMatImp[_nLinDad,2]  	})
	TRCell():New(oSection,"DOCUMENTO"		,"", "Documento "			,/*Picture*/			,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,3]  	})
	TRCell():New(oSection,"VENCIMENTO"		,"", "Vencimento "			,/*Picture*/			,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,4]  	})
	TRCell():New(oSection,"VALOR"			,"", "Valor"				,"@)E 999,999,999.99"	,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,5]  	},,,"RIGHT")
	TRCell():New(oSection,"BANCO"			,"", "Banco"				,/*Picture*/			,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,6]  	})
	TRCell():New(oSection,"CONTA CORRENTE"	,"", "Conta Corrente"		,/*Picture*/			,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,7]  	})
	
	oSection:Init()
	nLen:=Len(_aMatImp)
	For nX:=1 to nLen
		//		If !Empty(_aMatImp[nX,2])
		//        	If SubStr(_aMatImp[nX,2],1,5) == "Total"
		//				oReport:Line( oReport:Row(), oSection:Cell(5):ColPos(), oReport:Row(),  oSection:Cell(6):ColPos() )
		//			EndIf
		//		EndIf
		_nLinDad:=nX
		oSection:PrintLine()
	Next nX
	
	oSection:Finish()
	
EndIf

_lSair := .F.

Return



/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| CriaSx1()      	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
Static Function CriaSx1()

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0
Local aRegs		:= {}
Local cPerg		:= "CFINR05XXX"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Monta array com as perguntas

aAdd(aRegs,{cPerg,"01","Vencimento De   ","","","mv_ch1","D",8,0,0,"G","","MV_PAR01","",			"",	"",	"",	"",	"", 			"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Vencimento Ate  ","","","mv_ch2","D",8,0,0,"G","","MV_PAR02","",			"",	"",	"",	"",	"", 			"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Fornecedor De   ","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","",			"",	"",	"",	"",	"", 			"",	"",	"", "", "","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegs,{cPerg,"04","Fornecedor Ate  ","","","mv_ch4","C",6,0,0,"G","","MV_PAR04","",			"",	"",	"",	"",	"", 			"",	"",	"", "", "","","","","","","","","","","","","","","SA2","","","",""})
aAdd(aRegs,{cPerg,"05","Banco De        ","","","mv_ch5","C",3,0,0,"G","","MV_PAR05","",			"",	"",	"",	"",	"", 			"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Banco Ate       ","","","mv_ch6","C",3,0,0,"G","","MV_PAR06","",			"",	"",	"",	"",	"", 			"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Conta De   		","","","mv_ch7","C",10,0,0,"G","","MV_PAR07","",			"",	"",	"",	"",	"", 			"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Conta Ate  		","","","mv_ch8","C",10,0,0,"G","","MV_PAR08","",			"",	"",	"",	"",	"", 			"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","FL	         	","","","mv_ch9","C",1,0,0,"C","","MV_PAR09","Sim",			"",	"",	"",	"", "Não",			"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","TED         	","","","mv_cha","C",1,0,0,"C","","MV_PAR10","Sim",			"",	"",	"",	"", "Não",			"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","CARTA         	","","","mv_chb","C",1,0,0,"C","","MV_PAR11","Sim",			"",	"",	"",	"", "Não",			"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","AP         		","","","mv_chc","C",1,0,0,"C","","MV_PAR12","Sim",			"",	"",	"",	"", "Não",			"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","BORDERO        	","","","mv_chd","C",1,0,0,"C","","MV_PAR13","Sim",			"",	"",	"",	"", "Não",			"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"14","Tipo        	","","","mv_che","C",1,0,0,"C","","MV_PAR14","Sintetico",	"",	"",	"",	"", "Analitico",	"",	"",	"", "", "","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)

Return(Nil)


/*

SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, RTRIM(LTRIM(E5_PREFIXO)) + ' ' + RTRIM(LTRIM(E5_NUMERO)) AS DOCUMENTO, E2_VENCREA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA
FROM SE5010
INNER JOIN SE2010 ON
E5_FILIAL = E2_FILIAL AND
E5_TIPO = E2_TIPO AND
E5_NUMERO = E2_NUM AND
E5_PREFIXO = E2_PREFIXO AND
E5_CLIFOR = E2_FORNECE AND
E5_LOJA = E2_LOJA
WHERE E2_VENCREA = '20130808' AND E5_RECPAG = 'P' AND E5_RECONC ='x'
AND NOT (E5_DOCUMEN LIKE '%DIF CARTA%')
AND (E5_TIPO LIKE '%FL%' AND (E5_PREFIXO LIKE '%FL%' OR E5_PREFIXO LIKE '%FLI%'))

UNION

SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, E5_NUMCHEQ AS DOCUMENTO, E2_VENCREA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA
FROM SE5010
INNER JOIN SE2010 ON
E5_FILIAL = E2_FILIAL AND
E5_TIPO = E2_TIPO AND
E5_NUMERO = E2_NUM AND
E5_PREFIXO = E2_PREFIXO AND
E5_CLIFOR = E2_FORNECE AND
E5_LOJA = E2_LOJA
WHERE E2_VENCREA = '20130808' AND E5_RECPAG = 'P' AND E5_RECONC ='x'
AND NOT (E5_DOCUMEN LIKE '%DIF CARTA%')
AND E5_MOEDA LIKE '%TR%' AND E5_NATUREZ LIKE '%6.04.01%'

UNION

SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, E5_DOCUMEN AS DOCUMENTO, E2_VENCREA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA
FROM SE5010
INNER JOIN SE2010 ON
E5_FILIAL = E2_FILIAL AND
E5_TIPO = E2_TIPO AND
E5_NUMERO = E2_NUM AND
E5_PREFIXO = E2_PREFIXO AND
E5_CLIFOR = E2_FORNECE AND
E5_LOJA = E2_LOJA
WHERE E2_VENCREA = '20130808' AND E5_RECPAG = 'P' AND E5_RECONC ='x'
AND NOT (E5_DOCUMEN LIKE '%DIF CARTA%')
AND E5_MOEDA LIKE '%BA%'

UNION

SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, 'AP ' + E5_NUMAP AS DOCUMENTO, E2_VENCREA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA
FROM SE5010
INNER JOIN SE2010 ON
E5_FILIAL = E2_FILIAL AND
E5_TIPO = E2_TIPO AND
E5_NUMERO = E2_NUM AND
E5_PREFIXO = E2_PREFIXO AND
E5_CLIFOR = E2_FORNECE AND
E5_LOJA = E2_LOJA
WHERE E2_VENCREA = '20130808' AND E5_RECPAG = 'P' AND E5_RECONC ='x'
AND NOT (E5_DOCUMEN LIKE '%DIF CARTA%')
AND E5_NUMAP <> '' AND E5_NUMCHEQ <> ''

UNION

SELECT E5_DATA AS EMISSAO, E5_BENEF AS FORNECEDOR, 'BORD '+ E5_DOCUMEN AS DOCUMENTO, E2_VENCREA AS VENCIMENTO, E5_VALOR AS VALOR, E5_BANCO AS BANCO, E5_CONTA AS CONTA
FROM SE5010
INNER JOIN SE2010 ON
E5_FILIAL = E2_FILIAL AND
E5_TIPO = E2_TIPO AND
E5_NUMERO = E2_NUM AND
E5_PREFIXO = E2_PREFIXO AND
E5_CLIFOR = E2_FORNECE AND
E5_LOJA = E2_LOJA
WHERE E2_VENCREA = '20130808' AND E5_RECPAG = 'P' AND E5_RECONC ='x'
AND NOT (E5_DOCUMEN LIKE '%DIF CARTA%')
AND E5_DOCUMEN <> '' AND E5_TIPODOC IN ('VL','CH','BA')

ORDER BY E5_DATA, DOCUMENTO
*/

