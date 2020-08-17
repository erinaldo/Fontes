#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TOPCONN.CH"          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Funcao: F430VAR	 	Autor: Tatiana A. Barbosa	Data: 21/03/11	       ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±	Descricao: 															   ±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±				Uso:  CSU CardSystem S.A								   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                                                	

User Function F430VAR()

Local _aArea   		:= 	GetArea()
Local _cAntForne	:=	Substr(Paramixb[1][16],15,3)      
Local __cIdCnab		:=  Substr(Paramixb[1][1],1,10) 
Local _cCodBanco	:=	Substr(Paramixb[1][16],1,3)
Local _cCodSequenc	:=	Substr(Paramixb[1][16],14,1)

If Empty(__cIdCnab)
	RestArea(_aArea)
	Return
EndIf

If _cCodBanco == "399" .And. (_cCodSequenc == "A" .Or. _cCodSequenc == "J")
	If _cAntForne == "510"
		Paramixb[1][16] := Substr(Paramixb[1][16],1,230)+"10"+Substr(Paramixb[1][16],233,10)
		DbSelectArea("SE2")
		DbSetOrder(11)
		DbSeek(xFilial("SE2")+__cIdCnab)
		If SE2->(Found())      
			RecLock("SE2",.F.)
			SE2->E2_XDTANTE := dDataBase  
			SE2->(MsUnLock())
		EndIf	
		dBaixa		:=	" "
		nValPgto	:=	"0.00"
		cOcorr		:=	"10"      
	EndIf
EndIf
	
RestArea(_aArea)
Return (Paramixb[1][16])