#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "RestFul.CH"

/*/{Protheus.doc} EREST_01
Ensinando Rest em ADVPL
@author Victor Andrade
@since 13/04/2017
@version undefined
@type function
/*/
//User Function EREST01()	
//Return
/*/{Protheus.doc} PRODUTOS
Defini��o da estrutura do webservice
@author Victor Andrade
@since 13/04/2017
@type class
/*/
WSRESTFUL PRODUTOS DESCRIPTION "Servi�o REST para manipula��o de Produtos"
WSDATA CODPRODUTO As String //String que vamos receber via URL
 
WSMETHOD GET DESCRIPTION "Retorna o produto informado na URL" WSSYNTAX "/PRODUTOS || /PRODUTOS/{CODPRODUTO}" //Disponibilizamos um m�todo do tipo GET
 
END WSRESTFUL
/*/{Protheus.doc} GET
Processa as informa��es e retorna o json
@author Victor Andrade
@since 13/04/2017
@version undefined
@param oSelf, object, Objeto contendo dados da requisi��o efetuada pelo cliente, tais como:
   - Par�metros querystring (par�metros informado via URL)
   - Objeto JSON caso o requisi��o seja efetuada via Request Post
   - Header da requisi��o
   - entre outras ...
@type Method
/*/
WSMETHOD GET WSRECEIVE CODPRODUTO WSSERVICE PRODUTOS
//--> Recuperamos o produto informado via URL 
//--> Podemos fazer dessa forma ou utilizando o atributo ::aUrlParms, que � um array com os par�metros recebidos via URL (QueryString)
Local cCodProd := Self:CODPRODUTO
Local aArea		:= GetArea()
Local oObjProd	:= Nil
Local cStatus	:= ""
Local cJson		:= ""
// define o tipo de retorno do m�todo
::SetContentType("application/json")
DbSelectArea("SB1")
SB1->( DbSetOrder(1) )
If SB1->( DbSeek( xFilial("SB1") + cCodProd ) )
	cStatus  := Iif( SB1->B1_MSBLQL == "1", "Sim", "Nao" )
	oObjProd := Produtos():New(SB1->B1_DESC, SB1->B1_UM, cStatus) //Cria um objeto da classe produtos para fazer a serializa��o na fun��o FWJSONSerialize
EndIf
// --> Transforma o objeto de produtos em uma string json
cJson := FWJsonSerialize(oObjProd)
// --> Envia o JSON Gerado para a aplica��o Client
::SetResponse(cJson)
RestArea(aArea)
Return(.T.)