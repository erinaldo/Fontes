#include 'protheus.ch'



/*/{Protheus.doc} FATA510
Ponto de entrada para rotina de Unidade de Negocio

#1 Atualiza ADK_XSTINT como P=Pendente na Inclusão e Alteração

@author Rafael Ricardo Vieceli
@since 02/03/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function FATA510()
Local oModel  //ParamIXB[1]
Local cIdPonto //ParamIXB[2]
Local cIdModel //ParamIXB[3]
Local xRetorno := .T.

	IF ! Empty(ParamIXB)

		oModel   := ParamIXB[1]
		cIdPonto := ParamIXB[2]
		cIdModel := ParamIXB[3]

		do case

			//na validação total do formulario
			case cIdPonto == "FORMPOS"

				//validação dos itens
				IF cIdModel == 'ADKMASTER'
					
					// -> Processo de integração com o Teknisa
					//--------------------------------------------------------
					If oModel:GetStruct():GetFieldPos("ADK_XSTINT") != 0
						oModel:LoadValue('ADK_XSTINT', 'P')
					EndIf	
					//--------------------------------------------------------
				EndIF

			case cIdPonto == "BUTTONBAR"

				xRetorno := {}

		endcase

	EndIF

return xRetorno