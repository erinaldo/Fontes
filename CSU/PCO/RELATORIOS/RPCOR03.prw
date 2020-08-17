///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | RPCOR03.prw      | AUTOR | Fernando Garrigos| DATA | 06/02/2007 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - RPCOR03()                                              |//
//|           | Relatório em SQL para demonstração dos Lanctos do PCO	        |//
//|           |                                                                 |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

User Function RPCOR03()

//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------

Local cDesc1  := "Este relatorio ira imprimir infomacoes referentes aos Bloqueios - CQ"
Local cDesc2  := "conforme parametros informado pelo usuario"
Local cDesc3  := ""

Private cString  := "AK2"
Private Tamanho  := "G"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "RPCOR03"
Private NomeProg := "RPCOR03"
Private nLastKey := 0
Private Limite   := 190
Private Titulo   := "Lançamentos do PCO"
Private cPerg    := PADR("RPCO03",LEN(SX1->X1_GRUPO))
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Cabec1   := ""
Private Cabec2   := ""
Private Li       := 80
Private m_pag    := 1
Private aOrd     := {}
//                             1         2         3         4         5         6         7         8         9        10        11
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//Private Cabec1   := "  FORNECEDOR                                                                 VLR. ORIGINAL              PAGO               SALDO  "
Private Cabec2   := "  C.Custo    Desc. C.Custo                   Cta Orcament.    Desc. Cta Orcament.             Tp  D/C   Data                  Crédito                     Débito         Historico"
Private Cabec3   := ""

#IFNDEF TOP
	MsgInfo("Não é possível executar este programa, está base de dados não é TopConnect","Incompatibilidade")
	RETURN
#ENDIF


/*+----------------------
| Parametros do aReturn
+----------------------
aReturn - Preenchido pelo SetPrint()
aReturn[1] - Reservado para formulario
aReturn[2] - Reservado para numero de vias
aReturn[3] - Destinatario
aReturn[4] - Formato 1=Comprimido 2=Normal
aReturn[5] - Midia 1-Disco 2=Impressora
aReturn[6] - Prota ou arquivo 1-Lpt1... 4-Com1...
CReturn[7] - Expressao do filtro
aReturn[8] - Ordem a ser selecionada
aReturn[9] [10] [n] - Campos a processar se houver
*/

//Parametros de perguntas para o relatorio
//+-------------------------------------------------------------+
//| mv_par01 - Produto de         ? ZZZZZZ                      |
//| mv_par02 - Produto ate        ? ZZZZZZ                      |
//| mv_par03 - Almoxarifado de    ? XX                          |
//| mv_par04 - Almoxarifado ate   ? XX                          |
//+-------------------------------------------------------------+

//+-------------------------------------------------------------------------------
//| Disponibiliza para usuario digitar os parametros
//+-------------------------------------------------------------------------------

AjustaSx1() //Ajusta o SX1 se necessário

Pergunte(cPerg,.F.)

//+-------------------------------------------------------------------------------
//| Solicita ao usuario a parametrizacao do relatorio.
//+-------------------------------------------------------------------------------
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,.F.,.F.)
//SetPrint(cAlias,cNome,cPerg,cDesc,cCnt1,cCnt2,cCnt3,lDic,aOrd,lCompres,;
//cSize,aFilter,lFiltro,lCrystal,cNameDrv,lNoAsk,lServer,cPortToPrint)

//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
	Return
Endif

//+-------------------------------------------------------------------------------
//| Estabelece os padroes para impressao, conforme escolha do usuario
//+-------------------------------------------------------------------------------
SetDefault(aReturn,cString)

//+-------------------------------------------------------------------------------
//| Verificar se sera reduzido ou normal
//+-------------------------------------------------------------------------------
nTipo := Iif(aReturn[4] == 1, 15, 18)

//+-------------------------------------------------------------------------------
//| Se teclar ESC, sair
//+-------------------------------------------------------------------------------
If nLastKey == 27
	Return
Endif

//+-------------------------------------------------------------------------------
//| Chama funcao que processa os dados
//+-------------------------------------------------------------------------------
RptStatus({|lEnd| RelSQLImp(@lEnd, wnrel, cString) }, "Aguarde...", "Processando registros...", .T. )

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | RESTR08.prw  | AUTOR | Fernando J. Garrigos | DATA | 24/05/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - RESTR08()                                              |//
//|           | 												                |//
//|           | Funcao de impressao                                             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function RelSQLImp(lEnd,wnrel,cString)
Local cFilSB1   := xFilial(cString)
Local cQuery    := ""
Local aCol      := {}
Local nCount	:= 0
Local nValor	:= 0
Local _ValCred	:= 0
Local _ValDeb	:= 0
Local nValCred	:= 0
Local nValDeb	:= 0
Local nValCredCO	:= 0
Local nValDebCO 	:= 0
Local nValCredCC 	:= 0
Local nValDebCC 	:= 0
Local cDC		:= ""
Local _CC		:= ""
Local _CO		:= ""
Local _DescCC	:= ""
Local _DescCO	:= ""



//+-----------------------
//| Cria filtro temporario
//+-----------------------


cQuery	:=	" SELECT DISTINCT AKD_CODPLA AS CODPLA, AKD_CO AS CO, AK5_DESCRI AS DESCCO, AKD_HIST AS HIST,  "
cQuery	+=	" AKD_DATA AS DT, AKD_VALOR1 AS VALOR, AKD_CC AS CC, CTT_DESC01 AS DESCCC, AKD_TPSALD AS TPSALD,  "
cQuery	+=	" AKD_TIPO AS DC  "
cQuery	+=	" FROM "+RetSqlName("AKD")+" AKD,"
cQuery	+=	" "+RetSqlName("AK5")+" AK5, "
cQuery	+=	" "+RetSqlName("CTT")+" CTT "
cQuery	+=	" WHERE AKD_FILIAL = '"+xFilial("AKD")+"' AND "
cQuery	+=	" AK5_FILIAL = '"+xFilial("AKD")+"' AND "
cQuery	+=	" CTT_FILIAL = '"+xFilial("AKD")+"' AND "
cQuery	+=	" AKD_CC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
cQuery	+=	" AKD_TPSALD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
cQuery  +=  " AKD_DATA >= '" + DTOS(mv_par05) + " ' AND "
cQuery  +=  " AKD_DATA <= '" + DTOS(mv_par06) + " ' AND "
cQuery  +=  " AKD_CO >= '" + ALLTRIM(mv_par07) + " ' AND "
cQuery  +=  " AKD_CO <= '" + ALLTRIM(mv_par08) + " ' AND "
cQuery	+=	" AKD_CO = AK5_CODIGO AND AKD_CC = CTT_CUSTO AND AKD_STATUS <> '2' AND "
cQuery	+=	" CTT.D_E_L_E_T_ = '' AND AK5.D_E_L_E_T_ = ''  AND CTT.D_E_L_E_T_ = '' "
cQuery	+=	" ORDER BY AKD_CC, AKD_CO "

//+-----------------------
//| Cria uma view no banco
//+-----------------------
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .F. )
dbSelectArea("TRB")
dbGoTop()
SetRegua( RecCount() )

//+--------------------
//| Coluna de impressao
//+--------------------
aAdd( aCol, 001 ) //Centro de Custo
aAdd( aCol, 013 ) //Desc.CC
aAdd( aCol, 045 ) //Cta Orcamentária
aAdd( aCol, 062 ) //Desc Cta
aAdd( aCol, 095 ) //Tipo de Saldo
aAdd( aCol, 100 ) //Débito / Crédito
aAdd( aCol, 105 ) //Data
aAdd( aCol, 120 ) //Valor Débito
aAdd( aCol, 145 ) //Valor Crédito
aAdd( aCol, 170 ) //Histórico


While !Eof() .And. !lEnd
	IncRegua()
	
	If Li > 55
		Cabec(Titulo,Cabec2,Cabec3,NomeProg,Tamanho,nTipo)
	Endif
	
	If TRB->DC = "1"
		_cDC = "C"
		_ValCred = TRB->VALOR
	Elseif TRB->DC = "2"
		_cDC = "D"
		_ValDeb = TRB->VALOR
	Else
		_cDC = "E"
	Endif
	
	// IMPRESSAO DE DADOS DO RELATORIO
	@ Li, aCol[1]  PSay TRB->CC
	@ Li, aCol[2]  PSay SUBSTR(TRB->DESCCC,1,30)
	@ Li, aCol[3]  PSay TRB->CO
	@ Li, aCol[4]  PSay SUBSTR(TRB->DESCCO,1,30)
	@ Li, aCol[5]  PSay TRB->TPSALD
	@ Li, aCol[6]  PSay _cDC
	@ Li, aCol[7]  PSay DTOC(STOD(TRB->DT))
	@ Li, aCol[8]  PSay _ValCred Picture "@E 999,999,999.99"
	@ Li, aCol[9]  PSay _ValDeb  Picture "@E 999,999,999.99"
	@ Li, aCol[10] PSay SUBSTR(TRB->HIST,1,40)
	
	Li ++
	nCount 	 := nCount + 1
	nValor 	 := nValor+TRB->VALOR
	nValDeb  := nValDeb + _ValDeb
	nValCred := nValCred + _ValCred
	nValDebCO  := nValDebCO + _ValDeb
	nValCredCO := nValCredCO + _ValCred
	nValDebCC  := nValDebCC + _ValDeb
	nValCredCC := nValCredCC + _ValCred
	_ValDeb	 := 0
	_ValCred := 0
	_CC		 := TRB->CC
	_CO		 := TRB->CO
	_DescCC	 := TRB->DESCCC
	_DescCO	 := TRB->DESCCO
	
	dbSkip()
	
	
	//Totalização da Conta Orçamentária
	IF TRB->CO <> _CO
		
//		Li ++
//		@ Li, 000 PSay Replicate("-",Limite)
		Li ++
		@ Li, aCol[2]  PSay "Total da Conta: " + _CO + " - " + _DescCO
		//@ Li, 021  PSay nCount
		//@ Li, 041  PSay nValor Picture "@E 999,999,999.99"
		@ Li, aCol[8]  PSay nValCredCO Picture "@E 999,999,999.99"
		@ Li, aCol[9]  PSay nValDebCO  Picture "@E 999,999,999.99"
		nValDebCO := 0
		nValCredCO := 0
		Li ++
		Li ++
		
	Endif
	
	//Totalização do Centro de Custo
	IF TRB->CC <> _CC
		
//		Li ++
//		@ Li, 000 PSay Replicate("-",Limite)
//		Li ++
		@ Li, aCol[2]  PSay "Total da CC: " + _CC + " - " + _DescCC
		//@ Li, 021  PSay nCount
		//@ Li, 041  PSay nValor Picture "@E 999,999,999.99"
		@ Li, aCol[8]  PSay nValCredCC Picture "@E 999,999,999.99"
		@ Li, aCol[9]  PSay nValDebCC  Picture "@E 999,999,999.99"
		nValDebCC := 0
		nValCredCC := 0
		Li ++
		@ Li, 000 PSay Replicate("-",Limite)
		Li ++
		
	Endif
	
End


If lEnd
	@ Li, aCol[1] PSay cCancel
	Return
Endif
Li ++
@ Li, 000 PSay Replicate("=",Limite)
Li ++
Li ++
@ Li, aCol[1]  PSay "Total de Geral: "
@ Li, 021  PSay nCount
@ Li, 041  PSay nValor Picture "@E 999,999,999.99"
@ Li, aCol[8]  PSay nValCred Picture "@E 999,999,999.99"
@ Li, aCol[9]  PSay nValDeb  Picture "@E 999,999,999.99"

If Li <> 80
	Roda(cbCont,cbTxt,Tamanho)
Endif

dbSelectArea("TRB")
dbCloseArea()

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
EndIf

Ms_Flush()

Return

Return Nil

//Atualização do SX1

Static Function AjustaSX1()
Local aHelpP01	:= {}
Local aHelpE01	:= {}
Local aHelpS01	:= {}
DbSelectArea('SX1')


PutSx1('RPCO03','01','CC Inicial?','De Usuario?','De Usuario?','mv_ch1','C'   , 10, 0, 0,'G','','CTT'   ,'','','mv_par01','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO03','02','CC Final?','Ate Usuario?','Ate Usuario?','mv_ch2','C', 10, 0, 0,'G','','CTT'   ,'','','mv_par02','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO03','03','Tp Saldo Ini?','De Usuario?','De Usuario?','mv_ch3','C'   , 02, 0, 0,'G','',''   ,'','','mv_par03','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO03','04','Tp Saldo Fim?','Ate Usuario?','Ate Usuario?','mv_ch4','C', 02, 0, 0,'G','',''   ,'','','mv_par04','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO03','05','Dt Inicial?','De Usuario?','De Usuario?','mv_ch5','D'   , 08, 0, 0,'G','',''   ,'','','mv_par05','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO03','06','Dt Final?','Ate Usuario?','Ate Usuario?','mv_ch6','D', 08, 0, 0,'G','',''   ,'','','mv_par06','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO03','07','CO Inicial?','De Usuario?','De Usuario?','mv_ch7','C'   , 20, 0, 0,'G','','AK5'   ,'','','mv_par07','','','','','','','','','','','','','','','','','','','')
PutSx1('RPCO03','08','CO Final?','Ate Usuario?','Ate Usuario?','mv_ch8','C', 20, 0, 0,'G','','AK5'   ,'','','mv_par08','','','','','','','','','','','','','','','','','','','')

Return .T.
