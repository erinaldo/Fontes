#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALSZ5    �Autor  �Emerson Natali      � Data �  29/06/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao do campo Z5_DOC. Preenche com 0 com tamanho de   ���
���          � 7 posicoes e valida a existencia do codigo na tabela SZ6   ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function VALSZ5()

M->Z5_DOC := STRZERO(VAL(M->Z5_DOC),7)

_lRet := ExistCpo("SZ6",M->Z5_DOC,1)

Return(_lRet)