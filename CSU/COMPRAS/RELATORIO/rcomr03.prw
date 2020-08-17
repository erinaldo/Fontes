#Include 'rwmake.ch'
#Include 'TopConn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMR03   ºAutor  ³Renato Lucena Neves º Data ³  14/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Acompanhamento de requisições e pedido compra º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8-CSU                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObserv.   ³ Esse Relatorio foi completamente modificado por Flavio No- º±±
±±º          ³ vaes em 05/04/07 para atendimento ao Chamado 000000001440. º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION RCOMR03()
PRIVATE oExcelApp
PRIVATE _cData    := dtos(Date())
PRIVATE _cHora    := Time()
PRIVATE _cUsuario := cUserName
PRIVATE cPerg     := PADR("XCOM03",LEN(SX1->X1_GRUPO))
PRIVATE _nLin     := 0
PRIVATE oPrint, oFont8, oFont10n, oFont8n
Private cFuncao     := " Processa( { || Rcomr03a() }, 'Processando Relatório ...' ) "
Private cVldExcel   := " IIF( ValType(oExcelApp)$'O', (oExcelApp:Quit(), oExcelApp:Destroy() ), .t. ) "
_fCriaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                      ³
//³ mv_par01   Da Solicitacao de Compra                       ³
//³ mv_par02   Ate a Solicitacao de Compra                    ³
//³ mv_par03   Status                             ³
//³ mv_par04   Da  Data de Emissao                          ³
//³ mv_par05   Ate a Data de Emissao                  ³
//³ mv_par06   Gera Excel? 1 = SIM / 2 = NAO                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)

Define MsDialog MkwDlg Title "Acompanhamento de Requisições" From 298,302 To 500,721 Of oMainWnd Pixel
@ 002,003 To 100,165
@ 012,170 To 087,203
@ 035,015 Say "Relatório de Acompanhamento de requisições e pedido compra" Size 141,8
@ 045,015 Say "do usuário.: "  Size 142,8
@ 020,173 Button "_Parametros" Size 28,16 Action( Pergunte(cPerg,.t.) )
@ 042,173 Button "_Gerar"      Size 28,16 Action( &( cFuncao ) )
@ 064,173 Button "_Sair"       Size 28,16 Action( &( cVldExcel ), lSair := .t., MkwDlg:End() )

Activate Dialog mkwdlg Centered Valid lSair

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Rcomr03a  ºAutor  ³                    º Data ³  14/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de impressão                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 - CSU                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Rcomr03a()

LOCAL _aArea      := GetArea()

oPrint := TmsPrinter():New('Relatório de Acompanhamento de Requisições e Pedido Compra')
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando as Fontes Utilizadas pelo Relatorio.                                        ³
//³ Parametros do TFont.New(): 1.Nome Fonte (Windows), 3.Tamanho (Pixels), 5.Bold (T/F).³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFont8   := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8n  := TFont():New("Arial",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oPrint:SetLandScape()
MsgRun('Gerando Visualização, Aguarde...',"",{||CursorWait(),_fImprime(),CursorArrow()})
oPrint:SetLandScape()
IF MV_PAR06 == 2	// Gera Excel = NAO
	oPrint:Preview()
ENDIF

RESTAREA(_aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fImprime ºAutor  ³Renato Lucena Neves º Data ³  14/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de impressão                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 - CSU                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION _fImprime()
Local _aArea	 := GetArea()
Local _cQuery	 := ""
Local _cFornece	 := ""
Local _cVendedor := ""
Local _cDtLibPC	 := ""
Local _cDtLibSC	 := ""
Local _lContinua := .T.
Local _cArqTrab	 := ""
Local _cEstrut	 := {}
Local _cCodUser	 := ""
Local _cDtLibPR  := ""
Local _cNumNF	 := ""		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
Local _dCompetNF := ""		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
Local _dVenctoNF := ""		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
Local _cNumProv	 := ""		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
Local nVlrTota	 := 0 //QSD1->D1_TOTAL
Local dTEmissa	 // Stod(QSD1->D1_EMISSAO)

SAJ->( DbSetOrder(1) )

If MV_PAR06 == 1
	aAdd(_cEstrut,{"SOLICITANT" ,"C",17,0})
	aAdd(_cEstrut,{"SOLICITACA" ,"C",06,0})
	aAdd(_cEstrut,{"FILENTREG"	,"C",02,0})
	aAdd(_cEstrut,{"EMISSAOSC"	,"C",10,0})
	aAdd(_cEstrut,{"APROVACAOS" ,"C",10,0})
	aAdd(_cEstrut,{"COMPRADOR"	,"C",20,0})
	aAdd(_cEstrut,{"PEDIDOCOMP" ,"C",30,0})
	aAdd(_cEstrut,{"EMISSAOPC"	,"C",10,0})
	aAdd(_cEstrut,{"APROVACAOP" ,"C",10,0})
	aAdd(_cEstrut,{"APROVPRCME" ,"C",10,0})
	aAdd(_cEstrut,{"CODPRODUTO"	,"C",06,0})
	aAdd(_cEstrut,{"DESCPRODUT" ,"C",30,0})
	aAdd(_cEstrut,{"UNIDADEM" 	,"C",2,0})
	aAdd(_cEstrut,{"TOTPEDIDO"  ,"N",14,2})
	aAdd(_cEstrut,{"CODFOR"	    ,"C",06,0})
	aAdd(_cEstrut,{"LOJFOR"     ,"C",02,0})
	aAdd(_cEstrut,{"FORNECEDOR"	,"C",30,0})
	aAdd(_cEstrut,{"CNPJFOR"	,"C",14,0})
	aAdd(_cEstrut,{"PCAPROVADO"	,"C",03,0})
	aAdd(_cEstrut,{"TEMCOTACAO"	,"C",03,0})
	aAdd(_cEstrut,{"ORIGEM "	,"C",10,0})
	aAdd(_cEstrut,{"CODPROJETO"	,"C",10,0})
	aAdd(_cEstrut,{"ITMPROJETO"	,"C",04,0})
	aAdd(_cEstrut,{"VALORCAPEX"	,"N",18,2})
	aAdd(_cEstrut,{"SAVING"		,"N",18,2})
	aAdd(_cEstrut,{"ITEMSC"		,"C",04,0})
	aAdd(_cEstrut,{"NUMNF"		,"C",60,0})		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
	aAdd(_cEstrut,{"COMPTNF"	,"C",60,0})		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
	aAdd(_cEstrut,{"VENCTONF"	,"C",10,0})		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
	aAdd(_cEstrut,{"NUMPROV"	,"C",09,0})		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
	
	aAdd(_cEstrut,{"CC"			,"C",20,0})		//Edu
	aAdd(_cEstrut,{"VLRTOTAL"	,"N",11,2})		//Edu
	aAdd(_cEstrut,{"QTDSC"		,"N",12,2})		//Edu
	aAdd(_cEstrut,{"QTDPC"		,"N",12,2})		//Edu
	aAdd(_cEstrut,{"CONDPAG"	,"C",30,0})		//Edu
	aAdd(_cEstrut,{"ESTFORN"	,"C",02,0})		//Edu
	aAdd(_cEstrut,{"FRETE"		,"N",14,2})		//Edu
	aAdd(_cEstrut,{"BLQSC"		,"C",100,0})	//Edu 26/12
	aAdd(_cEstrut,{"BLQPC"		,"C",100,0})	//Edu
	aAdd(_cEstrut,{"OBSSC"		,"C",30,0})		//Edu
	aAdd(_cEstrut,{"PRJ"		,"C",10,0})		//Edu
	aAdd(_cEstrut,{"DESCPRJ"	,"C",90,0})		//Edu
	aAdd(_cEstrut,{"CTAORCA"	,"C",12,0})		//Edu
	aAdd(_cEstrut,{"DESCORC"	,"C",60,0})		//Edu
	aAdd(_cEstrut,{"DTAPROV"	,"C",3,0})		//Edu
	aAdd(_cEstrut,{"DTEMISSA"	,"C",30,0})		//Edu
	aAdd(_cEstrut,{"DTVENC"		,"C",10,0})		//Edu
	aAdd(_cEstrut,{"TOTALNF"	,"N",17,2})		//Edu
	
Else
	aAdd(_cEstrut,{"SOLICITANT" ,"C",17,0})
	aAdd(_cEstrut,{"SOLICITACA" ,"C",06,0})
	aAdd(_cEstrut,{"FILENTREG"	,"C",02,0})
	aAdd(_cEstrut,{"EMISSAOSC"	,"C",10,0})
	aAdd(_cEstrut,{"APROVACAOS" ,"C",10,0})
	aAdd(_cEstrut,{"COMPRADOR"	,"C",20,0})
	aAdd(_cEstrut,{"PEDIDOCOMP" ,"C",30,0})
	aAdd(_cEstrut,{"EMISSAOPC"	,"C",10,0})
	aAdd(_cEstrut,{"APROVACAOP" ,"C",10,0})
	aAdd(_cEstrut,{"APROVPRCME" ,"C",10,0})
	aAdd(_cEstrut,{"CODPRODUTO"	,"C",06,0})
	aAdd(_cEstrut,{"DESCPRODUT" ,"C",20,0})
	aAdd(_cEstrut,{"UNIDADEM" 	,"C",2,0})
	aAdd(_cEstrut,{"TOTPEDIDO"  ,"N",14,2})
	aAdd(_cEstrut,{"CODFOR"	    ,"C",06,0})
	aAdd(_cEstrut,{"LOJFOR"     ,"C",02,0})
	aAdd(_cEstrut,{"FORNECEDOR"	,"C",25,0})
	aAdd(_cEstrut,{"CNPJFOR"		,"C",14,0})
	aAdd(_cEstrut,{"PCAPROVADO"	,"C",03,0})
	aAdd(_cEstrut,{"TEMCOTACAO"	,"C",03,0})
	aAdd(_cEstrut,{"ORIGEM "	,"C",10,0})
	aAdd(_cEstrut,{"CODPROJETO"	,"C",10,0})
	aAdd(_cEstrut,{"ITMPROJETO"	,"C",04,0})
	aAdd(_cEstrut,{"VALORCAPEX"	,"N",18,2})
	aAdd(_cEstrut,{"SAVING"		,"N",18,2})
	aAdd(_cEstrut,{"ITEMSC"		,"C",04,0})
	aAdd(_cEstrut,{"NUMNF"		,"C",60,0})		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
	aAdd(_cEstrut,{"COMPTNF"	,"C",60,0})		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
	aAdd(_cEstrut,{"VENCTONF"	,"C",10,0})		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
	aAdd(_cEstrut,{"NUMPROV"	,"C",09,0})		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
	
	aAdd(_cEstrut,{"CC"			,"C",20,0})		//Edu
	aAdd(_cEstrut,{"VLRTOTAL"	,"N",11,2})		//Edu
	aAdd(_cEstrut,{"QTDSC"		,"N",12,2})		//Edu
	aAdd(_cEstrut,{"QTDPC"		,"N",12,2})		//Edu
	aAdd(_cEstrut,{"CONDPAG"	,"C",30,0})		//Edu
	aAdd(_cEstrut,{"ESTFORN"	,"C",02,0})		//Edu
	aAdd(_cEstrut,{"FRETE"		,"N",14,2})		//Edu
	aAdd(_cEstrut,{"BLQSC"		,"C",1,0})		//Edu 26/12
	aAdd(_cEstrut,{"BLQPC"		,"C",1,0})		//Edu
	aAdd(_cEstrut,{"OBSSC"		,"C",30,0})		//Edu
	aAdd(_cEstrut,{"PRJ"		,"C",10,0})		//Edu
	aAdd(_cEstrut,{"DESCPRJ"	,"C",90,0})		//Edu
	aAdd(_cEstrut,{"CTAORCA"	,"C",12,0})		//Edu
	aAdd(_cEstrut,{"DESCORC"	,"C",60,0})		//Edu
	aAdd(_cEstrut,{"DTAPROV"	,"C",3,0})		//Edu
	aAdd(_cEstrut,{"DTEMISSA"	,"C",30,0})		//Edu
	aAdd(_cEstrut,{"DTVENC"		,"C",10,0})		//Edu
	aAdd(_cEstrut,{"TOTALNF"	,"N",17,2})		//Edu
	
EndIf

_cArqTrab := CriaTrab(_cEstrut,.T.)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ OS 1770/10: Exibir somente as Solicitacoes que estejam em aberto ou que ja estejam com pedido colocado (completamente). ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄsÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
//_cQuery := " SELECT C1_NUM,C1_ITEM,C1_PRODUTO,C1_DESCRI,C1_QUANT,C1_QUJE,C1_SOLICIT,C1_EMISSAO,C1_COTACAO,C1_PEDIDO,C1_ITEMPED,C1_FORNECE,C1_LOJA, C1_USER,C1_GRUPCOM, R_E_C_N_O_ "
_cQuery := " SELECT C1_NUM,C1_ITEM,C1_PRODUTO,C1_DESCRI,C1_QUANT,C1_QUJE,C1_SOLICIT,C1_EMISSAO,C1_COTACAO,C1_PEDIDO,C1_ITEMPED,C1_FORNECE,C1_LOJA, C1_USER,C1_GRUPCOM,C1_FILENT, R_E_C_N_O_,C1_X_CAPEX,C1_X_PRJ,C1_X_ITPRJ,C1_XVLCAPE, C1_CC,C1_PRECO,C1_QUANT,C1_CONDPAG,C1_CONAPRO,C1_OBS,C1_X_PRJ,C1_UM"// OS 2491-10 - adicao da filial de entrega + OS 2111-11 -- EDU
_cQuery += " FROM "+RetSqlName('SC1')+" "
_cQuery += " WHERE C1_FILIAL='"+xFilial('SC1')+"' "
_cQuery += " AND   C1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
_cQuery += " AND   C1_EMISSAO BETWEEN '"+DTOS(MV_PAR04)+"' AND '"+DTOS(MV_PAR05)+"' "
_cQuery += " AND  ( ( C1_QUJE = 0 AND C1_COTACAO = ' ' AND C1_APROV = 'L' AND C1_RESIDUO = ' ') OR "              //SC em aberto
_cQuery += "        ( C1_QUJE = C1_QUANT AND C1_RESIDUO = ' ' ) )  "           //SC com pedido colocado

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se Parametro Status = 2 (S/Pedido), Ignora se tem Qtde. em Pedido. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par03 == 2
	_cQuery += " AND 1_QUJE > 0 "
ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se Parametro Status = 3 (C/Pedido e S/Nota), Ignora se Nao tem Qtde. em Pedido. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par03 == 3
	_cQuery += " AND C1_QUJE <= 0 "
ENDIF

_cQuery += " AND D_E_L_E_T_ = ' ' "
_cQuery += " ORDER BY C1_NUM, C1_ITEM "

MemoWrit('RCOMR03.SQL',_cQuery)
TcQuery _cQuery New Alias 'QRY1'
dbUseArea(.T.,,_cArqTrab,'TRB1')

dbSelectArea('TRB1')
dbSelectArea('QRY1')
dbGoTop()

WHILE QRY1->(!EOF())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se Parametro Status = 3 (C/Pedido e S/Nota), Verifica se Tem Nota. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF mv_par03 == 3
		IF SELECT('QSC7') > 0
			dbSelectArea('QSC7')
			dbCloseArea()
		ENDIF
		_cQuery := " SELECT COUNT(*) AS REGS FROM "+RETSQLNAME('SC7')
		_cQuery += " WHERE C7_FILIAL = '" +xFilial('SC7')+"' AND C7_QUJE > 0 "
		_cQuery += " AND   C7_NUMSC = '" +QRY1->C1_NUM+"' AND C7_ITEMSC = '"+QRY1->C1_ITEM+"' "
		_cQuery += " AND   D_E_L_E_T_ = ' ' "
		TCQUERY _cQuery NEW ALIAS 'QSC7'
		dbSelectArea('QSC7')
		_lTemNota := !EOF()
		dbCloseArea()
		dbSelectArea('QRY1')
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se Parametro Status = 3 (C/Pedido e S/Nota), Ignora se Tem Nota. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF _lTemNota
			dbSkip()
			LOOP
		ENDIF
	ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados do Fornecedor. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	_aAreaSC7 := SC7->(GetArea())
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial("SC7") + QRY1->C1_PEDIDO)
	_cFornece	:= ""
	_cFornece 	:=GetAdvFVal("SA2","A2_NOME",xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA),1,"")
	_cFornece 	:=ALLTRIM(_cFornece)
	_cESTFor	:= GetAdvFVal("SA2","A2_EST",xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA),1,"") // Edu
	_cCNPJFor	:= GetAdvFVal("SA2","A2_CGC",xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA),1,"") // Douglas
	//RestArea(_aAreaSC7)
	
	// EDU
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados do Projeto.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aAreaAF8 := AF8->(GetArea())
	dbSelectArea("AF8")
	dbSetOrder(1) //AF8_FILIAL+AF8_PROJET
	dbSeek(xFilial("AF8") + QRY1->C1_X_PRJ)
	_cDescPRJ	:= ""
	_cDescPRJ 	:=	GetAdvFVal("AF8","AF8_DESCRI",xFilial('AF8')+QRY1->C1_X_PRJ,1,"")
	_cDescPRJ 	:=ALLTRIM(_cDescPRJ)
	RestArea(_aAreaAF8)
	
	
	// EDU
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados do Produto. Conta Orcamentaria   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aAreaSB1 := SB1->(GetArea())
	dbSelectArea("SB1")
	dbSetOrder(1) //B1_FILIAL+B1_COD
	dbSeek(xFilial("SB1") + QRY1->C1_PRODUTO)
	_cCTAORCA	:= ""
	_cCTAORCA 	:=	GetAdvFVal("SB1","B1_CTAPCO",xFilial('SB1')+QRY1->C1_PRODUTO,1,"")
	_cCTAORCA 	:=ALLTRIM(_cCTAORCA)
	RestArea(_aAreaSB1)
	
	// EDU
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados da Conta Orcamentaria   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aAreaAK5 := AK5->(GetArea())
	dbSelectArea("AK5")
	dbSetOrder(1) //AK5_FILIAL+AK5_CODIGO
	dbSeek(xFilial("AK5") + _cCTAORCA)
	_cDescOrc	:= ""
	_cDescOrc 	:=	GetAdvFVal("AK5","AK5_DESCRI",xFilial('AK5')+_cCTAORCA,1,"")
	_cDescOrc 	:=ALLTRIM(_cDescOrc)
	RestArea(_aAreaAK5)
	
	// By Alexandre Avelino - OS 3348/16
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Status da Solicitatacao de Compras     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aAreaSC1 := SC1->(GetArea())
	dbSelectArea("SC1")
	dbSetOrder(1) //C1_FILIAL+C1_NUM+C1_ITEM
	dbSeek(xFilial("SC1") + QRY1->C1_NUM + QRY1->C1_ITEM)
	_sTatusSC	:= ""
	lAProvSI    := GetNewPar("MV_APROVSI",.F.)
	cTpCto      := GETMV("MV_TPSCCT")
	If C1_APROV == "X"
		_sTatusSC	:= "Devolvida por Procurement"
	EndIf
	If C1_QUJE == 0 .And. C1_COTACAO == Space(Len(C1_COTACAO)) .And. C1_APROV $ " ,L"
		_sTatusSC	:= "Solicitacao Pendente"
	EndIf
	If C1_QUJE == 0 .And. C1_COTACAO == Space(Len(C1_COTACAO)) .And. C1_APROV $ " ,L"
		_sTatusSC	:= "Solicitacao Pendente"
	EndIf
	If C1_QUJE == C1_QUANT
		_sTatusSC	:= "Solicitacao Totalmente Atendida"
	EndIf
	If C1_QUJE > 0 .And. C1_QUJE <> C1_QUANT
		_sTatusSC	:= "Solicitacao Parcialmente Atendida"
	EndIf
	If C1_TPSC != "2" .And. C1_QUJE == 0 .And. C1_COTACAO <> Space(Len(C1_COTACAO)) .And. C1_IMPORT <> "S"
		_sTatusSC	:= "Solicitacao em Processo de Cotacao"
	EndIf
	If !Empty(C1_RESIDUO)
		_sTatusSC	:= "Elim. por Residuo"
	EndIf
	If lAprovSI
		If C1_QUJE == 0 .And. (C1_COTACAO == Space(Len(C1_COTACAO)) .Or. C1_COTACAO == "IMPORT") .And. C1_APROV == "R"
			_sTatusSC	:= "Solicitacao Rejeitada"
		EndIf
		If C1_QUJE == 0 .And. (C1_COTACAO == Space(Len(C1_COTACAO)) .Or. C1_COTACAO == "IMPORT") .And. C1_APROV == "B"
			_sTatusSC	:= "Solicitacao Bloqueada"
		EndIf
	Else
		If C1_QUJE == 0 .And. C1_COTACAO == Space(Len(C1_COTACAO)) .And. C1_APROV == "R"
			_sTatusSC	:= "Solicitacao Rejeitada"
		EndIf
		If C1_QUJE == 0 .And. C1_COTACAO == Space(Len(C1_COTACAO)) .And. C1_APROV == "B"
			_sTatusSC	:= "Solicitacao Bloqueada"
		EndIf
	EndIf
	If lAprovSI
		If C1_QUJE == 0 .And. C1_COTACAO <> Space(Len(C1_COTACAO)) .And. C1_IMPORT == "S" .And.C1_APROV $ " ,L"
			_sTatusSC	:= "Solicitacao de Produto Importado"
		EndIf
	Else
		If C1_QUJE == 0 .And. C1_COTACAO <> Space(Len(C1_COTACAO)) .And. C1_IMPORT == "S"
			_sTatusSC	:= "Solicitacao de Produto Importado"
		EndIf
	EndIf
	If C1_FLAGGCT == "1" .And. C1_QUJE < C1_QUANT
		_sTatusSC	:= "Integracao com o modulo de Gestao de Contratos"
	EndIf
	If C1_TPSC == "2" .And. C1_QUJE == 0 .And. !Empty(SC1->C1_CODED)
		_sTatusSC	:= "Solicitacao em Processo de Edital"
	EndIf
	If SC1->(FieldPos("C1_COMPRAC")) > 0
		If C1_RESIDUO == 'S' .And. C1_COMPRAC == '1'
			_sTatusSC	:= "Solicitacao em Compra Centralizada"
		EndIF
	EndIf
	If SC1->(FieldPos("C1_TIPO")) > 0
		If C1_TIPO == 2
			_sTatusSC	:= "Solicitacao de Importacao"
		EndIF
	Endif
	If SC1->(FieldPos("C1_ACCPROC")) > 0
		If C1_ACCPROC =="1" .And. C1_PEDIDO == Space(Len(C1_PEDIDO))
			_sTatusSC	:= "Solicitacao Pendente (MarketPlace)"
		EndIf
		If (C1_ACCPROC == "1" .Or. C1_ACCPROC =="2") .And. C1_PEDIDO == Space(Len(C1_PEDIDO)) .And. C1_COTACAO <> Space(Len(C1_COTACAO))
			_sTatusSC	:= "Solicitacao em Processo de Cotacao (MarketPlace)"
		EndIf
	EndIf
	If SC1->(FieldPos("C1_TPSC")) > 0
		If C1_QUJE == 0 .And. C1_COTACAO == Space(Len(C1_COTACAO)) .And. C1_APROV $ " ,L" .And. C1_TPSC == "2"
			_sTatusSC	:= "Solicitacao para Licitacao"
		EndIf
	EndIf
	RestArea(_aAreaSC1)
	
	// By Alexandre Avelino - OS 3348/16
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Status do Pedido de Compras            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//_aAreaSC7 := SC7->(GetArea())
	dbSelectArea("SC7")
	dbSetOrder(1) //C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
	dbSeek(xFilial("SC7") + SC7->C7_NUM + SC7->C7_ITEM + SC7->C7_SEQUEN)
	_sTatusPC	:= ""
	nTipoPed    := 1
	If C7_QUJE == 0 .And. C7_QTDACLA == 0
		_sTatusPC	:= "Pendente"
	EndIf
	If C7_QUJE <> 0 .And. C7_QUJE < C7_QUANT
		_sTatusPC	:= "Recebido Parcialmente"
	EndIf
	If C7_QUJE >= C7_QUANT
		_sTatusPC	:= "Recebido"
	EndIf
	If SC7->(FieldPos("C7_ACCPROC")) > 0
		If C7_ACCPROC <> "1" .And. C7_CONAPRO == "B" .And. C7_QUJE < C7_QUANT
			_sTatusPC	:= "Em aprovacao"
		EndIf
	Else
		If C7_CONAPRO == "B" .And. C7_QUJE < C7_QUANT
			_sTatusPC	:= "Em aprovacao"
		EndIf
	EndIf
	If !Empty(C7_RESIDUO)
		_sTatusPC	:= "Com Residuo eliminado"
	EndIf
	If C7_QTDACLA > 0
		_sTatusPC	:= "Em Recebimento (Pre-Nota)"
	EndIf
	If C7_TIPO != nTipoPed
		_sTatusPC	:= "Autorizacao de Entrega"
	EndIf
	If nTipoPed == 1
		If !Empty(C7_CONTRA).And.Empty(C7_RESIDUO)
			_sTatusPC	:= "Pedido de Contrato (GCT)"
		EndIf
		If SC7->(FieldPos("C7_ACCPROC")) > 0 .And. (SuperGetMv("MV_MKPLACE",.F.,.F.))
			If C7_ACCPROC == "1"
				_sTatusPC	:= "Aguardando aceite do fornecedor (Marketplace)"
			EndIf
		EndIf
	EndIf
	RestArea(_aAreaSC7)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca ultima data de liberacao do pedido de compra	³
	//³	 e de Procurement. Caso não tenha de procurement	³
	//³	 usar a liberação do pedido. 						³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCR->(dbSeek(xFilial('SCR')+'PC'+QRY1->C1_PEDIDO))
	_cDtLibPC := ""
	_cDtLibPR := ""
	WHILE ALLTRIM(xFilial('SCR')+'PC'+QRY1->C1_PEDIDO)==ALLTRIM(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) .AND. SCR->(!EOF())
		_cDtLibPC := DTOC(SCR->CR_DATALIB)
		
		If SCR->CR_X_TPLIB == 'S'
			_cDtLibPR := DTOC(SCR->CR_DATALIB)
		EndIf
		SCR->(DBSkip())
	ENDDO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca ultima data de liberacao da solicitacao de compra. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCR->(dbSeek(xFilial('SCR')+'SC'+QRY1->C1_NUM))
	_cDtLibSC := ""
	WHILE ALLTRIM(xFilial('SCR')+'SC'+QRY1->C1_NUM)==ALLTRIM(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) .AND. SCR->(!EOF())
		_cDtLibSC := DTOC(SCR->CR_DATALIB)
		SCR->(dBSkip())
	ENDDO
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca o codigo do usuario. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	_cCodUser := UsrFullName(QRY1->C1_USER)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca Informacoes do Pedido de Compra. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF SELECT('QSC7') > 0
		dbSelectArea('QSC7')
		dbCloseArea()
	ENDIF
	
	_cQuery := " SELECT DISTINCT C7_FILIAL, C7_NUM, C7_ITEM, C7_TOTAL, C7_QUANT, C7_FRETE, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_USER, C7_CONAPRO, C7_COND, "
	_cQuery  +=" C7_NUMCOT, ( C7_TOTAL+C7_VALIPI+C7_SEGURO+C7_DESPESA+C7_VALFRE ) - C7_VLDESC AS TOTPED , SD1.D1_DOC,"
	_cQuery  +=" SD1.D1_SERIE, SD1.D1_DTDIGIT, SD1.D1_EMISSAO, SD1.D1_TOTAL FROM "+RETSQLNAME('SD1')+" AS SD1"
	_cQuery  += " INNER JOIN "+RETSQLNAME('SC7')+" SC7 ON SC7.C7_NUM = SD1.D1_PEDIDO AND  SC7.C7_ITEM = SD1.D1_ITEMPC AND SC7.C7_PRODUTO = SD1.D1_COD AND SC7.D_E_L_E_T_ ='' "
	_cQuery  += " WHERE SC7.C7_NUMSC = '"+QRY1->C1_NUM+"' AND SC7.C7_ITEMSC = '"+QRY1->C1_ITEM+"'  AND   SD1.D_E_L_E_T_ = ' ' "
	TCQUERY _cQuery  NEW ALIAS 'QSC7'
	
	//CONTADOR
	_cQryReg:= " SELECT DISTINCT C7_FILIAL, C7_NUM, C7_ITEM, C7_TOTAL, C7_QUANT, C7_FRETE, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_USER, C7_CONAPRO, C7_COND, "
	_cQryReg+=" C7_NUMCOT, ( C7_TOTAL+C7_VALIPI+C7_SEGURO+C7_DESPESA+C7_VALFRE ) - C7_VLDESC AS TOTPED , SD1.D1_DOC,"
	_cQryReg+=" SD1.D1_SERIE, SD1.D1_DTDIGIT, SD1.D1_EMISSAO, SD1.D1_TOTAL FROM "+RETSQLNAME('SD1')+" AS SD1"
	_cQryReg+= " INNER JOIN "+RETSQLNAME('SC7')+" SC7 ON SC7.C7_NUM = SD1.D1_PEDIDO AND  SC7.C7_ITEM = SD1.D1_ITEMPC AND SC7.C7_PRODUTO = SD1.D1_COD AND SC7.D_E_L_E_T_ ='' "
	_cQryReg+= " WHERE SC7.C7_NUMSC = '"+QRY1->C1_NUM+"' AND SC7.C7_ITEMSC = '"+QRY1->C1_ITEM+"'  AND   SD1.D_E_L_E_T_ = ' ' "
	TCQUERY _cQryReg  NEW ALIAS 'QSC7REG'
	
	nRegQSC7 := Contar("QSC7REG","!Eof()")
	
	_cQrytot:= " SELECT C7_FILIAL, C7_NUM, C7_ITEM, C7_TOTAL, C7_QUANT, C7_FRETE, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_USER, C7_CONAPRO, C7_COND, C7_NUMCOT, ( C7_TOTAL+C7_VALIPI+C7_SEGURO+C7_DESPESA+C7_VALFRE ) - C7_VLDESC AS TOTPED FROM "+RETSQLNAME('SC7')
	_cQrytot+= " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
	_cQrytot+= " AND   C7_NUMSC   = '"+QRY1->C1_NUM+"' AND C7_ITEMSC = '"+QRY1->C1_ITEM+"' "
	_cQrytot+= " AND   D_E_L_E_T_ = ' ' "
	TCQUERY _cQrytot NEW ALIAS 'QSC7TOT'
	
	//CONTADOR
	_cQrytotReg:= " SELECT C7_FILIAL, C7_NUM, C7_ITEM, C7_TOTAL, C7_QUANT, C7_FRETE, C7_FORNECE, C7_LOJA, C7_EMISSAO, C7_USER, C7_CONAPRO, C7_COND, C7_NUMCOT, ( C7_TOTAL+C7_VALIPI+C7_SEGURO+C7_DESPESA+C7_VALFRE ) - C7_VLDESC AS TOTPED FROM "+RETSQLNAME('SC7')
	_cQrytotReg+= " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
	_cQrytotReg+= " AND   C7_NUMSC   = '"+QRY1->C1_NUM+"' AND C7_ITEMSC = '"+QRY1->C1_ITEM+"' "
	_cQrytotReg+= " AND   D_E_L_E_T_ = ' ' "
	TCQUERY _cQrytotReg NEW ALIAS 'QSC7TOTREG'
	
	nTotReg := Contar("QSC7TOTREG","!Eof()")
	
	dbSelectArea('QSC7')
	dbSelectArea('QSC7TOT')
	
	If nRegQSC7 == 0 .And. nTotReg > 1
		
		While QSC7TOT->(!Eof())
			
			nPcVai 	   := IIF(Empty(nPcVai),QSC7TOT->C7_NUM,nPcVai+" / "+QSC7TOT->C7_NUM)
			nPedidoVai := nPcVai
			
			nTotPed := IIF(Empty(nTotPed),QSC7TOT->TOTPED,(nTotped+QSC7TOT->TOTPED))
			nTotalPC:= nTotPed
			
			nVlrTot := IIF(Empty(nVlrTot),QSC7TOT->C7_TOTAL,(nVlrTot+QSC7TOT->C7_TOTAL))
			nTotalVai:= nVlrTot
			
			cCodFor := QSC7TOT->C7_FORNECE
			cLoja 	:= QSC7TOT->C7_LOJA
			
			cConapro:=IIF(QSC7TOT->C7_CONAPRO=='L','Sim','Não')
			cNumCot	:=IIF(EMPTY(QSC7TOT->C7_NUMCOT),'Não','Sim')
			_cDtEmiPC := Dtoc(Stod(QSC7TOT->C7_EMISSAO))
			
			nQtdPed := IIF(Empty(nQtdPed),QSC7TOT->C7_QUANT,(nQtdPed+QSC7TOT->C7_QUANT))
			nQtdPC	:= nQtdPed
			
			nCondVai  := IIF(Empty(nCondVai),QSC7TOT->C7_COND,nCondVai+" / "+QSC7TOT->C7_COND)
			nCPVai 	  := nCondVai
			nNOTAVai  := ""
			dCompetVai:= ""
			dEmissaVai:= ""
			nTotNF	  := 0
			
			
			QSC7TOT->(dbSkip())
			
		EndDo
	ElseIf nRegQSC7 == 0 .And. nTotReg <= 1
		nPedidoVai 	:= QRY1->C1_PEDIDO
		_cDtEmiPC   	:= Dtoc(Stod(QSC7TOT->C7_EMISSAO))
		cCodFor 	:= QSC7TOT->C7_FORNECE
		cLoja 		:= QSC7TOT->C7_LOJA
		cConapro	:=IIF(QSC7TOT->C7_CONAPRO=='L','Sim','Não')
		cNumCot		:=IIF(EMPTY(QSC7TOT->C7_NUMCOT),'Não','Sim')
		nTotalPC 	:= QSC7TOT->TOTPED
		nTotalVai 	:= QSC7TOT->C7_TOTAL
		nQtdPC      := QSC7TOT->C7_QUANT
		nCPVai      := QSC7TOT->C7_COND
		nNOTAVai  	:= ""
		dCompetVai	:= ""
		dEmissaVai	:= ""
		nTotNF	  	:= 0
		
	Endif
	
	nPcVai  := ""
	nTotPed := ""
	nVlrTot := ""
	nQtdPed   := ""
	nCondVai  := ""
	
	If nRegQSC7 <> 0 .And. nTotReg > 1
		
		While QSC7->(!Eof())
			
			nPcVai 	   := IIF(Empty(nPcVai),QSC7->C7_NUM,nPcVai+" / "+QSC7->C7_NUM)
			nPedidoVai := nPcVai
			
			nTotPed := IIF(Empty(nTotPed),QSC7->TOTPED,(nTotped+QSC7->TOTPED))
			nTotalPC:= nTotPed
			
			nVlrTot := IIF(Empty(nVlrTot),QSC7->C7_TOTAL,(nVlrTot+QSC7->C7_TOTAL))
			nTotalVai:= nVlrTot
			
			cCodFor := QSC7->C7_FORNECE
			cLoja 	:= QSC7->C7_LOJA
			
			cConapro:=IIF(QSC7->C7_CONAPRO=='L','Sim','Não')
			cNumCot	:=IIF(EMPTY(QSC7->C7_NUMCOT),'Não','Sim')
			_cDtEmiPC := Dtoc(Stod(QSC7->C7_EMISSAO))
			
			nNFVai   := IIF(Empty(nNFVai),QSC7->D1_DOC+"-"+QSC7->D1_SERIE,nNFVai+" / "+QSC7->D1_DOC+"-"+QSC7->D1_SERIE)
			nNOTAVai := nNFVai
			
			dCompetNF := IIF(Empty(dCompetNF),Dtoc(Stod(QSC7->D1_DTDIGIT)),dCompetNF+" - "+Dtoc(Stod(QSC7->D1_DTDIGIT)))
			dCompetVai:= dCompetNF
			
			dDtEmissa:= IIF(Empty(dDtEmissa),DTOc(Stod(QSC7->D1_EMISSAO) ),dDtEmissa+" - "+DTOc(Stod(QSC7->D1_EMISSAO)))
			dEmissaVai:= dDtEmissa
			
			nQtdPed := IIF(Empty(nQtdPed),QSC7->C7_QUANT,(nQtdPed+QSC7->C7_QUANT))
			nQtdPC	:= nQtdPed
			
			nCondVai  := IIF(Empty(nCondVai),QSC7->C7_COND,nCondVai+" / "+QSC7->C7_COND)
			nCPVai 	  := nCondVai
			
			nVlrTotal := IIF(Empty(nVlrTotal),QSC7->D1_TOTAL,(nVlrTotal+QSC7->D1_TOTAL))
			nTotNF	  := nVlrTotal
			
			QSC7->(dbSkip())
			
		EndDo
	ElseIf nRegQSC7 <> 0 .And. nTotReg <= 1
		nPedidoVai 	:= QRY1->C1_PEDIDO
		_cDtEmiPC   := Dtoc(Stod(QSC7->C7_EMISSAO))
		cCodFor 	:= QSC7->C7_FORNECE
		cLoja 		:= QSC7->C7_LOJA
		cConapro	:=IIF(QSC7->C7_CONAPRO=='L','Sim','Não')
		cNumCot		:=IIF(EMPTY(QSC7->C7_NUMCOT),'Não','Sim')
		nTotalPC 	:= QSC7->TOTPED
		nTotalVai 	:= QSC7->C7_TOTAL
		nNotavai 	:= QSC7->D1_DOC+"-"+QSC7->D1_SERIE
		dCompetVai	:= Dtoc(Stod(QSC7->D1_DTDIGIT))
		dEmissaVai	:= DTOc(Stod(QSC7->D1_EMISSAO) )
		nQtdPC      := QSC7->C7_QUANT
		nCPVai      := QSC7->C7_COND
		nTotNF      := QSC7->D1_TOTAL
	Endif
	nPcVai  := ""
	nTotPed := ""
	nVlrTot := ""
	nNFVai  := ""
	dCompetNF := ""
	dDtEmissa := ""
	nQtdPed   := ""
	nCondVai  := ""
	nVlrTotal :=""
	
	_cDtEmiSC := Dtoc(Stod(QRY1->C1_EMISSAO))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Correcao do comprador                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF (QSC7->C7_USER!='  ')
		cComprador:= UsrFullName(QSC7->C7_USER)
	ELSE
		cComprador:=''
	ENDIF
	
	If Empty( cComprador )
		If SAJ->( DbSeek( xFilial('SAJ')+QRY1->C1_GRUPCOM ) )
			cComprador := SAJ->AJ_US2NAME
		Else
			cComprador := "Nao Localizado"
		EndIf
	EndIf
	// - OS 3468/10
	If !Empty(_cDtLibPC)
		If Empty(_cDtLibPR)
			_cDtLibPR := _cDtEmiPC
		EndIf
		//	Else
		//	_cDtLibPR := "  /  /    "
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca o numero da NF e Competência (data de lançamento da NF). - Tatiana A. Barbosa - OS 2358/11 - 09/2011	   ³		//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF QSC7->C7_NUM!=' '
		_cQuery := " SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, D1_PEDIDO, D1_ITEMPC, D1_DTDIGIT, D1_TP, D1_EMISSAO, D1_TOTAL FROM "+RETSQLNAME('SD1')
		_cQuery += " WHERE "
		_cQuery += " D1_PEDIDO = '"+QSC7->C7_NUM+"' AND D1_ITEMPC = '"+QSC7->C7_ITEM+"' "
		_cQuery += " AND   D_E_L_E_T_ = ' ' "
		TCQUERY _cQuery NEW ALIAS 'QSD1'
		dbSelectArea('QSD1')
		IF ALLTRIM(QSD1->D1_PEDIDO+QSD1->D1_ITEMPC)==ALLTRIM(QSC7->(C7_NUM+C7_ITEM)) .AND. QSD1->D1_PEDIDO<>"      "
			_dCompetNF 	:= Dtoc(Stod(QSD1->D1_DTDIGIT))
			_cNumNF 	:= QSD1->D1_DOC+" / "+QSD1->D1_SERIE
			dTEmissa	:= DTOc(Stod(QSD1->D1_EMISSAO) )
		ELSE
			_dCompetNF 	:= ""
			_cNumNF 	:= ""
			dTEmissa    := ""
		ENDIF
		
		_aAreaSCR := SCR->(GetArea())
		dbSelectArea("SCR")
		dbSetOrder(1) //CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
		dbSeek(xFilial("SCR") + QRY1->C1_PRODUTO)
		//		_dDataLib 	:=	GetAdvFVal("SCR","CR_DATALIB",xFilial('SCR')+QSD1->D1_TP+QSD1->D1_PEDIDO,1,"")	   // RETIRADO EDU 27/12
		_dDataLib 	:=	POSICIONE("SCR",1,xFilial('SCR')+"PC"+QSD1->D1_PEDIDO,"CR_DATALIB")
		
		If !Empty( StrTran( cValToChar(_dDataLib), "/", " " ) )
			_Aprovacao := cValToChar( Stod(QSD1->D1_DTDIGIT) - _dDataLib )
		Else
			_Aprovacao := "0"
		EndIf
		
		If Val(_Aprovacao) < 0
			_Aprovacao := "0"
		EndIf
		
		RestArea(_aAreaSCR)
		
		// EDU
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Data Real do Vencimento do titulo    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_aAreaSE2 := SE2->(GetArea())
		dbSelectArea("SE2")
		dbSetOrder(1) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		dbSeek(xFilial("SE2")+QSD1->D1_SERIE+QSD1->D1_DOC)
		_dVencReal 	:=	DTOc(GetAdvFVal("SE2","E2_VENCREA",xFilial('SE2')+QSD1->D1_SERIE+QSD1->D1_DOC,1,"") )
		
		RestArea(_aAreaSE2)
		
	ELSE
		_dCompetNF 	:= ""
		_cNumNF 	:= ""
		_Aprovacao  := "0"
		_dVencReal  := ""
		dTEmissa    := ""
	ENDIF
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca o numero da Provisão do Pedido de Compra. - 		Tatiana A. Barbosa - OS 2358/11 - 09/2011			   ³		//ZB2_FILIAL+ZB2_PROVIS+ZB2_NATURE
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQuery := " SELECT ZB2_PROVIS, ZB2_PEDCOM FROM "+RETSQLNAME('ZB2')
	_cQuery += " WHERE "
	_cQuery += " ZB2_PEDCOM = '"+QSC7->C7_NUM+"' "
	_cQuery += " AND   D_E_L_E_T_ = ' ' "
	TCQUERY _cQuery NEW ALIAS 'QZB2'
	dbSelectArea('QZB2')
	IF ALLTRIM(QZB2->ZB2_PEDCOM)==ALLTRIM(QSC7->C7_NUM) .AND. QZB2->ZB2_PEDCOM<>"      "
		_cNumProv 	:= QZB2->ZB2_PROVIS
	ELSE
		_cNumProv 	:= ""
	ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ "	Vencimento da NF (caso exista mais de um titulo gerado para a mesma NF no relatório será informado apenas  ³
	//³     o vencimento do 1º titulo) 		Tatiana A. Barbosa - OS 2358/11 - 09/2011			   					   ³		//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF QSC7->C7_NUM!=' '
		
		D1_DOC := Substr(nNotavai,1,9)
		
		_cQuery := " SELECT TOP 1 E2_NUM, E2_FORNECE, E2_LOJA, E2_VENCTO FROM "+RETSQLNAME('SE2')
		_cQuery += " WHERE "
		_cQuery += " E2_NUM = '"+D1_DOC+"' AND E2_FORNECE = '"+cCodFor+"' AND E2_LOJA = '"+cLoja+"' "
		_cQuery += " AND   D_E_L_E_T_ = ' ' "
		_cQuery += " ORDER BY E2_VENCTO"
		TCQUERY _cQuery NEW ALIAS 'QSE2'
		dbSelectArea('QSE2')
		IF QSE2->E2_VENCTO <> '20070202'
			IF D1_DOC<>"         " .Or. QSE2->E2_NUM<>"         " .Or. QSC7->C7_NUM<>"      " .Or.  nPedidoVai <>"      "
				_dVenctoNF 	:= Dtoc(Stod(QSE2->E2_VENCTO))
			ELSE
				_dVenctoNF 	:= ""
			ENDIF
		ELSE
			_dVenctoNF 	:= ""
		ENDIF
	ELSE
		_dVenctoNF 	:= ""
	ENDIF
	RECLOCK('TRB1',.T.)
	TRB1->SOLICITANT	:= _cCodUser
	TRB1->SOLICITACA	:= QRY1->C1_NUM
	TRB1->EMISSAOSC		:= _cDtEmiSC
	TRB1->APROVACAOS	:= _cDtLibSC
	TRB1->COMPRADOR		:= cComprador
	TRB1->PEDIDOCOMP	:= nPedidoVai
	TRB1->EMISSAOPC		:= _cDtEmiPC
	TRB1->APROVACAOP	:= _cDtLibPC
	TRB1->APROVPRCME    := _cDtLibPR
	TRB1->CODPRODUTO	:= QRY1->C1_PRODUTO
	TRB1->DESCPRODUT	:= QRY1->C1_DESCRI
	TRB1->UNIDADEM 	    := QRY1->C1_UM
	TRB1->TOTPEDIDO 	:= nTotalPC
	
	TRB1->CODFOR        := cCodFor
	TRB1->LOJFOR        := cLoja
	
	TRB1->FORNECEDOR	:= _cFornece
	TRB1->CNPJFOR	    :=_cCNPJFOR
	TRB1->PCAPROVADO	:= cConapro
	TRB1->TEMCOTACAO	:= cNumCot
	TRB1->FILENTREG		:= QRY1->C1_FILENT
	TRB1->ORIGEM		:= QRY1->C1_X_CAPEX
	TRB1->CODPROJETO	:= QRY1->C1_X_PRJ
	TRB1->ITMPROJETO	:= QRY1->C1_X_ITPRJ
	TRB1->VALORCAPEX	:= QRY1->C1_XVLCAPE
	TRB1->SAVING    	:= QRY1->C1_XVLCAPE - nTotalPC
	TRB1->ITEMSC        := QRY1->C1_ITEM
	TRB1->NUMNF	        := IIF (Empty(nNOTAVai),_cNumNF,nNOTAVai)
	TRB1->COMPTNF       := IIF (Empty(dCompetVai),_dCompetNF,dCompetVai)
	TRB1->VENCTONF      := _dVenctoNF		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
	TRB1->NUMPROV       := _cNumProv		//Tatiana A. Barbosa - OS 2358/11 - 09/2011
	TRB1->CC			:= QRY1->C1_CC   //EDU
	TRB1->VLRTOTAL		:= nTotalVai
	
	TRB1->QTDSC			:= QRY1->C1_QUANT //EDU
	TRB1->QTDPC			:= nQtdPC
	TRB1->CONDPAG		:= nCPVai
	
	TRB1->ESTFORN		:= _cESTFor  //EDU
	TRB1->FRETE			:= QSC7->C7_FRETE	 //EDU
	
	TRB1->BLQSC			:= _sTatusSC // By Alexandre Avelino
	TRB1->BLQPC			:= _sTatusPC // By Alexandre Avelino
	TRB1->OBSSC			:= QRY1->C1_OBS
	TRB1->PRJ			:= QRY1->C1_X_PRJ
	TRB1->DESCPRJ		:= _cDescPRJ
	TRB1->CTAORCA		:= _cCTAORCA
	TRB1->DESCORC		:= _cDescOrc
	TRB1->DTAPROV		:= _Aprovacao
	TRB1->DTEMISSA		:= IIF (Empty(dEmissaVai),dTEmissa,dEmissaVai)
	TRB1->DTVENC		:= _dVencReal
	TRB1->TOTALNF		:= 	nTotNF
	
	MsUnLock()
	IF Select("QSC7")>0
		dbSelectArea('QSC7')
		dbCloseArea()
	Endif
	IF Select("QSC7TOT")>0
		dbSelectArea('QSC7TOT')
		dbCloseArea()
	Endif
	IF Select("QSC7")>0
		dbSelectArea('QSC7')
		dbCloseArea()
	Endif
	IF Select("QSC7REG")>0
		dbSelectArea('QSC7REG')
		dbCloseArea()
	Endif
	IF Select("QSC7TOTREG")>0
		dbSelectArea('QSC7TOTREG')
		dbCloseArea()
	Endif
	IF Select("QSD1")>0
		dbSelectArea('QSD1')
		dbCloseArea()
	Endif
	
	IF Select("QZB2")>0
		dbSelectArea('QZB2')
		dbCloseArea()
	Endif
	IF Select("QSE2")>0
		dbSelectArea('QSE2')
		dbCloseArea()
	Endif
	dbSelectArea('QRY1')
	QRY1->(DbSkip())
	
ENDDO

dbSelectArea('TRB1')
dbGoTop()
IF MV_PAR06 == 2	// Gera Excel = NAO
	IF !EOF()
		_fCabec()
		WHILE !EOF()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica Quebra de Pagina. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF _nLin >= 2180
				_fRodaPe()
				_fCabec()
				_nLin := 380
			ENDIF
			oPrint:Say(_nLin,0030,Lower(SOLICITANT),oFont8)
			oPrint:Say(_nLin,0300,SOLICITACA,oFont8)
			oPrint:Say(_nLin,0460,EMISSAOSC ,oFont10)
			oPrint:Say(_nLin,0660,APROVACAOS,oFont10)
			oPrint:Say(_nLin,0840,COMPRADOR ,oFont8)
			oPrint:Say(_nLin,1140,PEDIDOCOMP,oFont8)
			oPrint:Say(_nLin,1290,EMISSAOPC ,oFont10)
			oPrint:Say(_nLin,1490,APROVACAOP,oFont10)
			oPrint:Say(_nLin,1690,APROVPRCME,oFont10)
			oPrint:Say(_nLin,1860,CODPRODUTO,oFont8)
			oPrint:Say(_nLin,2000,DESCPRODUT,oFont8)
			oPrint:Say(_nLin,2040,UNIDADEM,oFont8)
			oPrint:Say(_nLin,2400,FORNECEDOR,oFont8)
			oPrint:Say(_nLin,2450,CNPJFOR,oFont8)
			oPrint:Say(_nLin,2950,PCAPROVADO,oFont8)
			oPrint:Say(_nLin,3150,TEMCOTACAO,oFont8)
			oPrint:Say(_nLin,3350,FILENTREG,oFont8)
			oPrint:Say(_nLin,3550,NUMNF,oFont8)				//Tatiana A. Barbosa - OS 2358/11 - 09/2011
			oPrint:Say(_nLin,3750,COMPTNF,oFont10)			//Tatiana A. Barbosa - OS 2358/11 - 09/2011
			oPrint:Say(_nLin,3750,VENCTONF,oFont10)			//Tatiana A. Barbosa - OS 2358/11 - 09/2011
			oPrint:Say(_nLin,3750,NUMPROV,oFont8)			//Tatiana A. Barbosa - OS 2358/11 - 09/2011
			
			oPrint:Say(_nLin,3950,CC,oFont8) //EDU
			oPrint:Say(_nLin,4150,VLRTOTAL,oFont8) //EDU
			oPrint:Say(_nLin,4350,QTDSC,oFont8) //EDU
			oPrint:Say(_nLin,4550,QTDPC,oFont8) //EDU
			oPrint:Say(_nLin,4750,CONDPAG,oFont8) //EDU
			oPrint:Say(_nLin,4950,ESTFORN,oFont8) //EDU
			oPrint:Say(_nLin,5050,FRETE,oFont8) //EDU
			
			oPrint:Say(_nLin,5250,BLQSC,oFont8) //EDU
			oPrint:Say(_nLin,5450,BLQPC,oFont8) //EDU
			oPrint:Say(_nLin,5650,OBSSC,oFont8) //EDU
			oPrint:Say(_nLin,5850,PRJ,oFont8) //EDU
			oPrint:Say(_nLin,6050,DESCPRJ,oFont8) //EDU
			oPrint:Say(_nLin,6250,CTAORCA,oFont8) //EDU
			oPrint:Say(_nLin,6450,DESCORC,oFont8) //EDU
			oPrint:Say(_nLin,6650,DTAPROV,oFont8) //EDU
			oPrint:Say(_nLin,7050,DTEMISSA,oFont8) //EDU
			oPrint:Say(_nLin,7250,DTVENC,oFont8) //EDU
			oPrint:Say(_nLin,7450,TOTALNF,oFont8) //EDU
			
			_nLin+=35
			dbSkip()
		ENDDO
		_fRodaPe()
	ENDIF
ELSE	// Gera Excel = SIM
	Processa( { || ExpExcel() },'Exportacao para o Excel...' )
ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha os Arquivos Temporarios. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('QRY1')
dbCloseArea()
dbSelectArea('TRB1')
dbCloseArea()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclui o Arquivo de Trabalho. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fErase(_cArqTrab+GetDbExtension())
RESTAREA(_aArea)
RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fCabec   ºAutor  ³Renato Lucena Neves º Data ³  14/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para impressão do cabeçalho                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 - CSU                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fCabec()
Local _cBitMap1	:=GetSrvProfString("StartPath","")+"lgrl"+SM0->M0_CODIGO+".BMP"
Local _cBitMap2	:=GetSrvProfString("StartPath","")+"logo.bmp"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia a pagina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:StartPage()
_nLin:=380
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressão do cabeçalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oPrint:Box(030,030,260,3300)	//box
oPrint:SayBitMap(050,100,_cBitMap1,280,60) //logo da empresa
oPrint:SayBitMap(050,3000,_cBitMap2,280,60) //logo microsiga
oPrint:Say(100,1000,oPrint:cDocument,oFont14N) //titulo
oPrint:Say(300,0030,"Solicitante",oFont8n)
oPrint:Say(300,0300,"SC",oFont8n)
oPrint:Say(300,0460,"Emissão SC",oFont10)//40
oPrint:Say(300,0660,"Aprov. SC",oFont10)
oPrint:Say(300,0840,"Comprador",oFont8n)//20
oPrint:Say(300,1140,"PC",oFont8n)
oPrint:Say(300,1290,"Emissão PC",oFont10)//50
oPrint:Say(300,1490,"Aprov. PC",oFont10)
oPrint:Say(300,1660,"Aprov. Proc",oFont10)
oPrint:Say(300,1860,"Produto",oFont8n) //30
oPrint:Say(300,2040,"Desc. Produto",oFont8n)
//oPrint:Say(300,1840,"Desc. Produto",oFont8n)
oPrint:Say(300,2450,"Fornecedor",oFont8n)
oPrint:Say(300,2900,"PC Aprov.",oFont8n)
oPrint:Say(300,3100,"Tem Cotação",oFont8n)
oPrint:Say(300,3300,"Fil Entreg",oFont8n)
oPrint:Say(300,3400,"Origem",oFont8n)
oPrint:Say(300,3500,"Cod Proj",oFont8n)
oPrint:Say(300,3600,"Item Proj",oFont8n)
oPrint:Say(300,3700,"Vl Capex",oFont8n)
oPrint:Say(300,3800,"Saving",oFont8n)
oPrint:Say(300,4000,"Num. NF",oFont8n)
oPrint:Say(300,4200,"Compet. NF",oFont10)
OPrint:Line(330,030,330,4200)
RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fRodape  ºAutor  ³Renato Lucena Neves º Data ³  14/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para impressão do rodape                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 - CSU                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fRodaPe()
oPrint:Box(2230,030,2300,3300)	//box
oPrint:Say(2250,3100,str(oPrint:nPage,3),oFont8n)
oPrint:Say(2250,050, _cData, oFont8n)
oPrint:Say(2250,200, _cHora, oFont8n)
oPrint:Say(2250,350, _cUsuario, oFont8n)
oPrint:EndPage()
RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fCriaSx1 ºAutor  ³Renato Lucena Neves º Data ³  14/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para criacao das perguntas.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8- CSU                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fCriaSx1()
SX1->(DbSetOrder(1))
If !SX1->(DbSeek(cPerg+"01",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Da Solicitação"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SC1"
	MsUnLock()
EndIf
If !SX1->(DbSeek(cPerg+"02",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Até a Solicitação"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SC1"
	MsUnLock()
EndIf
If !SX1->(DbSeek(cPerg+"03",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Status"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 01
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "C"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_DEF01   := "Todas"
	SX1->X1_DEF02   := "S/Pedido"
	SX1->X1_DEF03   := "C/Pedido e S/NF"
	SX1->X1_F3		 := ""
	MsUnLock()
EndIf
If !SX1->(DbSeek(cPerg+"04",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Da Emissão"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 08
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := ""
	MsUnLock()
EndIf
If !SX1->(DbSeek(cPerg+"05",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Até a Emissão"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 08
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := ""
	MsUnLock()
EndIf
If !SX1->(DbSeek(cPerg+"06",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Gerar Excel ?"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "1"
	SX1->X1_TAMANHO := 01
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "C"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par06"
	SX1->X1_DEF01   := "Sim"
	SX1->X1_DEF02   := "Não"
	SX1->X1_F3		 := ""
	MsUnLock()
EndIf
RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExpExcel  ºAutor  ³Renato Lucena Neves º Data ³  14/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Exporta os dados para o excel.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8-CSU                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExpExcel()

Local  nHdl, cLin
Local cDirDocs	:= MsDocPath()
Local cArquivo	:= CriaTrab(,.F.)
Local cTempPath	:= Alltrim(GetTempPath())
Local cCmd		:= cDirDocs+"\"+cArquivo+".csv"
nHdl := fCreate(cDirDocs+"\"+cArquivo+".csv")
If nHdl = -1
	MsgStop(OemToAnsi("Não foi possivel criar o arquivo. Verifique os direitos de gravação !"))
	Return
Endif
//cLin := "REQUISITANTE;NUM SC;FIL ENTREGA;EMISSAO SC;APROVACAO SC;COMPRADOR;NUM PC;EMISSAO PC;APROVACAO PC;APROV PROCUR;COD PRODUTO;DESC PRODUTO;TOT PEDIDO;COD FORNEC;LOJA FORNEC;FORNECEDOR;PC APROVADO;TEM COTACAO" + CHR(13)+CHR(10)
cLin := "REQUISITANTE;NUM SC;ITEM SC;FIL ENTREGA;EMISSAO SC;APROVACAO SC;COMPRADOR;NUM PC;EMISSAO PC;APROVACAO PC;APROV PROCUR;ORIGEM;COD PRJ;ITEM PRJ;VLR CAPEX;TOT PEDIDO;SAV CAPEX;COD PRODUTO;DESC PRODUTO;UM;COD FORNEC;LOJA FORNEC;FORNECEDOR;CNPJ;PC APROVADO;TEM COTACAO;NUM NF;COMPET NF;VENCTO NF;PROVISAO;CENTRO DE CUSTO;VALOR UNITARIO DO PEDIDO;QTD DA SOLICITACAO;QTD DO PEDIDO;CONDICAO PAGTO;ESTADO;FRETE;SC BLOQUEADA;PEDIDO BLOQUEADO;OBS SC;NUM PROJETO;DESC PROJETO;CONTA ORCAMENTARIA;DESC ORCAMENTARIA;DT APROVACAO;EMISSAO NF;VENCTO TITULO;VALOR ITEM NF"+ CHR(13)+CHR(10)
fWrite(nHdl,cLin,Len(cLin))
TRB1->(DbGoTop())

ProcRegua(TRB1->(RecCount()))
While TRB1->( !EOF() )
	
	cLin :=	SOLICITANT+';['+SOLICITACA+'];'+'['+ITEMSC+'];'+'['+FILENTREG+'];'+EMISSAOSC+';'+APROVACAOS+';'+COMPRADOR+';['+Alltrim(PEDIDOCOMP)+'];'+;
	EMISSAOPC+';'+APROVACAOP+';'+APROVPRCME+';'+ORIGEM+';['+CODPROJETO+'];'+'['+ITMPROJETO+'];'+Transform(VALORCAPEX,"@E 999,999,999.99")+';'+;
	Transform(TOTPEDIDO,"@E 999,999,999.99")+';'+Transform(SAVING,"@E 999,999,999.99")+';['+CODPRODUTO+'];'+DESCPRODUT+';'+UNIDADEM+';'+CODFOR+';'+LOJFOR+';'+; //EDU
	FORNECEDOR+';'+Transform(CNPJFOR,"@R 99.999.999/9999-99")+';'+PCAPROVADO+';'+TEMCOTACAO+';['+Alltrim(NUMNF)+'];'+Alltrim(COMPTNF)+';'+VENCTONF+';['+NUMPROV+']'+';'+CC+';'+Transform(VLRTOTAL,"@E 9999,999.99")+';'+; //EDU
	Transform(QTDSC,"@E 9,999,999.99")+';'+Transform(QTDPC,"@E 9,999,999.99")+';'+Alltrim(CONDPAG)+';'+ESTFORN+';'+Transform(FRETE,"@E 999,999,999.99")+';'+; //EDU
	BLQSC+';'+BLQPC+';'+OBSSC+';'+PRJ+';'+DESCPRJ+';'+CTAORCA+';'+DESCORC+';'+DTAPROV+';'+Alltrim(DTEMISSA)+';'+DTVENC+';'+Transform(TOTALNF,"@E 999,999,999.99")+CHR(13)+CHR(10) //EDU
	fWrite(nHdl,cLin,Len(cLin))
	IncProc('Gerando Excel....')
	TRB1->(dbSkip())
	
EndDo
fClose(nHdl)
CpyS2T(cDirDocs+"\"+cArquivo+".csv",cTempPath,.T.)
If !ApOleClient("MsExcel")
	MsgStop(OemToAnsi("MsExcel não instalado"))
	Return
Endif
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cTempPath+cArquivo+".csv")
oExcelApp:SetVisible(.T.)

RETURN
