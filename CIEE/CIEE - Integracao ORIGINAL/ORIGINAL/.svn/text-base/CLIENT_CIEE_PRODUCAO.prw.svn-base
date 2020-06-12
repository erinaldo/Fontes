#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

//TODO - Retirar após segunda fase do projeto, apenas para atender a integração com ambiente ORIGINAL

/* ===============================================================================
WSDL Location    http://localhost:9191/ws/CIEE.apw?WSDL
Gerado em        03/24/15 11:08:28
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _IVWOKJM ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCIEE
------------------------------------------------------------------------------- */

WSCLIENT WSCIEE

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD FSERVICE
	WSMETHOD GETBENS
	WSMETHOD GETF3

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cINMSG                    AS string
	WSDATA   cFSERVICERESULT           AS string
	WSDATA   cCCUSTO                   AS string
	WSDATA   cCCHAPA                   AS string
	WSDATA   oWSGETBENSRESULT          AS CIEE_ARRAYOFARET
	WSDATA   cCF3                      AS string
	WSDATA   cCFILPAR                  AS string
	WSDATA   oWSGETF3RESULT            AS CIEE_ARRAYOFARET

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCIEE
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20141125] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCIEE
	::oWSGETBENSRESULT   := CIEE_ARRAYOFARET():New()
	::oWSGETF3RESULT     := CIEE_ARRAYOFARET():New()
Return

WSMETHOD RESET WSCLIENT WSCIEE
	::cINMSG             := NIL 
	::cFSERVICERESULT    := NIL 
	::cCCUSTO            := NIL 
	::cCCHAPA            := NIL 
	::oWSGETBENSRESULT   := NIL 
	::cCF3               := NIL 
	::cCFILPAR           := NIL 
	::oWSGETF3RESULT     := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCIEE
Local oClone := WSCIEE():New()
	oClone:_URL          := ::_URL 
	oClone:cINMSG        := ::cINMSG
	oClone:cFSERVICERESULT := ::cFSERVICERESULT
	oClone:cCCUSTO       := ::cCCUSTO
	oClone:cCCHAPA       := ::cCCHAPA
	oClone:oWSGETBENSRESULT :=  IIF(::oWSGETBENSRESULT = NIL , NIL ,::oWSGETBENSRESULT:Clone() )
	oClone:cCF3          := ::cCF3
	oClone:cCFILPAR      := ::cCFILPAR
	oClone:oWSGETF3RESULT :=  IIF(::oWSGETF3RESULT = NIL , NIL ,::oWSGETF3RESULT:Clone() )
Return oClone

// WSDL Method FSERVICE of Service WSCIEE

WSMETHOD FSERVICE WSSEND cINMSG WSRECEIVE cFSERVICERESULT WSCLIENT WSCIEE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<FSERVICE xmlns="http://localhost:9191/">'
cSoap += WSSoapValue("INMSG", ::cINMSG, cINMSG , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</FSERVICE>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:9191/FSERVICE",; 
	"DOCUMENT","http://localhost:9191/",,"1.031217",; 
	"http://localhost:9191/CIEE.apw")

::Init()
::cFSERVICERESULT    :=  WSAdvValue( oXmlRet,"_FSERVICERESPONSE:_FSERVICERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETBENS of Service WSCIEE

WSMETHOD GETBENS WSSEND cCCUSTO,cCCHAPA WSRECEIVE oWSGETBENSRESULT WSCLIENT WSCIEE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETBENS xmlns="http://localhost:9191/">'
cSoap += WSSoapValue("CCUSTO", ::cCCUSTO, cCCUSTO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CCHAPA", ::cCCHAPA, cCCHAPA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETBENS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:9191/GETBENS",; 
	"DOCUMENT","http://localhost:9191/",,"1.031217",; 
	"http://localhost:9191/CIEE.apw")

::Init()
::oWSGETBENSRESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETBENSRESPONSE:_GETBENSRESULT","ARRAYOFARET",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GETF3 of Service WSCIEE

WSMETHOD GETF3 WSSEND cCF3,cCFILPAR WSRECEIVE oWSGETF3RESULT WSCLIENT WSCIEE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GETF3 xmlns="http://localhost:9191/">'
cSoap += WSSoapValue("CF3", ::cCF3, cCF3 , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CFILPAR", ::cCFILPAR, cCFILPAR , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</GETF3>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:9191/GETF3",; 
	"DOCUMENT","http://localhost:9191/",,"1.031217",; 
	"http://localhost:9191/CIEE.apw")

::Init()
::oWSGETF3RESULT:SoapRecv( WSAdvValue( oXmlRet,"_GETF3RESPONSE:_GETF3RESULT","ARRAYOFARET",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ARRAYOFARET

WSSTRUCT CIEE_ARRAYOFARET
	WSDATA   oWSARET                   AS CIEE_ARET OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CIEE_ARRAYOFARET
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CIEE_ARRAYOFARET
	::oWSARET              := {} // Array Of  CIEE_ARET():New()
Return

WSMETHOD CLONE WSCLIENT CIEE_ARRAYOFARET
	Local oClone := CIEE_ARRAYOFARET():NEW()
	oClone:oWSARET := NIL
	If ::oWSARET <> NIL 
		oClone:oWSARET := {}
		aEval( ::oWSARET , { |x| aadd( oClone:oWSARET , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CIEE_ARRAYOFARET
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ARET","ARET",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSARET , CIEE_ARET():New() )
			::oWSARET[len(::oWSARET)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARET

WSSTRUCT CIEE_ARET
	WSDATA   cCMSG                     AS string
	WSDATA   cCXML                     AS string
	WSDATA   lLRET                     AS boolean
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CIEE_ARET
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CIEE_ARET
Return

WSMETHOD CLONE WSCLIENT CIEE_ARET
	Local oClone := CIEE_ARET():NEW()
	oClone:cCMSG                := ::cCMSG
	oClone:cCXML                := ::cCXML
	oClone:lLRET                := ::lLRET
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CIEE_ARET
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCMSG              :=  WSAdvValue( oResponse,"_CMSG","string",NIL,"Property cCMSG as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCXML              :=  WSAdvValue( oResponse,"_CXML","string",NIL,"Property cCXML as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::lLRET              :=  WSAdvValue( oResponse,"_LRET","boolean",NIL,"Property lLRET as s:boolean on SOAP Response not found.",NIL,"L",NIL,NIL) 
Return


