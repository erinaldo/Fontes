#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CN130VLDVTOT�Autor� Carlos Tagliaferri Jr.� Data � 04.01.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Validacao do campo valor total informado na medicao         ���
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
�����������������������������������������������������������������������������
*/
User Function CN130VLDVTOT ()

Local lRet:= .T.
Local nPosVlUnit:=aScan(aHeader,{|x|x[2]=="CNE_VLUNIT"})
Local nx:= If(lAuto,n,oGetDados:nAt) 
Local cQuant

If M->CND_ZERO=="1"
	//Verifica se a quantidade e igual a zero quando a medicao for zerada
	lRet:=(CNE_QUANT==0)
Else
	//Verifica se o valor total e menor que o saldo disponivel
	cQuant:=Round((M->CNE_VLTOT/aCols[nx,nPosVlUnit]),TamSX3("CNE_QUANT")[2])
	lRet:=(M->CNE_VLTOT<=(aCols[nx,nPosVlUnit]*cQuant))	
Endif

If lRet
	TotMed()
Endif


Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �  TOTMED    �Autor� Carlos Tagliaferri Jr.� Data � 04.01.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualizacao do valor total                                  ���
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
�����������������������������������������������������������������������������
*/

Static Function TotMed()

Local nPosVu:=aScan(aHeader,{|x|x[2]=="CNE_VLUNIT"})
//Local nPosPD:=aScan(aHeader,{|x|x[2]=="CNE_PDESC"})
//Local nPosQt:=aScan(aHeader,{|x|x[2]=="CNE_QUANT"})
Local nx:= If(lAuto,n,oGetDados:nAt)

//Subtrai o valor antigo do item
nTotMed-=aCols[nx,6]*(aCols[nx,nPosVu]-((aCols[nx,nPosVu]*aCols[nx,14])/100))

//Soma valor alterado
nTotMed+=M->CNE_VLTOT-((aCols[nx,nPosVu]*aCols[nx,14])/100)

//Altera componente visual
oGetTot:Refresh()


Return Nil