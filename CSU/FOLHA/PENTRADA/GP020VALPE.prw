#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �GP020VALPE� Autor � Isamu Kawakami        � Data � 24.02.10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para validar informa��es no SRB           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RDMake ( DOS e Windows )                                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para CSU                                        ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function GP020VALPE              			

Local aArea  		:= GetArea()
Local lRet    		:= .T.                             
Local nPosDtNasc 	:= aScan(AHEADER,{|x| AllTrim(x[2]) == "RB_DTNASC"} )
Local nPosCPF		:= aScan(AHEADER,{|x| AllTrim(x[2]) == "RB_CIC"   } )
Local nPosCod		:= aScan(AHEADER,{|x| AllTrim(x[2]) == "RB_COD"   } )
Local nPosNome		:= aScan(AHEADER,{|x| AllTrim(x[2]) == "RB_NOME"   } )
Local nIdade 		:= (dDataBase-aCols[n,3])/365.25				

for nX := 1 to len(aCols)	
	If nIdade >= 18 .and. Empty(aCols[nX,nPosCPF]) .and. (INCLUI .OR. ALTERA)
		MsgAlert("O Dependente "+" "+aCols[nX,nPosCod]+"-"+Alltrim(aCols[nX,nPosNome])+", e� maior de idade. Preencha o Campo 'C.P.F.'  !!!")
		lRet := .F.
	Endif
Next nX                                  			
RestArea(aArea)

Return(lRet)

