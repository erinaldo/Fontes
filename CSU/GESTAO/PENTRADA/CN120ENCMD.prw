#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CN120ENCMDºAutor  ³ Sergio Oliveira     ºData ³ Abr/2008    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetuar a geracao das alcadas de contratos.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Encerramento de Medicao.                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN120ENCMD()

Local aAreaAnt := GetArea()
Local _bStatus := '02', _xAliasT := GetNextAlias(), _xNivel := '01'
Local cKueri, _xExec

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ # Chamado 004034: Se a tentativa de criacao do PC nao tiver sucesso, a va- ³
³                   riavel _xNumPC nao ira existir. Neste caso, devera ser   ³
³                   ignorado o processo da geracao do gestor tecnico.        ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

If Type( '_xNumPC' ) == 'U'
    Return
EndIf

SC7->( DbSetOrder(1), DbSeek( xFilial('SC7')+_xNumPC ) )

cKueri := " SELECT DISTINCT CNB_X_GTEC "
cKueri += " FROM "+RetSqlName('CNE')+" CNE, "+RetSqlName('CNB')+" CNB "
cKueri += " WHERE CNE_FILIAL = '"+xFilial('CNE')+"' "
cKueri += " AND   CNE_CONTRA = '"+SC7->C7_CONTRA +"' "
cKueri += " AND   CNE_NUMERO = '"+SC7->C7_PLANILH+"' "
cKueri += " AND   CNE_NUMMED = '"+SC7->C7_MEDICAO+"' "
cKueri += " AND   CNE_ITEM   = '"+SC7->C7_ITEMED +"' "
cKueri += " AND   CNE_REVISA = '"+SC7->C7_CONTREV+"' "
cKueri += " AND   CNE.D_E_L_E_T_ = ' ' "
cKueri += " AND   CNB_FILIAL = CNE_FILIAL "
cKueri += " AND   CNB_CONTRA = CNE_CONTRA "
cKueri += " AND   CNB_NUMERO = CNE_NUMERO "
cKueri += " AND   CNB_PRODUT = CNE_PRODUT "
cKueri += " AND   CNB.D_E_L_E_T_ = ' ' "

U_MontaView( cKueri, _xAliasT )

(_xAliasT)->( DbGoTop() )

SA2->( DbSetOrder(1), DbSeek( xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA) ) )

While !(_xAliasT)->( Eof() )
	
	SAK->( DbSetOrder(1), DbSeek( xFilial('SAK')+(_xAliasT)->CNB_X_GTEC ) )
	
	DbSelectArea('SCR')
	Reclock("SCR",.T.)
	SCR->CR_FILIAL	:= xFilial("SCR")
	SCR->CR_NUM		:= SC7->C7_NUM
	SCR->CR_TIPO	:= 'PC'
	SCR->CR_NIVEL	:= _xNivel
	SCR->CR_USER	:= SAK->AK_USER
	SCR->CR_APROV	:= SAK->AK_COD
	SCR->CR_STATUS  := _bStatus
	SCR->CR_TOTAL	:= TOTPED->VALPED
	SCR->CR_EMISSAO := Date()
	SCR->CR_X_TPLIB := 'A'
	SCR->CR_MOEDA	:= 1
	SCR->CR_TXMOEDA := 1
	SCR->CR_XNOMFOR := SA2->A2_NOME
	MsUnlock()
	
	_bStatus := '01'
	_xNivel  := Soma1( _xNivel )
	
	(_xAliasT)->( DbSkip() )
	
EndDo

// Agora, devera ser gerado o aprovador financeiro. Mas caso nao exista o gestor tecnico,
// nao devera ser gerado apenas o aprovador financeiro:

If _bStatus == '01'
	
	SAK->( DbSetOrder(1), DbSeek( xFilial('SAK')+GetNewPar('MV_X_APFIN','000099') ) )
	
	DbSelectArea('SCR')
	Reclock("SCR",.T.)
	SCR->CR_FILIAL	:= xFilial("SCR")
	SCR->CR_NUM		:= SC7->C7_NUM
	SCR->CR_TIPO	:= 'PC'
	SCR->CR_NIVEL	:= _xNivel
	SCR->CR_USER	:= SAK->AK_USER
	SCR->CR_APROV	:= SAK->AK_COD
	SCR->CR_STATUS  := _bStatus
	SCR->CR_TOTAL	:= TOTPED->VALPED
	SCR->CR_EMISSAO := Date()
	SCR->CR_X_TPLIB := 'A'
	SCR->CR_MOEDA	:= 1
	SCR->CR_TXMOEDA := 1
	SCR->CR_XNOMFOR := SA2->A2_NOME
	MsUnlock()
	
EndIf

_xExec := " UPDATE "+RetSqlName('SC7')+" SET C7_APROV = 'GCTGCT' "
_xExec += " WHERE C7_FILIAL  = '"+xFilial('SC7')+"' "
_xExec += " AND   C7_NUM     = '"+SC7->C7_NUM+"' "
_xExec += " AND   D_E_L_E_T_ = ' ' "

TcSqlExec( _xExec )

RestArea( aAreaAnt )

_xNumPC := Nil  // Destruir a variavel publica para nao conflitar

Return