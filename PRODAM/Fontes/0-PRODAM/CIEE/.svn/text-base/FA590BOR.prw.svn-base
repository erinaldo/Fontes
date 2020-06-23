#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FA590BOR
Ponto de Entrada para validacao sobre a selecao do bordero para manutencao
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function FA590BOR()
Local cNumBord	:= PARAMIXB[1]
Local cCarteira	:= PARAMIXB[2]
Local lRet			:= .T.

IF !empty(cNumBord) .and. cCarteira == "P"
	
	// Não permite manutenção de bordero em processo de aprovação
	dbSelectArea('SE2')
	dbSetORder(15)
	If dbSeek(xFilial('SE2')+cNumBord)
		If SE2->E2_XSTSAPV$"0,1"  
			MsgAlert('Borderô em processo de aprovação de alçadas.')
			lRet:=.F.            
		EndIf
	endIf

ENDIF

Return lRet

