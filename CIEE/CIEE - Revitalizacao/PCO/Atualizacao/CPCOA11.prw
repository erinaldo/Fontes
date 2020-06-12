#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CPCOA11   �Autor  �TOTVS               � Data �  10/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para executar a finalizacao da Digitacao			  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CPCOA11
Local lContinua:= .T.

//����������������������������������������������������������Ŀ
//�Executa validacao para prosseguir Finalizacao da Digitacao�
//������������������������������������������������������������
lContinua:= VldFlzOrc()

If lContinua
	//��������������������������������������������Ŀ
	//�Atualiza campo AK1_XAPROV=1 (Aguardando Aprov)�
	//����������������������������������������������
	dbSelectArea('AK1')
	RecLock("AK1", .F.)
	AK1->AK1_XAPROV := '1'
	AK1->(MsUnLock())
	
	MsgInfo("Planilha finalizada!")
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VldFlzOrc �Autor  �TOTVS               � Data �  11/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida se pode ser finalizado Digitacao					  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VldFlzOrc
Local lRet		:= .T.
Local lAchou	:= .F.
Local aArea		:= GetArea()

//������������������������������������������������Ŀ
//�Caso campo AK1_XAPROV <> 2 apresentar mensagem  �
//�e nao continuar.                                �
//��������������������������������������������������

If AK1->AK1_XAPROV == '1'
	MsgStop("Esta planilha j� foi finalizada. Verifique!")
	lRet:= .F.
Endif

If AK1->AK1_XAPROV == '2'
	MsgStop("Esta planilha j� foi aprovada. Verifique!")
	lRet:= .F.
Endif        


If AK1->AK1_FILIAL <> XFILIAL("AK1")
	MsgStop("Empresa selecionada diferente da filial corrente. Verifique!")
	lRet:= .F.
Endif        


//������������������������������������������������������������������
//�Verifica se todos os itens de todos os C.Custo estao finalizados�
//������������������������������������������������������������������
If lRet
	dbSelectArea('AK2')
	AK2->(dbSetOrder(1))
	AK2->(dbSeek(xFilial('AK2')+AK1->(AK1_CODIGO+AK1_VERSAO)))
	
	While !Eof() .and. AK2->(AK2_FILIAL+AK2_ORCAME+AK2_VERSAO) = AK1->(AK1_FILIAL+AK1_CODIGO+AK1_VERSAO) .and. !lAchou
		If AK2->AK2_XSTS <> '1'
			lAchou	:= .T.
			lRet	:= .F.
			MsgStop("Encontrado um ou mais itens em Aberto. Verifique!","Atenc�o")
		Endif
		dbSkip()
	Enddo
Endif
RestArea(aArea)

Return(lRet)
