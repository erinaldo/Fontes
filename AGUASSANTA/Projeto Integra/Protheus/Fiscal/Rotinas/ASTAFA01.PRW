#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

/*{Protheus.doc} ASTAFA01 
Chamado do Ponto de Entrada SPDPCIMOB

@param		ParamIxb
@return		{aRetF200,aRetF205,aRetF210} 
@author 	Adriano da Silva de Deus
@since 		07/04/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
User Function ASTAFA01(ParamIxb)   

Local cParseURL		:= ALLTRIM(SuperGetMv("AS_RMURLWS",.T.,"http://localhost:8051")) + "/wsConsultaSQL/MEX?wsdl" 
Local cUserTOP		:= SuperGetMv("AS_RMUWS",.T.,"mestre") 
Local cPassTOP		:= SuperGetMv("AS_RMPWS",.T.,"totvs")
Local oWsdl			:= Nil
Local xRet			:= .F.
Local lRet			:= .T.
Local cRETSend		:= ""                   
Local aSimple		:= {}	
Local nX			:= 0
Local nY			:= 0
Local cErro			:= ""
Local cAviso		:= ""
Local aRetF200 		:= {}
Local aRetF205 		:= {}
Local aRetF210 		:= {}
Local nPosF200 		:= 0 
Local nPosF205 		:= 0  
Local nPosF210 		:= 0
Local oResult		:= Nil
Local aResultVld	:= {}
Local cResultTAF 	:= ""
Local aDadosTAF 	:= {}
//-----------------------------------------------------------------------
// Cria o objeto da classe TWsdlManager
//-----------------------------------------------------------------------
oWsdl := TWsdlManager():New()

//-----------------------------------------------------------------------
// Faz o parse de uma URL
//-----------------------------------------------------------------------
xRet := oWsdl:ParseURL( cParseURL )
IF xRet == .F.
	cRETSend 	:=  "Erro ao executar o ParseURL no endereço (" + cParseURL + "): " + oWsdl:cError 
	lRet 		:= .F.
ENDIF

//-----------------------------------------------------------------------
// Autenticacao
//-----------------------------------------------------------------------
IF lRet
	xRet := oWsdl:SetAuthentication( cUserTOP, cPassTOP )
	IF !xRet
		cRETSend 	:= "Não foi possível autenticar o usuário (" + cUserTOP + ") no serviço RM TOP: " + oWsdl:cError 
		lRet 		:= .F.
	ENDIF
ENDIF
//-----------------------------------------------------------------------
// Define a operação
//-----------------------------------------------------------------------
IF lRet
	xRet := oWsdl:SetOperation( "RealizarConsultaSQL" )
	IF !xRet
		cRETSend 	:= "Não foi possível definir a operação: " + oWsdl:cError 
		lRet 		:= .F.
	ENDIF		
ENDIF

//-----------------------------------------------------------------------
// Define os parametros
//-----------------------------------------------------------------------
IF lRet
	aSimple := oWsdl:SimpleInput()

	FOR nX := 1 TO LEN(aSimple)
		nID		:= aSimple[nX][1]
		cNome	:= aSimple[nX][2]
		IF UPPER(ALLTRIM(cNome)) == "CODSENTENCA"
			oWsdl:SetValue( nID, "TAFRM" )
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "CODCOLIGADA"
			oWsdl:SetValue( nID, "0" )
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "CODSISTEMA"
			oWsdl:SetValue( nID, "X"  )
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "PARAMETERS"
			oWsdl:SetValue( nID, "" )
		ENDIF
	NEXT nX

	//-----------------------------------------------------------------------
	// Pega a mensagem SOAP que será enviada ao servidor
	//-----------------------------------------------------------------------
	cMsg := oWsdl:GetSoapMsg()

	//-----------------------------------------------------------------------
	// Envia uma mensagem SOAP personalizada ao servidor
	//-----------------------------------------------------------------------
	xRet := oWsdl:SendSoapMsg(cMsg)
	IF !xRet
		cRETSend	:= "Não foi possível enviar a mensagem ao serviço RM TOP: " + oWsdl:cError
		lRet 		:= .F.
	ENDIF
ENDIF
    
//-----------------------------------------------------------------------
// Pega a mensagem de resposta
//-----------------------------------------------------------------------
IF lRet
	
	//Resposta do serviço em objeto
	cXML := oWsdl:GetSoapResponse()
	cXML := STRTRAN(cXML, "&lt;", "<")
	cXML := STRTRAN(cXML, "&gt;", ">")
	cXML := STRTRAN(cXML, "&#xD;", "")
    
    //Convertendo a resposta do serviço em objeto através do XmlParser.
    oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
    
    //Transforma Objeto em Array para depois verificar o Objeto _REALIZARCONSULTASQLRESULT
	aResultVld := ClassDataArr(oResult:_S_ENVELOPE:_S_BODY:_REALIZARCONSULTASQLRESPONSE:_REALIZARCONSULTASQLRESULT:_NEWDATASET)                                   
	
	//Verifica se o Objeto _REALIZARCONSULTASQLRESULT Existe
	If ( nPos := aScan(aResultVld,{|x| Alltrim(x[1]) == "_RESULTADO" }) ) > 0
    
	    aResultTAF := oResult:_S_ENVELOPE:_S_BODY:_REALIZARCONSULTASQLRESPONSE:_REALIZARCONSULTASQLRESULT:_NEWDATASET:_RESULTADO 
		
		For nY:=1 To Len(aResultTAF)
			
			cResultTAF := SubStr(aResultTAF[nY]:_TAFMSG:TEXT,2,Len(aResultTAF[nY]:_TAFMSG:TEXT))
	        aDadosTAF := StrTokArr2(cResultTAF,"|",.T.)
			
			If AllTrim(aDadosTAF[1]) == "T033"
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³REGISTRO F200 - Sera gerado 1 para cada F010 do SpedPisCofins³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				Aadd(aRetF200,{})  			
							
				Aadd(aRetF200[nY],"F200") 				//01-REG                                
				Aadd(aRetF200[nY],aDadosTAF[2]) 		//02-IND_OPER                               
				Aadd(aRetF200[nY],aDadosTAF[3])			//03-UNID_IMOB                               
				Aadd(aRetF200[nY],aDadosTAF[4])			//04-IDENT_EMP                               
				Aadd(aRetF200[nY],aDadosTAF[5])			//05-DESC_UNID_IMOB                                
				Aadd(aRetF200[nY],aDadosTAF[6]) 		//06-NUM_CONT                               
				If !Empty(AllTrim(aDadosTAF[7]))
					Aadd(aRetF200[nY],aDadosTAF[7]) 	//07-CPF_CNPJ_ADQU                                
				Else
					Aadd(aRetF200[nY],aDadosTAF[8]) 	//07-CPF_CNPJ_ADQU 
				EndIf
				Aadd(aRetF200[nY],aDadosTAF[9])  		//08-DT_OPER                               
				Aadd(aRetF200[nY],Val(aDadosTAF[10]))  	//09-VL_TOT_VEND                               
				Aadd(aRetF200[nY],Val(aDadosTAF[11]))  	//10-VL_REC_ACUM
				Aadd(aRetF200[nY],Val(aDadosTAF[12])) 	//11-VL_TOT_REC 
				Aadd(aRetF200[nY],aDadosTAF[13])		//12-CST_PIS
				Aadd(aRetF200[nY],Val(aDadosTAF[14])) 	//13-VL_BC_PIS
				Aadd(aRetF200[nY],Val(aDadosTAF[15])) 	//14-ALIQ_PIS
				Aadd(aRetF200[nY],Val(aDadosTAF[16])) 	//15-VL_PIS
				Aadd(aRetF200[nY],aDadosTAF[17]) 		//16-CST_COFINS
				Aadd(aRetF200[nY],Val(aDadosTAF[18])) 	//17-VL_BC_COFINS
				Aadd(aRetF200[nY],Val(aDadosTAF[19]))  	//18-ALIQ_COFINS                               
				Aadd(aRetF200[nY],Val(aDadosTAF[20]))	//19-VL_COFINS
				Aadd(aRetF200[nY],Val(aDadosTAF[21])) 	//20-PERC_REC_RECEB
				Aadd(aRetF200[nY],aDadosTAF[22]) 		//21-IND_NAT_EMP
				Aadd(aRetF200[nY],aDadosTAF[23])		//22-INF_COMP
				Aadd(aRetF200[nY],"0") 					//Informa se o registro eh de regime cumulativo (0) ou nao cumulativo (1)
				
			ElseIf AllTrim(aDadosTAF[1]) == "T033AB"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ                   
				//³REGISTRO F205 - Sera Gerado 1 para cada registro F200³                   
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ                
				Aadd(aRetF205,{})                
				
				Aadd(aRetF205[nY],Len(aRetF200)) 		//Referencia do registro F200 Pai                
				Aadd(aRetF205[nY],"F205")  				//01-REG
				Aadd(aRetF205[nY],Val(aDadosTAF[02])) 	//02-VL_CUS_INC_ACUM_ANT                 
				Aadd(aRetF205[nY],Val(aDadosTAF[03])) 	//03-VL_CUS_INC_PER_ESC                 
				Aadd(aRetF205[nY],Val(aDadosTAF[04])) 	//04-VL_CUS_INC_ACUM                
				Aadd(aRetF205[nY],Val(aDadosTAF[05])) 	//05-VL_EXC_BC_CUS_INC_ACUM                 
				Aadd(aRetF205[nY],Val(aDadosTAF[06])) 	//06-VL_BC_CUS_INC                
				Aadd(aRetF205[nY],aDadosTAF[07]) 		//07-CST_PIS                 
				Aadd(aRetF205[nY],Val(aDadosTAF[08])) 	//08-ALIQ_PIS                 
				Aadd(aRetF205[nY],Val(aDadosTAF[09]))  	//09-VL_CRED_PIS_ACUM                
				Aadd(aRetF205[nY],Val(aDadosTAF[10]))  	//10-VL_CRED_PIS_DESC_ANT                
				Aadd(aRetF205[nY],Val(aDadosTAF[11]))  	//11-VL_CRED_PIS_DESC                 
				Aadd(aRetF205[nY],Val(aDadosTAF[12])) 	//12-VL_CRED_PIS_DESC_FUT                 
				Aadd(aRetF205[nY],aDadosTAF[13])	  	//13-CST_COFINS                 
				Aadd(aRetF205[nY],Val(aDadosTAF[14]))  	//14-ALIQ_COFINS                
				Aadd(aRetF205[nY],Val(aDadosTAF[15])) 	//15-VL_CRED_COFINS_ACUM                 
				Aadd(aRetF205[nY],Val(aDadosTAF[16])) 	//16-VL_CRED_COFINS_DESC_ANT                 
				Aadd(aRetF205[nY],Val(aDadosTAF[17])) 	//17-VL_CRED_COFINS_DESC                 
				Aadd(aRetF205[nY],Val(aDadosTAF[18])) 	//18-VL_CRED_COFINS_DESC_FUT                                    
				
			ElseIf AllTrim(aDadosTAF[1]) == "T033AC"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ                   
				//³REGISTRO F210 - Gerados N registros para cada F200       ³                   
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ                
				Aadd(aRetF210,{})                                                                       
				
				Aadd(aRetF210[nY],Len(aRetF200)) 		//Referencia do registro F200 Pai                
				Aadd(aRetF210[nY],"F210") 				//01-REG                 
				Aadd(aRetF210[nY],Val(aDadosTAF[02])) 	//02-VL_CUS_ORC                
				Aadd(aRetF210[nY],Val(aDadosTAF[03])) 	//03-VL_EXC                
				Aadd(aRetF210[nY],Val(aDadosTAF[04]))  	//04-VL_CUS_ORC_AJU                
				Aadd(aRetF210[nY],Val(aDadosTAF[05])) 	//05-VL_BC_CRED                
				Aadd(aRetF210[nY],aDadosTAF[06])	 	//06-CST_PIS                
				Aadd(aRetF210[nY],Val(aDadosTAF[07]))  	//07-ALIQ_PIS
				Aadd(aRetF210[nY],Val(aDadosTAF[08])) 	//08-VL_CRED_PIS_UTIL                 
				Aadd(aRetF210[nY],aDadosTAF[09]) 		//09-CST_COFINS                
				Aadd(aRetF210[nY],Val(aDadosTAF[10]))  	//10-ALIQ_COFINS
				Aadd(aRetF210[nY],Val(aDadosTAF[11]))  	//11-VL_CRED_COFINS_UTIL
	
			EndIf
					
		Next
	
	EndIf
	
Else
	IF !Empty(cRETSend)
		ApMsgAlert( cRETSend, "Atenção" )
	EndIf
EndIf

Return({aRetF200,aRetF205,aRetF210})