#include "Protheus.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MTALCFIM
Ponto de entrada após liberação de alçada SCR
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MTALCFIM()
Local lLib 	:= .T.
Local lTodos	:= .T.
Local aArea	:= GetArea()
Local aDocto	:= ParamIxb[1]
Local nOper	:= ParamIxb[3]
Local cDocto	:= aDocto[1]
Local cTipoDoc:= aDocto[2]
Local aEnvRet	:= {} 

cDocto := cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))

dbSelectArea("SCR")
dbSetOrder(1)
dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
                                                                                                               
//------------------------------------------------------------------
//-- Liberação ou Bloqueio de Borderô de Pagamentos
//------------------------------------------------------------------
If (nOper==4 .Or. nOper==6) .And. cTipoDoc=='BP' 
                                            
	//-- Variavel cDocto chega com '_1' ou '_2' aqui (aprovação inicial ou do Procurador)
	cNumBor:=PadR(cDocto,TamSx3('EA_NUMBOR')[1])
    cIdRet:=Substr(cDocto,Len(cNumBor)+1,2)//-- Pega '_1' ou '_2'
    If cIdRet=='_1'
		nOpc:=2//Retorno de Aprovação/Rejeic. Inicial
    Else
	    nOpc:=3//Retorno de aprovação/Rejeic. de Procurador
    EndIF
    
	While !Eof() .And. xFilial("SCR")+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
		Aadd(aEnvRet,{CR_USER,CR_OBS})
		If CR_STATUS != "03" .And. CR_STATUS != "05"
			lLib := .F.
		EndIf
		If CR_STATUS <> "04"//Bloqueado
			lTodos:=.F.
		EndIF
		dbSkip()
	EndDo                                  
	
	// Status SE2:
	// 0-Gerado Bordero
	// 1-Enviado para aprovação inicial
	// 2-Aprovado inicial
	// 3-Reprovado inicial
	// 4-Enviado para aprovação de PROCURADOR
	// 5-Aprovado pelo Procurador
	// 6-Reprovado pelo Procurador

		
	//-- Todos liberados - Aprova o Borderô
	If lLib

		cQuery:=" Update "+RetSqlName('SE2')+" Set E2_XSTSAPV='"+Iif(nOpc==2,'2','5')+"' "
		cQuery+=" Where E2_FILIAL='"+xFilial('SE2')+"' AND E2_NUMBOR='"+cNumBor+"' AND D_E_L_E_T_=''"
		TcSqlExec(cQuery)	
	
		For nX:=1 tO Len(aEnvRet)
			//Penultimo Parametro <> 1
			u_Tes06Prc(nOpc,cFilAnt,cDocto,aEnvRet[nX,1],,,2,aEnvRet[nX,2])
		Next nX   
		
		//Avisa o usuário que o processo de alçada inicial finalizou
		If nOpc==2 
			cMsg:='Borderô liberado pelos Aprovadores.'
		Else                                           
			cMsg:='Borderô liberado pelos Procuradores.'
		EndIF
		dbSelectarea("SE2")
		dbSetOrder(15)//Filial+Borderô
		dbSeek(xFilial('SE2')+cNumBor)
		u_Tes06Prc(nOpc,cFilAnt,cDocto,SE2->E2_XSOLAPV,,,2,cMsg)

	EndIF

	//-- Entra aqui quando todos os status são 04 - Então bloqueia o Bordero
	If lTodos                        
	
		cQuery:=" Update "+RetSqlName('SE2')+" Set E2_XSTSAPV='"+Iif(nOpc==2,'3','6')+"' "
		cQuery+=" Where E2_FILIAL='"+xFilial('SE2')+"' AND E2_NUMBOR='"+cNumBor+"' AND D_E_L_E_T_=''"
		TcSqlExec(cQuery)	
	
		//Retorno Rejeição           
		For nX:=1 tO Len(aEnvRet)
			//Penultimo Parametro = 1
			u_Tes06Prc(nOpc,cFilAnt,cDocto,aEnvRet[nX,1],,,1,aEnvRet[nX,2])
		Next nX
		
		//Avisa o usuário que o processo de alçada inicial finalizou
		If nOpc==2 
			cMsg:='Borderô não liberado pelos Aprovadores.'
		Else                                           
			cMsg:='Borderô não liberado pelos Procuradores.'
		EndIF
		dbSelectarea("SE2")
		dbSetOrder(15)//Filial+Borderô
		dbSeek(xFilial('SE2')+cNumBor)
		u_Tes06Prc(nOpc,cFilAnt,cDocto,SE2->E2_XSOLAPV,,,1,cMsg)
						
	EndIF

EndIf

RestArea(aArea)
Return nil