 #include "rwmake.ch"      
 
/* 
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒�
臼�Desc.     �Forma de Pagamento, conforme Tabela SE2 para as pos. 264 a  艮�
臼�          �265. PagFor Bradesco                                        艮�
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒�
臼�Uso       �                                                            艮�
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識�
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