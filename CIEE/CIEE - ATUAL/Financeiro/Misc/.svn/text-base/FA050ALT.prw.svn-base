#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050ALT  ºAutor  ³Emerson             º Data ³  18/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para tratar contabilizacao de             º±±
±±º          ³ amortizacao                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050ALT()

_cValid    := .T.
_aArea     := GetArea() 

// PATRICIA FONTANEZI 06/12/2012

M->E2_VALLIQ	:= (M->E2_VALOR + M->E2_ACRESC) - (M->E2_DECRESC)

//CHAMADA DA ROTINA DE AMORTIZACAO
If Empty(SE2->E2_TPAMORT) .or. SE2->E2_TPAMORT == "N"
	If M->E2_TPAMORT == "S"
	//	MsgBox("Rotina de amortizacao realizada!!!","Atencao")
		If Empty(M->E2_CNTD_AM).or.Empty(M->E2_CCD_AM).or.Empty(M->E2_PARC_AM).or.Empty(M->E2_HIST_AM).or.Empty(M->E2_CNTC_AM)
			MsgBox("Alguns dos campos nao esta preenchido. Verificar pasta Amortizacao!!!","Atencao")
			_cValid    := .F.
			RestArea(_aArea)
			Return(_cValid)
		Else
			If Substr(M->E2_CNTD_AM,1,1) $ "1|2"
				If !Empty(M->E2_CCD_AM)
					MsgBox(OemToAnsi("Conta Contabil Grupo 1 e 2 Nao Permite Centro de Custo!!!"),OemToAnsi("Atenção"))
					_cValid    := .F.
					RestArea(_aArea)
					Return(_cValid)
				EndIf
			Else
				If Empty(M->E2_CCD_AM)
					MsgBox(OemToAnsi("Conta Contabil Grupo 3 e 4 Obrigatório Centro de Custo!!!"),OemToAnsi("Atenção"))
					_cValid    := .F.
					RestArea(_aArea)
					Return(_cValid)
				EndIf
			EndIf		
	
			If Substr(M->E2_CNTC_AM,1,1) $ "1|2"
				If !Empty(M->E2_CCC_AM)
					MsgBox(OemToAnsi("Conta Contabil Grupo 1 e 2 Nao Permite Centro de Custo!!!"),OemToAnsi("Atenção"))
					_cValid    := .F.
					RestArea(_aArea)
					Return(_cValid)
				EndIf
			Else
				If Empty(M->E2_CCC_AM)
					MsgBox(OemToAnsi("Conta Contabil Grupo 3 e 4 Obrigatório Centro de Custo!!!"),OemToAnsi("Atenção"))
					_cValid    := .F.
					RestArea(_aArea)
					Return(_cValid)
				EndIf
			EndIf		
		EndIf
		lEnd	:= .F.
		MsAguarde({|lEnd| RunProc(@lEnd)}, "Aguarde...", OemToAnsi("Processando Contabilização Amortização..."),.T.)
	EndIf
//Else
//	MsgBox("Documento ja gerou Amortizacao, não é permitido alterar o campo AMORTIZACAO para NÂO!!!!","ALERT")
//	_cValid    := .F.
//	RestArea(_aArea)
//	Return(_cValid)
EndIf

RestArea(_aArea)

Return(_cValid)

Static Function RunProc(lEnd)

	_nValor	:= M->(E2_VALOR+E2_INSS+E2_IRRF+E2_ISS+E2_PIS)
	u_xCntAmor(M->E2_CNTD_AM,M->E2_CCD_AM,M->E2_PARC_AM,M->E2_HIST_AM,M->E2_CNTC_AM,M->E2_CCC_AM,_nValor,xFilial("SE2")+M->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
	lEnd	:= .T.

Return(lEnd)		