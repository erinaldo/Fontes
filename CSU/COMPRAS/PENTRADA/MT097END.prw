#INCLUDE 'RWMAKE.CH'
#DEFINE ENTER CHR(13)+CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT097END  �Autor  �Renato Lucena Neves � Data �  23/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada no fim das fun��es A097LIBERA, A097SUPERI ���
���          � e A097TRANSF                                               ���
�������������������������������������������������������������������������͹��
���Altera��o � Donizeti - 06/03/13 - Linha 99 Desabilitando envio e-mail  ���
�������������������������������������������������������������������������ͼ��
���Uso       � AP8-CSU                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	
	//�������������������Ŀ
	//�Busca o solicitante�
	//���������������������
	If SC7->C7_TIPO==1	//solicita��o
		_cUser	:= GetAdvFVal('SC1','C1_USER',xFilial('SC1')+SC7->C7_NUMSC,1,'')
	else				//contrato
		_cUser	:= GetAdvFVal('SC3','C3_USER',xFilial('SC3')+SC7->C7_NUMSC,1,'')
	endif
	
	//����������������������������������������Ŀ
	//�Verifica se esta completamente liberado �
	//������������������������������������������
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
		
		
		//���������������������������������������������������Ŀ
		//�Apaga a filial de entrega caso filial compartilhada�
		//�����������������������������������������������������
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
		
		//��������������������������������Ŀ
		//�Mensagem a ser enviada no e-mail�
		//����������������������������������
		_cFornece := GetAdvFVal('SA2','A2_NREDUZ',xFilial('SA2')+_cFornece,1,'')
		
		_cMensagem := "Prezado,"+ENTER
		_cMensagem += ENTER
		_cMensagem += "O seu pedido Nr. "+alltrim(_cDOC)+" no valor de R$ "+alltrim(transform(_nTotal, "@E 999,999,999,999.99"))+" do fornecedor "+alltrim(_cFornece)+" encontra-se totalmente aprovado. "+ENTER
		_cMensagem += "Favor providenciar a entrada do documento fiscal no sistema Microsiga m�dulo Compras/Documento de Entrada."+ENTER
		_cMensagem += ENTER
		_cMensagem += "ATT."+ENTER
		_cMensagem += "Dpto. Contabil"+ENTER
		_cMensagem += ENTER
		_cMensagem += ENTER
		_cMensagem += ENTER
		_cMensagem += "Este E-Mail � gerado automaticamente pelo sistema. N�o responda o mesmo!"
		
		//Desabilitando envio de e-mail por gerar lentid�o na �ltima libera��o.
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


