
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103DRF  �Autor  �Microsiga           � Data �  10/05/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Coloca os codigos de Reten��o dos impostos e marca a opcao ���
���          � GERA DIRF                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � GJP                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MT103DRF()

Local nCombo  := PARAMIXB[1]�
Local cCodRet := PARAMIXB[2]�
Local oCombo  := PARAMIXB[3]�
Local oCodRet := PARAMIXB[4]�
Local aImpRet := {}

//nCombo� := 1
//cCodRet := "1700"
//aadd(aImpRet,{"IRR",nCombo,cCodRet})
//nCombo� := 2
//cCodRet := "1708"
//aadd(aImpRet,{"ISS",nCombo,cCodRet})
nCombo� := 1
cCodRet := "5952"
aadd(aImpRet,{"PIS",nCombo,cCodRet})

nCombo� := 1
cCodRet := "5952"
aadd(aImpRet,{"COF",nCombo,cCodRet})

nCombo� := 1
cCodRet := "5952"
aadd(aImpRet,{"CSL",nCombo,cCodRet})
                                   
nCombo� := 1
cCodRet := "1708"
aadd(aImpRet,{"IRR",nCombo,cCodRet}) 

nCombo� := 1
cCodRet := "2631"
aadd(aImpRet,{"INS",nCombo,cCodRet})

Return aImpRet