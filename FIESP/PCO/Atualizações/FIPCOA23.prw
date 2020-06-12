/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIPCOA23  �Autor  �TOTVS               � Data �  10/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para executar a Reabertura da Digitacao			  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico FIESP (GAPID048)                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FIPCOA23
Local _aPerg     := {}
Local _nTamCC    := Space(TamSx3("CTT_CUSTO")[1])
Local _aRet	     := {}
Local lVisualiza := .T.

IF AK1->(AK1_XAPROV) == '2'
	MsgStop("Esta planilha j� foi aprovada.","Aten��o")
	Return()
ENDIF

If !AK1->(AK1_XRESPP) == __CUSERID .and. __CUSERID <> "000000"
	MsgStop("Somente o respons�vel pela planilha poder� executar esta rotina ! ","Aten��o")
Else
	aAdd(_aPerg,{1,"CC De : ",_nTamCC,"@!","","CTT","",_nTamCC,.F.})
	aAdd(_aPerg,{1,"CC At�: ",Replicate("Z",TamSx3("CTT_CUSTO")[1]),"@!","","CTT","",_nTamCC,.T.})
	
	IF ParamBox(_aPerg,"Selecione a(s) CC(s) para reabertura",@_aRet)
		
		If AK1->(AK1_XAPROV) == '1'
			dbSelectArea('AK1')
			RecLock("AK1", .F.)
			AK1->AK1_XAPROV := '0'
			AK1->(MsUnLock())
		ENDIF
		
		//������������������������������������������������������������������
		//�Verifica se usuario possui acesso ao C.Custo e finaliza item    �
		//�conforme os parametros informado de Centro de Custo			   �
		//������������������������������������������������������������������
		AK2->(dbSetOrder(1))
		AK2->(dbSeek(xFilial('AK2')+AK1->(AK1_CODIGO+AK1_VERSAO)))
		
		Begin Transaction
		
		While AK2->(!Eof()) .and. AK2->(AK2_FILIAL+AK2_ORCAME+AK2_VERSAO) = AK1->(AK1_FILIAL+AK1_CODIGO+AK1_VERSAO)
			
			lAcessOk := U_FIVldAK2_CC_CV_IC(lVisualiza)
			
			If lAcessOk .and. ( AK2->AK2_CC >= _aRet[1] .AND. AK2->AK2_CC <=  _aRet[2] )
				RecLock("AK2", .F.)
				AK2->AK2_XSTS := '0'
				AK2->(MsUnLock())
			Endif
			
			AK2->(dbSkip())
		Enddo
		
		End Transaction
		
		MsgStop("Or�amento/CC's reabertas com sucesso! ","Aten��o")
		
	ENDIF
Endif

Return

