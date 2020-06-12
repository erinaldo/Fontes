#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "TOPCONN.CH" 

/*/{Protheus.doc} GetSx5Info
//TODO Declaração do WebService GetArmEst
@author Paulo Gabriel F.Silva
@since 09/08/2018
@version 1.0
/*/

WSRESTFUL GetArmEst DESCRIPTION "Madero - Locais de Armazém e Estoque - FLUIG"

	WSMETHOD POST DESCRIPTION "Lista de Locais de Armazém e Estoque para integração FLUIG" WSSYNTAX "/GetArmEst"

END WSRESTFUL

/*/{Protheus.doc} POST
//TODO Declaração do Metodo GetArmEst
@author Paulo Gabriel F.Silva
@since 09/08/2018
@version 1.0
/*/
WSMETHOD POST WSRECEIVE cdempresa, cdfilial WSSERVICE GetArmEst

	Local cResponse	:= ""
	Local idproduto := ""
	Local cBody
	Local oObj
	Local cdempresa := ""
	Local cdfilial := ""
	
	::SetContentType("application/json")
	
	cBody := ::GetContent()


	If FWJsonDeserialize(cBody,@oObj)
	cdempresa := cValtoChar(oObj:cdempresa)
	cdfilial := cValtoChar(oObj:cdfilial) 
	
		If cdempresa == "" .Or. cdfilial == ""
			cResponse := "Error"		
			SetRestFault(600, "Parametros Incorretos")
		Else
			cResponse := WSFLUIG007(cdempresa, cdfilial)
		EndIf
	
	Else
	
		cResponse := "Error"		
		SetRestFault(600, "Parametros Incorretos")
	
	EndIf
	
	If cResponse == "Error"
		Return .F.
	EndIf
	

	::SetResponse(cResponse)
Return .T.

/*/{Protheus.doc} makeJson
//TODO Metodo para gerar JSON com lista de Armazéns e estoque.
@author Paulo Gabriel F.Silva
@since 09/08/2018
@version 1.0
@return cJson, Caracter, JSON de retorno do WS
@param cAlQry, caracter, Alias com os dados a enviar
/*/
Static Function makeJson(cAlQry)

	Local cJson 	:= ""
	
	cJson += 	'{"ArmEst":[' //Inicia objeto Json.
	
	While !(cAlQry)->( Eof() )
	
			cJson +=	'{'
			cJson +=	'"NNR_CODIGO":"'+ ALLTRIM((cAlQry)->NNR_CODIGO) +'",'
			cJson +=	'"NNR_DESCRI":"'+ ALLTRIM((cAlQry)->NNR_DESCRI) +'"'
			cJson +=	'},'
			
			(cAlQry)->(DbSkip())
	
	End
	cJson := LEFT(cJson, (LEN(cJson)-1))
	cJson +=	']}' // Finaliza objeto Json

Return cJson

/*/{Protheus.doc} WSFLUIG007
//TODO Função para executar WS GetArmEst
@author Paulo Gabriel F. e Silva
@since 09/08/2018
@version 1.0
@return cJson, Caracter, JSON de retorno
/*/
Static Function WSFLUIG007(cdempresa, cdfilial)
	Local cJson := ""
	Local nPos := 1
	Local Filial := ""
	Local SM0_aux := ""
	Local lCont := .T.
	Local cQuery := ""
	Local cAlQry	:= ""
	
	
	OpenSM0()
	DBSelectArea("SM0")
	SM0->(DBSetOrder(1))
	If SM0->(MSSeek(cdempresa+cdfilial))
		//RPCCLEARENV()
		RPCSetType(3)
		RPCSetEnv(cdempresa, cdfilial, Nil, Nil, Nil, GetEnvServer())
		nModulo := 02
	Else
		cJson := "Error"
		SetRestFault(602, "Informações não encontradas.")
		Return cJson
	EndIf

	If Select("QRY") > 0
		dbSelectArea("QRY")
		dbCloseArea()
	EndIf
	
	/*
	{
	"cdempresa":"01",
	"cdfilial":"01GDAD0001"
	}
	*/
	
		cQuery := "	SELECT NNR_CODIGO, NNR_DESCRI " + CRLF
		cQuery += "	FROM " + RetSqlName("NNR") + CRLF
		cQuery += "	WHERE " + CRLF  
		cQuery += "	NNR_FILIAL = '"+cdfilial+"' AND " + CRLF  
		cQuery += "	D_E_L_E_T_ = ' ' " + CRLF
		
		cQuery := ChangeQuery(cQuery)
		cAlQry := MPSysOpenQuery(cQuery)
	
		If (cAlQry)->(Eof())
			cAux := "Nao encontrado grupos de produtos. [BM_GRUPO > 500]"
			lCont := .F.
		EndIf
	
		If lCont
			cJson := MakeJson(cAlQry)
		Else	
			cJson := "Error"
			SetRestFault(602, "Informações não encontradas.")
		EndIf
	
	(cAlQry)->(dbCloseArea())

Return cJson
