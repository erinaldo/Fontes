#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIPCOA14  �Autor  �TOTVS               � Data �  24/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Alterar o status da Planilha e itens para Aberto (Zero)     ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico FIESP (GAPID048)                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FIPCOA14
Local _aAreaAK2 := AK2->(GetArea())

//������������������������������������Ŀ
//�Atualiza campo AK1_XAPROV=0 (Aberto)  �
//��������������������������������������
RecLock("AK1", .F.)
AK1->AK1_XAPROV := '0'
AK1->(MsUnLock())

//������������������������������������Ŀ
//�Atualiza campo AK2_XSTS=0 (Aberto)  �
//��������������������������������������
AK2->(dbSetOrder(1))
AK2->(dbSeek(xFilial('AK2')+AK1->(AK1_CODIGO+AK1_VERSAO)))

While AK2->(!Eof()) .and. AK2->(AK2_FILIAL+AK2_ORCAME+AK2_VERSAO) = AK1->(AK1_FILIAL+AK1_CODIGO+AK1_VERSAO)
	RecLock("AK2", .F.)
	AK2->AK2_XSTS := '0'
	AK2->(MsUnLock())
	AK2->(dbSkip())
Enddo

RestArea(_aAreaAK2)
Return
