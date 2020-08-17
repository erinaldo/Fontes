#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110ROT  ºAutor  ³ Sergio Oliveira    º Data ³  Ago/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para definir novos itens de menu no browseº±±
±±º          ³ das Solicitacoes de Compras.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU - Modulo de Compras                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT110ROT()

Local aDevolv := aClone( aRotina )

If SY1->( DbSetOrder(3), DbSeek( xFilial('SY1')+__cUserId ) )
	aAdd(aDevolv, { "Devolver","U_DevolvSC()"	, 0 , 1})
EndIf

Return( aDevolv )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³DevolvSC  ºAutor  ³ Sergio Oliveira    º Data ³  Ago/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Processamento da rotina.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MT110Rot.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function DevolvSC()

Local lDigTxt := .f.
Local cMemoD  := Space(10)         

If Existpc() // Caso existir pedido de compra, nao permitir a devolução.
	cMsg := "Existe pedido de compra vinculado a esta Solicitação de compra. "
	cMsg += CHR(13)+CHR(10)+"Esta operação não poderá ser concluída!"
	Aviso("Atenção",cMsg,{'Ok'},3,"SC Atendida",,"PCOLOCK")
	Return
EndIf

If Select('ZAB') == 0
   ChkFile('ZAB')
EndIf

Define MSDialog oDlMkwg Title " " From 86,305 To 357,858 of oMainWnd PIXEL

@ 004,006 To 134,268
@ 004,218 To 134,268
@ 039,006 To 134,218
@ 016,023 Say "Devolução da Solicitação ao Usuário" Size 170,014
@ 056,017 Get cMemoD Memo Size 191,068
@ 046,226 Button "Confirmar" Size 036,016 Action( IIF( Devolver(cMemoD), ( lDigTxt := .t., oDlMkwg:End() ), .f. ) )
@ 067,226 Button "Sair"      Size 036,016 Action( ( lDigTxt := .t., oDlMkwg:End() ) )

Activate MsDialog oDlMkwg Centered Valid lDigTxt

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Devolver  ºAutor  ³ Sergio Oliveira    º Data ³  Ago/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua a gravacao da legenda bem como o texto da devolucao.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MT110Rot.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Devolver(cMemoD)

Local cUpd, cTxtBlq
Local cEol     := Chr(13)+Chr(10)
Local cMens    := "Devolução da Solicitação de Compra"
Local cPriLin  := "Se deseja realmente efetuar esta operação, "

If Empty( cMemoD )

	Aviso("Motivo da Devolução","Informe o motivo da devolução.",;
	{"&Fechar"},3,"Devolver SC",,;
	"PCOLOCK")

Else

    cUpd := " UPDATE "+RetSqlName( 'SC1' )
    cUpd += " SET C1_APROV = 'X' "
    cUpd += " WHERE C1_FILIAL  = '"+SC1->C1_FILIAL+"' "
    cUpd += " AND   C1_NUM     = '"+SC1->C1_NUM+"' "
    cUpd += " AND   D_E_L_E_T_ = ' ' "
    
    If TcSqlExec( cUpd ) # 0
		cTxtBlq := "Ocorreu um problema no momento da gravacao do campo referente a justificativa da devolução. "
		cTxtBlq += "Entre em contato com a area de Sistemas ERP informando a mensagem "
		cTxtBlq += "a seguir: "+cEol+cEol+TcSqlError()
		Aviso("Texto da Devolucao",cTxtBlq,	{"&Fechar"},3,"Justificativa da Devolução",,"PCOLOCK")
    Else
		If !U_CodSegur(cMens, cPriLin)
			Aviso(cMens,"Operação nao Confirmada",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
			Return( .f. )
		EndIf
        ZAB->( RecLock('ZAB',.t.) )
        ZAB->ZAB_FILIAL := xFilial('ZAB')
        ZAB->ZAB_NUM    := SC1->C1_NUM
        ZAB->ZAB_SEQ    := SeqZAB(SC1->C1_NUM)
        ZAB->ZAB_JUSTIF := cMemoD
        ZAB->ZAB_RESPON := cUserName
        ZAB->ZAB_NOME   := UsrFullName( __cUserId )
        ZAB->ZAB_MAKINA := GetComputerName()
        ZAB->ZAB_DATA_  := Date()
        ZAB->ZAB_HORA   := Time()
        ZAB->( MsUnLock() )
        
		cAssunto := "Solicitação de Compras: "+SC1->C1_FILIAL+'/'+SC1->C1_NUM+" - DEVOLVIDA!"
		cTitulo  := 'Solicitação de Compra Nro. '+SC1->C1_FILIAL+'/'+SC1->C1_NUM
		cDetalhe := 'A sua solicitação de compra foi devolvida pela área de procurement. Visualize a sua Solicitação de Compra '
		cDetalhe += 'e clique no novo botão "DEVOLUÇÕES" presente na barra de botões para consultar a razão desta devolução. '
		_cUsuario := SC1->C1_USER
		U_Rcomw06(cAssunto, cTitulo, cDetalhe, _cUsuario)
                
    EndIf
    
EndIf

Return( !Empty( cMemoD ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ SeqZAB   ºAutor  ³ Sergio Oliveira    º Data ³  Ago/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Obtem a proxima sequencia para a tabela ZAB de acordo com oº±±
±±º          ³ ultimo numero da SC nesta tabela.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MT110Rot.prw                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SeqZAB(cNumSC)

Local cUltSeqs

cUltSeqs := " SELECT MAX(ZAB_SEQ) AS MAXSEQ FROM "+RetSqlName('ZAB')
cUltSeqs += " WHERE ZAB_FILIAL = '"+xFilial('ZAB')+"' "
cUltSeqs += " AND   ZAB_NUM    = '"+cNumSC+"' "
cUltSeqs += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cUltSeqs, 'cUltSeq' )

cUltSeq->( DbGoTop() )

cUltSeqs := Soma1( cUltSeq->MAXSEQ )
             
Return( cUltSeqs )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ Existpc ºAutor  ³ Douglas David       º Data ³  Jun/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verificar se algum item da SC possui pedido de compra.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Existpc()

Local aAreaAnt := GetArea()
Local cNextAli := GetNextAlias()
Local lRetorna := .t.
Local cQry

cQry := " SELECT COUNT(*) AS QTOS "
cQry += " FROM "+RetSqlName('SC1')
cQry += " WHERE C1_NUM    = '"+SC1->C1_NUM+"' "
cQry += " AND   C1_PEDIDO <> '' "
cQry += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cQry, cNextAli )

(cNextAli)->( DbGotop() )

lRetorna := (cNextAli)->QTOS > 0

(cNextAli)->( DbCloseArea() )

RestArea( aAreaAnt )

Return( lRetorna )

