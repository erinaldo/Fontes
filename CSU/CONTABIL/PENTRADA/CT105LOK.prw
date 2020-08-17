#include "rwmake.ch"
#include "PROTHEUS.CH"   

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��			                                                               ��
�� Funcao: CT105LOK 	Autor: Tatiana A. Barbosa	Data: 24/05/10	       ��
��																		   ��
�����������������������������������������������������������������������������
��						  												   ��
��	Descricao: Ponto de entrada para valida��o das linhas do lan�amento    �� 
�� 				cont�bil. Valida o tipo do lan�amento X Preenchimento	   ��  
��					dos campos de conta cont�bil.						   ��
�����������������������������������������������������������������������������
�� 																		   ��
��			Alteracoes: 											 	   ��
��																		   ��
�����������������������������������������������������������������������������
��															  			   ��
��				Uso:  CSU 	                                               ��
��												  						   ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		Alert("Quando o tipo de lan�amento for D�bito o campo Conta Cr�dito deve estar vazio.") 
		lRec ++
	Endif    
	
	If cTipo="2" .And. !Empty(cDebito)		
		Alert("Quando o tipo de lan�amento for Cr�dito o campo Conta D�bito deve estar vazio.")   
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
	   
	
Return (lRet)	// se lRet = .F.  o sistema emite a  mensagem informando sobre o tipo de lan�amento e o preenchimento dos campos de conta.