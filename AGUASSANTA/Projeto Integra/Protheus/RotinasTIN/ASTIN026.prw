#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN026
Chamado pelo PE Fa040DEL
Cancela a baixa dos titulos de origem
@return		Nenhum
@author		Nivia Ferreira
@since		07/03/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN026() //F0102006()

	Local aBaixa     := {}
	Local cMotiv     := "Cancelamento baixa título renegociado (origem)"
	private cChave   := SE1->E1_NUM+SE1->E1_TIPO+SE1->E1_NATUREZ+SE1->E1_CLIENTE+SE1->E1_LOJA
	private aOriAglu :={}
	Private lMsErroAuto := .F.

	//Se titulo renegociado (aglutinado)
	IF	SE1->E1_XAGLUT == '1' .And. Empty(SE1->E1_XTITAGL) .And. SE1->(deleted())

		Begin Transaction

			SE1->(DbOrderNickName("RENEGOCIA"))
			//E1_FILIAL+E1_XTITAGL+E1_TIPO+E1_NATUREZ+E1_CLIENTE+E1_LOJA
			SE1->(MsSeek(xFilial("SE1") + cChave ))

			While !SE1->(Eof()) .And. xFilial('SE1') == SE1->E1_FILIAL .and.;
			cChave == SE1->E1_XTITAGL+SE1->E1_TIPO+SE1->E1_NATUREZ+SE1->E1_CLIENTE+SE1->E1_LOJA

				//Cancela baixa titulos de origem
				dbselectarea("SE5")
				dbsetorder(7)
				If 	dbseek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)

					aBaixa  := {}
					aBaixa 	:= {{"E1_PREFIXO"	, SE5->E5_PREFIXO 		,Nil},;
					{"E1_NUM"		, SE5->E5_NUMERO       	,Nil},;
					{"E1_PARCELA"	, SE5->E5_PARCELA  		,Nil},;
					{"E1_TIPO"	    , SE5->E5_TIPO     		,Nil},;
					{"AUTMOTBX"	    , SE5->E5_MOTBX      	,Nil},;
					{"AUTDTBAIXA"	, SE5->E5_DATA			,Nil},;
					{"AUTDTCREDITO" , SE5->E5_DTDISPO		,Nil},;
					{"AUTHIST"	    , cMotiv				,Nil},;
					{"AUTVALREC"	, SE5->E5_VALOR		    ,Nil}}

					lMsErroAuto := .F.
					MSExecAuto({|x,y| Fina070(x,y)},aBaixa,5)//5 - Cancelamento de baixa

					IF 	lMsErroAuto .Or. !Empty(SE1->E1_BAIXA)
						AutoGrLog("Problema no Cancelamento de baixa de título renegociado (origem)." )
						MostraErro()
						DisarmTransaction()
						Break
					Else
						aAdd(aOriAglu,{  xFilial("SE1") ,;
						SE1->E1_CLIENTE,;
						SE1->E1_LOJA   ,;
						SE1->E1_PREFIXO,;
						SE1->E1_NUM    ,;
						SE1->E1_PARCELA,;
						SE1->E1_TIPO   ,;
						SE1->E1_XTITAGL })
					EndIf
				Endif
				SE1->(DbOrderNickName("RENEGOCIA"))
				SE1->(dbSkip())
			EndDo
			///Não apresentou erro na transação
			///Limpa aglutinação dos titulos Originais
			If(!lMsErroAuto)
				fRemvAgl()
			Endif
		End Transaction
	EndIf

	Return (!lMsErroAuto)

	**********************************************************************
// procurar os titulo que tivera as baixas canceladas
// na exclusão do aglutinador e remove o vinculo com o aglutinador
Static Function fRemvAgl()
	**********************************************************************
	Local nXi := 1
	private ckey :=''
	For nXi := 1 To Len (aOriAglu)
		ckey:= aOriAglu[nXi][1] + ; //SE1->E1_FILIAL
		aOriAglu[nXi][2] + ; //SE1->E1_CLIENTE
		aOriAglu[nXi][3] + ; //SE1->E1_LOJA
		aOriAglu[nXi][4] + ; //SE1->E1_PREFIXO
		aOriAglu[nXi][5] + ; //SE1->E1_NUM
		aOriAglu[nXi][6] + ; //SE1->E1_PARCELA
		aOriAglu[nXi][7]     //SE1->E1_TIPO

		DbSelectArea("SE1")
		DbSetOrder(2)
		SE1->(DbGoTOP())
		SE1->(msSeek( ckey ))
		While !SE1->(Eof()) .And. ckey == SE1->E1_FILIAL  + SE1->E1_CLIENTE + SE1->E1_LOJA +;
		SE1->E1_PREFIXO + SE1->E1_NUM     + SE1->E1_PARCELA + SE1->E1_TIPO

			if(SE1->E1_XTITAGL == aOriAglu[nXi][8])
				Reclock("SE1", .F.)
				SE1->E1_XAGLUT  := ''
				SE1->E1_XTITAGL := ''
				SE1->E1_XOK		:= ''
				SE1->(msunlock())
			EndIf
			SE1->(dbSkip())
		EndDo
	Next nXi
return

