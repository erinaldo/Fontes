#include "Protheus.ch"
#include "TopConn.ch"

Static __lFirst	:=.T.
Static __lFim		:=.F.
Static __aAprov	:={}
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CGCTE02
Controle de al็adas na revisใo do contrato
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CGCTE02() // ExecBlock("CN140GREV",.F.,.F.,{cContra,cRevisa,cNRevisa,cCodTR,cJust,cClaus})
Local dDtRevAnt	:= ctod("")
Local dDtRevAtu	:= ctod("")
Local nValAnt		:= 0
Local nValAtu		:= 0
Local aArea		:= GetArea()
Local cContra		:= ParamIXB[1]
Local cRevAnt		:= ParamIXB[2]
Local cRevAtu		:= ParamIXB[3]
Local cCodRev		:= ParamIXB[4]
Local cJust		:= ParamIXB[5]
Local cClaus		:= ParamIXB[6]
Local aCN9_Idem	:= {}//-- Array de contratos de mesmo ํndice para Reajuste automatico
Local cIndice		:= ''                    
Local lErro		:= .F.
Local cMsg 		:= ''
Local _obrw		:= NIL
Local cGrpAprov	:= PadR(GetMv('CI_GRPAPR2',,''),Tamsx3('AL_COD')[1])//Grupo de aprova็ใo

dbSelectArea('CN0')
dbSetOrder(1)
dbSeek(xFilial('CN0')+cCodRev)

//-- Regra aplicada somente a Revisao de Tipo=Reajuste
If CN0->CN0_TIPO$'2'
	dbSelectArea("CN9")
	dbSetOrder(1)              
	//----------------------------
	//-- Dt da Revisao Anterior
	//----------------------------
	if dbSeek(xFilial("CN9")+cContra+cRevAnt)
		dDtRevAnt:= Iif(Empty(CN9->CN9_DTREV),CN9->CN9_DTINIC,CN9->CN9_DTREV)//Quando Empty(), ้ o primeiro contrato.
	Endif
	
	//----------------------------
	//-- Data da Revisao atual
	//----------------------------
	if dbSeek(xFilial("CN9")+cContra+cRevAtu)   
		dDtRevAtu	:= CN9->CN9_DTREV
		cIndice	:= CN9->CN9_INDICE
		dDtReaj	:= CN9->CN9_DTREAJ
		
		// Grava c๓digo do usuario que realizaou a revisใo
		RECLOCK("CN9",.F.)
			CN9->CN9_XUSRRE:= __CUSERID
			CN9->CN9_XGRPAP:= cGrpAprov
			CN9->CN9_SITUAC:= "04"
		MSUNLOCK()
		
	Endif
	                              
	//----------------------------------------------------
	//-- Data de referencia do Historico de Indices
	//----------------------------------------------------
	dbSelectArea('CN6')//-- Indices
	dbSetOrder(1) 
	dbSeek(xFilial('CN6')+CN9->CN9_INDICE)  
	If CN6->CN6_TIPO=='1'//-- Diario
		dbSelectArea('CN7')
		dbSetOrder(1)//Indice+Data 
		If CN7->(dbSeek(xFilial('CN7')+CN9->CN9_INDICE+DtoS(dDtRevAnt)))//-- Valor anterior
			nValAnt:=Iif(Empty(CN7->CN7_VLREAL),CN7->CN7_VLPROJ,CN7->CN7_VLREAL)
		EndIf
		If CN7->(dbSeek(xFilial('CN7')+CN9->CN9_INDICE+DtoS(dDtRevAtu)))//-- Valor atual
			nValAtu:=Iif(Empty(CN7->CN7_VLREAL),CN7->CN7_VLPROJ,CN7->CN7_VLREAL)
		EndIf	
	Else//-- Mensal
		dbSelectArea('CN7')
		dbSetOrder(2)//Indice+Competencia
		If CN7->(dbSeek(xFilial('CN7')+CN9->CN9_INDICE+StrZero(Month(dDtRevAnt),2)+'/'+StrZero(Year(dDtRevAnt),4)))
			nValAnt:=Iif(Empty(CN7->CN7_VLREAL),CN7->CN7_VLPROJ,CN7->CN7_VLREAL)
		EndIf
		If CN7->(dbSeek(xFilial('CN7')+CN9->CN9_INDICE+StrZero(Month(dDtRevAtu),2)+'/'+StrZero(Year(dDtRevAtu),4)))
			nValAtu:=Iif(Empty(CN7->CN7_VLREAL),CN7->CN7_VLPROJ,CN7->CN7_VLREAL)
		EndIf	
	EndIf

	If __lFirst				
		__lFirst:=.F.//-- Quando entrar nesse P.E novamente, somente atualiza o contrato onde nasceu esse processo
			
		aCN9_Idem:= C8E02CON(cIndice)//-- Verifica se existem mais contratos de mesmo ํndice aptos a serem revisados.
		
		If nValAtu > nValAnt
			If C8E02GRP(cGrpAprov)
				__aAprov:= C8E02SEL()	//-- Solicita ao usuario a sele็ใo dos aprovadores
			Endif	
		Endif
	
		cJust+=(CRLF+"Reajuste automแtico do contrato efetuado em " + Dtoc(dDataBase))
		For nX:=1 to Len(aCN9_Idem)  
			If aCN9_Idem[nX,1]
				//CN140GerRev(cContra,cRevisa,cCodTR,cJust,cCodPr,dDtRein,dDtReaj,cClaus,aItens,aPlan,aParcelas,aCron,dFContra,aHeaderIt,aHeadParc,aColsParc,aItensCtb,nValor,lAltVlr,nVgAdit,aReman,cFornec,cLoja)
				//-- A cada execu็ใo de CN140GerRev() vai entrar no u_CN140GREV(), por isso o controle atravez da __lFirst
				CN140GerRev(aCN9_Idem[nX,2],aCN9_Idem[nX,3],cCodRev,cJust,,,dDtReaj,cClaus)
			EndIf
		Next nX
		
		__lFim	:=.T.
	EndIf		
	
	If Len(__aAprov)==2 //-- Necessita 2 aprovadores
		//-- Gera a al็ada
		CN9->(dbSeek(xFilial("CN9")+cContra+cRevAtu))
		C8E02ALC(__aAprov,cGrpAprov)		
	Endif	
	
EndIf

IF __lFim
	_obrw:= GetObjBrow()
	_obrw:Default()  
	_obrw:Refresh()
ENDIF  

RestArea(aArea)
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C8E02GRP	  บAutor  ณ Totvs				  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se Grupo de Aprova็ใo existe     			  		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                     	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C8E02GRP(cGrpAprov) 
Local nTot:=0

dbSelectArea('SAL')     
dbSetOrder(1)
If dbSeek(xFilial('SAL')+cGrpAprov)
	While !Eof() .And. xFilial('SAL')+cGrpAprov==AL_FILIAL+AL_COD
		nTot++
	dbSkip()
	End
EndIf
Return(nTot==2)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C8E02SEL	  บAutor  ณ Totvs				  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Solicita ao usuario a sele็ใo dos aprovadores		  		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                     	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C8E02SEL()
Local lOk		:= .F.
Local aAprov	:= {}
Local cVar    := Nil
Local oDlg    := Nil
Local lMark   := .F.
Local oOk     := LoadBitmap( GetResources(), "LBTIK" )   //CHECKED    //LBOK  //LBTIK
Local oNo     := LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
Local oChk    := Nil
Local cQuery	:= ''
Local cAlias	:= ''
Private oLbx 	:= Nil
Private aVetor:= {}

//-- Seleciona os aprovadores de Revisao Contratual
cQuery:=" Select AK_COD, AK_USER, AK_NOME From "+RetSqlName('SAK')
cQuery+=" Where AK_FILIAL='"+xFilial('SAK')+"' AND AK_XTIPAPR like '%RC%' And D_E_L_E_T_=' '"
cQuery+=" ORDER BY AK_COD"
TcQuery cQuery New Alias (cAlias:=GetNextAlias())

dbSelectarea(cAlias)
While !Eof()
	Aadd(aVetor,{.F.,(cAlias)->AK_COD,(cAlias)->AK_USER,(cAlias)->AK_NOME})
dbSkip()
End     
dbCloseArea()

If Len(aVetor)>=2//-- Necessita 2 aprovadores
	DEFINE MSDIALOG oDlg TITLE 'Revisใo de contratos - Aprovadores' FROM 0,0 TO 240,500 PIXEL
	  
	@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER " ", RetTitle('AK_COD'), RetTitle('AK_NOME') ;
	   SIZE 230,095 OF oDlg PIXEL ON dblClick(C8E02DBL())
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
	                       aVetor[oLbx:nAt,2],;//Codigo
	                       aVetor[oLbx:nAt,4]}}//Nome
		 
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (Iif(C8E02TOK(),(lOk:=.T.,oDlg:End()),Nil)) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
EndIf

If lOk
	For nX:=1 to Len(aVetor)                 
		If aVetor[nX,1]
			Aadd(aAprov,{aVetor[nX,2],aVetor[nX,3]})//Codigo e Usuario
		EndIf
	Next nX 	
EndIf

Return(aAprov)                                                
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C8E02DBL	  บAutor  ณ Totvs				  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Double click do listbox de Aprovadores		  		       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                     	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/  
Static Function C8E02DBL()
Local nCont	:= 0
Local nX		:= 0

If aVetor[oLbx:nAt,1]//-- Esta desmarcando
		aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1]
		
Else//-- Esta marcando

	For nX:=1 to Len(aVetor)                 
		If aVetor[nX,1]
			nCont++
		EndIf
	Next nX
	If  nCont<2
		aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1]
	Else
		Alert('Para aprova็ใo da revisใo de contrato sใo necessแrios apenas dois aprovadores.')
	EndIf
EndIf
oLbx:Refresh()
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C8E02TOK	  บAutor  ณ Totvs				  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Valid do Ok da tela de sele็ใo de aprovadores.   	       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                     	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/  
Static Function C8E02TOK()
Local lRet:=.T.
Local nX:=0
Local nCont:=0

For nX:=1 to Len(aVetor)                 
	If aVetor[nX,1]
		nCont++
	EndIf
Next nX
If  nCont<2 
	lRet:=.F.
	Alert('Para aprova็ใo da revisใo de contrato sใo necessแrios dois aprovadores.')
EndIf
Return(lRet)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C8E02ALC	  บAutor  ณ Totvs				  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Gera al็ada para libera็ใo							   	       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                     	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/ 
Static Function C8E02ALC(aAprov,cGrpAprov)
Local nReg			:= 1
Local cDoc			:= CN9->CN9_NUMERO + CN9->CN9_REVISA
Local nTxMoeda	:= recMoeda(dDataBase,CN9->CN9_MOEDA)
Local cAprovOri	:= ""	
Local cUserOri	:= ""	

cDoc:=PAdr(cDoc,TamSx3('CR_NUM')[1])
MaAlcDoc({;
	cDoc,			;	//[1] Numero do documento
	'RC',			;   //[2] Tipo de Documento
	CN9->CN9_VLINI,	;   //[3] Valor do Documento
	"",				; 	//[4] Codigo do Aprovador
	__cUserId,		;   //[5] Codigo do Usuario
	cGrpAprov,		;	//[6] Grupo do Aprovador
	"",				;   //[7] Aprovador Superior
	CN9->CN9_MOEDA,	;   //[8] Moeda do Documento		
	nTxMoeda,		;   //[9] Taxa da Moeda
	dDataBase,		;   //[10] Data de Emis.Doc.
	""}				;	//[11] Grupo de Compras
	,dDataBase,1,"",.F.)
 
//-- Altera os aprovadore para os que foram selecionados.
//-- Nesse ponto {aAprov} possui 2 posi็๕es, pois foi validado antes.
dbSelectArea('SCR')
dbSetOrder(1)//Filial_Tipo+Num
If dbSeek(xFilial('SCR')+'RC'+cDoc)
	While !Eof() .And. CR_FILIAL+CR_TIPO+CR_NUM==xFilial('SCR')+'RC'+cDoc
		cAprovOri	:= SCR->CR_APROV	
		cUserOri	:= SCR->CR_USER	
		If nReg==1 .Or. nReg==2
			RecLock('SCR',.F.)
			SCR->CR_APRORI  	:= cAprovOri	
			SCR->CR_USERORI 	:= cUserOri			
			SCR->CR_APROV		:= aAprov[nReg,1]
			SCR->CR_USER		:= aAprov[nReg,2]
			msUnLock()
			nReg++
		EndIf
	dbSkip()
	End
EndIf 

Return
/*
//ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C8E02SET	  บAutor  ณ Totvs				 บ Data ณ01/01/2015  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ User function chamada a partir de u_CN140CAN. Sempre que   บฑฑ
ฑฑบ          ณ inicia nova Revisใo, faz a verifica็ใo de contratos de     บฑฑ
ฑฑบ          ณ mesmo ํndice												       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/ 
User Function C8E02SET()
__lFirst:=.T.//-- Static
//__aAprov:={}//-- Static
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C8E02CON	  บAutor  ณ Totvs				  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica contratos de mesmo ํndice aptos a serem revisados บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                     	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C8E02CON(cIndice)

Local cQuery:=''
Local cAlias:=''
Local aArea:=GetArea()
Local aContr:={}

Local lOk		:=.F.
Local cVar     := Nil
Local oDlg     := Nil
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "LBTIK" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
Local oChk     := Nil
Local oLbx 	   := Nil

cQuery:=" Select * From "+RetSqlName('CN9')
cQuery+=" Where CN9_FILIAL='"+xFilial('CN9')+"' AND CN9_SITUAC='05'"//Vigente
cQuery+=" And"
cQuery+=" 	("
cQuery+=" 		(CN9_REVISA<>'' AND CN9_REVATU='')"//Revisใo atual vigente.
cQuery+=" 		OR"
cQuery+=" 		(CN9_REVISA='' AND CN9_REVATU='')"//Primeiro contrato - Sem nenhuam revisao
cQuery+=" 	)"
cQuery+=" And CN9_INDICE='"+cIndice+"'"//-- Mesmo indice
cQuery+=" And CN9_FLGREJ='1'"//--Contrato podera ter Reajuste
cQuery+=" And CN9_SALDO > 0 And D_E_L_E_T_=' '"
TcQuery cQuery New Alias (cAlias:=GetNextAlias())

dbSelectArea(cAlias)
While !Eof()
	aAdd(aContr,{.F.,(cAlias)->CN9_NUMERO,(cAlias)->CN9_REVISA,StoD((cAlias)->CN9_DTINIC),StoD((cAlias)->CN9_DTFIM),(cAlias)->CN9_SALDO})
dbSkip()
End           
dbCloseArea()
         
If Len(aContr)>0
	DEFINE MSDIALOG oDlg TITLE 'CONTRATOS DE MESMO อNDICE - '+cIndice FROM 0,0 TO 240,500 PIXEL
	@ 08,10 SAY "Selecione os contrato a aplicar o Reajuste." SIZE 160,008 PIXEL OF oDlg
	@ 20,10 LISTBOX oLbx VAR cVar;
	FIELDS HEADER " ", RetTitle("CN9_NUMERO"),RetTitle("CN9_REVISA"),RetTitle("CN9_DTINIC"),RetTitle("CN9_DTFIM"),RetTitle("CN9_SALDO");
    SIZE 230,085 OF oDlg PIXEL ON dblClick(aContr[oLbx:nAt,1] := !aContr[oLbx:nAt,1])
	
	oLbx:SetArray( aContr )
	oLbx:bLine := {|| {Iif(aContr[oLbx:nAt,1],oOk,oNo),;
	                       aContr[oLbx:nAt,2],;
	                       aContr[oLbx:nAt,3],;
	                       DtoC(aContr[oLbx:nAt,4]),;
	                       DtoC(aContr[oLbx:nAt,5]),;
	                       Transform(aContr[oLbx:nAt,6],PesqPict("CN9","CN9_SALDO"))}}
		 
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (Iif(.T.,(lOk:=.T.,oDlg:End()),Nil)) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
EndIf

RestArea(aArea)
Return(aContr)