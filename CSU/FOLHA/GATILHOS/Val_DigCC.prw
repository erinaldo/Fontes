User Function Val_DigCC()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VAL_DIGCC |Autor  � Isamu Kawakami     � Data �  25/08/04   ���
�������������������������������������������������������������������������͹��
���Descricao �Programa que checara se o Centro de Custo Digitado pertence ���
���          �a Filial Corrente                                           ���
�������������������������������������������������������������������������͹��
���Uso       � EXCLUSIVO PARA CSU                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

_aArea    := GetArea()
_Filial   :=xFilial("SRA")
_CCDigit  := M->Ra_CC
_Valida   := .T.

dBSelectArea("CTT")
dBSetOrder(1)
dBGoTop()

dbSeek("  "+_CCDigit)
If Ctt->Ctt_Fil != _Filial 
        ALERT("O CENTRO DE CUSTO DIGITADO NAO PERTENCE A ESSA FILIAL !!! VERIFIQUE O C.CUSTO CORRETO")
	_Valida := .F.
Endif

RestArea(_aArea) //Retorna o ambiente inicial

Return(_Valida) 
