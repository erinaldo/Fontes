#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �CSUA040   � Autor � Rodrigo Antonio       � Data �24/06/2006���
�������������������������������������������������������������������������Ĵ��
���Locacao   � Fabr.Tradicional �Contato � rodrigo.antonio@microsiga.com. ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorna o num do cracha do cadastro de func(SRA) tendo por ���
���          � base o ID do agente													  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cDAC - DAC/Site                                            ���
���          � cID  - ID do agente													  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � RA_CRACHA - Numero do Cracha                               ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �SIGAPON                                                     ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
���              �  /  /  �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CSUA040(cDAC,cID)
Local aArea := getArea()
UA2->(DbSetOrder(2))	//UA2_FILIAL, UA2_IDAGNT, UA2_DAC
If UA2->(DbSeek(xFilial("UA2")+ Padr(Upper(cID),8) + Upper(cDAC)))
	dbSelectArea("SRA")
	//SRA->(DbSetOrder(13))			// Ordem de Matricula sem Filial
	SRA->(DbSetOrder(1))			// Ordem de Filial + Matricula
	//If SRA->(DbSeek(UA2->UA2_MAT))
	//	Return SRA->(RA_CRACHA)		// Achou o cracha
	///Endif
	//DbSeek(UA2->UA2_MAT)
	DbSeek(UA2->UA2_FILIAL+UA2->UA2_MAT)
	While UA2->UA2_MAT==SRA->RA_MAT
		If SRA->RA_SITFOLH#"D"
			Return SRA->(RA_CRACHA)		// Achou o cracha
		EndIf
		SRA->(dbSkip())
	End
Endif
RestArea(aArea)
Return ""
