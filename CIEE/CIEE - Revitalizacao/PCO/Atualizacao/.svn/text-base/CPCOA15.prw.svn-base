#INCLUDE "protheus.ch"
#INCLUDE "apwizard.ch"
#INCLUDE "topconn.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CPCOA15
Exportacao de Planilha CSV de orçamento.
@author  	Leonardo Soncin
@since     	10/11/2011
@version  	P.11.8      
@return   	Nenhum
@obs       	Nenhum
Alterações	Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data         |Desenvolvedor     |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
15/04/2015  | Otacilio A. Jr.  | Inclusão de Parâmetros para Exportação de Valores Realizado 
------------+-----------------+----------------------------------------------------------
             |                    | 																 
------------+-----------------+----------------------------------------------------------

//---------------------------------------------------------------------------------------

/*/

User Function CPCOA15   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local oWizard
Local cArquivo
Local aAreaAK1  := AK1->(GetArea())
Local aAreaAK2  := AK2->(GetArea())
Local aAreaAK3  := AK3->(GetArea())
Local aAreaAKE  := AKE->(GetArea())
Local aAreaAKD  := AKD->(GetArea())
Local lRet 	  := .F.
Local lParam, lBrowse:=.T.
Local cNomeCSV 	:= Alltrim(AK1->AK1_FILIAL)+Alltrim(AK1->AK1_CODIGO)+Alltrim(AK1->AK1_VERSAO)+".CSV"
Local aParametros := {  { 1 ,"Filial"                   ,Space(LEN(AK1->AK1_FILIAL))        ,"@!" ,"" ,""    ,".T." ,15 ,.T. },;
                        { 1 ,"Planilha orçamentária"    ,Replicate(" ",LEN(AK1->AK1_CODIGO)),"@!" ,"" ,"AK1" ,".T." ,65 ,.T. },;
                        { 1 ,"Revisão"                  ,Replicate(" ",LEN(AKE->AKE_REVISA)),"@!" ,"" ,"AKE1",".T." ,65 ,.T. },;
                        { 1 ,"Conta orçamentária de"    ,Replicate(" ",LEN(AK2->AK2_CO))    ,"@!" ,"" ,"AK5" ,""    ,65 ,.F. },;
                        { 1 ,"Conta orçamentária até"	,Replicate(" ",LEN(AK2->AK2_CO))    ,"@!" ,"" ,"AK5" ,""    ,65 ,.T. },;
                        { 1 ,"Centro de custo de"		,Replicate(" ",LEN(AK2->AK2_CC))    ,"@!" ,"" ,"CTT" ,""    ,65 ,.F. },;
                        { 1 ,"Centro de custo até"		,Replicate(" ",LEN(AK2->AK2_CC))    ,"@!" ,"" ,"CTT" ,""    ,65 ,.T. },;
                        { 1 ,"Item contábil de"         ,Replicate(" ",LEN(AK2->AK2_ITCTB)) ,"@!" ,"" ,"CTD" ,""    ,65 ,.F. },;
                        { 1 ,"Item contábil até"        ,Replicate(" ",LEN(AK2->AK2_ITCTB)) ,"@!" ,"" ,"CTD" ,""    ,65 ,.T. },;
                        { 1 ,"Classe de valor de"		,Replicate(" ",LEN(AK2->AK2_CLVLR)) ,"@!" ,"" ,"CTH" ,""    ,65 ,.F. },;
                        { 1 ,"Classe de valor até"		,Replicate(" ",LEN(AK2->AK2_CLVLR)) ,"@!" ,"" ,"CTH" ,""    ,65 ,.T. },;
                        { 1 ,"Nome do arquivo"			,Space(60)                          ,"@!" ,"" ,""    ,""    ,65 ,.T. },;
                        { 6	,"Local do arquivo"			,Space(60)                          ,""   ,   ,""    ,90    ,.T.,"",'',GETF_RETDIRECTORY+GETF_LOCALHARD},;
                        { 2 ,"Orçado ou Realizado"      ,1                                  ,{"1=Orçado","2=Realizado"} ,100, "", .T.},;
                        { 1 ,"Data Inicial"             ,Space(10)                          ,""   ,"" ,""    ,".T." ,35 ,.T. },;
                        { 1 ,"Data Final"               ,Space(10)                          ,""   ,"" ,""    ,".T." ,35 ,.T. }}
                        
Local aConfig 		:= { AK1->AK1_FILIAL,;   //1
	                       AK1->AK1_CODIGO,;   //2
	                       IF(Empty(AK1->AK1_VERREV), AK1->AK1_VERSAO, AK1->AK1_VERREV),;  //3
	                       Replicate(" ",LEN(AK2->AK2_CO)),;   //4
	                       Replicate("Z",LEN(AK2->AK2_CO)),;   //5
	                       Replicate(" ",LEN(AK2->AK2_CC)),;   //6
	                       Replicate("Z",LEN(AK2->AK2_CC)),;   //7
	                       Replicate(" ",LEN(AK2->AK2_ITCTB)),;    //8
	                       Replicate("Z",LEN(AK2->AK2_ITCTB)),;    //9
	                       Replicate(" ",LEN(AK2->AK2_CLVLR)),;    //10
	                       Replicate("Z",LEN(AK2->AK2_CLVLR)),;    //11
	                       cNomeCSV,;  //12
	                       Space(60),; //13
	                       "1",;       //14
	                       Space(10),; //15
	                       Space(10)}  //16
Local aPerAux 		:= {}

PRIVATE aAuxCps
PRIVATE cRevisa
PRIVATE cPlanAnt 	:= ""
PRIVATE cCtaOrc 	:= ""

Private cPlanOri 	:= AK1->AK1_CODIGO
Private cRevOri 	:= IF(Empty(AK1->AK1_VERREV), AK1->AK1_VERSAO, AK1->AK1_VERREV)
Private cCtaOri 	:= AK3->AK3_CO
Private aPeriodo 	:= PcoRetPer()

dbSelectArea("AK3")
dbSeek(xFilial("AK3")+cPlanOri+cRevOri+cPlanOri)

oWizard := APWizard():New("Atenção"/*<chTitle>*/,;
"Este assistente lhe ajudara a exportar os dados da planilha orçamentária para um arquivo CSV."/*<chMsg>*/, "Exportação da Planilha Orçamentária"/*<cTitle>*/, ;
"Você deverá indicar os parâmetros e ao finalizar o assistente, os dados serão exportados conforme os parâmetros solicitados."/*<cText>*/,;
{||.T.}/*<bNext>*/, ;
{||.T.}/*<bFinish>*/,;
/*<.lPanel.>*/, , , /*<.lNoFirst.>*/)

oWizard:NewPanel( "Parâmetros"/*<chTitle>*/,;
"Neste passo você deverá informar os parâmetros para exportação da planilha orçamentária."/*<chMsg>*/, ;
{||.T.}/*<bBack>*/, ;
{||Rest_Par(aConfig),ParamOk(aParametros, aConfig) }/*<bNext>*/, ;
{||.T.}/*<bFinish>*/,;
.T./*<.lPanel.>*/,;
{||Plan_Box(oWizard,@lParam, aParametros, aConfig)}/*<bExecute>*/ )

oWizard:NewPanel( "Exportação da Planilha Orçamentária"/*<chTitle>*/,;
"Neste passo você deverá confirmar ou abortar a geração do arquivo.",;
{||.T.}/*<bBack>*/, ;
{||.T.}/*<bNext>*/, ;
{|| lRet := xProc(aConfig, cCtaOrc, cPlanOri, cRevOri, cPlanOri, aPeriodo, aPerAux)}/*<bFinish>*/, ;
.T./*<.lPanel.>*/, ;
{||.T.}/*<bExecute>*/ )
                                                                     
TSay():New( 010, 007, {|| "A Planilha Orçamentária será exportada em arquivo no formato CSV conforme os parâmetros selecionados." }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ ) 
TSay():New( 025, 007, {|| "Se o objetivo desta exportação for alterar ou inserir novos itens na planilha para posterior importação no sistema" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 035, 007, {|| "os seguintes critérios devem ser observados:" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 045, 007, {|| "1)  O cabeçalho da planilha não pode ser alterado ou excluído, e os títulos das colunas devem ser mantidos," }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 055, 007, {|| "caso contrário não será possível a sua importação;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 065, 007, {|| "2)  Nenhuma coluna pode ser excluída;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 075, 007, {|| "3)  Caso sejam alterados ou inseridos novos códigos para Filial, Planilha Orçamentária, Versão, Conta Orçamentária," }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 085, 007, {|| "Centro de Custo, Item Contábil ou Classe Valor o respectivo cadastro deve existir no sistema;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 095, 007, {|| "4)  Caso sejam inseridas novas colunas no arquivo que não fazem parte da sua estrutura exportada estas serão" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 105, 007, {|| "desconsideradas na importação;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 115, 007, {|| "5)  A coluna 'Item' (AK2_ID) foi exportada somente como informativa, na importação o sistema pode desconsiderar este"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 125, 007, {|| "código e criar outro de acordo com a seqüência da planilha."}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )

oWizard:Activate( .T./*<.lCenter.>*/,;
{||.T.}/*<bValid>*/, ;
{||.T.}/*<bInit>*/, ;
{||.T.}/*<bWhen>*/ )

RestArea(aAreaAK1)
RestArea(aAreaAK2)
RestArea(aAreaAK3)
RestArea(aAreaAKE)
RestArea(aAreaAKD)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³    Plan_Box ºAutor  ³ TOTVS            º Data ³ 10/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para escolha da planilha a ser copiada               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Plan_Box(oWizard, lParam, aParametros, aConfig)

LOCAL cLoad		:= ""						// Nome do arquivo aonde as respostas do usuário serão salvas / lidas
LOCAL lCanSave	:= .T.						// Se as respostas para as perguntas podem ser salvas
LOCAL lUserSave := .T.						// Se o usuário pode salvar sua propria configuracao

If lParam == NIL
	ParamBox(aParametros ,"Parametros", aConfig,,,.F.,120,3, oWizard:oMPanel[oWizard:nPanel], cLoad, lCanSave, lUserSave)
	lParam := .T.
Else
	Rest_Par(aConfig)
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Rest_Par   ºAutor  ³ TOTVS             º Data ³ 16/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para restauracao dos conteudos das variaveis MV_PAR  º±±
±±º          ³na navegacao entre os paineis do assistente de copia        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Fim_Wiz ºAutor  ³ TOTVS             º Data ³ 16/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para execucao das rotinas de copias quando pressionarº±±
±±º          ³o botao Finalizar do assistente de copia                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fim_Wiz(aConfig, cCtaOrc, cPlanOri, cRevOri, aPeriodo, aPerAux, lEnd, oProcess)

Local lRet 		:= .T.
Local cQuery 	:= ""
Local cAliasTrb	:= GetNextAlias()
Local cAliasTmp	:= GetNextAlias()
Local aEstrut	:= {}
Local nHdl 		:= 0
Local cDest 	:= Alltrim(MV_PAR13)
Local nTotRegs 	:= 0
Local nProcRegs := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura do arquivo temporario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo temporario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomeArq := CriaTrab( aEstrut, .T. )
dbUseArea( .T.,,cNomeArq, cAliasTmp, .F., .F. )

IndRegua( cAliasTmp, cNomeArq, "AK2_CO+AK2_CC+AK2_ITCTB+AK2_CLVLR+AK2_CLASSE+AK2_OPER",,,"Criando Indice, aguarde..." )
dbClearIndex()
dbSetIndex( cNomeArq + OrdBagExt() )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta nome do arquivo e diretorio onde sera gravado.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cDest 	:= IIF(Right(cDest,1) == "\",Substr(cDest,1,Len(cDest)-1),cDest)	//retira a "\" da ultima posicao se existir
cNomArq := MV_PAR12

MakeDir( cDest )
If File(cDest+'\'+cNomArq)
	
	If !(Aviso("Arquivo Existente","O arquivo:"+cDest+'\'+cNomArq+" já existe, deseja sobrescrever?",{"Sim","Não"},1)==1)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga o TMP	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea( cAliasTmp )
		DbCloseArea()
		FErase( cNomeArq + ".DBF" )
		FErase( cNomeArq + OrdBagExt() )
		
		Return(lRet)
	Endif
Endif

nHdl := FCreate( cDest+'\'+cNomArq )

If nHdl < 0
	cMsg := "Nao foi possivel criar o arquivo " + cDest+'\'+cNomArq

	MsgStop(cMsg)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga o TMP	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( cAliasTmp )
	DbCloseArea()
	FErase( cNomeArq + ".DBF" )
	FErase( cNomeArq + OrdBagExt() )
	
	Return(lRet)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exporta Cabecalho do arquivo.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FWrite(nHdl, 'AK2_FILIAL;AK2_ORCAME;AK2_VERSAO;AK2_CO;AK2_ID;AK2_CC;AK2_ITCTB;AK2_CLVLR;AK2_CLASSE;AK2_OPER')
aEval( aPeriodo,{|x| FWrite(nHdl,";"+Substr(x,1,10)) } )
FWrite(nHdl, CRLF)
If MV_PAR14 == "1"
    cQuery := "SELECT AK2_FILIAL, AK2_ORCAME, AK2_VERSAO, AK2_CO, AK2_CC, AK2_ITCTB, AK2_CLVLR, AK2_ID, AK2_PERIOD, AK2_VALOR, AK2_CLASSE, AK2_OPER "
    cQuery += "FROM "+RetSqlName("AK2")+" SN1 "
    cQuery += "WHERE AK2_FILIAL = '"+xFilial("AK2")+"' AND "
    cQuery += "      AK2_ORCAME = '"+MV_PAR02+"' AND AK2_VERSAO = '"+MV_PAR03+"' AND "
    cQuery += "      AK2_CO BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' AND "
    cQuery += "      AK2_CC BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' AND "
    cQuery += "      AK2_ITCTB BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' AND "
    cQuery += "      AK2_CLVLR BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' AND "
    cQuery += "      D_E_L_E_T_ = '' "
    cQuery += "ORDER BY AK2_FILIAL, AK2_ORCAME, AK2_VERSAO, AK2_CO, AK2_ID, AK2_PERIOD"
Else
    cQuery := "SELECT AKD_FILIAL AS AK2_FILIAL, '' AS AK2_ORCAME, '' AS AK2_VERSAO, AKD_CO AS AK2_CO, AKD_CC AS AK2_CC,"
    cQuery += "       AKD_ITCTB AS AK2_ITCTB, AKD_CLVLR AS AK2_CLVLR, AKD_ID AS AK2_ID, AKD_DATA AS AK2_PERIOD, "
    cQuery += "       AKD_VALOR1 AS AK2_VALOR, AKD_CLASSE AS AK2_CLASSE, AKD_OPER AS AK2_OPER "
    cQuery += "    FROM "+RETSQLNAME("CT1")+" CT1"
    cQuery += "    INNER JOIN "+RETSQLNAME("AKD")+" AKD2 ON AKD2.AKD_FILIAL='"+XFILIAL("AKD")+"'" 
    cQuery += "        AND LEFT(AKD2.AKD_CO,LEN(CT1.CT1_CONTA)) = RTRIM(CT1.CT1_CONTA)"
    cQuery += "        AND AKD2.AKD_DATA  BETWEEN '"+DTOS(CTOD(MV_PAR15))+"' AND '"+DTOS(CTOD(MV_PAR16))+"' "
    cQuery += "        AND AKD2.AKD_CC    BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "
    cQuery += "        AND AKD2.AKD_ITCTB BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
    cQuery += "        AND AKD2.AKD_CLVLR BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
    cQuery += "        AND AKD2.AKD_TPSALD = 'RE'"
    cQuery += "        AND AKD2.AKD_STATUS != '3'"    
    cQuery += "        AND AKD2.D_E_L_E_T_= ' '"
    cQuery += "    WHERE CT1.CT1_FILIAL='"+XFILIAL("CT1")+"'"
    cQuery += "        AND CT1.CT1_CONTA BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'"
    cQuery += "        AND CT1.D_E_L_E_T_=''"
    cQuery += "ORDER BY AK2_FILIAL, AK2_ORCAME, AK2_VERSAO, AK2_CO, AK2_ID, AK2_PERIOD"
    
EndIf
cQuery := ChangeQuery(cQuery)

If Select(cAliasTRB) > 0
	dbSelectArea(cAliasTRB)
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.F.)

DbSelectArea(cAliasTRB)
dbGotop()

If !Eof(cAliasTRB)
	
	dbEval( {|x| nTotRegs++ },,{|| (cAliasTRB)->(!EOF())})
	oProcess:SetRegua1(nTotRegs)
	oProcess:IncRegua1("Iniciando processamento...")
	oProcess:SetRegua2(nTotRegs)
	oProcess:IncRegua2("Contas Orçamentárias:")
	                                        
	dbgotop(cAliasTRB)
	
	While !Eof(cAliasTRB)
		
		nProcRegs++
		oProcess:IncRegua1("Processando item: "+CValToChar(nProcRegs)+" / "+CValToChar(nTotRegs))
		
		//Grava dados Agrupados
		dbSelectArea(cAliasTmp)
		dbSetOrder(1)
		dbGotop(cAliasTmp)
		If dbSeek((cAliasTRB)->(AK2_CO+AK2_CC+AK2_ITCTB+AK2_CLVLR+AK2_CLASSE+AK2_OPER))
			
			RecLock((cAliasTmp),.F.)
			(cAliasTmp)->&("P"+StrTran(DTOC(STOD((cAliasTrb)->AK2_PERIOD)),"/","")) += (cAliasTrb)->AK2_VALOR
			MsUnLock()
			
		Else
			
			RecLock((cAliasTmp),.T.)
			(cAliasTmp)->AK2_FILIAL  := (cAliasTrb)->AK2_FILIAL
			(cAliasTmp)->AK2_ORCAME  := (cAliasTrb)->AK2_ORCAME
			(cAliasTmp)->AK2_VERSAO  := (cAliasTrb)->AK2_VERSAO
			(cAliasTmp)->AK2_CO      := (cAliasTrb)->AK2_CO
			(cAliasTmp)->AK2_ID      := (cAliasTrb)->AK2_ID
			(cAliasTmp)->AK2_CC      := (cAliasTrb)->AK2_CC
			(cAliasTmp)->AK2_ITCTB   := (cAliasTrb)->AK2_ITCTB
			(cAliasTmp)->AK2_CLVLR   := (cAliasTrb)->AK2_CLVLR
			(cAliasTmp)->AK2_CLASSE  := (cAliasTrb)->AK2_CLASSE			
			(cAliasTmp)->AK2_OPER    := (cAliasTrb)->AK2_OPER
			(cAliasTmp)->&("P"+StrTran(DTOC(STOD((cAliasTrb)->AK2_PERIOD)),"/","")) := (cAliasTrb)->AK2_VALOR
			MsUnLock()
			
		Endif
		
		dbSelectArea(cAliasTRB)
		dbSkip()
	Enddo
	
	dbSelectArea(cAliasTmp)
	dbGotop()
	While !Eof(cAliasTmp)
		
		oProcess:IncRegua2("CO: "+(cAliasTmp)->AK2_CO)
		
		// Grava a linha do Detalhe
		FWrite(nHdl, Alltrim((cAliasTmp)->AK2_FILIAL)+";"+Alltrim((cAliasTmp)->AK2_ORCAME)+";"+Alltrim((cAliasTmp)->AK2_VERSAO)+";"+Alltrim((cAliasTmp)->AK2_CO)+";"+Alltrim((cAliasTmp)->AK2_ID)+";"+Alltrim((cAliasTmp)->AK2_CC)+";"+ Alltrim((cAliasTmp)->AK2_ITCTB)+";"+ Alltrim((cAliasTmp)->AK2_CLVLR)+";"+ Alltrim((cAliasTmp)->AK2_CLASSE)+";"+ Alltrim((cAliasTmp)->AK2_OPER))
		//Periodos
//		aEval( aPeriodo,{|x| FWrite(nHdl,";"+Str((cAliasTmp)->&("P"+StrTran(Substr(x,1,10),"/","")),TamSx3("AK2_VALOR")[1],2))} )      
		aEval( aPeriodo,{|x| FWrite(nHdl,";"+StrTran(Alltrim(    Str((cAliasTmp)->&("P"+StrTran(Substr(x,1,10),"/","")),TamSx3("AK2_VALOR")[1],2))      ,".","," )   )} )  //StrTran(Alltrim(Str((caliastrb)->AK2_VALOR   )),".",",") 
		FWrite(nHdl, CRLF)
		
		DbSelectArea(cAliasTmp)
		dbSkip()
	Enddo
	
Else
	ApMsgStop( 'Não existem Itens para esta Planilha Orçamentária. O processamento será abortado.' + CRLF +'Para que seja possível a exportação da Planilha é necessário que exista pelo menos um item cadastrado.', 'ATENÇÃO' )
Endif

fClose(nHdl)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga o TMP	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( cAliasTmp )
DbCloseArea()
FErase( cNomeArq + ".DBF" )
FErase( cNomeArq + OrdBagExt() )


Return(lRet)
                                          
Static Function xProc(aConfig, cCtaOrc, cPlanOri, cRevOri, cPlanOri, aPeriodo, aPerAux)

Local oProcess

oProcess:= MsNewProcess():New({|lEnd| Fim_Wiz(aConfig, cCtaOrc, cPlanOri, cRevOri, aPeriodo, aPerAux, .F., oProcess) })
oProcess:Activate()

Return .T.  