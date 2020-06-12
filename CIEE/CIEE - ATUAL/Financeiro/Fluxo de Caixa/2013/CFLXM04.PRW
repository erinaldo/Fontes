#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| CFLXM04     		 | Autor   |  AF Custom           | Data   |    07/2013      |
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Descricao 	| Relatorio Plano Natureza Financeira CIEE - Analitico                           |
+---------------+--------------------------------------------------------------------------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function CFLXM04()
Local 	oReport
Private _lSair
While .T.
	_lSair:= .T.
	If TRepInUse()
		CRIASX1()
		pergunte("CFLXM04XXX",.F.)
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

oReport := TReport():New("CFLXM04","Fluxo de Caixa Analítico","CFLXM04XXX",{|oReport| PrintReport(oReport)},"Fluxo de Caixa Analítico")
oReport:SetLandScape(.T.)
oReport:DisableOrientation()
oSection := TRSection():New(oReport,"Fluxo de Caixa","SED")


Return oReport

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| PrintReport() 	 | Autor   |  AF Custom           | Data   |    05/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
Static Function PrintReport(oReport)
Local oSection  := oReport:Section(1)
Local cTabED	:= RetSqlName('SED')
Local cQuery	:= ''
Local cAlias	:= ''
Local nX		:= 0
Local nLen		:= 0
Local nFil		:= 0
Local cFil		:= ''

Private _NatMax
Private _nLinDad	:= 1
Private _aDados		:= {}	// Matriz principal do Relatório contendo Linhas Brancas, Naturezas Sintéticas de Nível 01 e Nível 02;
Private _aClone		:= {}	// Matriz auxiliar contendo Código da Natureza e a Linha da Matriz _aDados que ela ocupa;
Private _aScan		:= {}	// Matriz com Endereçamento do _aDados de cada Natureza
// o maior cõdigo de Naturezas Sintéticas de Nível 01 é 12, tamanho do _aChave, len(_cHave) é igual a 121, vide array(_NatMax+1),
// onde _NatMat é igual a MAX(ED_CODIGO) da Tabela SED
// Assim todas as Naturezas de nível 01 ou 02 terá uma linha correspondente neste vetor, cuja célula contém a Linha da Matriz _aDados que ela ocupa,
// evitando a busca da posição pela função ASCAN().
Private _aNATSIN	:= {}   // Matriz auxiliar contendo a Natureza Sintética de Nível 01 como pai e os respectivos filhos, que correspondem às Naturezas Sintéticas de Nível 02,
// Facilita a soma, pois na Matriz principal _aDados, os filhos precedem ao pai


If VAL(MV_PAR02) < 1 .Or. VAL(MV_PAR02) > 12 
	MsgStop("Parâmetro de Mês Inválido : "+MV_PAR02+"!")  
	_lSair := .F.
	Return
Else
	MV_PAR02:=STRZERO(VAL(MV_PAR02),2)
EndIf
    

If !Empty(MV_PAR03) .And. !Empty(MV_PAR04)  

	If VAL(MV_PAR03) < 1 .Or. VAL(MV_PAR03) > 31 
		MsgStop("Parâmetro de Dia De Inválido : "+MV_PAR03+"!") 
		_lSair := .F.
		Return
	EndIf
	                                                  
	_cMesPost:= IIf(VAL(MV_PAR02)+1==13,"01",STRZERO(VAL(MV_PAR02)+1,2))
	_cAnoPost:= IIf(VAL(MV_PAR02)+1==13,STRZERO(VAL(MV_PAR01)+1,4),STRZERO(VAL(MV_PAR01),4))
	
	_dULT := DAY(STOD(_cAnoPost+_cMesPost+"01")-1)
	
	If VAL(MV_PAR04) < 1 .Or. VAL(MV_PAR04) > _dULT 
		MsgStop("Parâmetro de Dia Ate Inválido : "+MV_PAR04+"!") 
		_lSair := .F.
		Return
	EndIf
	
	_lRelParcial := .T.

Else
	_lRelParcial := .F.

EndIf



//---------------------------------------------------------------------------------
// Define _aDados com as Colunas do Relatório para Tipo Estrutural ou Informativo
//---------------------------------------------------------------------------------


TRCell():New(oSection,"DESNAT"			,"", "Descrição"		    ,/*Picture*/			,70		,/*lPixel*/,{|| _aDados[_nLinDad,1]  	})
TRCell():New(oSection,"REAORC"			,"", "Orçado"		    	,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aDados[_nLinDad,6]  	},,,"RIGHT")
TRCell():New(oSection,"REAREA"			,"", "Realizado"		    ,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aDados[_nLinDad,7]  	},,,"RIGHT")
TRCell():New(oSection,"VARNOM"			,"", "Nominal"		    	,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aDados[_nLinDad,9]  	},,,"RIGHT")
TRCell():New(oSection,"VARPER"			,"", "Percentual"		    ,"@)E 999,999.9"		,15		,/*lPixel*/,{|| _aDados[_nLinDad,10]  	},,,"RIGHT")

If !_lRelParcial
	TRCell():New(oSection,"ACUORC"			,"", "Orçado"		    	,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aDados[_nLinDad,11]  	},,,"RIGHT")
	TRCell():New(oSection,"ACUREA"			,"", "Realizado"		   	,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aDados[_nLinDad,12]  	},,,"RIGHT")
	TRCell():New(oSection,"ACUNOM"			,"", "Nominal"		    	,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aDados[_nLinDad,13]  	},,,"RIGHT")      
	TRCell():New(oSection,"ACUPER"			,"", "Percentual"		    ,"@)E 999,999.9"		,15		,/*lPixel*/,{|| _aDados[_nLinDad,14]  	},,,"RIGHT")
EndIf		

//------------------------------------------
// Faz o Query para montagem da 1a. Coluna
//------------------------------------------

cFil:=xFilial("SED")

cQuery:=" SELECT ED_TIPO, ED_CODIGO, ED_DESCRIC, ED_DESORC, ED_SUPORC, ED_XFLUXO, ED_SUP, ED_TPMOV, ED_COND, ED_MSBLQL
cQuery+=" FROM " + cTabED
cQuery+=" WHERE ED_FILIAL	= '" + cFil + "' "
cQuery+="	AND ED_TIPO 	= '1'" 			// 1 == Sintética, 	2 == Analítica
cQuery+="	AND ED_MSBLQL 	= '2'"			// 1 == Ativa, 		2 == Inativa
cQuery+="	AND ED_XFLUXO 	= 'S'"        	// S == Sim, 		N == Não
cQuery+="	AND ED_CODIGO   = '" + MV_PAR05 + "' "
cQuery+=" 	AND " + cTabED + ".D_E_L_E_T_=' ' "
cQuery+=" ORDER BY ED_FILIAL, ED_CODIGO, ED_SUPORC"

TcQuery cQuery New Alias (cAlias:=GetNextAlias())

//----------------------------------------------------------------------
// Carrega o array 1a. Coluna Comum para Tipo Estrutural e Informativo
//----------------------------------------------------------------------

While (cAlias)->(!Eof())
	
	
	// Sintéticos Nivel 02
	U_Filhos(AllTrim((cAlias)->ED_CODIGO))
	
	// Carrega Linha Branca
	Aadd(_aDados,{ , , , , , , , , , , , , , })
	                  
	// Guarda no array auxiliar _aClone[] as Linhas correspondentes às Natureza do array _aDados[], para montagem do array _aChave
	Aadd(_aClone,{ , Len(_aDados)})

	
	// Sintéticos Nivel 01
	Aadd(_aDados,	{ 																																					;
	AllTrim(Iif(!Empty((cAlias)->ED_DESORC),(cAlias)->ED_DESORC,(cAlias)->ED_CODIGO+". "+(cAlias)->ED_DESCRIC )),										; // 1
	(cAlias)->ED_CODIGO,																																; // 2
	StrZero(Len(_aDados)+1,2),																															; // 3
	Iif(!Empty((cAlias)->ED_COND),Iif((cAlias)->ED_COND=="R","Receita","Despesa")," "), 																; // 4
	(cAlias)->ED_SUPORC,0 ,0 ,																															; // 5,6,7
	(cAlias)->ED_COND,0 ,0 ,0, 0, 0 ,0								  																					; // 8,9,10,11,12,13,14
	} )
	// Utilizar o Campo ED_COND para definir o Sentido da Coluna Nominal, "R"eceita ou "D"espesa
	// Carrega os Filhos
	// Soma se 1 pois o primeiro registro do _aDados deve conter na sua 3a. coluna, a sua linha que é Len(_aDados)==0 + 1, no _aClone não se soma pois Len(_aDados) já está com 1

	Aadd(_aClone,{  AllTrim((cAlias)->ED_CODIGO) , Len(_aDados)})
	Aadd(_aScan, {  AllTrim((cAlias)->ED_CODIGO) , Len(_aDados)})

	(cAlias)->(dbSkip())
	
End

(cAlias)->(dbCloseArea())
                                                                                           

//----------------------------------------------------------------------
// Montando as Colunas
//----------------------------------------------------------------------

U_REAORC(MV_PAR01, MV_PAR02) 		// Monta a Coluna "Realizado Orçado    " Posição _aDados[*,6]

U_REAREA(MV_PAR01, MV_PAR02) 		// Monta a Coluna "Realizado Realizado " Posição _aDados[*,7]

U_VARNOM() 							// Monta a Coluna "Variação  Nominal   " Posição _aDados[*,9]

U_VARPER() 							// Monta a Coluna "Variação  Percentual" Posição _aDados[*,10]


If !_lRelParcial

	U_ACUORC(MV_PAR01, MV_PAR02) 		// Monta a Coluna "Acumulado Orçado	   " Posição _aDados[*,11]
	
	U_ACUREA(MV_PAR01, MV_PAR02) 		// Monta a Coluna "Acumulado Realizado " Posição _aDados[*,12]
	
	U_VARACUNOM() 						// Monta a Coluna "Variação  Acumulada Nominal   " Posição _aDados[*,13]
	
	U_VARACUPER() 						// Monta a Coluna "Variação  Acumulada Percentual" Posição _aDados[*,14]

EndIf	

//-----------------------------------------------------------------
// Imprimir todos os TRCell() para Tipo Estrutural ou Informativo
//-----------------------------------------------------------------

oSection:Init()
nLen:=Len(_aDados)
For nX:=1 to nLen
	_nLinDad:=nX
	oSection:PrintLine()
Next nX
oSection:Finish()

_lSair := .F.

Return


/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| Netos() 	 		 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function Netos(_cCodPai)

Local cTabED	:=RetSqlName('SED')
Local cQuery	:=''
Local cAlias	:=''
Local nX		:=0
Local nLen		:=0
Local cFil		:=''

//----------------------------
// Faz o query
//----------------------------

cFil:=xFilial("SED")

cQuery:=" SELECT ED_TIPO, ED_CODIGO, ED_DESCRIC, ED_DESORC, ED_SUPORC, ED_XFLUXO, ED_SUP, ED_TPMOV, ED_COND, ED_MSBLQL
cQuery+=" FROM "+cTabED
cQuery+=" WHERE ED_FILIAL	= '"+cFil+"' "
cQuery+="	AND ED_TIPO 	= '2'" 			// 1 == Sintética, 	2 == Analítica
cQuery+="	AND ED_MSBLQL 	= '2'"			// 1 == Ativa, 		2 == Inativa
cQuery+="	AND ED_XFLUXO 	= 'S'"        	// S == Sim, 		N == Não
cQuery+="	AND LEN(ED_CODIGO) = 8 "
cQuery+="	AND LEFT(ED_CODIGO,4) = '"+_cCodPai+"' "
cQuery+=" 	AND "+cTabED+".D_E_L_E_T_=' ' "
cQuery+=" ORDER BY ED_FILIAL, ED_CODIGO, ED_SUPORC"

TcQuery cQuery New Alias (cAlias:=GetNextAlias())

//----------------------------
// Carrega o array
//----------------------------
If (cAlias)->(!Eof())
	Aadd(_aDados,{ , , , , , , , , , , , , , })
	Aadd(_aClone,{ , Len(_aDados)})
EndIf
While (cAlias)->(!Eof())
	
	Aadd(_aDados,	{																		;
	(cAlias)->ED_CODIGO+". "+Iif(!Empty((cAlias)->ED_DESORC),(cAlias)->ED_DESORC, (cAlias)->ED_DESCRIC ) ,	; // 1
	(cAlias)->ED_CODIGO,																	; // 2
	StrZero(Len(_aDados)+1,2),																; // 3
	Iif(!Empty((cAlias)->ED_COND),Iif((cAlias)->ED_COND=="R","Receita","Despesa")," "), 	; // 4
	(cAlias)->ED_SUPORC,0 ,0 ,																; // 5,6,7
	(cAlias)->ED_COND,0 ,0 ,0, 0, 0 ,0														; // 8,9,10,11,12,13,14
	} )
	// Utilizar o Campo ED_COND para definir o Sentido da Coluna Nominal, "R"eceita ou "D"espesa
	// Carrega os Filhos
	Aadd(_aClone, {  AllTrim((cAlias)->ED_CODIGO) 	, Len(_aDados)			})
	Aadd(_aScan,  {  AllTrim((cAlias)->ED_CODIGO) 	, Len(_aDados)			})
	Aadd(_aNATSIN,{  _cCodPai						,(cAlias)->ED_CODIGO   	})
	     
	
	(cAlias)->(dbSkip())
End

(cAlias)->(dbCloseArea())

Return


/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| Filhos() 	 		 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function Filhos(_cCodPai)

Local cTabED	:=RetSqlName('SED')
Local cQuery	:=''
Local cAlias	:=''
Local nX		:=0
Local nLen		:=0
Local cFil		:=''

//----------------------------
// Faz o query
//----------------------------

cFil:=xFilial("SED")

cQuery:=" SELECT ED_TIPO, ED_CODIGO, ED_DESCRIC, ED_DESORC, ED_SUPORC, ED_XFLUXO, ED_SUP, ED_TPMOV, ED_COND, ED_MSBLQL
cQuery+=" FROM "+cTabED
cQuery+=" WHERE ED_FILIAL	= '"+cFil+"' "
cQuery+="	AND ED_TIPO 	= '1'" 			// 1 == Sintética, 	2 == Analítica
cQuery+="	AND ED_MSBLQL 	= '2'"			// 1 == Ativa, 		2 == Inativa
cQuery+="	AND ED_XFLUXO 	= 'S'"        	// S == Sim, 		N == Não
cQuery+="	AND LEN(ED_CODIGO) = 4 "
cQuery+="	AND LEFT(ED_CODIGO,4) BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' " 
cQuery+="	AND LEFT(ED_CODIGO,2) = '"+_cCodPai+"' "
cQuery+=" 	AND "+cTabED+".D_E_L_E_T_=' ' "
cQuery+=" ORDER BY ED_FILIAL, ED_CODIGO, ED_SUPORC"

TcQuery cQuery New Alias (cAlias:=GetNextAlias())

//----------------------------
// Carrega o array
//----------------------------
If (cAlias)->(!Eof())
	Aadd(_aDados,{ , , , , , , , , , , , , , })
	Aadd(_aClone,{ , Len(_aDados)})
EndIf
While (cAlias)->(!Eof())    


	// Analiticos
	U_Netos(AllTrim((cAlias)->ED_CODIGO)) 
	
	Aadd(_aDados,	{																		;
	(cAlias)->ED_CODIGO+". "+Iif(!Empty((cAlias)->ED_DESORC),(cAlias)->ED_DESORC, (cAlias)->ED_DESCRIC ) ,	; // 1
	(cAlias)->ED_CODIGO,																	; // 2
	StrZero(Len(_aDados)+1,2),																; // 3
	Iif(!Empty((cAlias)->ED_COND),Iif((cAlias)->ED_COND=="R","Receita","Despesa")," "), 	; // 4
	(cAlias)->ED_SUPORC,0 ,0 ,																; // 5,6,7
	(cAlias)->ED_COND,0 ,0 ,0, 0, 0 ,0														; // 8,9,10,11,12,13,14
	} )
	// Utilizar o Campo ED_COND para definir o Sentido da Coluna Nominal, "R"eceita ou "D"espesa
	// Carrega os Filhos
	Aadd(_aClone, {  AllTrim((cAlias)->ED_CODIGO) 	, Len(_aDados)			})
	Aadd(_aScan,  {  AllTrim((cAlias)->ED_CODIGO) 	, Len(_aDados)			})
	Aadd(_aNATSIN,{  _cCodPai						,(cAlias)->ED_CODIGO   	})
	     
	(cAlias)->(dbSkip())
End

(cAlias)->(dbCloseArea())

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
Local cPerg		:= "CFLXM04XXX"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Monta array com as perguntas

aAdd(aRegs,{cPerg,"01","Ano      		","","","mv_ch1","C",4,0,0,"G","","MV_PAR01","",			"",	"",	"",	"",	"", "",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Mes     		","","","mv_ch2","C",2,0,0,"G","","MV_PAR02","",			"",	"",	"",	"",	"",	"",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Dia De     		","","","mv_ch3","C",2,0,0,"G","","MV_PAR03","",			"",	"",	"",	"",	"",	"",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Dia Ate    		","","","mv_ch4","C",2,0,0,"G","","MV_PAR04","",			"",	"",	"",	"",	"",	"",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Totalizadora    ","","","mv_ch5","C",2,0,0,"G","","MV_PAR05","",			"",	"",	"",	"",	"", "",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Sintetica De    ","","","mv_ch6","C",4,0,0,"G","","MV_PAR06","",			"",	"",	"",	"",	"", "",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Sintetica Ate   ","","","mv_ch7","C",4,0,0,"G","","MV_PAR07","",			"",	"",	"",	"",	"", "",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})

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

