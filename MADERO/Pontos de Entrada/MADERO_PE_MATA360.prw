#include 'protheus.ch'
/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Customização                                            !
+------------------+---------------------------------------------------------+
!Modulo            ! FIN                                                     !
+------------------+---------------------------------------------------------+
!Nome              ! MATA360                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de entrada da rotina de Cadastro de Condições de  !
!                  ! pagamento                                               !
+------------------+---------------------------------------------------------+
!Autor             !                                                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   !                                                         !
+------------------+---------------------------------------------------------+
*/
User Function MATA360()
Local oModel 
Local cIdPonto
Local cIdModel
Local xRetorno  := .T.	
Local aAreaSE4  := GetArea()  
	

	If ! Empty(ParamIXB)

		oModel   := ParamIXB[1]
		cIdPonto := ParamIXB[2]
		cIdModel := ParamIXB[3]

		do case

			case cIdPonto == "MODELCOMMITTTS"
				If oModel:GetOperation() == 3 .Or. oModel:GetOperation() == 4 .Or. oModel:GetOperation() == 5
						ATU_Z10(oModel)
				EndIf
			

			case cIdPonto == "BUTTONBAR"

				xRetorno := {}

		endcase

	EndIF            
	
	RestArea(aAreaSE4)	

return xRetorno

static function ATU_Z10(oModel)
Local aAreaSE4  := GetArea()  
Local lOpcao	:= .T.
Local lEnvia    := .T.   


	If oModel:GetOperation() == 3 .Or. oModel:GetOperation() == 4

		If !Empty(oModel:GetValue('SE4MASTER','E4_XNATVDA'))
			If !Empty(oModel:GetValue('SE4MASTER','E4_CODEXT'))
				dbSelectArea("Z10")
				Z10->(dbSetOrder(1))
				If Z10->(dbSeek(xFilial("Z10") + oModel:GetValue('SE4MASTER','E4_CODIGO')))
					lOpcao := .F.
				EndIf
				Reclock("Z10",lOpcao)
					Z10->Z10_XFILI		:= cFilAnt
					Z10->Z10_CODIGO		:= oModel:GetValue('SE4MASTER','E4_CODIGO')  
					Z10->Z10_DESC       := oModel:GetValue('SE4MASTER','E4_DESCRI')
					Z10->Z10_XSTINT		:= "P"
					Z10->Z10_CODEXT		:= oModel:GetValue('SE4MASTER','E4_CODEXT')
					Z10->Z10_XEXC		:= If(oModel:GetValue('SE4MASTER','E4_MSBLQL') <> "1","N","S")
					Z10->Z10_XHINT		:= Time()
					Z10->Z10_XDINT		:= Date()
				Z10->( MsUnlock() )
			Else
				dbSelectArea("Z10")
				Z10->(dbSetOrder(1))
				If Z10->(dbSeek(xFilial("Z10") + oModel:GetValue('SE4MASTER','E4_CODIGO')))
					lOpcao := .F.
				EndIf
				Reclock("Z10",lOpcao)
					Z10->Z10_XFILI		:= cFilAnt
					Z10->Z10_CODIGO		:= oModel:GetValue('SE4MASTER','E4_CODIGO')  
					Z10->Z10_DESC       := oModel:GetValue('SE4MASTER','E4_DESCRI')
					Z10->Z10_XSTINT		:= "P"
					Z10->Z10_XEXC		:= If(oModel:GetValue('SE4MASTER','E4_MSBLQL') <> "1","N","S")
				Z10->( MsUnlock() )
			EndIf
		EndIf
	ElseIf oModel:GetOperation() == 5
		//Marca Z10 como deletado
		//******************************************
		If !lOpcao .and. lEnvia
			Reclock("Z10",lOpcao)
			Z10->Z10_XSTINT		:= "P"
			Z10->Z10_XEXC		:= "S"
			Z10->(MsUnlock())	
		EndIf	
	EndIf

RestArea(aAreaSE4)
return