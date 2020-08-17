//Esse programa é usado no Cnab pgto de fornecedor do banco do brasil e do banco alfa
// para gerar um único sequencial independete do segmento(ou seja qdo passa pelo segmento A e B
// Andréa  - 06-11-2007 


User Function SomaLin
If valtype(_nlinha)="U"
	//conout("nlinha não foi incrementado: "+str(_nlinha))		
else	
	_nlinha++
	//conout("Incremento de linha: "+str(_nlinha))
endif 
return STRZERO(_nlinha,5)	


User Function CriaLin
Public _nlinha:=0 
//	conout("Criando Variável pública")
Return ""             

User Function ZeraLin
If valtype(_nlinha)<>"U"
	_nlinha:=0
	//conout("Zerando variável pública")
ENDIF          
return ""