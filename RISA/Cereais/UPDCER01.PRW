#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �UPDCER01  �Autor  �Marcelo Joner       � Data �  15/09/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada executado no compatibilizador U_UPDCEREAIS.���
���          �Determina se deve atualizar �s defini��es de exibi��o no    ���
���          �no browse conforme o padr�o do Addon Gest�o de Cereais para ���
���          �o campo repassado por par�metro.                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico Gest�o de Cereais                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function UPDCER01()

Local lUpdBrowse	:= .T.
Local cCpoNoUpd		:= "ZCB_NUMCC/ZCB_NUMCV/ZCB_NUMCS"
Local cCampo		:= PARAMIXB

//���������������������������������������������������������������������������������������������������
//�Caso o campo atual esteja entre os campos definidos, n�o atualiza as regras de exibi��o no browse�
//���������������������������������������������������������������������������������������������������
If ALLTRIM(cCampo) $ cCpoNoUpd
	lUpdBrowse := .F.
EndIf

Return lUpdBrowse
