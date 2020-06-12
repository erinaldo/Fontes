#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "TopConn.CH"


/*/{Protheus.doc} EST552
//TODO Rotina para Procresssar o Inventário
@author Mario L. B. Faria
@since 30/07/2018
@version 1.0
/*/
User Function EST552()

	Local aArea := GetArea()
	
	Processa({ || PROCSB7() },"Aguarde, Processando Inventário...")
	
	RestArea(aArea)
	
Return

/*/{Protheus.doc} PROCSB7
//TODO Processa o invetário
@author Mario L. B. Faria
@since 30/07/2018
@version 1.0
/*/
Static Function PROCSB7()

	Local cQuery	:= ""
	Local cAlQry	:= ""
	Local cModAux	:= nModulo
	Local cDtaAux	:= dDataBase
	Local nRecnoZA0	:= 0
	Local nTotZ05	:= 0
	Local nTotSE1	:= 0
	Local aValid	:= {}
	Local lBlocZ23	:= .F.
	Local aDtaZWE	:= {}
	Local lErrProc	:= .F.
	Local cMsgFim	:= "Inventário: " + Z23->Z23_ID + " processado com sucesso."

	
	ProcRegua(0)

	cQuery := "	SELECT " + CRLF 
	cQuery += "	    Z23.R_E_C_N_O_ Z23_REGNO " + CRLF
	cQuery += "	FROM " + RetSqlName("Z23") + " Z23 " + CRLF 
	cQuery += "	WHERE " + CRLF  
	cQuery += "	        Z23_FILIAL     = '" + xFilial("Z23") + "'  " + CRLF
	cQuery += "	    AND Z23_DATA       = '" + DtoS(dDataBase) + "' " + CRLF 
	cQuery += "	    AND Z23_DTCONF    != ' ' " + CRLF 
	cQuery += "	    AND Z23_DTPROC     = ' ' " + CRLF
	cQuery += "	    AND Z23.D_E_L_E_T_ = ' ' " + CRLF 

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)
	
	dbSelectArea("ZA0")
	dbSelectArea("Z05")
	dbSelectArea("Z23")
	
	If (cAlQry)->(Eof())
		Help("",1,"Processamento Inventário",,"Não ha dados para processamento na data",4,1)
		lErrProc := .T.
	Else
	
		nModulo := 4
    
	    While !(cAlQry)->(Eof())
	    
	    	Begin Transaction
	    
				Z23->(dbGoTo((cAlQry)->Z23_REGNO))
			    dDataBase := Z23->Z23_DATA	    
		    	
		    	//Bloqueia o registro
		    	RecLock("Z23",.F.)
		    	lBlocZ23 := .T.
		    	
		    	//Verifica Centro de Custo ZA0
		    	nRecnoZA0 := VerZA0()
		    	
		    	If nRecnoZA0 == 0
					Help("",1,"Processamento Inventário",,"Não ha Centro de Custo para a filial: " + cFilAnt,4,1)
					lErrProc := .T.	
					DisarmTransaction()
				Else
					    	
		    		ValFecha(@aValid, @aDtaZWE)
	    			
	    			//Verifica e ajusta aValid
	    			MostraZWE(aValid, aDtaZWE, @lBlocZ23)	    		
	
		    		If Len(aVAlid) == 0
		    		
		    			lErrProc := ProcInv(@aValid)
		    			
		    			ValPrcInv(@aValid)	
	
		    			//Se houve registro não processado, mostra tela
		    			//Verifica e ajusta aValid
		    			MostraZWE(aValid, aDtaZWE, @lBlocZ23)	
	    			
		    			//Grava processamento na Z23
		    			If Len(aValid) == 0 .And. !lErrProc
		    				Z23->Z23_DTPROC := dDataBase
		    				Z23->Z23_HRPROC := Time()
		    				Z23->Z23_USERPR := UsrRetName(RetCodUsr())
		    			Else
		    				DisarmTransaction()
		    			EndIf
		    			
		    		Else
		    			DisarmTransaction()	
		    		EndIf
		
		    	EndIf
	
		    	//Verifica desbloqueio Z23
		    	DesbZ23(@lBlocZ23)

	    	End Transaction

	    	(cAlQry)->(dbSkip())
	    
	    EndDo
	    
	EndIf

	(cAlQry)->(dbCloseArea())
	
	nModulo		:= cModAux
	dDataBase	:= cDtaAux

	If Len(aValid) > 0 .Or. lErrProc
		cMsgFim := "Inventário: " + Z23->Z23_ID + " com erro de processamento."
	EndIf

	Help("",1,"Processamento Inventário",,cMsgFim,4,1)

Return

/*/{Protheus.doc} DesbZ23
//TODO Efetuao desbloqueio da Z23
@author Mario L. B. Faria
@since 30/07/2018
@version 1.0n}
@param lBlocZ23, logical, Indica se o registro esta ou não bloqueado
/*/
Static Function DesbZ23(lBlocZ23)
	If lBlocZ23
    	Z23->(MSUnlock())
		lBlocZ23 := .F.
	EndIf
Return

/*/{Protheus.doc} VerZA0
//TODO Verifica se possui cadastrado para filial
@author Mario L. B. Faria
@since 30/07/2018
@version 1.0
@return ${return}, Recno do registro
/*/
Static Function VerZA0()

	Local nRet		:= 0
	Local cQuery	:= ""
	Local cAlQry	:= ""	

	cQuery := "	SELECT ZA0.R_E_C_N_O_ ZA0_REGNO " + CRLF
	cQuery += "	FROM " + RetSqlName("ZA0") + " ZA0 " + CRLF
	cQuery += "	WHERE " + CRLF
	cQuery += "			ZA0_FILIAL = '" + xFilial("ZA0") + "' " + CRLF
	cQuery += "		AND ZA0_FILCC  = '" + Z23->Z23_FILIAL +  "' " + CRLF 
	cQuery += "		AND ZA0.D_E_L_E_T_ = ' ' " + CRLF

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)
	
	If !(cAlQry)->(Eof())
		nRet := (cAlQry)->ZA0_REGNO
	EndIf
	
	(cAlQry)->(dbCloseArea())

Return nRet

/*/{Protheus.doc} ValFecha
//TODO Valida se existe fechametno e se as vendas foram integradas
@author Mario L. B. Faria
@since 30/07/2018
@version 1.0
@return ${return}, ${return_description}
@param aValid, array, Array com erros encontrados e/eu ja gravados
@param aDtaZWE, array,  [01] - Data Final
						[02] - Data Inicial
/*/
Static Function ValFecha(aValid, aDtaZWE)

	Local nRetroa	:= SuperGetMv("MD_DIARET",.F.,6)
	Local dDtaAux	:= dDataBase
	
	Local nTotZ05	:= 0
	Local nTotSE1	:= 0
	Local nX		:= 0
	Local cMsg		:= ""
	Local cProces	:= "Inventário - Fechamento Caixa"
	Local cEntid	:= "Z23-1"
	Local cTipo		:= "E"
	
	aAdd(aDtaZWE,DtoS(dDataBase))

	For nX := 0 to nRetroa

		IncProc("Data: " + DtoC(dDataBase))

		//Verifica se possui ZWE para a data
		VerZWE(@aValid)
		
		If Len(aValid) == 0

			nTotZ05 := 0
			nTotSE1 := 0
			
			//Fechamento de caixa Z05
		    nTotZ05 := VerZ05()
		    
		    If nTotZ05 == 0
		    
		    	cMsg := "Não existe fechamento de caixa. Data: " + DtoC(dDataBase) + ". Filial: " + cFilAnt
		    	aAdd(aValid,	{;
			    					Z23->Z23_FILIAL,;	//[01] - ZWE_FILIAL
			    					cProces,;			//[02] - ZWE_PROCES
			    					dDataBase,;			//[03] - ZWE_DATA
			    					Z23->Z23_ID,;		//[04] - ZWE_ID
			    					cEntid,;			//[05] - ZWE_ENTID
			    					cTipo,;				//[06] - ZWE_TIPO
			    					0,;					//[07] - ZWE_VALOR
			    					cMsg,;				//[08] - ZWE_DESC
			    					.T.;				//[09] - .T. = Grava na ZWE -- .F. Não grava na ZWE
		    					})
//				Help("",1,"Processamento Inventário",,cMsg,4,1)
		    Else
		    
		    	//Verifica SE1
		    	nTotSE1 := VerSE1()
		    	 
			    If nTotZ05 != nTotSE1
			    	cMsg := "Não foram integradas todas as vendas para o dia " + DtoC(dDataBase) + ", favor verificar. [" +;
						 	"Caixa da unidade = " + Alltrim(Transform(nTotZ05,PesqPict("Z05","Z05_VALOR"))) + " / " +;
						 	"Financeiro: " + Alltrim(Transform(nTotSE1,PesqPict("SE1","E1_VALOR"))) + "]"
			    	aAdd(aValid,	{;
				    					Z23->Z23_FILIAL,;	//[01] - ZWE_FILIAL
				    					cProces,;			//[02] - ZWE_PROCES
				    					dDataBase,;			//[03] - ZWE_DATA
				    					Z23->Z23_ID,;		//[04] - ZWE_ID
				    					cEntid,;			//[05] - ZWE_ENTID
				    					cTipo,;				//[06] - ZWE_TIPO
				    					0,;					//[07] - ZWE_VALOR
				    					cMsg,;				//[08] - ZWE_DESC
				    					.T.;				//[09] - .T. = Grava na ZWE -- .F. Não grava na ZWE
			    					})
//					Help("",1,"Processamento Inventário",,cMsg + cFilAnt,4,1)	
	
				EndIf	    
		
			EndIf
			
		EndIf
		
		dDataBase -= 1
		
	Next nX
	
	aAdd(aDtaZWE,DtoS(dDataBase))
	
	dDataBase := dDtaAux

Return

/*/{Protheus.doc} VerZWE
//TODO Verifica se possui ZWE ja gravada para a date e inclui no aValid
@author Mario L. B. Faria
@since 30/07/2018
@version 1.0
@param aValid, array, Array com erros encontrados e/eu ja gravados
/*/
Static Function VerZWE(aValid)

	Local cQuery	:= ""
	Local cAlQry	:= ""	
	
	cQuery := "	SELECT " + CRLF   
	cQuery += "		ZWE_FILIAL, ZWE_PROCES, ZWE_DATA, ZWE_ID, " + CRLF   
	cQuery += "		ZWE_ENTID, ZWE_TIPO, ZWE_VALOR, ZWE_DESC " + CRLF  
	cQuery += "	FROM " + RetSqlName("ZWE") + " ZWE " + CRLF  
	cQuery += "	WHERE " + CRLF           
	cQuery += "			ZWE_FILIAL = '" + Z23->Z23_FILIAL +  "' " + CRLF  
	cQuery += "		AND ZWE_TIPO = 'E' " + CRLF  
	cQuery += "		AND ZWE_DATA = '" + DtoS(dDataBase) +  "' " + CRLF  
	cQuery += "		AND ZWE.D_E_L_E_T_ = ' ' " + CRLF  
	cQuery += "	ORDER BY " + CRLF  
	cQuery += "		ZWE_FILIAL, ZWE_PROCES, ZWE_DATA, ZWE_ENTID, ZWE_ID " + CRLF  

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)
	
	While!(cAlQry)->(Eof())
	
    	aAdd(aValid,	{;
	    					(cAlQry)->ZWE_FILIAL,;		//[01] - ZWE_FILIAL
	    					(cAlQry)->ZWE_PROCES,;		//[02] - ZWE_PROCES
	    					StoD((cAlQry)->ZWE_DATA),;	//[03] - ZWE_DATA
	    					(cAlQry)->ZWE_ID,;			//[04] - ZWE_ID
	    					(cAlQry)->ZWE_ENTID,;		//[05] - ZWE_ENTID
	    					(cAlQry)->ZWE_TIPO,;		//[06] - ZWE_TIPO
	    					(cAlQry)->ZWE_VALOR,;		//[07] - ZWE_VALOR
	    					(cAlQry)->ZWE_DESC,;		//[08] - ZWE_DESC
	    					.F.;						//[09] - .T. = Grava na ZWE -- .F. Não grava na ZWE
    					})		
	
		(cAlQry)->(dbSkip())
	
	EndDo
	
	(cAlQry)->(dbCloseArea())

Return

/*/{Protheus.doc} VerZ05
//TODO Verifica se existe fechamento de caixa
@author Mario L. B. Faria
@since 30/07/2018
@version 1.0
@return ${return}, Recno do registro
/*/
Static Function VerZ05()

	Local nRet		:= 0
	Local cQuery	:= ""
	Local cAlQry	:= ""	

	cQuery := "	SELECT COALESCE(SUM(Z05_VALOR),0) TOT_Z05 " + CRLF  
	cQuery += "	FROM " + RetSqlName("Z05") + " Z05 " + CRLF 
	cQuery += "	WHERE " + CRLF 
	cQuery += "			Z05_FILIAL = '" + Z23->Z23_FILIAL +  "' " + CRLF  
	cQuery += "		AND Z05_DATA   = '" + DtoS(dDataBase) +  "' " + CRLF 
	cQuery += "		AND Z05_COND  != ' ' " + CRLF 
	cQuery += "		AND Z05_DATAF != ' ' " + CRLF 
	cQuery += "		AND Z05.D_E_L_E_T_ = ' ' " + CRLF  
	
	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)
	
	If !(cAlQry)->(Eof())
		nRet := (cAlQry)->TOT_Z05
	EndIf
	
	(cAlQry)->(dbCloseArea())

Return nRet

/*/{Protheus.doc} VerSE1
//TODO Totalisa valores a receber para a data
@author Mario L. B. Faria
@since 30/07/2018
@version 1.0
@return nRet, numerico, total da venda
/*/
Static Function VerSE1()

	Local nRet		:= 0
	Local cQuery	:= ""
	Local cAlQry	:= ""	

	cQuery := "	SELECT COALESCE(SUM(E1_VALOR),0) TOT_SE1 " + CRLF  
	cQuery += "	FROM " + RetSqlName("SE1") + " SE1 " + CRLF  
	cQuery += "	WHERE " + CRLF   
	cQuery += "			E1_FILIAL   = '" + Z23->Z23_FILIAL +  "' " + CRLF  
	cQuery += "		AND E1_EMISSAO  = '" + DtoS(dDataBase) +  "' " + CRLF 
	cQuery += "		AND E1_XSEQVDA != ' ' " + CRLF  
	cQuery += "		AND E1_TIPO    != 'AB-' " + CRLF  
	cQuery += "		AND SE1.D_E_L_E_T_ = ' ' " + CRLF  
	
	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)
	
	If !(cAlQry)->(Eof())
		nRet := (cAlQry)->TOT_SE1
	EndIf
	
	(cAlQry)->(dbCloseArea())

Return nRet

/*/{Protheus.doc} VldGrvZWE
//TODO verifica se registro ja esta gravado na ZWE
@author Mario L. B. Faria
@since 30/07/2018
@version 1.0
@return lRet, Lógico, .T. ou .F.
@param cFilInv, characters, Filial
@param cPrcInv, characters, Processo
@param dDtaInv, date, Data
@param cIdinv, characters, ID
@param cEntInv, characters, entidade
/*/
Static Function VldGrvZWE(cFilInv, cPrcInv, dDtaInv, cIdinv, cEntInv)

	Local nRet	:= .T.
	Local cQuery	:= ""
	Local cAlQry	:= ""
	
	cQuery := "	SELECT COALESCE(R_E_C_N_O_,0) REGNO_ZWE " + CRLF  
	cQuery += "	FROM " + RetSqlName("ZWE") + " ZWE " + CRLF  
	cQuery += "	WHERE " + CRLF    
	cQuery += "	        ZWE_FILIAL = '" + cFilInv + "' " + CRLF   
	cQuery += "	    AND ZWE_PROCES = '" + cPrcInv + "' " + CRLF  
	cQuery += "	    AND ZWE_DATA   = '" + DtoS(dDtaInv) + "' " + CRLF  
	cQuery += "	    AND ZWE_ID     = '" + cIdinv + "' " + CRLF  
	cQuery += "	    AND ZWE_ENTID  = '" + cEntInv + "' " + CRLF  
	cQuery += "	    AND ZWE.D_E_L_E_T_ = ' ' " + CRLF  

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)
	
	nRet := (cAlQry)->REGNO_ZWE
	
	(cAlQry)->(dbCloseArea())

Return nRet

/*/{Protheus.doc} MostraZWE
//TODO Verifica se os dados do array aValid existem na ZWE caso não existam grava
@author Mario L. B. Faria
@since 30/07/2018
@version 1.0
@param aValid, array, dados para validação
@param aDtaZWE, array, Dada inicial e final para consulta ZWE
/*/
Static Function MostraZWE(aValid, aDtaZWE, lBlocZ23)

	Local nOpc		:= 0
	Local nRegnoZWE	:= 0
	Local aErro		:= {}

	//Relação aValid X ZWE
	//******************************
	//ZWE_FILIAL	:= aValid[id,01]
	//ZWE_PROCES	:= aValid[id,02]
	//ZWE_DATA		:= aValid[id,03]
	//ZWE_ID		:= aValid[id,04]
	//ZWE_ENTID		:= aValid[id,05]
	//ZWE_TIPO		:= aValid[id,06]
	//ZWE_VALOR		:= aValid[id,07]
	//ZWE_DESC		:= aValid[id,08] 
	//****************************** 
	
	Local nX 	:= 0	

	For nX := 1 to Len(avalid)
	
		If aValid[nX,09]	//.T. = Grava na ZWE -- .F. Não grava na ZWE
			nRegnoZWE = VldGrvZWE(aValid[nX,01], aValid[nX,02], aValid[nX,03],aValid[nX,04], aValid[nX,05])
			If nRegnoZWE == 0
				nOpc := 3
			Else
				ZWE->(dbGoto(nRegnoZWE))
				nOpc := 4
			EndIf
			
			GrvZWE(aValid[nX],nOpc)
		EndIf

	Next nX

    //Verifica se existem erros, caso exista apresenta tela
    If Len(aValid) > 0
    
    	//Verifica desbloqueio Z23
		DesbZ23(@lBlocZ23)
    	U_AEST001(aDtaZWE)
    	
    	//Exclui registros incluidos
 		For nX := 1 to  Len(aValid)
 		
 			If aValid[nX,09]
 		
				nRegnoZWE = VldGrvZWE(aValid[nX,01], aValid[nX,02], aValid[nX,03],aValid[nX,04], aValid[nX,05])
				If nRegnoZWE != 0
					ZWE->(dbGoto(nRegnoZWE))
					GrvZWE(aValid[nX],5)
				EndIf
			
			EndIf
			
		Next nX  
		 	
    EndIf

Return

/*/{Protheus.doc} GrvZWE
//TODO Grava ZWE
@author Mario L. B. Faria
@since 30/07/2018
@version 1.0
@param aValItem, array, Dados para gravação
/*/
Static Function GrvZWE(aValItem,nOpc)
	
	Local oModel	:= FWLoadModel("MADERO_AEST001")
	Local aErro		:= {}

	oModel:SetOperation(nOpc)
	oModel:Activate()

	If nOpc != 5
		oModel:SetValue("MODEL_ZWE", "ZWE_FILIAL"	, aValItem[01])
		oModel:SetValue("MODEL_ZWE", "ZWE_PROCES"	, aValItem[02])
		oModel:SetValue("MODEL_ZWE", "ZWE_DATA"		, aValItem[03])
		oModel:SetValue("MODEL_ZWE", "ZWE_ID"		, aValItem[04])
		oModel:SetValue("MODEL_ZWE", "ZWE_ENTID"	, aValItem[05])
		oModel:SetValue("MODEL_ZWE", "ZWE_TIPO"		, aValItem[06])
	    oModel:SetValue("MODEL_ZWE", "ZWE_VALOR"	, aValItem[07])
	    oModel:SetValue("MODEL_ZWE", "ZWE_DESC"		, aValItem[08])
	EndIf
                          
 	If oModel:VldData()
		oModel:CommitData()
	Else
	
		aErro := oModel:GetErrorMessage()
		
		AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1] ) + ']' )
		AutoGrLog( "Id do campo de origem: " + ' [' + AllToChar( aErro[2] ) + ']' )
		AutoGrLog( "Id do formulário de erro: " + ' [' + AllToChar( aErro[3] ) + ']' )
		AutoGrLog( "Id do campo de erro: " + ' [' + AllToChar( aErro[4] ) + ']' )
		AutoGrLog( "Id do erro: " + ' [' + AllToChar( aErro[5] ) + ']' )
		AutoGrLog( "Mensagem do erro: " + ' [' + AllToChar( aErro[6] ) + ']' )
		AutoGrLog( "Mensagem da solução: " + ' [' + AllToChar( aErro[7] ) + ']' )
		AutoGrLog( "Valor atribuído: " + ' [' + AllToChar( aErro[8] ) + ']' )
		AutoGrLog( "Valor anterior: " + ' [' + AllToChar( aErro[9] ) + ']' )
		
//		cRet := RetErro()
		
		MostraErro()

	EndIf
	
	oModel:DeActivate()                                           
                           
Return 

/*/{Protheus.doc} ProcInv
//TODO Função para processar o inventário
@author Mario L. B. Faria
@since 31/07/2018
@version 1.0
/*/
Static Function ProcInv(aValid)

	Private lMsErroAuto := .F.

	SetParam()

	MSExecAuto({|x,y,z| MATA340(x,y,z)}, .T., "INV" + Z23->Z23_ID, .F.)                
	
	If lMsErroAuto
		MostraErro()
	EndIf

Return lMsErroAuto

/*/{Protheus.doc} SetParam
//TODO Função para setar parametros no execauto MATA340
@author Mario L. B. Faria
@since 31/07/2018
@version 1.0
/*/
Static Function SetParam()

	Local cPergunta := "MTA340"

	Pergunte(cPergunta,.F.)

	MV_PAR01 := dDataBase
	MV_PAR02 := ZA0->ZA0_CUSTO
	MV_PAR03 := 2
	MV_PAR04 := 2
	MV_PAR05 := Space(TamSx3("B1_COD")[01])
	MV_PAR06 := Replicate("Z",TamSx3("B1_COD")[01])
	MV_PAR07 := Space(TamSx3("B7_LOCAL")[01])
	MV_PAR08 := Replicate("Z",TamSx3("B7_LOCAL")[01])
	MV_PAR09 := Space(TamSx3("B1_GRUPO")[01])
	MV_PAR10 := Replicate("Z",TamSx3("B1_GRUPO")[01])
	MV_PAR11 := "INV" + Z23->Z23_ID
	MV_PAR12 := "INV" + Z23->Z23_ID
	MV_PAR13 := 2
	MV_PAR14 := 1

Return

/*/{Protheus.doc} ValPrcInv
//TODO Valida processamento do inventário
@author Mario L. B. Faria
@since 31/07/2018
@version 1.0
@param aValid, array, Dados de erro
/*/
Static Function ValPrcInv(aValid)

	Local cQuery	:= ""
	Local cAlQry	:= ""	

	cQuery := "	SELECT " + CRLF 
	cQuery += "	B7_FILIAL, B7_DATA, B7_DOC || B7_COD || B7_LOCAL SB7_ID " + CRLF  
	cQuery += "	FROM " + RetSqlName("SB7") + " SB7 " + CRLF 
	cQuery += "	WHERE " + CRLF 
	cQuery += "			B7_FILIAL  = '" + xFilial("SB7") + "' " + CRLF 
	cQuery += "		AND B7_DOC     = 'INV" + Z23->Z23_ID + "' " + CRLF 
	cQuery += "		AND B7_DATA    = '" + DtoS(dDataBase) + "' " + CRLF 
	cQuery += "		AND B7_STATUS != '2' " + CRLF 
	cQuery += "		AND SB7.D_E_L_E_T_ = ' ' " + CRLF 

	cQuery := ChangeQuery(cQuery)
	cAlQry := MPSysOpenQuery(cQuery)
	
	While !(cAlQry)->(Eof())
		aAdd(aValid,	{;
							(cAlQry)->B7_FILIAL,;		//[01] - ZWE_FILIAL
							"Inventário -Contagem",;	//[02] - ZWE_PROCES
							StoD((cAlQry)->B7_DATA),;	//[03] - ZWE_DATA
							(cAlQry)->SB7_ID,;			//[04] - ZWE_ID
							"SB7-3",;					//[05] - ZWE_ENTID
							"E",;						//[06] - ZWE_TIPO
							0,;							//[07] - ZWE_VALOR
							"Produto não processado",;	//[08] - ZWE_DESC
	    					.T.;						//[09] - .T. = Grava na ZWE -- .F. Não grava na ZWE
    					})	
		(cAlQry)->(dbSkip())
	EndDo

Return













