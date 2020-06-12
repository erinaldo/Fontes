#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CFINA37
Cadastro Configuracao CNAB
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CFINA37()
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "SZL"

dbSelectArea("SZL")
dbSetOrder(1)

AxCadastro(cString,"Cadastro Configuracao CNAB",cVldExc,"u_CFIN37VL()")
Return

/*/{Protheus.doc} CFIN37VL
//Validacao para não permitir cadastrar mais de 1 registro para o mesmo banco quando o tipo for Folha de Pagamento
@author emerson.natali
@since 02/08/2017
@version undefined

@type function
/*/
User Function CFIN37VL()

Local _lRet 	:= .T.
Local _cArqTrab := "" //Arquivo de Trabalho - query

If INCLUI
	_cArqTrab:= GetNextAlias()
	
	BeginSQL Alias _cArqTrab
		SELECT * 
		FROM %Table:SZL% SZL 
		WHERE SZL.%NotDel% 
		AND SZL.ZL_BANCO = %Exp:M->ZL_BANCO%
		AND SZL.ZL_TIPO = %Exp:'5'%
	EndSQL
	
	If !((_cArqTrab)->(EOF()))
		msgalert("Ja existe um registro de configuração CNAB cadastrado para esse Banco", "JAEXISTE")
		
		_lRet := .F.
	
	EndIf
EndIf


Return(_lRet)