#Include 'Protheus.ch'
#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FA050DEL
Ponto de entrada executado após a confirmação da exclusão do título
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function FA050DEL()
Local _lRet 		:= .T.
Private aExLcto	:= {}
Private xCT2Lote	:= ""

IF cEmpAnt == '01' 	// Somente CIEE-SP tem o novo controle das FLs
	If Alltrim(FunName()) <> "CFINA81"
		If AllTrim(SE2->E2_TIPO)=="FL"
			MsgBox("Não é permitida a exclusão do tipo FL pela rotina de Contas a Pagar!!! Utilize a rotina adequada!!!",OemToAnsi("Atenção"))	
			_lRet := .F.
			Return(_lRet)
		EndIf
	EndIf
EndIf

MsgRun("Processando Exclusao do Titulo e Lancamentos Contabeis!!!",,{|| _lRet:= U_CFINE14() })

Return(_lRet)

