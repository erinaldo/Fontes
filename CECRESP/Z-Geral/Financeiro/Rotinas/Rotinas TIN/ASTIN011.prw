#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
//#INCLUDE "ACADEF.CH"  
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWADAPTEREAI.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN011
Atualiza o valor do titulo a receber conforme valor no TIN(RM) via EAI
@return	Nenhum			
@author	Carlos Gorgulho
@since		01/02/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN011()  //F0101001()

Local aRetMsg	:= {}
Local lRet		:= .T.
	
If (AllTrim(SE1->E1_ORIGEM) == "FINI055" .And. lRet .And. SE1->E1_SITUACA == "0") .Or.;
	(AllTrim(SE1->E1_ORIGEM) $ 'L|S|T' .Or. SE1->E1_IDLAN > 0) .And. Empty(SE1->E1_NUMBOR) .And.;
	Empty(SE1->E1_BAIXA) .And. ( SE1->E1_TIPO $ MVABATIM .And. SE1->E1_SALDO > 0 )

	If FWHasEAI("FINI070A",.T.,,.T.) 
		SE1->(msUnlock()) 
	
		SetRotInteg('FINI070A')
		MsgRun ( "Atualizando título"+" "+rTrim(SE1->E1_NUM)+ " " +"a valor presente...","Valor Presente",{||aRetMsg:=FinI070A()} )
		SetRotInteg('FINA070')
		RecLock("SE1",.F.)
		If ValType(aRetMsg) == "A" .And. Len(aRetMsg) > 0  
			If ValType(aRetMSg[1]) <> "U" .and. !aRetMsg[1]
				If ValType (aRetMsg[2]) <> "U" .and. aRetMsg[2] <> Nil .and. !Empty (aRetMsg[2])
					MsgAlert("Foi realizada uma tentativa de atualização do título, e foi retornada a seguinte mensagem:"+ CRLF+aRetMsg[2])//
				Else
					MsgAlert("Ocorreu um erro inesperado na tentativa de atualização do título "+" " + Rtrim(SE1->E1_NUM)+". "+"Verifique as configurações da integração  e tente novamente.")
				Endif
				lRet := .F.
			ElseIF Valtype (aRetMSg[1]) =="U"
				MsgAlert("Ocorreu um erro inesperado na tentativa de atualização do título "+" " + Rtrim(SE1->E1_NUM)+". "+"Verifique as configurações da integração  e tente novamente.")
				lRet := .F.
			Endif	
		EndIf	
	Else
		lRet := .F.
		MsgAlert("Para realizar as baixas de integrações como TIN, é necessário cadastrar o adapter da rotina FINI070A - UPDATECONTRACTPARCEL.")
	Endif
Else 
	lRet := .F.
	MsgAlert("Atualização permitida somente para titulos de origem do TIN(RM), não esteja em bordero e não seja do tipo aglutinador.")
EndIf

Return(lRet)