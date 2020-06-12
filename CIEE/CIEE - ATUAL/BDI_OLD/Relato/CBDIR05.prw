#include "rwmake.ch"

//oPrn:Say(0250,1400,Transform(mv_par01,"99/99/9999"),oFont10N,50)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIR05   บAutor  ณMicrosiga           บ Data ณ  10/19/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIR05()

// Declara variaveis
Local  oFont10, oFont10N, oFont10S, oPrn
Local  nLin
Local  lBold, lUnderL, lPixel, lPrint

lBold  := .t.
lUnderL:= .t.
lPixel := .t.
lPrint := .f.
nLin   := 3000

// Define fontes
oFont10  := TFont():New("Garamond",,10,,.f.,,,,,.f.) // Normal
oFont10N := TFont():New("Garamond",,10,,.t.,,,,,.f.) // Negrito
oFont10S := TFont():New("Garamond",,10,,.f.,,,,,.t.) // Sublinhada

// Instancia objeto
oPrn   := TMSPrinter():New("Etiqueta")

// Define formato da pagina - LandScape / Portrait
oPrn:SetPortrait()

DbSelectarea("TMP1")
DbGotop()

If RecCount() < 1
	MsgBox("Nao ha relatorio para exibir!","A T E N C A O","ALERT")
	Return
Endif

oPrn:EndPage()
oPrn:StartPage()
nLin := 370
nLin += 50

Do While !EOF()

	Do Case
		Case marked(TMP1->OK)
			If Empty(TMP1->OK)
				If nLin > 2935
					oPrn:EndPage()
					oPrn:StartPage()
					nLin := 370
				Endif
				oPrn:Say(0175,0800,TMP1->NOME             ,oFont10N,50)
				oPrn:Say(0250,0800,TMP1->CARGO            ,oFont10N,50)
				oPrn:Say(0250,1400,TMP1->NOME1            ,oFont10N,50)
				oPrn:Say(0370,0250,TMP1->ENDERECO         ,oFont10N,50)
				oPrn:Say(0565,0250,OemToAnsi("CENTRO")    ,oFont10N,50)
				oPrn:Say(0760,0250,OemToAnsi("SAO PAULO") ,oFont10N,50)
				oPrn:Say(0960,0250,OemToAnsi("SP")        ,oFont10N,50)
				oPrn:Say(1150,0250,OemToAnsi("9999-999")  ,oFont10N,50)
		    EndIf
		Case TMP1->OK == cMarca
				If nLin > 2935
					oPrn:EndPage()
					oPrn:StartPage()
					nLin := 370
				Endif
				oPrn:Say(0175,0800,TMP1->NOME             ,oFont10N,50)
				oPrn:Say(0250,0800,TMP1->CARGO            ,oFont10N,50)
				oPrn:Say(0250,1400,TMP1->NOME1            ,oFont10N,50)
				oPrn:Say(0370,0250,TMP1->ENDERECO         ,oFont10N,50)
				oPrn:Say(0565,0250,OemToAnsi("CENTRO")    ,oFont10N,50)
				oPrn:Say(0760,0250,OemToAnsi("SAO PAULO") ,oFont10N,50)
				oPrn:Say(0960,0250,OemToAnsi("SP")        ,oFont10N,50)
				oPrn:Say(1150,0250,OemToAnsi("9999-999")  ,oFont10N,50)
	EndCase

	TMP1->(DBSkip())
	
EndDo

// Exibe spool de impressao
oPrn:Preview()

DbSelectArea("TMP1")
DbGotop()

Return