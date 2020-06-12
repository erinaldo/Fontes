#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CIWSINT
Rotina de integração com web sevice de ambos os ambientes - ORIGINAL e PRODUCAO
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
//TODO - Necessario aplicar Web Service WSCIEE01 no ambiente 
//TODO - Retirar após segunda fase do projeto, apenas para atender a integração entre ambiente ORIGINAL e PRODUCAO
User Function CIWSINT(cXml)
Local cError   	:= ""
Local cWarning 	:= ""
Local cDelimit 	:= "_"
local cRet			:= ""

IF !EMPTY(cXml)
	// O WS já faz o parse do xml
	oWsCiee:= WSCIEE():NEW()
	IF oWsCiee:FSERVICE(cXml)
		cXml:= alltrim(EncodeUTF8(oWsCiee:CFSERVICERESULT)) 
		
		IF !EMPTY(cXml)		
			oXml := XmlParser(cXml, cDelimit, @cError, @cWarning)
			if !(Empty(cError) .and. Empty(cWarning))
				msgalert(oXml:_TOTVSINTEGRATOR:_LOGMASTER:_MOTIVO:TEXT)
			else
				if oXml:_TOTVSINTEGRATOR:_LOGMASTER:_RETORNO:TEXT == "1"
					msgalert(oXml:_TOTVSINTEGRATOR:_LOGMASTER:_MOTIVO:TEXT)
				else
					if oXml:_TOTVSINTEGRATOR:_GLOBALDOCUMENTFUNCTIONCODE:TEXT == "CORIGA02"
						cRet:= oXml:_TOTVSINTEGRATOR:_ID:TEXT
					EndIf
					
					MSGINFO(oXml:_TOTVSINTEGRATOR:_LOGMASTER:_MOTIVO:TEXT)
				endif					
			Endif
		else
			msgalert("Não houve retorno da integração.")	
		Endif
	ENDIF
ENDIF

Return cRet
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CIXCONV
Realiza a conversão dos dados e montagem do xml
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CIXCONV(cTab,cCampo,cXML) 
Local xValor		:= nil 
Local cNoCamps	:= ""
Local aDePara		:= {}
Local nPosCmp		:= 0

cCampo:= ALLTRIM(cCampo)

DO CASE
	
	CASE cTab == "SB1"
		// Campos desconsiderados na integração	
		cNoCamps:= "B1_USERLGI,B1_USERLGA,B1_CONTA,B1_TE,B1_TS"
		
		// Monta array de-para
		AADD(aDePara,{"B1_ESPEC","B1_XESPEC"})
		AADD(aDePara,{"B1_CONMED","B1_XCONMED"})
		AADD(aDePara,{"B1_EMIND","B1_XEMIND"})
		AADD(aDePara,{"B1_PEQ","B1_XPEQ"})
		AADD(aDePara,{"B1_DIASEG","B1_XDIASEG"})
		AADD(aDePara,{"B1_LED","B1_XLED"})
		AADD(aDePara,{"B1_BLQSAI","B1_XBLQSAI"})
		AADD(aDePara,{"B1_BLOENT","B1_XBLOENT"})
		AADD(aDePara,{"B1_OBSER","B1_XOBSER"})
		AADD(aDePara,{"B1_SDATU","B1_XSDATU"})
		AADD(aDePara,{"B1_SDPED","B1_XSDPED"})
		AADD(aDePara,{"B1_SDSOL","B1_XSDSOL"})
		AADD(aDePara,{"B1_AUTSC","B1_XAUTSC"})
		AADD(aDePara,{"B1_ARRED","B1_XARRED"})
		AADD(aDePara,{"B1_FATARR","B1_XFATARR"})
		AADD(aDePara,{"B1_JAN","B1_XJAN"})
		AADD(aDePara,{"B1_FEV","B1_XFEV"})
		AADD(aDePara,{"B1_MAR","B1_XMAR"})
		AADD(aDePara,{"B1_ABR","B1_XABR"})
		AADD(aDePara,{"B1_MAI","B1_XMAI"})
		AADD(aDePara,{"B1_JUN","B1_XJUN"})
		AADD(aDePara,{"B1_JUL","B1_XJUL"})
		AADD(aDePara,{"B1_AGO","B1_XAGO"})
		AADD(aDePara,{"B1_SET","B1_XSET"})
		AADD(aDePara,{"B1_OUT","B1_XOUT"})
		AADD(aDePara,{"B1_NOV","B1_XNOV"})
		AADD(aDePara,{"B1_DEZ","B1_XDEZ"})
		AADD(aDePara,{"B1_LOCAL","B1_XLOCAL"})
		AADD(aDePara,{"B1_MULTI","B1_XMULTI"})
		AADD(aDePara,{"B1_ATIVO","B1_XATIVO"})
		AADD(aDePara,{"B1_UNIFRH","B1_XUNIFRH"})	

	CASE cTab == "SBM"
	
		// Campos desconsiderados na integração	
		cNoCamps:= "BM_XTES,BM_CONTA1,BM_CONTA2,BM_CREDUZ1,BM_CREDUZ2"		
		
		AADD(aDePara,{"BM_ESTSEGD","BM_XDIASEG"})
		AADD(aDePara,{"BM_PE","BM_XPE"})

	CASE cTab == "SA2"
		// Campos desconsiderados na integração	
		cNoCamps:= "A2_CONTA"
		
		// Monta array de-para
		AADD(aDePara,{"A2_XPISNIT","A2_XPISNIT"})
		AADD(aDePara,{"A2_TPFOR","A2_XTPFOR"})
		AADD(aDePara,{"A2_CELULAR","A2_XCEL"})
		AADD(aDePara,{"A2_TELFIN","A2_XTELFI"})
		AADD(aDePara,{"A2_CONTFIN","A2_XCONTFI"})
		AADD(aDePara,{"A2_PROSPEC","A2_XPROSPE"})
		AADD(aDePara,{"A2_DVAG","A2_XDVAG"})
		AADD(aDePara,{"A2_CCPOUPA","A2_XCCPOUP"})
		AADD(aDePara,{"A2_FORPGTO","A2_XFORPGT"})
		AADD(aDePara,{"A2_CONDDES","A2_XCONDDE"})
		AADD(aDePara,{"A2_REDUZ","A2_XREDUZ"})
		AADD(aDePara,{"A2_OBSERV","A2_XOBSERV"})
		AADD(aDePara,{"A2_VRACUMR","A2_XVRACUR"})
		AADD(aDePara,{"A2_MATRASO","A2_XMAXATR"})
		AADD(aDePara,{"A2_DATAREF","A2_XDATREF"})
		AADD(aDePara,{"A2_MEDATR","A2_XMEDATR"})
		AADD(aDePara,{"A2_VRACUMD","A2_XVRACUD"})
		AADD(aDePara,{"A2_ATRDIAS","A2_XATRDIA"})
		AADD(aDePara,{"A2_PERCDES","A2_XPERDES"})
		AADD(aDePara,{"A2_VLRDESC","A2_XVLRDES"})
		AADD(aDePara,{"A2_PERCONC","A2_XPERCON"})
		AADD(aDePara,{"A2_GRUPO1","A2_XGRP01"})
		AADD(aDePara,{"A2_GRUPO2","A2_XGRP02"})
		AADD(aDePara,{"A2_GRUPO3","A2_XGRP03"})
		AADD(aDePara,{"A2_PRODUTO","A2_XPRODUT"})
		AADD(aDePara,{"A2_QTDCOT","A2_XQTDCOT"})
		AADD(aDePara,{"A2_CONV","A2_XCONV"})
		AADD(aDePara,{"A2_QTDCOTV","A2_XQTDCOT"})
		AADD(aDePara,{"A2_ESTNUM","A2_XESTNUM"})
		AADD(aDePara,{"A2_DATAUC","A2_XDTAUC"})
		AADD(aDePara,{"A2_VALORUC","A2_XVLRUC"})
		AADD(aDePara,{"A2_MCOMP","A2_XMCOMP"})
		AADD(aDePara,{"A2_COTVEN1","A2_XCOTVE1"})
		AADD(aDePara,{"A2_COTVEN2","A2_XCOTVE2"})
		AADD(aDePara,{"A2_MDESC","A2_XMDESC"})
		AADD(aDePara,{"A2_DESCUC","A2_XDESCUC"})
		AADD(aDePara,{"A2_ATRASUC","A2_XATRUC"})
		AADD(aDePara,{"A2_UNIDFAT","A2_XUNIFAT"})				
		
	
	CASE cTab == "SE4"		
		
		// Campos desconsiderados na integração	
		cNoCamps:= "E4_FATOR"
	
	CASE cTab == "SC7"
	
		// Campos desconsiderados na integração	
		cNoCamps:= "C7_CONTA,C7_CC,C7_ITEMCTA,C7_EC05DB,C7_EC05CR"		
		
		// Monta array de-para
		AADD(aDePara,{"C7_XESPEC","C7_ESPEC"})
		AADD(aDePara,{"C7_XTOTCUS","C7_TOTCUS"})
	
	CASE cTab == "SE2"
	
		// Campos desconsiderados na integração	
		cNoCamps:= "E2_FILIAL,E2_FILORIG"		
		
		

ENDCASE	

// Verifica campos que não serão integrados
if cCampo$cNoCamps
	xValor:= ""
else
 	xValor:= &(cTab+"->"+cCampo)
 	
 	IF cCampo == "B1_ESPEC"
 		IF "&"$xValor
 			xValor:= strTran(xValor,"&","{E}") // ajuste para retornar após entegração --> Gerar erro xml
 		Endif
 	ElseIF "ED_PERC"$cCampo .and. !"IOF"$cCampo
 		IF	&(cTab+"->ED_CALC"+SUBSTR(cCampo,8,LEN(cCampo))) == "N"
 			xValor:= 0
 		END
 	ElseIF cCampo == "C7_CONTRA"
 		IF EMPTY(xValor) 
 			xValor:= CN9->CN9_NUMERO
 		ENDIF
 	ElseIF cCampo == "E2_TIPO" .OR. cCampo == "E2_PREFIXO"
 			xValor:= "CL"
 	Endif
	
	if valtype(xValor) == "C"		
		xValor := ALLTRIM(xValor)
	elseif valtype(xValor) == "N"
		xValor := ALLTRIM(CVALTOCHAR(xValor))
	elseif valtype(xValor) == "D"
		xValor := Dtos(xValor)
	else
		xValor := ""				
	endif		
endif

// Adiciona apenas campos com valores
IF !EMPTY(xValor)
	// Realiza o de-para dos campos
	IF !EMPTY(aDePara)
		if (nPosCmp:= ASCAN(aDePara,{|x| TRIM(x[1]) == TRIM(cCampo) })) > 0
			cCampo:= aDePara[nPosCmp][2]
		endif	
	ENDIF
	cXML += '<'+ cCampo +'><value>'+ xValor +'</value></'+ cCampo +'>'
ENDIF	

return
