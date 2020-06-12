#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT160WF  ºAutor  ³Ligia Sarnauskas     º Data ³  23/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada gravar informacoes no pedido logo apos    º±±
±±º          ³ a confirmação da analise da cotação                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MT160WF()

Local aResult    := {} //-- Gera notificacao - Encerramento de cotacao
_cNumCot:=SC7->C7_NUMCOT

Dbselectarea("SC8")
Dbsetorder(1)
If Dbseek(xFilial("SC8")+_cNumCot)
	While SC8->C8_NUM == _cNumCot
		If !empty(SC8->C8_NUMPED)
			Dbselectarea("SC7")
			dBSETORDER(1)
			If Dbseek(xFilial("SC7")+SC8->C8_NUMPED+SC8->C8_ITEMPED)
				Reclock("SC7",.F.)
			   //	SC7->C7_X_OBSPE:=SC8->C8_XOBSSOL
				SC7->C7_OBS:=Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,"A2_NOME" )
				Dbselectarea("SC1")
				dBSETORDER(1)
				If Dbseek(xFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC)
					SC7->C7_OBS:=Posicione("CTT",1,xFilial("CTT")+SC1->C1_CC,"CTT_DESC01" )
				ENDIF
				MsUnlock()
			Endif
		Endif
		Dbselectarea("SC8")
		Dbskip()
	Enddo
Endif

Return
