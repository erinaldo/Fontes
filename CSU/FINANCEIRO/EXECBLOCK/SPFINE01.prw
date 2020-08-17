#include "RWmake.ch"
#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SPFINE01  ºAutor  ³                    º Data ³  29/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna Valor liquido para montagem do CNAB                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SPTURISMO                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SPFINE01(_cOpc)

Local _xRet := ""
Local nAbat   := 0
Local nDecres := 0
Local nAcresc := 0

If _cOpc = '1'
	
	If FunName() == "FINA150"
		
		nAbat	:= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		nAcresc := SE1->E1_SDACRES
		nDecres := SE1->E1_SDDECRE
		_xRet:=PADL(Alltrim(str((SE1->E1_SALDO - nAbat + nAcresc - nDecres ) * 100 )), 15 , "0")
	Else
		If GetMv("MV_BX10925") == "1"
			nAbat	:= SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",SE2->E2_MOEDA,,SE2->E2_FORNECE)
			nAcresc := SE2->E2_SDACRES
			nDecres := SE2->E2_SDDECRE
			_xRet:=PADL(Alltrim(str((SE2->E2_SALDO - nAbat + nAcresc - nDecres ) * 100 )), 15 , "0")
		Else
			nAcresc := SE2->E2_SDACRES
			nDecres := SE2->E2_SDDECRE
			_xRet := PADL(Alltrim(str((SE2->E2_SALDO + nAcresc - nDecres ) * 100 )), 15 , "0")
		Endif
	Endif

ElseIf _cOpc = '2'
	
	If ALLTRIM(SEA->EA_MODELO)=="02"
		_xRet := "001"
	ElseIf !Empty(SE2->E2_FORBCO)
		_xRet := PADL(ALLTRIM(SE2->E2_FORBCO),3,"0")
	Else
		_xRet := PADL(ALLTRIM(SA2->A2_BANCO),3,"0")
	EndIf

ElseIf _cOpc = '3'
	If ALLTRIM(SEA->EA_MODELO)=="02"
		_xRet := "000000"
	ElseIf !Empty(SE2->E2_FORAGE)
		If ALLTRIM(SE2->E2_FORBCO) = '001'
			_xRet := "0"+PADL(ALLTRIM(SE2->E2_FORAGE),4,"0")+ALLTRIM(SE2->E2_FAGEDV)  
		Else 
			_xRet := "0"+PADL(ALLTRIM(SE2->E2_FORAGE),5,"0")
	    EndIf
	Else
		If ALLTRIM(SA2->A2_BANCO) = '001'
			_xRet := "0"+PADL(ALLTRIM(SA2->A2_AGENCIA),4,"0")+ALLTRIM(SA2->A2_DVAGE)  
		Else 
			_xRet := "0"+PADL(ALLTRIM(SA2->A2_AGENCIA),5,"0")
	    EndIf
	EndIf

ElseIf _cOpc = '4'
	If ALLTRIM(SEA->EA_MODELO)=="02"
		_xRet := "000000000000"
	ElseIf !Empty(SE2->E2_FORCTA)
		_xRet := PADL(ALLTRIM(SE2->E2_FORCTA),11,"0")
	Else
		_xRet := PADL(ALLTRIM(SA2->A2_NUMCON),11,"0")
	EndIf
EndIf

Return(_xRet)