#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} HFINAP03
//Consumindo API Lista de Clientes
@author emerson.natali
@since 01/05/2018
@version undefined
@type function
/*/

user function HFINAP03(_nType)

//CLIENTES IUGU
//lista cliente
//https://api.iugu.com/v1/customers

//busca clientes
//https://api.iugu.com/v1/customers/6437208CE1494E339A1E6CFE9419747A?api_token=e3a203c0cfaf1f396fe9d45e22b7bea4

//id
//email
//name
//cpf_cnpj

Local cUrl			:= "https://api.iugu.com/v1/customers"
Local cApi_Token	:= "api_token=e3a203c0cfaf1f396fe9d45e22b7bea4"
Local cGetParams	:= cApi_Token
Local nTimeOut		:= 200
Local aHeadStr		:= {}
Local cHeaderGet	:= ""
Local cRetorno		:= ""
Local oObjJson		:= Nil
Local aJsonFields 	:= {}
Local nlenRetJson 	:= 0
Local nRetParser 	:= 0

If _nType == 1 //processamento automatico scheduler
	RpcSetType(3)
	RpcSetEnv("99", "01")
EndIf

cRetorno	:= HttpGet( cUrl, cGetParams, nTimeOut, aHeadStr, @cHeaderGet)

oObjJson 	:= tJsonParser():New()
nlenRetJson := Len(cRetorno)
	
lRet := oObjJson:Json_Parser(cRetorno, nlenRetJson, @aJsonFields, @nRetParser)

If ( lRet == .F. )
	ConOut("##### [JSON][ERR] " + "Parser 1 com erro" + " MSG len: " + AllTrim(Str(nlenRetJson)) + " bytes lidos: " + AllTrim(Str(nRetParser)))
Else
	ConOut("[JSON] "+ "+++++ PARSER OK dia processado: ARRAY "+ AllTrim(Str(Len(aJsonFields))) + " MSG len: " + AllTrim(Str(nlenRetJson)) + " bytes lidos: " + AllTrim(Str(nRetParser)))
EndIf
ConOut("-------------------------------------------------------", "")

For _nI := 1 to Len(aJsonFields[1,2,2,2])
	acampos := {}
	For _nY := 1 to Len(aJsonFields[1,2,2,2,_nI,2]) //array com o conteudo (campos e valores)
		aadd(acampos,aJsonFields[1,2,2,2,_nI,2,_nY,2]) //valor do campo
	Next _nY
	If ValType(acampos[8]) <> 'U'
		_cCodigo := StrTran(StrTran(StrTran(acampos[8],".",""),"/",""),"-","")
		DbSelectArea("ZAA")
		DbSetOrder(1) //CODIGO CLIENTE
		If DbSeek(_cCodigo)
			RecLock("ZAA",.F.)
			ZAA->ZAA_CODIUG := acampos[1]
			ZAA->ZAA_EMAIL	:= acampos[2]
			MsUnlock()
		Else
			RecLock("ZAA",.T.)
			ZAA->ZAA_CODCLI := _cCodigo
			ZAA->ZAA_CODIUG := acampos[1]
			ZAA->ZAA_CNPJ	:= acampos[8]
			ZAA->ZAA_RAZAO	:= acampos[3]
			ZAA->ZAA_NREDUZ	:= acampos[3]
			ZAA->ZAA_END	:= acampos[17]
			ZAA->ZAA_NUMERO	:= acampos[10]
			ZAA->ZAA_BAIRRO	:= acampos[16]
			ZAA->ZAA_CIDADE	:= acampos[14]
			ZAA->ZAA_CEP	:= acampos[9]
			ZAA->ZAA_UF		:= acampos[15]
			ZAA->ZAA_COMPL	:= "" 
			ZAA->ZAA_EMAIL	:= acampos[2]
			MsUnlock()
		EndIf
	EndIf
Next _nI

lRet := .T.

If _nType == 1 //processamento automatico scheduler
	RpcClearEnv()
EndIf

return(.T.)