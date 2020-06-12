#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
//-----------------------------------------------------------------------
/*/{Protheus.doc} F940PAR1()

Ponto de entrada na rotina de Cálculo do AVP-CR, permite adicionar mais perguntas no Wizard
@param		Paramixb[1] -  	Array com as perguntas atuais
@return		aRet		= 	Array com as perguntas alteradas
@author 	Zema
@since 		14/08/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

USER FUNCTION F940PAR1
Local aRet := ACLONE(PARAMIXB[1])
aAdd(aRet,{ 1,	"Contrato"		,Space(TamSx3('E1_XCONTRA')[1])	,"","","","",100,.F.})  
aAdd(aRet,{ 1,	"Empreendimento",Space(TamSx3('E1_XEMPRE')[1])	,"","","","",100,.F.})  
Return(aRet)