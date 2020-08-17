#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110ROT  �Autor  � Sergio Oliveira    � Data �  Ago/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para definir novos itens de menu no browse���
���          � das Solicitacoes de Compras.                               ���
�������������������������������������������������������������������������͹��
���Uso       � CSU - Modulo de Compras                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function MT110ROT()

Local aDevolv := aClone( aRotina )

If SY1->( DbSetOrder(3), DbSeek( xFilial('SY1')+__cUserId ) )
	aAdd(aDevolv, { "Devolver","U_DevolvSC()"	, 0 , 1})
EndIf

Return( aDevolv )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �DevolvSC  �Autor  � Sergio Oliveira    � Data �  Ago/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Processamento da rotina.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � MT110Rot.prw                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function DevolvSC()

Local lDigTxt := .f.
Local cMemoD  := Space(10)         

If Existpc() // Caso existir pedido de compra, nao permitir a devolu��o.
	cMsg := "Existe pedido de compra vinculado a esta Solicita��o de compra. "
	cMsg += CHR(13)+CHR(10)+"Esta opera��o n�o poder� ser conclu�da!"
	Aviso("Aten��o",cMsg,{'Ok'},3,"SC Atendida",,"PCOLOCK")
	Return
EndIf

If Select('ZAB') == 0
   ChkFile('ZAB')
EndIf

Define MSDialog oDlMkwg Title " " From 86,305 To 357,858 of oMainWnd PIXEL

@ 004,006 To 134,268
@ 004,218 To 134,268
@ 039,006 To 134,218
@ 016,023 Say "Devolu��o da Solicita��o ao Usu�rio" Size 170,014
@ 056,017 Get cMemoD Memo Size 191,068
@ 046,226 Button "Confirmar" Size 036,016 Action( IIF( Devolver(cMemoD), ( lDigTxt := .t., oDlMkwg:End() ), .f. ) )
@ 067,226 Button "Sair"      Size 036,016 Action( ( lDigTxt := .t., oDlMkwg:End() ) )

Activate MsDialog oDlMkwg Centered Valid lDigTxt

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �Devolver  �Autor  � Sergio Oliveira    � Data �  Ago/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Efetua a gravacao da legenda bem como o texto da devolucao.���
�������������������������������������������������������������������������͹��
���Uso       � MT110Rot.prw                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

Static Function Devolver(cMemoD)

Local cUpd, cTxtBlq
Local cEol     := Chr(13)+Chr(10)
Local cMens    := "Devolu��o da Solicita��o de Compra"
Local cPriLin  := "Se deseja realmente efetuar esta opera��o, "

If Empty( cMemoD )

	Aviso("Motivo da Devolu��o","Informe o motivo da devolu��o.",;
	{"&Fechar"},3,"Devolver SC",,;
	"PCOLOCK")

Else

    cUpd := " UPDATE "+RetSqlName( 'SC1' )
    cUpd += " SET C1_APROV = 'X' "
    cUpd += " WHERE C1_FILIAL  = '"+SC1->C1_FILIAL+"' "
    cUpd += " AND   C1_NUM     = '"+SC1->C1_NUM+"' "
    cUpd += " AND   D_E_L_E_T_ = ' ' "
    
    If TcSqlExec( cUpd ) # 0
		cTxtBlq := "Ocorreu um problema no momento da gravacao do campo referente a justificativa da devolu��o. "
		cTxtBlq += "Entre em contato com a area de Sistemas ERP informando a mensagem "
		cTxtBlq += "a seguir: "+cEol+cEol+TcSqlError()
		Aviso("Texto da Devolucao",cTxtBlq,	{"&Fechar"},3,"Justificativa da Devolu��o",,"PCOLOCK")
    Else
		If !U_CodSegur(cMens, cPriLin)
			Aviso(cMens,"Opera��o nao Confirmada",{"&Fechar"},3,"Nao Confirmado",,"PCOLOCK")
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
        
		cAssunto := "Solicita��o de Compras: "+SC1->C1_FILIAL+'/'+SC1->C1_NUM+" - DEVOLVIDA!"
		cTitulo  := 'Solicita��o de Compra Nro. '+SC1->C1_FILIAL+'/'+SC1->C1_NUM
		cDetalhe := 'A sua solicita��o de compra foi devolvida pela �rea de procurement. Visualize a sua Solicita��o de Compra '
		cDetalhe += 'e clique no novo bot�o "DEVOLU��ES" presente na barra de bot�es para consultar a raz�o desta devolu��o. '
		_cUsuario := SC1->C1_USER
		U_Rcomw06(cAssunto, cTitulo, cDetalhe, _cUsuario)
                
    EndIf
    
EndIf

Return( !Empty( cMemoD ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � SeqZAB   �Autor  � Sergio Oliveira    � Data �  Ago/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Obtem a proxima sequencia para a tabela ZAB de acordo com o���
���          � ultimo numero da SC nesta tabela.                          ���
�������������������������������������������������������������������������͹��
���Uso       � MT110Rot.prw                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � Existpc �Autor  � Douglas David       � Data �  Jun/2015   ���
�������������������������������������������������������������������������͹��
���Descricao � Verificar se algum item da SC possui pedido de compra.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

