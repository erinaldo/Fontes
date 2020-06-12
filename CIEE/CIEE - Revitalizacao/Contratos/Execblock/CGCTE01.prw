#INCLUDE "TOPCONN.CH"
#include "Protheus.ch"

//Situacoes de contrato
#DEFINE DEF_SVIGE "05" //Vigente
#DEFINE DEF_SPARA "06" //Paralisado
#DEFINE DEF_SREVD "10" //Revisado

//Tipos de Revisao
#DEFINE DEF_PARAL "5" //Paralisacao
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CGCTE01
Aprova็ใo da Revisใo do Contrato
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CGCTE01(_nOpc,_cChave)
Local aArea		:= GetArea()
Local lRet    	:= .F.
Local cContra		:= ""
Local cRevisao	:= ""
Local cRevAnt		:= Nil
Private lFisico 	:= .f.
Private lContab := .F.

DO CASE
	CASE _nOpc == 1 // aprovado
	
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CN9") + _cChave)
			
			// Altera de aprova็ใo para revisใo
			RECLOCK("CN9",.F.)
				CN9->CN9_SITUAC:= "09"
			MSUNLOCK()		
		
			lFisico := Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROFIS") == "1"
			lContab := Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROCTB") == "1" //cronograma contแbil
			cRevisao:= CN9->CN9_REVISA     
			cContra := CN9->CN9_NUMERO
			cRevAnt := Nil		
			
			If CN9->CN9_SITUAC == '09'//Em revisใo
			
				dbSelectArea("CN9")
				dbSetOrder(8)
				dbSeek(xFilial("CN9")+cRevisao)
				While CN9->(!Eof()) .And. CN9->(CN9_FILIAL+CN9_REVATU) == xFilial("CN9")+cRevisao
					If CN9->CN9_NUMERO == cContra
						cRevAnt := CN9->CN9_REVISA
						Exit
					EndIf
				CN9->(dbSkip())
				End			
				
				dbSelectArea("CN9")
				dbSetOrder(1)
				If dbSeek(xFilial("CN9") + _cChave)					
					lRet:= C8E01REJ(cContra,cRevisao,cRevAnt)
				Endif	
			
			Endif
		EndIf
	
	CASE _nOpc == 2 // reprovado
		
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CN9") + _cChave)
		
			// Altera de aprova็ใo para revisใo
			RECLOCK("CN9",.F.)
				CN9->CN9_SITUAC:= "09"
			MSUNLOCK()			
			
			lFisico := Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROFIS") == "1"
			lContab := Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROCTB") == "1" //cronograma contแbil				
			cRevisao:= CN9->CN9_REVISA     
			cContra := CN9->CN9_NUMERO
			cRevAnt := Nil		
			
			If CN9->CN9_SITUAC == '09'//Em revisใo
				
				dbSelectArea("CN9")
				dbSetOrder(8)
				dbSeek(xFilial("CN9")+cRevisao)
				While CN9->(!Eof()) .And. CN9->(CN9_FILIAL+CN9_REVATU) == xFilial("CN9")+cRevisao
					If CN9->CN9_NUMERO == cContra
						cRevAnt := CN9->CN9_REVISA
						Exit
					EndIf
				CN9->(dbSkip())
				End
				
				If cRevAnt # NIL                           				
				    //-- Exclui a Revisใo
					CN140DelRev(cContra,cRevAnt,cRevisao)  
				EndIf		
					
			Endif
		EndIf	
		
ENDCASE

RestArea(aArea)
Return(lRet)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C8E01REJ	  บAutor  ณ Totvs				  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza o reajuste do contrato 						  		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                     	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C8E01REJ(_cContrato,_cRevisa,_cORev)
Local lMedeve := .F.
Local lCauc   := .F.
Local lRet    := .F.

//-- Valor do indice para Reajuste
nVlInd:= C8E01IND(dDataBase)
If nVlInd<=0
	Return(lRet)
EndIf

lMedeve := (Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_MEDEVE") == "1")//medicao eventual
lCauc   := (CN9->CN9_FLGCAU == "1" .And. If((CN9->(FieldPos("CN9_TPCAUC")) > 0),(CN9->CN9_TPCAUC == "1"),.T.))//Valida caucao

/*
dbSelectArea("CN9")
dbSetOrder(8)
dbSeek(xFilial("CN9") + _cRevisa)
_cORev := CN9->CN9_REVISA//Revisao anterior

dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9") + _cContrato + _cRevisa)
*/

//-- Reajusta o contrato
lRet := CN150Reaj(_cContrato,_cRevisa,_cORev,lMedeve,dDataBase,dDataBase,nVlInd,lFisico)

If lRet
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtra os contratos com o mesmo codigo de contrato   ณ
	//ณ que estao em processo de aprovacao                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cQuery := "SELECT CN9.CN9_REVISA,CN9.CN9_SITUAC,CN9.CN9_TIPREV,CN9.R_E_C_N_O_ as RECNO FROM " + RetSQLName("CN9") + " CN9 "
	_cQuery += "WHERE CN9.CN9_FILIAL = '" + xFilial("CN9") + "' AND "
	_cQuery += "CN9.CN9_NUMERO = '" + _cContrato + "' AND "
	_cQuery += "CN9.D_E_L_E_T_ <> '*'"
	
	//_cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBCN9",.F.,.T.)
	
	While !TRBCN9->(Eof())
		CN9->(dbgoTo(TRBCN9->RECNO))
		RecLock("CN9",.F.)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ O contrato vigente assume a situacao de revisado     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If AllTrim(TRBCN9->CN9_SITUAC) == DEF_SVIGE .OR. AllTrim(TRBCN9->CN9_SITUAC) == DEF_SPARA
			CN9->CN9_SITUAC := DEF_SREVD
			_cORev          := TRBCN9->CN9_REVISA
		EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ A revisao assume a nova situacao: Vigente/Paralisado ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If  TRBCN9->CN9_REVISA == _cRevisa
			CN9->CN9_SITUAC := DEF_SVIGE
			CN9->CN9_REVATU := ""
		Else
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Os outros contratos apenas alteram a flag de revisao ณ
			//ณ atual                                                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			CN9->CN9_REVATU := _cRevisa
		EndIf
		MsUnLock()
		TRBCN9->(dbSkip())
	EndDo
	TRBCN9->(dbCloseArea())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza data de aniversario dos itens inclusos durante ณ
	//ณ a revisao                                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cQuery := "SELECT CNB.R_E_C_N_O_ as RECNO FROM " + RetSQLName("CNB") + " CNB "
	_cQuery += "WHERE CNB.CNB_FILIAL = '" + xFilial("CNB") + "' AND "
	_cQuery += "CNB.CNB_CONTRA = '" + _cContrato + "' AND "
	_cQuery += "CNB.CNB_REVISA = '" + _cRevisa + "' AND "
	_cQuery += "CNB.CNB_DTANIV = '' AND "
	_cQuery += "CNB.D_E_L_E_T_ <> '*'"
	
	//_cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBCNB",.F.,.T.)
	
	dbSelectArea("CNB")
	While !TRBCNB->(Eof())
		dbGoTo(TRBCNB->RECNO)
		RecLock("CNB",.F.)
		CNB->CNB_DTANIV := dDataBase
		MsUnlock()
		TRBCNB->(dbSkip())
	EndDo
	TRBCNB->(dbCloseArea())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Seleciona as medicoes da revisao original            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cQuery := "SELECT CND.R_E_C_N_O_ as RECNO FROM " + RetSQLName("CND") + " CND "
	_cQuery += "WHERE CND.CND_FILIAL = '" + xFilial("CND") + "' AND "
	_cQuery += "CND.CND_CONTRA = '" + _cContrato + "' AND "
	_cQuery += "CND.CND_REVISA = '" + _cORev + "' AND "
	_cQuery += "CND.D_E_L_E_T_ <> '*'"
	
	//_cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBCND",.F.,.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Migra as medicoes para a nova revisao                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While !TRBCND->(Eof())
		CND->(dbGoTo(TRBCND->RECNO))
		RecLock("CND",.F.)
		CND->CND_REVISA := _cRevisa
		MsUnlock()
		TRBCND->(dbSkip())
	EndDo
	TRBCND->(dbCloseArea())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Seleciona os itens de medicoes da revisao original   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cQuery := "SELECT CNE.R_E_C_N_O_ as RECNO FROM " + RetSQLName("CNE") + " CNE "
	_cQuery += "WHERE CNE.CNE_FILIAL = '" + xFilial("CNE") + "' AND "
	_cQuery += "CNE.CNE_CONTRA = '" + _cContrato + "' AND "
	_cQuery += "CNE.CNE_REVISA = '" + _cORev + "' AND "
	_cQuery += "CNE.D_E_L_E_T_ <> '*'"
	
	//_cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBCNE",.F.,.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Migra os itens de medicoes para a nova revisao       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While !TRBCNE->(Eof())
		CNE->(dbGoTo(TRBCNE->RECNO))
		RecLock("CNE",.F.)
		CNE->CNE_REVISA := _cRevisa
		MsUnlock()
		TRBCNE->(dbSkip())
	EndDo
	TRBCNE->(dbCloseArea())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ajusta campo de revisao dos pedidos de compra        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_cQuery := "SELECT SC7.R_E_C_N_O_ as RECNO FROM " + RetSQLName("SC7") + " SC7 "
	_cQuery += "WHERE SC7.C7_FILIAL = '" + xFilial("SC7") + "' AND "
	_cQuery += "SC7.C7_CONTRA  = '" + _cContrato + "' AND "
	_cQuery += "SC7.C7_CONTREV = '" + _cORev + "' AND "
	_cQuery += "SC7.D_E_L_E_T_ <> '*'"
	
	//_cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRBSC7",.F.,.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Migra os itens de medicoes para a nova revisao       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	While !TRBSC7->(Eof())
		SC7->(dbGoTo(TRBSC7->RECNO))
		RecLock("SC7",.F.)
		SC7->C7_CONTREV := _cRevisa
		MsUnlock()
		TRBSC7->(dbSkip())
	EndDo
	TRBSC7->(dbCloseArea())
	
EndIf

Return(lRet)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C8E01IND	  บAutor  ณ Totvs				  บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona indice do contrato 			    			  		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                     	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C8E01IND(_dData)
Local _nI1 := 0

If Posicione("CN6",1,xFilial("CN6")+CN9->CN9_INDICE,"CN6_TIPO") == "1"//Diario
	
	dbSelectArea("CN7")
	dbSetOrder(1)
	If dbSeek(xFilial("CN7") + CN9->CN9_INDICE + DTOS(_dData))
		_nI1 := Iif(Empty(CN7_VLREAL),CN7_VLPROJ,CN7_VLREAL)
	EndIf
Else
	dbSelectArea("CN7")
	dbSetOrder(2)
	If dbSeek(xFilial("CN7") + CN9->CN9_INDICE + strzero(Month(_dData),2) + "/" + strzero(Year(_dData),4))
		_nI1 := Iif(Empty(CN7_VLREAL),CN7_VLPROJ,CN7_VLREAL)
	EndIf
EndIf

Return(_nI1)