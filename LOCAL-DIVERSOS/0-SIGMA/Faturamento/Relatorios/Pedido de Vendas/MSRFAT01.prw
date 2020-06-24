#Include "TOTVS.CH"

/*/{Protheus.doc} MSRFAT01

Rotina Principal do Acelerador do Relatório do Pedido de Venda

@type function
@author Hermes Vieira
@since 27/10/2006

@history 21/06/2016, Carlos Eduardo Niemeyer Rodrigues
/*/
User Function MSRFAT01()
	Local oClassRelatorioPV	:= ClassRelatorioPV():newClassRelatorioPV()
	Local cOpt				:= ""
	Local lAuto 			:= .F.
	Local cNum  			:= ""

	If MsgYesNo("Deseja Enviar Relatório via E-Mail?","Envia E-Mail")
		cOpt := "mail"
	else
		cOpt := "grafico"
	Endif

	If FunName() == "MATA410"
		lAuto := .T.
		cNum  := SC5->C5_NUM
	Endif

	If cOpt == "mail"
		U_MSRFATHT(lAuto,cNum)
	Else
		U_MSRFATGF(lAuto,cNum)
	EndIf     

Return