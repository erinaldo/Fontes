#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| CFLXM03     		 | Autor   |  AF Custom           | Data   |    05/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Descricao 	| Relatorio Plano Natureza Financeira CIEE                                       |
+---------------+--------------------------------------------------------------------------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function CFLXM03()
Local 	oReport
Private _lSair
While .T.
	_lSair:= .T.
	If TRepInUse()
		CRIASX1()
		pergunte("CFLXM03XXX",.F.)
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

oReport:= TReport():New("CFLXM03","Fluxo de Caixa - Acompanhamento Orçamentário - ","CFLXM03XXX",{|oReport| PrintReport(oReport)},"Fluxo de Caixa Sintético")
oReport:SetLandScape(.T.)
oReport:DisableOrientation()
oSection := TRSection():New(oReport,"Fluxo de Caixa","SED")

//TRFunction():New(oSection:Cell("B2_VATU1"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)

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
Local cNatSaldo := SuperGetMV("MV_NATINI",,"30")
Local PulaLinhas:= SuperGetMV("MV_PULALI",,"35,36,58,59")

Private _NatMax
Private _nLinDad	:= 1
Private _aDados		:= {}	// Matriz principal do Relatório contendo Linhas Brancas, Naturezas Sintéticas de Nível 01 e Nível 02;
Private _aClone		:= {}	// Matriz auxiliar contendo Código da Natureza e a Linha da Matriz _aDados que ela ocupa;
Private _aChave		:= {}	// Vetor de tamanho do Maior código da Natureza de Nível 01 multiplicado por 100, mais 1, por exemplo
// o maior cõdigo de Naturezas Sintéticas de Nível 01 é 12, tamanho do _aChave, len(_cHave) é igual a 121, vide array(_NatMax+1),
// onde _NatMat é igual a MAX(ED_CODIGO) da Tabela SED
// Assim todas as Naturezas de nível 01 ou 02 terá uma linha correspondente neste vetor, cuja célula contém a Linha da Matriz _aDados que ela ocupa,
// evitando a busca da posição pela função ASCAN().
Private _aNATSIN	:= {}   // Matriz auxiliar contendo a Natureza Sintética de Nível 01 como pai e os respectivos filhos, que correspondem às Naturezas Sintéticas de Nível 02,
// Facilita a soma, pois na Matriz principal _aDados, os filhos precedem ao pai
Private _aNATSUP	:= {}   // Matriz que contém Naturezas Sintéticas de Nível 01, denominadas Naturezas Totalizadoras ou Superiores,
// cujo valor deriva de uma regra de cálculo envolvendo os demais Naturezas Sintéticas de Nível 01,
// nesta Matriz é guardada a Natureza Totalizadora, o sinal de operação (ED_TPMOV), e a Natureza "operanda"
// Para Naturezas Sintéticas de Nível 02 há um tratamento direto no seu valor através campo ED_TPMOV
Private _aScan		:= {}	// Matriz com Endereçamento do _aDados de cada Natureza


//---------------------------------------------------------------------------------
// Define _aDados com as Colunas do Relatório para Tipo Estrutural ou Informativo
//---------------------------------------------------------------------------------
    
                     
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
	_cAnoPost:= IIf(VAL(MV_PAR02)+1==13,STRZERO(VAL(MV_PAR01)+1,2),STRZERO(VAL(MV_PAR01),2))
	
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


//------------------------------------------
// Faz o Query para montagem da 1a. Coluna
//------------------------------------------

cFil:=xFilial("SED")

cQuery:=" SELECT ED_TIPO, ED_CODIGO, ED_DESCRIC, ED_DESORC, ED_SUPORC, ED_XFLUXO, ED_SUP, ED_TPMOV, ED_COND, ED_MSBLQL
cQuery+=" FROM "+cTabED
cQuery+=" WHERE ED_FILIAL	= '"+cFil+"' "
cQuery+="	AND ED_TIPO 	= '1'" 			// 1 == Sintética, 	2 == Analítica
cQuery+="	AND ED_MSBLQL 	= '2'"			// 1 == Ativa, 		2 == Inativa
cQuery+="	AND ED_XFLUXO 	= 'S'"        	// S == Sim, 		N == Não
cQuery+="	AND LEN(ED_CODIGO) = 2
cQuery+=" 	AND "+cTabED+".D_E_L_E_T_=' ' "
cQuery+=" ORDER BY ED_FILIAL, ED_CODIGO, ED_SUPORC"

TcQuery cQuery New Alias (cAlias:=GetNextAlias())

//----------------------------------------------------------------------
// Carrega o array 1a. Coluna Comum para Tipo Estrutural e Informativo
//----------------------------------------------------------------------

While (cAlias)->(!Eof())
	
	// Analiticos
	U_Carrega_Filhos(AllTrim((cAlias)->ED_CODIGO))
	
	// Carrega Linha Branca
	If MV_PAR05 == 1
		Aadd(_aDados,{ , ,StrZero(Len(_aDados)+1,2), , , , , , , , , , , })
	Else
		Aadd(_aDados,{ , , , , , , , , , , , , , })
	EndIf
	// Guarda no array auxiliar _aClone[] as Linhas correspondentes às Natureza do array _aDados[], para montagem do array _aChave
	Aadd(_aClone,{ , Len(_aDados)})
	
	// Sintéticos
	Aadd(_aDados,	{ 																																					;
	AllTrim(Iif(!Empty((cAlias)->ED_DESORC),(cAlias)->ED_DESORC,(cAlias)->ED_CODIGO+". "+(cAlias)->ED_DESCRIC )) + U_DesNatSup((cAlias)->ED_CODIGO),	; // 1
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

//----------------------------------
// Demais Colunas Tipo Informativo
//----------------------------------

//-------------------------------------------------------------------------------------------------------
// Montagem do Array _aChave[] que contem Natureza x Linhas do _aDados[] para evitar aScan no _aDados[]
//-------------------------------------------------------------------------------------------------------

_NatMax := 0 // Contem a maior Natureza Sintética Totalizadora, exemplo NATMAX="12", então _NatMax==1200

If MV_PAR05 == 2
	
	If FUNNAME() $ 'CFLXM03'
		
		cFil:=xFilial("SED")
		
		cQuery:=" SELECT MAX(ED_CODIGO) AS NATMAX"
		cQuery+=" FROM "+cTabED
		cQuery+=" WHERE ED_FILIAL	= '"+cFil+"' "
		cQuery+="	AND ED_TIPO 	= '1'" 			// 1 == Sintética, 	2 == Analítica
		cQuery+="	AND ED_MSBLQL 	= '2'"			// 1 == Ativa, 		2 == Inativa
		cQuery+="	AND ED_XFLUXO 	= 'S'"        	// S == Sim, 		N == Não
		cQuery+="	AND LEN(ED_CODIGO) = 2
		cQuery+=" 	AND "+cTabED+".D_E_L_E_T_=' ' "
		
		TcQuery cQuery New Alias (cAlias:=GetNextAlias())
		If (cAlias)->(!Eof())
			_NatMax := Val((cAlias)->NATMAX) * 100
		Endif
		(cAlias)->(dbCloseArea())
		
		_aChave:= array(_NatMax+1) 					// Define-se o Len(_aChave)
		
		For _nI:= 1 to Len(_aClone)
			If !Empty(_aClone[_nI,1])
				If Val(_aClone[_nI,1]) == 0         // Tratar Natureza Zero! Guardar na posição da _aChave em _NatMax+1
					_aChave[ _NatMax + 1 ]			:=  _aClone[_nI,2]
				Else
					_aChave[ Val(_aClone[_nI,1]) ] 	:=  _aClone[_nI,2]
				EndIf
			EndIf
		Next _nI
		
	EndIf
	
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
		
	If FUNNAME() $ 'CFLXM03' .And. MV_PAR05 == 2 .And. MV_PAR06==1 	// Relatório Tipo Informativo e Opção Grava Saldo Inicial
		U_Grava_Saldo(_aDados[U_NatPos(cNatSaldo),7])
	EndIf 
	
	If FUNNAME() $ 'CFLXM03' .And. MV_PAR05 == 2 .And. Empty(MV_PAR03) .And. Empty(MV_PAR04) // Relatório Tipo Informativo e for opção mensal
		Grava_Fluxo(_aDados[U_NatPos(cNatSaldo),7])
	EndIf
EndIf

//--------------------------------------------------
// Imprimir todos os TRCell() para Tipo Informativo
//--------------------------------------------------

_aMatImp := {}
// ----------------------------------------------
// Busca o nome do mes por extenso
// ----------------------------------------------
_cMesExt := MesExtenso( MV_PAR02 )                                                         

If FUNNAME() $ 'CFLXM03' // .And. MV_PAR05 == 2 .And. MV_PAR07 == 1          

	_cTitle:="Fluxo de Caixa - Acompanhamento Orçamentário - " // Fluxo de Caixa - Acompanhamento Orçamentário - Julho/2013 - Em R$
	If !Empty(MV_PAR03) .And. !Empty(MV_PAR04)  
		_cTitle+=" " + MV_PAR03 + "/" + MV_PAR02 + "/" + MV_PAR01 + " a " + MV_PAR04 + "/" + MV_PAR02 + "/" + MV_PAR01
	Else
		_cTitle+=" " + _cMesExt + "/" + MV_PAR01 + " - Em R$"
	EndIf 
	oReport:SetTitle(Alltrim(_cTitle))

	For _nI:=1 To Len(_aDados)
	    AADD(_aMatImp,{Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil})
		If !Empty(_aDados[_nI,1])
			For _nj:=1 To Len(_aDados[_nI])
				_aMatImp[_nI,_nJ] := _aDados[_nI,_nJ]
			Next _nJ 
		EndIf	      
	Next _nI
EndIf

If MV_PAR05 == 1
	
	TRCell():New(oSection,"DESNAT"			,"", "Descrição"			,/*Picture*/			,70		,/*lPixel*/,{|| _aMatImp[_nLinDad,1]  	})
	TRCell():New(oSection,"ORCNAT"			,"", "Codigo"				,/*Picture*/			,12		,/*lPixel*/,{|| _aMatImp[_nLinDad,2]  	})
	TRCell():New(oSection,"REANAT"			,"", "Linha"				,/*Picture*/			,12		,/*lPixel*/,{|| _aMatImp[_nLinDad,3]  	})
	TRCell():New(oSection,"REANAT"			,"", "Nominal"				,/*Picture*/			,12		,/*lPixel*/,{|| _aMatImp[_nLinDad,4]  	})
	
Else
	
	TRCell():New(oSection,"DESNAT"			,"", "Descrição"		    		,/*Picture*/			,70		,/*lPixel*/,{|| _aMatImp[_nLinDad,1]  	})
	TRCell():New(oSection,"REAORC"			,"", CRLF+"Orçado"  				,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,6]  	},,,"RIGHT")
	TRCell():New(oSection,"REAREA"			,"", CRLF+"Realizado"   			,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,7]  	},,,"RIGHT")
	TRCell():New(oSection,"VARNOM"			,"", "Variação"+CRLF+"Nominal"		,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,9]  	},,,"RIGHT")
	TRCell():New(oSection,"VARPER"			,"", "Variação"+CRLF+"Percentual"	,"@)E 999,999.9"		,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,10]  	},,,"RIGHT")
	If !_lRelParcial
		TRCell():New(oSection,"ACUORC"			,"", "Acumulado"+CRLF+"Orçado"	   	,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,11]  	},,,"RIGHT")
		TRCell():New(oSection,"ACUREA"			,"", "Acumulado"+CRLF+"Realizado" 	,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,12]  	},,,"RIGHT")
		TRCell():New(oSection,"ACUNOM"			,"", "Variação"+CRLF+"Nominal"		,"@)E 999,999,999,999"	,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,13]  	},,,"RIGHT")      
		TRCell():New(oSection,"ACUPER"			,"", "Variação"+CRLF+"Percentual"	,"@)E 999,999.9"		,15		,/*lPixel*/,{|| _aMatImp[_nLinDad,14]  	},,,"RIGHT")
	EndIf	           
EndIf
   

oSection:Init()                                                     
nLen:=Len(_aMatImp)
For nX:=1 to nLen    

    If FUNNAME() $ 'CFLXM03' 
		If MV_PAR05 == 2  // Informativo
			If MV_PAR07 == 1  // Linhas
				If !(StrZero(nX,2) $ PulaLinhas) 
	    			If nX > 1 
						If Empty(_aMatImp[nX,1]) 
							_nLinDad:=nX
						    If _lImpLinha        
						    	If !_lRelParcial
									oReport:Line( oReport:Row(), oSection:Cell(1):ColPos(), oReport:Row(),  oSection:Cell(9):ColPos()+190 ) 
								Else                                                                                                       
									oReport:Line( oReport:Row(), oSection:Cell(1):ColPos(), oReport:Row(),  oSection:Cell(5):ColPos()+190 )
								EndIf 
						    EndIf
							oSection:PrintLine()
				    	Else
							If Left(_aMatImp[nX,1],1) $ "0,1,2,3,4,5,6,7,8,9" 
							   	_lImpLinha := .T.
							Else
				   				_lImpLinha := .F.
							EndIf
							_nLinDad:=nX
							oSection:PrintLine()
		            	EndIf
					Else
						_nLinDad:=nX
						oSection:PrintLine()
    				EndIf
				EndIf
			Else     
				If !(StrZero(nX,2) $ PulaLinhas) 
					_nLinDad:=nX
					oSection:PrintLine()
				EndIf	
			EndIf
		Else 
			If (StrZero(nX,2) $ PulaLinhas)
				If _aMatImp[nX,3]==Nil       
			 		_aMatImp[nX,3]:="bb Pula"
				Else
			 		_aMatImp[nX,3]+=" Pula"
            	EndIf
            EndIf
			_nLinDad:=nX
			oSection:PrintLine()
		EndIf
    Else
		_nLinDad:=nX
		oSection:PrintLine()
	EndIf	

Next nX     

If FUNNAME() $ 'CFLXM03' .And. MV_PAR05 == 2  .And.  MV_PAR07 == 1 // Informativo e Linhas   
	If !_lRelParcial
		oReport:Line( oReport:Row(), oSection:Cell(1):ColPos(), oReport:Row(),  oSection:Cell(9):ColPos()+190 ) 
//		oReport:SkipLine()
	Else                                                                                                       
		oReport:Line( oReport:Row(), oSection:Cell(1):ColPos(), oReport:Row(),  oSection:Cell(5):ColPos()+190 )
	EndIf 
EndIf


oSection:Finish()
_lSair := .F.

Return


/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| Grava_Fluxo()    	 | Autor   |  AF Custom           | Data   |    09/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/

STATIC FUNCTION Grava_Fluxo(_nValor)   
dbSelectArea("PAH")
dbSetOrder(1)  
               
_nTam:=40-Len("CFLXM03")
_cChave:="CFLXM03"+Space(_nTam)+DTOS(dDataBase)                                

If !(dbSeek(xFilial("PAH")+_cChave))
	RecLock("PAH", .T.)
		PAH->PAH_FILIAL := xFilial("PAH")            
		PAH->PAH_ORIGEM := "CFLXM03"
        PAH->PAH_DATA   := dDataBase
		PAH->PAH_VALOR  := _nValor
	msUnLock()
Else
	RecLock("PAH", .F.)
		PAH->PAH_VALOR  := _nValor
	msUnLock()
EndIf

Return

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| Grava_Saldo()    	 | Autor   |  AF Custom           | Data   |    07/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function Grava_Saldo(_nValor)

Local _cProxMes := STRZERO(VAL(MV_PAR02)+1,2)
Local _cAno 	:= MV_PAR01

If _cProxMes == "13"
	_cProxMes := "01"
	_cAno := AllTrim(STR(VAL(_cAno)+1))
EndIf

If MsgYesNo("Confirma Gravação de Orçamento Realizado em 01/"+_cProxMes+"/"+_cAno + " no valor de " + STR(_nValor))

	//	MsgStop("Data Orçamento Realizado de 01/"+_cProxMes+"/"+_cAno + " no valor de " + STR(_nValor))
	//
	//	Regra		A Coluna de Realizado/Realizado para Natureza 00 - Saldo Inicial, do Relatório de 06/13:
	//				É o Saldo gravado na Tabela SZZ para data de 01/06/13 da Natureza 00;
	//				Assim, quando a opção de gravar saldo do Relatório de Junho estiver ativado, estaremos gravando o Saldo da data de 01/07/13 da Natureza 00,
	//				vindo da coluna 07, Realizado/Realizado da linha da Natureza 10 
	
	DbSelectArea("SZZ")
	DbSetOrder(2)
	If DbSeek(xFilial("SZZ")+_cAno+_cProxMes+"0100") 
		RecLock("SZZ",.F.)
	 	SZZ->ZZ_VALOR := _nValor
	Else
		RecLock("SZZ",.T.)
		SZZ->ZZ_FILIAL 	:= xFilial("SZZ")
		SZZ->ZZ_NATUREZ	:= "00"
		SZZ->ZZ_DESCNAT	:= "SALDO INICIAL"
		SZZ->ZZ_NATDEP	:= "0"
		SZZ->ZZ_HIST 	:= "RELATORIO FLUXO SINTETICO RR"
		SZZ->ZZ_DOCUMEN	:= "FECHAMENTO"
		SZZ->ZZ_DATA 	:= STOD(_cAno+_cProxMes+"01")
		SZZ->ZZ_VALOR 	:= _nValor
		SZZ->ZZ_FLAG 	:= "IMP"
		MsUnLock()
	EndIf	                              
EndIf

If MsgYesNo("Confirma Gravação de Acumulado Realizado de 31/12/"+MV_PAR01 + " no valor de " + STR(_nValor))

	//	MsgStop("Data Orçamento Acumulado Realizado de 31/12/"+_cAno  + " no valor de " + STR(_nValor))
	//
	//	Regra		A Coluna de Acumulado/Realizado para Natureza 00 - Saldo Inicial, do Relatório de 06/13:
	//				É o Saldo gravado na Tabela SZZ para data de 31/12/13 da Natureza 00;
	//				Assim, quando a opção de gravar saldo do Relatório estiver ativado, estaremos gravando o Saldo da data de 31/12/13 da Natureza 00,
	//				vindo da coluna 07, Realizado/Realizado da linha da Natureza 10 
	
	DbSelectArea("SZZ")
	DbSetOrder(2)
	If DbSeek(xFilial("SZZ")+MV_PAR01+"123100") 
		RecLock("SZZ",.F.)
	 	SZZ->ZZ_VALOR := _nValor
	Else
		RecLock("SZZ",.T.)
		SZZ->ZZ_FILIAL 	:= xFilial("SZZ")
		SZZ->ZZ_NATUREZ	:= "00"
		SZZ->ZZ_DESCNAT	:= "SALDO INICIAL"
		SZZ->ZZ_NATDEP	:= "0"
		SZZ->ZZ_HIST 	:= "RELATORIO FLUXO SINTETICO AR"
		SZZ->ZZ_DOCUMEN	:= "FECHAMENTO"
		SZZ->ZZ_DATA 	:= STOD(MV_PAR01+"1231")
		SZZ->ZZ_VALOR 	:= _nValor
		SZZ->ZZ_FLAG 	:= "IMP"
		MsUnLock()
	EndIf	                              
EndIf	
Return

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| VARACUPER()      	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function VARACUPER()
Local _nI

For _nI := 1 To Len(_aDados)
	If !Empty(_aDados[_nI,2])
		_nFator:= 1
		DbSelectarea("SED")
		SED->(DbSetOrder(1))
		If SED->(DbSeek(xFilial("SED")+AllTrim(_aDados[_nI,2])))
			If AllTrim(SED->ED_SUP) == AllTrim(SED->ED_CODIGO)
				If SED->ED_TPMOV == "N"
					_nFator:= -1
				EndIf
			Else
				If _aDados[_nI,13] < 0 .And. _aDados[_nI,11] < 0
					_nFator:= -1
				EndIf	
			EndIf
		EndIf
		
		If _aDados[_nI,11] == 0 
			If _aDados[_nI,13] <> 0
				_aDados[_nI,14] := Iif(_aDados[_nI,13] < 0,-100,100)
			Else 
				_aDados[_nI,14] := 0 
			EndIf	
		Else 
			_aDados[_nI,14] := ( ROUND((_aDados[_nI,13] / _aDados[_nI,11]) * 100,1) ) * _nFator
		EndIf
		
	EndIf
Next _nI

Return

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| VARNOM()      	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function VARACUNOM()
Local _nI

For _nI := 1 To Len(_aDados)
	If !Empty(_aDados[_nI,2])
		If AllTrim(_aDados[_nI,2]) =="00"
			_aDados[_nI,13] := _aDados[_nI,12]-_aDados[_nI,11]
		Else
			_aDados[_nI,13] := IIf(_aDados[_nI,8]=="R", _aDados[_nI,12]-_aDados[_nI,11], _aDados[_nI,11]-_aDados[_nI,12])
		EndIf
	EndIf
Next _nI

Return


/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| ACUREA()      	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function ACUREA(_cAno, _cMes)
Local _nI
Local _nJ
Local _nFator
Local _nValor 	:= 0
Local cAlias	:= ''
Local cFil		:= xFilial("SZZ")
Local cTabZZ	:= RetSqlName('SZZ')
Local _cFilED	:= xFilial("SED")
Local _cTabED	:= RetSqlName('SED')
Local _cAnoAnt  := STRZERO(Val(_cAno)-1,4)
Local _n00		:= Iif(FUNNAME()$'CFLXM03',U_NatPos("00"),0)
Local cNatIgual := SuperGetMV("MV_NATIGU",,"31")
Local _nii		:= Iif(FUNNAME()$'CFLXM03',U_NatPos(cNatIgual),0)   
Local _nTam     := IIf(FUNNAME()$'CFLXM03',4,8)



If FUNNAME() $ 'CFLXM03' .And. !Empty(_aDados[_n00,2])                                
	DbSelectArea("SZZ")
	DbSetOrder(2)
	If DbSeek(xFilial("SZZ")+_cAnoAnt+"123100") 
		_aDados[_n00,12] := SZZ->ZZ_VALOR
	EndIf	                              
EndIf                                   

For _nJ := 1 To Val(_cMes)
	
	For _nI := 1 To Len(_aDados)
                        
		If !Empty(_aDados[_nI,2]) .And. Len(AllTrim(_aDados[_nI,2])) == _nTam .And. _nI <> _n00
		
			cFil:=xFilial("SZZ")
			
			cQuery:=" SELECT SUM(ZZ_VALOR) AS VALORZZ "
			cQuery+=" FROM " + cTabZZ + " INNER JOIN "	+ _cTabED
			cQuery+=" ON ZZ_NATUREZ = ED_CODIGO "
	
			cQuery+=" WHERE ZZ_FILIAL	= '"	+ cFil 		+ "' "
			cQuery+=" AND LEFT(ZZ_DATA,6)= '"	+ _cAno 	+ STRZERO(_nJ,2) + "' "
	                 
			If (_cAno >= "2013" .And. _cMes >= "06") .Or. _cAno >= "2014"
				cQuery+="	AND ZZ_NATUREZ LIKE '"		+ AllTrim(_aDados[_nI,2]) 	+ "%' "
			Else
				cQuery+="	AND ZZ_NATUREZ LIKE '"		+ AllTrim(_aDados[_nI,5]) 	+ "%' "
			EndIf
			cQuery+=" 	AND "+cTabZZ+".D_E_L_E_T_=' ' "        
			cQuery+=" 	AND ZZ_DEL=' ' "        
	
			cQuery+=" AND ED_FILIAL = '"	+ _cFilED	+ "'"
			cQuery+=" AND ED_TIPO = '2'"             
			cQuery+=" AND ED_MSBLQL 	 = '2' "
			cQuery+=" AND ED_XFLUXO 	 = 'S' "
			cQuery+=" AND LEN(ED_CODIGO) = 8 "
			cQuery+=" AND "+ _cTabED +".D_E_L_E_T_=' ' "
			
			TcQuery cQuery New Alias (cAlias:=GetNextAlias())
			
			// Em 02/07/13 o tratamento abaixo foi substituido pela seguinte regra:
			// 			Naturezas de Nível 02 terão valores negativos ou positivos de acordo com o sinal dos valores dos seus analíticos,
			// 			que por sua vez possuem valores na tabela ZZ, lançados de acordo com o ED_TIPO e o ED_COND, Se ED_COND=="D", o valor em ZZ_VALOR
			// 			Para isto foi alterado o CFINA51 criado indice SED->(DbOrderNickName("SUPORC")) paa tratar o valor de ZZ pelo ED_TIPO e ED_COND
			//			Alterado também o CFINA52a para visualizar ED_NATDEP e ED_NATDEPD
			
			// Tratar Naturezas de Nível 02, por exemplo 09.01 caso a sua conta (ED_SUP) seja ele mesmo, então multiplique o valor por (ED_TPMOV), 1 se for "P" e -1 se For "N"
			
			If (cAlias)->(!Eof())
				_nValor := (cAlias)->VALORZZ
			Else
				_nValor := 0
			EndIf

			_nFator:= 1
			
			_aDados[_nI,12] += _nValor * _nFator
			
			(cAlias)->(dbCloseArea())
			
		EndIf
		
	Next _nI
	
Next _nJ                    



// Tratar as Somas das Naturezas Sintéticas do _aDados

For _nI := 1 To Len(_aNATSIN)
	_aDados[U_NatPos(_aNATSIN[_nI,1]),12] += _aDados[U_NatPos(_aNATSIN[_nI,2]),12]  // Jogando por exemplo valor de 01.01 ao 01.
Next _nI
 

// Tratar as Somas das Naturezas Superiores através do _aNATSUP
If FUNNAME() $ 'CFLXM03'
	For _nI := 1 To Len(_aNATSUP)
		_aDados[U_NatPos(_aNATSUP[_nI,1]),12] += Iif(_aNATSUP[_nI,2]=="+", 1 , -1 ) * _aDados[U_NatPos(_aNATSUP[_nI,3]),12]  // Jogando por exemplo +01. ao 03. e -02. ao 03. então 03. = 01. -02.

		// Tratar as Colunas com Saldo Acumulado igual ao Saldo Inicial
		_aDados[_nii,12] := _aDados[_nii,7] 
	Next _nI
EndIf



Return


/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| ACUORC()      	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function ACUORC(_cAno, _cMes)
Local _nI
Local _nJ
Local _nI
Local _nFator
Local cAlias	:= ''
Local _cFilE7	:= xFilial("SE7")
Local _cTabE7	:= RetSqlName('SE7')
Local _cFilED	:= xFilial("SED")
Local _cTabED	:= RetSqlName('SED')
Local cNatIgual := SuperGetMV("MV_NATIGU",,"31")
Local _nii		:= Iif(FUNNAME()$'CFLXM03',U_NatPos(cNatIgual),0)       
Local _nTam     := IIf(FUNNAME()$'CFLXM03',4,8)

If FUNNAME() $ 'CFLXM03'

		For _nI := 1 To Len(_aDados) 
		
			If !Empty(_aDados[_nI,2]) .And. AllTrim(_aDados[_nI,2]) == "00"                               
			   	dbSelectArea("SE7") // Tabela Orçamentos
				dbSetOrder(2)   	// E7_FILIAL + E7_ANO + E7_NATUREZ
				If DbSeek(xFilial("SE7") + _cAno + AllTrim(_aDados[_nI,2])  ) 
				    _aDados[_nI,11] := SE7->E7_VALJAN1
				EndIf  
			EndIf
		
			If !Empty(_aDados[_nI,2]) .And. Len(AllTrim(_aDados[_nI,2])) == _nTam
	
				_nFator:= 1
				DbSelectarea("SED")
				SED->(DbSetOrder(1))
				If SED->(DbSeek(xFilial("SED")+AllTrim(_aDados[_nI,2])))
					If AllTrim(SED->ED_SUP) == AllTrim(SED->ED_CODIGO)
						If SED->ED_TPMOV == "N"
							_nFator:= -1
						EndIf
					EndIf
				EndIf


				For _nJ := 1 To Val(_cMes)			
				
				Do Case
					Case _nJ==1
						cQuery:=" SELECT SUM(E7_VALJAN1) AS VALOR "
					Case _nJ==2
						cQuery:=" SELECT SUM(E7_VALFEV1) AS VALOR "
					Case _nJ==3
						cQuery:=" SELECT SUM(E7_VALMAR1) AS VALOR "
					Case _nJ==4
						cQuery:=" SELECT SUM(E7_VALABR1) AS VALOR "
					Case _nJ==5
						cQuery:=" SELECT SUM(E7_VALMAI1) AS VALOR "
					Case _nJ==6
						cQuery:=" SELECT SUM(E7_VALJUN1) AS VALOR "
					Case _nJ==7
						cQuery:=" SELECT SUM(E7_VALJUL1) AS VALOR "
					Case _nJ==8
						cQuery:=" SELECT SUM(E7_VALAGO1) AS VALOR "
					Case _nJ==9
						cQuery:=" SELECT SUM(E7_VALSET1) AS VALOR "
					Case _nJ==10
						cQuery:=" SELECT SUM(E7_VALOUT1) AS VALOR "
					Case _nJ==11
						cQuery:=" SELECT SUM(E7_VALNOV1) AS VALOR "
					Case _nJ==12
						cQuery:=" SELECT SUM(E7_VALDEZ1) AS VALOR "
					Otherwise
						cQuery:=" SELECT 0 AS VALOR "
				EndCase

				cQuery+=" FROM " + _cTabE7 +" INNER JOIN "	+ _cTabED
				cQuery+=" ON E7_NATUREZ = ED_CODIGO "
				cQuery+=" WHERE E7_FILIAL = '"	+ _cFilE7	+ "'"
				cQuery+=" AND E7_ANO = '"		+ _cAno 	+ "'"
				cQuery+=" AND E7_NATUREZ LIKE '"		+ AllTrim(_aDados[_nI,2]) 	+ "%'"
				cQuery+=" AND "+ _cTabE7 +".D_E_L_E_T_=' ' "
				cQuery+=" AND ED_FILIAL = '"	+ _cFilED	+ "'"
				cQuery+=" AND ED_TIPO = '2'"             
				cQuery+=" AND ED_MSBLQL 	 = '2' "
				cQuery+=" AND ED_XFLUXO 	 = 'S' "
				cQuery+=" AND LEN(ED_CODIGO) = 8 "
				cQuery+=" AND "+ _cTabED +".D_E_L_E_T_=' ' "
				
				TcQuery cQuery New Alias (cAlias:=GetNextAlias())
				
				If (cAlias)->(!Eof())
					_aDados[_nI,11] += (cAlias)->VALOR * _nFator
				Else
					_aDados[_nI,11] += 0
				EndIf
				
				(cAlias)->(dbCloseArea())
				 
				Next _nJ

			EndIf
			
		Next _nI

		
Else
	
	
	For _nI := 1 To Len(_aDados)
		
		If !Empty(_aDados[_nI,2]) .And. Len(AllTrim(_aDados[_nI,2])) == 8
			                     
			
			_nFator:= 1
			DbSelectarea("SED")
			SED->(DbSetOrder(1))
			If SED->(DbSeek(xFilial("SED")+SubStr(_aDados[_nI,2],1,4)))
				If AllTrim(SED->ED_SUP) == AllTrim(SED->ED_CODIGO)
					If SED->ED_TPMOV == "N"
						_nFator:= -1
					EndIf
				EndIf
			EndIf

			dbSelectArea("SE7") // Tabela Orçamentos
			dbSetOrder(2)   	// E7_FILIAL + E7_ANO + E7_NATUREZ
			
			For _nJ := 1 To Val(_cMes)
				
				If DbSeek(xFilial("SE7") + _cAno + AllTrim(_aDados[_nI,2])  )
					
					Do Case
						Case _nJ==1
							_nSE7_VAL := SE7->E7_VALJAN1
						Case _nJ==2
							_nSE7_VAL := SE7->E7_VALFEV1
						Case _nJ==3
							_nSE7_VAL := SE7->E7_VALMAR1
						Case _nJ==4
							_nSE7_VAL := SE7->E7_VALABR1
						Case _nJ==5
							_nSE7_VAL := SE7->E7_VALMAI1
						Case _nJ==6
							_nSE7_VAL := SE7->E7_VALJUN1
						Case _nJ==7
							_nSE7_VAL := SE7->E7_VALJUL1
						Case _nJ==8
							_nSE7_VAL := SE7->E7_VALAGO1
						Case _nJ==9
							_nSE7_VAL := SE7->E7_VALSET1
						Case _nJ==10
							_nSE7_VAL := SE7->E7_VALOUT1
						Case _nJ==11
							_nSE7_VAL := SE7->E7_VALNOV1
						Case _nJ==12
							_nSE7_VAL := SE7->E7_VALDEZ1
						Otherwise
							_nSE7_VAL := 0
					EndCase
					
					_aDados[_nI,11] += _nSE7_VAL * _nFator
					
				EndIf
				
			Next _nJ
			
		EndIf
		
	Next _nI
	
	
EndIf


// Tratar as Somas das Naturezas Sintéticas do _aDados

For _nI := 1 To Len(_aNATSIN)
	_aDados[U_NatPos(_aNATSIN[_nI,1]),11] += _aDados[U_NatPos(_aNATSIN[_nI,2]),11]  // Jogando por exemplo valor de 01.01 ao 01.
Next _nI

// Tratar as Somas das Naturezas Superiores através do _aNATSUP
If FUNNAME() $ 'CFLXM03'
	For _nI := 1 To Len(_aNATSUP)
		_aDados[U_NatPos(_aNATSUP[_nI,1]),11] += Iif(_aNATSUP[_nI,2]=="+", 1 , -1 ) * _aDados[U_NatPos(_aNATSUP[_nI,3]),11]  // Jogando por exemplo +01. ao 03. e -02. ao 03. então 03. = 01. -02.
		// Tratar as Colunas com Saldo Acumulado igual ao Saldo Inicial
		_aDados[_nii,11] := _aDados[_nii,6] 
	Next _nI
EndIf   

Return



/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| VARPER()      	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function VARPER()
Local _nI

For _nI := 1 To Len(_aDados)
	If !Empty(_aDados[_nI,2]) 
		_nFator:= 1
		DbSelectarea("SED")
		SED->(DbSetOrder(1))
		If SED->(DbSeek(xFilial("SED")+AllTrim(_aDados[_nI,2])))
			If AllTrim(SED->ED_SUP) == AllTrim(SED->ED_CODIGO)
				If SED->ED_TPMOV == "N"
					_nFator:= -1
				EndIf 
			Else
				If _aDados[_nI,9] < 0 .And. _aDados[_nI,6] < 0
					_nFator:= -1
				EndIf	
			EndIf
		EndIf
		If _aDados[_nI,6] == 0 
			If _aDados[_nI,9] <> 0
				_aDados[_nI,10] := Iif(_aDados[_nI,9] < 0,-100,100)
			Else 
				_aDados[_nI,10] := 0 
			EndIf	
		Else 
			_aDados[_nI,10] := ( ROUND((_aDados[_nI,9] / _aDados[_nI,6]) * 100,1) ) * _nFator
		EndIf
	EndIf
Next _nI

Return

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| VARNOM()      	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function VARNOM()
Local _nI

For _nI := 1 To Len(_aDados)
	If !Empty(_aDados[_nI,2])
		If AllTrim(_aDados[_nI,2]) =="00"
			_aDados[_nI,9] := _aDados[_nI,7]-_aDados[_nI,6]
		Else
			_aDados[_nI,9] := IIf(_aDados[_nI,8]=="R", _aDados[_nI,7]-_aDados[_nI,6], _aDados[_nI,6]-_aDados[_nI,7])
		EndIf
	EndIf
Next _nI

Return

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| REAREA()      	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function REAREA(_cAno, _cMes)
Local _nI
Local _nFator
Local _nValor 	:= 0
Local cFil		:=xFilial("SZZ")
Local cTabZZ	:=RetSqlName('SZZ')
Local _cFilED	:= xFilial("SED")
Local _cTabED	:= RetSqlName('SED')
Local cAlias	:= ''
Local _n00		:= IIf(FUNNAME()$'CFLXM03',U_NatPos("00"),0)
Local _nTam     := IIf(FUNNAME()$'CFLXM03',4,8)

If FUNNAME()$'CFLXM03' .And. !Empty(_aDados[_n00,2])                                
	DbSelectArea("SZZ")
	DbSetOrder(2)
	If DbSeek(xFilial("SZZ")+_cAno+_cMes+"0100") 
		_aDados[_n00,7] := SZZ->ZZ_VALOR
	EndIf	                              
EndIf

For _nI := 1 To Len(_aDados)

	If !Empty(_aDados[_nI,2]) .And. Len(AllTrim(_aDados[_nI,2])) == _nTam .And. _nI<>_n00
		
		cFil:=xFilial("SZZ")
		
		cQuery:=" SELECT SUM(ZZ_VALOR) AS VALORZZ "
		cQuery+=" FROM " + cTabZZ + " INNER JOIN "	+ _cTabED
		cQuery+=" ON ZZ_NATUREZ = ED_CODIGO "

		cQuery+=" WHERE ZZ_FILIAL	= '"	+ cFil 		+ "' "
		cQuery+=" AND LEFT(ZZ_DATA,6)= '"	+ _cAno 	+ _cMes + "' "
		
        If _lRelParcial
				
			_dDe 	:= _cAno + _cMes + MV_PAR03
			_dAte 	:= _cAno + _cMes + MV_PAR04
			cQuery	+= " AND ZZ_DATA BETWEEN '" + _dDe + "' AND '" + _dAte +"' "
	        
        EndIf 
		
		If (_cAno >= "2013" .And. _cMes >= "06") .Or. _cAno >= "2014"
			cQuery+="	AND ZZ_NATUREZ LIKE '"		+ AllTrim(_aDados[_nI,2]) 	+ "%' "
		Else
			cQuery+="	AND ZZ_NATUREZ LIKE '"		+ AllTrim(_aDados[_nI,5]) 	+ "%' "
		EndIf
		
		cQuery+=" 	AND "+cTabZZ+".D_E_L_E_T_=' ' "        
		cQuery+=" 	AND ZZ_DEL=' ' "        

		cQuery+=" AND ED_FILIAL = '"	+ _cFilED	+ "'"
		cQuery+=" AND ED_TIPO = '2'"             
		cQuery+=" AND ED_MSBLQL 	 = '2' "
		cQuery+=" AND ED_XFLUXO 	 = 'S' "
		cQuery+=" AND LEN(ED_CODIGO) = 8 "
		cQuery+=" AND "+ _cTabED +".D_E_L_E_T_=' ' "
		
		TcQuery cQuery New Alias (cAlias:=GetNextAlias())
		
		If (cAlias)->(!Eof())
			_nValor := (cAlias)->VALORZZ
		Else
			_nValor := 0
		EndIf
		
		// Em 02/07/13 o tratamento abaixo foi substituido pela seguinte regra:
		// 			Naturezas de Nível 02 terão valores negativos ou positivos de acordo com o sinal dos valores dos seus analíticos,
		// 			que por sua vez possuem valores na tabela ZZ, lançados de acordo com o ED_TIPO e o ED_COND, Se ED_COND=="D", o valor em ZZ_VALOR
		// 			Para isto foi alterado o CFINA51 criado indice SED->(DbOrderNickName("SUPORC")) paa tratar o valor de ZZ pelo ED_TIPO e ED_COND
		//			Alterado também o CFINA52a para visualizar ED_NATDEP e ED_NATDEPD
		
		// Tratar Naturezas de Nível 02, por exemplo 09.01 caso a sua conta (ED_SUP) seja ele mesmo, então multiplique o valor por (ED_TPMOV), 1 se for "P" e -1 se For "N"
		
		
		_nFator:= 1 

		/*		                           
		If FUNNAME() $ 'CFLXM04'//14/11/2013 - Relato Analitico
			DbSelectarea("SED")
   			SED->(DbSetOrder(1))
   			If SED->(DbSeek(xFilial("SED")+AllTrim(_aDados[_nI,2])))
		 	
				If SED->ED_TPMOV == "N"
					_nFator:= -1
				EndIf                                                      
			EndIf

		EndIf
		*/
		_aDados[_nI,7] := _nValor * _nFator
		
		(cAlias)->(dbCloseArea())
		
	EndIf
	
Next _nI

// EndIf

// Tratar as Somas das Naturezas Sintéticas do _aDados

For _nI := 1 To Len(_aNATSIN)
	_aDados[U_NatPos(_aNATSIN[_nI,1]),7] += _aDados[U_NatPos(_aNATSIN[_nI,2]),7]  // Jogando por exemplo valor de 01.01 ao 01.
Next _nI

// Tratar as Somas das Naturezas Superiores através do _aNATSUP
If FUNNAME() $ 'CFLXM03'
	For _nI := 1 To Len(_aNATSUP)
		_aDados[U_NatPos(_aNATSUP[_nI,1]),7] += Iif(_aNATSUP[_nI,2]=="+", 1 , -1 ) * _aDados[U_NatPos(_aNATSUP[_nI,3]),7]  // Jogando por exemplo +01. ao 03. e -02. ao 03. então 03. = 01. -02.
	Next _nI
EndIf

Return

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| REAORC()      	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function REAORC(_cAno, _cMes)
Local _nI
Local _nFator
Local cAlias	:= ''
Local _cFilE7	:= xFilial("SE7")
Local _cTabE7	:= RetSqlName('SE7')
Local _cFilED	:= xFilial("SED")
Local _cTabED	:= RetSqlName('SED')                                             
Local _nTam     := IIf(FUNNAME()$'CFLXM03',4,8)


// Os Saldos Orçamentarios passam a ser alimentados analiticamente, conforme solicitação da Tesouraria em 15/07/13

If FUNNAME() $ 'CFLXM03'
	
	For _nI := 1 To Len(_aDados)                                           
	                                                      
	    If !Empty(_aDados[_nI,2]) .And. AllTrim(_aDados[_nI,2]) == "00"                               
	    
	    	dbSelectArea("SE7") // Tabela Orçamentos
			dbSetOrder(2)   	// E7_FILIAL + E7_ANO + E7_NATUREZ
			If DbSeek(xFilial("SE7") + _cAno + AllTrim(_aDados[_nI,2])  ) 
				Do Case
					Case Val(_cMes)==1
						_aDados[_nI,6] := SE7->E7_VALJAN1
					Case Val(_cMes)==2
						_aDados[_nI,6] := SE7->E7_VALFEV1
					Case Val(_cMes)==3
						_aDados[_nI,6] := SE7->E7_VALMAR1
					Case Val(_cMes)==4
						_aDados[_nI,6] := SE7->E7_VALABR1
					Case Val(_cMes)==5
						_aDados[_nI,6] := SE7->E7_VALMAI1
					Case Val(_cMes)==6
						_aDados[_nI,6] := SE7->E7_VALJUN1
					Case Val(_cMes)==7
						_aDados[_nI,6] := SE7->E7_VALJUL1
					Case Val(_cMes)==8
						_aDados[_nI,6] := SE7->E7_VALAGO1
					Case Val(_cMes)==9
						_aDados[_nI,6] := SE7->E7_VALSET1
					Case Val(_cMes)==10
						_aDados[_nI,6] := SE7->E7_VALOUT1
					Case Val(_cMes)==11
						_aDados[_nI,6] := SE7->E7_VALNOV1
					Case Val(_cMes)==12
						_aDados[_nI,6] := SE7->E7_VALDEZ1
					Otherwise
						_aDados[_nI,6] := 0 
				EndCase
				
			EndIf
		EndIf
		
		If !Empty(_aDados[_nI,2]) .And. Len(AllTrim(_aDados[_nI,2])) == _nTam
			
			Do Case
				Case Val(_cMes)==1
					cQuery:=" SELECT SUM(E7_VALJAN1) AS VALOR "
				Case Val(_cMes)==2
					cQuery:=" SELECT SUM(E7_VALFEV1) AS VALOR "
				Case Val(_cMes)==3
					cQuery:=" SELECT SUM(E7_VALMAR1) AS VALOR "
				Case Val(_cMes)==4
					cQuery:=" SELECT SUM(E7_VALABR1) AS VALOR "
				Case Val(_cMes)==5
					cQuery:=" SELECT SUM(E7_VALMAI1) AS VALOR "
				Case Val(_cMes)==6
					cQuery:=" SELECT SUM(E7_VALJUN1) AS VALOR "
				Case Val(_cMes)==7
					cQuery:=" SELECT SUM(E7_VALJUL1) AS VALOR "
				Case Val(_cMes)==8
					cQuery:=" SELECT SUM(E7_VALAGO1) AS VALOR "
				Case Val(_cMes)==9
					cQuery:=" SELECT SUM(E7_VALSET1) AS VALOR "
				Case Val(_cMes)==10
					cQuery:=" SELECT SUM(E7_VALOUT1) AS VALOR "
				Case Val(_cMes)==11
					cQuery:=" SELECT SUM(E7_VALNOV1) AS VALOR "
				Case Val(_cMes)==12
					cQuery:=" SELECT SUM(E7_VALDEZ1) AS VALOR "
				Otherwise
					cQuery:=" SELECT 0 AS VALOR "
			EndCase
			
			cQuery+=" FROM " + _cTabE7 +" INNER JOIN "	+ _cTabED
			cQuery+=" ON E7_NATUREZ = ED_CODIGO "
			cQuery+=" WHERE E7_FILIAL = '"	+ _cFilE7	+ "'"
			cQuery+=" AND E7_ANO = '"		+ _cAno 	+ "'"
			cQuery+=" AND E7_NATUREZ LIKE '"		+ AllTrim(_aDados[_nI,2]) 	+ "%'"
			cQuery+=" AND "+ _cTabE7 +".D_E_L_E_T_=' ' "
			cQuery+=" AND ED_FILIAL = '"	+ _cFilED	+ "'"
			cQuery+=" AND ED_TIPO = '2'"             
			cQuery+=" AND ED_MSBLQL 	 = '2' "
			cQuery+=" AND ED_XFLUXO 	 = 'S' "
			cQuery+=" AND LEN(ED_CODIGO) = 8 "
			cQuery+=" AND "+ _cTabED +".D_E_L_E_T_=' ' "
			
			TcQuery cQuery New Alias (cAlias:=GetNextAlias())
			
			_nFator:= 1
			DbSelectarea("SED")
			SED->(DbSetOrder(1))
			If SED->(DbSeek(xFilial("SED")+AllTrim(_aDados[_nI,2])))
				If AllTrim(SED->ED_SUP) == AllTrim(SED->ED_CODIGO)
					If SED->ED_TPMOV == "N"
						_nFator:= -1
					EndIf
				EndIf
			EndIf
			
			If (cAlias)->(!Eof())
				_aDados[_nI,6] := (cAlias)->VALOR * _nFator
			Else
				_aDados[_nI,6] := 0
			EndIf
			
			(cAlias)->(dbCloseArea())
			
		EndIf
		
	Next _nI                
	
Else                    // chamado do Relatorio Analitico 'CFLXM04'
	
	For _nI := 1 To Len(_aDados)
		
		If !Empty(_aDados[_nI,2]) .And. Len(AllTrim(_aDados[_nI,2])) == 8
			
			dbSelectArea("SE7") // Tabela Orçamentos
			dbSetOrder(2)   	// E7_FILIAL + E7_ANO + E7_NATUREZ
			If DbSeek(xFilial("SE7") + _cAno + AllTrim(_aDados[_nI,2])  )
				
				Do Case
					Case Val(_cMes)==1
						_nSE7_VAL := SE7->E7_VALJAN1
					Case Val(_cMes)==2
						_nSE7_VAL := SE7->E7_VALFEV1
					Case Val(_cMes)==3
						_nSE7_VAL := SE7->E7_VALMAR1
					Case Val(_cMes)==4
						_nSE7_VAL := SE7->E7_VALABR1
					Case Val(_cMes)==5
						_nSE7_VAL := SE7->E7_VALMAI1
					Case Val(_cMes)==6
						_nSE7_VAL := SE7->E7_VALJUN1
					Case Val(_cMes)==7
						_nSE7_VAL := SE7->E7_VALJUL1
					Case Val(_cMes)==8
						_nSE7_VAL := SE7->E7_VALAGO1
					Case Val(_cMes)==9
						_nSE7_VAL := SE7->E7_VALSET1
					Case Val(_cMes)==10
						_nSE7_VAL := SE7->E7_VALOUT1
					Case Val(_cMes)==11
						_nSE7_VAL := SE7->E7_VALNOV1
					Case Val(_cMes)==12
						_nSE7_VAL := SE7->E7_VALDEZ1
					Otherwise
						_nSE7_VAL := 0
				EndCase
				
				_nFator:= 1
				DbSelectarea("SED")
				SED->(DbSetOrder(1))
				If SED->(DbSeek(xFilial("SED")+SubStr(_aDados[_nI,2],1,4)))
					If AllTrim(SED->ED_SUP) == AllTrim(SED->ED_CODIGO)
						If SED->ED_TPMOV == "N"
							_nFator:= -1
						EndIf
					EndIf
				EndIf
				
				_aDados[_nI,6] := _nSE7_VAL * _nFator
				
			EndIf
		EndIf
		
	Next _nI
EndIf

// Tratar as Somas das Naturezas Sintéticas do _aDados

For _nI := 1 To Len(_aNATSIN)
	_aDados[U_NatPos(_aNATSIN[_nI,1]),6] += _aDados[U_NatPos(_aNATSIN[_nI,2]),6]  // Jogando por exemplo valor de 01.01 ao 01.
Next _nI

// Tratar as Somas das Naturezas Superiores através do _aNATSUP
If FUNNAME() $ 'CFLXM03'
	For _nI := 1 To Len(_aNATSUP)
		_aDados[U_NatPos(_aNATSUP[_nI,1]),6] += Iif(_aNATSUP[_nI,2]=="+", 1 , -1 ) * _aDados[U_NatPos(_aNATSUP[_nI,3]),6]  // Jogando por exemplo +01. ao 03. e -02. ao 03. então 03. = 01. -02.
	Next _nI
EndIf

Return

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| NatPos()      	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function NatPos(_cNat)
Local _nPos
Local _nAux

_nAux := ASCAN(_aScan, {|x| AllTrim(x[1]) == AllTrim(_cNat) })
_nPos := _aScan[_nAux,2]

Return _nPos



/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| DesNatSup()    	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function DesNatSup(_cCodPai)
Local _cDescri 	:= ""
Local _lFirst   := .T.
Local cTabED	:=RetSqlName('SED')
Local cQuery	:=''
Local cAlias	:=''
Local cFil		:=''

//------------------------------------------------------------------------------------------------------------
// Faz o query para tratar Descrição dos Sintéticos e se há formulas de Cálculo caso sejam Contas Superiores
//------------------------------------------------------------------------------------------------------------

cFil:=xFilial("SED")

cQuery:=" SELECT ED_TIPO, ED_CODIGO, ED_DESCRIC, ED_DESORC, ED_SUPORC, ED_XFLUXO, ED_SUP, ED_MSBLQL, "
cQuery+=" CASE ED_TPMOV "
cQuery+=" WHEN 'P' THEN '+' "
cQuery+=" WHEN 'N' THEN '-' "
cQuery+=" ELSE  ' '         "
cQuery+=" END AS ED_TPMOV   "
cQuery+=" FROM "+cTabED
cQuery+=" WHERE ED_FILIAL	= '"+cFil+"' "
cQuery+="	AND ED_TIPO 	= '1'" 			// 1 == Sintética, 	2 == Analítica
cQuery+="	AND ED_MSBLQL 	= '2'"			// 1 == Ativa, 		2 == Inativa
cQuery+="	AND ED_XFLUXO 	= 'S'"        	// S == Sim, 		N == Não
cQuery+="	AND LEN(ED_CODIGO) = 2 "
cQuery+="	AND ED_SUP = '"+_cCodPai+"' "
cQuery+=" 	AND "+cTabED+".D_E_L_E_T_=' ' "
cQuery+=" ORDER BY ED_FILIAL, ED_TPMOV, ED_SUP"

TcQuery cQuery New Alias (cAlias:=GetNextAlias())

//----------------------------------------------------
// Carrega o array _aNATSUP das Naturezas Superiores
//----------------------------------------------------

While (cAlias)->(!Eof())
	If _lFirst
		_lFirst := .F.
		_cDescri+= "  ( "
		If (cAlias)->ED_TPMOV = "+"
			_cDescri+= LEFT((cAlias)->ED_DESORC,2)
		Else
			_cDescri+= " " + (cAlias)->ED_TPMOV + " " + LEFT((cAlias)->ED_DESORC,2)
		EndIf
	Else
		_cDescri+= " " + (cAlias)->ED_TPMOV + " " + LEFT((cAlias)->ED_DESORC,2)
	EndIf
	
	
	AADD(_aNATSUP,{ _cCodPai, (cAlias)->ED_TPMOV, AllTrim((cAlias)->ED_CODIGO) })
	
	(cAlias)->(dbSkip())
End
If !_lFirst .Or. !Empty(_cDescri)
	_cDescri+= " )"
EndIf
(cAlias)->(dbCloseArea())


Return _cDescri

/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| Carrega_Filhos() 	 | Autor   |  AF Custom           | Data   |    06/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/
User Function Carrega_Filhos(_cCodPai)

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
cQuery+="	AND LEFT(ED_CODIGO,2) = '"+_cCodPai+"' "
cQuery+=" 	AND "+cTabED+".D_E_L_E_T_=' ' "
cQuery+=" ORDER BY ED_FILIAL, ED_CODIGO, ED_SUPORC"

TcQuery cQuery New Alias (cAlias:=GetNextAlias())

//----------------------------
// Carrega o array
//----------------------------
If (cAlias)->(!Eof())
	If MV_PAR05 == 1	// Carrega Linha Branca
		Aadd(_aDados,{ , ,StrZero(Len(_aDados)+1,2), , , , , , , , , , , })
	Else
		Aadd(_aDados,{ , , , , , , , , , , , , , })
	EndIf
	Aadd(_aClone,{ , Len(_aDados)})
EndIf
While (cAlias)->(!Eof())
	
	Aadd(_aDados,	{																		;
	Iif(!Empty((cAlias)->ED_DESORC),(cAlias)->ED_DESORC,(cAlias)->ED_DESCRIC),				; // 1
	(cAlias)->ED_CODIGO,																	; // 2
	StrZero(Len(_aDados)+1,2),																; // 3
	Iif(!Empty((cAlias)->ED_COND),Iif((cAlias)->ED_COND=="R","Receita","Despesa")," "), 	; // 4
	(cAlias)->ED_SUPORC,0 ,0 ,																; // 5,6,7
	(cAlias)->ED_COND,0 ,0 ,0, 0, 0 ,0														; // 8,9,10,11,12,13,14
	} )
	// Utilizar o Campo ED_COND para definir o Sentido da Coluna Nominal, "R"eceita ou "D"espesa
	// Carrega os Filhos
	Aadd(_aClone, {  AllTrim((cAlias)->ED_CODIGO) 	, Len(_aDados)			})      
	Aadd(_aScan, {  AllTrim((cAlias)->ED_CODIGO) , Len(_aDados)})

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
Local cPerg		:= "CFLXM03XXX"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Monta array com as perguntas

aAdd(aRegs,{cPerg,"01","Ano      		","","","mv_ch1","C",4,0,0,"G","","MV_PAR01","",			"",	"",	"",	"",	"", "",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Mes     		","","","mv_ch2","C",2,0,0,"G","","MV_PAR02","",			"",	"",	"",	"",	"",	"",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Dia De     		","","","mv_ch3","C",2,0,0,"G","","MV_PAR03","",			"",	"",	"",	"",	"",	"",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Dia Ate    		","","","mv_ch4","C",2,0,0,"G","","MV_PAR04","",			"",	"",	"",	"",	"",	"",			"",	"", "", "","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Tipo           	","","","mv_ch5","C",1,0,0,"C","","MV_PAR05","Estrutural",	"",	"",	"",	"", "Informativo"	,	"",	"",	"", "","","","","","","","","","","","","","","","" ,"","","",""})
aAdd(aRegs,{cPerg,"06","Atualiza Saldo 	","","","mv_ch6","C",1,0,0,"C","","MV_PAR06","Sim"		 ,	"",	"",	"",	"", "Não"			,	"",	"",	"", "","","","","","","","","","","","","","","","" ,"","","",""})
aAdd(aRegs,{cPerg,"07","Linhas      	","","","mv_ch7","C",1,0,0,"C","","MV_PAR07","Sim"		 ,	"",	"",	"",	"", "Não"			,	"",	"",	"", "","","","","","","","","","","","","","","","" ,"","","",""})


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


