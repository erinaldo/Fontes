#include "rwmake.ch"

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �MT120ISC � Autor � Leonardo Soncin        � Data � 28/11/06   ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Grava Jutificativa de Compra e Informacao de Contrato da      ���
���          �Solicitacao de Compras no PC                                  ���
���������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                      ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

User Function MT120ISC()

Local nPosJustif   := aScan( aHeader,{|x| Alltrim(x[2]) == "C7_XJUSTIF"})
Local nPosContr    := aScan( aHeader,{|x| Alltrim(x[2]) == "C7_XCONT"})
Local nPosVlCapex  := aScan( aHeader,{|x| Alltrim(x[2]) == "C7_XVLCAPE"})


cFilialEnt :=	SC1->C1_FILENT  // Tatiana Barbosa - 05/01/11 - OS 3127/10

If nTipoPed == 1 // Pedido de Compra

	aCols[n][nPosJustif]    := SC1->C1_XJUSTIF
	aCols[n][nPosContr]     := SC1->C1_XCONT
	aCols[n][nPosVlCapex]   := SC1->C1_XVLCAPE

EndIf           

Return()