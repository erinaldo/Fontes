#INCLUDE "rwmake.ch"
#INCLUDE "common.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma³CMGA001     ºAutor  ³Claudio Alves       º Data ³  30/05/05   º±±
±±º        ³            º       ³Resource Informaticaº Fone ³  3040-3509  º±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºDesc.   ³SISTEMA ELABORADO PARA ATENDER A NECESSIDADE DO DEPARTAMENTO  º±±
±±º        ³FINANCEIRO POR SOLICITAÇÃO DE MARCELA BORGES                  º±±
±±º        ³------------------------------------------------------------- º±±
±±º        ³O PROJETO FOI SOLICITADO SEGUNDO ESPECIFICAÇÃO DA APR 0897-05 º±±
±±º        ³------------------------------------------------------------- º±±
±±º        ³ENTREGE E TESTADO COM MARCELA DIA 03/06/2005                  º±±
±±º        ³GERACAO PLANILHA EXCEL COM RATEIO CENTRO DE CUSTO / NATUREZA  º±±
±±º        ³ALTERAÇÃO/CORREÇÃO DEVIDO ERROS DE VARIAIVEIS 30/06/2005      º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³FINANCEIRO CONTAS A PAGAR  -  MARCELA                         º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlterações ³OS 3609/14 Alteração para exibir campo Especie na coluna   º±±
±±º                       Prefixo -  Douglas David                        º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CMGA001()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cAnoMes		:= ""
Local cUltRev		:= ""

_CODIFOR	:=	""
_Entrou		:=	0
_UserData	:= 	PswRet()
Private oExcelApp,_cUsuInc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cPerg 		:= PADR("CMGA01",LEN(SX1->X1_GRUPO))
Private oGeraXls

ValidPerg(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,400 DIALOG oGeraXls TITLE OemToAnsi("Arquivo Excel Dados Contas a Pagar")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo no Excel conforme os parametros "
@ 18,018 Say " definidos  pelo usuario, com os registros  do  arquivo  do "
@ 26,018 Say " Financeiro  -  Contas a Pagar."

@ 60,098 BMPBUTTON TYPE 01 ACTION OkGeraXls()
@ 60,128 BMPBUTTON TYPE 02 ACTION CloseXls()
@ 60,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraXls Centered

Return

//***********************
Static Function OkGeraXls

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| RunCont() },"Processando...")

Return

//***********************
Static Function CloseXls()

If Type('oExcelApp') == 'O'
	oExcelApp:Quit()
	oExcelApp:Destroy()
EndIf

Close(oGeraXls)

Return

//***********************
Static Function RunCont()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gerando o Arquivo de Trabalho Principal                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cQuery		:=	"SELECT  E2_PREFIXO,  E2_NUM, E2_PARCELA, E2_TIPO,  E2_FORNECE, "
_cQuery		+=			"E2_LOJA,  E2_NOMFOR, E2_NATUREZ, E2_CCUSTO, E2_EMISSAO, "
_cQuery		+=		    "E2_VENCREA, E2_HIST, E2_ITEMD, E2_CLVLDB, "
_cQuery		+=		    "E2_USERLGI, "  								// incluido por Renato Carlos em 12/07/2011 - OS 1929/11
_cQuery		+=		    "E2_FILORIG, "  								    // incluido por Jose Maria em 10/110/2011 - OS 2405/11
//_cQuery		+=			"STR((E2_VALOR+E2_ISS+E2_INSS+E2_IRRF),12,2) AS E2_VALOR, "
//_cQuery		+=		    "STR(((E2_VLRORIG + E2_COFINS)-E2_SALDO),12,2) AS E2_PAGO, "
//_cQuery		+=			"STR(E2_SALDO,12,2) AS E2_SALDO, E2_MULTNAT, E2_ORIGEM, "
_cQuery		+=			"(E2_VALOR+E2_ISS+E2_INSS+E2_IRRF) AS E2_VALOR, "
_cQuery		+=		    "((E2_VLRORIG + E2_COFINS)-E2_SALDO) AS E2_PAGO, "
_cQuery		+=			"E2_SALDO AS E2_SALDO, E2_MULTNAT, E2_ORIGEM, "
_cQuery     +=			"F1_ESPECIE, "					// By Douglas David OS 3609/14
_cQuery     +=			"F1_DTDIGIT DTDIGITA, "					// incluido por Daniel G.Jr. em 02/10/2007
_cQuery     +=			"D1_XDTAQUI COMPET "					// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
//_cQuery     +=			"D1_ITEMCTA UNINEG, "				// incluido por Alecsandro Amaro em 03/07/2008
//_cQuery     +=			"D1_CLVL OPERACAO "			    	// incluido por Alecsandro Amaro em 03/07/2008
_cQuery		+=	  "FROM "+RetSqlName('SE2')+" SE2 "
///////////////////////////////////////////
// incluido por Daniel G.Jr. em 02/10/2007
///////////////////////////////////////////
_cQuery     +=	  "LEFT OUTER JOIN "+RetSqlName("SF1")+" SF1 "
_cQuery     +=		      "ON SE2.E2_PREFIXO=SF1.F1_PREFIXO "
_cQuery     +=           "AND SE2.E2_FILORIG=SF1.F1_FILIAL "           // incluido por Jose Maria em 10/110/2011 - OS 2405/11
_cQuery     +=           "AND SE2.E2_NUM=SF1.F1_DOC "
_cQuery     +=           "AND SE2.E2_FORNECE=SF1.F1_FORNECE "
_cQuery     +=           "AND SE2.E2_LOJA=SF1.F1_LOJA "
_cQuery     +=           "AND SE2.E2_EMISSAO=SF1.F1_EMISSAO "	// incluido por Daniel G.Jr. em 23/09/2008
_cQuery		+=		     "AND SE2.D_E_L_E_T_=SF1.D_E_L_E_T_ "
///////////////////////////////////////////
// incluido por Nelson A. Pascoal em 05/05/2008
///////////////////////////////////////////
_cQuery     +=	  "LEFT OUTER JOIN "+RetSqlName("SD1")+" SD1 "
//_cQuery     +=		      "ON SE2.E2_PREFIXO=SD1.D1_SERIE "
//_cQuery     +=           "AND SE2.E2_NUM=SD1.D1_DOC "
_cQuery     +=           "ON SE2.E2_NUM=SD1.D1_DOC "
_cQuery     +=           "AND SE2.E2_FILORIG=SD1.D1_FILIAL  "           // incluido por Jose Maria em 10/110/2011 - OS 2405/11
_cQuery     +=           "AND SE2.E2_FORNECE=SD1.D1_FORNECE "
_cQuery     +=           "AND SE2.E2_LOJA=SD1.D1_LOJA "
_cQuery     +=           "AND SE2.E2_EMISSAO=SD1.D1_EMISSAO "	// incluido por Daniel G.Jr. em 23/09/2008
_cQuery		+=		     "AND SE2.D_E_L_E_T_=SD1.D_E_L_E_T_ "
///////////////////////////////////////////
_cQuery		+=	 "WHERE SE2.D_E_L_E_T_ <>'*' "
_cQuery 	+= 	   "AND E2_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
_cQuery 	+= 	   "AND E2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
_cQuery 	+= 	   "AND E2_VENCREA BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' "
_cQuery 	+= 	   "AND E2_TIPO BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
// Ricardo 24/08/2005
_cQuery		+=	   "AND ((E2_CCUSTO BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"') OR E2_MULTNAT='1') "
// ROBERTO 01/06/2006
IF MV_PAR15 == 1
	_cQuery	+=	   "AND E2_RATCSU = 'S' AND E2_MULTNAT = '1' "
ENDIF
_cQuery		+=	 "ORDER BY  E2_FORNECE,  E2_NATUREZ,  E2_CCUSTO	"

MemoWrite("C:\CMGA001.sql",_cQuery)

IF Select("TRBX")>0
	TRBX->(dbCloseArea())
Endif

IncProc("Obtendo os Dados do Financeiro")

TCQUERY _cQuery NEW ALIAS "TRBX"

TCSetField("TRBX","E2_EMISSAO","D",8,0)
TCSetField("TRBX","E2_VENCREA","D",8,0)
TCSetField("TRBX","DTDIGITA","D",8,0)
TCSetField("TRBX","E2_VALOR","N",17,2)
TCSetField("TRBX","E2_SALDO","N",17,2)
TCSetField("TRBX","COMPET","C",7,0)
TCSetField("TRBX","E2_ITEMD","C",9,0)			// incluido por Alecsandro Amaro em 03/07/2008
TCSetField("TRBX","E2_CLVLDB","C",9,0)			// incluido por Alecsandro Amaro em 03/07/2008
TCSetField("TRBX","E2_PAGO","N",17,2)
TCSetField("TRBX","E2_USERLGI","C",17,0) 			    // incluido por Renato Carlos em 11/05/2011 - OS 1929/11
                                                   

If TRBX->(Eof().And.Bof())
	Aviso("A T E N C A O","Nao há dados a serem processados",{'Ok'})
	Return()
	TRBX->(dbCloseArea())
EndIf

aCampos := {}
AADD(aCampos,{"E2_PREFIXO",  	"C", TamSX3("E2_PREFIXO")[1],TamSX3("E2_PREFIXO")[2]})  //003,0})  //Comentado por Jose Maria em 17/10/2011
AADD(aCampos,{"E2_NUM",   		"C", TamSX3("E2_NUM")[1]    ,TamSX3("E2_NUM")[2]})      //006,0})  //Comentado por Jose Maria em 17/10/2011
AADD(aCampos,{"E2_PARCELA",   	"C", TamSX3("E2_PARCELA")[1],TamSX3("E2_PARCELA")[2]})  //001,0})  //Comentado por Jose Maria em 17/10/2011
AADD(aCampos,{"E2_TIPO",   		"C", TamSX3("E2_TIPO")[1]   ,TamSX3("E2_TIPO")[2]})     //003,0})  //Comentado por Jose Maria em 17/10/2011
AADD(aCampos,{"E2_FORNECE",   	"C", 006,0})
AADD(aCampos,{"E2_LOJA",   		"C", 002,0})
AADD(aCampos,{"E2_NOMFOR",   	"C", 040,0})
AADD(aCampos,{"E2_NATUREZ",   	"C", 010,0})
AADD(aCampos,{"E2_CCUSTO",   	"C", 020,0})
AADD(aCampos,{"E2_EMISSAO",   	"D", 008,0})
AADD(aCampos,{"E2_VENCREA",   	"D", 008,0})
AADD(aCampos,{"E2_HIST",   		"C", 060,0})
AADD(aCampos,{"E2_VALOR",   	"N", 017,2})
AADD(aCampos,{"E2_PAGO",   		"N", 017,2})
AADD(aCampos,{"E2_SALDO",   	"N", 017,2})
AADD(aCampos,{"E2_MULTNAT",   	"C", 001,0})
AADD(aCampos,{"DTDIGITA",		"D", 008,0})		// incluido por Daniel G.Jr. em 02/10/07
AADD(aCampos,{"COMPET",			"C", 007,0})		// incluido por Nelson A Pascoal em 05/05/08
AADD(aCampos,{"E2_ITEMD",		"C", 009,0})		// incluido por Alecsandro Amaro em 03/07/2008
AADD(aCampos,{"E2_CLVLDB",		"C", 009,0})		// incluido por Alecsandro Amaro em 03/07/2008
AADD(aCampos,{"E2_USERLGI",	   	"C", 017,0})		// incluido por Renato Carlos em 11/05/2011 - OS 1929/11

cArqTrb := CriaTrab(aCampos,.t.)
dbSelectArea("TRBX")
Copy to &cArqTrb
TRBX->(dbCloseArea())

IF Select("FIN012")>0
	FIN012->(dbCloseArea())
Endif

dbUseArea(.T.,,cArqTrb,"FIN012",.T.)

If !Empty(DtoS(MV_PAR18))
	cArqTrbX:= CriaTrab('',.f.)
	cFiltro := 'DtoS(DTDIGITA)>="'+DtoS(MV_PAR18)+'".AND.DtoS(DTDIGITA)<="'+DtoS(MV_PAR19)+'"'
	cIndice	:= "E2_FORNECE+E2_NATUREZ+E2_CCUSTO"
	IndRegua('FIN012', cArqTrbX, cIndice,, cFiltro, "Selecionando registros...",.T.)
EndIf

//PLANILHA - TITULOS - ANALITICO - COM CENTRO DE CUSTO, CONSIDERANDO RATEIO.
//ANALITICO - ANALITICO

If MV_PAR11 == 2 .AND. MV_PAR12 == 1
	Aviso("A T E N C A O","Prezado(a) Sr.(a): "+AllTrim(_UserData[1][4])+Chr(13)+" Esta opção não está disponível!"+chr(13)+"Rel Sint/Analit.?  =  Sintético"+chr(13)+"CC. Sint/Analit.?  =  Analítico",{'Ok'})
	Return
EndIf
_vDatuser:= PswRet()
_aNaturezas := {}

//PLANILHA ANALITICA
IF MV_PAR11 == 1 .AND. MV_PAR12 == 1
	CamposExc := {}
	
	AADD(CamposExc,{"PREFIXO",	  "C", TamSX3("E2_PREFIXO")[1],TamSX3("E2_PREFIXO")[2]})
	AADD(CamposExc,{"TITULO",	  "C", TamSX3("E2_NUM")[1]    ,TamSX3("E2_NUM")[2]})    //TamSX3("E2_NUM")[1]}) //Ajustado aqui por Jose Maria em 17/10/2011
	AADD(CamposExc,{"PARCELA",	  "C", TamSX3("E2_PARCELA")[1],TamSX3("E2_PARCELA")[2]})
	AADD(CamposExc,{"TIPO",		  "C", TamSX3("E2_TIPO")[1]   ,TamSX3("E2_TIPO")[2]})
	AADD(CamposExc,{"CODIFOR",	  "C", 009,0})
	AADD(CamposExc,{"FORNECEDOR", "C", 050,0})
	AADD(CamposExc,{"NATUREZA",	  "C", 041,0})
	AADD(CamposExc,{"C_CUSTO",	  "C", 061,0})
	AADD(CamposExc,{"EMISSAO",	  "D", 008,0})
	AADD(CamposExc,{"VENCTO",  	  "D", 008,0})
	AADD(CamposExc,{"DTDIGITA",   "D", 008,0})		// incluido por Daniel G.Jr. em 02/10/07
	AADD(CamposExc,{"HISTORICO",  "C", 060,0})
	AADD(CamposExc,{"VALOR",	  "N", 017,2})
	AADD(CamposExc,{"COMPET",	  "C", 007,0})		// incluido por Nelson A Pascoal em 05/05/08
	AADD(CamposExc,{"UNINEG",	  "C", TamSX3("CTD_ITEM")[1],TamSX3("CTD_ITEM")[2]})		// incluido por Alecsandro Amaro em 03/07/08
	AADD(CamposExc,{"OPERACAO",	  "C", TamSX3("CTH_CLVL")[1],TamSX3("CTH_CLVL")[2]})		// incluido por Alecsandro Amaro em 03/07/08
	AADD(CamposExc,{"USERINC",	  "C", 030,0})		// incluido por Renato Carlos em 11/05/2011 - OS 1929/11
	AADD(CamposExc,{"PAGO",		  "N", 017,2})
	AADD(CamposExc,{"SALDO",	  "N", 017,2})
	
	
	// CRIANDO O ARQUIVO COM OS FILTROS
	IF Select("EXC")>0
		dbselectarea("EXC")
		dbclosearea()
	Endif
	cArqBD := CriaTrab(CamposExc,.t.)
	dbUseArea(.T.,,cArqBD,"EXC",.T.)
	
	dbselectarea("FIN012")
	dbgotop()
	_SUMVAL		:=	0
	_SUMPAG		:=	0
	_SUMSAL		:=	0
	_SOMAVAL	:= 	0
	_SOMAPAG	:=	0
	_SOMASAL    :=	0
	_FORNEC		:= 	""
	ENTRA		:=	1
	_CNATCUS    :=  ""
	_lLISTAR    := .F.
	
	//centro de custo analitico
	Do While FIN012->(!EOF())
		
		IF _CNATCUS <> FIN012->(E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_NATUREZ+E2_CCUSTO)
			_CNATCUS := FIN012->(E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_NATUREZ+E2_CCUSTO)
			_lLISTAR := .T.
		Endif
		
		IF _lLISTAR
			
			_Entrou++
			
			IF _FORNEC=="" .OR. _FORNEC==FIN012->E2_NOMFOR
				
				tx_prefixo 		:= 	Fin012->E2_Prefixo
				tx_numero 		:= 	Fin012->E2_Num
				tx_parc 		:= 	Fin012->E2_Parcela
				tx_tipo 		:= 	Fin012->E2_Tipo
				tx_codforn 		:= 	Fin012->E2_Fornece
				tx_loja 		:= 	Fin012->E2_Loja
				_CODIFOR 		:= 	Fin012->E2_Fornece	+"-"+Fin012->E2_Loja
				//VERIFICANDO SE TEM RATEIO DE CENTRO DE CUSTO
				dbselectarea("SEZ")
				dbgotop()
				dbsetorder(1)
				
				If SEZ->(dbseek(xFilial("SEZ")+tx_prefixo+tx_numero+tx_parc+tx_tipo+tx_codforn+tx_loja,.F.)) .and. SEZ->EZ_CCUSTO <> '0901111111'
					
					ENTRA	:= 1
					_FORNEC	:= ""
					while xFilial()== SEZ->EZ_FILIAL .AND. tx_prefixo == SEZ->EZ_PREFIXO .AND.;
						tx_numero == SEZ->EZ_NUM .AND. tx_parc == SEZ->EZ_PARCELA .AND.;
						tx_tipo == SEZ->EZ_TIPO .AND. tx_codforn == SEZ->EZ_CLIFOR .AND.;
						tx_loja == SEZ->EZ_LOJA .AND. SEZ->EZ_NATUREZ >= MV_PAR07 .AND.;
						SEZ->EZ_NATUREZ <= MV_PAR08
						
						IF sez->(ez_ccusto>=mv_par13.and.ez_ccusto<=mv_par14)
							
							RecLock("EXC",.T.)
							IF MV_PAR17 == 2
								EXC->PREFIXO	:=	IIF(ENTRA==1,FIN012->F1_ESPECIE,"")
								EXC->TITULO		:=	IIF(ENTRA==1,FIN012->E2_NUM,"")
								EXC->PARCELA	:=	IIF(ENTRA==1,FIN012->E2_PARCELA,"")
								EXC->TIPO		:=	IIF(ENTRA==1,FIN012->E2_TIPO,"")
								EXC->CODIFOR	:=	IIF(ENTRA==1,FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA,"")
								EXC->FORNECEDOR	:=	IIF(ENTRA==1,POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME"),"")
								EXC->NATUREZA	:=	IIF(ENTRA==1,"RATEIO (VLR. R$ "+ALLTRIM(TRANSFORM(FIN012->E2_VALOR, "@E 99,999,999,999.99"))+")",SEZ->EZ_NATUREZ+" - "+POSICIONE("SED",1,XFILIAL("FIN012")+SEZ->EZ_NATUREZ,"ED_DESCRIC"))
								EXC->C_CUSTO	:=	IIF(ENTRA==1,"",AllTrim(SEZ->EZ_CCUSTO)+" - "+AllTrim(POSICIONE("CTT",1,XFILIAL("FIN012")+SEZ->EZ_CCUSTO,"CTT_DESC01")))
								EXC->EMISSAO	:=	IIF(ENTRA==1,FIN012->E2_EMISSAO,CTOD(""))
								EXC->VENCTO		:=	IIF(ENTRA==1,FIN012->E2_VENCREA,CTOD(""))
								EXC->HISTORICO	:=	IIF(ENTRA==1,FIN012->E2_HIST,"")
								EXC->VALOR		:=	IIF(ENTRA==1,FIN012->E2_VALOR,SEZ->EZ_VALOR)
								EXC->PAGO		:=	IIF(ENTRA==1,FIN012->E2_PAGO,0)
								EXC->SALDO		:=	IIF(ENTRA==1,FIN012->E2_SALDO,0)
								EXC->DTDIGITA	:=	IIF(ENTRA==1,FIN012->DTDIGITA,CTOD(""))		// incluido por Daniel G.Jr. em 02/10/2007
								EXC->COMPET		:=	IIF(ENTRA==1,FIN012->COMPET,"")		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
								EXC->UNINEG 	:=	IIF(ENTRA==1,"",SEZ->EZ_ITEMCTA)	    // incluido por Alecsandro Amaro em 03/07/2008 // alterado por Daniel G.Jr. 28/08/08
								EXC->OPERACAO	:=	IIF(ENTRA==1,"",SEZ->EZ_CLVL)		// incluido por Alecsandro Amaro em 03/07/2008 // alterado por Daniel G.Jr. 28/08/08
			     				_cUsuInc:=''
								PswOrder(2)
								If PswSeek(Left(Embaralha(FIN012->E2_USERLGI,1),15))
									_cUsuInc := UsrFullName(PswId())
								ElseIf PswSeek(Alltrim(Left(Embaralha(FIN012->E2_USERLGI,1),15))+"*")
									_cUsuInc := UsrFullName(PswId())
								Else
									PswOrder(1)						                                  
										cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
										cID:=ALLTRIM(substr(cID,3,6))
										_cUsuInc := UsrFullName(cID)														
								EndIf	
								EXC->USERINC:=	_cUsuInc	// incluido por Renato Carlos em 12/07/2011
								
								//MELHORIA PARA EXIBICAO DO NOME DO USUARIO PELO ID			  
								//OS1237/12 - //FERNANDO BARRETO
						  /*		IF Empty (_cUsuInc) 
									PswOrder(1)
									If PswSeek(Left(EMBARALHA(FIN012->E2_USERLGI,1),15))                                   
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)
									EXC->USERINC	:=	_cUsuInc
					            ENDIF   */           
								// FIM DA MELHORIA
							ELSE
								EXC->PREFIXO	:=	FIN012->F1_ESPECIE
								EXC->TITULO		:=	FIN012->E2_NUM
								EXC->PARCELA	:=	FIN012->E2_PARCELA
								EXC->TIPO		:=	FIN012->E2_TIPO
								EXC->CODIFOR	:=	FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA
								EXC->FORNECEDOR	:=	POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME")
								EXC->NATUREZA	:=	SEZ->EZ_NATUREZ+" - "+POSICIONE("SED",1,XFILIAL("FIN012")+SEZ->EZ_NATUREZ,"ED_DESCRIC")
								EXC->C_CUSTO	:=	AllTrim(SEZ->EZ_CCUSTO)+" - "+AllTrim(POSICIONE("CTT",1,XFILIAL("FIN012")+SEZ->EZ_CCUSTO,"CTT_DESC01"))
								EXC->EMISSAO	:=	FIN012->E2_EMISSAO
								EXC->VENCTO		:=	FIN012->E2_VENCREA
								EXC->HISTORICO	:=	FIN012->E2_HIST
								EXC->VALOR		:=	SEZ->EZ_VALOR//VAL(FIN012->E2_VALOR)
								EXC->PAGO		:=	0 //VAL(FIN012->E2_PAGO)
								EXC->SALDO		:=	FIN012->E2_SALDO
								EXC->DTDIGITA	:=	FIN012->DTDIGITA	// incluido por Daniel G.Jr. em 02/10/2007
								EXC->COMPET		:=	FIN012->COMPET		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
								EXC->UNINEG 	:=	SEZ->EZ_ITEMCTA		// incluido por Alecsandro Amaro em 03/07/2008 // alterado por Daniel G.Jr. 28/08/08
								EXC->OPERACAO	:=	SEZ->EZ_CLVL   		// incluido por Alecsandro Amaro em 03/07/2008 // alterado por Daniel G.Jr. 28/08/08
					     		_cUsuInc:=''
								PswOrder(2)
								If PswSeek(Left(Embaralha(FIN012->E2_USERLGI,1),15))
									_cUsuInc := UsrFullName(PswId())
								ElseIf PswSeek(Alltrim(Left(Embaralha(FIN012->E2_USERLGI,1),15))+"*")
									_cUsuInc := UsrFullName(PswId())
								Else
									PswOrder(1)						                                  
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)																	
								EndIf	
								EXC->USERINC:=	_cUsuInc	// incluido por Renato Carlos em 12/07/2011
								
								//MELHORIA PARA EXIBICAO DO NOME DO USUARIO PELO ID			  
								//OS1237/12 - //FERNANDO BARRETO
						  /*		IF Empty (_cUsuInc) 
									PswOrder(1)
									If PswSeek(Left(EMBARALHA(FIN012->E2_USERLGI,1),15))                                   
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)
									EXC->USERINC	:=	_cUsuInc
					            ENDIF   */           
								// FIM DA MELHORIA
							ENDIF
							
							MsUnLock()
							If Entra == 1
								_SOMAVAL			+= 		FIN012->E2_VALOR
								_SOMAPAG			+= 		FIN012->E2_PAGO
								_SOMASAL    		+=		FIN012->E2_SALDO
							EndIf
							_FORNEC	:=	FIN012->E2_NOMFOR
							DBSELECTAREA("SEZ")
							DBSKIP()
							ENTRA++
						Else
							DBSELECTAREA("SEZ")
							DBSKIP()
							loop
						Endif
						
					EndDo
					
				Else
					
					Dbselectarea("SEV")
					dbgotop()
					dbsetorder(1)
					
					If SEV->(dbseek(xFilial()+tx_prefixo+tx_numero+tx_parc+tx_tipo+tx_codforn+tx_loja,.F.))
						
						ENTRA	:= 1
						_FORNEC	:= ""
						while xFilial()== SEV->EV_FILIAL .AND. tx_prefixo == SEV->EV_PREFIXO .AND.;
							tx_numero == SEV->EV_NUM .AND. tx_parc == SEV->EV_PARCELA .AND.;
							tx_tipo == SEV->EV_TIPO .AND. tx_codforn == SEV->EV_CLIFOR .AND.;
							tx_loja == SEV->EV_LOJA .AND. SEV->EV_NATUREZ >= MV_PAR07 .AND.;
							SEV->EV_NATUREZ <= MV_PAR08
							
//							RecLock("EXC",.T.)
							cAnoMes	:= SUBSTR(FIN012->COMPET,4,4)+SUBSTR(FIN012->COMPET,1,2) 	//Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
							cUltRev	:= U_RZB7ULTR(SEV->EV_XCODRAT,cAnoMes,.T.)
//							MsUnLock()
							
							Dbselectarea("ZB8")
							dbgotop()
							dbsetorder(1)
							
							//						If !(ZB8->(dbseek(xFilial() + SEV->EV_XCODRAT + Substr(DtoS(FIN012->E2_EMISSAO),1,6),.F.)))
							If !dbSeek(xFilial("ZB8")+SEV->EV_XCODRAT+cAnoMes+cUltRev,.F.)
								
								RecLock("EXC",.T.)
								EXC->PREFIXO		:=		FIN012->F1_ESPECIE //IIF(ENTRA==1,FIN012->E2_PREFIXO,"")
								EXC->TITULO			:=		FIN012->E2_NUM //IIF(ENTRA==1,FIN012->E2_NUM,"")
								EXC->PARCELA		:=		FIN012->E2_PARCELA //IIF(ENTRA==1,FIN012->E2_PARCELA,"")
								EXC->TIPO			:=		FIN012->E2_TIPO //IIF(ENTRA==1,FIN012->E2_TIPO,"")
								EXC->CODIFOR		:=		FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA //IIF(ENTRA==1,FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA,"")
								EXC->FORNECEDOR		:=		POSICIONE("SA2",1,XFILIAL("SA2")+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME")  //IIF(ENTRA==1,POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME"),"")
								//Tatiana - OS 1026/11	EXC->NATUREZA		:=		"RATEIO2 (VLR. R$"+ALLTRIM(FIN012->E2_VALOR)+")" //IIF(ENTRA==1,"RATEIO (VLR. R$"+ALLTRIM(FIN012->E2_VALOR)+")",SEV->EV_NATUREZ+" - "+POSICIONE("SED",1,XFILIAL("FIN012")+SEV->EV_NATUREZ,"ED_DESCRIC"))
								EXC->NATUREZA		:=		SEV->EV_NATUREZ+" - "+POSICIONE("SED",1,XFILIAL("FIN012")+SEV->EV_NATUREZ,"ED_DESCRIC")
								//Tatiana - OS 1026/11	EXC->C_CUSTO		:=		""
								EXC->C_CUSTO		:=		AllTrim(SEV->EV_XCCTRAN)+" - "+AllTrim(POSICIONE("CTT",1,XFILIAL("FIN012")+SEV->EV_XCCTRAN,"CTT_DESC01"))
								EXC->EMISSAO		:=		FIN012->E2_EMISSAO //IIF(ENTRA==1,STOD(FIN012->E2_EMISSAO),CTOD(""))
								EXC->VENCTO			:=		FIN012->E2_VENCREA //IIF(ENTRA==1,STOD(FIN012->E2_VENCREA),CTOD(""))
								EXC->HISTORICO		:=		FIN012->E2_HIST //IIF(ENTRA==1,FIN012->E2_HIST,"")
								EXC->VALOR			:=		SEV->EV_VALOR//VAL(FIN012->E2_VALOR) //IIF(ENTRA==1,VAL(FIN012->E2_VALOR),SEV->EV_VALOR)
								EXC->DTDIGITA		:=		FIN012->DTDIGITA		// incluido por Daniel G.Jr. em 02/10/2007
								EXC->COMPET			:=		FIN012->COMPET			// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
								EXC->UNINEG  		:=		AllTrim(SEV->EV_XITTRAN)
								EXC->OPERACAO		:=		AllTrim(SEV->EV_XCLTRAN)
						    	_cUsuInc:=''
								PswOrder(2)
								If PswSeek(Left(Embaralha(FIN012->E2_USERLGI,1),15))
									_cUsuInc := UsrFullName(PswId())
								ElseIf PswSeek(Alltrim(Left(Embaralha(FIN012->E2_USERLGI,1),15))+"*")
									_cUsuInc := UsrFullName(PswId())
								Else
									PswOrder(1)						                                  
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)									
								EndIf	
								EXC->USERINC:=	_cUsuInc	// incluido por Renato Carlos em 12/07/2011
								
								//MELHORIA PARA EXIBICAO DO NOME DO USUARIO PELO ID			  
								//OS1237/12 - //FERNANDO BARRETO
						  /*		IF Empty (_cUsuInc) 
									PswOrder(1)
									If PswSeek(Left(EMBARALHA(FIN012->E2_USERLGI,1),15))                                   
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)
									EXC->USERINC	:=	_cUsuInc
					            ENDIF   */           
								// FIM DA MELHORIA
								Msunlock()
							Else
								
								While ZB8->(!EOF()) .And. SEV->EV_XCODRAT == ZB8->ZB8_CODRAT .And. ZB8->ZB8_ANOMES == cAnoMes
									IF ZB8->(ZB8_CCDBTO>=mv_par13.and.ZB8_CCDBTO<=mv_par14)
										RecLock("EXC",.T.)
										IF MV_PAR17 == 2
											EXC->PREFIXO		:=		IIF(ENTRA==1,FIN012->F1_ESPECIE,"")
											EXC->TITULO			:=		IIF(ENTRA==1,FIN012->E2_NUM,"")
											EXC->PARCELA		:=		IIF(ENTRA==1,FIN012->E2_PARCELA,"")
											EXC->TIPO			:=		IIF(ENTRA==1,FIN012->E2_TIPO,"")
											EXC->CODIFOR		:=		IIF(ENTRA==1,FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA,"")
											EXC->FORNECEDOR		:=		IIF(ENTRA==1,POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME"),"")
											EXC->NATUREZA		:=		IIF(ENTRA==1,"RATEIO (VLR. R$ "+ALLTRIM(TRANSFORM(SEV->EV_VALOR, "@E 99,999,999,999.99"))+")",SEV->EV_NATUREZ+" - "+POSICIONE("SED",1,XFILIAL("FIN012")+SEV->EV_NATUREZ,"ED_DESCRIC"))
											EXC->C_CUSTO		:=		IIF(ENTRA==1,"",AllTrim(ZB8->ZB8_CCDBTO)+" - "+AllTrim(POSICIONE("CTT",1,XFILIAL("FIN012")+ZB8->ZB8_CCDBTO,"CTT_DESC01")))
											EXC->EMISSAO		:=		IIF(ENTRA==1,FIN012->E2_EMISSAO,CTOD(""))
											EXC->VENCTO			:=		IIF(ENTRA==1,FIN012->E2_VENCREA,CTOD(""))
											EXC->HISTORICO		:=		IIF(ENTRA==1,FIN012->E2_HIST,"")
											EXC->VALOR			:=		IIF(ENTRA==1,FIN012->E2_VALOR,SEV->EV_VALOR)
											EXC->DTDIGITA		:=		IIF(ENTRA==1,FIN012->DTDIGITA,CTOD(""))		// incluido por Daniel G.Jr. em 02/10/2007
											EXC->COMPET			:=		IIF(ENTRA==1,FIN012->COMPET,"")		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
											EXC->UNINEG  		:=		IIF(ENTRA==1,"",AllTrim(ZB8->ZB8_ITDBTO))
											EXC->OPERACAO		:=		IIF(ENTRA==1,"",AllTrim(ZB8->ZB8_CLVLDB))
									    	_cUsuInc:=''
											PswOrder(2)
											If PswSeek(Left(Embaralha(FIN012->E2_USERLGI,1),15))
												_cUsuInc := UsrFullName(PswId())
											ElseIf PswSeek(Alltrim(Left(Embaralha(FIN012->E2_USERLGI,1),15))+"*")
												_cUsuInc := UsrFullName(PswId())
											Else
												PswOrder(1)						                                  
												cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
												cID:=ALLTRIM(substr(cID,3,6))
												_cUsuInc := UsrFullName(cID)									
											EndIf	
											EXC->USERINC:=	_cUsuInc	// incluido por Renato Carlos em 12/07/2011
								
								//MELHORIA PARA EXIBICAO DO NOME DO USUARIO PELO ID			  
								//OS1237/12 - //FERNANDO BARRETO
						  /*		IF Empty (_cUsuInc) 
									PswOrder(1)
									If PswSeek(Left(EMBARALHA(FIN012->E2_USERLGI,1),15))                                   
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)
									EXC->USERINC	:=	_cUsuInc
					            ENDIF   */           
								// FIM DA MELHORIA
										ELSE
											EXC->PREFIXO		:=		FIN012->F1_ESPECIE //IIF(ENTRA==1,FIN012->E2_PREFIXO,"")
											EXC->TITULO			:=		FIN012->E2_NUM //IIF(ENTRA==1,FIN012->E2_NUM,"")
											EXC->PARCELA		:=		FIN012->E2_PARCELA //IIF(ENTRA==1,FIN012->E2_PARCELA,"")
											EXC->TIPO			:=		FIN012->E2_TIPO //IIF(ENTRA==1,FIN012->E2_TIPO,"")
											EXC->CODIFOR		:=		FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA //IIF(ENTRA==1,FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA,"")
											EXC->FORNECEDOR		:=		POSICIONE("SA2",1,XFILIAL("SA2")+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME")  //IIF(ENTRA==1,POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME"),"")
											//Tatiana - OS 1026/11	EXC->NATUREZA		:=		"RATEIO2 (VLR. R$"+ALLTRIM(FIN012->E2_VALOR)+")" //IIF(ENTRA==1,"RATEIO (VLR. R$"+ALLTRIM(FIN012->E2_VALOR)+")",SEV->EV_NATUREZ+" - "+POSICIONE("SED",1,XFILIAL("FIN012")+SEV->EV_NATUREZ,"ED_DESCRIC"))
											EXC->NATUREZA		:=		SEV->EV_NATUREZ+" - "+POSICIONE("SED",1,XFILIAL("FIN012")+SEV->EV_NATUREZ,"ED_DESCRIC")
											//Tatiana - OS 1026/11	EXC->C_CUSTO		:=		""
											EXC->C_CUSTO		:=		AllTrim(ZB8->ZB8_CCDBTO)+" - "+AllTrim(POSICIONE("CTT",1,XFILIAL("FIN012")+ZB8->ZB8_CCDBTO,"CTT_DESC01"))
											EXC->EMISSAO		:=		FIN012->E2_EMISSAO //IIF(ENTRA==1,STOD(FIN012->E2_EMISSAO),CTOD(""))
											EXC->VENCTO			:=		FIN012->E2_VENCREA //IIF(ENTRA==1,STOD(FIN012->E2_VENCREA),CTOD(""))
											EXC->HISTORICO		:=		FIN012->E2_HIST //IIF(ENTRA==1,FIN012->E2_HIST,"")
											EXC->VALOR			+=		(SEV->EV_VALOR*ZB8->ZB8_PERCEN)/100//VAL(FIN012->E2_VALOR) //IIF(ENTRA==1,VAL(FIN012->E2_VALOR),SEV->EV_VALOR)
											EXC->DTDIGITA		:=		FIN012->DTDIGITA		// incluido por Daniel G.Jr. em 02/10/2007
											EXC->COMPET			:=		FIN012->COMPET		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
											EXC->UNINEG  		:=		AllTrim(ZB8->ZB8_ITDBTO)
											EXC->OPERACAO		:=		AllTrim(ZB8->ZB8_CLVLDB)
											_cUsuInc:=''
											PswOrder(2)
											If PswSeek(Left(Embaralha(FIN012->E2_USERLGI,1),15))
												_cUsuInc := UsrFullName(PswId())
											ElseIf PswSeek(Alltrim(Left(Embaralha(FIN012->E2_USERLGI,1),15))+"*")
												_cUsuInc := UsrFullName(PswId())
											Else
												PswOrder(1)						                                  
												cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
												cID:=ALLTRIM(substr(cID,3,6))
												_cUsuInc := UsrFullName(cID)									
											EndIf	
											EXC->USERINC:=	_cUsuInc	// incluido por Renato Carlos em 12/07/2011
											
								//MELHORIA PARA EXIBICAO DO NOME DO USUARIO PELO ID			  
								//OS1237/12 - //FERNANDO BARRETO
						  /*		IF Empty (_cUsuInc) 
									PswOrder(1)
									If PswSeek(Left(EMBARALHA(FIN012->E2_USERLGI,1),15))                                   
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)
									EXC->USERINC	:=	_cUsuInc
					            ENDIF   */           
								// FIM DA MELHORIA
										ENDIF
										MsUnlock()
									ENDIF
									ENTRA++
									ZB8->(DbSkip())
								EndDo
							EndIf
							//	EndIf
							If Entra ==1
								//EXC->PAGO			:=		FIN012->E2_PAGO //IIF(ENTRA==1,VAL(FIN012->E2_PAGO),0)
								//EXC->SALDO			:=		FIN012->E2_SALDO //IIF(ENTRA==1,VAL(FIN012->E2_SALDO),0)
								_SOMAVAL			+= 		FIN012->E2_VALOR
								_SOMAPAG			+= 		FIN012->E2_PAGO
								_SOMASAL    		+=		FIN012->E2_SALDO
							EndIf
							
							_FORNEC				:=		FIN012->E2_NOMFOR
							ENTRA++
							DbSelectArea("SEV")
							DbSkip()
							//MsUnlock()
						EndDo
					Else
						
						If Trim(FIN012->E2_ORIGEM)=="MATA100"
							cQuery := "SELECT D1_NATFULL NATUREZA, SUM(D1_TOTAL) VALOR "
							cQuery +=   "FROM "+RetSqlName("SD1")+" SD1, "
							cQuery +=           RetSqlName("SF1")+" SF1 "
							cQuery +=  "WHERE SD1.D_E_L_E_T_<>'*' AND SF1.D_E_L_E_T_<>'*' "
							cQuery +=    "AND F1_FILIAL='"+FIN012->E2_FILORIG+"' "   // incluido por Jose Maria em 10/110/2011 - OS 2405/11
							cQuery +=    "AND F1_DOC='"+FIN012->E2_NUM+"' "
							cQuery +=    "AND F1_PREFIXO='"+FIN012->E2_PREFIXO+"' "
							cQuery +=    "AND F1_FORNECE='"+FIN012->E2_FORNECE+"' "
							cQuery +=    "AND F1_LOJA='"+FIN012->E2_LOJA+"' "
							cQuery +=	 "AND D1_DOC=F1_DOC "
							cQuery +=	 "AND D1_SERIE=F1_SERIE "
							cQuery +=	 "AND D1_FORNECE=F1_FORNECE "
							cQuery +=	 "AND D1_LOJA=F1_LOJA "
							cQuery += "GROUP BY D1_NATFULL "
							cQuery += "ORDER BY D1_NATFULL "
							cQuery := ChangeQuery(cQuery)
							
							//MemoWrite("C:\CMGA001b.sql",cQuery)
							
							IF Select("D1TMP")>0
								D1TMP->(dbCloseArea())
							Endif
							
							TCQUERY cQuery NEW ALIAS "D1TMP"
							TCSetField("D1TMP","VALOR","N",15,2)
							
							_aNaturezas:={}
							D1TMP->(dbGoTop())
							While D1TMP->(!Eof().And.!Bof())
								If D1TMP->NATUREZA >= MV_PAR07 .AND. D1TMP->NATUREZA <= MV_PAR08
									//aAdd(_aNaturezas, { D1TMP->NATUREZA, Str(D1TMP->VALOR,12,2) } )
									//-----  Ajustado em 24/10/2011 Jose Maria ----//
									_nPosNat := Ascan(_aNaturezas,{|x|AllTrim(Upper(x[2])) == AllTrim(Upper(D1TMP->NATUREZA))})
									If _nPosNat > 0
										_aNaturezas[ _nPosNat ][2] += Str(D1TMP->VALOR,12,2)
									Else
										aAdd(_aNaturezas, { D1TMP->NATUREZA, Str(D1TMP->VALOR,12,2) } )
									Endif
									//---------------------------------------------//
								EndIf
								D1TMP->(dbSkip())
							End
							
							IF Select("D1TMP")>0
								D1TMP->(dbCloseArea())
							Endif
							
						EndIf
						If Len(_aNaturezas)>0
							Entra:=1
							For _Ni:=1 to Len(_aNaturezas)
								
								RecLock("EXC",.T.)
								EXC->PREFIXO		:=		FIN012->F1_ESPECIE
								EXC->TITULO			:=		FIN012->E2_NUM
								EXC->PARCELA		:=		FIN012->E2_PARCELA
								EXC->TIPO			:=		FIN012->E2_TIPO
								EXC->CODIFOR		:=		FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA //IIF(ENTRA==1,FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA,"N")
								EXC->FORNECEDOR		:=		POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME")
								EXC->NATUREZA		:=		_aNaturezas[_Ni][1]+" - "+POSICIONE("SED",1,XFILIAL("FIN012")+_aNaturezas[_Ni][1],"ED_DESCRIC")
								EXC->C_CUSTO		:=		AllTrim(FIN012->E2_CCUSTO)+" - "+AllTrim(POSICIONE("CTT",1,XFILIAL("FIN012")+FIN012->E2_CCUSTO,"CTT_DESC01"))
								EXC->EMISSAO		:=		FIN012->E2_EMISSAO
								EXC->VENCTO			:=		FIN012->E2_VENCREA
								EXC->HISTORICO		:=		FIN012->E2_HIST
								EXC->DTDIGITA		:=		FIN012->DTDIGITA		// incluido por Daniel G.Jr. em 02/10/2007
								EXC->VALOR			:=		VAL(_aNaturezas[_Ni][2])
								EXC->COMPET			:=		FIN012->COMPET		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
								EXC->UNINEG  		:=		FIN012->E2_ITEMD	// incluido por Alecsandro Amaro em 03/07/2008
								EXC->OPERACAO		:=		FIN012->E2_CLVLDB  	// incluido por Alecsandro Amaro em 03/07/2008
								_cUsuInc:=''
								PswOrder(2)
								If PswSeek(Left(Embaralha(FIN012->E2_USERLGI,1),15))
									_cUsuInc := UsrFullName(PswId())
								ElseIf PswSeek(Alltrim(Left(Embaralha(FIN012->E2_USERLGI,1),15))+"*")
									_cUsuInc := UsrFullName(PswId())
								Else
									PswOrder(1)						                                  
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)									
								EndIf	
								EXC->USERINC:=	_cUsuInc	// incluido por Renato Carlos em 12/07/2011
								
								//MELHORIA PARA EXIBICAO DO NOME DO USUARIO PELO ID			  
								//OS1237/12 - //FERNANDO BARRETO
						  /*		IF Empty (_cUsuInc) 
									PswOrder(1)
									If PswSeek(Left(EMBARALHA(FIN012->E2_USERLGI,1),15))                                   
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)
									EXC->USERINC	:=	_cUsuInc
					            ENDIF   */           
								// FIM DA MELHORIA
								If Entra==1
									EXC->PAGO		:=		FIN012->E2_PAGO
									EXC->SALDO		:=		FIN012->E2_SALDO
									_SOMAVAL		+= 		FIN012->E2_VALOR
									_SOMAPAG		+= 		FIN012->E2_PAGO
									_SOMASAL   		+=		FIN012->E2_SALDO
								EndIf
								EXC->(MsUnLock())
								_FORNEC				:=		""
								Entra++
							Next _Ni
						Else
							If SE2->E2_NATUREZ >= MV_PAR07 .AND. SE2->E2_NATUREZ <= MV_PAR08
								RecLock("EXC",.T.)
								EXC->PREFIXO		:=		FIN012->F1_ESPECIE
								EXC->TITULO			:=		FIN012->E2_NUM
								EXC->PARCELA		:=		FIN012->E2_PARCELA
								EXC->TIPO			:=		FIN012->E2_TIPO
								EXC->CODIFOR		:=		FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA //IIF(ENTRA==1,FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA,"N")
								EXC->FORNECEDOR		:=		POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME")
								EXC->NATUREZA		:=		FIN012->E2_NATUREZ+" - "+POSICIONE("SED",1,XFILIAL("FIN012")+FIN012->E2_NATUREZ,"ED_DESCRIC")
								EXC->C_CUSTO		:=		AllTrim(FIN012->E2_CCUSTO)+" - "+AllTrim(POSICIONE("CTT",1,XFILIAL("FIN012")+FIN012->E2_CCUSTO,"CTT_DESC01"))
								EXC->EMISSAO		:=		FIN012->E2_EMISSAO
								EXC->VENCTO			:=		FIN012->E2_VENCREA
								EXC->HISTORICO		:=		FIN012->E2_HIST
								EXC->VALOR			:=		FIN012->E2_VALOR
								EXC->PAGO			:=		FIN012->E2_PAGO
								EXC->SALDO			:=		FIN012->E2_SALDO
								EXC->DTDIGITA		:=		FIN012->DTDIGITA		// incluido por Daniel G.Jr. em 02/10/2007
								EXC->COMPET			:=		FIN012->COMPET		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
								EXC->UNINEG 		:=		FIN012->E2_ITEMD  		// incluido por Alecsandro Amaro em 03/07/2008
								EXC->OPERACAO		:=		FIN012->E2_CLVLDB		// incluido por Alecsandro Amaro em 03/07/2008
								_cUsuInc:=''
								PswOrder(2)
								If PswSeek(Left(Embaralha(FIN012->E2_USERLGI,1),15))
									_cUsuInc := UsrFullName(PswId())
								ElseIf PswSeek(Alltrim(Left(Embaralha(FIN012->E2_USERLGI,1),15))+"*")
									_cUsuInc := UsrFullName(PswId())
								Else
									PswOrder(1)						                                  
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)									
								EndIf	
								EXC->USERINC:=	_cUsuInc	// incluido por Renato Carlos em 12/07/2011
								
								//MELHORIA PARA EXIBICAO DO NOME DO USUARIO PELO ID			  
								//OS1237/12 - //FERNANDO BARRETO
						  /*		IF Empty (_cUsuInc) 
									PswOrder(1)
									If PswSeek(Left(EMBARALHA(FIN012->E2_USERLGI,1),15))                                   
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)
									EXC->USERINC	:=	_cUsuInc
					            ENDIF   */           
								// FIM DA MELHORIA
								MsUnLock()
								_SOMAVAL			+= 		FIN012->E2_VALOR
								_SOMAPAG			+= 		FIN012->E2_PAGO
								_SOMASAL    		+=		FIN012->E2_SALDO
								_FORNEC				:=		""
							EndIf
						EndIf
					EndIf
				ENDIF
				
			EndIf
			
			_SUMVAL		+=	FIN012->E2_VALOR
			_SUMPAG		+=	FIN012->E2_PAGO
			_SUMSAL		+=	FIN012->E2_SALDO
			
		ENDIF
		
		dbSelectArea("FIN012")
		dbSkip()
		
		IF _CNATCUS == FIN012->(E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_NATUREZ+E2_CCUSTO)
			_lLISTAR := .F.
		Endif
		
		IF  _FORNEC <> FIN012->E2_NOMFOR
			IF MV_PAR16 == 1
				LinhaBr()
				RecLock("EXC",.T.)
				EXC->CODIFOR		:=		_CODIFOR
				EXC->FORNECEDOR		:=		POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME")
				EXC->PREFIXO		:=		""
				EXC->TITULO			:=		"TOTAL"
				EXC->PARCELA		:=		""
				EXC->TIPO			:=		""
				EXC->NATUREZA		:=		""
				EXC->C_CUSTO		:=		""
				EXC->EMISSAO		:=		CTOD("")
				EXC->VENCTO			:=		CTOD("")
				EXC->HISTORICO		:=		""
				EXC->VALOR			:=		_SOMAVAL
				EXC->PAGO			:=		_SOMAPAG
				EXC->SALDO			:=		_SOMASAL
				EXC->DTDIGITA		:=		CTOD("")		// incluido por Daniel G.Jr. em 02/10/2007
				EXC->COMPET			:=		""		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
				EXC->UNINEG			:=		""		// incluido por Alecsandro Amaro em 03/07/2008
				EXC->OPERACAO		:=		""		// incluido por Alecsandro Amaro em 03/07/2008
				EXC->USERINC		:=		""	// incluido por Renato Carlos em 12/07/2011
				EXC->(MsUnLock())
				_SOMAVAL			:= 		0
				_SOMAPAG			:=		0
				_SOMASAL    		:=		0
				_FORNEC				:=	   ""
				LinhaBr()
			ENDIF
			
		ENDIF
		dbSelectArea("FIN012")
		_FORNEC			:=	   FIN012->E2_NOMFOR
		
	Enddo
	
	If _Entrou == 0
		Aviso("A T E N C A O","Prezado(a) Sr.(a): "+AllTrim(_UserData[1][4])+Chr(13)+"Nao existem dados para serem gerados",{'Ok'})
		Return
	EndIf
	IF MV_PAR16 == 1
		LinhaBr()
		RecLock("EXC",.T.)
		EXC->CODIFOR		:=		_CODIFOR
		EXC->FORNECEDOR		:=		POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME")
		EXC->PREFIXO		:=		""
		EXC->TITULO			:=		"TOTAL"
		EXC->PARCELA		:=		""
		EXC->TIPO			:=		""
		EXC->NATUREZA		:=		""
		EXC->C_CUSTO		:=		""
		EXC->EMISSAO		:=		CTOD("")
		EXC->VENCTO			:=		CTOD("")
		EXC->HISTORICO		:=		""
		EXC->VALOR			:=		_SOMAVAL
		EXC->PAGO			:=		_SOMAPAG
		EXC->SALDO			:=		_SOMASAL
		EXC->DTDIGITA		:=		CTOD("")
		EXC->COMPET			:=		""		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
		EXC->UNINEG			:=		""		// incluido por Alecsandro Amaro em 03/07/2008
		EXC->OPERACAO		:=		""		// incluido por Alecsandro Amaro em 03/07/2008
		EXC->USERINC		:=		""   	// incluido por Renato Carlos em 12/07/2011
		MsUnLock()
		_SOMAVAL			:= 		0
		_SOMAPAG			:=		0
		_SOMASAL    		:=		0
		_FORNEC				:=		""
		LinhaBr()
		LinhaBr()
		LinhaBr()
	ENDIF
	
	/* Inibir a apresentacao do total geral
	RecLock("EXC",.T.)
	EXC->CODIFOR		:=		""
	EXC->FORNECEDOR		:=		"TOTAL GERAL"
	EXC->PREFIXO		:=		""
	EXC->TITULO			:=		""
	EXC->PARCELA		:=		""
	EXC->TIPO			:=		""
	EXC->NATUREZA		:=		""
	EXC->C_CUSTO		:=		""
	EXC->EMISSAO		:=		CTOD("")
	EXC->VENCTO			:=		CTOD("")
	EXC->HISTORICO		:=		""
	EXC->VALOR			:=		_SUMVAL
	EXC->PAGO			:=		_SUMPAG
	EXC->SALDO			:=		_SUMSAL
	MsUnLock()
	*/
	OpExcel(cArqBD)
	
EndIf

//PLANILHA - TITULOS - ANALITICO - COM CENTRO DE CUSTO, SEM CONSIDERAR RATEIO.

IF MV_PAR12 == 2 .AND. MV_PAR11 == 1
	//ANALITICO - SINTETICO
	CamposExc := {}
	
	AADD(CamposExc,{"CODIFOR",	  "C", 009,0})
	AADD(CamposExc,{"FORNECEDOR", "C", 050,0})
	AADD(CamposExc,{"PREFIXO",	  "C", TamSX3("E2_PREFIXO")[1],TamSX3("E2_PREFIXO")[2]})  //003,0})
	AADD(CamposExc,{"TITULO",	  "C", TamSX3("E2_NUM")[1]    ,TamSX3("E2_NUM")[2]})      //006,0})
	AADD(CamposExc,{"PARCELA",	  "C", TamSX3("E2_PARCELA")[1],TamSX3("E2_PARCELA")[2]})  //001,0})
	AADD(CamposExc,{"TIPO",		  "C", TamSX3("E2_TIPO")[1]   ,TamSX3("E2_TIPO")[2]})     //003,0})
	AADD(CamposExc,{"NATUREZA",	  "C", 041,0})
	AADD(CamposExc,{"C_CUSTO",	  "C", 061,0})
	AADD(CamposExc,{"EMISSAO",	  "D", 008,0})
	AADD(CamposExc,{"DTDIGITA",	  "D", 008,0})		// incluido por Daniel G.Jr. em 02/10/2007
	AADD(CamposExc,{"VENCTO",	  "D", 008,0})
	AADD(CamposExc,{"HISTORICO",  "C", 060,0})
	AADD(CamposExc,{"VALOR",	  "N", 017,2})
	AADD(CamposExc,{"COMPET",	  "C", 007,0})		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
	AADD(CamposExc,{"UNINEG",	  "C", 009,0})		// incluido por Alecsandro Amaro em 03/07/2008
	AADD(CamposExc,{"OPERACAO",	  "C", 009,0})		// incluido por Alecsandro Amaro em 03/07/2008
	AADD(CamposExc,{"USERINC",	  "C", 030,0})		// incluido por Daniel G.Jr. em 12/07/2011
	AADD(CamposExc,{"PAGO",		  "N", 017,2})
	AADD(CamposExc,{"SALDO",	  "N", 017,2})
	
	// CRIANDO O ARQUIVO COM OS FILTROS
	IF Select("EXC")>0
		dbselectarea("EXC")
		dbclosearea()
	Endif
	cArqBD := CriaTrab(CamposExc,.t.)
	dbUseArea(.T.,,cArqBD,"EXC",.T.)
	
	DBSELECTAREA("FIN012")
	DBGOTOP()
	_SUMVAL		:=	0
	_SUMPAG		:=	0
	_SUMSAL		:=	0
	_SOMAVAL	:= 	0
	_SOMAPAG	:=	0
	_SOMASAL    :=	0
	_FORNEC		:= 	""
	_ILFOR		:=	""
	ENTRA		:=	1
	While FIN012->(!EOF())		// .AND. SE2->E2_NATUREZ >= MV_PAR07 .AND. SE2->E2_NATUREZ <= MV_PAR08
		
		IF _FORNEC=="" .OR. _FORNEC==FIN012->E2_NOMFOR
			
			If Trim(FIN012->E2_ORIGEM)=="MATA100"
				cQuery := "SELECT D1_NATFULL NATUREZA, SUM(D1_TOTAL) VALOR "
				cQuery +=   "FROM "+RetSqlName("SD1")+" SD1, "
				cQuery +=           RetSqlName("SF1")+" SF1 "
				cQuery +=  "WHERE SD1.D_E_L_E_T_<>'*' AND SF1.D_E_L_E_T_<>'*' "
				cQuery +=    "AND F1_FILIAL='"+FIN012->E2_FILORIG+"' "   // incluido por Jose Maria em 10/110/2011 - OS 2405/11
				cQuery +=    "AND F1_DOC='"+FIN012->E2_NUM+"' "
				cQuery +=    "AND F1_PREFIXO='"+FIN012->E2_PREFIXO+"' "
				cQuery +=    "AND F1_FORNECE='"+FIN012->E2_FORNECE+"' "
				cQuery +=    "AND F1_LOJA='"+FIN012->E2_LOJA+"' "
				cQuery +=	 "AND D1_DOC=F1_DOC "
				cQuery +=	 "AND D1_SERIE=F1_SERIE "
				cQuery +=	 "AND D1_FORNECE=F1_FORNECE "
				cQuery +=	 "AND D1_LOJA=F1_LOJA "
				cQuery += "GROUP BY D1_NATFULL "
				cQuery += "ORDER BY D1_NATFULL "
				cQuery := ChangeQuery(cQuery)
				
				IF Select("D1TMP")>0
					D1TMP->(dbCloseArea())
				Endif
				
				TCQUERY cQuery NEW ALIAS "D1TMP"
				TCSetField("D1TMP","VALOR","N",15,2)
				
				_aNaturezas:={}
				D1TMP->(dbGoTop())
				While D1TMP->(!Eof().And.!Bof())
					If D1TMP->NATUREZA >= MV_PAR07 .AND. D1TMP->NATUREZA <= MV_PAR08
						//aAdd(_aNaturezas, { D1TMP->NATUREZA, Str(D1TMP->VALOR,12,2) } )
						//-----  Ajustado em 24/10/2011 Jose Maria ----//
						_nPosNat := Ascan(_aNaturezas,{|x|AllTrim(Upper(x[2])) == AllTrim(Upper(D1TMP->NATUREZA))})
						If _nPosNat > 0
							_aNaturezas[ _nPosNat ][2] += Str(D1TMP->VALOR,12,2)
						Else
							aAdd(_aNaturezas, { D1TMP->NATUREZA, Str(D1TMP->VALOR,12,2) } )
						Endif
						//---------------------------------------------//
					EndIf
					D1TMP->(dbSkip())
				End
				
				IF Select("D1TMP")>0
					D1TMP->(dbCloseArea())
				Endif
				
			EndIf
			
			If Len(_aNaturezas)>0
				
				For _nI:=1 to Len(_aNaturezas)
					
					_Entrou++
					RecLock("EXC",.T.)
					EXC->CODIFOR		:=		""
					EXC->FORNECEDOR		:=		""
					EXC->PREFIXO		:=		FIN012->F1_ESPECIE
					EXC->TITULO			:=		FIN012->E2_NUM
					EXC->PARCELA		:=		FIN012->E2_PARCELA
					EXC->TIPO			:=		FIN012->E2_TIPO
					EXC->NATUREZA		:=		_aNaturezas[_nI][1]+" - "+POSICIONE("SED",1,XFILIAL("FIN012")+_aNaturezas[_Ni][1],"ED_DESCRIC")
					EXC->C_CUSTO		:=		AllTrim(FIN012->E2_CCUSTO)+" - "+AllTrim(POSICIONE("CTT",1,XFILIAL("FIN012")+FIN012->E2_CCUSTO,"CTT_DESC01"))
					EXC->EMISSAO		:=		FIN012->E2_EMISSAO
					EXC->VENCTO			:=		FIN012->E2_VENCREA
					EXC->HISTORICO		:=		FIN012->E2_HIST
					EXC->VALOR			:=		VAL(_aNaturezas[_nI][2])
					EXC->DTDIGITA		:=		FIN012->DTDIGITA		// incluido por Daniel G.Jr. em 02/10/2007
					EXC->COMPET			:=		FIN012->COMPET		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
					EXC->UNINEG			:=		FIN012->E2_ITEMD   	// incluido por Alecsandro Amaro em 03/07/2008
					EXC->OPERACAO		:=		FIN012->E2_CLVLDB	// incluido por Alecsandro Amaro em 03/07/2008
					_cUsuInc:=''
								PswOrder(2)
								If PswSeek(Left(Embaralha(FIN012->E2_USERLGI,1),15))
									_cUsuInc := UsrFullName(PswId())
								ElseIf PswSeek(Alltrim(Left(Embaralha(FIN012->E2_USERLGI,1),15))+"*")
									_cUsuInc := UsrFullName(PswId())
								Else
									PswOrder(1)						                                  
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)									
								EndIf	
								EXC->USERINC:=	_cUsuInc	// incluido por Renato Carlos em 12/07/2011
								
								//MELHORIA PARA EXIBICAO DO NOME DO USUARIO PELO ID			  
								//OS1237/12 - //FERNANDO BARRETO
						  /*		IF Empty (_cUsuInc) 
									PswOrder(1)
									If PswSeek(Left(EMBARALHA(FIN012->E2_USERLGI,1),15))                                   
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)
									EXC->USERINC	:=	_cUsuInc
					            ENDIF   */           
								// FIM DA MELHORIA
					If Entra==1
						LinhaBr()
						EXC->PAGO			:=		FIN012->E2_PAGO
						EXC->SALDO			:=		FIN012->E2_SALDO
						_SOMAVAL			+= 		FIN012->E2_VALOR
						_SOMAPAG			+= 		FIN012->E2_PAGO
						_SOMASAL    		+=		FIN012->E2_SALDO
					EndIf
					EXC->(MsUnLock())
					ENTRA++
				Next _nI
			Else
				If ENTRA == 1
					LinhaBr()
				EndIf
				RecLock("EXC",.T.)
				EXC->CODIFOR		:=		""
				EXC->FORNECEDOR		:=		""
				EXC->PREFIXO		:=		FIN012->F1_ESPECIE
				EXC->TITULO			:=		FIN012->E2_NUM
				EXC->PARCELA		:=		FIN012->E2_PARCELA
				EXC->TIPO			:=		FIN012->E2_TIPO
				EXC->NATUREZA		:=		FIN012->E2_NATUREZ+" - "+POSICIONE("SED",1,XFILIAL("FIN012")+FIN012->E2_NATUREZ,"ED_DESCRIC")
				EXC->C_CUSTO		:=		AllTrim(FIN012->E2_CCUSTO)+" - "+AllTrim(POSICIONE("CTT",1,XFILIAL("FIN012")+FIN012->E2_CCUSTO,"CTT_DESC01"))
				EXC->EMISSAO		:=		FIN012->E2_EMISSAO
				EXC->VENCTO			:=		FIN012->E2_VENCREA
				EXC->HISTORICO		:=		FIN012->E2_HIST
				EXC->VALOR			:=		FIN012->E2_VALOR
				EXC->PAGO			:=		FIN012->E2_PAGO
				EXC->SALDO			:=		FIN012->E2_SALDO
				EXC->DTDIGITA		:=		FIN012->DTDIGITA		// incluido por Daniel G.Jr. em 02/10/2007
				EXC->COMPET			:=		FIN012->COMPET		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
				EXC->UNINEG			:=		FIN012->E2_ITEMD   	// incluido por Alecsandro Amaro em 03/07/2008
				EXC->OPERACAO		:=		FIN012->E2_CLVLDB	// incluido por Alecsandro Amaro em 03/07/2008
				_cUsuInc:=''
								PswOrder(2)
								If PswSeek(Left(Embaralha(FIN012->E2_USERLGI,1),15))
									_cUsuInc := UsrFullName(PswId())
								ElseIf PswSeek(Alltrim(Left(Embaralha(FIN012->E2_USERLGI,1),15))+"*")
									_cUsuInc := UsrFullName(PswId())
								Else
									PswOrder(1)						                                  
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)									
								EndIf	
								EXC->USERINC:=	_cUsuInc	// incluido por Renato Carlos em 12/07/2011
								
								//MELHORIA PARA EXIBICAO DO NOME DO USUARIO PELO ID			  
								//OS1237/12 - //FERNANDO BARRETO
						  /*		IF Empty (_cUsuInc) 
									PswOrder(1)
									If PswSeek(Left(EMBARALHA(FIN012->E2_USERLGI,1),15))                                   
									cID:=Left(EMBARALHA(FIN012->E2_USERLGI,1),15)
									cID:=ALLTRIM(substr(cID,3,6))
									_cUsuInc := UsrFullName(cID)
									EXC->USERINC	:=	_cUsuInc
					            ENDIF   */           
								// FIM DA MELHORIA
				EXC->(MsUnLock())
				
				_SOMAVAL			+= 		FIN012->E2_VALOR
				_SOMAPAG			+= 		FIN012->E2_PAGO
				_SOMASAL    		+=		FIN012->E2_SALDO
				_FORNEC				:= 		FIN012->E2_NOMFOR
				_CODIFOR			:=		FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA
				_FORNE				:=		POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME")
				ENTRA++
			EndIf
		Else
			LinhaBr()
			RecLock("EXC",.T.)
			EXC->CODIFOR		:=		_CODIFOR
			EXC->FORNECEDOR		:=		_FORNE
			EXC->PREFIXO		:=		""
			EXC->TITULO			:=		""
			EXC->PARCELA		:=		""
			EXC->TIPO			:=		""
			EXC->NATUREZA		:=		""
			EXC->C_CUSTO		:=		""
			EXC->EMISSAO		:=		CTOD("")
			EXC->VENCTO			:=		CTOD("")
			EXC->HISTORICO		:=		""
			EXC->VALOR			:=		_SOMAVAL
			EXC->PAGO			:=		_SOMAPAG
			EXC->SALDO			:=		_SOMASAL
			EXC->DTDIGITA		:=		CTOD("")		// incluido por Daniel G.Jr. em 02/10/2007
			EXC->COMPET			:=		""		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
			EXC->UNINEG			:=		""		// incluido por Alecsandro Amaro em 03/07/2008
			EXC->OPERACAO		:=		""		// incluido por Alecsandro Amaro em 03/07/2008
			EXC->USERINC		:=		""	// incluido por Renato Carlos em 12/07/2011
			MsUnLock()
			_SOMAVAL			:= 		0
			_SOMAPAG			:=		0
			_SOMASAL    		:=		0
			_FORNEC				:=		""
			LinhaBr()
		EndIf
		_FORNEC				:= 		FIN012->E2_NOMFOR
		_CODIFOR			:=		FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA
		_FORNE				:=		POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME")
		_SUMVAL		+=	FIN012->E2_VALOR
		_SUMPAG		+=	FIN012->E2_PAGO
		_SUMSAL		+=	FIN012->E2_SALDO
		_ILFOR	:=	FIN012->E2_NOMFOR
		dbSelectArea("FIN012")
		dbSkip()
		
	Enddo
	
	If _Entrou == 0
		Aviso("A T E N C A O","Prezado(a) Sr.(a): "+AllTrim(_UserData[1][4])+Chr(13)+" Esta opção não está disponível!"+chr(13)+"Rel Sint/Analit.?  =  Sintético"+chr(13)+"CC. Sint/Analit.?  =  Analítico",{'Ok'})
		Return
	EndIf
	
	LinhaBr()
	RecLock("EXC",.T.)
	EXC->CODIFOR		:=		_CODIFOR
	EXC->FORNECEDOR		:=		_ILFOR
	EXC->PREFIXO		:=		""
	EXC->TITULO			:=		""
	EXC->PARCELA		:=		""
	EXC->TIPO			:=		""
	EXC->NATUREZA		:=		""
	EXC->C_CUSTO		:=		""
	EXC->EMISSAO		:=		CTOD("")
	EXC->VENCTO			:=		CTOD("")
	EXC->HISTORICO		:=		""
	EXC->VALOR			:=		_SOMAVAL
	EXC->PAGO			:=		_SOMAPAG
	EXC->SALDO			:=		_SOMASAL
	EXC->DTDIGITA		:=		CTOD("")		// incluido por Daniel G.Jr. em 02/10/2007
	EXC->COMPET			:=		""		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
	EXC->UNINEG			:=		""		// incluido por Alecsandro Amaro em 03/07/2008
	EXC->OPERACAO		:=		""		// incluido por Alecsandro Amaro em 03/07/2008
	EXC->USERINC		:=		""	// incluido por Renato Carlos em 12/07/2011
	MsUnLock()
	
	LinhaBr()
	LinhaBr()
	
	RecLock("EXC",.T.)
	EXC->CODIFOR		:=		""
	EXC->FORNECEDOR		:=		"TOTAL GERAL"
	EXC->PREFIXO		:=		""
	EXC->TITULO			:=		""
	EXC->PARCELA		:=		""
	EXC->TIPO			:=		""
	EXC->NATUREZA		:=		""
	EXC->C_CUSTO		:=		""
	EXC->EMISSAO		:=		CTOD("")
	EXC->VENCTO			:=		CTOD("")
	EXC->HISTORICO		:=		""
	EXC->VALOR			:=		_SUMVAL
	EXC->PAGO			:=		_SUMPAG
	EXC->SALDO			:=		_SUMSAL
	EXC->DTDIGITA		:=		CTOD("")		// incluido por Daniel G.Jr. em 02/10/2007
	EXC->COMPET			:=		""		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
	EXC->UNINEG			:=		""		// incluido por Alecsandro Amaro em 03/07/2008
	EXC->OPERACAO		:=		""		// incluido por Alecsandro Amaro em 03/07/2008
	EXC->USERINC		:=		""	// incluido por Renato Carlos em 12/07/2011
	MsUnLock()
	
	OpExcel(cArqBD)
	
EndIf


//PLANILHA - TITULOS - SINTETICO POR FORNECEDOR.

IF MV_PAR11 == 2 .AND. MV_PAR12 == 2
	//SINTETICO - SINTETICO
	CamposExc := {}
	
	AADD(CamposExc,{"CODIFOR",	  "C", 009,0})
	AADD(CamposExc,{"FORNECEDOR", "C", 050,0})
	AADD(CamposExc,{"VALOR",	  "N", 017,2})
	AADD(CamposExc,{"PAGO",		  "N", 017,2})
	AADD(CamposExc,{"SALDO",	  "N", 017,2})
	
	
	// CRIANDO O ARQUIVO COM OS FILTROS
	IF Select("EXC")>0
		dbselectarea("EXC")
		dbclosearea()
	Endif
	cArqBD := CriaTrab(CamposExc,.t.)
	dbUseArea(.T.,,cArqBD,"EXC",.T.)
	
	
	DBSELECTAREA("FIN012")
	DBGOTOP()
	_SUMVAL		:=	0
	_SUMPAG		:=	0
	_SUMSAL		:=	0
	_SOMAVAL	:= 	0
	_SOMAPAG	:=	0
	_SOMASAL    :=	0
	_FORNEC		:= 	""
	_ILFOR	  := ""
	ENTRA		:=	1
	
	Do While !EOF("FIN012") .AND. SE2->E2_NATUREZ >= MV_PAR07 .AND. SE2->E2_NATUREZ <= MV_PAR08
		_Entrou++
		IF 	_FORNEC 	==	"" .OR. _FORNEC	==	FIN012->E2_NOMFOR
			_SUMVAL		+=		FIN012->E2_VALOR
			_SUMPAG		+=		FIN012->E2_PAGO
			_SUMSAL		+=		FIN012->E2_SALDO
			_SOMAVAL	+= 		FIN012->E2_VALOR
			_SOMAPAG	+= 		FIN012->E2_PAGO
			_SOMASAL    +=		FIN012->E2_SALDO
			_FORNEC		:= 		FIN012->E2_NOMFOR
			_CODIFOR	:=		FIN012->E2_FORNECE +"-"+ FIN012->E2_LOJA
			ENTRA++
		Else
			LinhaBr()
			RecLock("EXC",.T.)
			EXC->CODIFOR		:=		_CODIFOR
			EXC->FORNECEDOR		:=		POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME")
			EXC->VALOR			:=		_SOMAVAL
			EXC->PAGO			:=		_SOMAPAG
			EXC->SALDO			:=		_SOMASAL
			MsUnLock()
			_SOMAVAL			:= 		0
			_SOMAPAG			:=		0
			_SOMASAL    		:=		0
			_FORNEC				:=		""
		EndIf
		_ILFOR	:=	POSICIONE("SA2",1,XFILIAL()+ALLTRIM(SUBSTR(_CODIFOR,1,6)+SUBSTR(_CODIFOR,8,2)),"A2_NOME")
		dbSelectArea("FIN012")
		dbSkip()
	Enddo
	
	If _Entrou == 0
		Aviso("A T E N C A O","Prezado(a) Sr.(a): "+AllTrim(_UserData[1][4])+Chr(13)+" Esta opção não está disponível!"+chr(13)+"Rel Sint/Analit.?  =  Sintético"+chr(13)+"CC. Sint/Analit.?  =  Analítico",{'Ok'})
		Return
	EndIf
	LinhaBr()
	RecLock("EXC",.T.)
	EXC->CODIFOR		:=		_CODIFOR
	EXC->FORNECEDOR		:=		_ILFOR
	EXC->VALOR			:=		_SOMAVAL
	EXC->PAGO			:=		_SOMAPAG
	EXC->SALDO			:=		_SOMASAL
	MsUnLock()
	
	LinhaBr()
	
	RecLock("EXC",.T.)
	EXC->CODIFOR		:=		""
	EXC->FORNECEDOR		:=		"TOTAL GERAL"
	EXC->VALOR			:=		_SUMVAL
	EXC->PAGO			:=		_SUMPAG
	EXC->SALDO			:=		_SUMSAL
	MsUnLock()
	
	OpExcel(cArqBD)
	
EndIf

if type('cArqTrb')!="U"
	If File(cArqTrb+".dbf")
		fErase(cArqTrb+".dbf")
	EndIf
endif
if type('cArqTrbX')!="U"
	If File(cArqTrbX+OrdBagExt())
		fErase(cArqTrbX+OrdBagExt())
	EndIf
endif
if type('cArqBD')!="U"
	fErase(cArqBD+".dbf")
endif

Return

//***********************
Static Function LinhaBr()

RecLock("EXC",.T.)
EXC->CODIFOR		:=		""
EXC->FORNECEDOR		:=		""
IF MV_PAR12 == 2 .AND. MV_PAR11 == 1
	EXC->PREFIXO		:=		""
	EXC->TITULO			:=		""
	EXC->PARCELA		:=		""
	EXC->TIPO			:=		""
	EXC->NATUREZA		:=		""
	EXC->C_CUSTO		:=		""
	EXC->EMISSAO		:=		CTOD("")
	EXC->VENCTO			:=		CTOD("")
	EXC->HISTORICO		:=		""
	EXC->DTDIGITA		:=		CTOD("")		// incluido por Daniel G.Jr. em 02/10/2007
	EXC->COMPET			:=		""		// Tatiana A. Barbosa - 01/09/2011 - OS 2268/11
	EXC->UNINEG			:=		""		// incluido por Alecsandro Amaro em 03/07/2008
	EXC->OPERACAO		:=		""		// incluido por Alecsandro Amaro em 03/07/2008
	EXC->USERINC		:= 		""	// incluido por Renato Carlos em 12/07/2011
ENDIF
EXC->VALOR			:=		0
EXC->PAGO			:=		0
EXC->SALDO			:=		0
MsUnLock()

Return

//******************************
Static Function OpExcel(cArqTRC)
Local cDirDocs	:= MsDocPath()
Local cPath		:= AllTrim(GetTempPath())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Copia DBF para pasta TEMP do sistema operacional da estacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If FILE(cArqTRC+".DBF")
	COPY FILE (cArqTRC+".DBF") TO (cPath+cArqTRC+".DBF")
EndIf

If !ApOleClient("MsExcel")
	MsgStop("MsExcel nao instalado.")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria link com o excel³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oExcelApp := MsExcel():New()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre uma planilha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oExcelApp:WorkBooks:Open(cPath+cArqTRC+".DBF")
oExcelApp:SetVisible(.T.)

Return()

//*************************
Static Function ValidPerg()

_sAlias := Alias()

dbSelectArea("SX1") // abre arquivo sx1 de perguntas
dbSetOrder(1)       // coloca na ordem 1 do sindex
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/        Cnt05
AADD(aRegs,{cPerg,"01","Fornecedor de   ?","Fornecedor de   ","Fornecedor de   ","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
AADD(aRegs,{cPerg,"02","Fornecedor Ate  ?","Fornecedor Ate  ","Fornecedor Ate  ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
AADD(aRegs,{cPerg,"03","Emissao de      ?","Emissao de      ","Emissao de      ","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Emissao Ate     ?","Emissao Ate     ","Emissao Ate     ","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Vencimento de   ?","Vencimento de   ","Vencimento de   ","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Vencimento Ate  ?","Vencimento ATE  ","Vencimento ATe  ","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Natureza de     ?","Natureza de     ","Natureza de     ","mv_ch7","C",10,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SED",""})
AADD(aRegs,{cPerg,"08","Natureza Ate    ?","Natureza Ate    ","Natureza aTe    ","mv_ch8","C",10,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SED",""})
AADD(aRegs,{cPerg,"09","Tipo de         ?","Tipo de         ","Tipo de         ","mv_ch9","C",03,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","05",""})
AADD(aRegs,{cPerg,"10","Tipo ate        ?","Tipo ATe        ","Tipo ATe        ","mv_ch10","C",03,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","05",""})
AADD(aRegs,{cPerg,"11","Rel Analit/Sint.?","Rel Analit/Sint.","Rel Analit/Sint.","mv_ch11","N",01,0,1,"C","","mv_par11","1-Anallitico","","","","","2-Sintetico","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","CC. Analit/Sint.?","CC. Analit/Sint.","CC. Analit/Sint.","mv_ch12","N",03,0,1,"C","","mv_par12","1-Anallitico","","","","","2-Sintetico","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Centro Custo de :","Centro Custo de ","Centro Custo de ","mv_ch13","C",20,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"14","Centro Custo até:","Centro Custo ATE","Centro Custo ATE","mv_ch14","C",20,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","CTT"})
AADD(aRegs,{cPerg,"15","Tit.só C/Rateio ?","Tit.só C/Rateio?","Tit.só C/Rateio ?","mv_ch15","N",01,0,1,"C","","mv_par15","Sim","SI","YES","","","Nao","NO","NO","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"16","Totais p/Cliente?","Totais p/Cliente","Totais p/Cliente","mv_ch16","N",01,0,1,"C","","mv_par16","Sim","SI","YES","","","Nao","NO","NO","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"17","Inibe linha Rateio","Inibe linha Rateio","Inibe linha Rateio","mv_ch17","N",01,0,1,"C","","mv_par17","Sim","SI","YES","","","Nao","NO","NO","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"18","Dt.Digitação de ?","Dt.Digitação de ?","Dt.Digitação de ?","mv_ch18","D",08,0,0,"G","","mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"19","Dt.Digitação até?","Dt.Digitação até?","Dt.Digitação até?","mv_ch19","D",08,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)
Pergunte(cPerg,.F.)
Return
