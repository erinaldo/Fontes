#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BBRASIL   ºAutor  ³   Eduardo Dias     º Data ³  29/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera as informacoes para o cnab a pagar o banco do brasil  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CSU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BBrasil(cOpcao)

Local cReturn   := ""
Local cAgencia  := " "
Local cNumCC    :=" "
Local cDVAgencia:= " "
Local cDVNumCC  := " "


If cOpcao == "1"  // Obtem o numero da agencia
	
	//cAgencia :=  Alltrim(SA2->A2_AGFORN)
	cAgencia :=  Alltrim(SA2->A2_AGENCIA)
	
	If AT("-",cAgencia) > 0
		cAgencia := Substr(cAgencia,1,AT("-",cAgencia)-1)
	Endif
	
	cAgencia := STRTRAN(cAgencia,".","")
	
	cReturn  := strzero(val(cAgencia),5)
	
ElseIf cOpcao =="2"  // Obtem o digito da agencia
	
	//cDVAgencia :=  Alltrim(SA2->A2_AGFORN)
	cDVAgencia :=  Alltrim(SA2->A2_AGENCIA)
	
	If AT("-",cDVAgencia) > 0
		cDVAgencia := Substr(cDVAgencia,AT("-",cDVAgencia)+1,1)
	Else
		cDVAgencia := Space(1)
	Endif
	
	cReturn:= cDVAgencia
	
ElseIf cOpcao == "3"    // Obtem o numero da conta corrente
	
	cNumCC :=  Alltrim(SA2->A2_NUMCON)
	
	If AT("-",cNumCC) > 0
		cNumCC := Substr(cNumCC,1,AT("-",cNumCC)-1)
	Endif
	
	cReturn  := StrZero(val(cNumCC),12)
	
	
ElseIf cOpcao =="4"         // EXECUTA ROTINA DV C/C
	
	cDVNumCC :=  Alltrim(SA2->A2_NUMCON)
	If AT("-",cDVNumCC) > 0
		cDVNumCC := Substr(cDVNumCC,AT("-",cDVNumCC)+1,2)
	Else
		cDVNumCC := Space(1)
	Endif
	
	cReturn := cDvNumCC
	
ElseIf cOpcao =="5"   // EXECUTA ROTINA DV AGENCIA ou C/C
	
	cDV :=  Alltrim(SA2->A2_AGENCIA)
	
	If AT("-",cDV) > 0
		cDV := Substr(cDV,AT("-",cDV)+2,1)
	Else
		cDV :=  Alltrim(SA2->A2_NUMCON)
		If AT("-",cDV) > 0
			cDV := Substr(cDV,AT("-",cDV)+2,1)
		Else
			cDV := Space(1)
		Endif
	Endif
	
	cReturn := cDv
	
ElseIf cOpcao == "6"  // guarda totalizador
	// não estou usando mais na linha 231 a 240 quando brasil IIF(SEE->EE_CODIGO $ "001",U_BBRASIL("6")," ")
	
	nTotPag:= SE2->E2_SALDO - SE2->E2_DECRESC + SE2->E2_ACRESC
	
	RecLock("SEE",.F.)
	SEE->EE_VALTOT += nTotPag
	MsUnlock("SEE")
	
	cReturn:= " "
	
ElseIf cOpcao == "7"   // prepara para o proximo arquivo
	
	RecLock("SEE",.F.)
	SEE->EE_VALTOT:= 0
	MsUnlock("SEE")
	cReturn:= " "
	
ElseIf cOpcao == '8' // Numero sequencial para seguimento A e B
	nSeq++
	cReturn:= " "
EndIf

Return(cReturn)