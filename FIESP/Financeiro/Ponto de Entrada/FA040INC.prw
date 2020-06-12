#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA040INC � Autor �Totvs			     �Data  �  29/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada no OK da inclusao do titulo a receber no  ���
���          � Financeiro.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA040INC

Local lRet:=.T.

IF !ALLTRIM(M->E1_ORIGEM) $ "MATA103/FINA280"
	IF Empty(M->E1_CCC) .or. Empty(M->E1_ITEMC)
		lRet:=.F.
		MSGINFO('Preecher os campos Centro de Custo e/ou Item Cont�bil (Projeto)!!!','Aviso')
	EndIF
EndIF

Return (lRet)