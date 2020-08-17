#Include 'Rwmake.ch'
#include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120GOK  ºAutor  ³ Sergio Oliveira    º Data ³  Out/2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada apos a atualizacao da base de dados no    º±±
±±º          ³pedido de compras para gerar a alcada de aprovacao.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Verificar o funcionamento com o SAL mascarado em 03/set

User Function MT120GOK()

Private _aAreaAnt := GetArea()

If AllTrim(Upper(FunName())) == "RIMPA081" //Nao utilizar a tratativa se for oriunda da importação Marketsystem
	Return()
EndIf
/*
If AllTrim(Upper(FunName())) $ 'MATA160/MATA130' //Nao utilizar a tratativa se for oriunda de Cotação
	Return()
EndIf
*/
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Caso o pedido de compra esteja sendo gerado via Analise de Cotacao, fazer o desvio apropriadamente.   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If FunName() $ 'MATA160' // Somente se vier de cotacao
	
	cSelect := " SELECT DISTINCT C8_NUMPED "
	cSelect += " FROM "+RetSqlName("SC8")
	cSelect += " WHERE C8_FILIAL = '"+xFilial('SC8')+"' "
	cSelect += " AND   C8_NUM    = '"+SC7->C7_NUMCOT+"' "
	cSelect += " AND   D_E_L_E_T_ = ' ' "
	
	U_MontaView( cSelect, "MT120" )
	
	// Em seguida, executar o Mt120Gok() para cada pedido em separado:
	
	DbSelectArea("MT120")
	DbGoTop()
	While !Eof()
		
		DbSelectArea("SC7")
		DbSetOrder(1)
		If DbSeek(xFilial("SC7")+MT120->C8_NUMPED)
			U_Mt120G2()
			U_ProvPCInc()    //OS 1001/16 - Douglas David
		EndIf
		
		DbSelectArea("MT120")
		DbSkip()
		
	EndDo
	
Else
	
	If FunName() $ 'MATA121/MATA122'
		SC7->( DbSetOrder(1) )
		SC7->( DbSeek( xFilial('SC7')+cA120Num ) )
	EndIf
	
	U_Mt120G2()
	U_ProvPCInc() // OS 1001/16 - Douglas David
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Funcao   ³MT120G2   ºAutor  ³ Sergio Oliveira    º Data ³  Ago/2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento do ponto de entrada.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mt120Gok.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Mt120G2()

Local _cVerifica 	:= "", cDestroi, cAliasT, lGeraProc
Local _lLiber    	:= .t.
Local _cSelect 	:= '', _cExec := '', _cStatus := '02', _cTrab := CriaTrab( Nil,.f. )
Local _nAlcAnt 	:= 0
Local _nNivel  	:= 1
Local _lPreap 	 	:= .f., _lUltimo := .f., _nVoltaSAL := .t.
Local lYesZA6		:= .T.

Local _lErro		:= .F.,lDelSCR := .f., _lApSol := .f.
Local _cLaudo		:= ""
Local _cMsgErr		:= ""
Local _cEol 		:= Chr(13)+Chr(10)
Local aUser			:= {}

Local _cSeekZA6	:= ""
Local cSolicit      := "", cSelPrj := ""
Local _nRecSAL		:= 0
Local _aCadAprov	:= {}
Local cNextAlias    := GetNextAlias()
Local aNivs    := {}
Local aAntFin  := {}
Local _lTemGApr   := .F.
Local _aGrupos    := {}
Local _cGrupoCC   := ""
//Local lDelete		:= ParamIxb[4] //OS 3677/16 - Eduardo Dias
Local lDelete		:= IIF(Funname()=="RCOMM99","",ParamIxb[4]) //OS 0748/17 - Douglas
Private _lJa02    := .f.
Private cRtTable  := IIF( Select('SCRCLONE') > 0, cArqPre, RetSqlName('SCR') )
Private cRtAlias  := IIF( Select('SCRCLONE') > 0, "SCRCLONE", "SCR" )
Private cRtSAL    := IIF( Select('SCRCLONE') > 0, "Work", "SAL" )
Private _lSolicit := .f., _lCapex := .f., _lProjeto := .f.
Private nPididu   := FCreate( '\workflow\'+AllTrim(SC7->C7_FILIAL)+SC7->C7_NUM+'-'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log',1 )
Private cPididu   := 'Inicio do logo do Pedido '+AllTrim(SC7->C7_FILIAL)+'/'+SC7->C7_NUM
Private cEol      := Chr(13)+Chr(10), xAprosu := '', xAprov := ''
Private aAprovs   := {}
Private __cDescPrd := '', __cNomFor := '', __cSolicit := '', __cCCDesc := ''
Private _cAprovPres := " "
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Gerar o log para possibilitar o rastreamento detalhado do Pedido em funcao do alto grau de complexi-  ³
³ dade da politica de geracao de alcadas.                                                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
FWrite( nPididu, "Usuario logado: ["+__cUserId+"] - "+Trim(UsrFullName(__cUserId))+' - Programa de origem: '+FunName()+' - Estação: '+GetComputerName()+' - Hora: '+Time()+cEol )
FWrite( nPididu, cPididu+cEol )

Private _cGrupo   := ''
Private _aUser	  := {}
Private _aAreaSC7 := SC7->(GetArea())
Private _cNivelSol	:= ""
Private _aAprov 	 	:= {}
Private _lxAprov
Private _nAlcAnt
Private aStats   := {}  // Sergio em Mai/2007: (Ajuste) - Inicio
Private aAprovs       := {}
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Solicitado pela CSU um paliativo para quando o modulo Gestao de Contratos estiver inoperante.         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If GetMv("MV_GCTON") == "N"
	U_CONTRAX()
EndIf
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Tratamento especial para a geracao do codigo do projeto em cada Pedido para possibilitar o rastrea-   ³
³ mento:                                                                                                ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If !FunName() $ 'CNTA120'
	
	cSelPrj := " SELECT SC7.R_E_C_N_O_ AS REGS, C1_X_PRJ, C1_X_ITPRJ FROM "+RetSqlName('SC7')+" SC7, "+RetSqlName('SC1')+" SC1 "  // Tatiana A. Barbosa - OS 1262/11 - 08/06/11 - Incluida a seleção do campo C1_X_ITPRJ da SC.
	cSelPrj += " WHERE C7_FILIAL = '"+xFilial('SC7')+"' "
	cSelPrj += " AND     C7_NUM    = '"+SC7->C7_NUM+"' "
	cSelPrj += " AND     C7_NUMSC  <> ' ' "
	cSelPrj += " AND     C7_X_PRJ  = ' ' "
	cSelPrj += " AND     SC7.D_E_L_E_T_ = ' ' "
	cSelPrj += " AND     C1_FILIAL = '"+xFilial('SC1')+"' "
	cSelPrj += " AND     C1_NUM    = C7_NUMSC "
	cSelPrj += " AND     C1_ITEM   = C7_ITEMSC "
	cSelPrj += " AND     C1_X_PRJ  <> ' ' "
	cSelPrj += " AND     SC1.D_E_L_E_T_ = ' ' "
	
	U_MontaView( cSelPrj, "xWork" )
	
	xWork->( DbGoTop() )
	
	While !xWork->( Eof() )
		
		FWrite( nPididu, "Gravando o nro. de projeto para o pedido(SIGACOM)"+cEol )
		
		TcSqlExec( "UPDATE "+RetSqlName('SC7')+" SET C7_X_PRJ = '"+xWork->C1_X_PRJ+"', C7_X_ITPRJ = '"+xWork->C1_X_ITPRJ+"' WHERE R_E_C_N_O_ = "+Str( xWork->REGS ) ) // Tatiana A. Barbosa - OS 1262/11 - 08/06/11 - Incluida a gravacao do campo C7_X_ITPRJ atraves da SC.
		
		xWork->( DbSkip() )
		
	EndDo
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Gravar tambem a origem de acordo com a Solicitacao de Compras (quando houver SC).                     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	cSelPrj := " SELECT SC7.R_E_C_N_O_ AS REGS, C1_X_CAPEX FROM "+RetSqlName('SC7')+" SC7, "+RetSqlName('SC1')+" SC1 "
	cSelPrj += " WHERE C7_FILIAL   = '"+xFilial('SC7')+"' "
	cSelPrj += " AND     C7_NUM    = '"+SC7->C7_NUM+"' "
	cSelPrj += " AND     C7_NUMSC  <> ' ' "
	cSelPrj += " AND     C7_X_CAPEX = ' ' "
	cSelPrj += " AND     SC7.D_E_L_E_T_ = ' ' "
	cSelPrj += " AND     C1_FILIAL = '"+xFilial('SC1')+"' "
	cSelPrj += " AND     C1_NUM    = C7_NUMSC "
	cSelPrj += " AND     C1_ITEM   = C7_ITEMSC "
	cSelPrj += " AND     C1_X_CAPEX <> ' ' "
	cSelPrj += " AND     SC1.D_E_L_E_T_ = ' ' "
	
	U_MontaView( cSelPrj, "xWork" )
	
	xWork->( DbGoTop() )
	
	While !xWork->( Eof() )
		
		FWrite( nPididu, "Gravando a origem para o pedido(SIGACOM)"+cEol )
		
		TcSqlExec( "UPDATE "+RetSqlName('SC7')+" SET C7_X_CAPEX = '"+xWork->C1_X_CAPEX+"' WHERE R_E_C_N_O_ = "+Str( xWork->REGS ) )
		
		xWork->( DbSkip() )
		
	EndDo	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Sergio em Jun/2010: Para atender a OS 0248/10 sera necessario gravar a data de entrega em branco para  ³
	³                     as situacoes onde a area de Procurement ira fazer a compra do produto, ou seja,    ³
	³                     quando o campo de "Grupo de Compras" nao estiver em branco.                        ³
	³                     Importante: Executar somente se este ponto de entrada tiver sido acionado atraves  ³
	³                                 rotina de manutencao dos grupos de aprovacao.                          ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	/*
	If !"RCOMM99" $ FunName()
		FWrite( nPididu, "Gravando a data de entrega em branco caso o Pedido seja referente a uma Compra a ser realizada."+cEol )
		cDatPRF := " UPDATE "+RetSqlName('SC7')+" SET C7_DATPRF = '        ' "
		cDatPRF += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
		cDatPRF += " AND   C7_NUM     = '"+SC7->C7_NUM+"' "
		cDatPRF += " AND   C7_GRUPCOM <> '      ' "
		cDatPRF += " AND   D_E_L_E_T_ = ' ' "
		
		TcSqlExec( cDatPRF )
		FWrite( nPididu, "Fim da gravacao."+cEol )
	Else
		FWrite( nPididu, "Não será gravada a data de entrega em branco porque este ponto de entrada esta sendo executado atraves da rotina de alteracao dos grupos de aprovacao."+cEol )
	EndIf
	*/
Else
	
	If !Empty( CND->CND_X_PRJ )
		FWrite( nPididu, "Gravando o nro. de projeto e a origem para o pedido(SIGAGCT)"+cEol )
		//cExec := " UPDATE "+RetSqlName('SC7')+" SET C7_X_PRJ = '"+CND->CND_X_PRJ+"', C7_X_CAPEX = 'CONTRATO' "
		cExec := " UPDATE "+RetSqlName('SC7')+" SET C7_X_PRJ = '"+CND->CND_X_PRJ+"', C7_X_CAPEX = 'SGC@' "// OS 0102/10
		cExec += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
		cExec += " AND   C7_NUM     = '"+SC7->C7_NUM+"' "
		cExec += " AND   D_E_L_E_T_ = ' ' "
		TcSqlExec( cExec )
	Else
		FWrite( nPididu, "Gravando a origem para o pedido(SIGAGCT)"+cEol )
		//	cExec := " UPDATE "+RetSqlName('SC7')+" SET C7_X_CAPEX = 'CONTRATO' "
		cExec := " UPDATE "+RetSqlName('SC7')+" SET C7_X_CAPEX = 'SGC@' "   // OS 0102/10
		cExec += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
		cExec += " AND   C7_NUM     = '"+SC7->C7_NUM+"' "
		cExec += " AND   D_E_L_E_T_ = ' ' "
		TcSqlExec( cExec )
		
	EndIf
	
EndIf
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ A verificacao da origem determinara o correto tratamento na geracao das alcadas de aprovacao.         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If FunName() $ 'MATA121/MATA122/CNTA120'
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Limpar o controle de alcadas anterior no caso de exclusao do PC.                                      ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If ( FunName() $ 'MATA121/CNTA120' ) .And. lDelete // !Inclui .And. !Altera - OS 3677/16 Edu 20/12/16
		
		FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - deletando a alçada para o PC."+cEol )
		_cExec := " DELETE FROM "+cRtTable
		_cExec += " WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
		_cExec += " AND   CR_TIPO   = 'PC' "
		_cExec += " AND   CR_NUM    = '"+cA120Num+"' "
		_cExec += " AND   D_E_L_E_T_ = ' ' "
		
		TcSqlExec( _cExec )
		                                       
		RestArea(_aAreaAnt)
		Fclose( nPididu )
		Return
		
	EndIf
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Para autorizacoes de entrega nao ha controle de aprovacao de Pedidos.                                 ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If 'MATA122' $ FunName()
		
		If SC7->C7_TIPO == 2
			
			_cExec := " DELETE FROM "+cRtTable
			_cExec += " WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
			_cExec += " AND   CR_TIPO   = 'AE' "
			_cExec += " AND   CR_NUM    = '"+SC7->C7_NUM+"' "
			_cExec += " AND   D_E_L_E_T_ = ' ' "
			
			TcSqlExec( _cExec )
			
			U_LiberaSC7(2,.t.)
			
			SC7->(RestArea(_aAreaSC7))
			RestArea(_aAreaAnt)
			
			Fclose( nPididu )
			
			Return
			
		EndIf
		
	EndIf
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ O usuario que alterar o PC nao devera assumir a gestao do mesmo. Para possibilitar este controle, foi ³
	³ criada a variavel _cUsrGst criada no ponto de entrada MT120Alt.prw:                                   ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If Altera
		If Type( '_cUsrGst' ) == 'C'
			_cExec := " UPDATE "+RetSqlName('SC7')+" SET C7_USER = '"+_cUsrGst+"' "
			_cExec += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
			_cExec += " AND   C7_NUM     = '"+cA120Num+"' "
			_cExec += " AND   D_E_L_E_T_ = ' ' "
			TcSqlExec( _cExec )
		Else
			cAssunto := "Necessidade de compilacao de programa: MT120ALT.PRW "
			cTitulo  := "Necessidade de compilacao de programa: MT120ALT.PRW "
			cDetalhe := "O sistema detectou que o ponto de entrada MT120ALT.PRW nao foi compilado."
			cDetalhe += "O programa MT120GOK.PRW necessida que este ponto de entrada esteja compilado."
			U_Rcomw06( cAssunto, cTitulo, cDetalhe, __cUserId )
		EndIf
	EndIf
	
	DbSelectArea('SC7')
	DbSetOrder(1)
	DbSeek(xFilial('SC7')+cA120Num)
	
EndIf
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Colocar em uso todas as tabelas relacionadas a geracao das alcadas.                                   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If Select('SAK') == 0
	ChkFile('SAK')
EndIf
If Select('SAL') == 0
	ChkFile('SAL')
EndIf
If Select('ZA6') == 0
	ChkFile('ZA6')
EndIf
If Select('SZI') == 0
	ChkFile('SZI')
EndIf
If Select('ZA8') == 0
	ChkFile('ZA8')
EndIf

(cRtSAL)->( DbSetOrder(2) )
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Limpar o controle de alcadas anterior.                                                                ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
_cExec := " DELETE FROM "+cRtTable
_cExec += " WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
_cExec += " AND   CR_TIPO   = 'PC' "
_cExec += " AND   CR_NUM    = '"+SC7->C7_NUM+"' "
_cExec += " AND   D_E_L_E_T_ = ' ' "

TcSqlExec( _cExec )
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Limpar o controle de alcadas anterior.                                                                ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
_cSelect := " SELECT SUM(C7_TOTAL+C7_VALIPI+C7_SEGURO+C7_DESPESA+C7_VALFRE) - SUM(C7_VLDESC) VALPED "
_cSelect += "   FROM "+RetSqlName('SC7')
_cSelect += "   WHERE C7_FILIAL = '"+xFilial('SC7')+"' "
_cSelect += "   AND   C7_NUM    = '"+SC7->C7_NUM+"' "
_cSelect += "   AND   D_E_L_E_T_ = ' ' "

U_MontaView( _cSelect, "TOTPED" )

TOTPED->(DbGoTop())
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Para pedidos de compras provenientes de medicao de contratos, marcar o campo de contrato              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If FunName() $ 'CNTA120'
	FWrite( nPididu, "Este pedido esta sendo gerado atraves de uma medicao"+cEol )
	SC7->( RecLock("SC7",.F.) )
	SC7->C7_CONTRA := CND->CND_CONTRA
	SC7->C7_XCONTRA := SC7->C7_CONTRA
	SC7->( MsUnlock() )
	U_TrazCCUn()
EndIf
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Tratamento especial para obter os aprovadores para o PC                                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
If Empty( SC7->C7_CONTRA )
	
	FWrite( nPididu, "Este pedido nao possui medicao"+cEol )
	
	If Empty( SC7->C7_NUMSC )
		
		FWrite( nPididu, "Este pedido NAO POSSUI Solicitacao de Compras. Sera exibida a tela de selecao do usuario."+cEol )
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Se nao existir SC relacionada ao PC, exibir a tela de escolha para que o solicitante possa determinar ³
		³ o Centro de Custo para aprovacao do PC. Mas se este ponto de entrada estiver sendo executado atraves  ³
		³ da rotina de manutencao dos grupos de aprovacao pelo Excel, utilizar os campos C7_X_CCAP e C7_X_USRA  ³
		³ para nao precisar exibir a tela durante o processamento.                                              ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If "RCOMM99" $ FunName() .Or. AllTrim(Upper(FunName())) == "RIMPA081"   // Se estiver vindo da rotina de troca de grupos ou improtação multi-catalogo, nao dar tela, pegar o escolhido previamente
			If !Empty( SC7->C7_X_USRA )
				PswOrder(2) // Ordem de nome do usuario
				PswSeek( SC7->C7_X_USRA )
				aAdd( _aUser,{ PswId(),SC7->C7_X_CCAP,SC7->C7_X_USRA } )
			ElseIf AllTrim(Upper(FunName())) == "RIMPA081"
				PswOrder(2) // Ordem de nome do usuario
				PswSeek( Alltrim(aItens[1,15,2]) )
				aAdd( _aUser,{ PswId(),Alltrim(aItens[1,12,2]),Alltrim(aItens[1,15,2]) } )
			EndIf
		Else
			If EMPTY( SB1->B1_X_APROV ) //O.S 2266/14 - Eduardo Dias
				aAdd( _aUser,U_TelaUsr2() )
			ElseIf EMPTY( SB1->B1_X_APROV ) .And. !Empty( SC7->C7_NUMSC )
				aAdd( _aUser,U_TelaUsr2() )
			Else
				If SZI->(DbSetOrder(1),DbSeek( xFilial('SZI')+PswId())) .And. EMPTY( SB1->B1_X_APROV ) // OS 3438/14 - By Douglas David
					aAdd( _aUser,{ PswId(),SZI->ZI_CCUSTO,SZI->ZI_NMUSER } )
				ElseIf !EMPTY( SB1->B1_X_APROV )
					/*
					lYesZA6	:=	.F. //Desconsidera a tabela ZA6 - // Eduardo - OS 0687/15
					SC7->( RecLock("SC7",.F.) )
					SC7->C7_APROV := SB1->B1_X_APROV
					SC7->( MsUnlock() )
					*/
					aAdd( _aUser,{ PswId(),SC7->C7_CC,SZI->ZI_NMUSER } ) // Eduardo - OS 0687/15
					//					U_LiberaSC7(2, .F., SB1->B1_X_APROV)
					//					LiberaSC7(pnOpcao, plLibera, pcGrupo)
					//					Return
				EndIf
			EndIf
		EndIf
		
		FWrite( nPididu, "Tela da selecao de usuario terminada."+cEol )
		
		
	Else
		
		FWrite( nPididu, "Este pedido POSSUI solicitacao de compras."+cEol )
		
		SC1->(DbSetOrder(1))
		SC1->(DbSeek( xFilial('SC1')+SC7->C7_NUMSC ))
		SZI->(DbSetOrder(1))
		
		_lSolicit := .f.
		_lCapex   := ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+'SC'+SC1->C1_NUM ) )
		//	_lProjeto := ZA8->( DbSetOrder(1), DbSeek( xFilial('ZA8')+'PR'+SC1->C1_NUM ) ) .Or. !Empty( SC1->C1_X_PRJ )
		
		PswOrder(2) // Ordem de nome do usuario
		PswSeek( SC1->C1_SOLICIT )
		
		////		If SZI->(DbSeek( xFilial('SZI')+PswId() ))
		//If SZI->(DbSeek( xFilial('SZI')+PswId()+SC1->C1_CCAPROV))
		If SZI->(DbSetOrder(1),DbSeek( xFilial('SZI')+PswId()+SC1->C1_CCAPROV))    // OS 2391/14 By Douglas David
			
			FWrite( nPididu, "O usuario solicitante é "+SC1->C1_SOLICIT+' - '+PswId()+" E o Centro - ."+SC1->C1_CCAPROV+" . "+cEol )
			
			/*
			TIRADO ESSA PARTE POIS PEGARA DIRETO PELO USUARIO E CENTRO DE CUSTO DA SOLICITACAO SEM OLHAR O FLAG OS 2264/14
			While !SZI->(EOF()) .AND. SZI->ZI_USUARIO == PswId() // Original -> RetCodUsr(SC1->C1_SOLICIT)
			
			If SZI->ZI_FLGCOM == "1"
			aAdd(_aUser,{SZI->ZI_USUARIO,SZI->ZI_CCUSTO})
			Exit
			EndIf
			
			SZI->(DbSkip())
			EndDo
			*/
			aAdd(_aUser,{SZI->ZI_USUARIO,SZI->ZI_CCUSTO})
			
		Else
			FWrite( nPididu, "O usuario solicitante "+SC1->C1_SOLICIT+' nao cadastrado na SZI.'+cEol )
			_cMsg 	:= "Usuario "+SC1->C1_SOLICIT+" nao cadastrado na SZI!"
			_cLaudo 	+= _cMsg+_cEol
			_lErro 	:= .T.
			
		EndIf
	EndIf
	
	
	If Len( _aUser ) == 0 //.And. lYesZA6 //Desconsidera a tabela ZA6 - // Eduardo - OS 0687/15
		FWrite( nPididu, "Usuario "+SC1->C1_SOLICIT+" nao possui amarracao ao Centro de Custo na SZI!"+cEol )
		_cMsg 	:= "Usuario "+SC1->C1_SOLICIT+" nao possui amarracao ao Centro de Custo na SZI!"
		_cLaudo 	+= _cMsg+_cEol
		_lErro 	:= .T.
	EndIf
	
	If Len( _aUser ) > 0
		FWrite( nPididu, "Verificar se o solicitante no Centro de Custo "+Trim(_aUser[1][2])+' possui Grupo de Aprovacao para Pedidos '+cEol )
		If ZA6->( DbSeek( xFilial('ZA6')+_aUser[1][2] ) ) // Centro de custo
			(cRtSAL)->( DbSeek( xFilial('SAL')+ZA6->ZA6_CAAPC1 ) )
			FWrite( nPididu, "O solicitante no Centro de Custo "+Trim(_aUser[1][2])+' possui Grupo de Aprovacao para Pedidos '+cEol )
			FWrite( nPididu, "O grupo de aprovacao informado nesta amarracao ["+ZA6->ZA6_CAAPC1+"]"+cEol )
			FWrite( nPididu, IIF( (cRtSAL)->( Found() ),'foi encrontrado.','nao foi encontrado.' )+cEol )
			//_cGrupoCC := ZA6->ZA6_CAAPC1  OS 3319-10
		Else
			FWrite( nPididu, "O solicitante no Centro de Custo "+Trim(_aUser[1][2])+' nao possui Grupo de Aprovacao para Pedidos '+cEol )
			_cMsg 	:= "Centro de custo "+_aUser[1][2]+" sem amarracao com grupo de aprovacao cadastrado no ZA6!!!"
			_cLaudo 	+= _cMsg+_cEol
			_lErro 	:= .T.
		EndIf
	EndIf
	
Else
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ . Sergio em Jun/2010: Definir os aprovadores de PC provenientes de medicoes de contratos da mesma for ³
	³                       ma que eh feito para os Pedidos "Diretos". Eh necessario posicionar no contrato ³
	³                       para que atraves do usuario o Centro de Custo aprovador seja obtido.            ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	/*
	Retirado essa parte para que o aprovador do pedido de compra venha do campo  CNB_X_GTEC
	Fernando José - OS 0680/14
	If CN9->( DbSetOrder(1), DbSeek( xFilial('CN9')+SC7->(C7_CONTRA+C7_CONTREV) ) )
	
	PswOrder(2) // Ordem de nome do usuario
	PswSeek( CN9->CN9_X_SOLI )
	
	If SZI->( DbSetOrder(1), DbSeek(xFilial('SZI')+PswId()) )
	
	
	FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - O usuario solicitante é "+CN9->CN9_X_SOLI+' - '+Trim(UsrFullName(PswId()))+"."+cEol )
	
	While !SZI->(Eof()) .And. SZI->ZI_USUARIO == PswId()
	
	FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - SZI->ZI_FLGCOM: "+SZI->ZI_FLGCOM+"."+cEol )
	If SZI->ZI_FLGCOM == "1"
	FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - Adicionando Recno: "+AllTrim( Str(SZI->(Recno())) )+"."+cEol )
	aAdd(_aUser,{SZI->ZI_USUARIO,SZI->ZI_CCUSTO,CN9->CN9_X_SOLI})
	Exit
	EndIf
	
	SZI->(DbSkip())
	
	EndDo
	
	Else
	FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - O usuario solicitante "+CN9->CN9_X_SOLI+' - '+Trim(UsrFullName(PswId()))+' nao cadastrado na SZI.'+cEol )
	_cMsg 	:= "Usuario "+CN9->CN9_X_SOLI+' - '+Trim(UsrFullName(PswId()))+" nao cadastrado na SZI!"
	_cLaudo += _cMsg+_cEol
	_lErro 	:= .T.
	EndIf
	Else
	FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - O contrato ["+SC7->(C7_CONTRA+'/'+C7_CONTREV)+"] nao foi localizado na CN9"+cEol )
	_cMsg 	:= "O contrato ["+SC7->(C7_CONTRA+'/'+C7_CONTREV)+"] nao foi localizado na CN9"
	_cLaudo	+= _cMsg+_cEol
	_lErro 	:= .T.
	EndIf
	
	*/
	
	/////   DAQUI PARA FRENTE SERA A PARTE DE SUBSTITUICA DO CAMPO ACIMA CN9_X_SOLI PARA O CAMPO CNB_X_GTEC
	////    Fernando José OS 0680/14
	
	////   O CAMPO CNB_X_GTEC - e o codigo do aprovador de compra, sera necessario procutrar no SAK o codigo de usuario do sistema
	
	////		PswOrder(2) // Ordem de nome do usuario
	////		PswSeek( (_xAliasT)->CNB_X_GTEC  )
	
	/*
	
	BLOCO SEPARADO PARA A SEGUNDA FASE DAS MUDANCAS DE ALCADAS DE CONTRATO, AGORA SE O CAMPO DO CONTRATO CND_APROV ESTIVER PREENCHIDO O PROGRAMA DEVERA
	PEGAR ESSE GRUPO DE APROVACAO, CASO CONTRARIO ABRIR A TELA PARA ESCOLHER O USUARIO PARA LIBERACAO
	
	If SAK->( DbSetOrder(1), DbSeek(xFilial('SAK')+CNB->CNB_X_GTEC ) )
	_Codaprov := SAK->AK_USER
	///		PswOrder(1)
	///		PswSeek( SAK->AK_USER  )
	
	If SZI->( DbSetOrder(1), DbSeek(xFilial('SZI')+_Codaprov) )
	
	PswOrder(2)
	PswSeek( SZI->ZI_NMUSER  )
	
	FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - O usuario solicitante é "+_CODAPROV+' - '+Trim(UsrFullName(PswId()))+"."+cEol )
	
	While !SZI->(Eof()) .And. SZI->ZI_USUARIO == _CodAprov                                 //////////PswId()
	
	FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - SZI->ZI_FLGCOM: "+SZI->ZI_FLGCOM+"."+cEol )
	If SZI->ZI_FLGCOM == "1"
	FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - Adicionando Recno: "+AllTrim( Str(SZI->(Recno())) )+"."+cEol )
	////					aAdd(_aUser,{SZI->ZI_USUARIO,SZI->ZI_CCUSTO,CN9->CN9_X_SOLI})
	aAdd(_aUser,{SZI->ZI_USUARIO,SZI->ZI_CCUSTO,SZI->ZI_NMUSER})
	Exit
	EndIf
	
	SZI->(DbSkip())
	
	EndDo
	
	Else
	FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - O usuario solicitante "+CN9->CN9_X_SOLI+' - '+Trim(UsrFullName(PswId()))+' nao cadastrado na SZI.'+cEol )
	_cMsg 	:= "Usuario "+CNB->CNB_X_GTEC+' - '+Trim(UsrFullName(PswId()))+" nao cadastrado na SZI!"
	_cLaudo += _cMsg+_cEol
	_lErro 	:= .T.
	EndIf
	Else
	_Codaprov := ""
	FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - O Gerente Tecnico "+CNB->CNB_X_GTEC+' - '+' nao cadastrado na SAK.'+cEol )
	_cMsg 	:= "Gerente Tecnico  "+CNB->CNB_X_GTEC+" nao cadastrado na SAK!"
	_cLaudo += _cMsg+_cEol
	_lErro 	:= .T.
	ENDIF
	
	
	
	//////  FIM
	
	*///CORREÇÃO FLUXO DE APROVAÇÃO SGC - OS 0680-14 - Fernando José
	
	
	_APVconTR  :=  CN9->CN9_APROV    /////  GRUPO DE APROVACAO COLOCADO NO CONTRATO
	_ApContr   :=  .F.
	IF EMPTY(ALLTRIM(CN9->CN9_APROV))
		
		aAdd( _aUser,U_TelaUsr() )
		
	ELSE
		
		IF (cRtSAL)->( DbSeek( xFilial('SAL')+CN9->CN9_APROV ) )
			
			aAdd(_aUser,{CN9->CN9_APROV, CNE->CNE_X_SOLI, __cUserID})
			_ApContr  := .T.
			
		ELSE
			
			FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - O Gerente Tecnico "+CN9->CN9_APROV+' - '+' nao cadastrado na SAK.'+cEol )
			_cMsg 	:= "GRUPO DE APROVACAO COLOCADO NO CONTRATO (CND) NAO EXISTE VERIFICAR.   "
			_cLaudo += _cMsg+_cEol
			_lErro 	:= .T.
			
		ENDIF
		
	ENDIF
	
	//---
	_APVProd	:=  SB1->B1_X_APROV    /////  GRUPO DE APROVACAO COLOCADO NO PRODUTO
	
	IF EMPTY(ALLTRIM(SB1->B1_X_APROV))
		aAdd( _aUser,U_TelaUsr() )
	ELSE
		IF (cRtSAL)->( DbSeek( xFilial('SB1')+SB1->B1_X_APROV) )
			//			aAdd(_aUser,{SB1->B1_X_APROV, CNE->CNE_X_SOLI, __cUserID})
			aAdd( _aUser,{ PswId(),SC7->C7_CC,SZI->ZI_NMUSER } )
		ELSE
			FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - O Gerente Tecnico "+SB1->B1_X_APROV+' - '+' nao cadastrado na SAK.'+cEol )
			_cMsg 	:= "GRUPO DE APROVACAO COLOCADO NO PRODUTO (SB1) NAO EXISTE VERIFICAR. "
			_cLaudo += _cMsg+_cEol
			_lErro 	:= .T.
		ENDIF
	ENDIF
	
	//---
	
	
	If Type("_aUser[1][1]") == "U"
		FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - O usuario solicitante "+SAK->AK_USER+' - '+Trim(UsrFullName(PswId()))+' nao possui autorizacao para inclusao de Pedidos de Compras.'+cEol )
		_cMsg 	:= "Line: "+AllTrim(Str(ProcLine()))+" - O usuario solicitante "+SAK->AK_USER+' - '+Trim(UsrFullName(PswId()))+' nao possui autorizacao para inclusao de Pedidos de Compras.'
		_cLaudo += _cMsg+_cEol
		_lErro 	:= .T.
		U_LiberaSC7(1,.f.)
		FClose( nPididu)
		ExibLog(_cLaudo)
		Return
	Else
		IF !_ApContr //.And. lYesZA6    /////////////////////   NAO É CONTRATO COM O APROVADOR PREENCHIDO - OS 0680-14 - Fernando José // Eduardo - OS 0687/15
			FWrite( nPididu, "Verificar se o solicitante no Centro de Custo "+Trim(_aUser[1][2])+' possui Grupo de Aprovacao para Pedidos '+cEol )
			If ZA6->( DbSeek( xFilial('ZA6')+_aUser[1][2] ) ) // Centro de custo
				(cRtSAL)->( DbSeek( xFilial('SAL')+ZA6->ZA6_CAAPC1 ) )
				FWrite( nPididu, "O solicitante no Centro de Custo "+Trim(_aUser[1][2])+' possui Grupo de Aprovacao para Pedidos '+cEol )
				FWrite( nPididu, "O grupo de aprovacao informado nesta amarracao ["+ZA6->ZA6_CAAPC1+"]"+cEol )
				FWrite( nPididu, IIF( (cRtSAL)->( Found() ),'foi encrontrado.','nao foi encontrado.' )+cEol )
			Else
				FWrite( nPididu, "O solicitante no Centro de Custo "+Trim(_aUser[1][2])+' nao possui Grupo de Aprovacao para Pedidos '+cEol )
				_cMsg 	:= "Centro de custo "+_aUser[1][2]+" sem amarracao com grupo de aprovacao cadastrado no ZA6!!!"
				_cLaudo 	+= _cMsg+_cEol
				_lErro 	:= .T.
				U_LiberaSC7(1,.f.)
				FClose( nPididu)
				ExibLog(_cLaudo)
				Return
			EndIf
		EndIf
	ENDIF
EndIf

FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+cEol )

If Len(_aUser) == 0 .Or. Type("_aUser[1][1]") == "U"
	FWrite( nPididu, "Line: "+AllTrim(Str(ProcLine()))+" - Usuario solicitante nao localizado."+cEol )
	_cMsg  := "Usuario solicitante nao localizado."
	_lErro := .T.
Else
	
	
	If Empty( SC7->C7_NUMSC )
		
		FWrite( nPididu, "Gravando o usuario solicitante "+_aUser[1][3]+" - PC sem SC. "+cEol )
		
		cUpd := " UPDATE "+RetSqlName('SC7')+" SET C7_X_USRA = '"+_aUser[1][3]+"', C7_X_CCAP = '"+_aUser[1][2]+"' "
		cUpd += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
		cUpd += " AND   C7_NUM     = '"+SC7->C7_NUM+"' "
		cUpd += " AND   D_E_L_E_T_ = ' ' "
		
		TcSqlExec( cUpd )
		
	EndIf
EndIf


DbSelectArea('SAK')
DbSetOrder(1) // AK_FILIAL + AK_COD

DbSelectArea('SB1')
DbSetOrder(1)
DbSeek(xFilial('SB1')+SC7->C7_PRODUTO)

_lGrupcom := .t.
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Buscar o usuario correto caso esta rotina esteja sendo executada atraves de MsExecAuto()              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
_cBkId := __cUserID
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Verificar se o usuario logado eh um comprador que esta associado a algum grupo de compras. Em caso    ³
³ afirmativo, nao alterar o ID:                                                                         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
DbSelectArea('SAJ')
DbSetOrder(1) // Codigo do Grupo
If !SAJ->(DbSeek( xFilial('SAJ')+SB1->B1_GRUPCOM ))
	FWrite( nPididu, "O grupo de compras do produto "+Trim(SC7->C7_PRODUTO)+" ["+Trim(SB1->B1_GRUPCOM)+"] "+' nao existe. '+cEol )
	_cMsg		:= "Produto "+SC7->C7_PRODUTO+" sem amarracao com o grupo de compras!!!"
	_cLaudo 	+= _cMsg+_cEol
	_lGrupcom := .f.
Else
	FWrite( nPididu, "Grupo do PC "+Trim(SB1->B1_GRUPCOM) +' - Comprador Amarrado a este grupo: '+"("+SAJ->AJ_USER+")"+UsrFullName(SAJ->AJ_USER)+cEol )
	If "RCOMM99"$Upper(FunName())
		FWrite( nPididu, "RCOMM99 - O Usuario continua sendo o do Pedido!"+cEol )
		__cUserId := SC7->C7_USER
	Else
		FWrite( nPididu, "O Usuario devera ser o do grupo"+cEol )
		__cUserId := SAJ->AJ_USER
	EndIf
	If SAJ->( DbSetOrder(2), DbSeek( xFilial('SAJ')+_cBkId ) ) // Usuario
		FWrite( nPididu, "O Usuario é comprador, utilizar este ID => "+_cBkId+" - "+UsrFullName(_cBkId)+cEol )
		__cUserID := _cBkId
	EndIf
EndIf

If !(FunName() $ 'MATA121/MATA122/MATA160/CNTA120/RCOMM99')
	cExec := " UPDATE "+RetSqlName('SC7')+" SET C7_USER = '"+__cUserId+"' "
	cExec += " WHERE C7_FILIAL = '"+xFilial('SC7')+"' "
	cExec += " AND   C7_NUM    = '"+SC7->C7_NUM+"' "
	cExec += " AND   D_E_L_E_T_ = ' ' "
	TcSqlExec( cExec )
EndIf

If SC7->C7_TIPO == 1
	
	_cPedTmp := SC7->C7_NUM
	aAreaSC1 := SC1->( GetArea() )
	
	SC1->(DbSetOrder(1))
	SC7->(DbSetOrder(1))
	SC7->( DbSeek( xFilial('SC7')+_cPedTmp ) )
	
	While !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == xFilial('SC7')+_cPedTmp
		
		If !Empty( SC7->C7_NUMSC ) .And. Empty(SC7->C7_XJUSTIF)
			If SC1->( DbSeek( xFilial('SC1')+SC7->(C7_NUMSC+C7_ITEMSC) ) ) .And. !Empty(SC1->C1_XJUSTIF)
				
				SC7->( RecLock('SC7',.f.) )
				SC7->C7_XJUSTIF := SC1->C1_XJUSTIF
				SC7->( MsUnLock() )
				
			EndIf
		EndIf
		
		cSolicit += "'"+SC7->C7_NUMSC+"'"
		
		SC7->( DbSkip() )
		
		If !SC7->(Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == xFilial('SC7')+_cPedTmp
			cSolicit += ','
		EndIf
		
	EndDo
	
	SC1->(RestArea(aAreaSC1))
	SC7->(RestArea(_aAreaSC7))
	
EndIf

If _lGrupCom
	
	DbSelectArea('SY1')
	DbSetOrder(3) // Y1_FILIAL+Y1_USER
	If !DbSeek( xFilial('SY1')+__cUserID )
		FWrite( nPididu, "O usuario: ("+__cUserID+") ["+UsrFullName(__cUserId)+"] nao e comprador. "+cEol )
		__cUserId := _cBkId
		
		U_LiberaSC7(1,.f.)
		
		SC7->(RestArea(_aAreaSC7))
	EndIf
	
EndIf

__cUserId := _cBkId

If _lErro
	FWrite( nPididu, "Houve problemas para concluir a geracao das alcadas. Verificar abaixo: "+cEol )
	If !("RCOMM99" $ FunName())
		ExibLog(_cLaudo)
	EndIf
	FWrite( nPididu, _cLaudo+cEol )
	FWrite( nPididu, "O pedido foi bloqueado"+cEol )
	U_LiberaSC7(1,.f.)
	Fclose( nPididu )
	Return
EndIf
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Sergio em 03/Dez/2007: Incluir a aprovacao de suprimentos antes da aprova-³
³                        cao financeira.                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
_xlGrProd := .f.
_ApContr  := .f.  // By Douglas David OS 2135/14
SB1->(DbSetOrder(1))
SB1->(DbSeek( xFilial("SB1")+SC7->C7_PRODUTO ))
If !Empty(SB1->B1_X_APROV)
	_lTemGApr := .T. // OS 2498/10 - Verificação do grupo de aprovação - Inibir troca de aprovador pelo superior.
	If !(cRtSAL)->(DbSeek( xFilial("SAL")+SB1->B1_X_APROV ))
		_cMsg		:= "O Grupo de Aprovadores "+SB1->B1_X_APROV+" informado no produto "+SB1->B1_COD+" nao existe no cadastro!!!"
		_cLaudo 	+= _cMsg+_cEol
		FWrite( nPididu, "O Grupo de Aprovadores "+SB1->B1_X_APROV+" informado no produto "+SB1->B1_COD+" nao existe no cadastro!!!"+cEol )
	Else
		If Empty(_cGrupoCC)
			FWrite( nPididu, "O grupo de aprovadores do produto "+Trim(SC7->C7_PRODUTO)+" ["+Trim(SB1->B1_X_APROV)+"] "+' sera Considerado. '+cEol )
		Else
			FWrite( nPididu, "O grupo de aprovadores do produto "+Trim(SC7->C7_PRODUTO)+" ["+Trim(SB1->B1_X_APROV)+"] "+' sera incrementado ao grupo [ '+_cGrupoCC+' ]. '+cEol )
		EndIf
		_xlGrProd := .t.
	EndIf
EndIf


//_nVlQuebra := SB1->B1_XVLRQBR   OS 3319-10
_nRegSAL := (cRtSAL)->AL_COD
/*If _nRegSAL <> _cGrupoCC     OS 3319-10
aAdd(_aGrupos, _cGrupoCC)
aAdd(_aGrupos, _nRegSAL)
EndIf
*/
FWrite( nPididu, "Inicio da verificacao da aprovacao de negociacao. Grupo obtido ate o momento: "+_nRegSAL+cEol )

If !_xlGrProd  .AND. 	!_ApContr    ///// 	_ApContr   -   INDICA QUE ESTA SENDO INDICADO UM APROVADOR NO CONTRATO ASSIM NAO SE DEVE MUDAR O GRUPO DE APROVACAO - OS 0680-14 - Fernando José
	FWrite( nPididu, "Não houve grupo de produtos. Grupo para negociacao: "+_nRegSAL+cEol )
	(cRtSAL)->( DbSeek( xFilial('SAL')+SY1->Y1_X_APROV ) )
EndIf
FWrite( nPididu, "Grupo de aprovacao de negociacao amarrado ao comprador: "+SY1->Y1_X_APROV+" - Encontrado => "+ IIF((cRtSAL)->( DbSeek( xFilial('SAL')+SY1->Y1_X_APROV ) ),".t.",".f.") +cEol )
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Sergio em Jun/2010: Atendimento a OS 0541/10 - Somente devera gerar aprovacao para a area de Procure- ³
³                     ment caso a origem nao seja igual a "CONTRATO".                                   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
lGeraProc := !"SGC"$SC7->C7_X_CAPEX .Or.!IsInCallStack('CNTA120')
FWrite( nPididu, "Verificacoes - (cRtSAL)->AL_COD: ["+(cRtSAL)->AL_COD+"]"+SY1->Y1_X_APROV+" - _xlGrProd: "+ IIF(_xlGrProd,".t.",".f.")+" - _lGrupcom: "+IIF(_lGrupcom ,".t.",".f.")+" - lGeraProc: "+IIF(lGeraProc ,".t.",".f.")+cEol )

While !(cRtSAL)->( Eof() ) .And. (cRtSAL)->AL_COD == SY1->Y1_X_APROV .And. !_xlGrProd .And. _lGrupcom .And. lGeraProc
	
	DbSelectArea('SAK')
	SAK->( DbSetOrder(1), DbSeek(xFilial('SAK')+(cRtSAL)->AL_APROV) )
	
	FWrite( nPididu, "LINE: "+AllTrim(Str(ProcLine()))+" (cRtSAL)->AL_AUTOLIM: "+(cRtSAL)->AL_AUTOLIM+" TOTPED->VALPED: "+Transform(TOTPED->VALPED, "@R 999,999,999.99")+" SAK->AK_LIMMIN: "+Transform(SAK->AK_LIMMIN, "@R 999,999,999.99")+" SAK->AK_LIMMAX: "+Transform(SAK->AK_LIMMAX, "@R 999,999,999.99")+" Verificar se o aprovador "+UsrFullName((cRtSAL)->AL_USER)+" (cRtSAL)->AL_NIVEL: "+(cRtSAL)->AL_NIVEL+" _cNivelSol: "+_cNivelSol+" precisara entrar na alcada de aprovacao"+cEol )
	
	If (cRtSAL)->AL_AUTOLIM == 'N' .Or. (TOTPED->VALPED >= SAK->AK_LIMMIN .And. TOTPED->VALPED <= SAK->AK_LIMMAX)// .And.
		
		__aArea    := GetArea()         // guardando area atual
		__aAreaSC7 := SC7->(GetArea())  // guardando area atual do pedido de compras
		__aAreaSC1 := SC1->(GetArea())  // guardando area atual da solicitacao de compras
		__aAreaCTT := CTT->(GetArea())  // guardando area atual do centro de custo
		__aAreaSA2 := SA2->(GetArea())  // guardando area atual do cadastro de fornecedor
		
		__cPcNum   := SC7->C7_NUM
		__cDescPrd := ''
		__cSolicit := ''
		__cNomFor  := Alltrim(Posicione("SA2", 1, xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA),"A2_NOME"))
		__cCCDesc  := Alltrim(Posicione("CTT", 1, SC7->(C7_FILIAL+_aUser[1][2]),"CTT_DESC01"))
		
		SC1->(dbSetOrder(1))
		If SC1->(dbSeek(SC7->C7_FILIAL+SC7->C7_NUMSC))
			__cSolicit := UsrFullName(SC1->C1_USER)
		EndIf
		
		RestArea(__aAreaCTT)
		RestArea(__aAreaSA2)
		RestArea(__aAreaSC1)
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Sergio em 22/Jan/2008: Correcao: Posicionar no pedido de compras e testar ³
		³                        se nao eh final de arquivo. Como nao ha a verifica-³
		³                        cao de final de arquivo, quando chegava no ultimo  ³
		³                        registro do pedido, este while ficava em loop e o  ³
		³                        tamanho da string ultrapassava o limite de string  ³
		³                        de 64 kb gerando assim o error.log                 ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+__cPcNum ) )
		While !SC7->( Eof() ) .And. __cPcNum == SC7->C7_NUM
			__cDescPrd += Alltrim(SC7->C7_DESCRI)
			SC7->(dbSkip())
			If __cPcNum == SC7->C7_NUM
				__cDescPrd += ', '
			EndIf
		EndDo
		
		SC7->( RestArea(__aAreaSC7) )
		RestArea(__aArea)
		
		(cRtAlias)->( Reclock(cRtAlias,.t.) )
		(cRtAlias)->CR_FILIAL		:= xFilial("SCR")
		(cRtAlias)->CR_NUM			:= SC7->C7_NUM
		(cRtAlias)->CR_TIPO		:= 'PC'
		If Ascan( aAprovs, SAK->AK_USER ) == 0
			Aadd( aAprovs, SAK->AK_USER )
		EndIf
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Ajustar o status no caso de haver mais de um aprovador no mesmo nivel                                 ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		nSeek := Ascan( aStats, { |x| x[1] == (cRtSAL)->AL_NIVEL } )
		If nSeek == 0
			Aadd( aStats, { (cRtSAL)->AL_NIVEL, _cStatus } )
			nSeek := Len( aStats )
		EndIf
		(cRtAlias)->CR_NIVEL		:= (cRtSAL)->AL_NIVEL
		(cRtAlias)->CR_USER		:= SAK->AK_USER
		(cRtAlias)->CR_APROV		:= SAK->AK_COD
		(cRtAlias)->CR_STATUS      := aStats[nSeek][2]
		(cRtAlias)->CR_TOTAL		:= TOTPED->VALPED
		(cRtAlias)->CR_EMISSAO 	:= Date()
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Flegar a aprovacao de Procurement                                                                     ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		(cRtAlias)->CR_X_TPLIB 	:= 'S'
		(cRtAlias)->CR_MOEDA		:= 1
		(cRtAlias)->CR_TXMOEDA 	:= 1
		(cRtAlias)->CR_XDESCPR 	:= __cDescPrd  	// Descricao dos produtos contido no pedido de compras
		(cRtAlias)->CR_XNOMFOR 	:= __cNomFor   	// nome do fornecedor do PC
		(cRtAlias)->CR_XNOMSOL 	:= __cSolicit   	// nome do solicitado do primeiro item do PC contido na SC
		(cRtAlias)->CR_XCC     	:= _aUser[1][2] 	// SC7->C7_CC  // Centro de custo
		(cRtAlias)->CR_XCCDESC 	:= __cCCDesc   	// descricao do centro de custo
		(cRtAlias)->( MsUnlock() )
		
		FWrite( nPididu, "Gerando o aprovador ["+UsrFullName(SAK->AK_USER)+"] de suprimentos para o nivel ["+(cRtSAL)->AL_NIVEL+"] com Status: "+(cRtAlias)->CR_STATUS+cEol )
		_cStatus := '01'
		_lJa02   := .t.
	Else
		FWrite( nPididu, "Nao foi gerado o aprovador ["+UsrFullName(SAK->AK_USER)+"] de suprimentos para o nivel ["+(cRtSAL)->AL_NIVEL+"]"+cEol )
	EndIf
	
	(cRtSAL)->( DbSkip() )
	
EndDo
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ # Chamado 004672: Geracao da aprovacao CAPEX ou PROJETO conforme as especi-³
³                   ficacoes do escopo preliminar aprovado:                  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
FWrite( nPididu, "|- Inicio do tratamento de aprovacao CAPEX / PROJETO -|"+cEol )

If SC1->( DbSetOrder(1), DbSeek( xFilial('SC1')+SC7->C7_NUMSC ) ) .And. ( _lCapex .Or. _lProjeto ) .Or. !Empty(SB1->B1_X_APROV)
	
	FWrite( nPididu, "Existe a aprovacao CAPEX / PROJETO"+cEol )
	
	cAliasVer := GetNextAlias()
	
	cVerifik := " SELECT COUNT(*) AS REGSCR "
	cVerifik += " FROM "+cRtTable
	cVerifik += " WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
	cVerifik += " AND   CR_TIPO   = 'PC' "
	cVerifik += " AND   CR_NUM    = '"+SC7->C7_NUM+"' "
	cVerifik += " AND   D_E_L_E_T_ = ' ' "
	
	U_MontaView( cVerifik, cAliasVer )
	
	(cAliasVer)->( DbGoTop() )
	
	_cStatus := IIF( (cAliasVer)->REGSCR > 0,"01","02" )
	
	(cAliasVer)->( DbCloseArea() )
	
	FWrite( nPididu, "Aprovacao CAPEX / PROJETO (cRtAlias) => "+cRtAlias+cEol )
	
	//Tatiana - Inicio
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ # Chamado 3251/10: Definição de qual grupo de aprovação será usado,         ³
	³                    utilizando como critério de seleção do fluxo a unidade   ³
	³ 					 de negocio do pedido de compra. A unidade de negocio     ³
	³					 será identificada através dos dois primeiros dígitos do  ³
	³					 campo unidade de negocio preenchido no pedido de compras.³
	³ # Alteração do   : Quando for um pedido de compras CAPEX deverá seguir o    ³
	³	Escopo Inicial : fluxo de aprovacão normal, porem sempre desconsiderando  ³
	³					 o aprovador da presidencia, cadastrado no paramentro     ³
	³					 MV_X_PRESI.											  ³
	³ # Tatiana A. Barbosa - 03/2011 											  ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	/*
	Grupos de aprovação de acordo com a regra de negócio:
	Unid.  Nome				Cod. Grupo		Parametro
	Neg.					de Aprov.
	02 = CARDSYSTEM 	=	7000002		=	MV_X_APCP2
	03 = CREDIT&RISK	=	7000003		=	MV_X_APCP3
	04 = TELESYSTEM		= 	7000004		=	MV_X_APCP4
	05 = NOVOS PROJETOS	=	7000005		=	MV_X_APCP5
	06 = ACQUIRER		=	7000006		=	MV_X_APCP6
	07 = MARKETSYSTEM	= 	7000007		=	MV_X_APCP7
	09 = INSTITUCIONAL	= 	7000009		=	MV_X_APCP9
	*/
	
	
	
	//(cRtSAL)->( DbSetOrder(2), DbSeek( xFilial('SAL')+GetNewPar('MV_X_APCPX','700000') ) ) // Codigo do grupo de aprovacao CAPEX / PROJETO
	
	/*
	If Substr(SC7->C7_ITEMCTA,1,2)=="02"
	_cGrpAprov := GetNewPar('MV_X_APCP2','700002')
	ElseIf Substr(SC7->C7_ITEMCTA,1,2)=="03"
	_cGrpAprov := GetNewPar('MV_X_APCP3','700003')
	ElseIf Substr(SC7->C7_ITEMCTA,1,2)=="04"
	_cGrpAprov := GetNewPar('MV_X_APCP4','700004')
	ElseIf Substr(SC7->C7_ITEMCTA,1,2)=="05"
	_cGrpAprov := GetNewPar('MV_X_APCP5','700005')
	ElseIf Substr(SC7->C7_ITEMCTA,1,2)=="06"
	_cGrpAprov := GetNewPar('MV_X_APCP6','700006')
	ElseIf Substr(SC7->C7_ITEMCTA,1,2)=="07"
	_cGrpAprov := GetNewPar('MV_X_APCP7','700007')
	ElseIf Substr(SC7->C7_ITEMCTA,1,2)=="09"
	_cGrpAprov := GetNewPar('MV_X_APCP9','700009')
	EndIf
	*/
	
	//	(cRtSAL)->( DbSetOrder(2), DbSeek( xFilial('SAL')+ _cGrpAprov ) ) // Codigo do grupo de aprovacao CAPEX / PROJETO
	(cRtSAL)->( DbSeek( xFilial('SAL')+ZA6->ZA6_CAAPC1 ) )
	
	If !Empty(SB1->B1_X_APROV)
		(cRtSAL)->( DbSeek( xFilial('SAL')+_nRegSAL ) )
		_cGrpAprov := SB1->B1_X_APROV
		_cAprovPres := GetMV("MV_X_PRESI")
	Else
		_cGrpAprov := (cRtSAL)->AL_COD
		_cAprovPres := GetMV("MV_X_PRESI")
	EndIf
	
	SAK->( DbSetOrder(1) )
	
	While !(cRtSAL)->( Eof() ) .And. (cRtSAL)->AL_COD == _cGrpAprov
		
		//Tatiana - Fim
		
		SAK->( DbSeek( xFilial("SAK")+(cRtSAL)->AL_APROV ) )
		
		If (cRtSAL)->AL_AUTOLIM == 'N' .Or. 	(TOTPED->VALPED >= SAK->AK_LIMMIN .And. TOTPED->VALPED <= SAK->AK_LIMMAX)
			
			If !((cRtSAL)->AL_APROV $ _cAprovPres)
				
				__aArea    := GetArea()         // guardando area atual
				__aAreaSC7 := SC7->(GetArea())  // guardando area atual do pedido de compras
				__aAreaSC1 := SC1->(GetArea())  // guardando area atual da solicitacao de compras
				__aAreaCTT := CTT->(GetArea())  // guardando area atual do centro de custo
				__aAreaSA2 := SA2->(GetArea())  // guardando area atual do cadastro de fornecedor
				
				__cPcNum   := SC7->C7_NUM
				__cDescPrd := ''
				__cSolicit := ''
				__cNomFor  := Alltrim(Posicione("SA2", 1, xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA),"A2_NOME"))
				__cCCDesc  := Alltrim(Posicione("CTT", 1, SC7->(C7_FILIAL+_aUser[1][2]),"CTT_DESC01"))
				
				SC1->(dbSetOrder(1))
				If SC1->(dbSeek(SC7->C7_FILIAL+SC7->C7_NUMSC))
					__cSolicit := UsrFullName(SC1->C1_USER)
				EndIf
				
				RestArea(__aAreaCTT)
				RestArea(__aAreaSA2)
				RestArea(__aAreaSC1)
				
				/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Sergio em 22/Jan/2008: Correcao: Posicionar no pedido de compras e testar ³
				³                        se nao eh final de arquivo. Como nao ha a verifica-³
				³                        cao de final de arquivo, quando chegava no ultimo  ³
				³                        registro do pedido, este while ficava em loop e o  ³
				³                        tamanho da string ultrapassava o limite de string  ³
				³                        de 64 kb gerando assim o error.log                 ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+__cPcNum ) )
				While !SC7->( Eof() ) .And. __cPcNum == SC7->C7_NUM
					__cDescPrd += Alltrim(SC7->C7_DESCRI)
					SC7->(dbSkip())
					If __cPcNum == SC7->C7_NUM
						__cDescPrd += ', '
					EndIf
				EndDo
				
				SC7->( RestArea(__aAreaSC7) )
				RestArea(__aArea)
				
				Aadd( _aAprov, (cRtSAL)->AL_APROV )
				
				(cRtAlias)->( Reclock(cRtAlias,.t.) )
				(cRtAlias)->CR_FILIAL		:= xFilial("SCR")
				(cRtAlias)->CR_NUM			:= SC7->C7_NUM
				(cRtAlias)->CR_TIPO		:= 'PC'
				(cRtAlias)->CR_NIVEL		:= (cRtSAL)->AL_NIVEL
				(cRtAlias)->CR_USER		:= SAK->AK_USER
				(cRtAlias)->CR_APROV		:= SAK->AK_COD
				(cRtAlias)->CR_STATUS      := _cStatus
				(cRtAlias)->CR_TOTAL		:= TOTPED->VALPED
				(cRtAlias)->CR_EMISSAO 	:= Date()
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Flegar a aprovacao CAPEX                                                                              ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				(cRtAlias)->CR_X_TPLIB 	:= 'C'
				(cRtAlias)->CR_MOEDA		:= 1
				(cRtAlias)->CR_TXMOEDA 	:= 1
				(cRtAlias)->CR_XDESCPR 	:= __cDescPrd  	// Descricao dos produtos contido no pedido de compras
				(cRtAlias)->CR_XNOMFOR 	:= __cNomFor   	// nome do fornecedor do PC
				(cRtAlias)->CR_XNOMSOL 	:= __cSolicit   	// nome do solicitado do primeiro item do PC contido na SC
				(cRtAlias)->CR_XCC     	:= _aUser[1][2] 	// SC7->C7_CC  // Centro de custo
				(cRtAlias)->CR_XCCDESC 	:= __cCCDesc   	// descricao do centro de custo
				(cRtAlias)->( MsUnlock() )
				
				FWrite( nPididu, "Gerando o aprovador ["+UsrFullName(SAK->AK_USER)+"] CAPEX para o nivel ["+(cRtAlias)->CR_NIVEL+"] com Status: "+(cRtAlias)->CR_STATUS+cEol )
				
				_cStatus := '01'
				_lJa02   := .t.
			EndIf
		Else
			FWrite( nPididu, "Nao foi necessario gerar o aprovador ["+UsrFullName(SAK->AK_USER)+"] CAPEX para o nivel ["+(cRtSAL)->AL_NIVEL+"] "+cEol )
		EndIf
		
		(cRtSAL)->( DbSkip() )
		
	EndDo
	
EndIf

FWrite( nPididu, "Inicio da verificacao da aprovacao FINANCEIRA. Grupo de aprovacao financeira: "+_nRegSAL+cEol )


If Empty( SC7->C7_NUMSC ) .And. !_lCapex
	FWrite( nPididu, "Verificando a aprovacao superior se o solicitante for um aprovador"+cEol )
	If SAK->( DbSetOrder(2), DbSeek( xFilial('SAK')+_aUser[1][1] ) )
		FWrite( nPididu, "LINE: "+AllTrim(Str(ProcLine()))+" O Solicitante 'e um aprovador. SAK->AK_USER: "+SAK->AK_USER+" SAK->AK_COD: "+SAK->AK_COD+" "+UsrFullName(SAK->AK_USER)+cEol )
		xAprov := ''
		If !_lTemGApr// OS 2498/10 - Verificação do grupo de aprovação - Inibir troca de aprovador pelo superior em produtos com grupo fixo.
			While !SAK->( Eof() ) .And. SAK->AK_USER == _aUser[1][1]
				
				FWrite( nPididu, "LINE: "+AllTrim(Str(ProcLine()))+" SAK->AK_COD: "+SAK->AK_COD+" SAK->AK_APROSUP: "+SAK->AK_APROSUP+" SAK->AK_USER: "+SAK->AK_USER+" "+UsrFullName(SAK->AK_USER)+cEol )
				If !Empty( SAK->AK_APROSUP )
					IF Empty(SC7->C7_CONTRA)
						xAprov := SAK->AK_APROSUP
					ENDIF
				EndIf
				
				SAK->( DbSkip() )
				
			EndDo
			
			
			If !Empty( xAprov ) .And. SAK->( DbSetOrder(1), DbSeek( xFilial('SAK')+xAprov ) )
				
				Aadd( _aAprov, SAK->AK_COD )
				If !FunName() $ 'CNTA120'
					xAprosu := SAK->AK_USER
				endif
				
				(cRtAlias)->( Reclock(cRtAlias,.t.) )
				(cRtAlias)->CR_FILIAL	:= xFilial("SCR")
				(cRtAlias)->CR_NUM		:= SC7->C7_NUM
				(cRtAlias)->CR_TIPO		:= 'PC'
				(cRtAlias)->CR_NIVEL	:= '00'
				(cRtAlias)->CR_USER		:= SAK->AK_USER
				(cRtAlias)->CR_APROV	:= xAprov
				(cRtAlias)->CR_STATUS   := _cStatus
				(cRtAlias)->CR_TOTAL	:= TOTPED->VALPED
				(cRtAlias)->CR_EMISSAO 	:= Date()
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Flegar a aprovacao financeira                                                                         ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				(cRtAlias)->CR_X_TPLIB 	:= 'A'
				(cRtAlias)->CR_MOEDA	:= 1
				(cRtAlias)->CR_TXMOEDA 	:= 1
				(cRtAlias)->CR_XDESCPR 	:= __cDescPrd  	// Descricao dos produtos contido no pedido de compras
				(cRtAlias)->CR_XNOMFOR 	:= __cNomFor   	// nome do fornecedor do PC
				(cRtAlias)->CR_XNOMSOL 	:= __cSolicit   	// nome do solicitado do primeiro item do PC contido na SC
				(cRtAlias)->CR_XCC     	:= _aUser[1][2] 	// SC7->C7_CC  // Centro de custo
				(cRtAlias)->CR_XCCDESC 	:= __cCCDesc   	// descricao do centro de custo
				(cRtAlias)->( MsUnlock() )
				_cStatus := '01'
				_lJa02   := .t.
				
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Sergio em Jul/2010: Atendimento a OS  1824/10 onde o codigo do aprovador obtido atraves do aprovador   ³
				³                     superior pode nao estar contido no grupo de aprovacao gravado no campo C7_APROV.   ³
				³                     Se esta situacao for detectada (SAK->AK_USER == _aUser[1][1]) o campo CR_APROV de- ³
				³                     devera ser gravado com o codigo de aprovador relacionado ao usuario presente no    ³
				³                     grupo de aprovacao C7_APROV.                                                       ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				aSAlAnt := (cRtSAL)->( GetArea() )
				//(cRtSAL)->( DbSetOrder(3), DbSeek( xFilial('SAL')+SC7->C7_APROV ) )
				(cRtSAL)->( DbSetOrder(2), DbSeek( xFilial('SAL')+SC7->C7_APROV ) )
				
				While !(cRtSAL)->( Eof() ) .And. (cRtSAL)->AL_COD == SC7->C7_APROV
					If (cRtSAL)->AL_USER == SAK->AK_USER
						
						(cRtAlias)->( Reclock(cRtAlias,.f.) )
						(cRtAlias)->CR_APROV := (cRtSAL)->AL_APROV
						(cRtAlias)->( MsUnlock() )
						
					EndIf
					(cRtSAL)->( DbSkip() )
				EndDo
				
				(cRtSAL)->( RestArea( aSALAnt ) )
				
				FWrite( nPididu, "Line: "+AllTrim(Str( ProcLine() ))+" - Gerando o aprovador superior CR_APROV [ "+(cRtAlias)->CR_APROV+" ] - "+UsrFullName(SAK->AK_USER)+" com Status: "+(cRtAlias)->CR_STATUS+cEol )
				
			Else
				FWrite( nPididu, "Line: "+AllTrim(Str( ProcLine() ))+" - código de aprovador superior inválido."+cEol )
				If "RCOMM99"$Upper(FunName())
					Aviso("APROVADOR SUPERIOR INVALIDO","Nao existe aprovador superior referente ao codigo de usuario ["+_aUser[1][1]+" - "+UsrFullName(_aUser[1][1])+"]. Entre em contato com a área responsável.",;
					{"&Fechar"},3,"Usuário",,;
					"PCOLOCK")
				EndIf
			EndIf
		Else // OS 2498/10 - Verificação do grupo de aprovação - Inibir troca de aprovador pelo superior.
			FWrite( nPididu, "Line: "+AllTrim(Str( ProcLine() ))+" O produto ["+Trim(SC7->C7_PRODUTO)+"] possui grupo de aprovação ["+_nRegSAL+"] cadastrado"+cEol )
			FWrite( nPididu, "Line: "+AllTrim(Str( ProcLine() ))+" Verificação e troca para o aprovador superior cancelada"+cEol )
		EndIf
		
	EndIf
EndIf


If Len(_aGrupos) > 0
	For nY := 1 to Len(_aGrupos)
		(cRtSAL)->( DbSeek( xFilial('SAL')+_aGrupos[nY] ) )
		
		aStats   := {}
		_cCod    := (cRtSAL)->AL_COD
		_nAlcAnt := 0
		_cGrupo  := _cCod
		_lxAprov := .f.
		
		MontaAprov(_cCod,_cAprovPres,1,nY)
	Next nY
Else
	(cRtSAL)->( DbSeek( xFilial('SAL')+_nRegSAL ) )
	
	aStats   := {}
	_cCod    := (cRtSAL)->AL_COD
	_nAlcAnt := 0
	_cGrupo  := _cCod
	_lxAprov := .f.
	
	MontaAprov(_cCod,_cAprovPres,2)
EndIf

If Len(_aAprov) == 0
	FWrite( nPididu, "Nao foram encontrados aprovadores para este pedido. O pedido sera bloqueado sem aprovadores relacionados."+cEol )
	If !("RCOMM99"$FunName())
		Aviso('100 Aprovadores','Nao foram encontrados aprovadores para este Pedido.',{"Ok"})
	EndIf
	U_LiberaSC7(1,.f.)   // Enviar ja com o flag de Bloqueado
	
	SC7->(RestArea(_aAreaSC7))
	RestArea(_aAreaAnt)
	
	Fclose( nPididu )
	Return
EndIf

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ OS 3261/08: Revisar a aprovacao financeira caso o solicitante seja um apro-³
³ vador. Esta regra vale somente para Pedidos de Compras sem Solicitacoes.   ³
³ *** IMPLANTAR ESTA OS SOMENTE APOS A OS 2326/08.                           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
/*
If Empty( SC7->C7_NUMSC )
If SAK->( DbSetOrder(2), DbSeek( xFilial('SAK')+_aUser[1][1] ) )

// Neste caso o solicitante eh um aprovador - reprocessar as alcadas:

FWrite( nPididu, "O solicitante deste Pedido sem Solicitação é um aprovador."+cEol )

cSolPc := " SELECT R_E_C_N_O_ CRECNNO, CR_NIVEL FROM "+cRtTable
cSolPc += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
cSolPc += " AND   CR_TIPO    = 'PC' "
cSolPc += " AND   CR_NUM     = '"+SC7->C7_NUM+"' "
cSolPc += " AND   CR_X_TPLIB NOT IN('C','S') " // Capex + Aprovacao Financeira
cSolPc += " AND   D_E_L_E_T_ = ' ' "
cSolPc += " ORDER BY CR_NIVEL "

nCntView := U_MontaView( cSolPc, 'SolPc' )

FWrite( nPididu, "Niveis obtidos ate o momento: "+Str(nCntView)+cEol )

SolPc->( DbGoTop() )

While !SolPc->( Eof() )

(cRtAlias)->( DbGoTo( SolPc->CRECNNO ) )

// SAK->( DbSetOrder(1), DbSeek( xFilial('SAK')+GetNewPar('MV_X_APFIN','000099') ) )

FWrite( nPididu, "Verificando se o aprovador atual do CR_APROV ["+(cRtAlias)->CR_APROV+"] é o aprovador financeiro => "+UsrFullName((cRtAlias)->CR_USER)+cEol )

If (cRtAlias)->CR_APROV $ GetNewPar('MV_X_APFN','000099/090050/090060')
FWrite( nPididu, "Aprovador financeiro detectado. Saindo do Laço."+cEol )
// Como o aprovador financeiro foi detectado, deletar os itens anteriores
// e criar o aprovador superior do usuario detectado conforme o SAK:
Exit
Else
FWrite( nPididu, "O aprovador atual ["+AllTrim(UsrFullName((cRtAlias)->CR_USER))+"] esta sendo adicionado na lista de delecao. "+cEol )
Aadd( aAntFin, { SolPc->CRECNNO, SolPc->CR_NIVEL } )
EndIf

SolPc->( DbSkip() )

EndDo

FWrite( nPididu, "Numero de registros obtidos para deletar/alterar => "+Str(Len( aAntFin ))+cEol )

If Len( aAntFin ) > 0
(cRtAlias)->( DbGoTo( aAntFin[Len(aAntFin)][1] ) )
FWrite( nPididu, "O aprovador atual ["+SAK->AK_COD+" / "+SAK->AK_USER+"] tem como aprovador superior ["+SAK->AK_APROSUP+"]"+cEol )
_cAproSup := SAK->AK_APROSUP
SAK->( DbSetOrder(1), DbSeek( xFilial('SAK')+_cAproSup ) )
FWrite( nPididu, "O aprovador atual ["+AllTrim(UsrFullName((cRtAlias)->CR_USER))+"] => passará a ser ["+SAK->AK_USER+" / "+AllTrim(UsrFullName(SAK->AK_USER))+"]"+cEol )
(cRtAlias)->( RecLock('SCR',.f.) )
(cRtAlias)->CR_USER  := SAK->AK_USER
(cRtAlias)->CR_APROV := SAK->AK_COD
(cRtAlias)->( MsUnLock() )

For nUlt := Len( aAntFin ) To 1 Step -1

If nUlt == Len( aAntFin )
Loop
EndIf

(cRtAlias)->( DbGoTo( aAntFin[nUlt][1] ) )

FWrite( nPididu, "O aprovador atual ["+AllTrim(UsrFullName((cRtAlias)->CR_USER))+"] esta sendo deletado!"+cEol )
(cRtAlias)->( RecLock('SCR',.f.) )
(cRtAlias)->( DbDelete() )
(cRtAlias)->( MsUnLock() )

Next
Else // Se nao entrou no laco acima, forcar a entrada:
FWrite( nPididu, "Line: "+AllTrim(Str( ProcLine() ))+" - Nao entrou no laco do aprovador financeiro. Forçar geração do aprovador superior ["+SAK->AK_APROSUP+"] do ["+SAK->AK_COD+"] "+Trim(UsrFullName(SAK->AK_USER))+cEol )
_SAK_COD := SAK->AK_COD
If SAK->( DbSetOrder(1), DbSeek( xFilial('SAK')+SAK->AK_APROSUP ) )
FWrite( nPididu, "Line: "+AllTrim(Str( ProcLine() ))+" - Gerando o aprovador superior."+cEol )
(cRtAlias)->( Reclock(cRtAlias,.t.) )
(cRtAlias)->CR_FILIAL	:= xFilial("SCR")
(cRtAlias)->CR_NUM		:= SC7->C7_NUM
(cRtAlias)->CR_TIPO		:= 'PC'
(cRtAlias)->CR_NIVEL	:= '02'
(cRtAlias)->CR_USER		:= SAK->AK_USER
(cRtAlias)->CR_APROV	:= SAK->AK_COD
(cRtAlias)->CR_STATUS   := '01'
(cRtAlias)->CR_TOTAL	:= TOTPED->VALPED
(cRtAlias)->CR_EMISSAO 	:= Date()
(cRtAlias)->CR_X_TPLIB 	:= 'A'  // Aprovacao Financeira
(cRtAlias)->CR_MOEDA	:= 1
(cRtAlias)->CR_TXMOEDA 	:= 1
(cRtAlias)->CR_XDESCPR 	:= __cDescPrd  	// Descricao dos produtos contido no pedido de compras
(cRtAlias)->CR_XNOMFOR 	:= __cNomFor   	// nome do fornecedor do PC
(cRtAlias)->CR_XNOMSOL 	:= __cSolicit   	// nome do solicitado do primeiro item do PC contido na SC
(cRtAlias)->CR_XCC     	:= _aUser[1][2] 	// SC7->C7_CC  // Centro de custo
(cRtAlias)->CR_XCCDESC 	:= __cCCDesc   	// descricao do centro de custo
(cRtAlias)->( MsUnlock() )
Else
FWrite( nPididu, "Line: "+AllTrim(Str( ProcLine() ))+" - código de aprovador superior inválido."+cEol )
Aviso("APROVADOR SUPERIOR INVALIDO","O aprovador superior referente ao codigo de aprovador ["+_SAK_COD+"] está inválido. Entre em contato com a área responsável.",;
{"&Fechar"},3,"Usuário",,;
"PCOLOCK")

EndIf

EndIf

EndIf
EndIf
*/

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Refazer os niveis de acordo com a aprovacao de Suprimentos x Financeira:   ³
³ -> Verificar qual foi o ultimo nivel da aprovacao de suprimentos:          ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
FWrite( nPididu, "Refazer os niveis de aprovacao caso exista aprovacao da negociacao."+cEol )
cMaxSup := " SELECT MAX(CR_NIVEL) CMAXNIVEL FROM "+cRtTable
cMaxSup += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
cMaxSup += " AND   CR_TIPO    = 'PC' "
cMaxSup += " AND   CR_NUM     = '"+SC7->C7_NUM+"' "
cMaxSup += " AND   CR_X_TPLIB = 'S' "
cMaxSup += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cMaxSup, 'MaxSup' )

MaxSup->( DbGoTop() )

_lNegoc := !Empty( MaxSup->CMAXNIVEL )

If !Empty( MaxSup->CMAXNIVEL )
	cMaxNiv := MaxSup->CMAXNIVEL
Else
	cMaxNiv := '01'
EndIf

FWrite( nPididu, "REFAZENDO os niveis de aprovacao."+cEol )
cRefNiv := " SELECT R_E_C_N_O_ AS RE_CNO FROM "+cRtTable
cRefNiv += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
cRefNiv += " AND   CR_TIPO    = 'PC' "
cRefNiv += " AND   CR_NUM     = '"+SC7->C7_NUM+"' "
cRefNiv += " AND   CR_X_TPLIB <> 'S' "
cRefNiv += " AND   D_E_L_E_T_ = ' ' "
cRefNiv += " ORDER BY CR_NIVEL "

U_MontaView( cRefNiv, 'RefNiv' )

RefNiv->( DbGoTop() )
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Verificar quais nives possuem mais de um aprovador:                        ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cVerNiv := " SELECT CR_NIVEL FROM "+cRtTable
cVerNiv += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
cVerNiv += " AND   CR_TIPO    = 'PC' "
cVerNiv += " AND   CR_NUM     = '"+SC7->C7_NUM+"' "
cVerNiv += " AND   CR_X_TPLIB <> 'S' "
cVerNiv += " AND   D_E_L_E_T_ = ' ' "
cVerNiv += " GROUP BY CR_NIVEL "
cVerNiv += " HAVING COUNT(*) > 1 "

U_MontaView( cVerNiv, 'VerNiv' )

VerNiv->( DbGoTop() )

While !VerNiv->( Eof() )
	
	Aadd( aNivs, { VerNiv->CR_NIVEL, .f. } )
	
	VerNiv->( DbSkip() )
	
EndDo

nPrivez := 0

While !RefNiv->( Eof() )
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Refazer os niveis logo apos a sequencia de suprimentos:                    ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	(cRtAlias)->( DbGoTo( RefNiv->RE_CNO ) )
	
	nPriVez := Ascan( aNivs, { |x| x[1] == (cRtAlias)->CR_NIVEL } )
	
	If nPriVez == 0
		cMaxNiv := Soma1( cMaxNiv )
	Else
		If aNivs[nPriVez][2] == .f.
			cMaxNiv := Soma1( cMaxNiv )
			aNivs[nPriVez][2] := .t.
		EndIf
	EndIf
	
	(cRtAlias)->( RecLock(cRtAlias,.f.) )
	(cRtAlias)->CR_NIVEL  := cMaxNiv
	If !_lNegoc
		If !_lJa02
			(cRtAlias)->CR_STATUS := '01'
		Else
			_lJa02 := .f.
		EndIf
	Else
		(cRtAlias)->CR_STATUS := '01'
	EndIf
	(cRtAlias)->( MsUnLock() )
	
	FWrite( nPididu, "O aprovador ["+UsrFullName((cRtAlias)->CR_USER)+"] passou a ter o nivel ["+(cRtAlias)->CR_NIVEL+"] com Status: "+(cRtAlias)->CR_STATUS+cEol )
	RefNiv->( DbSkip() )
	
EndDo

RefNiv->( DbCloseArea() )
VerNiv->( DbCloseArea() )

MaxSup->( DbCloseArea() )


FWrite( nPididu, "Finalizacao da geracao da alcada de contratos e financeira."+cEol )

U_LiberaSC7(1, .f., _cGrupo)

// OS 3172-11 - MULTICATALOGO
//Se a rotina que criou o pedido for a do multicatalogo, refaz a alçada aprovada com as informações pre-definidas.

If AllTrim(Upper(FunName())) == "RIMPA081"
	FWrite( nPididu, "Inicia a liberação automatica dos pedidos multicatalogo."+cEol )
	
	cRefMC := " SELECT R_E_C_N_O_ AS RE_CNO FROM "+cRtTable
	cRefMC += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
	cRefMC += " AND   CR_TIPO    = 'PC' "
	cRefMC += " AND   CR_NUM     = '"+Alltrim((cRtAlias)->CR_NUM)+"' "
	cRefMC += " AND   CR_X_TPLIB <> 'S' "
	cRefMC += " AND   D_E_L_E_T_ = ' ' "
	cRefMC += " ORDER BY CR_NIVEL "
	
	U_MontaView( cRefMC, 'RefMC' )
	
	RefMC->( DbGoTop() )
	
	FWrite( nPididu, "Inicio da Gravação da aprovação automatica para a alçada do pedido ["+(cRtAlias)->CR_NUM+"] Multicatalogo."+cEol )
	While !RefMC->( Eof() )
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Busca os registros conforme a query:                    ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		(cRtAlias)->( DbGoTo( RefMC->RE_CNO ) )
		
		(cRtAlias)->( Reclock(cRtAlias,.F.) )
		(cRtAlias)->CR_USER		  := "TESTE"
		(cRtAlias)->CR_APROV	  := "TESTE2"
		(cRtAlias)->CR_LIBAPRO	  := "TESTE2"
		(cRtAlias)->CR_USERLIB	  := "TESTE"
		(cRtAlias)->CR_DATALIB	  := DATE()
		(cRtAlias)->CR_STATUS     := "03"
		(cRtAlias)->CR_VALLIB     := (cRtAlias)->CR_TOTAL
		(cRtAlias)->( MsUnlock() )
		
		RefMC->( DbSkip() )
		
	EndDo
	FWrite( nPididu, "Fim da Gravação da aprovação automatica para a alçada do pedido ["+(cRtAlias)->CR_NUM+"] Multicatalogo."+cEol )
	FWrite( nPididu, "Inicio da rotina de liberação do pedido."+cEol )
	
	U_LiberaSC7(1, .T., _cGrupo)
	
	FWrite( nPididu, "Fim da rotina de liberação do pedido."+cEol )
	RefMC->( DbCloseArea() )
EndIf

SC7->(RestArea(_aAreaSC7))
RestArea(_aAreaAnt)

Fclose( nPididu )

AcertaSCR()   //OS 3319-10

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LiberaSC7 ºAutor  ³ Sergio Oliveira    º Data ³  Out/2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a liberacao do SC7.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MT120GOK.Prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LiberaSC7(pnOpcao, plLibera, pcGrupo)

Local _cChave := ''
Local _nReg   := SC7->(Recno())

DbSelectArea('SC7')
DbSetOrder(1)
SC7->(DbGoTo(_nReg))
If FunName() $ 'MATA120/MATA121/MATA122/CNTA120/RIMPA081'
	DbSeek(xFilial('SC7')+cA120Num)
	_cChave := "xFilial('SC7')+cA120Num"
Else
	DbSeek(xFilial('SC7')+SC7->C7_NUM)
	_cSC7   := SC7->C7_NUM
	_cChave := "xFilial('SC7')+_cSC7"
EndIf

While !Eof() .And. SC7->(C7_FILIAL+C7_NUM) == &(_cChave)
	
	RecLock('SC7',.f.)
	SC7->C7_WF := ' '
	If plLibera
		SC7->C7_CONAPRO := 'L'
	Else
		SC7->C7_CONAPRO := 'B'
	EndIf
	SC7->C7_X_ENVFR := ' '
	SC7->C7_X_DTACT := Ctod('')
	If pcGrupo # Nil
		If !EMPTY( SB1->B1_X_APROV ) .And. AllTrim(Upper(FunName())) <> 'RIMPA081' //.And. pnOpcao = 2
			SC7->C7_APROV := SB1->B1_X_APROV
			SC7->C7_CONAPRO := 'B'
		Else
			SC7->C7_APROV := pcGrupo
		EndIf
	EndIf
	MsUnLock()
	
	DbSkip()
	
EndDo

Return

#Include 'Protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ TelaUsr ³ Autor   ³ Fabio Jadao Caires     ³ Data ³21/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³                                                              ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TelaUsr()

Local _aRet 	:= {}
Private oDlg

Private _oSolic
Private _cSolic	:= Space(14) //(06)

Private _oNome
Private _cNome		:= Space(30)

Private _oCC
Private _cCC		:= Space(15)

Private _oCCDesc
Private _cCCDesc	:= Space(30)

Private _oUser
Private _cUser		:= Space(06)


DEFINE MSDIALOG oDlg TITLE "Selecao de Solicitante" FROM 178,181 TO 365,867 PIXEL

@ 020,055 MsGet _oSolic	Var _cSolic F3 "SZIC" Size 060,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg Valid U_VlSol() When .T.
@ 019,120 MsGet _oNome	Var _cNome 				Size 200,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg READONLY When .T.
@ 021,008 Say "Solicitante" 						Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg

@ 033,055 MsGet _oCC 	Var _cCC 				Size 060,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.
@ 034,008 Say "Centro de Custo" 					Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg

@ 033,120 MsGet _oCCDesc Var _cCCDesc 			Size 200,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.

@ 047,008 Say "Cod. Usuario" 						Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 046,055 MsGet _oUser	Var _cUser 				Size 060,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF(  !Empty(_cUser),(_aRet := {_cUser,_cCC},oDlg:End()),""  )  },{|| U_VlOk()},,) CENTERED Valid U_VldBox(_aRet)

U_ProvPCInc()

Return _aRet

User Function VldBox(_aRet)
Local _lRet := .T.
If Len( _aRet ) < 2
	_lRet := .F.
	MsgAlert("Voce deve selecionar um solicitante !!!")
EndIf
Return _lRet

#Include 'Protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ TelaUsr2 ³ Autor  ³ Fabio Jadao Caires     ³ Data ³21/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Tela para pedido de compra direto (Sem SC)                   ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TelaUsr2()

Local _aRet 	:= {}
Private oDlg

Private _oSolic
Private _cSolic	:= Space(14) //(06)

Private _oNome
Private _cNome		:= Space(30)

Private _oCC
Private _cCC		:= Space(15)

Private _oCCDesc
Private _cCCDesc	:= Space(30)

Private _oUser
Private _cUser		:= Space(06)


DEFINE MSDIALOG oDlg TITLE "Selecao de Solicitante" FROM 178,181 TO 365,867 PIXEL

@ 020,055 MsGet _oSolic	Var _cSolic F3 "SZIB" Size 060,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg Valid U_VlSol1() When .T.
@ 019,120 MsGet _oNome	Var _cNome 				Size 200,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg READONLY When .T.
@ 021,008 Say "Solicitante" 						Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg

@ 033,055 MsGet _oCC 	Var _cCC 				Size 060,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.
@ 034,008 Say "Centro de Custo" 					Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg

@ 033,120 MsGet _oCCDesc Var _cCCDesc 			Size 200,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.

@ 047,008 Say "Cod. Usuario" 						Size 040,008 COLOR CLR_BLACK PIXEL OF oDlg
@ 046,055 MsGet _oUser	Var _cUser 				Size 060,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg When .F.

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIF(!Empty(_cUser),(_aRet := {_cUser,_cCC},oDlg:End()),""  )  },{|| U_VlOk()},,) CENTERED Valid U_VldBox2(_aRet)

U_ProvPCInc()

Return _aRet

User Function VldBox2(_aRet)
Local _lRet := .T.
If Len( _aRet ) < 2
	_lRet := .F.
	MsgAlert("Voce deve selecionar um solicitante !!!")
EndIf
Return _lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ ValSolic³ Autor   ³ Fabio Jadao Caires     ³ Data ³21/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Ajuste para consultar o solicitante correto para pedido      ³±±
±±³           ³ direto - OS 2391/14 e OS 2264/14                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function VlSol1()

Local lRet     := .T.
Local aArea    := GetArea()
Local aAreaSZI := SZI->(GetArea())

//SZI->( DbSetOrder(5) )

FWrite( nPididu, "Inicio da validacao do usuario solicitante selecionado manualmente"+cEol )
FWrite( nPididu, "Ordem 5 do SZI: "+Trim(SZI->( IndexKey() ))+cEol )
FWrite( nPididu, "Solicitante: "+_cSolic+cEol )

_aUser := {}

//// If SZI->(DbSeek( xFilial('SZI')+_cSolic ))   ja foi dado seek no sxb

//// 	PswOrder(2) // Ordem de nome do usuario     ja foi dado seek no sxb

//// 	If PswSeek( _cSolic )    ja foi dado seek no sxb

If _cCC == "               "
	
	cUsu := Posicione("SZI", 5, xFilial("SZI")+_cSolic+"1","ZI_USUARIO")
	cCust:= Posicione("SZI", 5, xFilial("SZI")+_cSolic+"1","ZI_CCUSTO")
	
	FWrite( nPididu, "_cSolic: "+_cSolic+cEol )
	
	aAdd(_aUser,{cUsu,cCust, _cSolic })
	
	_cNome 	 := UsrFullName(cUsu)
	_cCC	 := cCust
	_cCCDesc := POSICIONE("CTT",1,xFILIAL("CTT")+cCust,"CTT_DESC01")
	_cUser	 := cUsu
	
	FWrite( nPididu, "Encontrado no SZI: "+_cUser+cEol )
	
Else
	
	aAdd(_aUser,{SZI->ZI_USUARIO,SZI->ZI_CCUSTO, _cSolic })
	
	_cNome 	 := UsrFullName(SZI->ZI_USUARIO)
	_cCC	 := SZI->ZI_CCUSTO
	_cCCDesc := POSICIONE("CTT",1,xFILIAL("CTT")+SZI->ZI_CCUSTO,"CTT_DESC01")
	_cUser	 := SZI->ZI_USUARIO
	
EndIf


_oNome	 :Refresh()
_oCC	 :Refresh()
_oCCDesc :Refresh()
_oUser	 :Refresh()

SZI->(RestArea(aAreaSZI))
RestArea(aArea)

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ ValSolic³ Autor   ³ Fabio Jadao Caires     ³ Data ³21/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³                                                              ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function VlSol()

Local lRet     := .T.
Local aArea    := GetArea()
Local aAreaSZI := SZI->(GetArea())


FWrite( nPididu, "Inicio da validacao do usuario solicitante selecionado manualmente"+cEol )
FWrite( nPididu, "Ordem 5 do SZI: "+Trim(SZI->( IndexKey() ))+cEol )
FWrite( nPididu, "Solicitante: "+_cSolic+cEol )

_aUser := {}

FWrite( nPididu, "_cSolic: "+_cSolic+cEol )

aAdd(_aUser,{SZI->ZI_USUARIO,SZI->ZI_CCUSTO, _cSolic })

_cNome 	 := UsrFullName(SZI->ZI_USUARIO)
_cCC	 := SZI->ZI_CCUSTO
_cCCDesc := POSICIONE("CTT",1,xFILIAL("CTT")+SZI->ZI_CCUSTO,"CTT_DESC01")
_cUser	 := SZI->ZI_USUARIO

FWrite( nPididu, "Encontrado no SZI: "+_cUser+cEol )


_oNome	 :Refresh()
_oCC	 :Refresh()
_oCCDesc :Refresh()
_oUser	 :Refresh()

SZI->(RestArea(aAreaSZI))
RestArea(aArea)

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ VlOk    ³ Autor   ³ Fabio Jadao Caires     ³ Data ³21/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³                                                              ³±±
±±³           ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function VlOk()

MsgAlert("Voce deve informar um solicitante!")

Return .F.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ ExibLog  ºAutor  ³ Sergio Oliveira     ºData ³ Nov/2006    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibir as ocorrencias caso faltar alguma informacao.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ponto de Entrada M120Gok.prw                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ExibLog(pcDscLog)

Aviso("Houve problema na atualizacao do Pedido de Compras "+SC7->C7_NUM,pcDscLog,;
{"&Fechar"},3,"Problema no Pedido",,;
"PCOLOCK")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³MontaAprovºAutor  ³ TOTVS               ºData ³ Jun/2011    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta Aprovadores                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ponto de Entrada M120Gok.prw                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaAprov(_cCod,_cAprovPres,_nOpc,_nTipo)

Default _nTipo := 0

While (!(cRtSAL)->(Eof()) .And. (cRtSAL)->AL_COD == _cCod .And. !_lCapex) .Or. (!(cRtSAL)->(Eof()) .And. (cRtSAL)->AL_COD == _cCod .And. _lCapex .And. !((cRtSAL)->AL_APROV $ _cAprovPres)) //incluido o Alias SAL (Serginho)
	
	DbSelectArea('SAK')
	SAK->( DbSetOrder(1), DbSeek(xFilial('SAK')+(cRtSAL)->AL_APROV) )
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ O proprio solicitante nao poderar aprovar o seu pedido de compras pois o mesmo pode ser aprovador e   ³
	³ solicitante ao mesmo tempo.                                                                           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	FWrite( nPididu, "O solicitante nao podera ser aprovador de seu proprio documento - Inicio"+cEol )
	IF EMPTY(SC7->C7_CONTRA)   //MBARROS => OS 1487/14 NAO CONSIDERAR ESTE TRATAMENTO QUANDO FOR DE CONTRATO MANTENDO A REGRA PARA DEMAIS PROCESSO QUE NAO VIER DE CONTRATO
		If Empty( SC7->C7_NUMSC )
			If (cRtSAL)->AL_USER == _aUser[1][1]
				FWrite( nPididu, "Ignorando como aprovador o solicitante "+UsrFullName((cRtSAL)->AL_USER)+cEol )
				_cNivelSol := Soma1((cRtSAL)->AL_NIVEL)
				(cRtSAL)->(DbSkip())
				Loop
			EndIf
		Else
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ # Chamado 004104: Correcao da verificacao do aprovador x solicitante       ³
			³                   quando houver solicitacao de compras:                    ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			SC1->( DbSetOrder(1), DbSeek(SC7->C7_FILIAL+SC7->C7_NUMSC) )
			
			PswOrder(2) // Ordem de nome do usuario
			PswSeek( SC1->C1_SOLICIT )
			
			If (cRtSAL)->AL_USER == PswId()
				FWrite( nPididu, "Ignorando como aprovador o solicitante "+UsrFullName((cRtSAL)->AL_USER)+cEol )
				_cNivelSol := Soma1((cRtSAL)->AL_NIVEL)
				(cRtSAL)->(DbSkip())
				Loop
			EndIf
		EndIf
		FWrite( nPididu, "O solicitante nao podera ser aprovador de seu proprio documento - Fim"+cEol )
	ELSE
		FWrite( nPididu, "O solicitante podera ser aprovador de seu proprio documento quando tratar-se de contrato - Fim"+cEol )
	ENDIF
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Campo AL_AUTOLIM: Igual a "N", incluir o aprovador/vistador no roteiro de aprovacao. Igual a "S", res-³
	³                   peitar o valor da alcada.                                                           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	FWrite( nPididu, "LINE: "+AllTrim(Str(ProcLine()))+" (cRtSAL)->AL_AUTOLIM: "+(cRtSAL)->AL_AUTOLIM+" TOTPED->VALPED: "+Transform(TOTPED->VALPED, "@R 999,999,999.99")+" SAK->AK_LIMMIN: "+Transform(SAK->AK_LIMMIN, "@R 999,999,999.99")+" SAK->AK_LIMMAX: "+Transform(SAK->AK_LIMMAX, "@R 999,999,999.99")+" Verificar se o aprovador "+UsrFullName((cRtSAL)->AL_USER)+" (cRtSAL)->AL_NIVEL: "+(cRtSAL)->AL_NIVEL+" _cNivelSol: "+_cNivelSol+" precisara entrar na alcada de aprovacao"+cEol )
	If (cRtSAL)->AL_AUTOLIM == 'N' .Or. (TOTPED->VALPED >= SAK->AK_LIMMIN .And. TOTPED->VALPED <= SAK->AK_LIMMAX) .OR. (cRtSAL)->AL_NIVEL == _cNivelSol
		
		If Ascan( _aAprov, (cRtSAL)->AL_APROV ) > 0 .Or. (cRtSAL)->AL_USER == xAprosu
			
			FWrite( nPididu, "LINE: "+AllTrim(Str(ProcLine()))+" (cRtAlias)->CR_APROV: "+(cRtAlias)->CR_APROV+" (cRtSAL)->AL_USER: "+(cRtSAL)->AL_USER+" "+UsrFullName((cRtSAL)->AL_USER)+" xAprosu: "+xAprosu+cEol )
			_lxAprov := .t.
			
			DbSelectArea(cRtSAL)
			DbSkip()
			Loop
			
		EndIf
		
		If _nOpc == 1 .And. SAK->AK_LIMMIN > _nVlQuebra .And. _nVlQuebra > 0 .And. _nTipo == 1
			FWrite( nPididu, "Ignorando o aprovador [ "+SAK->AK_NOME + " ] pela quebra"+cEol )
			(cRtSAL)->(DbSkip())
			Loop
		EndIf
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Verificar se o solicitante como aprovador esta presente no fluxo da aprovacao financeira. Em caso afir³
		³ mativo, ler a partir dele para frente INCLUINDO O APROVADOR FINANCEIRO:                               ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		FWrite( nPididu, "LINE: "+AllTrim(Str(ProcLine()))+" SAK->AK_COD: "+SAK->AK_COD+" Verificar se o aprovador "+(cRtSAL)->AL_USER+" "+UsrFullName((cRtSAL)->AL_USER)+" PRECISARA SER IGNORADO"+cEol )
		If !(cRtSAL)->AL_USER $ GetMV('MV_X_APFN')
			FWrite( nPididu, "LINE: "+AllTrim(Str(ProcLine()))+cEol )             //MBARROS => OS 1487/14 NAO CONSIDERAR ESTE TRATAMENTO QUANDO FOR DE CONTRATO MANTENDO A REGRA PARA DEMAIS PROCESSO QUE NAO VIER DE CONTRATO
			If !Empty( xAprov ) .And. (cRtSAL)->AL_USER # xAprosu .And. !_lxAprov .AND. EMPTY(SC7->C7_CONTRA)
				FWrite( nPididu, "LINE: "+AllTrim(Str(ProcLine()))+cEol )
				_lxAprov := .t.
				DbSelectArea(cRtSAL)
				DbSkip()
				Loop
			EndIf
		EndIf
		
		FWrite( nPididu, "LINE: "+AllTrim(Str(ProcLine()))+cEol )
		Aadd( _aAprov, (cRtSAL)->AL_APROV )
		
		_nAlcAnt := SAK->AK_LIMMAX
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Antes de gravar os dados dentro da tabela de alcadas de aprovacao, obter os dados de compras.         ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		__aArea    := GetArea()         // guardando area atual
		__aAreaSC7 := SC7->(GetArea())  // guardando area atual do pedido de compras
		__aAreaSC1 := SC1->(GetArea())  // guardando area atual da solicitacao de compras
		__aAreaCTT := CTT->(GetArea())  // guardando area atual do centro de custo
		__aAreaSA2 := SA2->(GetArea())  // guardando area atual do cadastro de fornecedor
		
		__cPcNum   := SC7->C7_NUM
		__cDescPrd := ''
		__cSolicit := ''
		__cNomFor  := Alltrim(Posicione("SA2", 1, xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA),"A2_NOME"))
		__cCCDesc  := Alltrim(Posicione("CTT", 1, SC7->(C7_FILIAL+_aUser[1][2]),"CTT_DESC01"))
		
		SC1->(dbSetOrder(1))
		If SC1->(dbSeek(SC7->C7_FILIAL+SC7->C7_NUMSC))
			__cSolicit := UsrFullName(SC1->C1_USER)
		EndIf
		
		RestArea(__aAreaCTT)
		RestArea(__aAreaSA2)
		RestArea(__aAreaSC1)
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Sergio em 22/Jan/2008: Correcao: Posicionar no pedido de compras e testar ³
		³                        se nao eh final de arquivo. Como nao ha a verifica-³
		³                        cao de final de arquivo, quando chegava no ultimo  ³
		³                        registro do pedido, este while ficava em loop e o  ³
		³                        tamanho da string ultrapassava o limite de string  ³
		³                        de 64 kb gerando assim o error.log                 ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+__cPcNum ) )
		While !SC7->( Eof() ) .And. __cPcNum == SC7->C7_NUM
			__cDescPrd += Alltrim(SC7->C7_DESCRI)
			SC7->(dbSkip())
			If __cPcNum == SC7->C7_NUM
				__cDescPrd += ', '
			EndIf
		EndDo
		
		SC7->( RestArea(__aAreaSC7) )
		RestArea(__aArea)
		
		If Len( aStats ) == 0
			_cStatus := '02'
		EndIf
		
		(cRtAlias)->( Reclock(cRtAlias,.t.) )
		(cRtAlias)->CR_FILIAL		:= xFilial("SCR")
		(cRtAlias)->CR_NUM			:= SC7->C7_NUM
		(cRtAlias)->CR_TIPO		:= 'PC'
		If Ascan( aAprovs, SAK->AK_USER ) == 0
			Aadd( aAprovs, SAK->AK_USER )
		EndIf
		nSeek := Ascan( aStats, { |x| x[1] == (cRtSAL)->AL_NIVEL } )
		If nSeek == 0
			Aadd( aStats, { (cRtSAL)->AL_NIVEL, _cStatus } )
			nSeek := Len( aStats )
		EndIf
		(cRtAlias)->CR_NIVEL	:= (cRtSAL)->AL_NIVEL
		(cRtAlias)->CR_USER		:= SAK->AK_USER
		(cRtAlias)->CR_APROV	:= SAK->AK_COD
		(cRtAlias)->CR_STATUS	:= aStats[nSeek][2] // Sergio em Mai/2007: (Ajuste) - Continuacao
		(cRtAlias)->CR_TOTAL	:= TOTPED->VALPED
		(cRtAlias)->CR_EMISSAO 	:= Date()
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Flegar a aprovacao financeira.                                                                        ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		(cRtAlias)->CR_X_TPLIB 	:= 'A'
		(cRtAlias)->CR_MOEDA	:= 1
		(cRtAlias)->CR_TXMOEDA 	:= 1
		(cRtAlias)->CR_XDESCPR 	:= __cDescPrd  	// Descricao dos produtos contido no pedido de compras
		(cRtAlias)->CR_XNOMFOR 	:= __cNomFor   	// nome do fornecedor do PC
		(cRtAlias)->CR_XNOMSOL 	:= __cSolicit   // nome do solicitado do primeiro item do PC contido na SC
		(cRtAlias)->CR_XCC     	:= _aUser[1][2]// SC7->C7_CC  // Centro de custo
		(cRtAlias)->CR_XCCDESC 	:= __cCCDesc   	// descricao do centro de custo
		(cRtAlias)->( MsUnlock() )
		FWrite( nPididu, "O aprovador "+UsrFullName((cRtSAL)->AL_USER)+" entrou na alcada de aprovacao no nivel "+(cRtSAL)->AL_NIVEL+' -> Conforme SAL com Status: '+(cRtAlias)->CR_STATUS+cEol )
		
		_cStatus := '01'
		_lJa02   := .t.
	Else
		FWrite( nPididu, "O aprovador "+UsrFullName((cRtSAL)->AL_USER)+" NÃO entrou na alcada de aprovacao no nivel "+(cRtSAL)->AL_NIVEL+cEol )
	EndIf
	
	(cRtSAL)->(DbSkip())
EndDo

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AcertaSCR ºAutor  ³ TOTVS               ºData ³ Jun/2011    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acerta niveis do SCR                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ponto de Entrada M120Gok.prw                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AcertaSCR()

Local _aArea  := GetArea()
Local _cQuery := ""
Local _cNivel := "01"

_cQuery := "SELECT SCR.R_E_C_N_O_ AS RECNO FROM " + RetSqlName("SCR") + " SCR WHERE "
_cQuery += "SCR.CR_FILIAL = '" + xFilial("SCR") + "' AND "
_cQuery += "SCR.CR_TIPO = 'PC' AND "
_cQuery += "SCR.CR_NUM = '" + SC7->C7_NUM + "' AND "
_cQuery += "SCR.D_E_L_E_T_ = ' ' "
_cQuery += "ORDER BY SCR.R_E_C_N_O_"

U_MontaView( _cQuery, "TSCR" )
TSCR->(dbGoTop())

While !TSCR->(EOF())
	dbSelectArea("SCR")
	dbGoTo(TSCR->RECNO)
	RecLock("SCR",.F.)
	SCR->CR_NIVEL := _cNivel
	SCR->CR_STATUS := IIF(_cNivel == "01","02","01")
	MsUnlock()
	_cNivel := Soma1(_cNivel)
	TSCR->(dbSkip())
EndDo
TSCR->(dbCloseArea())

RestArea(_aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProvPCInc ºAutor  ³Douglas David       º Data ³  17/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processamento das Provisoes Contabeis                       º±±
±±º          ³Limpa o campo ZB1_SITPC - E=EXCLUIDO 						  º±±
±±º          ³Para retornar o status.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CSU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ProvPCInc()

Local _cQuery
Local _aArea	:= GetArea()
Local _aAreaSC7 := SC7->(GetArea())
Local cProvisAnt:= ""

Private cAlias  :="_WORK"

_cQuery := "SELECT ZB1_PROVIS, ZB1.R_E_C_N_O_ RECZB1, ZB2.R_E_C_N_O_ RECZB2 "
_cQuery +=   "FROM "+RetSqlName("ZB1")+" ZB1, "+RetSqlName("ZB2")+" ZB2 "
_cQuery +=  "WHERE ZB1_FILIAL='"+xFilial("ZB1")+"' AND ZB1.D_E_L_E_T_ <> '*' "
_cQuery +=    "AND ZB2_FILIAL='"+xFilial("ZB2")+"' AND ZB2.D_E_L_E_T_ <> '*' "
_cQuery +=    "AND ZB2_FORNEC+ZB2_LOJA='"+SC7->(C7_FORNECE+C7_LOJA)+"' "
_cQuery +=    "AND ZB2_PEDCOM='"+SC7->C7_NUM+"' "
_cQuery +=    "AND ZB1_PROVIS=ZB2_PROVIS "
_cQuery += "ORDER BY RECZB1, RECZB2 "
_cQuery:= ChangeQuery( _cQuery )

If Select (cAlias) > 0
	_WORK->(dbCloseArea())
EndIf

TcQuery _cQuery New Alias "_WORK"

dbSelectArea("_WORK")
dbGoTop()

If _WORK->(Eof().And.Bof())
	_WORK->(dbCloseArea())
	Return
EndIf

While _WORK->(!Eof())
	
	If _WORK->ZB1_PROVIS!=cProvisAnt
		
		cProvisAnt := _WORK->ZB1_PROVIS
		
		dbSelectArea("ZB1")
		ZB1->(dbGoTo(_WORK->RECZB1))
		RecLock("ZB1",.F.)
		ZB1->ZB1_PCEXC := ""
		MsUnLock()
		
	EndIf
	
	dbSelectArea("_WORK")
	dbSkip()
	
EndDo

_WORK->(dbCloseArea())
RestArea(_aAreaSC7)
RestArea(_aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ TrazCCUn  ³ Autor   ³ Douglas Coelho	   ³ Data ³08/08/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Copiar os campos CC, Un.Neg. e Operação para o PC, ao gerar  ³±±
±³            ³ Medição - Gestão de Contratos OS 2188/16                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TrazCCUn()

Local cTmpx     := "cTmpx"       
Local aArea		:= GetArea() // Eduardo Dias - OS 2961/16 

dbSelectArea("CNE")
dbSetOrder(1)

//Posiciona nos itens da medicao
dbSeek(xFilial("CNE")+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO+CND->CND_NUMMED,.F.)

cContra := CND->CND_CONTRA
cRev    := CND->CND_REVISA
cNumero := CND->CND_NUMERO
cNumed  := CND->CND_NUMMED

cQuery:=" SELECT * FROM CNE050 "
cQuery+=" WHERE CNE_CONTRA = '"+cContra+ "' "
cQuery+=" AND CNE_REVISA = '"+cRev+"' "
cQuery+=" AND CNE_NUMERO = '"+cNumero+"' "
cQuery+=" AND CNE_NUMMED = '"+cNumed+"' "
cQuery+=" AND CNE_QUANT <> 0 "
cQuery+=" AND D_E_L_E_T_= '' "

If Select("cTmpx") > 0
	dbSelectArea("cTmpx")
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmpx, .F., .T. )

DBSELECTAREA("cTmpx")
cTmpx->(dbGoTop())

cItem 	 := 1

While !cTmpx->(Eof())   

    cDescSc7 := Alltrim(POSICIONE("SB1",1,xFILIAL("SB1")+Alltrim(cTmpx->CNE_PRODUT),"B1_DESC")) //OS 0176/17 - Douglas Coelho
	cCC      := cTmpx->CNE_X_SOLI
	cUnne    := cTmpx->CNE_X_UNNE
	cOper    := cTmpx->CNE_X_OPER
	//cItem    := Strzero(val(cTmpx->CNE_ITEM),4)
	cIteMed  := Strzero(cItem,4) //OS 2301/17 - Douglas Coelho
	
	DbSelectArea("SC7")
	DBSetOrder(14)
	
	If DbSeek( xFilial()+ cA120Num + cIteMed)
		Reclock( "SC7", .F. )    
		SC7->C7_DESCRI   := cDescSc7
		SC7->C7_CC       := cCC
		SC7->C7_ITEMCTA  := cUnne
		SC7->C7_CLVL     := cOper
		Msunlock()
	Endif
	
	cTmpx->(DbSkip())
	cItem++
Enddo

cTmpx->( DbCloseArea() )    

DbSelectArea("SC7")
DBSetOrder(1)
SC7->(dbGoTop())
SC7->(DbSeek(xFilial("SC7")+cA120Num) ) // Eduardo Dias - OS 2961/16 - Recupara o posicionamento do SC7
            
RestArea(aArea) // Eduardo Dias - OS 2961/16 

Return
               