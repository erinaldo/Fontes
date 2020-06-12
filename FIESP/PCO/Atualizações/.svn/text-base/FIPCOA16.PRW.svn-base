#INCLUDE "protheus.ch"
#INCLUDE "apwizard.ch"
#INCLUDE "topconn.ch"

Static GRID_STEP 
Static __lBlind      := IsBlind()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIPCOA16 บ Autor ณ Claudinei Ferreira บ Data ณ  17/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importacao de Planilha CSV de or็amento.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FIPCOA16()
Local oWizard
Local cArquivo
Local aArea    := GetArea()
Local aAreaAK1 := AK1->(GetArea())
Local aAreaAK2 := AK2->(GetArea())
Local aAreaAK3 := AK3->(GetArea())
Local aAreaAKE := AKE->(GetArea())
Local aAreaSX3 := SX3->(GetArea())
Local lRet 		:= .F.
Local lParam, lBrowse:=.T.
Local aParametros := {	{ 1 ,"Filial"						,Space(LEN(AK1->AK1_FILIAL))			,"@!" 	 ,""  ,"" 	 ,".F." ,15 ,.T. },;
								{ 1 ,"Planilha or็amentแria"	,Replicate(" ",LEN(AK1->AK1_CODIGO)),"@!" 	 ,""  ,"AK1" ,".F." ,65 ,.T. },;
								{ 1 ,"Revisใo"						,Replicate(" ",LEN(AKE->AKE_REVISA)),"@!" 	 ,""  ,"AKE1",".F." ,65 ,.T. },;
								{ 1 ,"Conta orcamentแria de"	,Replicate(" ",LEN(AK2->AK2_CO)) 	,"@!" 	 ,""  ,"AK5" ,"" ,65 ,.F. },;
								{ 1 ,"Conta orcamentแria at้"	,Replicate(" ",LEN(AK2->AK2_CO)) 	,"@!" 	 ,""  ,"AK5" ,"" ,65 ,.T. },;
								{ 1 ,"Centro de custo de"		,Replicate(" ",LEN(AK2->AK2_CC)) 	,"@!" 	 ,""  ,"CTT" ,"" ,65 ,.F. },;
								{ 1 ,"Centro de custo at้"		,Replicate(" ",LEN(AK2->AK2_CC)) 	,"@!" 	 ,""  ,"CTT" ,"" ,65 ,.T. },;
								{ 1 ,"Item contแbil de"			,Replicate(" ",LEN(AK2->AK2_ITCTB)) ,"@!" 	 ,""  ,"CTD" ,"" ,65 ,.F. },;
								{ 1 ,"Item contแbil at้"		,Replicate(" ",LEN(AK2->AK2_ITCTB)) ,"@!" 	 ,""  ,"CTD" ,"" ,65 ,.T. },;
								{ 1 ,"Classe de valor de"		,Replicate(" ",LEN(AK2->AK2_CLVLR)) ,"@!" 	 ,""  ,"CTH" ,"" ,65 ,.F. },;
								{ 1 ,"Classe de valor at้"		,Replicate(" ",LEN(AK2->AK2_CLVLR)) ,"@!" 	 ,""  ,"CTH" ,"" ,65 ,.T. },;
								{ 2 ,"Apagar itens da planilha"	,1 ,{"1=Nใo apagar itens da planilha","2=Sim. Apagar itens na faixa informada","3=Sim. Apagar TODOS os registros"} ,100, "", .T.},;
								{ 6	,"Arquivo"					,Space(60),"",,"",90 ,.T.,"",'',GETF_LOCALHARD+GETF_LOCALFLOPPY}}

Local aConfig := {AK1->AK1_FILIAL,AK1->AK1_CODIGO,IF(Empty(AK1->AK1_VERREV), AK1->AK1_VERSAO, AK1->AK1_VERREV),Replicate(" ",LEN(AK2->AK2_CO)),Replicate("Z",LEN(AK2->AK2_CO)),Replicate(" ",LEN(AK2->AK2_CC)),Replicate("Z",LEN(AK2->AK2_CC)),Replicate(" ",LEN(AK2->AK2_ITCTB)),Replicate("Z",LEN(AK2->AK2_ITCTB)),Replicate(" ",LEN(AK2->AK2_CLVLR)),Replicate("Z",LEN(AK2->AK2_CLVLR)),"1",""}
Local aPerAux  := {}
PRIVATE aAuxCps
PRIVATE cRevisa
PRIVATE cPlanAnt := ""
PRIVATE cCtaOrc := ""
Private cPlanOri 	:= AK1->AK1_CODIGO
Private cRevOri 	:= IF(Empty(AK1->AK1_VERREV), AK1->AK1_VERSAO, AK1->AK1_VERREV)
Private cCtaOri 	:= AK3->AK3_CO
Private aPeriodo 	:= PcoRetPer()

dbSelectArea("AK3")
dbSeek(xFilial("AK3")+cPlanOri+cRevOri+cPlanOri)

If AK1->(FieldPos("AK1_XAPROV"))>0
	If AK1->AK1_XAPROV <> "0"
		MsgStop("A planilha or็amentแria deve estar com a situa็ใo igual a '0 - Em aberto' para que possa importar dados. Verifique!","Aten็ใo")
		
		RestArea(aArea)
		RestArea(aAreaAK1)
		RestArea(aAreaAK2)
		RestArea(aAreaAK3)
		RestArea(aAreaAKE)
		
		Return
	Endif
Endif

oWizard := APWizard():New("Aten็ใo"/*<chTitle>*/,;
"Este assistente lhe ajudara a importar os dados de um arquivo CSV para uma planilha or็amentแria."/*<chMsg>*/, "Importa็ใo para Planilha Or็amentแria"/*<cTitle>*/, ;
"Voc๊ deverแ indicar os parโmetros e ao finalizar o assistente, os dados serใo importados conforme os parโmetros solicitados."/*<cText>*/,;
{||.T.}/*<bNext>*/, ;
{||.T.}/*<bFinish>*/,;
/*<.lPanel.>*/, , , /*<.lNoFirst.>*/)

oWizard:NewPanel( "Parโmetros"/*<chTitle>*/,;
"Neste passo voc๊ deverแ informar os parโmetros para importa็ใo da planilha or็amentแria."/*<chMsg>*/, ;
{||.T.}/*<bBack>*/, ;
{||.T.}/*<bNext>*/, ;
{|| Rest_Par(aConfig),Iif(ParamOk(aParametros, aConfig), lRet := xProc(aConfig, cCtaOrc, cPlanOri, cRevOri, cPlanOri, aPeriodo, aPerAux), lRet := .F.) }/*<bFinish>*/,;
.T./*<.lPanel.>*/,;
{||Plan_Box(oWizard,@lParam, aParametros, aConfig)}/*<bExecute>*/ )

oWizard:Activate( .T./*<.lCenter.>*/,;
{||.T.}/*<bValid>*/, ;
{||.T.}/*<bInit>*/, ;
{||.T.}/*<bWhen>*/ )

RestArea(aAreaSX3)
RestArea(aArea)
RestArea(aAreaAK1)
RestArea(aAreaAK2)
RestArea(aAreaAK3)
RestArea(aAreaAKE)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณA   Plan_Box บAutor  ณPaulo Carnelossi  บ Data ณ 16/05/05   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para escolha da planilha a ser copiada               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Plan_Box(oWizard, lParam, aParametros, aConfig)
LOCAL cLoad		:= ""						// Nome do arquivo aonde as respostas do usuแrio serใo salvas / lidas
LOCAL lCanSave	:= .T.						// Se as respostas para as perguntas podem ser salvas
LOCAL lUserSave := .T.						// Se o usuแrio pode salvar sua propria configuracao

If lParam == NIL
	ParamBox(aParametros ,"Parametros", @aConfig,,,.F.,120,3, oWizard:oMPanel[oWizard:nPanel], cLoad, lCanSave, lUserSave)
	lParam := .T.
Else
	Rest_Par(aConfig)
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ Rest_Par   บAutor  ณPaulo Carnelossi   บ Data ณ 16/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para restauracao dos conteudos das variaveis MV_PAR  บฑฑ
ฑฑบ          ณna navegacao entre os paineis do assistente de copia        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Rest_Par(aParam)
Local nX
Local cVarMem

For nX := 1 TO Len(aParam)
	cVarMem := "MV_PAR"+AllTrim(STRZERO(nX,2,0))
	&(cVarMem) := aParam[nX]
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ Fim_Wiz    บAutor  ณPaulo Carnelossi   บ Data ณ 16/05/05   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para execucao das rotinas de copias quando pressionarบฑฑ
ฑฑบ          ณo botao Finalizar do assistente de copia                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Fim_Wiz(aConfig, cCtaOrc, cPlanOri, cRevOri, aPeriodo, aPerAux,lEnd,oProcess)
Local lRet 		:= .T.
Local cAliasTmp	:= GetNextAlias()
Local aEstrut	:= {}
Local aCampos	:= {}
Local aCposPer	:= {}
Local cCposPer	:= ""
Local aTxt	:= {}
Local _nValor := 0
Local aPosCampos:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estrutura do arquivo temporario ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aEstrut, { "LINHA"		,"C", 5, 0 } )
aAdd( aEstrut, { "AK2_FILIAL"	,"C", TamSx3("AK2_FILIAL")[1], 0 } )
aAdd( aEstrut, { "AK2_ID"		,"C", TamSx3("AK2_ID")[1], 0 } )
aAdd( aEstrut, { "AK2_ORCAME"	,"C", TamSx3("AK2_ORCAME")[1], 0 } )
aAdd( aEstrut, { "AK2_VERSAO"	,"C", TamSx3("AK2_VERSAO")[1], 0 } )
aAdd( aEstrut, { "AK2_CO"		,"C", TamSx3("AK2_CO")[1], 0 } )
aAdd( aEstrut, { "AK2_CC"		,"C", TamSx3("AK2_CC")[1], 0 } )
aAdd( aEstrut, { "AK2_ITCTB"	,"C", TamSx3("AK2_ITCTB")[1], 0 } )
aAdd( aEstrut, { "AK2_CLVLR"	,"C", TamSx3("AK2_CLVLR")[1], 0 } )
aAdd( aEstrut, { "AK2_CLASSE"	,"C", TamSx3("AK2_CLASSE")[1], 0 } )
aAdd( aEstrut, { "AK2_OPER"		,"C", TamSx3("AK2_OPER")[1], 0 } )

// Campos de Acordo com o Periodo
For nX := 1 to Len(aPeriodo)
	aAdd( aEstrut, { "P"+StrTran(Substr(aPeriodo[nX],1,10),"/","") 	,"N", TamSx3("AK2_VALOR")[1], 2 } )
	aAdd( aCposPer, Substr(aPeriodo[nX],1,10) )
	cCposPer += Substr(aPeriodo[nX],1,10)+"|"
Next nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo temporario ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cNomeArq := CriaTrab( aEstrut, .T. )
dbUseArea( .T.,,cNomeArq, cAliasTmp, .F., .F. )

IndRegua( cAliasTmp, cNomeArq, "AK2_FILIAL+AK2_ORCAME+AK2_VERSAO+AK2_CO+AK2_CC+AK2_ITCTB+AK2_CLVLR",,,"Criando Indice, aguarde..." )

dbClearIndex()
dbSetIndex( cNomeArq + OrdBagExt() )

// Campos para Validacao
aAdd(aCampos,"AK2_FILIAL")
aAdd(aCampos,"AK2_ID")
aAdd(aCampos,"AK2_ORCAME")
aAdd(aCampos,"AK2_VERSAO")
aAdd(aCampos,"AK2_CO")
aAdd(aCampos,"AK2_CC")
aAdd(aCampos,"AK2_ITCTB")
aAdd(aCampos,"AK2_CLVLR")
aAdd(aCampos,"AK2_CLASSE")
aAdd(aCampos,"AK2_OPER")

aEval( aCposPer,{|x| aAdd(aCampos,x) } )

//Define o valor do array conforme estrutura
aPosCampos:= Array(Len(aCampos))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abre o arquivo a ser importado                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If (nHandle := FT_FUse(AllTrim(MV_PAR13)))== -1
	Help(" ",1,"NOFILE")
	Return
EndIf

// Valida se o Arquivo ้ CSV
If upper(Right(Alltrim(MV_PAR13),3)) <> "CSV"
	Help(" ",1, "ARQINV","Arquivo invแlido","O arquivo de importa็ใo nใo ้ um arquivo CSV.",1,0 )
	fClose(nHandle)
	Return
Endif

FT_FGOTOP()
cLinha := FT_FREADLN()
nPos	:=	0
nAt	:=	1

While nAt > 0
	nPos++
	nAt	:=	AT(";",cLinha)
	If nAt == 0
		cCampo := cLinha
	Else
		cCampo	:=	Substr(cLinha,1,nAt-1)
	Endif
	nPosCpo	:=	Ascan(aCampos,{|x| x==cCampo})
	If nPosCPO > 0
		aPosCampos[nPosCpo]:= nPos
	Endif
	cLinha	:=	Substr(cLinha,nAt+1)
Enddo

If (nPosNil:= Ascan(aPosCampos,Nil)) > 0
	Aviso("Estrutura incorreta.","O campo "+aCampos[nPosNil]+" nใo foi encontrado na estrutura do arquivo, por favor verifique.",{"Sair"})
	fClose(nHandle)
	Return .F.
Endif

// Inicia Importacao das Linhas
FT_FSKIP()
While !FT_FEOF()
	cLinha := FT_FREADLN()
	AADD(aTxt,{})
	nCampo := 1
	While At(";",cLinha)>0
		aAdd(aTxt[Len(aTxt)],Substr(cLinha,1,At(";",cLinha)-1))
		nCampo ++
		cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
	End
	If Len(AllTrim(cLinha)) > 0
		aAdd(aTxt[Len(aTxt)],StrTran(Substr(cLinha,1,Len(cLinha)),'"','') )
	Else
		aAdd(aTxt[Len(aTxt)],"")
	Endif
	FT_FSKIP()
End

// Gravacao dos Itens no TRB
FT_FUSE()
For nX:=1 To Len(aTxt)
	dbSelectArea(cAliasTmp)
	RecLock((cAliasTmp),.T.)
	(cAliasTmp)->LINHA 		:= Alltrim(Str(nX))
	For nY:=1 To Len(aCampos)
		//For nY:=1 To Len(aCampos)
		If AllTrim(aCampos[nY]) $ cCposPer
			//_nValor	:= Val(aTxt[nX,aPosCampos[nY]])
			_nValor	:= val(strtran(StrTran(    aTxt[nX,aPosCampos[nY]] ,".","") ,",","." )    )  //Ana
			(cAliasTmp)->&("P"+StrTran(AllTrim(aCampos[nY]),"/","")) := _nValor
			
		Else
			FieldPut(FieldPos(aCampos[nY]),aTxt[nX,aPosCampos[nY]])
		Endif
		//Next
		
	Next
	MsUnLock()
Next

dbSelectArea(cAliasTmp)
dbGotop()

xImpOrc(lEnd,oProcess,cAliasTmp,aPeriodo,cPlanOri,cRevOri,aConfig)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Apaga o TMP	ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select(cAliasTmp) != 0
	dbSelectArea(cAliasTmp)
	dbCloseArea()
	FErase(cNomeArq+GetDBExtension())
	FErase(cNomeArq+OrdBagExt())
Endif
FClose(nHandle)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIPCOA16  บAutor  ณMicrosiga           บ Data ณ  02/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta Processamento                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xProc(aConfig, cCtaOrc, cPlanOri, cRevOri, cPlanOri, aPeriodo, aPerAux)
Local oProcess

oProcess:= MsNewProcess():New({|lEnd| Fim_Wiz(aConfig, cCtaOrc, cPlanOri, cRevOri, aPeriodo, aPerAux,.F.,oProcess)})
oProcess:Activate()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ Ctb025Imp    ณ Autor ณ Felipe A. Melo    ณ Data ณ 17/09/08 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Exporta cadastro do plano de contas referencial            ณฑฑ
ฑฑณ          ณ se jแ foi utilizada em alguma outra rotina                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ Ctb025Imp()                                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ CTBA025                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function xImpOrc(lEnd,oProcess,cAliasTmp,aPeriodo,cPlanOri,cRevOri,aConfig)
LOCAL nProcRegs	:= 0
LOCAL nTotRegs	:= 0
Local cChavPla 	:= AK1->(AK1_FILIAL+AK1_CODIGO+AK1_VERSAO)
Local cTexto 	:= ""
Local cFile  	:= IIF(upper(Right(Alltrim(MV_PAR13),3)) == "CSV",Substr(Alltrim(MV_PAR13),1,Len(Alltrim(MV_PAR13))-4),Alltrim(MV_PAR13))+".LOG"
Local lErro		:= .F.
Local cAliasAK2	:= GetNextAlias()
Local aRecAK3	:={}
Local cItem 	:= "0001"

Private _nMaxReg:= 0
Private _nTotReg:= 0

dbEval( {|x| nTotRegs++ },,{|| (cAliasTmp)->(!EOF())})
oProcess:SetRegua1(nTotRegs)
oProcess:IncRegua1("Iniciando processamento...")
oProcess:SetRegua2(nTotRegs)
oProcess:IncRegua2("Aguarde...")

cTexto += Replicate( "-", 128 ) + CRLF
ctexto += Replicate( " ", 128 ) + CRLF
ctexto += "LOG DE IMPORTACAO DA PLANILHA ORCAMENTARIA" + CRLF
ctexto += Replicate( " ", 128 ) + CRLF
ctexto += Replicate( "-", 128 ) + CRLF
ctexto += CRLF
ctexto += " Dados Ambiente" + CRLF
ctexto += " --------------------"  + CRLF
ctexto += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + CRLF
ctexto += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
ctexto += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
ctexto += " DataBase...........: " + DtoC( dDataBase )  + CRLF
ctexto += " Data / Hora Inicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
ctexto += " Usuario TOTVS .....: " + __cUserId + " " +  cUserName + CRLF
ctexto += Replicate( "-", 128 ) + CRLF
ctexto += CRLF


dbSelectArea(cAliasTmp)
dbGotop()

WHILE (cAliasTmp)->(!EOF())
	
	nProcRegs++
	oProcess:IncRegua1("Validando arquivo item: "+CValToChar(nProcRegs)+" / "+CValToChar(nTotRegs))
	
	// Valida Registros e Gerar Log
	
	// Valida Chave da Planilha Orcamentaria
	If (cAliasTmp)->AK2_FILIAL+AK2_ORCAME+AK2_VERSAO <> cChavPla
		cTexto += "A chave da planilha or็amentแria: "+Alltrim((cAliasTmp)->AK2_FILIAL+AK2_ORCAME+AK2_VERSAO)+", informada no arquivo CSV, nใo ้ a mesma da planilha posicionada."+CRLF
		lErro := .T.
	Endif
	
	// Valida Existencia da Conta Orcamentaria
	dbSelectArea("AK5")
	dbSetOrder(1)
	If !dbSeek(xFilial("AK5")+(cAliasTmp)->AK2_CO)
		cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - A conta or็amentแria: "+Alltrim((cAliasTmp)->AK2_CO )+" informada no arquivo CSV, nใo existe no sistema."+CRLF
		lErro := .T.
	ElseIf AK5->AK5_TIPO <> "2"
		cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - A conta or็amentแria: "+Alltrim((cAliasTmp)->AK2_CO )+" nใo ้ analํtica."+CRLF
		lErro := .T.
	Elseif AK5->AK5_MSBLQL == "1"
		IF !(Alltrim((cAliasTmp)->AK2_CO)$cTexto)
			cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - A conta or็amentแria: "+Alltrim((cAliasTmp)->AK2_CO )+" estแ bloqueada para uso."+CRLF
			lErro := .T.
		ENDIF
	Endif
	
	// Valida Existencia do Centro de Custo
	If !Empty((cAliasTmp)->AK2_CC)
		dbSelectArea("CTT")
		dbSetOrder(1)
		If !dbSeek(xFilial("CTT")+(cAliasTmp)->AK2_CC)
			cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - A U.O.: "+Alltrim((cAliasTmp)->AK2_CC)+" informada no arquivo CSV, nใo existe no sistema."+CRLF
			lErro := .T.
		ElseIf CTT->CTT_CLASSE <> "2"
			cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - A U.O.: "+Alltrim((cAliasTmp)->AK2_CC)+" nใo ้ analํtica."+CRLF
			lErro := .T.
		ElseIf !ValidaBloq((cAliasTmp)->AK2_CC,Date(),"CTT",.f.)
			cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - A U.O.: "+Alltrim((cAliasTmp)->AK2_CC)+" estแ bloqueada para uso."+CRLF
			lErro := .T.
		Endif
	Endif
	
	// Valida Existencia do Item Contabil
	If !Empty((cAliasTmp)->AK2_ITCTB)
		dbSelectArea("CTD")
		dbSetOrder(1)
		If !dbSeek(xFilial("CTD")+(cAliasTmp)->AK2_ITCTB)
			cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - O C.R.: "+Alltrim((cAliasTmp)->AK2_ITCTB)+" informado no arquivo CSV, nใo existe no sistema."+CRLF
			lErro := .T.
		ElseIf CTD->CTD_CLASSE <> "2"
			cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - O C.R.: "+Alltrim((cAliasTmp)->AK2_ITCTB)+" nใo ้ analํtico."+CRLF
			lErro := .T.
		Elseif !ValidaBloq((cAliasTmp)->AK2_ITCTB,Date(),"CTD",.f.)
			cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - O C.R.: "+Alltrim((cAliasTmp)->AK2_ITCTB)+" estแ bloqueado para uso."+CRLF
			lErro := .T.
		Endif
	Endif
	
	// Valida Existencia da Classe de Valor
	If !Empty((cAliasTmp)->AK2_CLVLR)
		dbSelectArea("CTH")
		dbSetOrder(1)
		If !dbSeek(xFilial("CTH")+(cAliasTmp)->AK2_CLVLR)
			cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - A classe de valor: "+Alltrim((cAliasTmp)->AK2_CLVLR)+", informada no arquivo CSV, nใo existe no sistema."+CRLF
			lErro := .T.
		ElseIf CTH->CTH_CLASSE <> "2"
			cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - A classe de valor: "+Alltrim((cAliasTmp)->AK2_CLVLR)+", nใo ้ analํtica."+CRLF
			lErro := .T.
		ElseIf !ValidaBloq((cAliasTmp)->AK2_CLVLR,Date(),"CTH",.f.)
			cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - A classe de valor: "+Alltrim((cAliasTmp)->AK2_CLVLR)+", estแ bloqueada para uso."+CRLF
			lErro := .T.
		Endif
	Endif
	
	// Valida Existencia da Classe Orcamentaria
	dbSelectArea("AK6")
	dbSetOrder(1)
	If !dbSeek(xFilial("AK6")+(cAliasTmp)->AK2_CLASSE)
		cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - A classe or็แmentแria: "+Alltrim((cAliasTmp)->AK2_CLASSE)+", informada no arquivo CSV, nใo existe no sistema."+CRLF
		lErro := .T.
	Endif
	
	// Valida Existencia da Opera็ใo Or็amentaria
	//	If !Empty((cAliasTmp)->AK2_OPER)
	dbSelectArea("AKF")
	dbSetOrder(1)
	If !dbSeek(xFilial("AKF")+(cAliasTmp)->AK2_OPER)
		cTexto += "Linha " + Alltrim((cAliasTmp)->LINHA)+ " - A opera็ใo or็amentแria: "+Alltrim((cAliasTmp)->AK2_OPER)+", informada no arquivo CSV, nใo existe no sistema."+CRLF
		lErro := .T.
	Endif
	//	Endif
	
	
	DbSelectArea(cAliasTmp)
	DbSkip()
	
Enddo

If lErro
	MsgStop("Ocorreram erros na valida็ใo do arquivo CSV. O processo foi abortado!"+CRLF+"Por favor, verifique o arquivo "+Alltrim(cFile)+" gerado no mesmo diret๓rio do arquivo importado para mais detalhes.","Aten็ใo")
Else
	
	If (Aviso("Importa็ใo da Planilha","Confirma a importa็ใo dos dados conforme parโmetros informados?",{"Sim","Nใo"},1)==1)
		
		//Apagar os dados ou nao
		If MV_PAR12 == "1"
			//			IF Aviso("Os itens existentes na Planilha Or็amentแria serใo MANTIDOS conforme parโmetro selecionado.",{"Continuar","Abortar"},1) <> 1
			IF Aviso("Aten็ใo","Os itens existentes na Planilha Or็amentแria serใo MANTIDOS conforme parโmetro selecionado.",{"Continuar","Abortar"},1) <> 1
				Return()
			ENDIF
		Else
			IF Aviso("Aten็ใo","Os itens existentes na Planilha Or็amentแria serใo APAGADOS conforme parโmetro selecionado.",{"Continuar","Abortar"},1) <> 1
				Return()
			ENDIF
			//Apaga os Dados
			MsgRun('Excluindo lan็amentos. Aguarde...',, {|| xDelOrcTrh(MV_PAR12) } )
		Endif
		
		// Processa Importacao
		DbSelectArea(cAliasTmp)
		dbGotop()
		
		dbSelectArea("AK2")
		dbSetOrder(5)

		While !Eof(cAliasTmp)
			
			cCtaOrc := (cAliasTmp)->AK2_CO
						
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณLocaliza qual e o maior ID para a Conta Orcamentariaณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			AK2->(dbSeek(xFilial()+cPlanOri+cRevOri+cCtaOrc+"ZZZZ",.T.))
			AK2->(dbSkip(-1))
			
			If xFilial("AK2")+cPlanOri+cRevOri+cCtaOrc==AK2->(AK2_FILIAL+AK2_ORCAME+AK2_VERSAO+AK2_CO)
				cItem := Soma1(AK2->AK2_ID)
			Else
				cItem := "0001"
			EndIf
			
			oProcess:IncRegua2("Gravando registros AK2..: "+cCtaOrc)
			xGeraOrc(cAliasTmp,cCtaOrc,aPeriodo,cPlanOri,cRevOri,cItem)
			
			dbSelectArea(cAliasTmp)
			dbSkip()
		EndDo
		
		//ฺฤฤฤฤฤฤฤฤฟ
		//ณ Query  ณ
		//ภฤฤฤฤฤฤฤฤู
		cQuery1 :=  "SELECT AK2_CO, AK2_ORCAME, AK2_VERSAO "
		cQuery1 +=  "FROM "+RetSqlName("AK2")+" (nolock) "
		cQuery1 +=	"WHERE D_E_L_E_T_='' "
		cQuery1 +=	"AND AK2_ORCAME= '"+cPlanOri+"' "
		cQuery1 +=	"AND AK2_VERSAO= '"+cRevOri+"' "
		cQuery1 +=	"GROUP BY AK2_CO, AK2_ORCAME, AK2_VERSAO "
		cQuery1 +=	"ORDER BY AK2_CO, AK2_ORCAME, AK2_VERSAO "
		
		cQuery1 := ChangeQuery(cQuery1)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAliasAK2,.T.,.F.)
		(cAliasAK2)->(dbGotop())
		
		If Select(cAliasAK2) != 0
			While !Eof(cAliasAK2) .and. !Empty((cAliasAK2)->AK2_CO)
				
				oProcess:IncRegua2("Gravando Planilha AK3...: "+(cAliasAK2)->AK2_CO)
				
				dbSelectArea("AK3")
				dbSetOrder(1)
				
				If !dbSeek(xFilial('AK3')+(cAliasAK2)->AK2_ORCAME+(cAliasAK2)->AK2_VERSAO+(cAliasAK2)->AK2_CO)
					cxNivel := "001"
					GravaAK3((cAliasAK2)->AK2_ORCAME,(cAliasAK2)->AK2_VERSAO,(cAliasAK2)->AK2_CO,aRecAK3,@cxNivel)
					
					For nt := Len(aRecAK3) to 1 Step -1
						cxNivel := Soma1(cxNivel)
						AK3->(dbGoto(aRecAK3[nt]))
						
						If Empty(AK3->AK3_NIVEL)
							RecLock("AK3",.F.)
							AK3->AK3_NIVEL := cxNivel
							MsUnlock()
						Endif
						
					Next nt
				EndIf
				
				(cAliasAK2)->(DbSkip())
			Enddo
		Endif
		
		oProcess:IncRegua2("Aguarde atualiza็ใo de Lan็amentos...")
		MsgRun('Atualizando Lan็amentos (AKD). Por favor aguarde....',, {|| xPcoA122(AK1->(RecNo())) } )
		
	Endif
	
	cTexto += "Importa็ใo realizada com sucesso!"+CRLF
Endif

cTexto += Replicate( "-", 128 ) + CRLF
cTexto += " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time()  + CRLF
cTexto += Replicate( "-", 128 ) + CRLF

MemoWrite( cFile, cTexto )

If !lErro
	Aviso("Importa็ใo de Planilha","A importa็ใo foi concluํda com ๊xito!"+CRLF+CRLF+"Por favor, verifique o arquivo "+Alltrim(cFile)+" gerado no mesmo diret๓rio do arquivo importado para mais detalhes."+CRLF+CRLF+"ษ necessแrio fechar a planilha or็amentแria e abri-la novamente para visualizar os dados importados.",{"OK"},2)
Endif

Return lErro

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxDelOrcTrhบ Autor ณ Claudinei Ferreira บ Data ณ  22/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Deleta dados da Pl. Orcamentaria antes da importacao do csvบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function xDelOrcTrh(nOpc)
Local cAliasDel := GetNextAlias()
Local cCommand  := ""
Local cPlanRev	:= MV_PAR02
Local cVersPlan	:= MV_PAR03
Local cTmpREC
Local nStep		:= 10000

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Deleta lancamentos da AKD (PCODetlan)  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
P122CDELL(cPlanRev, cVersPlan, "01")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuery para obter recnos da tabela AK2 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cTmpREC := GetNextAlias() //Obtem o alias para a tabela temporaria

cQuery := " SELECT MIN(R_E_C_N_O_)RECMIN, MAX(R_E_C_N_O_) RECMAX, COUNT(*) QTDREG "
cQuery += " FROM " + RetSqlName( "AK2" )
cQuery += " WHERE "
cQuery += "            AK2_FILIAL ='" + xFilial( "AK2" ) + "' " 
cQuery += "        AND AK2_ORCAME ='" + cPlanRev + "' "
cQuery += "        AND AK2_VERSAO = '"+ cVersPlan +"' "

If nOpc == '2'
	cQuery += " AND AK2_CO BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'  
	cQuery += " AND AK2_CC BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'
	cQuery += " AND AK2_ITCTB BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'
	cQuery += " AND AK2_CLVLR BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"'
Endif

cQuery += "        AND D_E_L_E_T_ = ' ' " 
	
cQuery := ChangeQuery( cQuery )
	
dbUseArea( .T., "TOPCONN", Tcgenqry( , , cQuery ), cTmpREC, .F., .T. )
	
TcSetField( cTmpREC, "RECMIN", "N", 12, 0 )
TcSetField( cTmpREC, "RECMAX", "N", 12, 0 )
TcSetField( cTmpREC, "QTDREG", "N", 12, 0 )
	
nRecIni:= RECMIN
nRecFim := If(nRecIni+nStep > RECMAX,RECMAX,nRecIni+nStep)
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExclui registros da AK2 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
While nRecIni <> RECMAX

	cCommand := "DELETE "
	cCommand += RetSqlName("AK2")+" "
	cCommand += " WHERE AK2_FILIAL = '"+MV_PAR01+"' AND AK2_ORCAME = '"+MV_PAR02+"'  AND AK2_VERSAO = '"+MV_PAR03+"'
	cCommand += " AND R_E_C_N_O_ BETWEEN  "+ Str(nRecIni,12,0) + " AND "+ Str(nRecFim,12,0)
	cCommand += " AND D_E_L_E_T_ = ' ' "

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExecuta expressao SQL e atualiza TOP ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	BeginTran()
	TcSqlExec(cCommand)
	TcRefresh(RetSqlName("AK2"))
	EndTran()
	
	nRecIni := nRecFim
	nRecFim := If(nRecIni+nStep > RECMAX,RECMAX,nRecIni+nStep)
Enddo
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExclui registros da AK3 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
cCommand := "DELETE "
cCommand += RetSqlName("AK3")+" "
cCommand += " WHERE AK3_FILIAL = '"+MV_PAR01+"' AND AK3_ORCAME = '"+MV_PAR02+"'  AND AK3_VERSAO = '"+MV_PAR03+"' AND "
cCommand += " AK3_ORCAME <> AK3_CO AND "
cCommand += " D_E_L_E_T_ = ' ' "
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta expressao SQL e atualiza TOP ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
BeginTran()
	TcSqlExec(cCommand)	
	TcRefresh(RetSqlName("AK3"))
EndTran()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxDelOrc	บ Autor ณ Claudinei Ferreira บ Data ณ  22/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Deleta dados da Pl. Orcamentaria antes da importacao do csvบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function xDelOrc()
Local cAliasDel := GetNextAlias()
Local cQuery    := ""

// Deleta AK2
cQuery := "SELECT R_E_C_N_O_ AS NREG FROM "
cQuery += RetSqlName("AK2")+" "
cQuery += " WHERE AK2_FILIAL = '"+MV_PAR01+"' AND AK2_ORCAME = '"+MV_PAR02+"'  AND AK2_VERSAO = '"+MV_PAR03+"' AND "
cQuery += " AK2_CO BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'  AND "
cQuery += " AK2_CC BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'  AND "
cQuery += " AK2_ITCTB BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"'  AND "
cQuery += " AK2_CLVLR BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"'  AND "
cQuery += " D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery(cQuery)

If Select(cAliasDel) > 0
	dbSelectArea(cAliasDel)
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDel,.T.,.F.)

DbSelectArea(cAliasDel)
dbGotop()

If !Eof(cAliasDel)
	While !Eof(cAliasDel)
		
		dbSelectArea("AK2")
		dbGoto((cAliasDel)->NREG)
		Reclock("AK2",.F.,.T.)
		dbDelete()
		Msunlock()
		
		dbSelectArea(cAliasDel)
		dbSkip()
	Enddo	
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  xGeraOrcบ Autor ณ Claudinei Ferreira บ Data ณ  27/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Deleta dados da Pl. Orcamentaria antes da importacao do csvบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CNI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function xGeraOrc(cAliasTmp,cCtaOrc,aPeriodo,cPlanOri,cRevOri,cItem)
Local nX       := 0
Local cxNivel   := "001"

For nX := 1 to Len(aPeriodo)
	
	IF (cAliasTmp)->&("P"+StrTran(Substr(aPeriodo[nx],1,10),"/","")) == 0
		Loop
	ENDIF
	
	RecLock("AK2",.T.)
	AK2->AK2_FILIAL := xFilial("AK2")
	AK2->AK2_ORCAME := cPlanOri
	AK2->AK2_VERSAO := cRevOri
	AK2->AK2_MOEDA	:= 1
	AK2->AK2_PERIOD	:= CTOD(Substr(aPeriodo[nx],1,10))
	AK2->AK2_DATAI	:= CTOD(Substr(aPeriodo[nx],1,10))
	AK2->AK2_DATAF	:= CTOD(Substr(aPeriodo[nx],14,16))
	AK2->AK2_ID		:= cItem
	AK2->AK2_CO 	:= (cAliasTmp)->AK2_CO
	AK2->AK2_CC 	:= (cAliasTmp)->AK2_CC
	AK2->AK2_ITCTB 	:= (cAliasTmp)->AK2_ITCTB
	AK2->AK2_CLVLR 	:= (cAliasTmp)->AK2_CLVLR
	AK2->AK2_XSTS	:= "0" // status da UO
	AK2->AK2_CLASSE := (cAliasTmp)->AK2_CLASSE
	AK2->AK2_OPER	:= (cAliasTmp)->AK2_OPER
	AK2->AK2_VALOR	:= (cAliasTmp)->&("P"+StrTran(Substr(aPeriodo[nx],1,10),"/",""))
//	AK2->AK2_XDTIMP := dDataBase
	
	MsUnlock()

	_nTotReg++
	
Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ xIncConta บAutor ณ Claudinei Ferreira  บ Data ณ 21/11/11   บฑฑ
ฑฑฬออออออออออุอออออออออออออสออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณInclui as contas orcamentarias ref a tab (AK3)   posicionadoบฑฑ
ฑฑบ          ณutiliza recursividade ao chamar a funcao A200Nivel() para   บฑฑ
ฑฑบ          ณchamar novamente xIncConta para as contas pai     	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaAK3(cOrcame,cVersao,cCO,aRecAK3,cxNivel)
Local aArea := GetArea()
dbSelectArea("AK5")
dbSetOrder(1)
If MsSeek(xFilial()+cCO)
	PmsNewRec("AK3")
	AK3->AK3_FILIAL 	:= xFilial("AK3")
	AK3->AK3_ORCAME		:= cOrcame
	AK3->AK3_VERSAO		:= cVersao
	AK3->AK3_CO			:= cCO
	AK3->AK3_PAI		:= If(Empty(AK5->AK5_COSUP),cOrcame,AK5->AK5_COSUP)
	AK3->AK3_TIPO		:= AK5->AK5_TIPO
	AK3->AK3_DESCRI		:= AK5->AK5_DESCRI
	MsUnlock()
	aAdd(aRecAK3,AK3->(RecNo()))
	dbSelectArea("AK3")
	dbSetOrder(1)
	If !Empty(AK5->AK5_COSUP)
		If !dbSeek(xFilial('AK3')+cOrcame+cVersao+AK5->AK5_COSUP)
			GravaAK3(AK2->AK2_ORCAME,AK2->AK2_VERSAO,AK5->AK5_COSUP,aRecAK3,@cxNivel)
		Else
			cxNivel := AK3->AK3_NIVEL
		EndIf
	EndIf
EndIf
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPcoA122  บAutor  ณMicrosiga           บ Data ณ  02/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Chamada da funcao para controle de Threads na geracao dos  บฑฑ
ฑฑบ          ณ lancamentos da AKD                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xPcoA122(nRecAK1)

Local nX
Local lRet        	:= .F.
Local cAliasTmp
Local cQuery      	:= ""
Local aRecGrid 		:= {}
Local nThread		:= SuperGetMv("MV_PCOTHRD",.T.,10)
Local cPlanRev		:= MV_PAR02
Local cNewVers		:= MV_PAR03

Default nRecAK1 := AK1->( Recno() )
Private aParam:={}

GRID_STEP:= 10000

cAliasTmp := GetNextAlias() //Obtem o alias para a tabela temporaria
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuery para obter recnos da tabela AK2 ou AK3 da nova versao    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT MIN(R_E_C_N_O_) MINRECNOAK, MAX(R_E_C_N_O_) MAXRECNOAK FROM " + RetSqlName( "AK2" )
cQuery += " WHERE "
cQuery += "         	AK2_FILIAL ='" + xFilial( "AK2" ) + "' " 
cQuery += "        AND AK2_ORCAME ='" + cPlanRev + "' "
cQuery += "        AND AK2_VERSAO = '"+ cNewVers +"' "
cQuery += "        AND D_E_L_E_T_= ' ' " 

cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", Tcgenqry( , , cQuery ), cAliasTmp, .F., .T. )

TcSetField( cAliasTmp, "MINRECNOAK", "N", 12, 0 )
TcSetField( cAliasTmp, "MAXRECNOAK", "N", 12, 0 )

If (cAliasTmp)->(!Eof())

                //DISTRIBUIR EM GRID
                aRecGrid := {}
                For nX := (cAliasTmp)->MINRECNOAK TO (cAliasTmp)->MAXRECNOAK STEP GRID_STEP
                               If nX + GRID_STEP > (cAliasTmp)->MAXRECNOAK
                                               aAdd(aRecGrid, {nx, (cAliasTmp)->MAXRECNOAK } )  //ultimo elemento do array
                               Else
                                               aAdd(aRecGrid, {nx, nX+GRID_STEP-1} )
                               EndIf
                Next

                nThread := Min( Len(aRecGrid), nThread ) //Configura a quantidade de threads pelo menor parametro ou len(arecgrid)

                oGrid := FWIPCWait():New("SI16"+cEmpAnt+StrZero(nRecAK1,9,0),10000)
                oGrid:SetThreads(nThread)
                oGrid:SetEnvironment(cEmpAnt,cFilAnt)
                oGrid:Start("U_SI16IMPLAN")

                lRet := SIA16RevPre(oGrid,aRecGrid,nThread)

EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPcoA122  บAutor  ณMicrosiga           บ Data ณ  02/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de Start das Threads								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SIA16RevPre(oGrid,aRecGrid,nThread)
Local nRecIni
Local nRecFim
Local lSimu_ := .F.
Local lRevi_ := .F.
 
Local cPlanRev	:= MV_PAR02
Local cNewVers	:= MV_PAR03
Local cFilAKE   := xFilial("AKE")
Local lExit     := .F.
Local nKilled
Local nHdl
Local cMsgComp  := ""
Local nX
Local nZ
 
For nX := 1 To Len(aRecGrid)
                nRecIni := aRecGrid[nX,1]
                nRecFim := aRecGrid[nX,2]
                lRet := oGrid:Go("Chamando escrituracao...",{nRecIni, nRecFim, lSimu_, lRevi_, cPlanRev, cNewVers, nX})  
                If !lRet
                               Exit
                EndIf
 
                Sleep(5000)//Aguarda 5 seg para abertura da thread para nใo concorrer na cria็ใo das procedures.
 
Next
 
Sleep(2500*nThread)//Aguarda todas as threads abrirem para tentar fechar
    
While !lExit
                nKilled := 0
                For nZ := 1 To Len(aRecGrid)
                               nHdl := FOpen("xPCOA16_"+cFilAKE+cPlanRev+cNewVers+StrZero(nZ,10,0), 16) 
                                If nHdl >= 0
                                               cMsgComp += FReadStr(nHdl,100)+CRLF
                                               oGrid:RemoveThread(.T.)
                                               nKilled += 1
                                               FClose(nHdl)
                                               FErase("xPCOA16_"+cFilAKE+cPlanRev+cNewVers+StrZero(nZ,10,0))
                               Else
                                               nHdl := FCreate("xPCOA16_"+cFilAKE+cPlanRev+cNewVers+StrZero(nZ,10,0), 16) 
                                               If nHdl >= 0
                                                               oGrid:RemoveThread(.T.)
                                                               nKilled += 1
                                                               FClose(nHdl)
                                                               FErase("xPCOA16_"+cFilAKE+cPlanRev+cNewVers+StrZero(nZ,10,0))
                                               EndIf
                               Endif
                Next nZ
                
                If nKilled == Len(aRecGrid)
                               Exit
                EndIf
                
                Sleep(3000) //Verifica a cada 3 segundos se as threads finalizaram
                
EndDo
 
PcoAvisoTm(IIf(lRet,"Processo finalizado com sucesso", "Problema no processamento."),cMsgComp, {"Ok"},,,,,5000)
 
oGrid:RemoveThread(.T.)
 
Return lRet        


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSI16IMPLANบAutor  ณMicrosiga           บ Data ณ  02/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcaod de controle de Threads                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SI16IMPLAN(cParm,aParam)

Local nRecIni   := aParam[1]
Local nRecFim   := aParam[2]
Local lSimulac  := aParam[3]
Local lRevisa   := aParam[4]
Local cPlanRev  := aParam[5]
Local cNewVers  := aParam[6]
Local nZ        := aParam[7]
Local cFilAKE   := xFilial("AKE")

Local nHdl 
Local cStart    := ""
Local cEnd      := ""

nHdl := FCreate("xPCOA16_"+cFilAKE+cPlanRev+cNewVers+StrZero(nZ,10,0), 16) 

If nHdl >= 0
	
	cStart := DTOC(Date())+" "+Time()
	Conout( "xPCOA16 -> "+AllTrim(Str(ThreadID()))+" STARTED ["+cStart+"] " )
	fWrite(nHdl, " STARTED ["+cStart+"]")
	//PROCESSAMENTO
	lRet := Aux_Det_Lan(nRecIni, nRecFim, lSimulac, lRevisa, cPlanRev, cNewVers)
	//
	cEnd := DTOC(Date())+" "+Time()
	If lRet
		Conout("xPCOA16 -> "+AllTrim(Str(ThreadID()))+" END   ["+cEnd+"]  OK")
		fWrite(nHdl," END ["+cEnd+"] - OK")
	Else
		Conout("xPCOA16 -> "+AllTrim(Str(ThreadID()))+" END   ["+cEnd+"]  FAILED")
		fWrite(nHdl," END ["+cEnd+"] - FAILED")
	EndIf
	FClose(nHdl)
	
EndIf
                
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณAux_Det_Lan บAutor  ณMicrosiga         บ Data ณ  06/14/13   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChama a PcoDetLan para escriturar movimento gerado por      บฑฑ
ฑฑบ          ณIniciar Revisao (distribuido)                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Aux_Det_Lan(nRecIni, nRecFim, lSimulac, lRevisao, cPlanRev, cNewVers)
Local lRet 		:= .F.
Local cQuery 	:= " "
Local nCtdAK2 	:= 0
Local nLimLin	:= GetMV("MV_PCOLIMI")
Local nLinLote	:= 0

//SELECT AK2
cAliasTmp := GetNextAlias() //Obtem o alias para a tabela temporaria

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuery para obter recnos da tabela AK2 ou AK3 da nova versao    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT R_E_C_N_O_ RECNOAK FROM " + RetSqlName( "AK2" )
cQuery += " WHERE "
cQuery += "                  AK2_FILIAL ='" + xFilial( "AK2" ) + "' " 
cQuery += "        AND AK2_ORCAME ='" + cPlanRev + "' "
cQuery += "        AND AK2_VERSAO = '"+ cNewVers +"' "
cQuery += "        AND R_E_C_N_O_ BETWEEN  "+ Str(nRecIni,12,0) + " AND "+ Str(nRecFim,12,0)
cQuery += "        AND D_E_L_E_T_ = ' ' " 
cQuery += " ORDER BY R_E_C_N_O_ "

cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", Tcgenqry( , , cQuery ), cAliasTmp, .F., .T. )

TcSetField( cAliasTmp, "RECNOAK", "N", 12, 0 )
Conout("inicio Recnos de:"+Str(nRecIni,12,0)+" Ate: "+Str(nRecFim,12,0)+" "+time()) 

PcoIniLan("000252")
While (cAliasTmp)->(!Eof())
	nRecNew := (cAliasTmp)->(RECNOAK)
	AK2->(dbGoto(nRecNew))
	nCtdAK2++
	//PcoDetLan( cProcesso, cItem, cPrograma, lDeleta, cProcDel, cAKDStatus, lAtuSld )
	PcoDetLan("000252","01","PCOA100",.F., , "1",.F.)
	nLinLote++
	(cAliasTmp)->(dbSkip())
	
	If nLimLin = nLinLote
		PcoFinLan("000252",/*lForceVis*/,/*lProc*/,/*lDelBlq*/,.F.)
		nLinLote:=0
		PcoIniLan("000252")
	Endif
	
EndDo
PcoFinLan("000252",/*lForceVis*/,/*lProc*/,/*lDelBlq*/,.F.)

(cAliasTmp)->(dbCloseArea() )

Conout("Final Recnos de: "+Str(nRecIni,12,0)+"Ate: "+Str(nRecFim,12,0)+" "+time())

lRet := ( (nRecFim-nRecIni+1) == nCtdAK2 )

Return(lRet)