
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AJUS_CTT  �Autor  �Emerson             � Data �  02/11/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza o codigo DP06 para os CRs ja cadastrados.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AJUS_CTT()

DbSelectArea("CTT")
DbSetOrder(1)
DbGotop()

Do While !EOF()
	RecLock("CTT",.F.)
	CTT->CTT_DP06 := DP06()
	MsUnLock()

	DbSelectArea("CTT")
	DbSkip()
EndDo

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DP06      �Autor  �Emerson             � Data �  02/08/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula Digito Verificador do DP06 - Bradesco              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 8                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function DP06()

nMult 	:= 2
nVal	:= 0
cCampo	:= alltrim(CTT->CTT_CUSTO)

For i := 5 to 1 Step -1
	nMod 	:= Val(Substr(cCampo,i,1)) * nMult
	nVal 	:= nVal + nMod
	nMult 	:= IIF(nMult==7,2,nMult+1)
Next

nResto 	:= MOD(nVal,11)
If !(nResto == 0 .or. nResto == 1)
	nDvCalc	:= 11 - nResto
Else
	nDvCalc	:= 0
EndIf


Return(alltrim(cCampo)+STR(nDvCalc,1))