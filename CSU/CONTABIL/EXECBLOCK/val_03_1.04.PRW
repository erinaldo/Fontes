// Execblock que tem a função de validar as alterações nos Campos de debito, Credito
// e nos Centros de Custos de Debito e Credito.
// Analista   :. Arauto Miranda de Santana           Data :. 15/03/02
// Assistente :. Danielle Aparecida de Oliveira
// Alterado em 05/07 - Ricardo DTS - Alias (acrescentado "TMP")
//Alt. Mar./05

User Function vali_03

If tmp->Ct2_DC == "1"
	
	If !Empty(tmp->Ct2_CREDIT)
		
		tmp->Ct2_CREDIT  :=  ""
		
		If !Empty(tmp->Ct2_CCC)
			 tmp->Ct2_CCC :=   ""
		EndIf
	EndIf
EndIf

If  tmp->Ct2_DC == "2"
	
	If !Empty( tmp->Ct2_DEBITO)
		 tmp->Ct2_DEBITO      :=   ""
		If !Empty( tmp->Ct2_CCD)
			 tmp->Ct2_CCD  :=   ""
		EndIf
	EndIf
EndIf

If  tmp->Ct2_DC == "3"
	
	If Empty(tmp->Ct2_DEBITO)
		MsgAlert( " Atenção !!!, Informar Conta de Debito")
     	Return .t.
	EndIf
		
	If Empty(tmp->Ct2_CREDIT)
		MsgAlert( " Atenção !!!, Informar Conta de Credito ")
		Return .t.
	EndIf
EndIf

Return(.T.)