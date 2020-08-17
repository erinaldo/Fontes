#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �  CSUVALQT  �Autor� Carlos Tagliaferri Jr.� Data � 29.06.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Validacao do quantidade informada na medicao                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico CSU                                             ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������9������
*/
User Function CSUVALQT()
             
Local lRet	:= .F.
Local aArea := GetArea()
Local nPosQSol := aScan(aHeader,{|x| x[2] == "CNE_QTDSOL"})
Local nx   := If(lAuto,n,oGetDados:nAt)

//DbSelectArea("CN9")
//DbSetOrder(1)
//DbSeek(xFilial("CN9") + CND->CND_CONTRA + CND->CND_REVISA)

DbSelectArea("CN1")
DbSetOrder(1)       
DbSeek(xFilial("CN1") + CN9->CN9_TPCTO)
                                     
If (CN1->CN1_MEDEVE == "1" .And. CN9->CN9_CTRT == "2") .And. (M->CNE_QUANT != aCols[nx,nPosQSol])
	Aviso("CSUVALQT","Para contratos vari�veis a quantidade deve ser igual a da planilha.",{"Ok"},1, "Quantidade Inv�lida!!!")
Else
	lRet := .T.
EndIf                   

RestArea(aArea)

Return (lRet)
