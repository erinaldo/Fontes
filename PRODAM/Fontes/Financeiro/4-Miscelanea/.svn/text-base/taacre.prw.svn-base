#INCLUDE "RWMAKE.ch"
#include "topconn.ch"  
#Include "Protheus.Ch"
#Include "PROTDEF.Ch"
// usado para testes de baixa parcial

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  TAACRE    ºAutor  ³Rosana F. Silva       º Data ³  18/08/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula o valor de saldo, decrescimo e acrescimo           º±±
±±º          ³   														  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 11 TA                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TAACRE(nPar1)          

Local _nSoma := 0
Local _nTtAbat := 0
Local _Liqui := 0
Default nPar1:=0
 
_TtAbat   := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
_TtAbat   += Iif(Empty(SE2->E2_BAIXA),SE2->E2_DECRESC,0)
_Liqui    := (SE2->E2_SALDO-_TtAbat+Iif(Empty(SE2->E2_BAIXA),SE2->E2_ACRESC,0))

IF SE2->E2_ACRESC > 0 .OR. SE2->E2_DECRESC >0 
	_nSoma := SE2->E2_SALDO + Iif(Empty(SE2->E2_BAIXA),SE2->E2_ACRESC,0) - Iif(Empty(SE2->E2_BAIXA),SE2->E2_DECRESC,0)
Else
	_nSoma := SE2->E2_SALDO
Endif

//IF SE2->E2_ACRESC > 0 .OR. SE2->E2_DECRESC >0 
//	_nSoma := SE2->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC
//Else
//  _nSoma := SE2->E2_SALDO
//Endif
                            
// chamado na sessão PP003 (desconto) do Pagar341.prw
If nPar1=1			
	Return (_nSoma)
EndIf

if _nSoma < 0
	_nSoma := _nSoma * -1
Endif
_nSoma := STRZERO(_nSoma*100,15)

Return(_nSoma) 
