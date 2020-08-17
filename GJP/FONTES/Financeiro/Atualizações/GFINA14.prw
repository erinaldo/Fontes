 #include "rwmake.ch"      
 
/* 
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณForma de Pagamento, conforme Tabela SE2 para as pos. 264 a  บฑฑ
ฑฑบ          ณ265. PagFor Bradesco                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/
  

User Function GFINA14()        //PAGFOR

SetPrvt("_Form,_FormSEA")

_FORMSEA:= Substr(SEA->EA_MODELO,1,2)                    

If _FORMSEA $ "01"
	_Form := "01"
ElseIf _FormSEA $ "02/04"
	_Form := "02"			
ElseIf _FormSEA $ "03"
	_Form := "03"			
ElseIf _FormSEA $ "41/43"
	_Form := "08"			
ElseIf _FormSEA $ "30"
	_Form := "31"			
ElseIf _FormSEA $ "31/13"
	_Form := "31"	  

EndIf

Return(_Form)        