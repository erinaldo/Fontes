#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"  
#INCLUDE "FWADAPTEREAI.CH"
#INCLUDE "XMLXFUN.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} WSCIEE01
Servi็o de Consultas especificas CIEE
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------                           

WSSTRUCT aRet 
	WSDATA lRet AS BOOLEAN	 	                 
	WSDATA cMsg As String
	WSDATA cXml As String
ENDWSSTRUCT

WSSTRUCT Ativos 
	WSDATA N3_CUSTBEM AS String	 	                 
	WSDATA N1_CHAPA As String
	WSDATA N1_DESCRIC As String
	WSDATA N1_CBASE As String
	WSDATA N3_ITEM As String
	WSDATA N1_QUANTD As String
	WSDATA N1_AQUISIC As String
	WSDATA N3_VORIG1 As String
	WSDATA VLATUALIZADO As String
	WSDATA CTT_DESC01 As String
	WSDATA CV0_DESC As String
ENDWSSTRUCT

WSSERVICE CIEE DESCRIPTION "Especificos CIEE"        
	WSDATA cCusto	AS String                       
	WSDATA cChapa	AS String
	WSDATA cSetor	AS String
	WSDATA cOrigem AS String
	WSDATA aAtf AS Array OF Ativos	
	WSDATA cFilPar AS String
	WSDATA aDados	As Array OF aRet	
	WSDATA cF3		As String
	WSDATA INMSG	As String
	WSDATA OUTMSG	As String
	WSMETHOD GETF3 	 DESCRIPTION "Metodo que realiza uma consulta padrใo F3" 	
	WSMETHOD FSERVICE DESCRIPTION "Metodo de integra็ใo Fluig x Microsiga Protheus"
	WSMETHOD GETATIVOS DESCRIPTION "M้todo de consulta de ativos por plaqueta, centro de custo e setor"
ENDWSSERVICE  
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} GETATIVOS
M้todo de consulta de ativos por plaqueta, centro de custo e setor
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8
@Obs  		Utilizado pelos formulแrio de solicita็ใo baixa e transfer๊cia e relat๓rio de bens      
/*/
//---------------------------------------------------------------------------------------
WSMETHOD GETATIVOS WSRECEIVE cCusto,cChapa,cSetor,cOrigem WSSEND aAtf WSSERVICE CIEE
LOCAL cTab		:= GetNextAlias() 
LOCAL cQry		:= ""
LOCAL cQrySN1 := ""
LOCAL cQrySN3 := ""
LOCAL nItx		:= 0  
LOCAL cPictQUANTD := Pesqpict("SN1","N1_QUANTD")
LOCAL cPictVORIG1 := Pesqpict("SN3","N3_VORIG1")
LOCAL cDescCR	:= ""
LOCAL cDescSet:= ""

IF TRIM(cCusto)== "*"
	cCusto:= ""
ELSE
	cDescCR:= POSICIONE("CTT",1,xfilial("CTT")+cCusto,"CTT_DESC01")	
ENDIF

IF TRIM(cChapa)== "*"
	cChapa:= ""
ENDIF

IF TRIM(cSetor)== "*"
	cSetor:= ""
ELSE
	cDescSet:= POSICIONE("CTD",1,xfilial("CTD")+cSetor,"CTD_DESC01")	
ENDIF

IF !EMPTY(cChapa)
	cQrySN1+= "	AND N1_CHAPA='"+cChapa+"'"
ENDIF

IF !EMPTY(cCusto)
	cQrySN3+= "	AND N3_CUSTBEM='"+cCusto+"'"
ENDIF	

IF !EMPTY(cSetor)
	cQrySN3+= "	AND N3_SUBCCON='"+cSetor+"'" 
ENDIF

// Tratamento para solicita็ใo de baixa e transfer๊ncia de ativos Fluig
If cOrigem == "1"
	cQrySN1+= "	AND (SELECT COUNT(*) FROM "+RETSQLNAME("SNM")+" 
	cQrySN1+= "		SNM WHERE NM_FILIAL='"+xFilial("SNM")+"'	AND NM_CBASE=SN1.N1_CBASE"	
	cQrySN1+= "		AND NM_ITEM=SN1.N1_ITEM	AND NM_SITSOL='1'	AND SNM.D_E_L_E_T_='') = 0"
	
	// Filtra baixados para Formulแrio de solicita็ใo de baixa e transfer๊ncia
	cQrySN3+=	"	AND N3_BAIXA='0'"
	cQrySN3+=	"	AND N3_DTBAIXA=''"
else
	// Filtra baixados para Formulแrio de solicita็ใo de baixa e transfer๊ncia
	cQrySN3+=	"	AND N3_BAIXA='0'"
	cQrySN3+=	"	AND N3_DTBAIXA=''"	
Endif


cQrySN1 := "%" + cQrySN1 + "%"
cQrySN3 := "%" + cQrySN3 + "%"
	
BeginSql Alias cTab
	SELECT N3_CUSTBEM
			,N1_CHAPA
			,N1_DESCRIC										
			,N1_CBASE									
			,N3_ITEM
			,N1_QUANTD
			,N1_AQUISIC
			,N3_VORIG1
			,N3_VRCACM1
			,N3_AMPLIA1			
	FROM %TABLE:SN1% SN1 
	INNER JOIN %TABLE:SN3% SN3 ON N3_FILIAL=%xfilial:SN3%
		AND N3_CBASE=N1_CBASE
		AND N3_ITEM=N1_ITEM  		
		%exp:cQrySN3%
		AND SN3.D_E_L_E_T_=''
	WHERE N1_FILIAL=%xfilial:SN1%
	%exp:cQrySN1%
	AND SN1.D_E_L_E_T_ =''
	ORDER BY N1_DESCRIC	
EndSql
//aRet:= GETLastQuery()

tcsetfield(cTab,"N1_AQUISIC","D")

(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF())
	
	AADD(::aAtf,WsClassNew('Ativos'))
	nItx:= LEN(::aAtf)
	
	::aAtf[nItx]:N3_CUSTBEM	:= (cTab)->N3_CUSTBEM	 	                 
	::aAtf[nItx]:N1_CHAPA	:= (cTab)->N1_CHAPA
	::aAtf[nItx]:N1_DESCRIC	:= (cTab)->N1_DESCRIC
	::aAtf[nItx]:N1_CBASE	:= (cTab)->N1_CBASE
	::aAtf[nItx]:N3_ITEM		:= (cTab)->N3_ITEM
	::aAtf[nItx]:N1_QUANTD	:= ALLTRIM(Transform((cTab)->N1_QUANTD,cPictQUANTD)) 
	::aAtf[nItx]:N1_AQUISIC	:= IIF(!EMPTY((cTab)->N1_AQUISIC),Dtoc((cTab)->N1_AQUISIC),"")  
	::aAtf[nItx]:N3_VORIG1	:= ALLTRIM(Transform((cTab)->N3_VORIG1,cPictVORIG1))
	::aAtf[nItx]:VLATUALIZADO:= ALLTRIM(Transform((cTab)->N3_VORIG1 + (cTab)->N3_VRCACM1 + (cTab)->N3_AMPLIA1,cPictVORIG1))	
	::aAtf[nItx]:CTT_DESC01	:= cDescCR
	::aAtf[nItx]:CV0_DESC	:= cDescSet
	
	
(cTab)->(DBSKIP())
END                   
(cTab)->(dbCloseArea())                       

Return(.T.)  
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ FSERVICE   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Metodo de integra็ใo Fluig x Microsiga Protheus      	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
WSMETHOD FSERVICE WSRECEIVE INMSG WSSEND OUTMSG WSSERVICE CIEE
Local cErroBlk  	:= ""
Local oLastError	:= ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack , BREAK(e) })
LOCAL oXml			:= NIL
LOCAL cXmlCont	:= ""  
LOCAL cXmlRet		:= ""
LOCAL cError		:= ""   
LOCAL cWarning	:= ""
LOCAL cFuncCode	:= "" 
LOCAL cIdentif	:= ""
local cData		:= Dtos(Date())
local cHora		:= Time() 
local oFWEAI    	:= nil
local lErro		:= .f.
local cBakEmp		:= CEMPANT
local cBakFil		:= CFILANT

// Valida xml                  
oXml := XmlParser(alltrim(EncodeUTF8(::INMSG)), "_", @cError, @cWarning) 

if !Empty(cError) 
	lErro	:= .t.
	cMsg:= "Erro no xml: "+cError
 endif

if !lErro .and. !Empty(cWarning)                        
	lErro	:= .t.
	cMsg:= "Erro no xml: "+cWarning
endif  
	

if !lErro
	
	BEGIN TRANSACTION
		BEGIN SEQUENCE
			CEMPANT:= oXml:_TOTVSINTEGRATOR:_DOCCOMPANY:TEXT
			CFILANT:= oXml:_TOTVSINTEGRATOR:_DOCBRANCH:TEXT               		
			SAVE oXml:_TOTVSINTEGRATOR:_MESSAGE:_LAYOUTS:_CONTENT XMLSTRING cXmlCont
				
			// Gera registro de recebimento
			oFWEAI:= FWEAI():New()
			oFWEAI:SetFuncCode( oXml:_TOTVSINTEGRATOR:_MESSAGE:_LAYOUTS:_IDENTIFIER:TEXT )
			oFWEAI:SetFuncDescription(oXml:_TOTVSINTEGRATOR:_GLOBALDOCUMENTFUNCTIONDESCRIPTION:TEXT)
			oFWEAI:SetDocType(PROC_SYNC) 		// PROC_SYNC = Sincrono | PROC_ASYNC = Assincrono
			oFWEAI:AddLayout( oXml:_TOTVSINTEGRATOR:_MESSAGE:_LAYOUTS:_IDENTIFIER:TEXT ,;
							  oXml:_TOTVSINTEGRATOR:_MESSAGE:_LAYOUTS:_VERSION:TEXT ,;
							  oXml:_TOTVSINTEGRATOR:_MESSAGE:_LAYOUTS:_FUNCTIONCODE:TEXT,;
							  cXmlCont  )
			oFWEAI:SetTypeMessage( EAI_MESSAGE_MVC )
			oFWEAI:SetSendChannel(EAI_CHANNEL_EAI) // EAI_CHANNEL_ESB= ESB | EAI_CHANNEL_EAI= EAI
			oFWEAI:CUUID:= oXml:_TOTVSINTEGRATOR:_DOCIDENTIFIER:TEXT
			oFWEAI:SetType("0")
			oFWEAI:Activate()  
			
			If oFWEAI:Save()
				cXmlRet:= oFWEAI:cResult
			else
				cXmlRet+= '<TOTVSIntegrator>'+CRLF
				cXmlRet+= '	<DATA>'+cData+'</DATA>'+CRLF
				cXmlRet+= '	<HORA>'+cHora+'</HORA>'+CRLF
				cXmlRet+= '	<LOGMASTER modeltype="FIELDS">'+CRLF
				cXmlRet+= '		<RETORNO>1</RETORNO>'+CRLF	    	       
				cXmlRet+= '		<MOTIVO>'+oFWEAI:cResult+'</MOTIVO>'+CRLF
				cXmlRet+= '	</LOGMASTER>'+CRLF
				cXmlRet+= '	<GlobalDocumentFunctionCode>FSERVICE</GlobalDocumentFunctionCode>'+CRLF
				cXmlRet+= '	<GlobalDocumentFunctionDescription>Integracao Fluig</GlobalDocumentFunctionDescription>'+CRLF
				cXmlRet+= '</TOTVSIntegrator>'+CRLF				  	
			EndIf  
			
			oFWEAI:Deactivate()
			
			// Gera registro de Envio 
			oFWEAI:= FWEAI():New()
			oFWEAI:SetFuncCode( oXml:_TOTVSINTEGRATOR:_MESSAGE:_LAYOUTS:_IDENTIFIER:TEXT )
			oFWEAI:SetFuncDescription(oXml:_TOTVSINTEGRATOR:_GLOBALDOCUMENTFUNCTIONDESCRIPTION:TEXT)
			oFWEAI:SetDocType(PROC_ASYNC) 		// PROC_SYNC = Sincrono | PROC_ASYNC = Assincrono
			oFWEAI:AddLayout( oXml:_TOTVSINTEGRATOR:_MESSAGE:_LAYOUTS:_IDENTIFIER:TEXT ,;
							  oXml:_TOTVSINTEGRATOR:_MESSAGE:_LAYOUTS:_VERSION:TEXT ,;
							  oXml:_TOTVSINTEGRATOR:_MESSAGE:_LAYOUTS:_FUNCTIONCODE:TEXT,;
							  cXmlRet  )
			oFWEAI:SetTypeMessage( EAI_MESSAGE_MVC )
			oFWEAI:SetSendChannel(EAI_CHANNEL_EAI) // EAI_CHANNEL_ESB= ESB | EAI_CHANNEL_EAI= EAI			
			oFWEAI:SetType("1")
			oFWEAI:Activate()
			
			If oFWEAI:Save()
				oFWEAI:OpenTable()
				RECLOCK("XX3",.F.)
					XX3_TPDOC	:= "1"
					XX3_STATUS	:= "2"
				MSUNLOCK()
			endif
			
			oFWEAI:Deactivate()  
			::OUTMSG:= cXmlRet		  		 
		END SEQUENCE	
		
		ErrorBlock(oLastError)
		
		IF !lErro .and. !EMPTY(cErroBlk)	
			lErro:= .t.   
			DisarmTransaction()
			cMsg:= cErroBlk 
		ENDIF
	END TRANSACTION	
endif	  
			 	
if lErro           
	cXmlRet+= '<TOTVSIntegrator>'+CRLF
	cXmlRet+= '	<DATA>'+cData+'</DATA>'+CRLF
	cXmlRet+= '	<HORA>'+cHora+'</HORA>'+CRLF
	cXmlRet+= '	<LOGMASTER modeltype="FIELDS">'+CRLF
	cXmlRet+= '		<RETORNO>1</RETORNO>'+CRLF	    	       
	cXmlRet+= '		<MOTIVO>'+cMsg+'</MOTIVO>'+CRLF
	cXmlRet+= '	</LOGMASTER>'+CRLF
	cXmlRet+= '	<GlobalDocumentFunctionCode>FSERVICE</GlobalDocumentFunctionCode>'+CRLF
	cXmlRet+= '	<GlobalDocumentFunctionDescription>Integracao Fluig</GlobalDocumentFunctionDescription>'+CRLF
	cXmlRet+= '</TOTVSIntegrator>'+CRLF
	::OUTMSG:= cXmlRet
endif     

CEMPANT:= cBakEmp
CFILANT:= cBakFil

Return(.T.)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ GETF3      บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Metodo de consulta padrใo								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/       
WSMETHOD GETF3 WSRECEIVE cF3,cFilPar WSSEND aDados WSSERVICE CIEE
LOCAL cKeySxb	:= ""
LOCAL aExtCamp	:= {}
LOCAL nCnt		:= 0   
LOCAL nItx		:= 0
LOCAL nLen		:= 0
local cTab		:= ""
local cTabX5	:= "" 
local cFiltro	:= ""
local lFilOk	:= .t.
local cF3Fluig	:= TRIM(GetMv("CI_F3FLUIG",.F.,"$$$$$$$"))
local cXml		:= ""
local cCampo	:= "" 
local cCapAux	:= ""
LOCAL nIdItemSXB:= 0 
LOCAL cError	:= ""   
LOCAL cWarning	:= "" 
LOCAL nCamps	:= 1

IF "SX5"$cF3     	 
	cF3		:= TRIM(cF3)
	cTabX5	:= RIGHT(cF3,2)
	cF3		:= LEFT(cF3,3) 
	cKeySxb:= PadR(cF3,Len( SXB->XB_ALIAS ))
ELSE
	cKeySxb:= PadR(cF3,Len( SXB->XB_ALIAS ))	
ENDIF 

AAdd(::aDados,WSClassNew("aRet"))
nItx:= LEN(::aDados) 
::aDados[nItx]:cXml:= cXml

IF cF3$cF3Fluig 
	::aDados[nItx]:lRet:= .t.
	::aDados[nItx]:cMsg:= ""
else
	::aDados[nItx]:lRet:= .f.
	::aDados[nItx]:cMsg:= "Consulta nใo liberada."	
endif 

if ::aDados[nItx]:lRet  
	
	dbSelectArea( "SXB" )
	dbSetOrder( 1 )
	SXB->(dbGOTOP())  
	SXB->(dbSeek(cKeySxb)) 
	while SXB->(!eof()) .and. SXB->(XB_ALIAS) == cKeySxb
		if SXB->XB_TIPO == "1"  
			cTab:= LEFT(SXB->XB_CONTEM,3)
		elseif SXB->XB_TIPO == "4" .AND. SXB->XB_SEQ== "01"
		
			AADD(aExtCamp,{ SXB->XB_DESCRI,;
							TRIM(SXB->XB_CONTEM),;
							"CAMP"+STRZERO(nCamps,2)})
			nCamps++								
		elseif SXB->XB_TIPO == "6"
			cFiltro:= TRIM(SXB->XB_CONTEM)
		endif	
	SXB->(dbskip())
	end  
	
	IF cTab=="SX5"   
		cFiltro	:= "SX5->X5_TABELA=='"+cTabX5+"'"  
	ENDIF 
	
	IF EMPTY(cFiltro)
		cFiltro:= ".T."
	ENDIF	
		
endif                                         
     
cXml += '<?xml version="1.0" encoding="UTF-8"?>'+CRLF      
cXml+= '		<SXB>'+CRLF 
if ::aDados[nItx]:lRet .and. !empty(aExtCamp) 
	cXml+= '		   <HEADER>'+CRLF 
	
	FOR nCnt:= 1 to len(aExtCamp)	
		if !empty(aExtCamp[nCnt]) 
			cXml+= '		          <'+aExtCamp[nCnt][3]+'>'+ALLTRIM(EncodeUTF8( _NoTags(aExtCamp[nCnt][1])))+'</'+aExtCamp[nCnt][3]+'>'+CRLF 
		endif
	NEXT nCnt 	                      
	
	cXml+= '		   </HEADER>'+CRLF
endif 


if ::aDados[nItx]:lRet .and. !EMPTY(cTab) .and. !empty(aExtCamp)                                               	
	dbselectarea(cTab)
	(cTab)->(dbsetorder(1))
	(cTab)->(dbgotop())                                                                                         
	IF (cTab)->(!eof())                                                                                        
		cXml+= '		   <ACOLS>'+CRLF
		while (cTab)->(!eof())  
		    if &(cFiltro)   
		    	nIdItemSXB++
				cXml+= '		          <item id="'+strzero(nIdItemSXB,3)+'">'+CRLF						    			    		    			
		
				FOR nCnt := 1 TO len(aExtCamp) 
					//cCampo:= (cTab)->(aExtCamp[nCnt][2])
					//xValor:= (cTab)->&(cCampo)  
					xValor:= &(aExtCamp[nCnt][2]) 
					
					if valtype(xValor) == "C"
						xValor := TRIM(EncodeUTF8(_NoTags(xValor)))
					elseif valtype(xValor) == "N"
						xValor := ALLTRIM(Transform(xValor,"@E 999,999,999.99"))
					elseif valtype(xValor) == "D"
						xValor := Dtoc(xValor)
					else
						xValor := ""				
					endif
				
					cXml+= '		              <'+aExtCamp[nCnt][3]+'>'+xValor+'</'+aExtCamp[nCnt][3]+'>'+CRLF
											 										                        				 											
				NEXT nCnt  
				cXml+= '		          </item>'+CRLF
			endif	 	
		(cTab)->(dbskip())
		end 
		cXml+= '		   </ACOLS>'+CRLF		
		cXml+= '		</SXB>'+CRLF      
	else                     
		cXml+= '		   <ACOLS>'+CRLF	
		cXml+= '		   </ACOLS>'+CRLF		
		cXml+= '		</SXB>'+CRLF 	
		::aDados[nItx]:lRet:= .F.
		::aDados[nItx]:cMsg:= "Consulta nใo possui dados de retorno."	    
		::aDados[nItx]:cXml:= cXml
	endif 
else
	cXml:= ""
endif      



if nIdItemSXB > 0
	// Valida xml                  
	oXml := XmlParser(cXml, "_", @cError, @cWarning)
	
	if (Empty(cError) .and. Empty(cWarning))   	
		::aDados[nItx]:lRet:= .T. 
		::aDados[nItx]:cMsg:= ""
		::aDados[nItx]:cXml:= cXml
	else
		::aDados[nItx]:lRet:= .f.		
		::aDados[nItx]:cMsg:= ""
		::aDados[nItx]:cXml:= "" 
		
		if !Empty(cError) 
			::aDados[nItx]:cMsg:= "GETF3 - Erro na estrutura do xml"
	    endif
	
		if !Empty(cWarning)                        
			::aDados[nItx]:cMsg:= "GETF3 - "+cWarning
		endif    	
	endif 
endif

Return(.T.)