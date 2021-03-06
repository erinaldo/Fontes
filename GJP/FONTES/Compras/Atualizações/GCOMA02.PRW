#INCLUDE 'Protheus.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IndXFil   �Autor  �Lucas Riva Tsuda    � Data �  12/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Permite cadastrar indicador de produto somente para os itens���
���          �que possuem amarra��o no SZ1                                ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function IndXFil(cCod)
    
Local lRet := .T.    
      
SZ1->(DbSetOrder(1))
If !SZ1->(MsSeek(cCod+cEmpAnt+cFilAnt))  

	lRet := .F.
	MsgAlert("N�o � poss�vel cadastrar Indicador de Produto para esta filial. Verifique a amarra��o 'Produto x Filial' no cadastro de Produto")

EndIf                                                                                                                                          

Return lRet        


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BloqInd   �Autor  �Lucas Riva Tsuda    � Data �  12/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Substitui o bloqueio padr�o do produto (SB1) pelo bloqueio  ���
���          �customizado no indicador de produto (SBZ)                   ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BloqInd(cCod)
     
Local lRet := .T.

SBZ->(DbSetOrder(1))
If SBZ->(MsSeek(cFilAnt+cCod)) 

	If SBZ->BZ_XBLOQUE == "1"
	
		lRet := .F.
		MsgAlert("Produto bloqueado! Verifique o cadastro de Indicador de Produto.")
		
	EndIf   
	
Else

	lRet := .F.
	MsgAlert("Produto incompleto! Para utilizar este item deve ser feito o cadastro de Indicador de Produto.")	
	
EndIf     

Return lRet
