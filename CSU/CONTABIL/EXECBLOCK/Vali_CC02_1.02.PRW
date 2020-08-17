// Execblock que tem a função de validar os Campos de Centro de Custo a Débito e a Crédito, 
// as contas de débito ou credito envolverem as contas do grupo 3.
// Analista :. Arauto Miranda de Santana       Data :. 11/03/02
// Alt. Mar/05 

#include "rwmake.ch"

User Function VALI_CC02()

_cValor        := "0.00"
_bRet := .F.

If M->CT2_DC == "1"
	If Empty(M->CT2_CCD) .and. Subs(M->CT2_DEBITO,1,1) == "3"
  		MsgAlert( " Atenção !!!, Informar o C.Custo a Débito")
//  		Return (_cValor,.F.)
		_bRet := .F.
	Else
		_bRet := .T.
	Endif
EndIf  

If M->CT2_DC == "2"
 
	If Empty(M->CT2_CCC) .and. Subs(M->CT2_CREDIT,1,1) == "3"
  		MsgAlert( " Atenção !!!, Informar o C.Custo a Crédito")
//  		Return (_cValor,.F.)
		_bRet := .F.
  	Else
	
	_bRet := .T.
	
 	EndIf
      
EndIf    

If M->CT2_DC == "3"
 
	If Empty(M->CT2_CCC) .and. Subs(M->CT2_CREDIT,1,1) == "3"
  		MsgAlert( " Atenção !!!, Informar o C.Custo a Crédito")
		_bRet := .F.
	Else
	
	_bRet := .T.
	
 	EndIf 
 
  	If Empty(M->CT2_CCD) .and. Subs(M->CT2_DEBITO,1,1) == "3"
  		MsgAlert( " Atenção !!!, Informar o C.Custo a Débito ")
	Else
	
	_bRet := .T.
	
   	EndIf
      
EndIf   

Return(_bRet)