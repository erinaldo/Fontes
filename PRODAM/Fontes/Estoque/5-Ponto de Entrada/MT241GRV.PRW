#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
                                    
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT241GRV �Autor  �Felipe Santos        � Data �  11/08/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ap�s a grava��o dos dados (aCols) no SD3, e tem a finalidade ��
���          �de atualizar algum arquivo ou campo.                         ��
���          �PARAMIXB[1] = N�mero do Documento                            ��
���          �PARAMIXB[2] = Vetor bidimensional com nome campo/valor do    ��
���          campo (somente ser� enviado se o Ponto de Entrada MT241CAB    ��
���          for utilizado). 						   ��
����������������������������������admin���������������������������������������͹��
���Uso       � 							          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT241GRV 

Local cDoc:= PARAMIXB[1]
Local aProds :=  {}

aProds := ACLONE(aCols)

U_MMENSZ10(SD3->D3_FILIAL,  aProds)

Return 