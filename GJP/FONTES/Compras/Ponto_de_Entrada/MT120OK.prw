#INCLUDE 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT120OK   บAutor  ณLucas Riva Tsuda    บ Data ณ  10/29/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera al็ada de aprova็ใo de acordo com regra especํfica na  บฑฑ
ฑฑบ          ณinclusใo manual de Pedido de Compra                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico GJP                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT120OK

Local _aRet     := {}   
Local _aItens   := {}
Local _cMsg     := ""        
Local nPosCC    := 0       
Local nPosProd  := 0  
Local lRet      := .T.   

nPosCC   := aScan(aHeader,{|x| AllTrim(x[2])  == "C7_CC"})        
nPosProd := aScan(aHeader,{|x| AllTrim(x[2])  == "C7_PRODUTO"})   

If INCLUI .Or. ALTERA  
	
	For _nY := 1 To Len(aCols)
		
		AADD(_aItens, {aCols[_nY][nPosProd], aCols[_nY][nPosCC], cA120Num})
				
	Next
	
	_aRet    := U_MontaAlc(cFilAnt,_aItens)
	
	If _aRet[1][1] == "2"    
	
		_cMsg += "O PC nใo poderแ ser gravado pois nใo existe regra de aprova็ใo cadastrada para o(s) seguinte(s) "
		_cMsg += "Centro(s) de Custo / Grupo(s) de Produto (respectivamente): "
	     
		For _nX := 1 To Len(_aRet[1][3])	
		    
			_cMsg += _aRet[1][3][_nX][3]+" / "+_aRet[1][3][_nX][2]+" - ("+Alltrim(Posicione("SBM",1,xFilial("SBM")+_aRet[1][3][_nX][2],"BM_DESC"))+") "  
		 
		Next
	                                                           
		Aviso("Aten็ใo!",_cMsg,{"Ok"},3,"Al็ada incompleta")  
		
		lRet := .F.  
		
	ElseIf _aRet[1][1] == "3" 
	     // fazer uma mensagem no fonte que direcione para o grupo de contingencia no parametro. permitir que a rotina continue e nao trave processo.
/*		_cMsg += "O PC nใo poderแ ser gravado pois existe divergencia na regra de al็ada. De acordo com os itens do PC foram "
		_cMsg += "identificadas regras de al็ada diferentes para a escolha do grupo de aprova็ใo. Dos grupos "
	     
		For _nX := 1 To Len(_aRet[1][4])	
		    
			_cMsg += _aRet[1][4][_nX][1]+" ("+Alltrim(Posicione("SAL",1,xFilial("SAL")+_aRet[1][4][_nX][1],"AL_DESC"))+"), "
		
		Next  
		
		_cMsg += " apenas 1 pode ser utilizado para aprovar esta compra."
	                                                           
		Aviso("Aten็ใo!",_cMsg,{"Ok"},3,"Al็ada inconsistente")
	    
		lRet := .F.
*/	
    msginfo("Existem divergencias nas regras de al็ada, a aprova็ใo serแ direcionado para o grupo de conting๊ncia.")
	EndIf

EndIf

Return lRet
