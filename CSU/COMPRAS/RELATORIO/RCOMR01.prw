#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ RCOMR01.PRW  ³ Autor ³ Flavio Novaes   ³ Data ³ 18/04/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Relatorio de Acompanhamento de Processos: do Pedido de Com-³±±
±±³            ³ pra ate a Entrada da Nota Fiscal, com Aprovacoes e Contas a³±±
±±³            ³ Pagar. Chamado 000000001069                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Exclusivo CSU.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Observacao ³ Esse relatorio foi desenvolvido com base no programa de    ³±±
±±³            ³ mesmo nome, de Renato Lucena Neves, de 14/03/07. O motivo  ³±±
±±³            ³ de ser desenvolvido novamente foi que os usuarios solicita-³±±
±±³            ³ ram diversas alteracoes e, dentre elas, que o mesmo pudesse³±±
±±³            ³ gerar um aruivo (##R) para ser manipulado pelo Excel.      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION RCOMR01()
LOCAL wnrel      := 'RCOMR01'
LOCAL cDesc1     := 'Este relatorio ira emitir as Informações do  '
LOCAL cDesc2     := 'Processo de Pedido de Compra até a Entrada da'
LOCAL cDesc3     := 'Nota Fiscal, com Aprovações e Contas a Pagar.'
LOCAL cString    := 'SD1'
PRIVATE tamanho  := 'G'		// 'P', 'M' ou 'G'
PRIVATE limite   := 220		//  80, 132 ou 220
PRIVATE titulo   := 'Relatório de Acompanhamento de Processo'
PRIVATE aReturn  := {'Zebrado',1,'Administracao',2,2,1,'',1}
PRIVATE nomeprog := 'RCOMR01'
PRIVATE aLinha   := {}
PRIVATE nLastKey := 0
PRIVATE cPerg    := PADR('XCOM02',LEN(SX1->X1_GRUPO))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas nos Parametros     ³
//³ mv_par01   Da Data de Digitacao         ³
//³ mv_par02   Ate a Data de Digitacao      ³
//³ mv_par03   Do Fornecedor                ³
//³ mv_par04   Da Loja                      ³
//³ mv_par05   Ate o Fornecedor             ³
//³ mv_par06   Ate a Loja                   ³
//³ mv_par07   Da Nota Fiscal de Entrada    ³
//³ mv_par08   Ate a Nota Fiscal de Entrada ³
//³ mv_par09   Do Pedido                    ³
//³ mv_par10   Ate o Pedido                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_FCriaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PERGUNTE(cPerg,.F.)
wnrel := SETPRINT(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,'',,tamanho)
IF nLastKey==27
	dbClearFilter()
	RETURN()
ENDIF
SETDEFAULT(aReturn,cString)
IF nLastKey == 27
	dbClearFilter()
	RETURN()
ENDIF
RPTSTATUS({|lEnd|FIMPRIME()(@lEnd,wnRel,cString)},titulo)
RETURN()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ FIMPRIME.PRW ³ Autor ³ Flavio Novaes   ³ Data ³ 18/04/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Relatorio de Acompanhamento de Processos: do Pedido de Com-³±±
±±³            ³ pra ate a Entrada da Nota Fiscal, com Aprovacoes e Contas a³±±
±±³            ³ Pagar. Chamado 000000001069                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Exclusivo CSU.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Observacao ³ Esse relatorio foi desenvolvido com base no programa de    ³±±
±±³            ³ mesmo nome, de Renato Lucena Neves, de 14/03/07. O motivo  ³±±
±±³            ³ de ser desenvolvido novamente foi que os usuarios solicita-³±±
±±³            ³ ram diversas alteracoes e, dentre elas, que o mesmo pudesse³±±
±±³            ³ gerar um arquivo .##R para ser manipulado pelo Excel.      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION FIMPRIME(lEnd,WnRel,cString)
////////////
/// Alterado por Daniel G.Jr. TI1239 em 27/08/07 - chamado 2708
/// Alterado o lay-out do relatorio, incluindo o campo SITE (filial), e incluido as variaveis de controle da totalizacao
////////////
//LOCAL cabec1    := '  Fornecedor           Solicitante   Produto   PC    Emis.PC    Aprov.PC    Emis.PC x Apr.PC   NF    Vcto.NF     Valor NF   Digit.NF    Apr.PC x Dig.NF   Custo    Fiscal  C.Pagar   C.Pagar x Venc.NF    C.Pagar x Dig.NF '		// comentado por Daniel G.Jr.
//LOCAL cabec2    := '                                                                                 (dias)                                                     (dias)                                         (dias)              (dias)      '		// comentado por Daniel G.Jr.
/// Alterado por Nelson A. Pascoal em 05/05/08 - chamado 000000003175
/// Alterado o lay-out do relatorio, incluindo o campo Vencto Real e Emissao NF
//LOCAL cabec1	:= '  Fornecedor           Solicitante   Produto   PC    Emis.PC  Aprov.PC  Emis.PC x Apr.PC   NF    Vcto.NF     Valor NF   Digit.NF  Apr.PC x Dig.NF   Custo    Fiscal  C.Pagar  C.Pagar x Venc.NF  C.Pagar x Dig.NF  Site'
//LOCAL cabec2	:= '                                                                              (dias)                                                   (dias)                                       (dias)            (dias)           '
LOCAL cabec1	:= '  Fornecedor           Solicitante               Produto   PC   Emis.PC  Aprov.PC   Emis.PC         NF    Vcto.NF    Vcto.Real     Valor NF   Digit.NF  EmissaoNF  Apr.PC x Dig.NF   Custo    Fiscal    C.Pagar     Site'
LOCAL cabec2	:= '                                                                                  x Apr.PC(dias)                                                                   (dias)                                          '
LOCAL _aTotSite := {}, _aNotas := {}, _nScan := 0, _nTotQt := 0, _nTotVl := 0
LOCAL lContinua := .T.
LOCAL lImprimiu := .F.
LOCAL _cQuery   := ''
LOCAL _cFornece := ''
LOCAL _cSolicit := ''
LOCAL _dDataLib	:= CTOD('  /  /  ')
LOCAL _aParcela	:= {}
LOCAL _aUsuario	:= ALLUSERS()
LOCAL _cDia1	:= ''
LOCAL _cDia2	:= ''
LOCAL _cDia3	:= ''
LOCAL _cDia4	:= ''
LOCAL _nItem	:= 0
LOCAL _nMedia1	:= 0
LOCAL _nMedia2	:= 0
LOCAL _nMedia3	:= 0
LOCAL _nMedia4	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li     := 80
m_pag  := 1
nTipo  := IIF(aReturn[4]==1,15,18)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query com os dados a serem impressos: com informacoes de todas as filiais. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cQuery += " SELECT D1_FORNECE, D1_LOJA, C7_NUMSC, D1_PEDIDO, C7_DATPRF, D1_DOC, D1_EMISSAO, F1_VALBRUT, "
////////////
/// Alterado por Daniel G.Jr. TI1239 em 27/08/07 - chamado 2708
/// Incluido o campo F1_FILIAL
////////////
//_cQuery += " D1_DTDIGIT, F1_XCONF01, F1_XCONF02, F1_XCONF03, F1_COND, C7_EMISSAO, F1_USERLGI, D1_COD, C7_ITEMSC "		// comentado por Daniel G.Jr.
////////////
/// Alterado por Nelson A. Pascoal em 05/05/08 - chamado 000000003175
/// Incluido o campo E2_VENCREA
////////////
//_cQuery += " D1_DTDIGIT, F1_XCONF01, F1_XCONF02, F1_XCONF03, F1_COND, C7_EMISSAO, F1_USERLGI, D1_COD, C7_ITEMSC, F1_FILIAL, D1_SERIE "		// comentado por Nelson A. Pascoal
_cQuery += " D1_DTDIGIT, F1_XCONF01, F1_XCONF02, F1_XCONF03, F1_COND, C7_EMISSAO, F1_USERLGI, D1_COD, C7_ITEMSC, F1_FILIAL, E2_VENCREA "
_cQuery += " FROM "+RetSqlName('SD1')+" D1, "+RetSqlName('SC7')+" C7, "+RetSqlName('SF1')+" F1, "+RetSqlName('SE2')+" E2 "
_cQuery += " WHERE D1_PEDIDO=C7_NUM AND D1_ITEMPC=C7_ITEM AND F1_DOC=D1_DOC AND F1_FORNECE=D1_FORNECE "
_cQuery += " AND D1_LOJA=F1_LOJA AND D1_FILIAL=F1_FILIAL AND"
_cQuery += " F1_DOC=E2_NUM AND F1_FORNECE=E2_FORNECE AND F1_LOJA=E2_LOJA AND F1_EMISSAO=E2_EMISSAO AND D1_EMISSAO=E2_EMISSAO"   //By Douglas David OS 3646/13
_cQuery += " AND D1.D_E_L_E_T_='' AND C7.D_E_L_E_T_='' AND F1.D_E_L_E_T_='' AND E2.D_E_L_E_T_ = '' "
_cQuery += " AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
_cQuery += " AND D1_FORNECE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"' "
_cQuery += " AND D1_LOJA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"' "
_cQuery += " AND D1_DOC BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
_cQuery += " AND D1_PEDIDO BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
_cQuery += " AND C7_TIPO=1 "
_cQuery += " GROUP BY D1_FORNECE, D1_LOJA, C7_NUMSC, D1_PEDIDO, C7_DATPRF, D1_DOC, D1_EMISSAO, F1_VALBRUT, "
_cQuery += " D1_DTDIGIT, F1_XCONF01, F1_XCONF02, F1_XCONF03, F1_COND, C7_EMISSAO, F1_USERLGI, D1_COD, C7_ITEMSC, F1_FILIAL, E2_VENCREA "
_cQuery += " ORDER BY D1_DTDIGIT, D1_DOC, D1_FORNECE, D1_LOJA "
MEMOWRIT('RCOMR01.SQL',_cQuery)
TCQUERY _cQuery NEW ALIAS 'QRY1'
TCSETFIELD('QRY1','C7_DATPRF' ,'D',08,0)
TCSETFIELD('QRY1','D1_EMISSAO','D',08,0)
TCSETFIELD('QRY1','F1_VALBRUT','N',18,2)
TCSETFIELD('QRY1','D1_DTDIGIT','D',08,0)
TCSETFIELD('QRY1','C7_EMISSAO','D',08,0)
TCSETFIELD('QRY1','E2_VENCREA','D',08,0)
dbSelectArea('QRY1')
dbGoTop()
PROCREGUA(QRY1->(RECCOUNT()))
WHILE !EOF() .AND. lContinua
	IF lAbortPrint
		IF lImprimiu
			@ li,001 PSAY '** CANCELADO PELO OPERADOR **'
		ENDIF
		lContinua := .F.
		EXIT
	ENDIF

	INCPROC('Processando...')

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Produtos Leasing (Codigos contidos no Parametro MV_XPRLEAS) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF ALLTRIM(QRY1->D1_COD) $ GETMV('MV_XPRLEAS')
		dbSkip()
		LOOP
	ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca Ultima Data de Liberacao do Pedido de Compra. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea('SCR')
	dbSetOrder(1)	// CR_FILIAL + CR_TIPO + CR_NUM + CR_NIVEL
    dbSeek(xFilial('SCR')+'PC'+QRY1->D1_PEDIDO)
	_dDataLib := CTOD('  /  /  ')
	WHILE !EOF() .AND. ALLTRIM(xFilial('SCR')+'PC'+QRY1->D1_PEDIDO)==ALLTRIM(SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM)
		_dDataLib := SCR->CR_DATALIB
		dbSkip()
	ENDDO
	dbSelectArea('QRY1')
	IF EMPTY(_dDataLib)
		dbSkip()
		LOOP
	ENDIF
	lImprimiu := .T.
	IF li > 55
		CABEC(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca Fornecedor e Solicitante. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cFornece := SUBSTR(POSICIONE('SA2',1,xFilial('SA2')+QRY1->D1_FORNECE+QRY1->D1_LOJA,'A2_NREDUZ'),1,20)
	//////////////
	/// Alterado por Daniel G.Jr. TI1239 em 27/08/07 - chamado 2708
	/// Deixa de trazer o nome do solicitante, e passa a trazer o nome do usuario digitador
	//////////////
	//	_cSolicit := SUBSTR(POSICIONE('SC1',1,xFilial('SC1')+QRY1->C7_NUMSC+QRY1->C7_ITEMSC,'C1_SOLICIT'),1,15)			// comentado por Daniel G.Jr.
	_cSolicit := ""
	cUsu	:= QRY1->F1_USERLGI
	cCodigo := Substr(Embaralha(cUsu,1),1,15)
	_cSolicit:= UsrFullName(xRetCUsr(cCodigo))
	
	IF Empty (_cSolicit) 
		PswOrder(1)                                   
		cID:=Left(EMBARALHA(cUsu,1),15)
		cID:=ALLTRIM(substr(cID,3,6))
		_cSolicit := UsrFullName(cID)
    ENDIF                
    
	_nPos := aScan(_aUsuario,{|x|ALLTRIM(x[1][2])==ALLTRIM(_cSolicit)})
	IF _nPos > 0 .AND. _nPos < LEN(_aUsuario)
		_cSolicit := SUBSTR(ALLTRIM(_aUsuario[_nPos][1][4]),1,15)
	ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Parcelas do Titulo Gerado (Contas a Pagar). ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aParcela := CONDICAO(QRY1->F1_VALBRUT,QRY1->F1_COND,0,QRY1->D1_EMISSAO)
	IF LEN(_aParcela) < 1
		li++
	ENDIF
	FOR _nI := 1 TO LEN(_aParcela)
		IF li > 55
			CABEC(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		ENDIF
		_cDia1 := _dDataLib - QRY1->C7_EMISSAO
		_cDia2 := QRY1->D1_DTDIGIT - _dDataLib
		_cDia3 := 0
		_cDia4 := 0
		_nItem++
		IF !EMPTY(_aParcela[_nI][1]) .AND. !EMPTY(CTOD(LEFT(QRY1->F1_XCONF03,8)))
			_cDia3 := CTOD(LEFT(QRY1->F1_XCONF03,8)) - _aParcela[_nI][1]
		ENDIF
		IF !EMPTY(CTOD(LEFT(QRY1->F1_XCONF03,8))) .AND. !EMPTY(QRY1->D1_DTDIGIT)
			_cDia4 := CTOD(LEFT(QRY1->F1_XCONF03,8)) - QRY1->D1_DTDIGIT
		ENDIF
		_nMedia1 += _cDia1
		_nMedia2 += _cDia2
		_nMedia3 += _cDia3
		_nMedia4 += _cDia4
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprimindo Dados. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//'  Fornecedor           Solicitante   Produto   PC    Emis.PC  Aprov.PC  Emis.PC x Apr.PC   NF    Vcto.NF     Valor NF   Digit.NF  Apr.PC x Dig.NF   Custo    Fiscal  C.Pagar  C.Pagar x Venc.NF  C.Pagar x Dig.NF  Site'
		//'                                                                              (dias)                                                   (dias)                                       (dias)            (dias)           '
		// 12345678901234567890 123456789012345 1234567 123456 12345678  12345678       123456      123456 12345678 12345678901234 12345678      123456      12345678 12345678 12345678         123456            123456       12
		// 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		//          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
		@ li,001 PSAY ALLTRIM(_cFornece)   // By Douglas David OS 3827/13
		@ li,022 PSAY _cSolicit
		@ li,050 PSAY SUBSTR(QRY1->D1_COD,1,7)
		@ li,058 PSAY QRY1->D1_PEDIDO
		@ li,065 PSAY DTOC(QRY1->C7_EMISSAO)
		@ li,075 PSAY DTOC(_dDataLib)
		@ li,085 PSAY IIF(_cDia1==0,SPACE(6),STR(_cDia1,6,0))
		@ li,97 PSAY QRY1->D1_DOC
		@ li,107 PSAY DTOC(_aParcela[_nI][1])
		//////////////
		/// Alterado por Nelson A. Pascoal em 05/05/08 - chamado 000000003175
		/// Incluido o campo E2_VENCREA
		//////////////                                       
        /*
		@ li,106 PSAY TRANSFORM(QRY1->F1_VALBRUT,"@E 999,999,999.99")
		@ li,121 PSAY DTOC(QRY1->D1_DTDIGIT)
		@ li,135 PSAY IIF(_cDia2==0,SPACE(6),STR(_cDia2,6,0))
		@ li,147 PSAY LEFT(QRY1->F1_XCONF02,8)
		@ li,156 PSAY LEFT(QRY1->F1_XCONF01,8)
		@ li,165 PSAY LEFT(QRY1->F1_XCONF03,8)
		@ li,182 PSAY IIF(_cDia3==0,SPACE(6),STR(_cDia3,6,0))
		@ li,200 PSAY IIF(_cDia4==0,SPACE(6),STR(_cDia4,6,0))
		*/
		@ li,117 PSAY DTOC(QRY1->E2_VENCREA)
		@ li,125 PSAY TRANSFORM(QRY1->F1_VALBRUT,"@E 999,999,999.99")
		@ li,142 PSAY DTOC(QRY1->D1_DTDIGIT)
		//////////////
		/// Alterado por Nelson A. Pascoal em 05/05/08 - chamado 000000003175
		/// Incluido o campo D1_EMISSAO
		//////////////
		@ li,152 PSAY DTOC(QRY1->D1_EMISSAO)
		@ li,165 PSAY IIF(_cDia2==0,SPACE(6),STR(_cDia2,6,0))
		@ li,182 PSAY LEFT(QRY1->F1_XCONF02,8)
		@ li,192 PSAY LEFT(QRY1->F1_XCONF01,8)
		@ li,202 PSAY LEFT(QRY1->F1_XCONF03,8)
		//////////////
		/// Alterado por Daniel G.Jr. TI1239 em 27/08/07 - chamado 2708
		/// Incluido o campo F1_FILIAL
		//////////////
		@ li,214 PSAY QRY1->F1_FILIAL
		
		
		//-- Daniel Leme, 14/Jun/2013: Chamado 0579/13
		If mv_par11 == 1
			_cLinExcel := ""
			_cLinExcel += _cFornece + ";"
			_cLinExcel += _cSolicit + ";"
			_cLinExcel += SUBSTR(QRY1->D1_COD,1,7) + ";"
			_cLinExcel += QRY1->D1_PEDIDO + ";"
			_cLinExcel += DTOC(QRY1->C7_EMISSAO) + ";"
			_cLinExcel += DTOC(_dDataLib) + ";"
			_cLinExcel += IIF(_cDia1==0,SPACE(6),STR(_cDia1,6,0)) + ";"
			_cLinExcel += QRY1->D1_DOC + ";"
			_cLinExcel += DTOC(_aParcela[_nI][1]) + ";"
			_cLinExcel += DTOC(QRY1->E2_VENCREA) + ";"
			_cLinExcel += TRANSFORM(QRY1->F1_VALBRUT,"@E 999,999,999.99") + ";"
			_cLinExcel += DTOC(QRY1->D1_DTDIGIT) + ";"
			_cLinExcel += DTOC(QRY1->D1_EMISSAO) + ";"
			_cLinExcel += IIF(_cDia2==0,SPACE(6),STR(_cDia2,6,0)) + ";"
			_cLinExcel += LEFT(QRY1->F1_XCONF02,8) + ";"
			_cLinExcel += LEFT(QRY1->F1_XCONF01,8) + ";"
			_cLinExcel += LEFT(QRY1->F1_XCONF03,8) + ";"
			_cLinExcel += QRY1->F1_FILIAL + ";"
			R01Excel(_cLinExcel)
		EndIf
		li++
	NEXT _nI                          
	
	//////////////
	/// Alterado por Daniel G.Jr. TI1239 em 27/08/07 - chamado 2708
	/// Incluido o tratamento da totalizacao por site e geral, conforme solicitacao da Sra. Marcia
	//////////////                                                                                
	If aScan( _aNotas, QRY1->(D1_FORNECE+D1_LOJA+D1_DOC) ) == 0
		
		aAdd( _aNotas, QRY1->(D1_FORNECE+D1_LOJA+D1_DOC) )      
		aSort( _aNotas )
		
		_nScan := aScan( _aTotSite, {|x| x[1]==QRY1->F1_FILIAL} )
		If _nScan == 0
			aAdd( _aTotSite, { QRY1->F1_FILIAL, 1, QRY1->F1_VALBRUT } )
			aSort( _aTotSite,,, { |x,y| x[1] < y[1] } )
		Else
			_aTotSite[_nScan][2] += 1
			_aTotSite[_nScan][3] += QRY1->F1_VALBRUT
		EndIf
	EndIf

	dbSelectArea('QRY1')
	dbSkip()
ENDDO
IF lImprimiu
	li++
	If li>52
		CABEC(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
	//////////////
	/// Alterado por Nelson A. Pascoal em 05/05/08 - chamado 000000003175
	//////////////
    /*
	@ li,001 PSAY 'Total de Itens: '+ALLTRIM(STR(_nItem))
	@ li,075 PSAY TRANSFORM(_nMedia1,"@E 9,999,999")
	@ li,132 PSAY TRANSFORM(_nMedia2,"@E 9,999,999")
	@ li,179 PSAY TRANSFORM(_nMedia3,"@E 9,999,999")
	@ li,197 PSAY TRANSFORM(_nMedia4,"@E 9,999,999")
	li ++
	li ++
	@ li,001 PSAY 'Média por Item: '
	@ li,075 PSAY TRANSFORM(ROUND(_nMedia1/_nItem,0),"@E 9,999,999")
	@ li,132 PSAY TRANSFORM(ROUND(_nMedia2/_nItem,0),"@E 9,999,999")
	@ li,179 PSAY TRANSFORM(ROUND(_nMedia3/_nItem,0),"@E 9,999,999")
	@ li,197 PSAY TRANSFORM(ROUND(_nMedia4/_nItem,0),"@E 9,999,999")
	*/
	@ li,001 PSAY 'Total de Itens: '+ALLTRIM(STR(_nItem))
	@ li,075 PSAY TRANSFORM(_nMedia1,"@E 9,999,999")
	@ li,152 PSAY TRANSFORM(_nMedia2,"@E 9,999,999")
	li ++
	li ++
	@ li,001 PSAY 'Média por Item: '
	@ li,075 PSAY TRANSFORM(ROUND(_nMedia1/_nItem,0),"@E 9,999,999")
	@ li,152 PSAY TRANSFORM(ROUND(_nMedia2/_nItem,0),"@E 9,999,999")

	//////////////
	/// Alterado por Daniel G.Jr. TI1239 em 27/08/07 - chamado 2708
	/// Incluido o campo F1_FILIAL
	//////////////
	CABEC(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

	//-- Daniel Leme, 21/Jun/2013: Chamado 0579/13
	R01Excel("")
	R01Excel("")
	R01Excel("Resumo dos totais por Site:")
	R01Excel("Site;Qtd.de NFs;Valor Total")
	
	@ li,001 PSAY 'Resumo dos totais por Site:      Site    Qtd.de NFs    Valor Total'
	For _nI:=1 to Len(_aTotSite)
		li++          
		If li>55
			CABEC(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
			li+=2
			@ li,001 PSAY 'Resumo dos totais por Site:      Site    Qtd.de NFs    Valor Total'
			li++
		EndIf
		@ li,035 PSAY _aTotSite[_nI][1]
		@ li,044 PSAY TRANSFORM(_aTotSite[_nI][2],"@E 999,999")
		@ li,055 PSAY TRANSFORM(_aTotSite[_nI][3],"@E 999,999,999.99")

		_nTotQt += _aTotSite[_nI][2]
		_nTotVl += _aTotSite[_nI][3]
		
		//-- Daniel Leme, 21/Jun/2013: Chamado 0579/13
		_cLinExcel := ""
		_cLinExcel += _aTotSite[_nI][1] + ";"
		_cLinExcel += TRANSFORM(_aTotSite[_nI][2],"@E 999,999") + ";"
		_cLinExcel += TRANSFORM(_aTotSite[_nI][3],"@E 999,999,999.99") + ";"
		R01Excel(_cLinExcel)

	Next _nI
	
	li+=2          
	If li>52
		CABEC(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		li+=4
	EndIf
	@ li,001 PSAY 'Total Geral ===>>>'
	@ li,044 PSAY TRANSFORM(_nTotQt,"@E 999,999")
	@ li,055 PSAY TRANSFORM(_nTotVl,"@E 999,999,999.99")
		
	//-- Daniel Leme, 21/Jun/2013: Chamado 0579/13
	_cLinExcel := ""
	_cLinExcel += 'Total Geral ===>>>' + ";"
	_cLinExcel += TRANSFORM(_nTotQt,"@E 999,999") + ";"
	_cLinExcel += TRANSFORM(_nTotVl,"@E 999,999,999.99") + ";"
	R01Excel(_cLinExcel)
	R01Excel("",.T.) //-- Finaliza o Excel

	RODA(0,SPACE(10),'G')

ENDIF
dbSelectArea('QRY1')
dbCloseArea()
IF aReturn[5] = 1
	SET PRINTER TO
	dbCommitAll()
	OURSPOOL(wnrel)
ENDIF
MS_FLUSH()
RETURN(.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ xRetCUsr º Autor ³ Leonardo Soncin    º Data ³  09/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna Codigo do Usuario                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico - CSU                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
  
// Retorna Codigo de Usuario
Static Function xRetCUsr(cCodigo)
Local cAlias := Alias()
Local cSavOrd := IndexOrd()
Local cCodUser := CriaVar("AN_USER")
Local cUsux := cCodigo 
// OS 1017-12
PswOrder(2)
If PswSeek(cUsux)
	cCodUser := PswRet(1)[1][1]
Else
	PswOrder(1)                                   
	If PswSeek(ALLTRIM(substr(cUsux,3,6)))
		cCodUser := PswRet(1)[1][1]
	EndIf	
EndIf
// FIM OS 1017-12          
cCodUser := cCodUser            

dbSelectArea(cAlias)
dbSetOrder(cSavOrd)

Return cCodUser

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_FCriaSx1 ºAutor  ³Renato Lucena Neves º Data ³  14/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para criacao das perguntas.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8- CSU                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION _FCriaSx1()
SX1->(dbSetOrder(1))
IF !SX1->(dbSeek(cPerg+"01",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Digitação de"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 08
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := ""
	MsUnLock()
ENDIF
IF !SX1->(dbSeek(cPerg+"02",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Digitação até"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 08
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := ""
	MsUnLock()
ENDIF
IF !SX1->(dbSeek(cPerg+"03",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Fornecedor de"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SA2"
	MsUnLock()
ENDIF
IF !SX1->(dbSeek(cPerg+"04",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Loja de"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 02
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := ""
	MsUnLock()
ENDIF
IF !SX1->(dbSeek(cPerg+"05",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Fornecedor até"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SA2"
	MsUnLock()
ENDIF
IF !SX1->(dbSeek(cPerg+"06",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Loja até"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 02
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par06"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := ""
	MsUnLock()
ENDIF
IF !SX1->(dbSeek(cPerg+"07",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Nota de"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par07"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SF1"
	MsUnLock()
ENDIF
IF !SX1->(dbSeek(cPerg+"08",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "08"
	SX1->X1_PERGUNT := "Nota até"
	SX1->X1_VARIAVL := "mv_ch8"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par08"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SF1"
	MsUnLock()
ENDIF
IF !SX1->(dbSeek(cPerg+"09",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "09"
	SX1->X1_PERGUNT := "Pedido de"
	SX1->X1_VARIAVL := "mv_ch9"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par09"
	SX1->X1_DEF01   := ""
	SX1->X1_DEF02   := ""
	SX1->X1_F3		 := "SC7"
	MsUnLock()
ENDIF
IF !SX1->(dbSeek(cPerg+"10",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "10"
	SX1->X1_PERGUNT := "Pedido até"
	SX1->X1_VARIAVL := "mv_cha"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par10"
	SX1->X1_DEF01   := ""
	SX1->X1_DEF02   := ""
	SX1->X1_F3		:= "SC7"
	MsUnLock()
ENDIF
//-- Daniel Leme, 14/Jun/2013: Chamado 0579/13
IF !SX1->(dbSeek(cPerg+"11",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "11"
	SX1->X1_PERGUNT := "Gera Excel?"
	SX1->X1_VARIAVL := "mv_cha"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 01
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "C"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par11"
	SX1->X1_DEF01   := "Sim"
	SX1->X1_DEF02   := "Não"
	SX1->X1_F3		:= ""
	MsUnLock()
ENDIF

RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ R01Excel ºAutor  ³ Daniel Leme        º Data ³  14/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para gravacao em Excel.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R01Excel(cLinExcel,lFim)

Local oExcelApp, cLin
Local cDirDocs	:= MsDocPath()
Local cTempPath	:= Alltrim(GetTempPath())

Static cArquivo
Static nHdl

Default lFim := .F.

If !lFim .And. cArquivo == Nil
	cArquivo	:= CriaTrab(,.F.)
	nHdl := fCreate(cDirDocs+"\"+cArquivo+".csv")
	If nHdl = -1
		MsgStop(OemToAnsi("Não foi possivel criar o arquivo. Verifique os direitos de gravação !"))
		Return
	Endif
	//Msgalert("criou " + cArquivo)
	cLin := "Relatorio: Relatório de Acompanhamento de Processo" + CRLF
	fWrite(nHdl,cLin,Len(cLin))
	cLin := 'Fornecedor;Solicitante;Produto;PC;Emis.PC;Aprov.PC;Emis.PC;NF;Vcto.NF;Vcto.Real;Valor NF;Digit.NF; Emissao NF; Apr.PC x Dig.NF; Custo; Fiscal; C.Pagar; Site' + CRLF
	fWrite(nHdl,cLin,Len(cLin))
EndIf

If !lFim .And. nHdl != Nil .And. nHdl > 0
	cLin := cLinExcel + CRLF
	fWrite(nHdl,cLin,Len(cLin))
EndIf

If lFim .And. nHdl != Nil .And. nHdl > 0
	fClose(nHdl)
	//Msgalert("fechou " + cArquivo)
	CpyS2T(cDirDocs+"\"+cArquivo+".csv",cTempPath,.T.)
	
	If !ApOleClient("MsExcel")
		MsgStop(OemToAnsi("MsExcel não instalado"))
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cTempPath+cArquivo+".csv")
	oExcelApp:SetVisible(.T.)
	cArquivo := Nil
EndIf
Return Nil
