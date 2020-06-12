#Include 'Protheus.ch'
#Include "TBICONN.CH"

/*-----------------+---------------------------------------------------------+
!Nome              ! MTA410E - Cliente: Madero                              !
+------------------+---------------------------------------------------------+
!Descrição         ! PE apos exclusao  de Pedido de Venda na fabrica         !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 01/06/2018                                              !
+------------------+--------------------------------------------------------*/
user function MTA410E(IXBPAD)
	Local cFil
	Local cPed
	Local aParm
	if SC6->(FieldPos("C6_XFILORI")) > 0 .and. val(SC6->C6_ITEM) = 1
		cFil := SC6->C6_XFILORI
		cPed := left(SC6->C6_PEDCLI,6)
		if !empty(cPed)
			// TODO - criar parametro na fabrica para o grupo de empresas dos restaurantes 
			// que ficou fixo com 02.
			aParm := {"02", cFil, cPed, UsrRetName(RetCodUsr())}
			startJob("U_ARETSC7", GetEnvServer(), .T., aParm)
		Endif
	EndIf
return 

/*-----------------+---------------------------------------------------------+
!Nome              ! ARETSC7 - Cliente: Madero                               !
+------------------+---------------------------------------------------------+
!Descrição         ! Retornar status do Pedido de compra dos restaurantes    !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 01/06/2018                                              !
+------------------+--------------------------------------------------------*/
User Function ARETSC7(paramixb)
	// Parametros recebidos da rotina "pai"
    Local _cEmpresa := paramixb[1] // Empresa restaurante
    Local _cFilial  := paramixb[2] // Filial fabrica
    Local cPedido   := paramixb[3] // numero do pedido
    Local cUsrexc   := paramixb[4] // nome usuario de exclusao
    Prepare Environment Empresa _cEmpresa filial _cFilial Tables "SC7" Modulo "COM"
//    	conout('Alterar pedido de compra '+varinfo("paramixb",paramixb))
		SC7->(dbSetOrder(1))
		SC7->(dbSeek(_cFilial+cPedido))
		while !SC7->(eof()) .and. SC7->C7_FILIAL+SC7->C7_NUM = _cFilial+cPedido
			if !empty(SC7->C7_XEMAIL)
//				conout('Alterou PC '+_cFilial+cPedido)
				RecLock("SC7", .f.)
				SC7->C7_XENVCR  := 'P'
				SC7->C7_XEMAIL  := ''
				SC7->C7_XDTEXPV := dDataBase
				SC7->C7_XUSEREX := cUsrexc
				SC7->(MsUnlock())
			EndIf
			SC7->(dbSkip())
		enddo

    RESET ENVIRONMENT
Return     

/*-----------------+---------------------------------------------------------+
!Nome              ! MTA410T - Cliente: Madero                                !
+------------------+---------------------------------------------------------+
!Descrição         ! PE apos inclusao/alteracao de Pedido de Venda           !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 01/06/2018                                              !
+------------------+--------------------------------------------------------*/
user function MTA410T(IXBPAD)
	if Inclui
		if empty(SC5->C5_XDTINC)
			RecLock("SC5", .f.)
			SC5->C5_XDTINC := dDataBase
			SC5->C5_XUSERI := UsrRetName(RetCodUsr())
			SC5->(MsUnlock())
		Endif
 	ElseIf Altera
		RecLock("SC5", .f.)
		SC5->C5_XDTALT := dDataBase
		SC5->C5_XUSERA := UsrRetName(RetCodUsr())
		SC5->(MsUnlock())
	Endif
return


/*-----------------+---------------------------------------------------------+
!Nome              ! M410ALOK - Cliente: Madero                              !
+------------------+---------------------------------------------------------+
!Descrição         ! PE se pode ou nao alterar o Pedido de Venda             !
+------------------+---------------------------------------------------------+
!Data              ! 01/06/2018                                              !
+------------------+--------------------------------------------------------*/
user function M410ALOK(IXBPAD)
Local lRet := .t.

	//If ALTERA 
	//	if SC6->(dbSeek(SC5->C5_FILIAL+SC5->C5_NUM)) .and. !empty(SC6->C6_XFILORI)
	//		lRet := .f.
	//		Alert("Não poderá ser alterado pedidos de vendas gerados pela central de pedidos [C6_XFILORI  = " +SC6->C6_XFILORI+" ]")
	//	Endif
	//Endif

	/*
	@author Rafael Ricardo Vieceli
	@since 19/04/2018
	*/

	// -> apenas na alteração
	IF IsInCallStack("A410Altera")

		//procura pelo pedido nos Itens de ordem de separacao
		CB8->( dbSetOrder(2) )
		CB8->( dbSeek( xFilial("CB8") + SC5->C5_NUM ) )

		//percorre todos os itens
		While ! CB8->( Eof() ) .And. CB8->(CB8_FILIAL+CB8_PEDIDO) == xFilial("CB8") + SC5->C5_NUM

			CB7->( dbSetOrder(1) )
			CB7->( dbSeek( xFilial("CB7") + CB8->CB8_ORDSEP ) )

			//se a ordem de separação não estiver finalizada
			IF CB7->CB7_STATUS != '9'
				//não permite a alteração
				lRet := .F.
				//e sai
				Exit
			EndIF

			//posiciona na liberação
			SC9->( dbSetOrder(1) )
			SC9->( dbSeek( xFilial("SC9") + CB8->(CB8_PEDIDO+CB8_ITEM+CB8_SEQUEN+CB8_PROD) ) )

			//se a liberação não estiver faturada
			IF SC9->C9_BLEST != "10" .And. SC9->C9_BLCRED != "10"
				//não permite a alteração
				lRet := .F.
				//e sai
				Exit
			EndIF

			CB8->(dbSkip())
		EndDO

		IF ! lRet
			Help("",1,"MADERO_PE_M410ALOK",,"Não é possivel alterar o pedido, pois a ordem de separação " + CB7->CB7_ORDSEP + " não foi finalizada.",4,1)
		EndIF

	EndIF

return lRet 