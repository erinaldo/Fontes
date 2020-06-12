#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "fileio.ch"
#include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCPRJW01   บ Autor ณ Emerson Natali     บ Data ณ  11/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Workflow para a importacao do arquivo da Intranet na tabelaบฑฑ
ฑฑบ          ณ SZP                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CPRJW01()      

Local nTamSSI	:=0
Local _cEmail	 := ""
Local _cNumSSI   := ""

Local _cNumSSI :=	""
Local _cUseSSI :=	""
Local _cCR     :=	""
Local _cDesCR  :=	""
Local _cRamal  :=	""
Local _cData   :=	""
Local _cAnali  :=	""
Local _cSist   :=	""
Local _cIdent  :=	""
Local _cEmail  :=	""
Local _cEmailSup	:=	""
Local _cEmailGer	:=	""
Local _cEmailSI		:=	""      
Private aRotina:={{'','u_CIW01Imp',0,3}}
Private lMsErroAuto:=.F.

//wfPrepENV( "01", "01")

//ChkFile("SZP")
RpcSetType(3)
RpcSetEnv("01","01")
                
If !LockByName("CPRJW01")
	RpcClearEnv()
	Return
EndIf

nTamSSI		:=TamSX3('ZP_NRSSI')[1]
cDirect    := "\arq_txt\sistemas\"
cDirectImp := "\arq_txt\sistemas\Backup\"
aDirect    := Directory(cDirect+"*.TXT")

If !Empty(adirect)
	For _nI := 1 to Len(adirect)
		FT_FUSE(cDirect+adirect[_nI,1])
		FT_FGOTOP()
		cBuffer 	:=	Alltrim(FT_FREADLN())
		Do While !FT_FEOF()
			cBuffer  := Alltrim(FT_FREADLN())
			_cNumSSI :=	Substr(cBuffer,1,(At(";",cBuffer)-1))
			_cNumSSI:=PadR(_cNumSSI,nTamSSI)

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cUseSSI :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cEmail  :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		
			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cCR     :=	Substr(cBuffer,1,(At(";",cBuffer)-1))
        
	        cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cData   :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cEmailSup:=Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cEmailGer:=Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cEmailSI:=	Substr(cBuffer,1,(At(";",cBuffer)-1))


			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cDesc 	 :=	Substr(cBuffer,1,(At(";",cBuffer)-1))


			cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cSist  :=	Substr(cBuffer,1,(At(";",cBuffer)-1))//Protheus / Soe / Web / etc
                              
	  		cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cIdent  :=cBuffer//Altera็ใo / Desenv. / Emergencial
            
			//_xArea	:= GetArea()
			DbSelectArea("SZP")
			DbSetOrder(1)
			If !DbSeek(xFilial("SZP")+_cNumSSI)
			
		  		aCabSZP:={{"ZP_FILIAL", xFilial("SZP"),Nil},;
							{"ZP_NRSSI", _cNumSSI,Nil},;
							{"ZP_EMISSAO",ctod(_cData),Nil},;
							{"ZP_CR     ", _cCR,Nil},;
							{"ZP_SERVICO", _cDesc,Nil},;
							{"ZP_CODANAL", '99',Nil},;
							{"ZP_SISTEMA", _cSist,Nil},;
							{"ZP_TPIDENT", _cIdent,Nil},;
							{"ZP_SOLICIT", _cUseSSI,Nil},;
							{"ZP_EMAIL1 ", _cEmail,Nil},;//Solicitante
							{"ZP_EMAIL2 ", _cEmailSup,Nil},;//Superior
							{"ZP_EMAIL3 ", _cEmailGer,Nil},;//Gerente
							{"ZP_EMAIL4 ", _cEmailSI,Nil},;//Superintendente
							{"ZP_APROV  ", "S",Nil},;
							{"ZP_ALOC   ", "N",Nil},;
							{"ZP_ARQUIVO", "2",Nil},;
							{"ZP_CANCEL", "2",Nil},; 
							{"ZP_CONCLUS","",Nil},;    
							{"ZP_ACEITE","",Nil}}
						
					
			    lMsErroAuto:=.F.
				MsRotAuto(3,aCabSZP,'SZP')
				If !lMsErroAuto

					If SZP->(DbSeek(xFilial("SZP")+_cNumSSI))
						u_WfIncSSI()//Envia WF de Inclusใo.
					EndIf
				EndIf   
			EndIF

			/*
			DbSelectArea("SZP")
			DbSetOrder(1)
			If !DbSeek(xFilial("SZP")+_cNumSSI)
				RecLock("SZP",.T.)
				SZP->ZP_FILIAL  := xFilial("SZP")
				SZP->ZP_NRSSI   := _cNumSSI
				SZP->ZP_EMISSAO := ctod(_cData)
				SZP->ZP_CR      := _cCR
				//SZP->ZP_CRDESCR := _cDesCR
				SZP->ZP_SERVICO := _cDesc
				SZP->ZP_CODANAL := '99'
				//SZP->ZP_ANALIST := _cNomeA
				SZP->ZP_SISTEMA := _cSist
				//SZP->ZP_DESCSIS := _cDeSis
				SZP->ZP_TPIDENT := _cIdent
				SZP->ZP_SOLICIT := _cUseSSI
				//SZP->ZP_RAMAL   := _cRamal
				SZP->ZP_EMAIL1  := _cEmail//Solicitante
				SZP->ZP_EMAIL2  := _cEmailSup//Superior
				SZP->ZP_EMAIL3  := _cEmailGer//Gerente
				SZP->ZP_EMAIL4  := _cEmailSI//Superintendente
				SZP->ZP_APROV   := "N"
				SZP->ZP_ALOC    := "N"
				SZP->ZP_ARQUIVO	:= "2"
				SZP->ZP_CANCEL	:= "2"
				MsUnLock()    
				
					
				SZP->(DbSeek(xFilial("SZP")+_cNumSSI))
				u_WfIncSSI()//Envia WF de Inclusใo.
			EndIf*/
                        
			//_fEnvia2(_cEmail2, _cNumSSI, _cUseSSI, (_cCR+"-"+_cDesCR), ctod(_cData), _cDeSis, _cIdent, _cPedido)
			//_fEnvia (_cEmail , _cNumSSI, _cUseSSI, (_cCR+"-"+_cDesCR), ctod(_cData), _cDeSis, _cIdent, _cPedido)

			FT_FSKIP()
		EndDo
		FT_FUSE()
	Next
EndIf

For _nI := 1 to Len(adirect)
	If __copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
		ferase(cDirect+adirect[_nI,1]) 
	EndIf
Next         
    
UnLockByName("CPRJW01")
RpcClearEnv()       

Return()

User Function CIW01Imp()
AxIncluiAuto('SZP')
Return
/*                       

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF002   บAutor  ณMicrosiga           บ Data ณ  08/14/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail para o Aprovador A (Supervisor)                บฑฑ
ฑฑบ          ณ(Conferencia)                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fEnvia(_cEmail, _cNumSSI, _cUseSSI, _cCR, _cData, _cDeSis, _cIdent, _cPedido)

_cAssunto  	:= OemToAnsi("Solicita็ใo de Aprova็ใo de SSI - "+_cNumSSI )
_cEOL     	:= CHR(13) + CHR(10)
_nCont		:= 0  

Private oHtml

DbSelectArea("SZP")
DbSetOrder(1)
If DbSeek(xFilial("SZP")+_cNumSSI)

	If !Empty(_cEmail)
		oProcess:= TWFProcess():New("000001", "Workflow Controle SSI")
		oProcess:NewTask( "Workflow Controle SSI", "\Workflow\WFSSIAPR.htm")
		oProcess:NewVersion(.T.)
		oProcess:bReturn	:= "u_CPRJW01a(1,'"+_cAssunto+"','"+_cNumSSI+"')"
		oProcess:cSubject	:= _cAssunto
		oProcess:cTo  		:= _cEmail

		oProcess:cBody 		:= OemToAnsi("Sr. usuแrio favor clicar no anexo para visualizar a SSI e nela efetuar sua APROVAวรO !!!") +_cEOL
		oProcess:cBody 		+= OemToAnsi("Esta ้ uma mensagem automแtica. Por favor, nใo responda!!!") 

		//oProcess:cCC  		:= GETMV("CI_WFAPRB")//'sistemas@ciee.org.br'
		conout("Inicio do Envio CPRJW01...")

		oHtml  		:= oProcess:oHTML
		oHtml:ValByName("numssi"	, _cNumSSI	)
		oHtml:ValByName("solic"		, _cUseSSI	)
		oHtml:ValByName("cr"		, _cCR		)
		oHtml:ValByName("data"		, _cData	)
		oHtml:ValByName( "OBS"    	, ""		)
	EndIf 
	
	AAdd( (oHtml:ValByName( "t.1"     )), ALLTRIM(_cDeSis))
	AAdd( (oHtml:ValByName( "t.2"     )), ALLTRIM(_cIdent))
	AAdd( (oHtml:ValByName( "t.3"     )), ALLTRIM(_cPedido))

	oProcess:Start()
	conout("Fim do Envio...")

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF002   บAutor  ณMicrosiga           บ Data ณ  08/14/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail para o Aprovador A (Supervisor)                บฑฑ
ฑฑบ          ณ(Conferencia)                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fEnvia2(_cEmail, _cNumSSI, _cUseSSI, _cCR, _cData, _cDeSis, _cIdent, _cPedido)

_cAssunto  	:= OemToAnsi("Solicita็ใo de Aprova็ใo de SSI - "+_cNumSSI )
_cEOL     	:= CHR(13) + CHR(10)
_nCont		:= 0  

Private oHtml

DbSelectArea("SZP")
DbSetOrder(1)
If DbSeek(xFilial("SZP")+_cNumSSI)

	If !Empty(_cEmail)
		oProcess:= TWFProcess():New("000001", "Workflow Controle SSI")
		oProcess:NewTask( "Workflow Controle SSI", "\Workflow\WFSSI.htm")
		oProcess:NewVersion(.T.)
		oProcess:cSubject	:= _cAssunto
		oProcess:cTo  		:= _cEmail

		oProcess:cBody 		:= OemToAnsi("Sr. usuแrio em anexo segue SSI para simples conferencia!!!") +chr(10)+chr(13)
		oProcess:cBody 		+= OemToAnsi("Esta ้ uma mensagem automแtica. Por favor, nใo responda!!!") 

		//oProcess:cCC  		:= GETMV("CI_WFAPRB")//'sistemas@ciee.org.br'
		conout("Inicio do Envio CPRJW01...")

		oHtml  		:= oProcess:oHTML
		oHtml:ValByName("numssi"	, _cNumSSI	)
		oHtml:ValByName("solic"		, _cUseSSI	)
		oHtml:ValByName("cr"		, _cCR		)
		oHtml:ValByName("data"		, _cData	)
	EndIf 
	
	AAdd( (oHtml:ValByName( "t.1"     )), ALLTRIM(_cDeSis))
	AAdd( (oHtml:ValByName( "t.2"     )), ALLTRIM(_cIdent))
	AAdd( (oHtml:ValByName( "t.3"     )), ALLTRIM(_cPedido))

	oProcess:Start()
	conout("Fim do Envio...")

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF002   บAutor  ณMicrosiga           บ Data ณ  05/29/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara e-mail para Aprovador A                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function _EnvMail(_cEmail, _cAssunto, _cNumSSI)

Private oHtml

oProcess:= TWFProcess():New("000001", "Workflow Controle SSI")
oProcess:NewTask( "Workflow Controle SSI", "\Workflow\WFSSIAPR.htm")
oProcess:NewVersion(.T.)
oProcess:bReturn	:= "u_CPRJW01a(1,'"+_cAssunto+"','"+_cNumSSI+"')"
oProcess:cSubject	:= _cAssunto
oProcess:cTo  		:= _cEmail
//oProcess:cCC  		:= GETMV("CI_WFAPRB")//'sistemas@ciee.org.br'

conout("Inicio do Envio CPRJW01...")

Return(.T.)
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF004a  บAutor  ณMicrosiga           บ Data ณ  02/19/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail para Aprovador B                               บฑฑ
ฑฑบ          ณ(Analise do movimento)                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CPRJW01a(nAprov,_cAssunto, _cNumSSI, oProcess)

_cNotif1 := {}
_cNotif2 := {}

_cOBS := oProcess:oHtml:RetByName("OBS")
_cOpc := oProcess:oHtml:RetByName("OPC")

If Empty(_cOBS)
	_cOBS := "Cancelado sem justificativa do Aprovador"
EndIf

oProcess:Finish()

If _cOpc == "S"
	_cQuery	:= "UPDATE "+ RetSqlName("SZP")+" SET ZP_APROV = 'S' , ZP_DTAPROV = '"+DtoS(dDataBase)+"' "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZP_NRSSI = '"+_cNumSSI+"' "
	TcSQLExec(_cQuery)
ElseIf _cOpc == "N"

	_cQuery	:= "UPDATE "+ RetSqlName("SZP")+" SET ZP_APROV = 'N', ZP_CANCEL = '1', ZP_MOTIVO = '"+_cOBS+"', ZP_DTAPROV = '"+DtoS(dDataBase)+"' "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZP_NRSSI = '"+_cNumSSI+"' "
	TcSQLExec(_cQuery)


	oProcess:= TWFProcess():New("000001", "Workflow Reserva Financeira")
	oProcess:NewTask( "Workflow Controle SSI", "\Workflow\WFSSI.htm")
	oProcess:NewVersion(.T.)
	oProcess:cSubject	:= _cAssunto
	oProcess:cTo  		:= 'cristiano@cieesp.org.br'
	oProcess:bReturn	:= NIL
	oProcess:cBody  	:= OemToAnsi("Solicita็ใo "+_cNumSSI+" cancelado pelo Superior!!!")

	oHtml  		:= oProcess:oHTML

	oProcess:Start()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCWKF004a  บAutor  ณMicrosiga           บ Data ณ  02/19/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail para Aprovador B                               บฑฑ
ฑฑบ          ณ(Analise do movimento)                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CPRJW01b(nAprov,_cAssunto, _cNumSSI, oProcess)

_xArea		:= GetArea()
_cSist		:= ""
_cIdent		:= ""
_cDesc		:= ""
_aRet		:= {}   

//conout('CPRJW01b entrou aqui.')

_cOBS 		:= oProcess:oHtml:RetByName("OBS")
_cOpc 		:= oProcess:oHtml:RetByName("OPC")
_dtConclu	:= oProcess:oHtml:RetByName("dtconcl")

For _nI := 1 to Len(oProcess:oHtml:RetByName( "t.1"))
	_cSist		:= oProcess:oHtml:RetByName( "t.1")[_nI]
	_cIdent		:= oProcess:oHtml:RetByName( "t.2")[_nI]
	_cDesc		:= oProcess:oHtml:RetByName( "t.3")[_nI]
    AAdd(_aRet, {_cSist, _cIdent,_cDesc})
Next _nI

oProcess:Finish()

If _cOpc == "S" // aceite                          

	DbSelectArea("SZP")
	DbSetOrder(1)
	If DbSeek(xFilial("SZP")+_cNumSSI)
		_dDatConclu	:= SZP->ZP_CONCLUS
	Else
		_dDatConclu	:= CTOD(" / / ")
	EndIf

	DbSelectArea("SZW")
	DbSetOrder(1)
	DbGotop()
	If DbSeek(xFilial("SZW")+_cNumSSI ,.F.)
		_nSeq	:= VAL(SZW->ZW_SEQ)
		Do While !EOF() .and. SZW->ZW_NRSSI == _cNumSSI
			_nSeq += 1
			SZW->(DbSkip())
		EndDo
	Else
		_nSeq := 1
	EndIf
	RecLock("SZW",.T.)
	SZW->ZW_FILIAL	:= xFilial("SZW")
	SZW->ZW_CONCLUS	:= _dDatConclu
	SZW->ZW_ACEITE	:= "S"
	SZW->ZW_HISTOR	:= _cOBS
	SZW->ZW_SEQ		:= STRZERO(_nSeq,4)
	SZW->ZW_NRSSI	:= _cNumSSI
	MsUnLock()

	DbSelectArea("SZP")
	DbSetOrder(1)
	If DbSeek(xFilial("SZP")+_cNumSSI)
		RecLock("SZP",.F.)
		SZP->ZP_ACEITE	:= dDataBase
		MsUnLock()
	EndIf

	oProcess:= TWFProcess():New("000001", "Workflow Reserva Financeira")
	oProcess:NewTask( "Workflow Controle SSI", "\Workflow\WFSSIACE.htm")
	oProcess:NewVersion(.T.)
	oProcess:cSubject	:= "Aceite de encerramento da SSI n๚mero "+SZP->ZP_NRSSI+" !"
	oProcess:cTo  		:= SZP->ZP_EMAIL1+';'+SZP->ZP_EMAIL2
	oProcess:cCc  		:= 'sistemas@cieesp.org.br;mauricio@cieesp.org.br'
	oProcess:bReturn	:= NIL
	oProcess:cBody  	:= OemToAnsi("Solicita็ใo "+_cNumSSI+" - Retorno de homologa็ใo.")
	
	oHtml  		:= oProcess:oHTML
	
	oHtml:ValByName("numssi"	, _cNumSSI				)
	oHtml:ValByName("dtconcl"	, _dtConclu				)
	oHtml:ValByName("solic"		, Alltrim(SZP->ZP_SOLICIT))
	oHtml:ValByName("dtaceite"	, DtoC(dDataBase)		)
	
	For _nY := 1 to len(_aRet)
		AAdd( (oHtml:ValByName( "t.1"     )), ALLTRIM(_aRet[_nY,1]))
		AAdd( (oHtml:ValByName( "t.2"     )), ALLTRIM(_aRet[_nY,2]))
		AAdd( (oHtml:ValByName( "t.3"     )), ALLTRIM(_aRet[_nY,3]))
	Next _nY
	
	
	oHtml:ValByName("aceite"	, "SIM"				)                                   

	oHtml:ValByName("OBS"	, _cOBS				)
	
	oHtml:ValByName( "estado", "disabled" )
	
	oProcess:Start()
	
ElseIf _cOpc == "N"

	DbSelectArea("SZP")
	DbSetOrder(1)
	If DbSeek(xFilial("SZP")+_cNumSSI)
		_dDatConclu	:= SZP->ZP_CONCLUS
	Else
		_dDatConclu	:= CTOD(" / / ")
	EndIf

	DbSelectArea("SZW")
	DbSetOrder(1)
	DbGotop()
	If DbSeek(xFilial("SZW")+_cNumSSI ,.F.)
		_nSeq	:= VAL(SZW->ZW_SEQ)
		Do While !EOF() .and. SZW->ZW_NRSSI == _cNumSSI
			_nSeq += 1
			SZW->(DbSkip())
		EndDo
	Else
		_nSeq := 1
	EndIf
	RecLock("SZW",.T.)
	SZW->ZW_FILIAL	:= xFilial("SZW")
	SZW->ZW_CONCLUS	:= _dDatConclu
	SZW->ZW_ACEITE	:= "N"
	SZW->ZW_HISTOR	:= _cOBS
	SZW->ZW_SEQ		:= STRZERO(_nSeq,4)
	SZW->ZW_NRSSI	:= _cNumSSI
	MsUnLock()

	DbSelectArea("SZP")
	DbSetOrder(1)
	If DbSeek(xFilial("SZP")+_cNumSSI)
		RecLock("SZP",.F.)
		SZP->ZP_CONCLUS	:= CTOD(" / / ")
		MsUnLock()
	EndIf
	
	oProcess:= TWFProcess():New("000001", "Workflow Reserva Financeira")
	oProcess:NewTask( "Workflow Controle SSI", "\Workflow\WFSSINACE.htm")
	oProcess:NewVersion(.T.)
	oProcess:cSubject	:= "Recusa da SSI n๚mero "+SZP->ZP_NRSSI+" !"
	oProcess:cTo  		:= SZP->ZP_EMAIL1+';'+SZP->ZP_EMAIL2
	oProcess:cCc  		:= 'sistemas@cieesp.org.br;mauricio@cieesp.org.br'
	oProcess:bReturn	:= NIL
	oProcess:cBody  	:= OemToAnsi("Solicita็ใo "+_cNumSSI+" - Retorno de homologa็ใo.")
	
	oHtml  		:= oProcess:oHTML
	
	oHtml:ValByName("numssi"	, _cNumSSI				)
	oHtml:ValByName("solic"		, Alltrim(SZP->ZP_SOLICIT))
	
	For _nY := 1 to len(_aRet)
		AAdd( (oHtml:ValByName( "t.1"     )), ALLTRIM(_aRet[_nY,1]))
		AAdd( (oHtml:ValByName( "t.2"     )), ALLTRIM(_aRet[_nY,2]))
		AAdd( (oHtml:ValByName( "t.3"     )), ALLTRIM(_aRet[_nY,3]))
	Next _nY
	
	oHtml:ValByName("aceite"	, OemToAnsi("NรO")	)
	
	oHtml:ValByName("OBS"	, _cOBS				)
	
	//oHtml:ValByName( "estado", "disabled" )
	
	oProcess:Start()
	
EndIf

RestArea(_xArea)

Return