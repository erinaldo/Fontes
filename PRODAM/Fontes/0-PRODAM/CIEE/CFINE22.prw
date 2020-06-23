#Include 'Protheus.ch'
#include "TopConn.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CFINE22
Sele��o dos Borderos para envio de aprova��o de Procuradores
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CFINE22()
Local aArea:=GetArea()
Local aRet := {}
Local aParamBox := {}
Local cQuery:=''
Local cAlias:=''
Local aBordero:={}
Local aMarcados:={}

Local lOk		:=.F.
Local cVar     := Nil
Local oDlg     := Nil
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "LBTIK" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
Local oChk     := Nil
Local oLbx 	   := Nil  
Local cGrpAprov:=GetMv('CI_GRPFIWF',,'')

If Empty(cGrpAprov)
	MsgAlert('N�o h� Grupo de Aprova��o definido para gera��o de al�ada.')
	Return()
EndIf   

aAdd(aParamBox,{1,"Venc. Real De"	,cTod(''),"","","","",0,.T.})
aAdd(aParamBox,{1,"Venc. Real Ate"	,cTod(''),"","","","",0,.T.})
aAdd(aParamBox,{1,"Bordero De"	,Space(TamSx3('E1_NUMBOR')[1])	,"","","SEA"	,"",0,.F.})
aAdd(aParamBox,{1,"Bordero Ate"	,Space(TamSx3('E1_NUMBOR')[1])	,"","","SEA"	,"",0,.T.})

If ParamBox(aParamBox,"Aprova��o de Procuradores",@aRet,,,,,,,,.T.,.T.)
	
	cQuery:= "Select Distinct EA_NUMBOR, EA_DATABOR From "+RetSqlName('SEA')
	cQuery+= " 		Inner Join "+RetSqlName('SE2')
//	cQuery+= " 		On EA_FILIAL=E2_FILIAL AND EA_NUMBOR=E2_NUMBOR"
	cQuery+= " 		On EA_NUMBOR=E2_NUMBOR"   
	cQuery+= "		And EA_CART='P'"
	cQuery+= " 		And "+RetSqlName('SEA')+".D_E_L_E_T_=' '"
	cQuery+= " Where E2_FILIAL='"+xFilial('SE2')+"'"
	cQuery+= " 		And E2_NUMBOR Between '"+MV_PAR03+"' and '"+MV_PAR04+"'"
	cQuery+= " 		And E2_VENCREA Between '"+DToS(MV_PAR01)+"' And '"+DtoS(MV_PAR02)+"'"
	cQuery+= " 		And E2_XSTSAPV NOT IN ('0','1','4')"//Aprovado inicial Ok
	cQuery+= " 		And "+RetSqlName('SE2')+".D_E_L_E_T_=' '"
	TcQuery cQuery New ALias (cAlias:=GetNextAlias())      
	
	dbSelectArea(cAlias)
	While !Eof()              
		cQuery:=" Select Sum(E2_SALDO) SALDO From " +RetSqlName('SE2')
		cQuery+=" Where E2_FILIAL='"+xFilial('SE2')+"' AND E2_NUMBOR='"+(cAlias)->EA_NUMBOR+"' AND D_E_L_E_T_=''"
		TcQuery cQuery New ALias (cAlsSld:=GetNextAlias())      
		
		Aadd(aBordero,{.F.,(cAlias)->EA_NUMBOR,Stod((cAlias)->EA_DATABOR),(cAlsSld)->SALDO})
		(cAlsSld)->(dbCloseArea())

		dbSelectArea(cAlias)
		dbSkip()
	End
	dbcloseArea()
	
	If Len(aBordero)>0
		DEFINE MSDIALOG oDlg TITLE 'Border�es para aprova��o.' FROM 0,0 TO 240,500 PIXEL
		@ 08,10 SAY "Selecione o border� para solicita��o de Aprova��o de Procuradores." SIZE 200,008 PIXEL OF oDlg
		@ 20,10 LISTBOX oLbx VAR cVar;
		FIELDS HEADER " ", RetTitle("EA_NUMBOR"),RetTitle("EA_DATABOR")	,"Valor" SIZE 230,085 OF oDlg PIXEL ON dblClick(aBordero[oLbx:nAt,1]:=!aBordero[oLbx:nAt,1])
		
		oLbx:SetArray( aBordero )
		oLbx:bLine := {|| {Iif(aBordero[oLbx:nAt,1],oOk,oNo),;
							aBordero[oLbx:nAt,2],;
							DtoC(aBordero[oLbx:nAt,3])}}							
	                       //Transform(aBordero[oLbx:nAt,4],'@E 9,999,999,999.99')}}							
		
		DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (Iif(.T.,(lOk:=.T.,oDlg:End()),Nil)) ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg CENTER
		
		If lOk
			For nX:=1 to Len(aBordero)
				If aBordero[nX,1]
					Aadd(aMarcados,{aBordero[nX,2],aBordero[nX,4]})
				EndIF
			Next nX
			If Len(aMarcados)>0
				aAprov:=C6E22GPR()//-- Solicita a sele��o dos Aprovadores.
				If Len(aAprov)==1
					C6E22ALC(aAprov,aMarcados,cGrpAprov)
					Msginfo('Al�ada gerada para o Border� selecionado.')
				Else
					MsgAlert('N�o h� aprovadores suficientes para gera��o de al�ada.')
				EndIF
			Else     
				MsgAlert('N�o h� Border�s selecionados para gera��o de al�ada.')
			EndIF
		EndIF
	Else
		MsgAlert('N�o foram localizados Border�s.')
	EndIf
EndIF

RestArea(aArea)
Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} C6E22GPR
Sele��o dos Procuradores para aprova��o
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function C6E22GPR()

Local lOk		:=.F.
Local aAprov	:={}
Local cVar     := Nil
Local oDlg     := Nil
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "LBTIK" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
Local oChk     := Nil

Local cQuery:=''
Local cAlias:=''

Private oLbx := Nil
Private aVetor := {}

//-- Seleciona os aprovadores de Revisao Contratual
cQuery:=" Select AK_COD, AK_USER, AK_NOME From "+RetSqlName('SAK')
cQuery+=" Where AK_FILIAL='"+xFilial('SAK')+"' AND AK_XTIPAPR like '%BP%' And D_E_L_E_T_=' '"
TcQuery cQuery New Alias (cAlias:=GetNextAlias())

dbSelectarea(cAlias)
While !Eof()
	Aadd(aVetor,{.F.,(cAlias)->AK_COD,(cAlias)->AK_USER,(cAlias)->AK_NOME})
	dbSkip()
End
dbCloseArea()

If Len(aVetor)>=2//-- Necessita 2 aprovadores
	DEFINE MSDIALOG oDlg TITLE 'Border� de Pagamentos - Aprovadores' FROM 0,0 TO 240,500 PIXEL
	
	@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER " ", RetTitle('AK_COD'), RetTitle('AK_NOME') ;
	SIZE 230,095 OF oDlg PIXEL ON dblClick(C6E22DPR())
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;//Codigo
	aVetor[oLbx:nAt,4]}}//Nome
	
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (Iif(C6E22BOK(),(lOk:=.T.,oDlg:End()),Nil)) ENABLE OF oDlg
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
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} C6E22DPR
Double click do listbox de Aprovadore
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function C6E22DPR()

Local nCont:=0
Local nX:=0

If aVetor[oLbx:nAt,1]//-- Esta desmarcando
	aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1]
	
Else//-- Esta marcando
	
	For nX:=1 to Len(aVetor)
		If aVetor[nX,1]
			nCont++
		EndIf
	Next nX
	If  nCont<1
		aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1]
	Else
		Alert('Para aprova��o de Procuradores � necess�rio um aprovador.')
	EndIf
EndIf
oLbx:Refresh()
Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} C6E22BOK
Valid do Ok da tela de sele��o de aprovadores.
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function C6E22BOK()
Local lRet:=.T.
Local nX:=0
Local nCont:=0

For nX:=1 to Len(aVetor)
	If aVetor[nX,1]
		nCont++
	EndIf
Next nX
If  nCont<1
	lRet:=.F.
	Alert('Para aprova��o de Procuradores � necess�rio um aprovador.')
elseif nCont>1 
	lRet:=.F.
	Alert('Para aprova��o de Procuradores selecione apenas um aprovador.')	
EndIf

Return(lRet)
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} C6E22ALC
Gera al�ada para Produradores
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
Static Function C6E22ALC(aAprov,aMarcados,cGrpAprov)                                    

Local nX:=0
Local cDoc:=''
Local nReg:=1

For nX:=1 to Len(aMarcados)            
	
	cDoc:=aMarcados[nX,1]+'_2'//--Segunda aprova��o	
	cDoc:=PadR(cDoc,TamSx3('CR_NUM')[1])
	
	dbSelectArea('SCR')
	dbSetOrder(1)
	If dbSeek(xFilial('SCR')+'BP'+cDoc)	
		MaAlcDoc({cDoc,"BP",,,,,,1,0,},,3)
	Endif	
		    	
	//-- Gera al�ada de aprova��o      	
	MaAlcDoc({;
			cDoc,			;	//[1] Numero do documento
			'BP',			;   //[2] Tipo de Documento --> BP=Bordero Pagamento
			aMarcados[nX,2],;   //[3] Valor do Documento
			"",				; 	//[4] Codigo do Aprovador
			__cUserId,		;   //[5] Codigo do Usuario
			cGrpAprov,		;	//[6] Grupo do Aprovador
			"",				;   //[7] Aprovador Superior
			,				;   //[8] Moeda do Documento		
			,				;   //[9] Taxa da Moeda
			dDataBase,		;   //[10] Data de Emis.Doc.
			""}				;	//[11] Grupo de Compras
			,dDataBase,1,"",.F.)

	//-- Altera os aprovadore para os que foram selecionados.
	//-- Nesse ponto {aAprov} possui 2 posi��es, pois foi validado antes.
	nReg:=1
	dbSelectArea('SCR')
	dbSetOrder(1)//Filial_Tipo+Num
	If dbSeek(xFilial('SCR')+'BP'+cDoc)
		While !Eof() .And. CR_FILIAL+CR_TIPO+CR_NUM==xFilial('SCR')+'BP'+cDoc
			If nReg==1 .Or. nReg==2
				RecLock('SCR',.F.)
				CR_APROV:=aAprov[nReg,1]
				CR_USER:=aAprov[nReg,2]
				msUnLock()
				nReg++
			EndIf
		dbSkip()
		End
	EndIf 
	
	//-- Atualiza Contas a Pagar  
	cQuery:=" Update "+RetSqlName('SE2')
	cQuery+=" Set "
	cQuery+=" E2_XSOLAPV='"+__cUserID+"',"//Solicitante da aprova��o
	cQuery+=" E2_XSTSAPV='0'"//Status da Aprova��o
	cQuery+=" Where E2_FILIAL='"+xFilial('SE2')+"' AND E2_NUMBOR='"+TRIM(aMarcados[nX,1])+"' AND D_E_L_E_T_=''"
	TcSqlExec(cQuery)	
	
Next nX

//-- Envio do WF para aprova��o pelo Job CFINW08().
//-- Status do E2 continua como 2 e CFINW08() grava Status='4'
/*
* 0-Gerado Bordero
* 1-Enviado para aprova��o inicial
* 2-Aprovado inicial
* 3-Reprovado inicial
* 4-Enviado para aprova��o de PROCURADOR
* 5-Aprovado pelo Procurador
* 6-Reprovado pelo Procurador
*/

Return
