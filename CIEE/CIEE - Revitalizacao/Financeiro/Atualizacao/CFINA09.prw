#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CFINA09
Cadastro de codigo de bancos
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CFINA09()
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private cString := "SZ1"
dbSelectArea("SZ1")
dbSetOrder(1)

AxCadastro(cString, "Cadastro de código de bancos", cVldAlt, cVldExc)

Return