#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT130TOK()  �Autor� Jos� Carlos	 � Data � 03/07/2015      ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Seleciona apenas o fornecedor exclusivo na amarra��o       ���
���          � Produto x Fornecedor 									  ���
�������������������������������������������������������������������������Ĵ��
���Funcao    � PE GERACAO DE COTACAO	                                  ���
�������������������������������������������������������������������������Ĵ��
*/

/*
	ESPECIFICO PROCESSOS COMPRAS PUBLICAS
	GERACAO DE COTACAO 
*/

User Function MT130TOK()
Local aAreaAtu 	:= GetArea() 
Local aSA5		:= SA5->(GetArea())
Local nPosForn 	:= aScan(aHeader,{|x| AllTrim(x[2])=="AD_FORNECE"})       
Local nPosLoj  	:= aScan(aHeader,{|x| AllTrim(x[2])=="AD_LOJA"})       
Local nX
Local lRet     	:= .T.
Local lExclusivo:= .F.  
Local nLinhas	:= 0

DbSelectArea("SA5")
SA5->(DbSetOrder(1))  

For nX := 1 to Len(aCols)
	If ValType(aCols[nX,Len(aCols[nX])]) == "L"
		lDeleted := aCols[nX,Len(aCols[nX])]     
	EndIf
	If !lDeleted
		If SA5->( DbSeek(xFilial("SA5") + aCols[nX][nPosForn] + aCols[nX][nPosLoj] + SC1->C1_PRODUTO) )  
			If SA5->A5_EXCLUSI == 'S'
				lExclusivo := .T.	   	
			EndIf  
		EndIf
		nLinhas ++
	EndIf
Next nX

If lExclusivo .And. nLinhas > 1
	lRet := .F.
	Help(" ",1,"MT130TOK",,'Selecione apenas um fornecedor para produto exclusivo.',1,0)
EndIf
RestArea( aSA5 )                            
RestArea( aAreaAtu )
Return( lRet )