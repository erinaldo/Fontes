#Include "RwMake.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � SF1100E  � Autor � Emerson Custodio    � Data � 10/07/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Limpa conferencias dos movimentos com origem no compras.    ���
��������������������������������������������������������������������������͹��
���Uso       � CSU					                                       ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function SF1100E()

////////////
//DECLARA VARIAVEIS
////////////
Local aAREATU := GetArea()

DbSelectArea("SF1")											 					//SELECIONA TABELA
RecLock("SF1",.F.)										 						//INICIA GRAVACAO DO REGISTRO
SF1->F1_XLIBNIV := "0"															//ZERA NIVEL
SF1->F1_XCONF01 := ""															//LIMPA STATUS 1
SF1->F1_XCONF02 := ""															//LIMPA STATUS 2
SF1->F1_XCONF03 := ""															//LIMPA STATUS 3
MsUnlock()  

////////////
//RETORNA AREA ORIGINAL
////////////  
RestArea(aAREATU)

Return()