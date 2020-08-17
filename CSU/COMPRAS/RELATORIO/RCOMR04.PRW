#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Rcomr04   ºAutor  ³ Sergio Oliveira    º Data ³  Set/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Analise de Pedidos de Compras e Savings de    º±±
±±º          ³ Pedidos.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Rcomr04()

If !ApOleClient("MsExcel")
	Aviso("100 EXCEL","O MS Excel não encontra-se instalado nesta estação.",;
					{"&Fechar"},3,"Excel não Instalado",,;
					"PCOLOCK")
	Return
Endif

Private nOpca       := 0
Private cCadastro   := "Geracao de Planilha Excel"
Private aRegs := {}, aSays := {}, aButtons := {}
Private oExcelApp, cLin
Private cDirDocs	:= MsDocPath()
Private cArquivo	:= CriaTrab(,.F.)
Private cTempPath	:= Alltrim(GetTempPath())
Private cCmd		:= cDirDocs+"\"+cArquivo+".xls"
Private cPerg       := PADR("RCOMR4",LEN(SX1->X1_GRUPO))
Private cFuncao     := " Processa( { || CursorWait(), Rcomr04a(), CursorArrow() }, 'Efetuando os Filtros, Aguarde...' ) "
//Private cFuncao     := " MsgRun( 'Efetuando os Filtros, Aguarde...' ,'' , { || CursorWait(), Rcomr04a(), CursorArrow() } )"
Private cVldExcel   := " IIF( ValType(oExcelApp)$'O', (oExcelApp:Quit(), oExcelApp:Destroy() ), .t. ) "
Private lSair       := .f.

aAdd(aRegs,{cPerg,"01","Data de Emissao De....:","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data de Emissao Ate...:","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Pedido(Branco = Todos):","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

nHdl := fCreate(cDirDocs+"\"+cArquivo+".csv")

U_ValidPerg( cPerg, aRegs )

Pergunte(cPerg,.f.)

If nHdl = -1
	Aviso("EXCEL","Nao esta sendo possivel acessar o diretorio de arquivos temporarios de sua estacao.",;
					{"&Fechar"},3,"Geracao de Arquivo Excel",,;
					"PCOLOCK")
	Return
Endif
/*
AADD(aSays,OemToAnsi( "Esta rotina tem como objetivo gerar um arquivo no formato " ) )
AADD(aSays,OemToAnsi( "excel dos Pedidos de Compras com seus respectivos Savings, " ) )
AADD(aSays,OemToAnsi( "Base Line e Racional. " ) )

AADD(aButtons, { 5,.T.,{||Pergunte(cPerg,.t.) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons,,240,425 )
*/
Define MsDialog MkwDlg Title "Geracao de Planilha Excel" From 298,302 To 500,721 Of oMainWnd Pixel
@ 002,003 To 100,165
@ 012,170 To 087,203
@ 035,015 Say "Esta rotina tem como objetivo gerar um arquivo no formato" Size 141,8
@ 045,015 Say "excel dos Pedidos de Compras com seus respectivos"         Size 142,8
@ 055,015 Say "Savings.   Base Line e Racional. " 						  Size 143,8
@ 020,173 Button "_Parametros" Size 28,16 Action( Pergunte(cPerg,.t.) ) 
@ 042,173 Button "_Gerar"      Size 28,16 Action( &( cFuncao ) )
@ 064,173 Button "_Sair"       Size 28,16 Action( &( cVldExcel ), lSair := .t., MkwDlg:End() )

Activate Dialog mkwdlg Centered Valid lSair
/*
If nOpcA == 1
	MsgRun( 'Efetuando os Filtros, Aguarde...' ,"" , { || CursorWait(), Rcomr04a(), CursorArrow() } )
EndIf
*/

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Rcomr04a ºAutor  ³ Sergio Oliveira    º Data ³  Set/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento do relatorio.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomr04.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Rcomr04a()

Local cSelect, cSite, cLin := ""
Local cEol := Chr(13)+Chr(10)
Local aStru
Local _cDtLibSC := ""
Local _cDtEmiSC := ""
Local _cDtLibPC := ""
Local _cDtLibPR := ""
Local _cPCAprov	:= ""
Local _cCotAprov:= ""
Local _cGrpComp := ""
Local _dCompetNF:= ""
Local _cNumNF   := ""
Local _cNumProv := ""
Local _dVenctoNF := ""

SB1->( DbSetOrder(1) )
SC1->( DbSetOrder(1) )

ChkFile('ZA7')

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Equalizar os relatorios RCOMR03 E RCOMR04 - OS 0927/10³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

cSelect := " SELECT C7_X_CAPEX, C7_X_PRJ, C7_USER, C7_EMISSAO, C7_NUM, C7_ITEM,A2_NOME,C7_NUMSC,C7_ITEMSC,C7_PRODUTO,C7_QUANT,C7_DESCRI,C7_FORNECE,C7_LOJA,C7_NUMCOT,C7_CONAPRO, C7_XVLCAPE, SUM(C7_TOTAL) AS TOTPED, SUM( C7_VLDESC ) AS SAVING, C7_USER AS COMPRADOR "
cSelect += " FROM "+RetSqlName('SC7') + " AS SC7, " +RetSqlName('SA2') + " AS SA2 "
cSelect += " WHERE C7_FILIAL  =  '"+xFilial('SC7')+"' "
If !Empty( MV_PAR03 )
    cSelect += " AND C7_NUM = '"+MV_PAR03+"' "
EndIf
cSelect += " AND   C7_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' "
cSelect += " AND   SC7.D_E_L_E_T_ = ' ' "
cSelect += " AND   A2_FILIAL  =  '"+xFilial('SA2')+"' "
cSelect += " AND   A2_COD  =  C7_FORNECE " 
cSelect += " AND   A2_LOJA  =  C7_LOJA " 
cSelect += " AND   SA2.D_E_L_E_T_ = ' ' "
cSelect += " GROUP BY C7_X_CAPEX, C7_X_PRJ, C7_USER, C7_EMISSAO, C7_NUM,C7_ITEM, A2_NOME,C7_NUMSC,C7_ITEMSC,C7_PRODUTO,C7_QUANT,C7_DESCRI,C7_FORNECE,C7_LOJA,C7_NUMCOT,C7_CONAPRO, C7_XVLCAPE "

nCntView := U_MontaView( cSelect, 'Work' )

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Efetuar a compatibilizacao de campos Data e Numericos ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
  
TcSetField( 'Work', "C7_EMISSAO", "D", 08,00 )
TcSetField( 'Work', "TOTPED"    , "N", 14,02 )
TcSetField( 'Work', "SAVING"    , "N", 14,02 )

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Gerar o cabecalho do arquivo HTML + os Estilos CCS    ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

Rcomr04b()

DbSelectArea( 'Work' )
DbGoTop()
ProcRegua( nCntView )

While Work->(!Eof())
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca o grupo de compras - OS 0993/10                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SB1->(dbSeek(xFilial('SB1')+Work->C7_PRODUTO)))
   		_cGrpComp := SB1->B1_GRUPCOM
   	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca Emissao da Solicitacao de compras                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SC1->(dbSeek(xFilial('SC1')+Work->C7_NUMSC+Work->C7_ITEMSC)))
   		_cDtEmiSC := DTOC(SC1->C1_EMISSAO)
   		//_cCodProd := SC1->C1_PRODUTO
   	   //	_cDesProd := SC1->C1_DESCRI
   		//_cCodUser := UsrFullName(SC1->C1_USER)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca ultima data de liberacao da solicitacao de compra. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCR->(dbSeek(xFilial('SCR')+'SC'+Work->C7_NUMSC))
	_cDtLibSC := ""
	WHILE ALLTRIM(xFilial('SCR')+'SC'+Work->C7_NUMSC)==ALLTRIM(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) .AND. SCR->(!EOF())
		_cDtLibSC := DTOC(SCR->CR_DATALIB)
		SCR->(dBSkip())
	ENDDO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca ultima data de liberacao do pedido de compra. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SCR->(dbSeek(xFilial('SCR')+'PC'+Work->C7_NUM))
	_cDtLibPC := ""
	_cDtLibPR := "  /  /    "
	WHILE ALLTRIM(xFilial('SCR')+'PC'+Work->C7_NUM)==ALLTRIM(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) .AND. SCR->(!EOF())
		_cDtLibPC := DTOC(SCR->CR_DATALIB)
		
		If SCR->CR_X_TPLIB == 'S'
			_cDtLibPR := DTOC(SCR->CR_DATALIB)
		EndIf	
		SCR->(DBSkip())
	ENDDO
    
	_cPCAprov	:= IIF(Work->C7_CONAPRO =='L','Sim','Não')
    _cCotAprov	:= IIF(EMPTY(Work->C7_NUMCOT),'Não','Sim')

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Obter a ultima sequencia da digitacao do Saving:      ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
  
    cSelect := " SELECT MAX(R_E_C_N_O_) AS REG FROM "+RetSqlName('ZA7')
    cSelect += " WHERE ZA7_FILIAL = '"+xFilial('ZA7')+"' "
    cSelect += " AND   ZA7_PEDIDO = '"+Work->C7_NUM+"' "
    cSelect += " AND   D_E_L_E_T_ = ' ' "
    
    U_MontaView( cSelect, 'WorkII' )
    
    WorkII->( DbGoTop() )
    
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Verificar se existe solicitacao de compras para poder obter o Site ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
  
    cSelect := " SELECT DISTINCT C1_FILENT FROM "+RetSqlName('SC1')
    cSelect += " WHERE C1_FILIAL = '"+xFilial('SC1')+"' "
    cSelect += " AND   C1_PEDIDO = '"+Work->C7_NUM+"' "
    cSelect += " AND   D_E_L_E_T_ = ' ' "
    
    U_MontaView( cSelect, 'WorkIII' )
    
    WorkIII->( DbGoTop() )
    
    // OS 1024-12 - INICIO
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca o numero da NF e Competência (data de lançamento da NF). - Renato Carlos - OS 1024/12 - 05/2012	   ³		//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQuery := " SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, D1_PEDIDO, D1_ITEMPC, D1_DTDIGIT FROM "+RETSQLNAME('SD1')
	_cQuery += " WHERE "
	_cQuery += " D1_PEDIDO = '"+Work->C7_NUM+"' AND D1_ITEMPC = '"+Work->C7_ITEM+"' "
	_cQuery += " AND   D_E_L_E_T_ = ' ' "
	
	U_MontaView( _cQuery, '_QSD1' )

	dbSelectArea('_QSD1')
	DbGotop()
	
	IF ALLTRIM(_QSD1->D1_PEDIDO+_QSD1->D1_ITEMPC)==ALLTRIM(Work->(C7_NUM+C7_ITEM)) .AND. _QSD1->D1_PEDIDO<>"      "
		_dCompetNF 	:= Dtoc(Stod(_QSD1->D1_DTDIGIT))
		_cNumNF 	:= _QSD1->D1_DOC+" / "+_QSD1->D1_SERIE
	ELSE
		_dCompetNF 	:= ""
		_cNumNF 	:= ""
	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca o numero da Provisão do Pedido de Compra. - 		Renato Carlos - OS 1024/12 - 05/2012			   ³		//ZB2_FILIAL+ZB2_PROVIS+ZB2_NATURE
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQuery := " SELECT ZB2_PROVIS, ZB2_PEDCOM FROM "+RETSQLNAME('ZB2')
	_cQuery += " WHERE "
	_cQuery += " ZB2_PEDCOM = '"+Work->C7_NUM+"' "
	_cQuery += " AND   D_E_L_E_T_ = ' ' "
	
	U_MontaView( _cQuery, 'QZB2' )
	
	//TCQUERY _cQuery NEW ALIAS 'QZB2'
	dbSelectArea('QZB2')
	DbGotop()
	IF ALLTRIM(QZB2->ZB2_PEDCOM)==ALLTRIM(Work->C7_NUM) .AND. QZB2->ZB2_PEDCOM<>"      "
		_cNumProv 	:= QZB2->ZB2_PROVIS
	ELSE
		_cNumProv 	:= ""
	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ "	Vencimento da NF (caso exista mais de um titulo gerado para a mesma NF no relatório será informado apenas  ³
	//³     o vencimento do 1º titulo) 	Renato Carlos - OS 1024/12 - 05/2012			   					   ³		//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA                                                                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQuery := " SELECT TOP 1 E2_NUM, E2_FORNECE, E2_LOJA, E2_VENCTO FROM "+RETSQLNAME('SE2')
	_cQuery += " WHERE "
	_cQuery += " E2_NUM = '"+_QSD1->D1_DOC+"' AND E2_FORNECE = '"+_QSD1->D1_FORNECE+"' AND E2_LOJA = '"+_QSD1->D1_LOJA+"' "
	_cQuery += " AND   D_E_L_E_T_ = ' ' "
	_cQuery += " ORDER BY E2_VENCTO"
    
	U_MontaView( _cQuery, 'QSE2' )

	//TCQUERY _cQuery NEW ALIAS 'QSE2'
	dbSelectArea('QSE2')
	DbGotop()
	IF QSE2->E2_VENCTO <> '20070202'
		IF _QSD1->D1_DOC<>"         " .Or. QSE2->E2_NUM<>"         " .Or. Work->C7_NUM<>"      "
			_dVenctoNF 	:= Dtoc(Stod(QSE2->E2_VENCTO))
		ELSE
			_dVenctoNF 	:= ""
		ENDIF
	ELSE
		_dVenctoNF 	:= ""
	ENDIF
    
    // OS 1024-12 - FIM
    
    If Empty( WorkIII->C1_FILENT )
       cSite := ""
    Else
       cSite := Posicione( 'SM0',1,cEmpAnt+WorkIII->C1_FILENT, "M0_FILIAL" )
    EndIf

    cLin += "<td class=xl3331556 style='border-left:none'>"+Work->C7_X_CAPEX+"</td> "
    cLin += "<td class=xl3331556 style='border-left:none'>"+Work->C7_X_PRJ+"</td> "
    If WorkII->REG > 0
    
        ZA7->( DbGoTo( WorkII->REG ) )
        
        
        cLin += "<td class=xl3331556 style='border-left:none'>"+Work->C7_NUMSC+"</td> " // OS 0927/10
        cLin += "<td class=xl3331556 style='border-left:none'>"+_cDtEmiSC+"</td> "// OS 0927/10
        cLin += "<td class=xl3331556 style='border-left:none'>"+_cDtLibSC+"</td> "// OS 0927/10
        cLin += "<td class=xl3331556 style='border-left:none'>"+Dtoc(Work->C7_EMISSAO)+"</td> "
  	    cLin += "<td class=xl3431556 style='border-left:none'>"+Work->C7_NUM+"</td> "
  	    cLin += "<td class=xl3331556 style='border-left:none'>"+_cDtLibPC+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3331556 style='border-left:none'>"+_cDtLibPR+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_PRODUTO)+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Transform(Work->C7_QUANT,"@E 999,999,999.99")+"</td> "// OS 2611/10 Tatiana
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_DESCRI)+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cGrpComp)+"</td> "// OS 0993/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_FORNECE)+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_LOJA)+"</td> "// OS 0927/10
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->A2_NOME)+"</td> "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cPCAprov)+"</td> " // OS 0927/10
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cCotAprov)+"</td> "  // OS 0927/10
        cLin += "<td class=xl3431556 style='border-left:none'>"+cSite+"</td> "
        cLin += "<td class=xl3331556 style='border-left:none'>"+Transform(ZA7->ZA7_BASELI, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+Transform(Work->TOTPED, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Transform(ZA7->ZA7_BASELI-Work->TOTPED, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+UsrFullName(Work->C7_USER)+"</td> "
        cLin += "<td class=xl3531556 style='border-left:none'>"+ZA7->ZA7_DESCRI+"</td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+Transform(ZA7->ZA7_RACION, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3531556 style='border-left:none'>"+ZA7->ZA7_CLASSI+"</td>  "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Transform(Work->C7_XVLCAPE, "@E 999,999,999.99")+"</td>  "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cNumNF)+"</td>  "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_dCompetNF)+"</td>  "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_dVenctoNF)+"</td>  "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cNumProv)+"</td></tr>  "
        
       

    Else
       
    	cLin += "<td class=xl3331556 style='border-left:none'>"+Work->C7_NUMSC+"</td> "// OS 0927/10
        cLin += "<td class=xl3331556 style='border-left:none'>"+_cDtEmiSC+"</td> "// OS 0927/10
        cLin += "<td class=xl3331556 style='border-left:none'>"+_cDtLibSC+"</td> "// OS 0927/10
        cLin += "<td class=xl3331556 style='border-left:none'>"+Dtoc(Work->C7_EMISSAO)+"</td> "
  	    cLin += "<td class=xl3431556 style='border-left:none'>"+Work->C7_NUM+"</td> "
  	    cLin += "<td class=xl3331556 style='border-left:none'>"+_cDtLibPC+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3331556 style='border-left:none'>"+_cDtLibPR+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_PRODUTO)+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Transform(Work->C7_QUANT,"@E 999,999,999.99")+"</td> "// OS 2611/10 Tatiana
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_DESCRI)+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cGrpComp)+"</td> "// OS 0993/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_FORNECE)+"</td> "// OS 0927/10
  	    cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->C7_LOJA)+"</td> "// OS 0927/10
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(Work->A2_NOME)+"</td> "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cPCAprov)+"</td> " // OS 0927/10
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cCotAprov)+"</td> " // OS 0927/10  
        cLin += "<td class=xl3431556 style='border-left:none'>"+cSite+"</td> "
        cLin += "<td class=xl3331556 style='border-left:none'>"+Transform(0, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+Transform(Work->TOTPED, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Transform(WORK->SAVING, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+UsrFullName(Work->C7_USER)+"</td> "
        cLin += "<td class=xl3531556 style='border-left:none'> </td> "
        cLin += "<td class=xl3431556 style='border-left:none'>"+Transform(0, "@E 999,999,999.99")+"</td> "
        cLin += "<td class=xl3531556 style='border-left:none'> </td>  "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Transform(Work->C7_XVLCAPE, "@E 999,999,999.99")+"</td>  "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cNumNF)+"</td>  "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_dCompetNF)+"</td>  "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_dVenctoNF)+"</td>  "
        cLin += "<td class=xl3531556 style='border-left:none'>"+Trim(_cNumProv)+"</td></tr>  "

    EndIf

    // Grava linha a linha no arquivo XLS

    xAddToFile( cLin, cCmd )

    cLin := " 	  <tr height=17 style='height:12.75pt'> "
    cLin += " 	   <td height=17 class=xl2531556 style='height:12.75pt'></td> "

	IncProc('Gerando Excel....')

	Work->(DbSkip())
	
EndDo

// finaliza gravacao do arquivo excel

cLin += " </table> "
cLin += " </div> "
cLin += " </body> "
cLin += " </html> "

/*
cLin += "</font>"
cLin += "</table>"
*/

// Grava linha a linha no arquivo XLS

xAddToFile( cLin, cCmd )

CpyS2T(cDirDocs+"\"+cArquivo+".xls",cTempPath,.T.)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cTempPath+cArquivo+".xls")
oExcelApp:SetVisible(.T.)

If Select( 'WorkI' ) > 0
	Work->( DbCloseArea() )
EndIf

If Select( 'WorkII' ) > 0
	WorkII->( DbCloseArea() )
EndIf

If Select( 'WorkIII' ) > 0
	WorkIII->( DbCloseArea() )
EndIf

If Select( '_QSD1' ) > 0
	_QSD1->( DbCloseArea() )
EndIf

If Select( 'QZB2' ) > 0
	QZB2->( DbCloseArea() )
EndIf

If Select( 'QSD2' ) > 0
	QSE2->( DbCloseArea() )
EndIf

Ferase( cDirDocs+"\"+cArquivo+".xls" )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xAddToFileºAutor  ³ Sergio Oliveira    º Data ³  Set/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adiciona a linha de log ao fim de um arquivo.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rcomr04.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/

Static Function xAddToFile( cLog, cToFile )

Local nHdl  := -1
Local cBuff := cLog

If File( cToFile )

   nHdl := FOpen( cToFile, 1 )

   If nHdl >= 0

       FSeek( nHdl, 0, 2 )

   EndIf

Else

   nHdl := FCreate( cToFile )

EndIf

If nHdl >= 0

   FWrite( nHdl,  cBuff, Len( cBuff ) )

EndIf

FClose( nHdl )

Return

Static Function Rcomr04b()

Local cGrvBuff := ''
 
cGrvBuff += ' <html xmlns:v="urn:schemas-microsoft-com:vml" ' '
cGrvBuff += ' xmlns:o="urn:schemas-microsoft-com:office:office" '
cGrvBuff += ' xmlns:x="urn:schemas-microsoft-com:office:excel" '
cGrvBuff += ' xmlns="http://www.w3.org/TR/REC-html40"> '
cGrvBuff += ' <head> '
cGrvBuff += ' <meta http-equiv=Content-Type content="text/html; charset=windows-1252"> '
cGrvBuff += ' <meta name=ProgId content=Excel.Sheet> '
cGrvBuff += ' <meta name=Generator content="Microsoft Excel 11"> '
cGrvBuff += ' <link rel=File-List href="sc356290_arquivos/filelist.xml"> '
cGrvBuff += ' <style> '
cGrvBuff += ' v\:* {behavior:url(#default#VML);} '
cGrvBuff += ' o\:* {behavior:url(#default#VML);} '
cGrvBuff += ' x\:* {behavior:url(#default#VML);} '
cGrvBuff += ' .shape {behavior:url(#default#VML);} '
cGrvBuff += ' </style> '
cGrvBuff += ' <style id="Pedidos  BackLog1_31556_Styles"> '
cGrvBuff += ' <!--table '
cGrvBuff += ' 	{mso-displayed-decimal-separator:"\,"; '
cGrvBuff += ' 	mso-displayed-thousand-separator:"\.";} '
cGrvBuff += ' .xl1531556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:400; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial; '
cGrvBuff += ' 	mso-generic-font-family:auto; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:General; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd ) 

cGrvBuff += ' .xl2231556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:700; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial, sans-serif; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:General; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;} '
cGrvBuff += ' .xl2331556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:700; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial, sans-serif; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:"Short Date"; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd ) 

cGrvBuff += ' .xl2431556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 	font-weight:400; '
cGrvBuff += ' 	font-style:normal; '
cGrvBuff += ' 	text-decoration:none; '
cGrvBuff += ' 	font-family:Arial; '
cGrvBuff += ' 	mso-generic-font-family:auto; '
cGrvBuff += ' 	mso-font-charset:0; '
cGrvBuff += ' 	mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 	text-align:general; '
cGrvBuff += ' 	vertical-align:bottom; '
cGrvBuff += ' 	mso-background-source:auto; '
cGrvBuff += ' 	mso-pattern:auto; '
cGrvBuff += ' 	white-space:nowrap;}  '

xAddToFile( cGrvBuff, cCmd )
 
cGrvBuff += ' 	.xl2531556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:General; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl2631556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd ) 

cGrvBuff += ' 	.xl2731556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:General; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl2831556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:right; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; ' '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl2931556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; ' 
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl3031556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl3131556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '
cGrvBuff += ' 		.xl3231556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:"d\/mmm"; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom;  '
cGrvBuff += ' 			border:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd ) 

cGrvBuff += ' 		.xl3331556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:"d\/mmm"; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '
cGrvBuff += ' 		.xl3431556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 		.xl3531556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:general; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '
cGrvBuff += ' 		.xl3631556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:400; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial; '
cGrvBuff += ' 			mso-generic-font-family:auto; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 			text-align:right; '
cGrvBuff += ' 			vertical-align:bottom; '
cGrvBuff += ' 			border-top:none; '
cGrvBuff += ' 			border-right:.5pt solid silver; '
cGrvBuff += ' 			border-bottom:.5pt solid silver; '
cGrvBuff += ' 			border-left:.5pt solid silver; '
cGrvBuff += ' 			mso-background-source:auto; '
cGrvBuff += ' 			mso-pattern:auto; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd ) 

cGrvBuff += ' 		.xl3731556 '
cGrvBuff += ' 			{padding:0px; '
cGrvBuff += ' 			mso-ignore:padding; '
cGrvBuff += ' 			color:windowtext; '
cGrvBuff += ' 			font-size:10.0pt; '
cGrvBuff += ' 			font-weight:700; '
cGrvBuff += ' 			font-style:normal; '
cGrvBuff += ' 			text-decoration:none; '
cGrvBuff += ' 			font-family:Arial, sans-serif; '
cGrvBuff += ' 			mso-font-charset:0; '
cGrvBuff += ' 			mso-number-format:General; '
cGrvBuff += ' 			text-align:center; '
cGrvBuff += ' 			vertical-align:middle; '
cGrvBuff += ' 			border-top:1.0pt solid windowtext; '
cGrvBuff += ' 			border-right:.5pt solid windowtext; '
cGrvBuff += ' 			border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 			border-left:1.0pt solid windowtext; '
cGrvBuff += ' 			background:#99CCFF; '
cGrvBuff += ' 			mso-pattern:auto none; '
cGrvBuff += ' 			white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 			.xl3831556 '
cGrvBuff += ' 				{padding:0px; '
cGrvBuff += ' 				mso-ignore:padding; '
cGrvBuff += ' 				color:windowtext; '
cGrvBuff += ' 				font-size:10.0pt; '
cGrvBuff += ' 				font-weight:700; '
cGrvBuff += ' 				font-style:normal; '
cGrvBuff += ' 				text-decoration:none; '
cGrvBuff += ' 				font-family:Arial, sans-serif; '
cGrvBuff += ' 				mso-font-charset:0; '
cGrvBuff += ' 				mso-number-format:General; '
cGrvBuff += ' 				text-align:center; '
cGrvBuff += ' 				vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:.5pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '
cGrvBuff += ' 				.xl3931556 '
cGrvBuff += ' 					{padding:0px; '
cGrvBuff += ' 					mso-ignore:padding; '
cGrvBuff += ' 					color:windowtext; '
cGrvBuff += ' 					font-size:10.0pt; '
cGrvBuff += ' 					font-weight:700; '
cGrvBuff += ' 					font-style:normal; '
cGrvBuff += ' 					text-decoration:none; '
cGrvBuff += ' 					font-family:Arial, sans-serif; '
cGrvBuff += ' 					mso-font-charset:0; '
cGrvBuff += ' 					mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 					text-align:center; '
cGrvBuff += ' 					vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:.5pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd ) 

cGrvBuff += ' 				.xl4031556 '
cGrvBuff += ' 					{padding:0px; '
cGrvBuff += ' 					mso-ignore:padding; '
cGrvBuff += ' 					color:windowtext; '
cGrvBuff += ' 					font-size:10.0pt; '
cGrvBuff += ' 					font-weight:700; '
cGrvBuff += ' 					font-style:normal; '
cGrvBuff += ' 					text-decoration:none; '
cGrvBuff += ' 					font-family:Arial, sans-serif; '
cGrvBuff += ' 					mso-font-charset:0; '
cGrvBuff += ' 					mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 					text-align:center; '
cGrvBuff += ' 					vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:.5pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '
cGrvBuff += ' 				.xl4131556 '
cGrvBuff += ' 					{padding:0px; '
cGrvBuff += ' 					mso-ignore:padding; '
cGrvBuff += ' 					color:windowtext; '
cGrvBuff += ' 					font-size:10.0pt; '
cGrvBuff += ' 					font-weight:700; '
cGrvBuff += ' 					font-style:normal; '
cGrvBuff += ' 					text-decoration:none; '
cGrvBuff += ' 					font-family:Arial, sans-serif; '
cGrvBuff += ' 					mso-font-charset:0; '
cGrvBuff += ' 					mso-number-format:General; '
cGrvBuff += ' 					text-align:center; '
cGrvBuff += ' 					vertical-align:middle; '
cGrvBuff += ' 					border-top:1.0pt solid windowtext; '
cGrvBuff += ' 					border-right:1.0pt solid windowtext; '
cGrvBuff += ' 					border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 					border-left:.5pt solid windowtext; '
cGrvBuff += ' 					background:#99CCFF; '
cGrvBuff += ' 					mso-pattern:auto none; '
cGrvBuff += ' 					white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' .xl4231556 '
cGrvBuff += ' 	{padding:0px; '
cGrvBuff += ' 	mso-ignore:padding; '
cGrvBuff += ' 	color:windowtext; '
cGrvBuff += ' 	font-size:10.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 		text-align:center; '
cGrvBuff += ' 		vertical-align:middle; '
cGrvBuff += ' 		border-top:1.0pt solid windowtext; '
cGrvBuff += ' 		border-right:.5pt solid windowtext; '
cGrvBuff += ' 		border-bottom:1.0pt solid windowtext; '
cGrvBuff += ' 		border-left:.5pt solid windowtext; '
cGrvBuff += ' 		background:#99CCFF; '
cGrvBuff += ' 		mso-pattern:auto none; '
cGrvBuff += ' 		white-space:normal;} '
cGrvBuff += ' 	.xl4331556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"\0022R$ \0022\#\,\#\#0\.00"; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border-top:none; '
cGrvBuff += ' 		border-right:.5pt solid silver; '
cGrvBuff += ' 		border-bottom:.5pt solid silver; ' 
cGrvBuff += ' 		border-left:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd ) 

cGrvBuff += ' 	.xl4431556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:18.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:General; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	.xl4531556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0_\)\;_\(* \\\(\#\,\#\#0\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:left; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd ) 

cGrvBuff += ' 	.xl4631556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:400; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial; '
cGrvBuff += ' 		mso-generic-font-family:auto; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"_\(* \#\,\#\#0\.00_\)\;_\(* \\\(\#\,\#\#0\.00\\\)\;_\(* \0022-\0022??_\)\;_\(\@_\)"; '
cGrvBuff += ' 		text-align:general; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		border:.5pt solid silver; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '

xAddToFile( cGrvBuff, cCmd )

cGrvBuff += ' 	.xl4731556 '
cGrvBuff += ' 		{padding:0px; '
cGrvBuff += ' 		mso-ignore:padding; '
cGrvBuff += ' 		color:windowtext; '
cGrvBuff += ' 		font-size:10.0pt; '
cGrvBuff += ' 		font-weight:700; '
cGrvBuff += ' 		font-style:normal; '
cGrvBuff += ' 		text-decoration:none; '
cGrvBuff += ' 		font-family:Arial, sans-serif; '
cGrvBuff += ' 		mso-font-charset:0; '
cGrvBuff += ' 		mso-number-format:"0\.0%"; '
cGrvBuff += ' 		text-align:right; '
cGrvBuff += ' 		vertical-align:bottom; '
cGrvBuff += ' 		mso-background-source:auto; '
cGrvBuff += ' 		mso-pattern:auto; '
cGrvBuff += ' 		white-space:nowrap;} '
cGrvBuff += ' 	--> '
cGrvBuff += ' 	</style> '
cGrvBuff += ' 	</head> '

xAddToFile( cGrvBuff, cCmd ) 

cGrvBuff += " 	<body> "
cGrvBuff += " 	<table x:str border=0 cellpadding=0 cellspacing=0 width=1171 style='border-collapse: "
cGrvBuff += " 	 collapse;table-layout:fixed;width:880pt'> "
cGrvBuff += " 	 <col class=xl2531556 width=26 style='mso-width-source:userset;mso-width-alt: "
cGrvBuff += " 	 950;width:20pt'> "
cGrvBuff += " 	 <col width=90 span=2 style='mso-width-source:userset;mso-width-alt:3291; "
cGrvBuff += " 	 width:68pt'> "
cGrvBuff += " 	 <col width=306 style='mso-width-source:userset;mso-width-alt:11190;width:230pt'> "
cGrvBuff += " 	 <col width=80 style='mso-width-source:userset;mso-width-alt:2925;width:60pt'> "
cGrvBuff += " 	 <col width=92 style='mso-width-source:userset;mso-width-alt:3364;width:69pt'> "
cGrvBuff += " 	 <col class=xl2631556 width=95 style='mso-width-source:userset;mso-width-alt: "
cGrvBuff += " 	 3474;width:71pt'> "
cGrvBuff += " 	 <col class=xl2431556 width=95 style='mso-width-source:userset;mso-width-alt: "
cGrvBuff += " 	 3474;width:71pt'> "
cGrvBuff += " 	 <col width=89 style='mso-width-source:userset;mso-width-alt:3254;width:67pt'> "
cGrvBuff += " 	 <col width=18 style='mso-width-source:userset;mso-width-alt:658;width:14pt'> "
cGrvBuff += " 	 <col class=xl2431556 width=95 span=2 style='mso-width-source:userset; "
cGrvBuff += " 	 mso-width-alt:3474;width:71pt'> "

xAddToFile( cGrvBuff, cCmd ) 

cGrvBuff += " 	 <tr height=17 style='height:12.75pt'> "
cGrvBuff += " 	  <td height=17 class=xl2531556 width=26 style='height:12.75pt;width:20pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=90 style='width:68pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=90 style='width:68pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=306 style='width:230pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=80 style='width:60pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=92 style='width:69pt'></td> "
cGrvBuff += " 	  <td class=xl2631556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	  <td class=xl2431556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=89 style='width:67pt'></td> "
cGrvBuff += " 	  <td class=xl1531556 width=18 style='width:14pt'></td> "
cGrvBuff += " 	  <td class=xl2431556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	  <td class=xl2431556 width=95 style='width:71pt'></td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr height=31 style='height:23.25pt'> "
cGrvBuff += " 	  <td height=31 class=xl2531556 style='height:23.25pt'></td> "

xAddToFile( cGrvBuff, cCmd ) 

cGrvBuff += " 	  <td class=xl4431556 colspan=3>Relatório Diário de Pedidos</td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr height=20 style='mso-height-source:userset;height:15.0pt'> "
cGrvBuff += " 	  <td height=20 class=xl2531556 style='height:15.0pt'></td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr height=18 style='height:13.5pt'> "
cGrvBuff += " 	  <td height=18 class=xl2531556 style='height:13.5pt'></td> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	 <tr class=xl2231556 height=44 style='mso-height-source:userset;height:33.0pt'> "
cGrvBuff += " 	  <td height=44 class=xl2531556 style='height:33.0pt'></td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Origem</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Projeto</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Numero SC</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Emissao SC</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Aprovacao SC</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Data Pedido</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Nº do Pedido</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Aprov Pedido</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Aprov Procur</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Cod Produto</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Qtde Produto</td> " //OS 2611/10 Tatiana
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Desc Produto</td> "
cGrvBuff += " 	  <td class=xl3731556 style='border-left:none'>Grupo Comp</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Fornecedor</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Loja</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>R Social</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Pedido Aprovado?</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Tem Cotação?</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Site</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Base Line</td> "
cGrvBuff += " 	  <td class=xl3831556 style='border-left:none'>Valor</td> "
cGrvBuff += " 	  <td class=xl4031556 style='border-left:none'>Savings</td> "
cGrvBuff += " 	  <td class=xl4131556 style='border-left:none'>Comprador</td> "
cGrvBuff += " 	  <td class=xl4031556 style='border-left:none'>Obs. Geral</td> "
cGrvBuff += " 	  <td class=xl4231556 style='border-left:none'>Racional Base Line<br> "
cGrvBuff += " 	  <td class=xl4231556 style='border-left:none'>Classificacao<br> "
cGrvBuff += " 	  <td class=xl4231556 style='border-left:none'>Valor Capex<br> "
cGrvBuff += " 	  <td class=xl4231556 style='border-left:none'>Numero NF<br> "
cGrvBuff += " 	  <td class=xl4231556 style='border-left:none'>Compet NF<br> "
cGrvBuff += " 	  <td class=xl4231556 style='border-left:none'>Vencim NF<br> "
cGrvBuff += " 	  <td class=xl4231556 style='border-left:none'>Provisao<br> "
cGrvBuff += " 	 </tr> "
cGrvBuff += " 	  <tr height=17 style='height:12.75pt'> "
cGrvBuff += " 	   <td height=17 class=xl2531556 style='height:12.75pt'></td> "

xAddToFile( cGrvBuff, cCmd ) 

Return  