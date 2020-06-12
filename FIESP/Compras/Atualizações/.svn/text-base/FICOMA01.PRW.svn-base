#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Ap5mail.ch"

#Define BMP_ON     "LBOK"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICOMA01  ºAutor  ³TOTVS               º Data ³  20/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para Liberacao de documentos.                        º±±
±±º          ³Funcao vem do ponto de entrada MTA097MNU                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICOMA01(_nOpcao)
// _nOpcao = 1 / Consulta
// _nOpcao = 2 / Liberacao
// _nOpcao = 3 / Estornar
Local _aArea	:= {}
Local _aAreaCR	:= {}
Local _cDoc		:= ""

If _nOpcao == 1 // Consulta
	If SCR->CR_TIPO == "SA"	// solicitacao ao Armazem
		U_FIESTA01(_nOpcao)
	Elseif SCR->CR_TIPO == "GC"	// solicitacao de Contrato
		U_FIGCTA01(_nOpcao)
	Elseif SCR->CR_TIPO == "RN"	// requisicao de numerario
		U_FIFINA02(_nOpcao)
	Elseif SCR->CR_TIPO == "CV"
		U_FICDVA02(_nOpcao)
	Else					// visualizacao padrao Pedido de Compras
		A097Visual(,,2)
	EndIf
ElseIf _nOpcao == 2 // Liberacao
	If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
		Help(" ",1,"A097LIB")
		Return()
	EndIf
	
	If SCR->CR_TIPO == "SA"  // solicitacao ao Armazem
		U_FIESTA01(_nOpcao)
	Elseif SCR->CR_TIPO == "GC"	// solicitacao de Contrato
		U_FIGCTA01(_nOpcao)
	Elseif SCR->CR_TIPO == "RN"	// requisicao de numerario
		U_FIFINA02(_nOpcao)
	Elseif SCR->CR_TIPO == "CV"
		U_FICDVA02(_nOpcao)
	Else
		A097Libera("SCR",recno(),2) // liberacao padrao Pedido de Compras
	EndIf
ElseIf _nOpcao == 3 // Estornar
	If SCR->CR_STATUS$"01"
		Aviso("A097BLQ","Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)",{"Ok"})
		Return()
	EndIf
	
	If SCR->CR_TIPO == "SA"  // solicitacao ao Armazem
		U_FIESTA01(_nOpcao)
	Elseif SCR->CR_TIPO == "GC"	// solicitacao de Contrato
		U_FIGCTA01(_nOpcao)
	Elseif SCR->CR_TIPO == "RN"	// requisicao de numerario
		U_FIFINA02(_nOpcao)
	Elseif SCR->CR_TIPO == "CV"
		U_FICDVA02(_nOpcao)
	Else
		A097Estorna("SCR",recno(),2) // estorno padrao Pedido de Compras
	EndIf
EndIf

Return
