#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'Topconn.ch'
/*/{Protheus.doc} HFINAP02
//Consumindo API Consulta Faturas
@author emerson.natali
@since 01/05/2018
@version undefined
@type function
/*/
user function HFINAP02()

//consulta faturas
//ID Fatura - campo ZAB_REFER (sem os espaços em branco)
//api_token
//https://api.iugu.com/v1/invoices/14575557D2D240C2BC244E64EC1F8D81?api_token=e3a203c0cfaf1f396fe9d45e22b7bea4

Local cUrl			:= "https://api.iugu.com/v1/invoices/"
Local cApi_Token	:= "api_token=e3a203c0cfaf1f396fe9d45e22b7bea4"
Local _cFatura		:= ""
Local cGetParams	:= ""
Local nTimeOut		:= 120
Local aHeadStr		:= {}
Local cHeaderGet	:= ""
Local cRetorno		:= ""
Local oObjJson		:= Nil
Local aJsonFields 	:= {}
Local nlenRetJson 	:= 0
Local nRetParser 	:= 0
Local cArqTrab		:= GetNextAlias()

BeginSQL Alias cArqTrab
	SELECT ZAB.ZAB_REFER, ZAB.R_E_C_N_O_ as ZAB_RECNO
	FROM %Table:ZAB% ZAB
	WHERE ZAB_TYPE = 'credit    '
	AND ZAB.ZAB_CODIUG = ''
	AND ZAB.%NotDel%
EndSQL
	
(cArqTrab)->(dbSelectArea((cArqTrab)))                    
(cArqTrab)->(dbGoTop())                               	
While (cArqTrab)->(!Eof())        		

	Sleep( 2000 )//2 segundos // é definido em milissegundos/ 1000 para o processamento por 1 segundo

	aJsonFields := {}
	cUrl		:= "https://api.iugu.com/v1/invoices/"
	_cFatura	:= alltrim((cArqTrab)->(ZAB_REFER))
	cUrl		+= _cFatura
	cGetParams	:= cApi_Token
	
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
		ConOut("[JSON] +++++ PARSER OK FATURA: "+ _cFatura )	
		//AJSONFIELDS[1][2][28][2]	"E86C0629F5274570BB6AC4916D927AB2"
		If Len(AJSONFIELDS[1]) > 1 //na posição 2 é onde tem o conteudo

			_aCampo := AJSONFIELDS[1,2]
			For _nY := 1 to len(_aCampo)
				If _aCampo[_nY,1] == "customer_id" .and. valtype(_aCampo[_nY,2]) <> "U"
					DbSelectArea("ZAB")
					DbGoto((cArqTrab)->(ZAB_RECNO))
					RecLock("ZAB",.F.)
					ZAB->ZAB_CODIUG := _aCampo[_nY,2] //AJSONFIELDS[1][2][28][2]
					MsUnLock()
					Exit
				ElseIf _aCampo[_nY,1] == "variables"
					_aCampo := _aCampo[_nY,2]
					For _nI := 1 to len(_aCampo)
						If _aCampo[_nI,2,2,2] == "payer.cpf_cnpj" .and. valtype(_aCampo[_nI,2,3,2]) <> "U"
							_cCampo := _aCampo[_nI,2,3,2]
							_cCampo := StrTran(_cCampo, "." , "" )
							_cCampo := StrTran(_cCampo, "/" , "" )
							_cCampo := StrTran(_cCampo, "-" , "" )
		
							DbSelectArea("ZAA")
							DbSetOrder(1)
							If DbSeek(_cCampo)
								_cCodIugu := ZAA->ZAA_CODIUG
								DbSelectArea("ZAB")
								DbGoto((cArqTrab)->(ZAB_RECNO))
								RecLock("ZAB",.F.)
								ZAB->ZAB_CODIUG := _cCodIugu
								MsUnLock()
							EndIf
						ElseIf _aCampo[_nI,2,2,2] == "payer.name" .and. valtype(_aCampo[_nI,2,3,2]) <> "U"							
							_cCampo := _aCampo[_nI,2,3,2] //AJSONFIELDS[1,2,57,2][_nI][2,3,2]
	
							DbSelectArea("ZAA")
							DbSetOrder(2)
							If DbSeek(_cCampo)
								_cCodIugu := ZAA->ZAA_CODIUG
								DbSelectArea("ZAB")
								DbGoto((cArqTrab)->(ZAB_RECNO))
								RecLock("ZAB",.F.)
								ZAB->ZAB_CODIUG := _cCodIugu
								MsUnLock()
							EndIf
						EndIf
					Next _nI
					Exit
				EndIf
			Next _nY
		EndIf
	EndIf

	ConOut("-------------------------------------------------------", "")

	(cArqTrab)->(dbSelectArea((cArqTrab))) 
	(cArqTrab)->(dbSkip())

EndDo
	
(cArqTrab)->(dbCloseArea())
	
return
