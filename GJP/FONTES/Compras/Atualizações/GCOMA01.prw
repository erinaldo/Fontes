#INCLUDE 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GCOMA01   �Autor  �Lucas Riva Tsuda    � Data �  10/28/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela para cadastrar as regras de al�ada                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GCOMA01

AxCadastro("SZ0","Regras de Al�ada",,"U_VALCHAV()")

Return                                           

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValChav   �Autor  �Lucas Riva Tsuda    � Data �  10/28/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida chave prim�ria                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ValChav()
           
Local aArea    := GetArea()
Local aAreaSZ0 := {}//SZ0->(GetArea())    
Local lRet     := .T.
  // validar se eh inclusao (permitir) e alteracao nao validar
If INCLUI
	SZ0->(DbSetOrder(1))
	If SZ0->(MsSeek(xFilial("SZ0")+M->Z0_ESTOCAV+M->Z0_GRUPO+M->Z0_CC))
		
		MsgAlert("Regra j� cadastrada!")
		lRet := .F.
		
	EndIf
EndIf

RestArea(aArea)

Return lRet