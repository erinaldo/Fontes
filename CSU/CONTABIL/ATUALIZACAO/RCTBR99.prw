#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"      
#INCLUDE "report.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBR99   ºAutor  ³Edival Alves Junior º Data ³  06/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de documentos de entrada com o rateio ñ          º±±
±±º          ³ processado.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCTBR99()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaração de variáveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aRegs	:= {}
Local cPerg := PADR("CTBR99",Len(SX1->X1_GRUPO))
Private Qry := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria os parametros da rotina                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
//aAdd(aRegs,{cPerg,"01","Emissão De"				,"","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
//aAdd(aRegs,{cPerg,"02","Emissão Até"			,"","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VG - 2011.06.06³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRegs,{cPerg,"01","Digitação De"			,"","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"02","Digitação Até"			,"","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"03","Código Rateio De"		,"","","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","", "","","","","","","","","","","","","","","","","","","","","ZB7COD","","","","" })
aAdd(aRegs,{cPerg,"04","Códito Rateio Até"		,"","","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","", "","","","","","","","","","","","","","","","","","","","","ZB7COD","","","","" }) 
aAdd(aRegs,{cPerg,"05","NF De" 					,"","","mv_ch5","C",09,0,0,"G","","MV_PAR05","","","","", "","","","","","","","","","","","","","","","","","","","","SF1","","","","" })
aAdd(aRegs,{cPerg,"06","NF Até"					,"","","mv_ch6","C",09,0,0,"G","","MV_PAR06","","","","", "","","","","","","","","","","","","","","","","","","","","SF1","","","","" })
aAdd(aRegs,{cPerg,"07","Serie De"				,"","","mv_ch7","C",03,0,0,"G","","MV_PAR07","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"08","Serie Até"				,"","","mv_ch8","C",03,0,0,"G","","MV_PAR08","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"09","Status da Nota"			,"","","mv_ch9","C",01,0,1,"C","","MV_PAR09","Contabilizadas","","","","","Nao Contabilizadas","","","","","Ambas","","","","","","","","","","","","","","","","","",""})

CriaSx1(aRegs)                 

If !Pergunte(cPerg,.T.)  
	Return .F.
Endif

RCTBR99A()

Return .T.                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBR99A  ºAutor  ³Edival Alves Junior º Data ³  06/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento do relatorio de rateio.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RCTBR99A()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaração de variáveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oReport
Local oBreak
Local oSection                  
Local cTitulo 	:= "Relatório de Rateio"

oReport := TReport():New("REPORT",cTitulo,,{|oReport| PrintReport(oReport)},"Imprime Relatorio de Rateio")
oReport:HideParamPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VG - 2011.03.11                 ³
//³Garantir a impressão em paisagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetLandScape(.T.)

DEFINE SECTION oSection OF oReport TABLES "SF1","SA2","ZB7" TITLE "Resumo Documentos de Entrada"

	DEFINE CELL NAME "F1_DOC" 		OF oSection ALIAS "SF1" SIZE TAMSX3("F1_DOC")[1]		TITLE "Documento" 		BLOCK {|| impLinha("F1_DOC")		} 
	DEFINE CELL NAME "F1_SERIE" 	OF oSection ALIAS "SF1" SIZE TAMSX3("F1_SERIE")[1] 		TITLE "Serie" 			BLOCK {|| impLinha("F1_SERIE")		} 
	DEFINE CELL NAME "F1_FORNECE" 	OF oSection ALIAS "SF1" SIZE TAMSX3("F1_FORNECE")[1] 	TITLE "Fornec"			BLOCK {|| impLinha("F1_FORNECE")	} 
	DEFINE CELL NAME "F1_LOJA" 		OF oSection ALIAS "SF1" SIZE TAMSX3("F1_LOJA")[1] 		TITLE "Loja" 			BLOCK {|| impLinha("F1_LOJA")		} 
	DEFINE CELL NAME "A2_NREDUZ"	OF oSection ALIAS "SA2" SIZE 15							TITLE "Nome" 			BLOCK {|| impLinha("A2_NREDUZ")		} //VG - 2011.01.11
//	DEFINE CELL NAME "F1_DUPL" 		OF oSection ALIAS "SF1" SIZE TAMSX3("F1_DUPL")[1] 		TITLE "Duplicata"		BLOCK {|| impLinha("F1_DUPL")		} //VG - 2011.01.22 - Não é necessário para a usuária final.

	DEFINE CELL NAME "F1_EMISSAO" 	OF oSection ALIAS "SF1" SIZE TAMSX3("F1_EMISSAO")[1] 	TITLE "Emissao"			BLOCK {|| impLinha("F1_EMISSAO")	}
	DEFINE CELL NAME "F1_DTDIGIT" 	OF oSection ALIAS "SF1" SIZE TAMSX3("F1_DTDIGIT")[1] 	TITLE "Digitac"			BLOCK {|| impLinha("F1_DTDIGIT")	} //VG - 2011.03.22 - Solicitação da usuária

	DEFINE CELL NAME "ZB7_CODRAT" 	OF oSection ALIAS "ZB7" SIZE TAMSX3("ZB7_CODRAT")[1] 	TITLE "Rateio"			BLOCK {|| impLinha("ZB7_CODRAT")	} 
//	DEFINE CELL NAME "ZB7_DESCRI" 	OF oSection ALIAS "ZB7" SIZE 15 						TITLE "Descricao"		BLOCK {|| impLinha("ZB7_DESCRI")	} //VG - 2011.01.22 - Não é necessária para a usuária final.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³VG - 2011.03.11                               ³
	//³Impressão do responsável pela tabela de rateio³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	DEFINE CELL NAME "ZB7_USRNAM" 	OF oSection ALIAS "ZB7" SIZE TAMSX3("ZB7_USRNAM")[1] 	TITLE OemToAnsi("Responsável")		BLOCK {|| impLinha("ZB7_USRNAM")	}  
	//VG - 2011.03.22 - Imprimir o nome do usuário, limitando a quantidade de caracteres a 15
	DEFINE CELL NAME "ZB7_USRFNA" 	OF oSection ALIAS "ZB7" SIZE TAMSX3("ZB7_USRFNA")[1]	TITLE OemToAnsi("Responsável")		BLOCK {|| impLinha("ZB7_USRFNA")	}  
	
	DEFINE CELL NAME "ED_CODIGO" 	OF oSection ALIAS "SED" SIZE TAMSX3("ED_CODIGO")[1] 	TITLE "Natureza"					BLOCK {|| impLinha("ED_CODIGO")		} 
	DEFINE CELL NAME "ED_DESCRIC" 	OF oSection ALIAS "SED" SIZE TAMSX3("ED_DESCRIC")[1]	TITLE "Desc. Natureza"				BLOCK {|| impLinha("ED_DESCRIC")	} 

//VG - 2011.03.22 - Conta contábil relativa ao centro de custo transitório
	DEFINE CELL NAME "CT1_CONTA" 	OF oSection ALIAS "CT1" SIZE TAMSX3("CT1_CONTA")[1]		TITLE "Conta Contabil"				BLOCK {|| impLinha("CT1_CONTA")	} 
	DEFINE CELL NAME "CT1_DESC01" 	OF oSection ALIAS "CT1" SIZE TAMSX3("CT1_DESC01")[1]	TITLE "Desc. C.Contab"				BLOCK {|| impLinha("CT1_DESC01")	} 

//	DEFINE CELL NAME "F1_XPRORAT" 	OF oSection ALIAS "SF1" SIZE TAMSX3("F1_XPRORAT")[1] 	TITLE "Proc."						BLOCK {|| impLinha("F1_XPRORAT")	} 	
	DEFINE CELL NAME "F1_XPRORAT" 	OF oSection ALIAS "SF1" SIZE 04 						TITLE "Proc."						BLOCK {|| impLinha("F1_XPRORAT")	} 

	DEFINE BREAK oBreak OF oSection WHEN oSection:Cell("F1_DOC")
		
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrintReportºAutor  ³Edival Alves Junior º Data ³  06/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento da query relatorio de rateio.                 º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrintReport(oReport) 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaração de variáveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDataDe 	:=	DtoS(MV_PAR01)
Local cDataAte	:= 	DtoS(MV_PAR02)
Local cRatDe	:= 	MV_PAR03
Local cRatAte	:= 	MV_PAR04
Local cNfDe 	:= 	MV_PAR05
Local cNfAte	:= 	MV_PAR06 
Local cSerieDe	:= 	MV_PAR07
Local cSerieAte	:= 	MV_PAR08  
Local cInvCodRat:=	Replicate(" ",TAMSX3("ZB7_CODRAT")[1])
Local cXproRat	:= "" 
Local cBranco	:= ""     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VG - 2011.03.11                 ³
//³Garantir a impressão em paisagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetLandScape(.T.)

If Empty(MV_PAR09) .Or. MV_PAR09 == 3
	cXproRat := " ' = ' "
Else
	If MV_PAR09 == 1
		cXproRat := " ' = ' ' AND F1_XPRORAT = '"+AllTrim(Str(MV_PAR09))+" "
	Else
		cXproRat := " ' = ' ' AND (F1_XPRORAT = '"+AllTrim(Str(MV_PAR09))+"' OR F1_XPRORAT = ' ' ) AND ' ' = ' "
	Endif
EndIf

#IFDEF TOP
	oSection := oReport:Section(1)

	MakeSqlExp("REPORT")

	//VG - 2011.04.29
	//clausula de filial removida
	//		WHERE F1_FILIAL = %xfilial:SF1%	
	
	oSection:BeginQuery()		
	
	BeginSql alias Qry

		SELECT F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_DUPL,F1_EMISSAO, EV_XCODRAT ZB7_CODRAT, ED_CODIGO, ED_DESCRIC, F1_XPRORAT, F1_DTDIGIT
		FROM %table:SF1% SF1(NOLOCK),%table:SEV% SEV(NOLOCK), %table:SED% SED(NOLOCK)
		WHERE F1_FILIAL >= ' '
			AND F1_DOC BETWEEN %Exp:cNfDe% AND %Exp:cNfAte%
			AND F1_SERIE BETWEEN %Exp:cSerieDe% AND %Exp:cSerieAte%
			AND (%Exp:AllTrim(cXproRat)%)
			AND F1_DTDIGIT BETWEEN %Exp:cDataDe% AND %Exp:cDataAte%
			AND SF1.%notDel%             
	    	AND EV_FILIAL = %xfilial:SEV%
		    AND EV_NUM = F1_DOC 
    		AND EV_PREFIXO = F1_PREFIXO      
	    	AND EV_CLIFOR = F1_FORNECE
    		AND EV_LOJA = F1_LOJA
    		AND EV_XCODRAT BETWEEN %Exp:cRatDe% AND %Exp:cRatAte%  
    		AND EV_XCODRAT <> %Exp:cInvCodRat%
		    AND SEV.%notDel%
		    AND ED_FILIAL = %xfilial:SED%
		    AND ED_CODIGO = EV_NATUREZ
   		    AND SED.%notDel%
 		 ORDER BY F1_DTDIGIT, F1_FORNECE, F1_LOJA, F1_DOC, F1_SERIE
	    		
	EndSql            	
	
	oSection:EndQuery({})
#ENDIF                

MemoWrite("RCTBR99.QRY",GETLastQuery()[2])
        
oSection:Print()                                  

Return                  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³impLinha  ºAutor  ³Fabio Simonetti     º Data ³  04/30/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Query                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function impLinha(_cCampo)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaração de variáveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cRet 	:= " "
Local cAnoMes	:= ""
Local cUltRev	:= ""
Local cConta	:= ""

If _cCampo == "F1_DOC"
	_cRet := (Qry)->F1_DOC
	
ElseIf _cCampo == "F1_SERIE"
	_cRet := (Qry)->F1_SERIE
	
ElseIf _cCampo == "F1_FORNECE"
	_cRet := (Qry)->F1_FORNECE
	
ElseIf _cCampo == "F1_LOJA"
	_cRet := (Qry)->F1_LOJA
	
ElseIf _cCampo == "A2_NREDUZ"
	_cRet := Alltrim(Posicione("SA2",1,xFilial("SA2")+(Qry)->F1_FORNECE+(Qry)->F1_LOJA,"A2_NREDUZ"))
	
ElseIf _cCampo == "F1_DUPL"               		
	_cRet	:= (Qry)->F1_DUPL
	
ElseIf _cCampo == "F1_EMISSAO"	
	_cRet	:= (Qry)->F1_EMISSAO
	
ElseIf _cCampo == "F1_DTDIGIT"//VG - 2011.03.22
	_cRet	:= (Qry)->F1_DTDIGIT
	
ElseIf _cCampo == "ZB7_CODRAT"	
	If Empty((Qry)->ZB7_CODRAT)
//		_cRet	:= 	"<--Não"
		_cRet	:= 	Replicate("-",TAMSX3("ZB7_CODRAT")[1])
	Else
		_cRet	:= (Qry)->ZB7_CODRAT
	EndIf
	
ElseIf _cCampo == "ZB7_DESCRI"
	If Empty((Qry)->ZB7_CODRAT)
//   		_cRet	:=  "preenchido-->"
   		_cRet	:=  Replicate("-",TAMSX3("ZB7_DESCRI")[1])
	Else
		_cRet	:= Alltrim(Posicione("ZB7",1,xFilial("ZB7")+(Qry)->ZB7_CODRAT,"ZB7_DESCRI"))
	EndIf	                                   
	
ElseIf _cCampo == "ZB7_USRFNA"//VG - 2011.03.11
	If !Empty((Qry)->ZB7_CODRAT)           	
		//cAnoMes	:= SUBSTR(DTOS((Qry)->F1_EMISSAO),1,6)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VG - 2011.06.06 - Alteração para pegar³
		//³o ano/mês da tabela de rateio com base³
		//³na competência da nota.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAnoMes	:= U_GetCompetencia((Qry)->F1_FILIAL+(Qry)->F1_DOC+(Qry)->F1_SERIE+(Qry)->F1_FORNECE+(Qry)->F1_LOJA)
		cUltRev	:= U_RZB7ULTR((Qry)->ZB7_CODRAT,cAnoMes,.T.)	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VG - 2011.03.22 - pegar a última revisão disponível para o período³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		_cRet	:= Alltrim(Posicione("ZB7",1,xFilial("ZB7")+(Qry)->ZB7_CODRAT+cAnoMes+cUltRev+'A',"ZB7_USRFNA"))			
	Else
		_cRet	:= Replicate("-",TAMSX3("ZB7_USRFNA")[1])
	EndIf
	
ElseIf _cCampo == "ED_CODIGO"
	_cRet	:=  (Qry)->ED_CODIGO
	
ElseIf _cCampo == "ED_DESCRIC"
	_cRet	:=  (Qry)->ED_DESCRIC
	
ElseIf _cCampo == "CT1_CONTA"              
	If !Empty((Qry)->ZB7_CODRAT)           	
		//cAnoMes	:= SUBSTR(DTOS((Qry)->F1_EMISSAO),1,6)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VG - 2011.06.06 - Alteração para pegar³
		//³o ano/mês da tabela de rateio com base³
		//³na competência da nota.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAnoMes	:= U_GetCompetencia((Qry)->F1_FILIAL+(Qry)->F1_DOC+(Qry)->F1_SERIE+(Qry)->F1_FORNECE+(Qry)->F1_LOJA)		
		cUltRev	:= U_RZB7ULTR((Qry)->ZB7_CODRAT,cAnoMes,.T.)	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VG - 2011.03.22 - pegar a conta contábil com base na natureza e centro de custo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		_cRet	:= u_RetCtaNfe( (Qry)->ED_CODIGO , Posicione("ZB7",1,xFilial("ZB7")+(Qry)->ZB7_CODRAT+cAnoMes+cUltRev+'A',"ZB7_CCTRAN"))
	Else
		_cRet	:= Replicate("-",TAMSX3("CT1_CONTA")[1])
	EndIf
	
ElseIf _cCampo == "CT1_DESC01"
	If !Empty((Qry)->ZB7_CODRAT)           	
		//cAnoMes	:= SUBSTR(DTOS((Qry)->F1_EMISSAO),1,6)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VG - 2011.06.06 - Alteração para pegar³
		//³o ano/mês da tabela de rateio com base³
		//³na competência da nota.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAnoMes	:= U_GetCompetencia((Qry)->F1_FILIAL+(Qry)->F1_DOC+(Qry)->F1_SERIE+(Qry)->F1_FORNECE+(Qry)->F1_LOJA)
		cUltRev	:= U_RZB7ULTR((Qry)->ZB7_CODRAT,cAnoMes,.T.)	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³VG - 2011.03.22 - pegar a conta contábil com base na natureza e centro de custo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		cConta	:= u_RetCtaNfe( (Qry)->ED_CODIGO, Posicione("ZB7",1,xFilial("ZB7")+(Qry)->ZB7_CODRAT+cAnoMes+cUltRev+'A',"ZB7_CCTRAN") )
		_cRet	:= Posicione("CT1",1,xFilial("CT1")+cConta,"CT1_DESC01")
	Else
		_cRet	:= Replicate("-",TAMSX3("CT1_DESC01")[1])
	EndIf
		
ElseIf _cCampo == "F1_XPRORAT"
	_cRet	:=  If((Qry)->F1_XPRORAT=='2' .or. Empty(Alltrim((Qry)->F1_XPRORAT)),"Não","Sim")
	
Endif                               

Return _cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ CriaSx1  ³ Verifica e cria um novo grupo de perguntas com base nos      º±±
±±º             ³          ³ parâmetros fornecidos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 23.05.05 ³ Modelagem de Dados                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 28.04.04 ³ TI0607 - Almir Bandina                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ 99.99.99 ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ ExpA1 = array com o conteúdo do grupo de perguntas (SX1)                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99/99/99 - Consultor - Descricao da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSx1(aRegs)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaração de variáveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
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