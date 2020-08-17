#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA120E   ºAutor  ³ Sergio Oliveira    º Data ³  Ago/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada que efetua o envio do e-mail no momento daº±±
±±º          ³ confirmacao da exclusao do mesmo. O fornecedor que ja tiverº±±
±±º          ³ recebido o e-mail do pedido de compras eletronico ira rece-º±±
±±º          ³ ber a notificacao de cancelamento automatico do PC.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
			
			cMsg := "Este fornecedor nao possui um e-mail válido. Portanto, não será possível emitir "
			cMsg += "automaticamente a solicitação do cancelamento deste PC."
			
			Aviso('E-Mail para Cancelamento de PC',cMsg,{'Voltar'},3,"Notificação de Cancelamento do PC",,"PCOLOCK")
			
		EndIf
		// No caso de poder excluir o pedido ja enviado e ou aceito, uma solicitação de
		// cancelamento será enviada automaticamente ao fornecedor:
		cAssunto := Trim(SM0->M0_NOME)+"/"+Trim(SM0->M0_FILIAL)+" - Solicitação de Cancelamento de Pedido de Compras"
		cTitulo  := 'Solicitação de Cancelamento Referente ao Pedido de Compras Nro. '+ SC7->C7_FILIAL +'/'+ SC7->C7_NUM
		cDetalhe := 'Sr(a) '+Posicione('SA2',1,xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA),"A2_CONTATO")+', Solicitamos a gentileza de proceder '
		cDetalhe += 'com o cancelamento deste pedido de compras.  Qualquer dúvida, entre em contato com '+UsrFullName(SC7->C7_USER)+'. Obrigado.'
		U_Rcomw06( cAssunto, cTitulo, cDetalhe, _cUsuario )
				
	EndIf
	
EndIf

Return( _lRet )