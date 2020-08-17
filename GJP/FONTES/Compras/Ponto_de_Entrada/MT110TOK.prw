#INCLUDE 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110TOK  �Autor  �Lucas Riva Tsuda    � Data �  10/29/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida os dados inseridos na SC para que a al�ada de apro-  ���
���          �va��o seja gerada de acordo com a regra.                    ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110TOK

Local lRet      := .T.
Local nPosCC    := aScan(aHeader,{|x| Alltrim(x[2]) == "C1_CC"})  
Local nPosProd  := aScan(aHeader,{|x| Alltrim(x[2]) == "C1_PRODUTO"}) 
Local _aItens   := {}   
Local _aRet     := {}        
Local _cMsg      := ""

If INCLUI .Or. ALTERA

	For _nY := 1 To Len(aCols)
		
		AADD(_aItens, {aCols[_nY][nPosProd], aCols[_nY][nPosCC], cA110Num})
				
	Next  
	
	_aRet    := U_MontaAlc(cFilAnt,_aItens)  
	
	If _aRet[1][1] == "2"    
	
		_cMsg += "A SC n�o poder� ser gravada pois n�o existe regra de aprova��o cadastrada para o(s) seguinte(s) "
		_cMsg += "Centro(s) de Custo / Grupo(s) de Produto (respectivamente): "
	     
		For _nX := 1 To Len(_aRet[1][3])	
		    
			_cMsg += _aRet[1][3][_nX][3]+" / "+_aRet[1][3][_nX][2]+" - ("+Alltrim(Posicione("SBM",1,xFilial("SBM")+_aRet[1][3][_nX][2],"BM_DESC"))+") " 
		
		Next
	                                                           
		Aviso("Aten��o!",_cMsg,{"Ok"},3,"Al�ada incompleta")  
		
		lRet := .F.
	
	ElseIf _aRet[1][1] == "3" 
	// fazer uma mensagem no fonte que direcione para o grupo de contingencia no parametro. permitir que a rotina continue e nao trave processo.
/*		_cMsg += "A SC n�o poder� ser gravada pois existe divergencia na regra de al�ada. De acordo com os itens da SC foram "
		_cMsg += "identificadas regras de al�ada diferentes para a escolha do grupo de aprova��o. Dos grupos "
	     
		For _nX := 1 To Len(_aRet[1][4])	
		    
			_cMsg += _aRet[1][4][_nX][1]+" ("+Alltrim(Posicione("SAL",1,xFilial("SAL")+_aRet[1][4][_nX][1],"AL_DESC"))+"), "
		
		Next  
		
		_cMsg += " apenas 1 pode ser utilizado para aprovar esta compra."
	                                                           
		Aviso("Aten��o!",_cMsg,{"Ok"},3,"Al�ada inconsistente")
	    
		lRet := .F.
*/
//    msginfo("Existem divergencias nas regras de al�ada, a aprova��o ser� direcionado para o grupo de conting�ncia.")	
	EndIf

EndIf
	    
Return lRet
