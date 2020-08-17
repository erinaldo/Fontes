#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |MT100LOK  ºAutor  ³ Sergio Oliveira    º Data ³  Abr/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na nota fiscal de entrada para validar a  º±±
±±º          ³ competencia da NFE.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º****** IMPORTANTE ******³ Este programa faz a chamada do ponto de en-  º±±
±±º****** IMPORTANTE ******³ MT100TOK.PRW. Qualquer alteracao a ser efetu-º±±
±±º****** IMPORTANTE ******³ ada neste ponto de entrada, deve-se fazer o  º±±
±±º****** IMPORTANTE ******³ teste na rotina chamada (MT100Tok.prw) e vi- º±±
±±º****** IMPORTANTE ******³ ce-versa.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA103.prw                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100LOK(pcCampo)

Local _aArea 	:= GetArea(), _aAreaSC7 := SC7->( GetArea() )
Local _aAreaSD1	:= SD1->(GetArea())
Local _lEnd 	:= .t.
Local nY		:= 0
Local cNaturez  := GdFieldGet('D1_NATFULL')
Local cCompet   := GdFieldGet('D1_XDTAQUI')
Local nDifPC    := GetMV("MV_X_DIFPC")

If IsInCallStack("MATA103") .And. !IsInCallStack("A103DEVOL") .And. !IsInCallStack("COMXCOL") //Retirado a obrigatoriedade do SX3 dos campos D1_NATFULL e D1_XDTAQUI e tratado aqui - OS 3041/15 - Eduardo Dias //OS 0239/17 TOTVS COLABORAÇÃO
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	
	// Correção OS 3071/16 - Douglas
	If Empty(cNaturez)
		MsgAlert("É Obrigatorio o preenchimento do campo Natureza")
		Return(.F.)
	Endif
	
	If IsInCallStack("A103NFiscal")
		If Type("M->D1_XDTAQUI") != "U"
			If Empty(STRTRAN(M->D1_XDTAQUI, "/", " "))
				MsgAlert("É Obrigatorio o preenchimento do campo Competencia")
				Return(.F.)
			EndIf
		ElseIf Empty(cCompet)
			MsgAlert("É Obrigatorio o preenchimento do campo Competencia")
			Return(.F.)
		EndIf
	EndIf
	If !IsInCallStack("A103NFiscal")
		If Empty(M->D1_XDTAQUI)
			MsgAlert("É Obrigatorio o preenchimento do campo Competencia")
			Return(.F.)
		EndIf
	Endif
	
EndIf

If !Empty( pcCampo ) // Esta vindo do campo D1_X_DTAQUI
	ParamIxb := {.t.}
	_lEnd := U_Mt100Tok(pcCampo)
Else                 // Validacao de troca da linha
	If ParamIxb[1]
		_lEnd := U_Mt100Tok('E')
	EndIf
EndIf

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ # Chamado 004265: Nao permitir que o Valor Unitario x Quantidade fique di- ³
³                   ferente do valor total da nota fiscal de entrada.        ³
³                   Nao permitir tambem que quantidade e valor unitario da   ³
³                   NFE nao sejam superiores aos respectivos PC's.           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

If _lEnd
	
	If Round( GdFieldGet('D1_QUANT') * Round( GdFieldGet('D1_VUNIT'), TamSX3("D1_VUNIT")[2] ),TamSX3("D1_TOTAL")[2] ) # Round( GdFieldGet('D1_TOTAL'), TamSX3("D1_TOTAL")[2] )
		cTxtBlq := "Valor total invalido. Verifique a quantidade * valor unitário!"
		Aviso("Quantidade * Preço Unitário",cTxtBlq,;
		{"&Fechar"},3,"Valor Total Divergente",,;
		"PCOLOCK")
		_lEnd := .f.
	EndIf
	
	If _lEnd
		If SC7->( DbSetOrder(1), DbSeek(xFilial("SC7")+GdFieldGet('D1_PEDIDO')+GdFieldGet('D1_ITEMPC') ) )
			If SC7->C7_MOEDA == 1  //OS 0920/17 - By Douglas 
				_nPrcPC := xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,1,M->dDEmissao,TamSX3("D1_VUNIT")[2],SC7->C7_TXMOEDA)
				//If GdFieldGet('D1_VUNIT') > _nPrcPC
				If (GdFieldGet('D1_VUNIT')- nDifPC)  > _nPrcPC // OS 2313/17 - By Douglas			
					cTxtBlq := "- O Valor do item nao poderá ser maior que o do Pedido de Compras!"+Chr(13)+Chr(10)
					_lEnd   := .f.
				EndIf
				If GdFieldGet('D1_QUANT') > SC7->C7_QUANT - SC7->C7_QUJE
					cTxtBlq := "- A quantidade nao poderá ser maior que a do Pedido de Compras!"+Chr(13)+Chr(10)
					_lEnd   := .f.
				EndIf
				If !_lEnd
					Aviso("Quantidade * Preço Unitário",cTxtBlq,;
					{"&Fechar"},3,"Valor Total Divergente",,;
					"PCOLOCK")
				EndIf
			EndIf
		Endif
	EndIf
	
EndIf

SC7->( RestArea( _aAreaSC7 ) )
SD1->( RestArea( _aAreaSD1 ) )

RestArea( _aArea )

Return( _lEnd )
