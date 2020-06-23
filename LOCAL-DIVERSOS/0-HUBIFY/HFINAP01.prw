#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} HFINAP01
//Consumindo API Iugu Extrato Financeiro
@author emerson.natali
@since 01/05/2018
@version undefined

	//[1,2,1,1] == "transactions"
	//[1,2,1,2] array contendo as informações
	//[1][2][1][2][1][2][1] -> ARRAY (    2) [...]
	//[1][2][1][2][1][2][1][1] -> C (    6) [amount]  //campo
	//[1][2][1][2][1][2][1][2] -> C (    10) [amount] //valor

@type function
/*/
user function HFINAP01(_nType)

Local cUrl			:= "https://api.iugu.com/v1/accounts/financial"
Local cApi_Token	:= "api_token=e3a203c0cfaf1f396fe9d45e22b7bea4"
Local _cYear		:= ""
Local _cMonth		:= ""
Local _cDay			:= ""
Local _cLimit		:= "limit=100"
Local _cStart		:= "start"
Local cGetParams	:= ""
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
	dDini := ctod("03/05/2018")
	dDfim := ctod("04/06/2018")
Else
	aPergs := {}
	aRet   := {}
	aAdd( aPergs ,{1,"Data De: "   , dDataBase  , "","","","",70, .T.})
	aAdd( aPergs ,{1,"Data Ate: "  , dDataBase  , "","","","",70, .T.})
	lRet := ParamBox( @aPergs , "Data de Processamento" , @aRet)

	If !(lRet)
		return(.F.)
	Else
		dDini := aRet[1]
		dDfim := aRet[2]
	EndIf

EndIf
nCont := 1

Do While .T.

	Sleep( 2000 )//2 segundos // é definido em milissegundos/ 1000 para o processamento por 1 segundo

	aJsonFields 	:= {}
	_cYear		:= "year=" + strzero(year(dDini),4) 	//"year=2018"
	_cMonth		:= "month="+ strzero(month(dDini),2) 	//"month=02"
	_cDay		:= "day="  + strzero(day(dDini),2) 		//"day=28"
	cGetParams	:= "" + cApi_Token + "&" + _cYear + "&" + _cMonth + "&" + _cDay + "&" + _cLimit + "&" + _cStart
	
	cRetorno	:= HttpGet( cUrl, cGetParams, nTimeOut, aHeadStr, @cHeaderGet)
	
	oObjJson 	:= tJsonParser():New()
	If ValType(cRetorno) <> 'U'
		nlenRetJson := Len(cRetorno)
	Else
		ConOut("####  Erro no Retorno")
		return(.T.)
	EndIf
	
	lRet := oObjJson:Json_Parser(cRetorno, nlenRetJson, @aJsonFields, @nRetParser)
	   
	If ( lRet == .F. )
		ConOut("##### [JSON][ERR] " + "Parser 1 com erro" + " MSG len: " + AllTrim(Str(nlenRetJson)) + " bytes lidos: " + AllTrim(Str(nRetParser)))
		ConOut("Erro a partir: " + SubStr(cRetorno, (nRetParser+1)))
	Else
		ConOut("[JSON] "+ "+++++ PARSER OK dia processado: " +DTOC(dDini) +" ARRAY "+ AllTrim(Str(Len(aJsonFields))) + " MSG len: " + AllTrim(Str(nlenRetJson)) + " bytes lidos: " + AllTrim(Str(nRetParser)))
	//	printJson(aJsonFields, "| ")
	
		For _nI := 1 to Len(aJsonFields[1,2,1,2])
			acampos := {}
			For _nY := 1 to Len(aJsonFields[1,2,1,2,_nI,2]) //array com o conteudo (campos e valores)
				aadd(acampos,aJsonFields[1,2,1,2,_nI,2,_nY,2]) //valor do campo
			Next _nY
			_lAchou := .F.
			DbSelectArea("ZAB")
			DbSetOrder(2) // (ZAB_REFER+SPACE((50-LEN(ZAB_REFER)))) + str(ZAB_AMOUNT,18,2)
			
			_cREFER := alltrim(acampos[05])+SPACE((50-LEN(alltrim(acampos[05]))))
			_cAMOUN := STR(VAL(StrTran(SUBSTR(acampos[01],3,50), "," , "." )),18,2)
			
			If DbSeek(_cREFER+_cAMOUN) //Busca o codigo da Referencia //Fatura. Sempre terá 2 registro sendo um o valor integral e o outro a taxa de 2,50
				_lAchou := .T.	
			EndIf
			IF !(_lAchou) //se não achou inclui
				RecLock("ZAB",.T.)
				ZAB->ZAB_FILIAL		:= xFilial("ZAB")
				ZAB->ZAB_AMOUNT		:= VAL(StrTran(StrTran(SUBSTR(acampos[01],3,50), "," , "." ), "." , ""))/100
				ZAB->ZAB_TYPE		:= acampos[02]
				ZAB->ZAB_DESC		:= acampos[03]
				ZAB->ZAB_DATE		:= STOD(StrTran(acampos[04],"-",""))
				ZAB->ZAB_REFER		:= acampos[05]
				ZAB->ZAB_TYPEREF	:= acampos[06]
				ZAB->ZAB_ACCOUN		:= acampos[07]
				ZAB->ZAB_TYPETR		:= acampos[08]
				ZAB->ZAB_BALANC		:= VAL(StrTran(StrTran(SUBSTR(acampos[09],3,50), "," , "." ), "." , ""))/100
				ZAB->ZAB_REFCUS		:= acampos[10]
				MsUnLock()
			EndIf
		Next _nI
	
	EndIf
	ConOut("-------------------------------------------------------", "")

	dDini := dDini + nCont

	If dDini > dDfim
		Exit
	EndIf

EndDo	 

If _nType == 1 //processamento automatico scheduler
	RpcClearEnv()
EndIf

return(.T.)

/*Static Function printJson(aJson, niv)
  VarInfo(niv, aJson)
Return .T.*/