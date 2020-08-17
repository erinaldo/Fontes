#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA120E   �Autor  � Sergio Oliveira    � Data �  Ago/2007   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada que efetua o envio do e-mail no momento da���
���          � confirmacao da exclusao do mesmo. O fornecedor que ja tiver���
���          � recebido o e-mail do pedido de compras eletronico ira rece-���
���          � ber a notificacao de cancelamento automatico do PC.        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA120E()

Local _lRet := .f.
Local cMsg

// Confirmou a exclusao:
// Sergio em Jul/2008: A exclusao via modulo GCT devera ser permitida.


If "RPC"$FunName() 
	Return(.t.)
EndIf

If "CNTA120"$FunName()
	_lRet := .t.
Else
	
	If ParamIxb[1] == 1 .And. "MATA121"$FunName()
		
		_lRet     := .t.
		
		_cUsuario := Posicione('SA2',1,xFilial('SA2')+cA120Forn+cA120Loj,"A2_EMAIL")
		
		If Empty(_cUsuario) .Or. !('@' $ _cUsuario)
			
			cMsg := "Este fornecedor nao possui um e-mail v�lido. Portanto, n�o ser� poss�vel emitir "
			cMsg += "automaticamente a solicita��o do cancelamento deste PC."
			
			Aviso('E-Mail para Cancelamento de PC',cMsg,{'Voltar'},3,"Notifica��o de Cancelamento do PC",,"PCOLOCK")
			
		EndIf
		// No caso de poder excluir o pedido ja enviado e ou aceito, uma solicita��o de
		// cancelamento ser� enviada automaticamente ao fornecedor:
		cAssunto := Trim(SM0->M0_NOME)+"/"+Trim(SM0->M0_FILIAL)+" - Solicita��o de Cancelamento de Pedido de Compras"
		cTitulo  := 'Solicita��o de Cancelamento Referente ao Pedido de Compras Nro. '+ SC7->C7_FILIAL +'/'+ SC7->C7_NUM
		cDetalhe := 'Sr(a) '+Posicione('SA2',1,xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA),"A2_CONTATO")+', Solicitamos a gentileza de proceder '
		cDetalhe += 'com o cancelamento deste pedido de compras.  Qualquer d�vida, entre em contato com '+UsrFullName(SC7->C7_USER)+'. Obrigado.'
		U_Rcomw06( cAssunto, cTitulo, cDetalhe, _cUsuario )
				
	EndIf
	
EndIf

Return( _lRet )