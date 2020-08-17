#include "rwmake.ch"
#include "PROTHEUS.CH"   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±			                                                               ±±
±± Funcao: CT105LOK 	Autor: Tatiana A. Barbosa	Data: 24/05/10	       ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±						  												   ±±
±±	Descricao: Ponto de entrada para validação das linhas do lançamento    ±± 
±± 				contábil. Valida o tipo do lançamento X Preenchimento	   ±±  
±±					dos campos de conta contábil.						   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± 																		   ±±
±±			Alteracoes: 											 	   ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±															  			   ±±
±±				Uso:  CSU 	                                               ±±
±±												  						   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function  CT105LOK()      

Local lRet 		:= .T.
Local cTipo		:= TMP->CT2_DC		 // Tipo de lanc. contabil 1-> Debito, 2-> Credito, 3-> Partida Dobrada
Local cDebito	:= TMP->CT2_DEBITO	 // Conta Debito
Local cCredito	:= TMP->CT2_CREDIT	 // Conta Credito                
Local lRec		:= 0    
Local lRet 		:= .F.

//TMP->( DbGoTop() )

	If cTipo="1" .And. !Empty(cCredito)
		Alert("Quando o tipo de lançamento for Débito o campo Conta Crédito deve estar vazio.") 
		lRec ++
	Endif    
	
	If cTipo="2" .And. !Empty(cDebito)		
		Alert("Quando o tipo de lançamento for Crédito o campo Conta Débito deve estar vazio.")   
		lRec ++
	Endif   	
	
	//TMP->( DbSkip() )
	  

	If lRec > 0
		lRet := .F.
	Else
		lRet := .T.	
	EndIf
	
	// - OS 0888/10 - Se for efetivacao CSU
	If Alltrim(Upper(FunName())) == "XCTBA350"
       
   		lRet := U_CT105CHK()
	EndIf	
	   
	
Return (lRet)	// se lRet = .F.  o sistema emite a  mensagem informando sobre o tipo de lançamento e o preenchimento dos campos de conta.