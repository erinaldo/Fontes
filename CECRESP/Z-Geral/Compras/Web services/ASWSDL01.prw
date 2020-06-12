#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://aguassantatst.fluig.com/webdesk/ECMColleagueReplacementService?wsdl
Gerado em        06/09/16 10:32:27
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _FXNTVWR ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSECMColleagueReplacementServiceService
------------------------------------------------------------------------------- */

WSCLIENT WSECMColleagueReplacementServiceService

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD updateColleagueReplacement
	WSMETHOD deleteColleagueReplacement
	WSMETHOD getReplacementsOfUser
	WSMETHOD getValidReplacement
	WSMETHOD getValidReplacementsOfUser
	WSMETHOD getColleagueReplacement
	WSMETHOD createColleagueReplacement
	WSMETHOD getValidReplacedUsers

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cusername                 AS string
	WSDATA   cpassword                 AS string
	WSDATA   ncompanyId                AS int
	WSDATA   oWSupdateColleagueReplacementcolleagueReplacement AS ECMColleagueReplacementServiceService_colleagueReplacementDto
	WSDATA   cresult                   AS string
	WSDATA   oWSgetReplacementsOfUserresult AS ECMColleagueReplacementServiceService_colleagueReplacementDtoArray
	WSDATA   oWSgetValidReplacementresult AS ECMColleagueReplacementServiceService_colleagueReplacementDto
	WSDATA   oWSgetValidReplacementsOfUserresult AS ECMColleagueReplacementServiceService_colleagueReplacementDtoArray
	WSDATA   oWSgetColleagueReplacementresult AS ECMColleagueReplacementServiceService_colleagueReplacementDto
	WSDATA   oWScreateColleagueReplacementcolleagueReplacement AS ECMColleagueReplacementServiceService_colleagueReplacementDto
	WSDATA   oWSgetValidReplacedUsersresult AS ECMColleagueReplacementServiceService_colleagueReplacementDtoArray

	//-----------------------------------------------------------------------
	// Cazarini - Criado manualmente pois o TDS WSDL não incluiu:
	//-----------------------------------------------------------------------
	WSDATA   ccolleagueId               AS string
	WSDATA   creplacementId             AS string
	//-----------------------------------------------------------------------
	// Cazarini - Até aqui
	//-----------------------------------------------------------------------

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSECMColleagueReplacementServiceService
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160405 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSECMColleagueReplacementServiceService
	::oWSupdateColleagueReplacementcolleagueReplacement := ECMColleagueReplacementServiceService_COLLEAGUEREPLACEMENTDTO():New()
	::oWSgetReplacementsOfUserresult := ECMColleagueReplacementServiceService_COLLEAGUEREPLACEMENTDTOARRAY():New()
	::oWSgetValidReplacementresult := ECMColleagueReplacementServiceService_COLLEAGUEREPLACEMENTDTO():New()
	::oWSgetValidReplacementsOfUserresult := ECMColleagueReplacementServiceService_COLLEAGUEREPLACEMENTDTOARRAY():New()
	::oWSgetColleagueReplacementresult := ECMColleagueReplacementServiceService_COLLEAGUEREPLACEMENTDTO():New()
	::oWScreateColleagueReplacementcolleagueReplacement := ECMColleagueReplacementServiceService_COLLEAGUEREPLACEMENTDTO():New()
	::oWSgetValidReplacedUsersresult := ECMColleagueReplacementServiceService_COLLEAGUEREPLACEMENTDTOARRAY():New()
Return

WSMETHOD RESET WSCLIENT WSECMColleagueReplacementServiceService
	::cusername          := NIL 
	::cpassword          := NIL 
	::ncompanyId         := NIL 
	::oWSupdateColleagueReplacementcolleagueReplacement := NIL 
	::cresult            := NIL 
	::oWSgetReplacementsOfUserresult := NIL 
	::oWSgetValidReplacementresult := NIL 
	::oWSgetValidReplacementsOfUserresult := NIL 
	::oWSgetColleagueReplacementresult := NIL 
	::oWScreateColleagueReplacementcolleagueReplacement := NIL 
	::oWSgetValidReplacedUsersresult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSECMColleagueReplacementServiceService
Local oClone := WSECMColleagueReplacementServiceService():New()
	oClone:_URL          := ::_URL 
	oClone:cusername     := ::cusername
	oClone:cpassword     := ::cpassword
	oClone:ncompanyId    := ::ncompanyId
	oClone:oWSupdateColleagueReplacementcolleagueReplacement :=  IIF(::oWSupdateColleagueReplacementcolleagueReplacement = NIL , NIL ,::oWSupdateColleagueReplacementcolleagueReplacement:Clone() )
	oClone:cresult       := ::cresult
	oClone:oWSgetReplacementsOfUserresult :=  IIF(::oWSgetReplacementsOfUserresult = NIL , NIL ,::oWSgetReplacementsOfUserresult:Clone() )
	oClone:oWSgetValidReplacementresult :=  IIF(::oWSgetValidReplacementresult = NIL , NIL ,::oWSgetValidReplacementresult:Clone() )
	oClone:oWSgetValidReplacementsOfUserresult :=  IIF(::oWSgetValidReplacementsOfUserresult = NIL , NIL ,::oWSgetValidReplacementsOfUserresult:Clone() )
	oClone:oWSgetColleagueReplacementresult :=  IIF(::oWSgetColleagueReplacementresult = NIL , NIL ,::oWSgetColleagueReplacementresult:Clone() )
	oClone:oWScreateColleagueReplacementcolleagueReplacement :=  IIF(::oWScreateColleagueReplacementcolleagueReplacement = NIL , NIL ,::oWScreateColleagueReplacementcolleagueReplacement:Clone() )
	oClone:oWSgetValidReplacedUsersresult :=  IIF(::oWSgetValidReplacedUsersresult = NIL , NIL ,::oWSgetValidReplacedUsersresult:Clone() )
Return oClone

// WSDL Method updateColleagueReplacement of Service WSECMColleagueReplacementServiceService

WSMETHOD updateColleagueReplacement WSSEND cusername,cpassword,ncompanyId,oWSupdateColleagueReplacementcolleagueReplacement WSRECEIVE cresult WSCLIENT WSECMColleagueReplacementServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:updateColleagueReplacement xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("colleagueReplacement", ::oWSupdateColleagueReplacementcolleagueReplacement, oWSupdateColleagueReplacementcolleagueReplacement , "colleagueReplacementDto", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:updateColleagueReplacement>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"updateColleagueReplacement",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	SuperGetMv("AS_FLUWSCR",.T.,"http://aguassantatst.fluig.com/webdesk/ECMColleagueReplacementService"))

::Init()
::cresult            :=  WSAdvValue( oXmlRet,"_RESULT","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method deleteColleagueReplacement of Service WSECMColleagueReplacementServiceService

WSMETHOD deleteColleagueReplacement WSSEND cusername,cpassword,ncompanyId,ccolleagueId,creplacementId WSRECEIVE cresult WSCLIENT WSECMColleagueReplacementServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:deleteColleagueReplacement xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ccolleagueId , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("replacementId", ::creplacementId, creplacementId , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:deleteColleagueReplacement>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"deleteColleagueReplacement",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	SuperGetMv("AS_FLUWSCR",.T.,"http://aguassantatst.fluig.com/webdesk/ECMColleagueReplacementService"))

::Init()
::cresult            :=  WSAdvValue( oXmlRet,"_RESULT","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getReplacementsOfUser of Service WSECMColleagueReplacementServiceService

WSMETHOD getReplacementsOfUser WSSEND cusername,cpassword,ncompanyId,ccolleagueId WSRECEIVE oWSgetReplacementsOfUserresult WSCLIENT WSECMColleagueReplacementServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getReplacementsOfUser xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ccolleagueId , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getReplacementsOfUser>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getReplacementsOfUser",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	SuperGetMv("AS_FLUWSCR",.T.,"http://aguassantatst.fluig.com/webdesk/ECMColleagueReplacementService"))

::Init()
::oWSgetReplacementsOfUserresult:SoapRecv( WSAdvValue( oXmlRet,"_RESULT","colleagueReplacementDtoArray",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getValidReplacement of Service WSECMColleagueReplacementServiceService

WSMETHOD getValidReplacement WSSEND cusername,cpassword,ncompanyId,ccolleagueId,creplacementId WSRECEIVE oWSgetValidReplacementresult WSCLIENT WSECMColleagueReplacementServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getValidReplacement xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ccolleagueId , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("replacementId", ::creplacementId, creplacementId , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getValidReplacement>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getValidReplacement",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	SuperGetMv("AS_FLUWSCR",.T.,"http://aguassantatst.fluig.com/webdesk/ECMColleagueReplacementService"))

::Init()
::oWSgetValidReplacementresult:SoapRecv( WSAdvValue( oXmlRet,"_RESULT","colleagueReplacementDto",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getValidReplacementsOfUser of Service WSECMColleagueReplacementServiceService

WSMETHOD getValidReplacementsOfUser WSSEND cusername,cpassword,ncompanyId,ccolleagueId WSRECEIVE oWSgetValidReplacementsOfUserresult WSCLIENT WSECMColleagueReplacementServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getValidReplacementsOfUser xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ccolleagueId , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getValidReplacementsOfUser>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getValidReplacementsOfUser",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	SuperGetMv("AS_FLUWSCR",.T.,"http://aguassantatst.fluig.com/webdesk/ECMColleagueReplacementService"))

::Init()
::oWSgetValidReplacementsOfUserresult:SoapRecv( WSAdvValue( oXmlRet,"_RESULT","colleagueReplacementDtoArray",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getColleagueReplacement of Service WSECMColleagueReplacementServiceService

WSMETHOD getColleagueReplacement WSSEND cusername,cpassword,ncompanyId,ccolleagueId,creplacementId WSRECEIVE oWSgetColleagueReplacementresult WSCLIENT WSECMColleagueReplacementServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getColleagueReplacement xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ccolleagueId , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("replacementId", ::creplacementId, creplacementId , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getColleagueReplacement>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getColleagueReplacement",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	SuperGetMv("AS_FLUWSCR",.T.,"http://aguassantatst.fluig.com/webdesk/ECMColleagueReplacementService"))

::Init()
::oWSgetColleagueReplacementresult:SoapRecv( WSAdvValue( oXmlRet,"_RESULT","colleagueReplacementDto",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method createColleagueReplacement of Service WSECMColleagueReplacementServiceService

WSMETHOD createColleagueReplacement WSSEND cusername,cpassword,ncompanyId,oWScreateColleagueReplacementcolleagueReplacement WSRECEIVE cresult WSCLIENT WSECMColleagueReplacementServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:createColleagueReplacement xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("colleagueReplacement", ::oWScreateColleagueReplacementcolleagueReplacement, oWScreateColleagueReplacementcolleagueReplacement , "colleagueReplacementDto", .T. , .T. , 0 , NIL, .F.) 

cSoap += "</q1:createColleagueReplacement>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"createColleagueReplacement",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	SuperGetMv("AS_FLUWSCR",.T.,"http://aguassantatst.fluig.com/webdesk/ECMColleagueReplacementService"))

::Init()
::cresult            :=  WSAdvValue( oXmlRet,"_RESULT","string",NIL,NIL,NIL,"S",NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method getValidReplacedUsers of Service WSECMColleagueReplacementServiceService

WSMETHOD getValidReplacedUsers WSSEND cusername,cpassword,ncompanyId,creplacementId WSRECEIVE oWSgetValidReplacedUsersresult WSCLIENT WSECMColleagueReplacementServiceService
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<q1:getValidReplacedUsers xmlns:q1="http://ws.foundation.ecm.technology.totvs.com/">'
cSoap += WSSoapValue("username", ::cusername, cusername , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("companyId", ::ncompanyId, ncompanyId , "int", .T. , .T. , 0 , NIL, .F.) 
cSoap += WSSoapValue("replacementId", ::creplacementId, creplacementId , "string", .T. , .T. , 0 , NIL, .F.) 
cSoap += "</q1:getValidReplacedUsers>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"getValidReplacedUsers",; 
	"RPCX","http://ws.foundation.ecm.technology.totvs.com/",,,; 
	SuperGetMv("AS_FLUWSCR",.T.,"http://aguassantatst.fluig.com/webdesk/ECMColleagueReplacementService"))

::Init()
::oWSgetValidReplacedUsersresult:SoapRecv( WSAdvValue( oXmlRet,"_RESULT","colleagueReplacementDtoArray",NIL,NIL,NIL,"O",NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure colleagueReplacementDto

WSSTRUCT ECMColleagueReplacementServiceService_colleagueReplacementDto
	WSDATA   ccolleagueId              AS string OPTIONAL
	WSDATA   ncompanyId                AS long OPTIONAL
	WSDATA   creplacementId            AS string OPTIONAL
	WSDATA   cvalidationFinalDate      AS dateTime OPTIONAL
	WSDATA   cvalidationStartDate      AS dateTime OPTIONAL
	WSDATA   lviewGEDTasks             AS boolean OPTIONAL
	WSDATA   lviewWorkflowTasks        AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ECMColleagueReplacementServiceService_colleagueReplacementDto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ECMColleagueReplacementServiceService_colleagueReplacementDto
Return

WSMETHOD CLONE WSCLIENT ECMColleagueReplacementServiceService_colleagueReplacementDto
	Local oClone := ECMColleagueReplacementServiceService_colleagueReplacementDto():NEW()
	oClone:ccolleagueId         := ::ccolleagueId
	oClone:ncompanyId           := ::ncompanyId
	oClone:creplacementId       := ::creplacementId
	oClone:cvalidationFinalDate := ::cvalidationFinalDate
	oClone:cvalidationStartDate := ::cvalidationStartDate
	oClone:lviewGEDTasks        := ::lviewGEDTasks
	oClone:lviewWorkflowTasks   := ::lviewWorkflowTasks
Return oClone

WSMETHOD SOAPSEND WSCLIENT ECMColleagueReplacementServiceService_colleagueReplacementDto
	Local cSoap := ""
	cSoap += WSSoapValue("colleagueId", ::ccolleagueId, ::ccolleagueId , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("companyId", ::ncompanyId, ::ncompanyId , "long", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("replacementId", ::creplacementId, ::creplacementId , "string", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("validationFinalDate", ::cvalidationFinalDate, ::cvalidationFinalDate , "dateTime", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("validationStartDate", ::cvalidationStartDate, ::cvalidationStartDate , "dateTime", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("viewGEDTasks", ::lviewGEDTasks, ::lviewGEDTasks , "boolean", .F. , .T., 0 , NIL, .F.) 
	cSoap += WSSoapValue("viewWorkflowTasks", ::lviewWorkflowTasks, ::lviewWorkflowTasks , "boolean", .F. , .T., 0 , NIL, .F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ECMColleagueReplacementServiceService_colleagueReplacementDto
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ccolleagueId       :=  WSAdvValue( oResponse,"_COLLEAGUEID","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::ncompanyId         :=  WSAdvValue( oResponse,"_COMPANYID","long",NIL,NIL,NIL,"N",NIL,"xs") 
	::creplacementId     :=  WSAdvValue( oResponse,"_REPLACEMENTID","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cvalidationFinalDate :=  WSAdvValue( oResponse,"_VALIDATIONFINALDATE","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::cvalidationStartDate :=  WSAdvValue( oResponse,"_VALIDATIONSTARTDATE","dateTime",NIL,NIL,NIL,"S",NIL,"xs") 
	::lviewGEDTasks      :=  WSAdvValue( oResponse,"_VIEWGEDTASKS","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
	::lviewWorkflowTasks :=  WSAdvValue( oResponse,"_VIEWWORKFLOWTASKS","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure colleagueReplacementDtoArray

WSSTRUCT ECMColleagueReplacementServiceService_colleagueReplacementDtoArray
	WSDATA   oWSitem                   AS ECMColleagueReplacementServiceService_colleagueReplacementDto OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ECMColleagueReplacementServiceService_colleagueReplacementDtoArray
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ECMColleagueReplacementServiceService_colleagueReplacementDtoArray
	::oWSitem              := {} // Array Of  ECMColleagueReplacementServiceService_COLLEAGUEREPLACEMENTDTO():New()
Return

WSMETHOD CLONE WSCLIENT ECMColleagueReplacementServiceService_colleagueReplacementDtoArray
	Local oClone := ECMColleagueReplacementServiceService_colleagueReplacementDtoArray():NEW()
	oClone:oWSitem := NIL
	If ::oWSitem <> NIL 
		oClone:oWSitem := {}
		aEval( ::oWSitem , { |x| aadd( oClone:oWSitem , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ECMColleagueReplacementServiceService_colleagueReplacementDtoArray
	Local nRElem1 , nTElem1
	Local aNodes1 := WSRPCGetNode(oResponse,.T.)
	::Init()
	If oResponse = NIL ; Return ; Endif 
	nTElem1 := len(aNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( aNodes1[nRElem1] )
			aadd(::oWSitem , ECMColleagueReplacementServiceService_colleagueReplacementDto():New() )
  			::oWSitem[len(::oWSitem)]:SoapRecv(aNodes1[nRElem1])
		Endif
	Next
Return


