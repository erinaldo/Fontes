#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICOME03  ºAutor  ³Microsiga           º Data ³  08/22/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a inclusao de Titulo a Receber conforme rateio      º±±
±±º          ³ e regra definida no Centro de Custo                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICOME03(_cNF,_cSerie, _nOpc)

Local _cQuery
Local lEnd := .T.

If _nOpc == 3
	_cQuery := "SELECT SDE.DE_CC, SUM(SDE.DE_CUSTO1) VALOR, CTT.CTT_XCLI AS CLIENTE, CTT.CTT_XLOJA AS LOJA, SA1.A1_NATUREZ AS NATUREZA, SDE.DE_DOC AS DOC, SDE.DE_SERIE AS SERIE "
	_cQuery += "FROM "+RetSqlName("SDE")+" SDE, "+RetSqlName("CTT")+" CTT, "+RetSqlName("SD1")+" SD1, "+RetSqlName("SA1")+" SA1 "
	_cQuery += "WHERE SDE.D_E_L_E_T_ = '' AND CTT.D_E_L_E_T_ = '' AND SD1.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' "
	_cQuery += "AND SDE.DE_CC = CTT.CTT_CUSTO "
	_cQuery += "AND SDE.DE_DOC = SD1.D1_DOC "
	_cQuery += "AND SDE.DE_SERIE = SD1.D1_SERIE "
	_cQuery += "AND SDE.DE_ITEMNF = SD1.D1_ITEM "
	_cQuery += "AND DE_DOC = '"+_cNF+"' "
	_cQuery += "AND DE_SERIE = '"+_cSerie+"' "
	_cQuery += "AND CTT.CTT_XGRTIT = '1' "
	_cQuery += "AND CTT.CTT_XCLI = SA1.A1_COD "
	_cQuery += "AND CTT.CTT_XLOJA = SA1.A1_LOJA "
	_cQuery += "GROUP BY SDE.DE_CC, CTT.CTT_XCLI, CTT.CTT_XLOJA, SA1.A1_NATUREZ, SDE.DE_DOC, SDE.DE_SERIE "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRBSDE",.t.,.t.)
ElseIf _nOpc == 5
	_cQuery := "SELECT E1_PREFIXO AS SERIE, E1_NUM AS DOC, E1_PARCELA AS PARCELA, E1_NATUREZ AS NATUREZA, E1_CLIENTE AS CLIENTE, E1_LOJA AS LOJA, E1_VALOR AS VALOR "
	_cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
	_cQuery += "WHERE D_E_L_E_T_ = '' "
	_cQuery += "AND E1_ORIGEM = 'MATA103' "
	_cQuery += "AND E1_NUM = '"+_cNF+"' "
	_cQuery += "AND E1_PREFIXO = '"+_cSerie+"' "
	_cQuery += "ORDER BY E1_NUM, E1_PARCELA "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRBSDE",.t.,.t.)
EndIf

DbSelectArea("TRBSDE")
DbGotop()
If _nOpc == 3
	_nParc := "01"
ElseIf _nOpc == 5
	_nParc := TRBSDE->PARCELA
EndIf
Do While !EOF()
	MsAguarde({|lEnd| U_FICOME30(_nOpc,_nParc)}, "Aguarde", "Processando Titulos a Receber", .F.)
	DbSelectArea("TRBSDE")
	TRBSDE->(DbSkip())
	If _nOpc == 3
		_nParc := Soma1(_nParc)
	ElseIf _nOpc == 5
		_nParc := TRBSDE->PARCELA
	EndIf		
EndDo

DbSelectArea("TRBSDE")
TRBSDE->(DbCloseArea())

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM  ºAutor  ³Microsiga           º Data ³  08/22/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICOME30(nOpc,_nParc)
Local aTitulo 		:= {}
Local lMsErroAuto 	:= .F.

Begin Transaction

aTitulo := {{"E1_PREFIXO"		,TRBSDE->SERIE				,Nil},;
			{"E1_NUM"			,TRBSDE->DOC				,Nil},;
			{"E1_PARCELA"		,_nParc						,Nil},;
			{"E1_TIPO"			,"NF "						,Nil},;
			{"E1_NATUREZ"		,TRBSDE->NATUREZA			,Nil},;
			{"E1_CLIENTE"		,TRBSDE->CLIENTE			,Nil},;
			{"E1_LOJA"			,TRBSDE->LOJA	   			,Nil},;
			{"E1_EMISSAO"		,dDataBase					,Nil},;
			{"E1_VENCTO"		,dDataBase					,Nil},;
			{"E1_VENCREA"		,dDataBase					,Nil},;
			{"E1_VALOR"			,TRBSDE->VALOR	   			,Nil},;
			{"E1_ORIGEM"		,"MATA103"					,Nil }}

MSExecAuto({|x,y| FINA040(x,y)},aTitulo,nOpc)
If lMsErroAuto
	MostraErro()
	DisarmTransaction()
	break
EndIf

End Transaction

Return()