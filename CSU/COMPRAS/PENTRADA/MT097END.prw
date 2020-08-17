#INCLUDE 'RWMAKE.CH'
#DEFINE ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT097END  ºAutor  ³Renato Lucena Neves º Data ³  23/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada no fim das funções A097LIBERA, A097SUPERI º±±
±±º          ³ e A097TRANSF                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³ Donizeti - 06/03/13 - Linha 99 Desabilitando envio e-mail  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºUso       ³ AP8-CSU                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT097END()

Local _aArea	:= GetArea()
Local _aAreaSC7	:= SC7->(GetArea())
Local _cDoc  	:= alltrim(PARAMIXB[1])
Local _cTipo	:= PARAMIXB[2]
Local _nOpcao   := PARAMIXB[3]
Local _lTotLib	:= .F.
Local _nTotal	:= 0
Local _cUser	:= ""
Local _cFornece	:= ""

DbSelectArea('SC7')
DbGoTop()
If DbSeek(xFilial('SC7')+_cDoc)	//posiciona no pedido
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca o solicitante³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SC7->C7_TIPO==1	//solicitação
		_cUser	:= GetAdvFVal('SC1','C1_USER',xFilial('SC1')+SC7->C7_NUMSC,1,'')
	else				//contrato
		_cUser	:= GetAdvFVal('SC3','C3_USER',xFilial('SC3')+SC7->C7_NUMSC,1,'')
	endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se esta completamente liberado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While xFilial('SC7')+_cDoc==SC7->(C7_FILIAL+C7_NUM) .and. SC7->(!EOF())
		If SC7->C7_CONAPRO=='L'		//verifica se esta liberado
			_lTotLib := .T.
			//			_cUser	:= SC7->C7_USER
			_cFornece:= SC7->C7_FORNECE+SC7->C7_LOJA
			_nTotal+= (SC7->C7_TOTAL - SC7->C7_VLDESC)     //calcula o total do pedido
		else
			_lTotLib	:=.F.
			exit
		endif
		SC7->(DBSKIP())
	enddo
	If _lTotLib
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Apaga a filial de entrega caso filial compartilhada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF Empty(SC7->C7_FILIAL)
			SC7->(DbGoTop())
			DbSeek(xFilial('SC7')+_cDoc)
						
			While xFilial('SC7')+_cDoc==SC7->(C7_FILIAL+C7_NUM) .and. SC7->(!EOF())
				RecLock('SC7',.F.)
				SC7->C7_FILENT:=''
				MsUnLock()
				SC7->(DBSKIP())
			enddo
		endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Mensagem a ser enviada no e-mail³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cFornece := GetAdvFVal('SA2','A2_NREDUZ',xFilial('SA2')+_cFornece,1,'')
		
		_cMensagem := "Prezado,"+ENTER
		_cMensagem += ENTER
		_cMensagem += "O seu pedido Nr. "+alltrim(_cDOC)+" no valor de R$ "+alltrim(transform(_nTotal, "@E 999,999,999,999.99"))+" do fornecedor "+alltrim(_cFornece)+" encontra-se totalmente aprovado. "+ENTER
		_cMensagem += "Favor providenciar a entrada do documento fiscal no sistema Microsiga módulo Compras/Documento de Entrada."+ENTER
		_cMensagem += ENTER
		_cMensagem += "ATT."+ENTER
		_cMensagem += "Dpto. Contabil"+ENTER
		_cMensagem += ENTER
		_cMensagem += ENTER
		_cMensagem += ENTER
		_cMensagem += "Este E-Mail é gerado automaticamente pelo sistema. Não responda o mesmo!"
		
		//Desabilitando envio de e-mail por gerar lentidão na última liberação.
		//Donizeti 06/03/13 - 10:50 
		//
		//u_EnviaEMail(UsrRetMail(_cUSER),_cMensagem,'Pedido '+alltrim(_cDOC)+' liberado')
		
		_lTotLib:=.F.
	endif
endif

DbSelectArea('SC7')
RestArea(_aAreaSC7)

RestArea(_aARea)

Return


