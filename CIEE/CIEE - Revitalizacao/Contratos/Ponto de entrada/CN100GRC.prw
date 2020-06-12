#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CN100GRC
Ponto de entrada após o processamento das tabelas relacionadas ao contrato
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CN100GRC()
Local _lRet     := .T.
Local _aArea    := GetArea()
Local _lRestCot := If(SuperGetMV("MV_PCEXCOT")=="1",.T.,.F.)

If Paramixb[1] == 5 //Opção de Exclusão para Contratos em Elaboração
	If _lRestCot
		If !Empty(CN9->CN9_XCOT) //Se tiver vindo da integração com Compras
		
			DbSelectArea("SC8")
			DbSetOrder(1)
			DbGotop()
			DbSeek(xFilial("SC8")+CN9->CN9_XCOT)
			
			Do While !EOF() .and. SC8->C8_NUM == CN9->CN9_XCOT
					IF SC8->C8_XGCT == CN9->CN9_NUMERO
						RecLock("SC8",.F.)
						SC8->C8_NUMPED  := ""
						SC8->C8_ITEMPED := ""
						SC8->C8_MOTIVO  := ""
						MsUnlock()
					ENDIF
					//PcoDetLan("000052","02","MATA121",.T.)
					
					SC8->(DbSkip()) 
			EndDo
			
			//MAAlcDoc({CN9->CN9_NUMERO+CN9->CN9_REVISA,'RC',,,,,,,,,},,5)

		EndIf
	EndIf
EndIf

RestArea(_aArea)

Return(_lRet)

