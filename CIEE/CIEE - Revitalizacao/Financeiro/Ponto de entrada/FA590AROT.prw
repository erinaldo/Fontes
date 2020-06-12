#include "Protheus.ch"
#include "TopConn.ch"

/*---------------------------------------------------------------------------------------
{Protheus.doc} FA590AROT
P.E. adiciona Menu - Permite enviar aprovação de Borderô para Procuradores

@class		Nenhum
@from 		Nenhum
@param    	Nenhum
@attrib    	Nenhum
@protected  Nenhum
@author     AF Custom
@version    P.11
@since      01/10/2014
@return    	Nenhum
@sample   	Nenhum
@obs      	Nenhum
@project    CIEE - Revitalização
@menu    	Nenhum
@history    Nenhum
---------------------------------------------------------------------------------------*/

User Function FA590AROT()
Local aRotNew:=Paramixb[1]
If IsInCallStak('Fin590Pag')//Bordero de Pagamentos
	Aadd(aRotNew,{"Envio Procurador", "u_xF590Sel" , 0 , 4})
EndIf
Return(aRotNew)

/*-----------------------------------------------------------------------------
*
* xF590Sel()
* Seleção dos Borderos para envio de aprovação de Procuradores
*
-----------------------------------------------------------------------------*/
User Function xF590Sel()

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
	MsgAlert('Não há Grupo de Aprovação definido para geração de alçada.')
	Return()
EndIf   

aAdd(aParamBox,{1,"Venc. Real De"	,cTod(''),"","","","",0,.T.})
aAdd(aParamBox,{1,"Venc. Real Ate"	,cTod(''),"","","","",0,.T.})
aAdd(aParamBox,{1,"Bordero De"	,Space(TamSx3('E1_NUMBOR')[1])	,"","","SEA"	,"",0,.F.})
aAdd(aParamBox,{1,"Bordero Ate"	,Space(TamSx3('E1_NUMBOR')[1])	,"","","SEA"	,"",0,.T.})

If ParamBox(aParamBox,"Aprovação de Procuradores",@aRet,,,,,,,,.T.,.T.)
	
	cQuery:= "Select Distinct EA_NUMBOR, EA_DATABOR From "+RetSqlName('SEA')
	cQuery+= " 		Inner Join "+RetSqlName('SE2')
//	cQuery+= " 		On EA_FILIAL=E2_FILIAL AND EA_NUMBOR=E2_NUMBOR"
	cQuery+= " 		On EA_NUMBOR=E2_NUMBOR"   
	cQuery+= "		And EA_CART='P'"
	cQuery+= " 		And "+RetSqlName('SEA')+".D_E_L_E_T_=' '"
	cQuery+= " Where E2_FILIAL='"+xFilial('SE2')+"'"
	cQuery+= " 		And E2_NUMBOR Between '"+MV_PAR03+"' and '"+MV_PAR04+"'"
	cQuery+= " 		And E2_VENCREA Between '"+DToS(MV_PAR01)+"' And '"+DtoS(MV_PAR02)+"'"
	cQuery+= " 		And E2_XSTSAPV='2'"//Aprovado inicial Ok
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
		DEFINE MSDIALOG oDlg TITLE 'Borderôes para aprovação.' FROM 0,0 TO 240,500 PIXEL
		@ 08,10 SAY "Selecione o borderô para solicitação de Aprovação de Procuradores." SIZE 200,008 PIXEL OF oDlg
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
				aAprov:=xGetAprov()//-- Solicita a seleção dos Aprovadores.
				If Len(aAprov)==2
					xGeraAlc(aAprov,aMarcados,cGrpAprov)
					MsgAlert('Alçada gerada para o Borderô selecionado.')
				Else
					MsgAlert('Não há aprovadores suficientes para geração de alçada.')
				EndIF
			Else     
				MsgAlert('Não há Borderôs selecionados para geração de alçada.')
			EndIF
		EndIF
	Else
		MsgAlert('Não foram localizados Borderôs.')
	EndIf
EndIF

RestArea(aArea)
Return

//--------------------------------------------
//-- Seleção dos Procuradores para aprovação
//---------------------------------------------
Static Function xGetAprov()

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
cQuery+=" Where AK_FILIAL='"+xFilial('SAK')+"' AND AK_XTIPAPR='BP' And D_E_L_E_T_=' '"
TcQuery cQuery New Alias (cAlias:=GetNextAlias())

dbSelectarea(cAlias)
While !Eof()
	Aadd(aVetor,{.F.,(cAlias)->AK_COD,(cAlias)->AK_USER,(cAlias)->AK_NOME})
	dbSkip()
End
dbCloseArea()

If Len(aVetor)>=2//-- Necessita 2 aprovadores
	DEFINE MSDIALOG oDlg TITLE 'Borderô de Pagamentos - Aprovadores' FROM 0,0 TO 240,500 PIXEL
	
	@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER " ", RetTitle('AK_COD'), RetTitle('AK_NOME') ;
	SIZE 230,095 OF oDlg PIXEL ON dblClick(xDblClick())
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
	aVetor[oLbx:nAt,2],;//Codigo
	aVetor[oLbx:nAt,4]}}//Nome
	
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (Iif(xButtonOk(),(lOk:=.T.,oDlg:End()),Nil)) ENABLE OF oDlg
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

//------------------------------------------------------------
//-- Double click do listbox de Aprovadores
//------------------------------------------------------------
Static Function xDblClick()

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
	If  nCont<2
		aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1]
	Else
		Alert('Para aprovação de Procuradores são necessários apenas dois aprovadores.')
	EndIf
EndIf
oLbx:Refresh()
Return

//------------------------------------------------------------
//-- Valid do Ok da tela de seleção de aprovadores.
//------------------------------------------------------------
Static Function xButtonOk()
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
	Alert('Para aprovação de Procuradores são necessários dois aprovadores.')
EndIf
Return(lRet)

//------------------------------------------------------------                      
//-- Gera alçada para Produradores
//------------------------------------------------------------
Static Function xGeraAlc(aAprov,aMarcados,cGrpAprov)                                    

Local nX:=0
Local cDoc:=''
Local nReg:=1

For nX:=1 to Len(aMarcados)            
	
	cDoc:=aMarcados[nX,1]+'_2'//--Segunda aprovação	
	cDoc:=PadR(cDoc,TamSx3('CR_NUM')[1])

	dbSelectArea('SCR')
	dbSetOrder(1)//Filial_Tipo+Num
	If dbSeek(xFilial('SCR')+'BP'+cDoc)
		Loop//-- Ja gerado
	EndIf
	    	
	//-- Gera alçada de aprovação      	
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
	//-- Nesse ponto {aAprov} possui 2 posições, pois foi validado antes.
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
	
Next nX

//-- Envio do WF para aprovação pelo Job TES006WF().
//-- Status do E2 continua como 2 e TES006WF() grava Status='4'
/*
* 0-Gerado Bordero
* 1-Enviado para aprovação inicial
* 2-Aprovado inicial
* 3-Reprovado inicial
* 4-Enviado para aprovação de PROCURADOR
* 5-Aprovado pelo Procurador
* 6-Reprovado pelo Procurador
*/

Return