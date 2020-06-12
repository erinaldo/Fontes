#INCLUDE "protheus.ch"
#INCLUDE "apwizard.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SIPCOA15 � Autor � Leonardo Soncin    � Data �  10/11/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Exportacao de Planilha CSV de or�amento.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CNI                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FIPCOA15()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local oWizard
Local cArquivo
Local aAreaAK1 	:= AK1->(GetArea())
Local aAreaAK2 	:= AK2->(GetArea())
Local aAreaAK3 	:= AK3->(GetArea())
Local aAreaAKE 	:= AKE->(GetArea())
Local lRet 		:= .F.
Local lParam, lBrowse:=.T.
Local cNomeCSV 	:= Alltrim(AK1->AK1_FILIAL)+Alltrim(AK1->AK1_CODIGO)+Alltrim(AK1->AK1_VERSAO)+".CSV"
Local aParametros := {			{ 1 ,"Filial"					,Space(LEN(AK1->AK1_FILIAL))		,"@!" 	 ,""  ,"" 	 ,".F." ,15 ,.T. },;
{ 1 ,"Planilha or�ament�ria"	,Replicate(" ",LEN(AK1->AK1_CODIGO)),"@!" 	 ,""  ,"AK1" ,".F." ,65 ,.T. },;
{ 1 ,"Revis�o"					,Replicate(" ",LEN(AKE->AKE_REVISA)),"@!" 	 ,""  ,"AKE1",".F." ,65 ,.T. },;
{ 1 ,"Conta or�ament�ria de"	,Replicate(" ",LEN(AK2->AK2_CO)) 	,"@!" 	 ,""  ,"AK5" ,"" ,65 ,.F. },;
{ 1 ,"Conta or�ament�ria at�"	,Replicate(" ",LEN(AK2->AK2_CO)) 	,"@!" 	 ,""  ,"AK5" ,"" ,65 ,.T. },;
{ 1 ,"Centro de custo de"		,Replicate(" ",LEN(AK2->AK2_CC)) 	,"@!" 	 ,""  ,"CTT" ,"" ,65 ,.F. },;
{ 1 ,"Centro de custo at�"		,Replicate(" ",LEN(AK2->AK2_CC)) 	,"@!" 	 ,""  ,"CTT" ,"" ,65 ,.T. },;
{ 1 ,"Item cont�bil de"			,Replicate(" ",LEN(AK2->AK2_ITCTB)) ,"@!" 	 ,""  ,"CTD" ,"" ,65 ,.F. },;
{ 1 ,"Item cont�bil at�"		,Replicate(" ",LEN(AK2->AK2_ITCTB)) ,"@!" 	 ,""  ,"CTD" ,"" ,65 ,.T. },;
{ 1 ,"Classe de valor de"		,Replicate(" ",LEN(AK2->AK2_CLVLR)) ,"@!" 	 ,""  ,"CTH" ,"" ,65 ,.F. },;
{ 1 ,"Classe de valor at�"		,Replicate(" ",LEN(AK2->AK2_CLVLR)) ,"@!" 	 ,""  ,"CTH" ,"" ,65 ,.T. },;
{ 1 ,"Nome do arquivo"			,Space(60)							,"@!" 	 ,""  ,"" ,"" ,65 ,.T. },;
{ 6	,"Local do arquivo"			,Space(60),"",,"",90 ,.T.,"",'',GETF_RETDIRECTORY+GETF_LOCALHARD}}

Local aConfig 		:= {AK1->AK1_FILIAL,AK1->AK1_CODIGO,IF(Empty(AK1->AK1_VERREV), AK1->AK1_VERSAO, AK1->AK1_VERREV),Replicate(" ",LEN(AK2->AK2_CO)),Replicate("Z",LEN(AK2->AK2_CO)),Replicate(" ",LEN(AK2->AK2_CC)),Replicate("Z",LEN(AK2->AK2_CC)),Replicate(" ",LEN(AK2->AK2_ITCTB)),Replicate("Z",LEN(AK2->AK2_ITCTB)),Replicate(" ",LEN(AK2->AK2_CLVLR)),Replicate("Z",LEN(AK2->AK2_CLVLR)),cNomeCSV,Space(60)}
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

oWizard := APWizard():New("Aten��o"/*<chTitle>*/,;
"Este assistente lhe ajudara a exportar os dados da planilha or�ament�ria para um arquivo CSV."/*<chMsg>*/, "Exporta��o da Planilha Or�ament�ria"/*<cTitle>*/, ;
"Voc� dever� indicar os par�metros e ao finalizar o assistente, os dados ser�o exportados conforme os par�metros solicitados."/*<cText>*/,;
{||.T.}/*<bNext>*/, ;
{||.T.}/*<bFinish>*/,;
/*<.lPanel.>*/, , , /*<.lNoFirst.>*/)

oWizard:NewPanel( "Par�metros"/*<chTitle>*/,;
"Neste passo voc� dever� informar os par�metros para exporta��o da planilha or�ament�ria."/*<chMsg>*/, ;
{||.T.}/*<bBack>*/, ;
{||Rest_Par(aConfig),ParamOk(aParametros, aConfig) }/*<bNext>*/, ;
{||.T.}/*<bFinish>*/,;
.T./*<.lPanel.>*/,;
{||Plan_Box(oWizard,@lParam, aParametros, aConfig)}/*<bExecute>*/ )

oWizard:NewPanel( "Exporta��o da Planilha Or�ament�ria"/*<chTitle>*/,;
"Neste passo voc� dever� confirmar ou abortar a gera��o do arquivo.",;
{||.T.}/*<bBack>*/, ;
{||.T.}/*<bNext>*/, ;
{|| lRet := xProc(aConfig, cCtaOrc, cPlanOri, cRevOri, cPlanOri, aPeriodo, aPerAux)}/*<bFinish>*/, ;
.T./*<.lPanel.>*/, ;
{||.T.}/*<bExecute>*/ )
                                                                     
TSay():New( 010, 007, {|| "A Planilha Or�ament�ria ser� exportada em arquivo no formato CSV conforme os par�metros selecionados." }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ ) 
TSay():New( 025, 007, {|| "Se o objetivo desta exporta��o for alterar ou inserir novos itens na planilha para posterior importa��o no sistema" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 035, 007, {|| "os seguintes crit�rios devem ser observados:" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 045, 007, {|| "1)  O cabe�alho da planilha n�o pode ser alterado ou exclu�do, e os t�tulos das colunas devem ser mantidos," }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 055, 007, {|| "caso contr�rio n�o ser� poss�vel a sua importa��o;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 065, 007, {|| "2)  Nenhuma coluna pode ser exclu�da;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 075, 007, {|| "3)  Caso sejam alterados ou inseridos novos c�digos para Filial, Planilha Or�ament�ria, Vers�o, Conta Or�ament�ria," }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 085, 007, {|| "Centro de Custo, Item Cont�bil ou Classe Valor o respectivo cadastro deve existir no sistema;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 095, 007, {|| "4)  Caso sejam inseridas novas colunas no arquivo que n�o fazem parte da sua estrutura exportada estas ser�o" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 105, 007, {|| "desconsideradas na importa��o;" }	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 115, 007, {|| "5)  A coluna 'Item' (AK2_ID) foi exportada somente como informativa, na importa��o o sistema pode desconsiderar este"}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )
TSay():New( 125, 007, {|| "c�digo e criar outro de acordo com a seq��ncia da planilha."}	, oWizard:oMPanel[3],,,,  , /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 300/*<nWidth>*/, 08/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )

oWizard:Activate( .T./*<.lCenter.>*/,;
{||.T.}/*<bValid>*/, ;
{||.T.}/*<bInit>*/, ;
{||.T.}/*<bWhen>*/ )

RestArea(aAreaAK1)
RestArea(aAreaAK2)
RestArea(aAreaAK3)
RestArea(aAreaAKE)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �    Plan_Box �Autor  �Leonardo Soncin   � Data � 10/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para escolha da planilha a ser copiada               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Plan_Box(oWizard, lParam, aParametros, aConfig)

LOCAL cLoad		:= ""						// Nome do arquivo aonde as respostas do usu�rio ser�o salvas / lidas
LOCAL lCanSave	:= .T.						// Se as respostas para as perguntas podem ser salvas
LOCAL lUserSave := .T.						// Se o usu�rio pode salvar sua propria configuracao

If lParam == NIL
	ParamBox(aParametros ,"Parametros", aConfig,,,.F.,120,3, oWizard:oMPanel[oWizard:nPanel], cLoad, lCanSave, lUserSave)
	lParam := .T.
Else
	Rest_Par(aConfig)
EndIf

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Rest_Par   �Autor  �Paulo Carnelossi   � Data � 16/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para restauracao dos conteudos das variaveis MV_PAR  ���
���          �na navegacao entre os paineis do assistente de copia        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Fim_Wiz �Autor  �Paulo Carnelossi   � Data � 16/05/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para execucao das rotinas de copias quando pressionar���
���          �o botao Finalizar do assistente de copia                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//���������������������������������Ŀ
//� Estrutura do arquivo temporario �
//�����������������������������������
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

//���������������������������Ŀ
//� Cria o arquivo temporario �
//�����������������������������
cNomeArq := CriaTrab( aEstrut, .T. )
dbUseArea( .T.,,cNomeArq, cAliasTmp, .F., .F. )

IndRegua( cAliasTmp, cNomeArq, "AK2_CO+AK2_CC+AK2_ITCTB+AK2_CLVLR+AK2_CLASSE+AK2_OPER",,,"Criando Indice, aguarde..." )
dbClearIndex()
dbSetIndex( cNomeArq + OrdBagExt() )


//��������������������������������������������������������������Ŀ
//� Monta nome do arquivo e diretorio onde sera gravado.         �
//����������������������������������������������������������������

cDest 	:= IIF(Right(cDest,1) == "\",Substr(cDest,1,Len(cDest)-1),cDest)	//retira a "\" da ultima posicao se existir
cNomArq := MV_PAR12

MakeDir( cDest )
If File(cDest+'\'+cNomArq)
	
	If !(Aviso("Arquivo Existente","O arquivo:"+cDest+'\'+cNomArq+" j� existe, deseja sobrescrever?",{"Sim","N�o"},1)==1)
		
		//�������������Ŀ
		//� Apaga o TMP	�
		//���������������
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
	//�������������Ŀ
	//� Apaga o TMP	�
	//���������������
	dbSelectArea( cAliasTmp )
	DbCloseArea()
	FErase( cNomeArq + ".DBF" )
	FErase( cNomeArq + OrdBagExt() )
	
	Return(lRet)
EndIf

//��������������������������������������������������������������Ŀ
//� Exporta Cabecalho do arquivo.                                �
//����������������������������������������������������������������

FWrite(nHdl, 'AK2_FILIAL;AK2_ORCAME;AK2_VERSAO;AK2_CO;AK2_ID;AK2_CC;AK2_ITCTB;AK2_CLVLR;AK2_CLASSE;AK2_OPER')
aEval( aPeriodo,{|x| FWrite(nHdl,";"+Substr(x,1,10)) } )
FWrite(nHdl, CRLF)

cQuery :=  "SELECT AK2_FILIAL, AK2_ORCAME, AK2_VERSAO, AK2_CO, AK2_CC, AK2_ITCTB, AK2_CLVLR, AK2_ID, AK2_PERIOD, AK2_VALOR, AK2_CLASSE, AK2_OPER "
cQuery +=  "FROM "+RetSqlName("AK2")+" SN1 "
cQuery +=  "WHERE AK2_FILIAL = '"+xFilial("AK2")+"' AND "
cQuery +=  "AK2_ORCAME = '"+MV_PAR02+"' AND AK2_VERSAO = '"+MV_PAR03+"' AND "
cQuery +=  "AK2_CO BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' AND "
cQuery +=  "AK2_CC BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' AND "
cQuery +=  "AK2_ITCTB BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' AND "
cQuery +=  "AK2_CLVLR BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' AND "
cQuery +=  "D_E_L_E_T_ = '' "
cQuery +=  "ORDER BY AK2_FILIAL, AK2_ORCAME, AK2_VERSAO, AK2_CO, AK2_ID, AK2_PERIOD"

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
	oProcess:IncRegua2("Ordem de producao:")
	                                        
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
			(cAliasTmp)->AK2_FILIAL := (cAliasTrb)->AK2_FILIAL
			(cAliasTmp)->AK2_ORCAME := (cAliasTrb)->AK2_ORCAME
			(cAliasTmp)->AK2_VERSAO := (cAliasTrb)->AK2_VERSAO
			(cAliasTmp)->AK2_CO 	:= (cAliasTrb)->AK2_CO
			(cAliasTmp)->AK2_ID 	:= (cAliasTrb)->AK2_ID
			(cAliasTmp)->AK2_CC		:= (cAliasTrb)->AK2_CC
			(cAliasTmp)->AK2_ITCTB 	:= (cAliasTrb)->AK2_ITCTB
			(cAliasTmp)->AK2_CLVLR 	:= (cAliasTrb)->AK2_CLVLR
			(cAliasTmp)->AK2_CLASSE	:= (cAliasTrb)->AK2_CLASSE			
			(cAliasTmp)->AK2_OPER	:= (cAliasTrb)->AK2_OPER
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
	ApMsgStop( 'N�o existem Itens para esta Planilha Or�ament�ria. O processamento ser� abortado.' + CRLF +'Para que seja poss�vel a exporta��o da Planilha � necess�rio que exista pelo menos um item cadastrado.', 'ATEN��O' )
Endif

fClose(nHdl)

//�������������Ŀ
//� Apaga o TMP	�
//���������������
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