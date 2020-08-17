#INCLUDE 'Protheus.ch'
#INCLUDE 'Parmtype.ch'

//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA23
@Estrutura de consolidação
@param		aPar[1] = Código Empresa (cEmpAnt)
			aPar[2] = Código da Filial (cFilAnt)
			aPar[3] = Código de Cliente
			aPar[4] = Loja Cliente
			aPar[5] = Natureza
			aPar[6] = Empreendimento
			aPar[7] = Número da Venda
			aPar[8] = Tipo da Operação
			aPar[9] = Código da LP da chamada
			aPar[10] = Evento
			aPar[11] = Data da Operação
			aPar[12] = Valor da Operação
			aPar[13] = Histórico da Operação
			aPar[14] = Centro de Custo
			aPar[15] = oXmlFin
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------

User Function ASCTBA23(aPar)

Local nValCP	:= 0
Local nValLP    := 0
Local aConsRet	:= {}
Local cNum
Local nTXFIN	:= 0
Local cTpVend	:= ""
Local cVenda	:= aPar[7]
Local x
Local aReajust	:= {}
Local dDtReaj	
Local dDtEntCh		
Local aReajCM	:= {}	
Local dLP
Local lReajust  := .T.
Local nEstVLP	:= 0
Local nEstVCP	:= 0

cEmpAnt		:=	aPar[1]
cFilAnt		:=	aPar[2]

RpcSetType( 3 )
RpcSetEnv( cEmpAnt, cFilAnt ,,,'FIN')

//ProcLogIni( {},"ASCTBA23")
//ProcLogAtu("MENSAGEM",OemToAnsi("*** INICIO ***")				    							,"","ASCTBA23")

Sleep(180000)

DbSelectArea("SZ9")

IF ( aPar[8] == '0' .Or. aPar[8] == '2' ) .And. aPar[10] == "upsert"  // Inclusão Venda

	cNum := GetSxeNum("SZ9","Z9_ID","Z9_ID" + cEmpAnt ) 
	cDtCP		:= LastDay( MonthSum( aPar[11] , 12 ) )
	cDtCP		:= Dtos(cDtCP)
	nValCP		:= ConCpInc( aPar[11], cVenda, aPar[3], aPar[4], cDtCP ) // Data da Operação, Número da Venda, Cliente, Loja, Data Curto Prazo
	aConsRet	:= ConsTpVd( cVenda )
   	
   	IF Len(aConsRet) > 0
   		For x:=0 To Len(aConsRet)
   			IF x==1
   	     		cTpVend := aConsRet[x]
   	  		ElseIF x==2
   	     		nTXFIN	:= Val(aConsRet[x])
   	    	EndIF
   	    Next 
   	EndIF  

	SZ9->(RECLOCK( "SZ9", .T. ))

		SZ9->Z9_FILIAL	:= xFilial("SZ9")
		SZ9->Z9_ID		:= cNum			// ID
		SZ9->Z9_EMPR    := aPar[6]		// Código do Empreendimento
		SZ9->Z9_NUNVEND	:= aPar[7]		//Numero da Venda
		SZ9->Z9_CLIENTE	:= aPar[3]		// Cliente
		SZ9->Z9_LOJA	:= aPar[4]		// Loja Cliente
		SZ9->Z9_NATUREZ	:= aPar[5]		// Código da Natureza
		SZ9->Z9_DTOPER	:= aPar[11]		// Data Operação	
		SZ9->Z9_TXFIN	:= nTXFIN		// Taxa de Financiamento
		SZ9->Z9_TIPOVEN	:= cTpVend		//Tipo da Venda
		SZ9->Z9_TPOPER  := aPar[8]		//Tipo de Operação
		SZ9->Z9_VALORCP	:= nValCP		//Valor Curto
		SZ9->Z9_VALORLP	:= ( aPar[12] - nValCP ) //Valor Longo Prazo
		SZ9->Z9_CODLP	:= aPar[9]		//Código de LP de origem
		SZ9->Z9_CCUSTO	:= aPar[14]		// Centro de Custo	
		SZ9->Z9_HIST	:= IF(aPar[8] = '2', "ADITIVO: " + ALLTRIM(SUBSTR(ALLTRIM(aPar[13]),AT("-",ALLTRIM(aPar[13]))+1,100)) , ALLTRIM(SUBSTR(ALLTRIM(aPar[13]),AT("-",ALLTRIM(aPar[13]))+1,100)) )//Histórico de Contabilizacao
		SZ9->Z9_LA		:= IF(cTpVend == "VF","S","")
    
    ConfirmSX8()
    	
	MsUnLock()
		
EndIF

IF ( aPar[8] == '0' .Or. aPar[8] == '2' ) .And. aPar[10] == "delete"  // Exclusão Venda
	
	cNum 		:= GetSxeNum("SZ9","Z9_ID","Z9_ID" + cEmpAnt ) 
	cDtCP		:= LastDay( MonthSum( aPar[11] , 12 ) )
	cDtCP		:= Dtos(cDtCP)
	nValCP		:= ConCpBx( aPar[11], cVenda, aPar[3], aPar[4], cDtCP, cNum ) // Data da Operação, Número da Venda, Cliente, Loja, Data Curto Prazo, IDSZ9
	aConsRet	:= ConsTpVd( cVenda )
	
   	IF Len(aConsRet) > 0
   		For x:=0 To Len(aConsRet)
   			IF x==1
   	     		cTpVend := aConsRet[x]
   	  		ElseIF x==2
   	     		nTXFIN	:= Val(aConsRet[x])
   	    	EndIF
   	    Next 
   	EndIF

	SZ9->(RECLOCK( "SZ9", .T. ))
	
		SZ9->Z9_FILIAL	:= xFilial("SZ9")
		SZ9->Z9_ID		:= cNum			// ID
		SZ9->Z9_EMPR    := aPar[6]		// Código do Empreendimento
		SZ9->Z9_NUNVEND	:= aPar[7]		//Numero da Venda
		SZ9->Z9_CLIENTE	:= aPar[3]		// Cliente
		SZ9->Z9_LOJA	:= aPar[4]		// Loja Cliente
		SZ9->Z9_NATUREZ	:= aPar[5]		// Código da Natureza
		SZ9->Z9_DTOPER	:= aPar[11]		// Data Operação	
		SZ9->Z9_TXFIN	:= nTXFIN		// Taxa de Financiamento
		SZ9->Z9_TIPOVEN	:= cTpVend		//Tipo da Venda
		SZ9->Z9_TPOPER  := aPar[8]		//Tipo de Operação
		SZ9->Z9_VALORCP	:= nValCP		//Valor Curto
		SZ9->Z9_VALORLP	:= ( aPar[12] - nValCP ) //Valor Longo Prazo
		SZ9->Z9_CCUSTO	:= aPar[14]		// Centro de Custo	
		SZ9->Z9_CODLP	:= aPar[9]		//Código de LP de origem
		SZ9->Z9_HIST	:= IF(aPar[8] = '2', "ADITIVO: " + ALLTRIM(SUBSTR(ALLTRIM(aPar[13]),AT("-",ALLTRIM(aPar[13]))+1,100)) , ALLTRIM(SUBSTR(ALLTRIM(aPar[13]),AT("-",ALLTRIM(aPar[13]))+1,100)) )//Histórico de Contabilizacao
		SZ9->Z9_LA		:= IF(cTpVend == "VF","S","")

	    ConfirmSX8()
    	
	MsUnLock()
		
EndIF

IF aPar[8] == '1' .And. aPar[10] == "upsert"  // Inclusão Reajuste

	//aReajust[1] -> Data do reajuste
	//aReajust[2] -> Data entrega da chave
	aReajust	:= ConsReaj( cVenda )
    IF Len(aReajust) > 0
   		For x:=0 To Len(aReajust)
   			IF x==1
   	   	 		dDtReaj	:= cToD(Substr(aReajust[x],9,2)+"/"+Substr(aReajust[x],6,2)+"/"+Substr(aReajust[x],1,4))  
   			ElseIF x==2
   	   			dDtEntCh:= cToD(Substr(aReajust[x],9,2)+"/"+Substr(aReajust[x],6,2)+"/"+Substr(aReajust[x],1,4))  
   	   		EndIF
   	 	Next 
   	EndIF
  
	lReajust := CReajAnt(aPar, dDtReaj )
	dLP		:= LastDay( MonthSum( dDtReaj , 11 ) )
	
	//aReajCM [1] -> Valor do Reajuste Curto Prazo
	//aReajCM [2] -> Valor do Reajuste Longo Prazo
	aReajCM		:= ConsReCM( cVenda, dDtReaj, dLP )
   
    IF Len(aReajCM) > 0
		For x:=0 To Len(aReajCM)
			IF x==1
   	 			nValCP	:= Val( aReajCM[x] )
			ElseIF x==2
   				nValLP	:= Val( aReajCM[x] )
   			EndIF
 		Next 
	EndIF
    
 	IF !lReajust .And. ( nValCP > 0 .Or. nValLP > 0)
	
		//aConsRet [1] -> Tipo da Venda
		//aConsRet [2] -> Taxa de Financiamento
		aConsRet	:= ConsTpVd( cVenda )
  	
   		IF Len(aConsRet) > 0
   			For x:=0 To Len(aConsRet)
   				IF x==1
   	     			cTpVend := aConsRet[x]
   	  			ElseIF x==2
   	     			nTXFIN	:= Val(aConsRet[x])
   	    		EndIF
   	    	Next 
   		EndIF
	 	
		cNum 		:= GetSxeNum("SZ9","Z9_ID","Z9_ID" + cEmpAnt )

		SZ9->(RECLOCK( "SZ9", .T. ))
	
			SZ9->Z9_FILIAL	:= xFilial("SZ9")
			SZ9->Z9_ID		:= cNum			// ID
			SZ9->Z9_EMPR    := aPar[6]		// Código do Empreendimento
			SZ9->Z9_NUNVEND	:= aPar[7]		// Numero da Venda
			SZ9->Z9_CLIENTE	:= aPar[3]		// Cliente
			SZ9->Z9_LOJA	:= aPar[4]		// Loja Cliente
			SZ9->Z9_NATUREZ	:= aPar[5]		// Código da Natureza
			SZ9->Z9_DTOPER	:= aPar[11]		// Data Operação	
			SZ9->Z9_DTREAJU	:= dDtReaj 		// Data do Reajuste
	
			IF !Empty(dDtEntCh)
				SZ9->Z9_DTCHAVE := dDtEntCh // Data Entrega da Chave
			EndIF
		
			SZ9->Z9_TXFIN	:= nTXFIN		// Taxa de Financiamento
			SZ9->Z9_TIPOVEN	:= cTpVend		// Tipo da Venda
			SZ9->Z9_TPOPER  := aPar[8]		// Tipo de Operação
			SZ9->Z9_VALORCP	:= Abs(nValCP)	// Valor Curto
			SZ9->Z9_VALORLP	:= Abs(nValLP)	// Valor Longo Prazo
			SZ9->Z9_CCUSTO	:= aPar[14]		// Centro de Custo	
			SZ9->Z9_CODLP	:= aPar[9]		// Código de LP de origem
			SZ9->Z9_HIST	:= "REAJUSTE: " + ALLTRIM(SUBSTR(ALLTRIM(aPar[13]),AT("-",ALLTRIM(aPar[13]))+1,100))// Histórico de Contabilizacao
			SZ9->Z9_LA		:= IF(cTpVend == "VF" .AND. Empty(dDtEntCh) ,"S","")

		    ConfirmSX8()
    	
		MsUnLock()
  
    	//Transferência do Longo Prazo para o Curto
    	TransLP(aPar, dDtReaj, nTXFIN, cTpVend, dDtEntCh )

	EndIF

EndIF

IF ( aPar[8] == 'AV') .And. aPar[10] == "upsert"  // Alteração de Vencimento

	cDtCP		:= Dtos( LastDay( MonthSum( aPar[11] , 12 ) ) )

	nEstVCP		:= ConVEsCP( cVenda,  aPar[3], aPar[4], cDtCP ) //Consulta valor para ser estornado CP -> Número da Venda, Cliente, loja, data CP
	nEstVLP		:= ConVEsLP( cVenda,  aPar[3], aPar[4], cDtCP ) //Consulta valor para ser estornado LP -> Número da Venda, Cliente, loja, data CP
    nValCP		:= ConVRCP( cVenda,  aPar[3], aPar[4], cDtCP )
    nValLP		:= ConVRLP( cVenda,  aPar[3], aPar[4], cDtCP )    
    
    aReajust	:= ConsReaj( cVenda )
    IF Len(aReajust) > 0
   		For x:=0 To Len(aReajust)
   			IF x==1
   	   	 		dDtReaj	:= cToD(Substr(aReajust[x],9,2)+"/"+Substr(aReajust[x],6,2)+"/"+Substr(aReajust[x],1,4))  
   			ElseIF x==2
   	   			dDtEntCh:= cToD(Substr(aReajust[x],9,2)+"/"+Substr(aReajust[x],6,2)+"/"+Substr(aReajust[x],1,4))  
   	   		EndIF
   	 	Next 
   	EndIF
    
    //aConsRet [1] -> Tipo da Venda
	//aConsRet [2] -> Taxa de Financiamento
	aConsRet	:= ConsTpVd( cVenda )
  	IF Len(aConsRet) > 0
   		For x:=0 To Len(aConsRet)
   			IF x==1
   	   			cTpVend := aConsRet[x]
   			ElseIF x==2
   	   			nTXFIN	:= Val(aConsRet[x])
   	   		EndIF
   	   	Next 
   	EndIF
    
    cNum := GetSxeNum("SZ9","Z9_ID","Z9_ID" + cEmpAnt )
	SZ9->(RECLOCK( "SZ9", .T. ))
		 
		SZ9->Z9_FILIAL	:= xFilial("SZ9")
		SZ9->Z9_ID		:= cNum			// ID
		SZ9->Z9_EMPR    := aPar[6]		// Código do Empreendimento
		SZ9->Z9_NUNVEND	:= aPar[7]		// Numero da Venda
		SZ9->Z9_CLIENTE	:= aPar[3]		// Cliente
		SZ9->Z9_LOJA	:= aPar[4]		// Loja Cliente
		SZ9->Z9_NATUREZ	:= aPar[5]		// Código da Natureza
		SZ9->Z9_DTOPER	:= aPar[11]		// Data Operação	
		
		IF !Empty(dDtReaj)
			SZ9->Z9_DTREAJU	:= dDtReaj 		// Data do Reajuste
		EndIF    
	
		IF !Empty(dDtEntCh)
			SZ9->Z9_DTCHAVE := dDtEntCh // Data Entrega da Chave
		EndIF
		
		SZ9->Z9_TXFIN	:= nTXFIN		// Taxa de Financiamento
		SZ9->Z9_TIPOVEN	:= cTpVend		// Tipo da Venda
		SZ9->Z9_TPOPER  := aPar[8]		// Tipo de Operação
		SZ9->Z9_VALORCP	:= nEstVCP		// Valor Curto
		SZ9->Z9_VALORLP	:= nEstVLP		// Valor Longo Prazo
		SZ9->Z9_CCUSTO	:= aPar[14]		// Centro de Custo	
		SZ9->Z9_CODLP	:= "51C"		// Código de LP de origem
		SZ9->Z9_HIST	:= "ADITIVO: " + ALLTRIM(SUBSTR(ALLTRIM(aPar[13]),AT("-",ALLTRIM(aPar[13]))+1,100))// Histórico de Contabilizacao
		SZ9->Z9_LA		:= IF(cTpVend == "VF" .AND. Empty(dDtEntCh) ,"S","")
			    
		ConfirmSX8()
    	
	MsUnLock()
    
	cNum := GetSxeNum("SZ9","Z9_ID","Z9_ID" + cEmpAnt )
	SZ9->(RECLOCK( "SZ9", .T. ))
		 
		SZ9->Z9_FILIAL	:= xFilial("SZ9")
		SZ9->Z9_ID		:= cNum			// ID
		SZ9->Z9_EMPR    := aPar[6]		// Código do Empreendimento
		SZ9->Z9_NUNVEND	:= aPar[7]		// Numero da Venda
		SZ9->Z9_CLIENTE	:= aPar[3]		// Cliente
		SZ9->Z9_LOJA	:= aPar[4]		// Loja Cliente
		SZ9->Z9_NATUREZ	:= aPar[5]		// Código da Natureza
		SZ9->Z9_DTOPER	:= aPar[11]		// Data Operação	
		
		IF !Empty(dDtReaj)
			SZ9->Z9_DTREAJU	:= dDtReaj 		// Data do Reajuste
		EndIF
	
		IF !Empty(dDtEntCh)
			SZ9->Z9_DTCHAVE := dDtEntCh // Data Entrega da Chave
		EndIF
		
		SZ9->Z9_TXFIN	:= nTXFIN		// Taxa de Financiamento
		SZ9->Z9_TIPOVEN	:= cTpVend		// Tipo da Venda
		SZ9->Z9_TPOPER  := aPar[8]		// Tipo de Operação
		SZ9->Z9_VALORCP	:= nValCP		// Valor Curto
		SZ9->Z9_VALORLP	:= nValLP		// Valor Longo Prazo
		SZ9->Z9_CCUSTO	:= aPar[14]		// Centro de Custo	
		SZ9->Z9_CODLP	:= "51B"		// Código de LP de origem
		SZ9->Z9_HIST	:= "ADITIVO: " + ALLTRIM(SUBSTR(ALLTRIM(aPar[13]),AT("-",ALLTRIM(aPar[13]))+1,100))// Histórico de Contabilizacao
		SZ9->Z9_LA		:= IF(cTpVend == "VF" .AND. Empty(dDtEntCh) ,"S","")
			    
		ConfirmSX8()
    	
	MsUnLock()
 
EndIF

RpcClearEnv()                         
FreeUsedCode(.T.)

Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} ConCpInc()

Soma o valor do curto prazo quando inclusão

@param		dDtOper  -> Data de Operação
			cNVenda  -> Número da Venda
			cCodCli  -> Código do Cliente
			cLojaCli -> Loja Cliente
			cDtCP	 -> Data de Curto Prazo
			cNum	 -> IDSZ9
			
@return		Valor de Curto Prazo
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ConCpInc( dDtOper, cNVenda, cCodCli, cLojaCli, cDtCP )

Local cSql
Local cDtOper
Local cTMPSE1	:= GetNextAlias()

cDtOper		:= Dtos(dDtOper)

cQuery := "SELECT SUM(SE1.E1_VALOR) AS VALOR"
cQuery += " FROM " + RetSqlName("SE1") + " SE1"
cQuery += " WHERE "
cQuery += " SE1.E1_FILIAL = '"+ xFilial("SE1") +"'"
cQuery += " AND SE1.E1_TIPO = 'REC'"
cQuery += " AND SE1.E1_EMISSAO = '" + cDtOper + "'"
cQuery += " AND SE1.E1_XCONTRA = '"+ cNVenda +"'"
cQuery += " AND SE1.E1_CLIENTE = '"+ cCodCli +"'"
cQuery += " AND SE1.E1_LOJA = '"+ cLojaCli +"'"
cQuery += " AND SE1.E1_VENCTO <= '"+ cDtCP +"'"
cQuery += " AND SE1.E1_XIDSZ9 = '' " 
cQuery += " AND SE1.D_E_L_E_T_ = ''"

cQuery:=ChangeQuery(cQuery)

If Select(cTMPSE1)>0
	(cTMPSE1)->(dbCloseArea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cTMPSE1, .T., .T. )

nValCP := (cTMPSE1)->VALOR

(cTMPSE1)->(dbCloseArea())

Return nValCP

//-----------------------------------------------------------------------
/*/{Protheus.doc} ConCpBx()

Soma o valor do curto prazo quando baixa

@param		dDtOper  -> Data de Operação
			cNVenda  -> Número da Venda
			cCodCli  -> Código do Cliente
			cLojaCli -> Loja Cliente
			cDtCP	 -> Data de Curto Prazo
			cNum	 -> IDSZ9 
			
@return		Valor de Curto Prazo
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ConCpBx( dDtOper, cNVenda, cCodCli, cLojaCli, cDtCP, cNum )

Local cSql
Local cDtOper
Local cTMPSE1	:= GetNextAlias()

cDtOper		:= Dtos(dDtOper)

//Consulta o valor de curto prazo
cQuery := "SELECT ( SUM(SE1.E1_VALOR)+ SUM(SE1.E1_SDACRES) - SUM(SE1.E1_SDDECRE) ) AS VALOR"
cQuery += " FROM " + RetSqlName("SE1") + " SE1"
cQuery += " WHERE "
cQuery += " SE1.E1_FILIAL = '"+ xFilial("SE1") +"'"
cQuery += " AND SE1.E1_TIPO = 'REC'"
cQuery += " AND SE1.E1_BAIXA = '" + cDtOper + "'"
cQuery += " AND SE1.E1_XCONTRA = '"+ cNVenda +"'"
cQuery += " AND SE1.E1_CLIENTE = '"+ cCodCli +"'"
cQuery += " AND SE1.E1_LOJA = '"+ cLojaCli +"'"
cQuery += " AND SE1.E1_VENCTO <= '"+ cDtCP +"'"
cQuery += " AND SE1.E1_XIDSZ9 = '' " 
cQuery += " AND SE1.D_E_L_E_T_ = ''"

cQuery:=ChangeQuery(cQuery)
                                    
If Select(cTMPSE1)>0
	(cTMPSE1)->(dbCloseArea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cTMPSE1, .T., .T. )

nValCP := (cTMPSE1)->VALOR

(cTMPSE1)->(dbCloseArea())

//Marca o E1_XIDSZ9 com o número do ID da SZ9
cSql := "UPDATE "+RetSqlName("SE1")+" SET E1_XIDSZ9 = '"+cNum+"'"
cSql += " WHERE "
cSql += " SE1.E1_FILIAL = '"+ xFilial("SE1") +"'"
cSql += " AND SE1.E1_TIPO = 'REC'"
cSql += " AND SE1.E1_BAIXA = '" + cDtOper + "'"
cSql += " AND SE1.E1_XCONTRA = '"+ cNVenda +"'"
cSql += " AND SE1.E1_CLIENTE = '"+ cCodCli +"'"
cSql += " AND SE1.E1_LOJA = '"+ cLojaCli +"'"
cSql += " AND SE1.E1_XIDSZ9 = '' " 
cSql += " AND SE1.D_E_L_E_T_ = ''"

TCSQLEXEC(cSql)
TCREFRESH(RetSqlName("SE1"))

Return nValCP

//-----------------------------------------------------------------------
/*/{Protheus.doc} TransLP()

Soma o valor do curto prazo quando baixa

@param		aPar[1] = Código Empresa (cEmpAnt)
			aPar[2] = Código da Filial (cFilAnt)
			aPar[3] = Código de Cliente
			aPar[4] = Loja Cliente
			aPar[5] = Natureza
			aPar[6] = Empreendimento
			aPar[7] = Número da Venda
			aPar[8] = Tipo da Operação
			aPar[9] = Código da LP da chamada
			aPar[10] = Evento
			aPar[11] = Data da Operação
			aPar[12] = Valor da Operação
			aPar[13] = Histórico da Operação
			aPar[14] = oXmlFin
			dDtReaj -> Data do Reajuste
			nTXFIN  -> Tx de Financiamento
			cTpVend -> Tipo da venda
@return		
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION TransLP(aPar, dDtReaj, nTXFIN, cTpVend, dDtEntCh )

Local dTranIni
Local dTranFim
Local cQuery
Local cTRANS	:= GetNextAlias()

dTranIni := FirstDay( MonthSum( dDtReaj , 12 ) )
dTranFim := LastDay( MonthSum( dDtReaj , 12 ) )  

dTranIni := Dtos(dTranIni)
dTranFim := Dtos(dTranFim)
    
cQuery := "SELECT SUM(E1_SALDO)+SUM(E1_SDACRES)-SUM(E1_SDDECRE) AS VALTRANS"
cQuery += " FROM " + RetSqlName("SE1") + " SE1"
cQuery += " WHERE "
cQuery += " SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
cQuery += " AND SE1.E1_TIPO = 'REC'"
cQuery += " AND SE1.E1_XCONTRA = '" + aPar[7] + "'"
cQuery += " AND SE1.E1_CLIENTE = '" + aPar[3] + "'"
cQuery += " AND SE1.E1_LOJA = '" + aPar[4] + "'"
cQuery += " AND SE1.E1_VENCTO BETWEEN '"+ dTranIni + "' AND '"+ dTranFim +"'"
cQuery += " AND SE1.D_E_L_E_T_ = ''"
	
cQuery:=ChangeQuery(cQuery)

If Select(cTRANS)>0
	(cTRANS)->(dbCloseArea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cTRANS, .T., .T. )

nValTrans := (cTRANS)->VALTRANS

(cTRANS)->(dbCloseArea())

IF (nValTrans > 0)
	cNum := GetSxeNum("SZ9","Z9_ID","Z9_ID" + cEmpAnt )
		
	SZ9->(RECLOCK( "SZ9", .T. ))
	
		SZ9->Z9_FILIAL	:= xFilial("SZ9")
		SZ9->Z9_ID		:= cNum			// ID
		SZ9->Z9_EMPR    := aPar[6]		// Código do Empreendimento
		SZ9->Z9_NUNVEND	:= aPar[7]		// Numero da Venda
		SZ9->Z9_CLIENTE	:= aPar[3]		// Cliente
		SZ9->Z9_LOJA	:= aPar[4]		// Loja Cliente
		SZ9->Z9_NATUREZ	:= aPar[5]		// Código da Natureza
		SZ9->Z9_DTOPER	:= aPar[11]		// Data Operação	
		SZ9->Z9_DTREAJU	:= dDtReaj 		// Data do Reajuste
		SZ9->Z9_TXFIN	:= nTXFIN		// Taxa de Financiamento
		SZ9->Z9_TIPOVEN	:= cTpVend		// Tipo da Venda
		SZ9->Z9_TPOPER  := '9'			// Tipo de Operação
		SZ9->Z9_VALORCP	:= nValTrans	// Valor Curto
		SZ9->Z9_CCUSTO	:= aPar[14]		// Centro de Custo	
		SZ9->Z9_CODLP	:= "51B"		// Código de LP de origem
		SZ9->Z9_HIST	:= "TRANSF. LP PARA CP: " + ALLTRIM(SUBSTR(ALLTRIM(aPar[13]),AT("-",ALLTRIM(aPar[13]))+1,100))//Histórico de Contabilizacao
		SZ9->Z9_LA		:= IF(cTpVend == "VF" .AND. Empty(dDtEntCh) ,"S","")

	    ConfirmSX8()
    	
	MsUnLock()

EndIF

Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} CReajAnt()

Soma o valor do curto prazo quando baixa

@param		aPar[1] = Código Empresa (cEmpAnt)
			aPar[2] = Código da Filial (cFilAnt)
			aPar[3] = Código de Cliente
			aPar[4] = Loja Cliente
			aPar[5] = Natureza
			aPar[6] = Empreendimento
			aPar[7] = Número da Venda
			aPar[8] = Tipo da Operação
			aPar[9] = Código da LP da chamada
			aPar[10] = Evento
			aPar[11] = Data da Operação
			aPar[12] = Valor da Operação
			aPar[13] = Histórico da Operação
			aPar[14] = oXmlFin
			dDtReaj -> Data do Reajuste
@return		.T. = Inclusão de Registro, .F. = Exclusão de Registro
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION CReajAnt(aPar, dDtReaj)
LOCAL lRet := .F. 
LOCAL cQuery
LOCAL cTZ9	:= GetNextAlias()

dDtReaj := Dtos(dDtReaj)

cQuery := "SELECT SZ9.Z9_FILIAL, SZ9.Z9_ID, SZ9.Z9_EMPR, SZ9.Z9_NUNVEND, SZ9.Z9_CLIENTE, SZ9.Z9_LOJA, SZ9.Z9_NATUREZ, "
cQuery += " SZ9.Z9_DTOPER, SZ9.Z9_DTREAJU, SZ9.Z9_DTCHAVE, SZ9.Z9_TXFIN, SZ9.Z9_TIPOVEN, SZ9.Z9_TPOPER, SZ9.Z9_VALORCP,"
cQuery += " SZ9.Z9_VALORLP, SZ9.Z9_CCUSTO, SZ9.Z9_CODLP, SZ9.Z9_HIST, SZ9.Z9_LA"
cQuery += " FROM " + RetSqlName("SZ9") + " SZ9"
cQuery += " WHERE "
cQuery += " SZ9.Z9_FILIAL = '"+xFilial("SZ9")+"'" 
cQuery += " AND SZ9.Z9_NUNVEND = '"+ aPar[7] +"'"
cQuery += " AND SZ9.Z9_DTREAJU > '"+ dDtReaj +"'"
cQuery += " AND SZ9.D_E_L_E_T_ = ''"

cQuery:=ChangeQuery(cQuery)

If Select(cTZ9)>0
	cTZ9->(dbCloseArea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'cTZ9', .T., .T. )

DbSelectArea("cTZ9")
cTZ9->(DbGoTop())

//If !cSZ9->(Eof())
    
While !cTZ9->(EOF())

	cNum := GetSxeNum("SZ9","Z9_ID","Z9_ID" + cEmpAnt )
	SZ9->(RECLOCK( "SZ9", .T. ))
	
		SZ9->Z9_FILIAL	:= xFilial("SZ9")
		SZ9->Z9_ID		:= cNum					// ID
		SZ9->Z9_EMPR    := cTZ9->Z9_EMPR		// Código do Empreendimento
		SZ9->Z9_NUNVEND	:= cTZ9->Z9_NUNVEND		// Numero da Venda
		SZ9->Z9_CLIENTE	:= cTZ9->Z9_CLIENTE		 // Cliente
	    SZ9->Z9_LOJA	:= cTZ9->Z9_LOJA		 // Loja
	    SZ9->Z9_NATUREZ	:= cTZ9->Z9_NATUREZ		 // Natureza
	    SZ9->Z9_DTOPER  := sToD(cTZ9->Z9_DTOPER) // Data da Operação
	    SZ9->Z9_DTREAJU	:= sToD(cTZ9->Z9_DTREAJU)// Data do Reajuste
	    SZ9->Z9_DTCHAVE	:= sToD(cTZ9->Z9_DTCHAVE)// Data entrega chave
	    SZ9->Z9_TXFIN	:= cTZ9->Z9_TXFIN		 // Taxa de Financiamento
	    SZ9->Z9_TIPOVEN	:= cTZ9->Z9_TIPOVEN		 // Tipo de Venda
	    SZ9->Z9_TPOPER	:= cTZ9->Z9_TPOPER		// Tipo de Operação
	    SZ9->Z9_VALORCP	:= cTZ9->Z9_VALORCP		// Valor Curto Prazo
	    SZ9->Z9_VALORLP	:= cTZ9->Z9_VALORLP		// Valor Longo Prazo
	    SZ9->Z9_CCUSTO	:= cTZ9->Z9_CCUSTO		// Centro de Custo
	    SZ9->Z9_CODLP	:= IF( cTZ9->Z9_CODLP == "51B","51C",IF( cTZ9->Z9_CODLP == "51C","51B","" ) ) //LP 
	    SZ9->Z9_HIST	:= "ESTORNO: "+cTZ9->Z9_HIST // HISTORICO
	    SZ9->Z9_LA		:= IF( Alltrim(cTZ9->Z9_TIPOVEN) == "VF" .AND. Empty( cTZ9->Z9_DTCHAVE ) ,"S","") // Flag CTB
		    
		ConfirmSX8()
    	
	MsUnLock()

	cTZ9->(DbSkip())
   
 	lRet := .T.

EndDO

cTZ9->(dbCloseArea())

RETURN lRet 

//-----------------------------------------------------------------------
/*/{Protheus.doc} ConVEsCP()

Soma os valores de curto prazo para serem estornados em uma alteração de vencimento

@param		cNVenda  -> Número da Venda
			cCodCli  -> Código do Cliente
			cLojaCli -> Loja Cliente
			cDtCP	 -> Data de Curto Prazo
			dDtOper	 -> Data da Operação
			
@return		Valor de Curto Prazo
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ConVEsCP( cNVenda, cCodCli, cLojaCli, cDtCP )

Local cQuery
Local cSQL
Local nValCP	:= 0
Local cCP		:= GetNextAlias()

cQuery := "SELECT SUM(E1_XSALDOA) AS VALOR"
cQuery += " FROM " + RetSqlName("SE1") + " SE1"
cQuery += " WHERE "
cQuery += " SE1.E1_FILIAL = '"+ xFilial("SE1") +"'"
cQuery += " AND SE1.E1_TIPO = 'REC'"
cQuery += " AND SE1.E1_XVECTOA <= '" + cDtCP + "'"
cQuery += " AND SE1.E1_XFLAGES = ''"
cQuery += " AND SE1.E1_XCONTRA = '"+ cNVenda +"'"
cQuery += " AND SE1.E1_CLIENTE = '"+ cCodCli +"'"
cQuery += " AND SE1.E1_LOJA = '"+ cLojaCli +"'"
cQuery += " AND SE1.D_E_L_E_T_ = ''"

cQuery:=ChangeQuery(cQuery)

If Select(cCP)>0
	(cCP)->(dbCloseArea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cCP, .T., .T. )

nValCP := (cCP)->VALOR

(cCP)->(dbCloseArea())

//Marca o E1.XFLAGES
cSql := "UPDATE "+RetSqlName("SE1")+" SET E1_XFLAGES = 'S'"
cSql += " WHERE "
cSql += " E1_FILIAL = '"+ xFilial("SE1") +"'"
cSql += " AND E1_TIPO = 'REC'"
cSql += " AND E1_XVECTOA <= '" + cDtCP + "'"
cSql += " AND E1_XFLAGES = ''"
cSql += " AND E1_XCONTRA = '"+ cNVenda +"'"
cSql += " AND E1_CLIENTE = '"+ cCodCli +"'"
cSql += " AND E1_LOJA = '"+ cLojaCli +"'"
cSql += " AND E1_XSALDOA > 0"
cSql += " AND D_E_L_E_T_ = ''"

TCSQLEXEC(cSql)
TCREFRESH(RetSqlName("SE1"))

Return nValCP


//-----------------------------------------------------------------------
/*/{Protheus.doc} ConVEsLP()

Soma os valores de longo prazo para serem estornados em uma alteração de vencimento

@param		cNVenda  -> Número da Venda
			cCodCli  -> Código do Cliente
			cLojaCli -> Loja Cliente
			cDtCP	 -> Data de Curto Prazo
			dDtOper	 -> Data da Operação
			
@return		Valor de Longo Prazo
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ConVEsLP( cNVenda, cCodCli, cLojaCli, cDtCP )

Local cQuery
Local cSQL
Local nValLP	:= 0
Local cLP		:= GetNextAlias()

cQuery := "SELECT SUM(E1_XSALDOA) AS VALOR"
cQuery += " FROM " + RetSqlName("SE1") + " SE1"
cQuery += " WHERE "
cQuery += " SE1.E1_FILIAL = '"+ xFilial("SE1") +"'"
cQuery += " AND SE1.E1_TIPO = 'REC'"
cQuery += " AND SE1.E1_XVECTOA > '" + cDtCP + "'"
cQuery += " AND SE1.E1_XFLAGES = ''"
cQuery += " AND SE1.E1_XCONTRA = '"+ cNVenda +"'"
cQuery += " AND SE1.E1_CLIENTE = '"+ cCodCli +"'"
cQuery += " AND SE1.E1_LOJA = '"+ cLojaCli +"'"
cQuery += " AND SE1.D_E_L_E_T_ = ''"

cQuery:=ChangeQuery(cQuery)

If Select(cLP)>0
	(cLP)->(dbCloseArea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cLP, .T., .T. )

nValLP := (cLP)->VALOR

(cLP)->(dbCloseArea())

//Marca o E1.XFLAGES
cSql := "UPDATE "+RetSqlName("SE1")+" SET E1_XFLAGES = 'S'"
cSql += " WHERE "
cSql += " E1_FILIAL = '"+ xFilial("SE1") +"'"
cSql += " AND E1_TIPO = 'REC'"
cSql += " AND E1_XVECTOA > '" + cDtCP + "'"
cSql += " AND E1_XFLAGES = ''"
cSql += " AND E1_XCONTRA = '"+ cNVenda +"'"
cSql += " AND E1_CLIENTE = '"+ cCodCli +"'"
cSql += " AND E1_LOJA = '"+ cLojaCli +"'"
cSql += " AND E1_XSALDOA > 0"
cSql += " AND D_E_L_E_T_ = ''"

TCSQLEXEC(cSql)
TCREFRESH(RetSqlName("SE1"))

Return nValLP

//-----------------------------------------------------------------------
/*/{Protheus.doc} ConVRCP()

Soma os valores de curto prazo para serem contabilizados

@param		cNVenda  -> Número da Venda
			cCodCli  -> Código do Cliente
			cLojaCli -> Loja Cliente
			cDtCP	 -> Data de Curto Prazo
			dDtOper	 -> Data da Operação
			
@return		Valor de Curto Prazo
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ConVRCP( cNVenda, cCodCli, cLojaCli, cDtCP )

Local cQuery
Local cSQL
Local nValCP	:= 0
Local cCP		:= GetNextAlias()

cQuery := "SELECT (SUM(SE1.E1_SALDO)+ SUM(SE1.E1_SDACRES) - SUM(SE1.E1_SDDECRE)) AS VALOR"
cQuery += " FROM " + RetSqlName("SE1") + " SE1"
cQuery += " WHERE "
cQuery += " SE1.E1_FILIAL = '"+ xFilial("SE1") +"'"
cQuery += " AND SE1.E1_TIPO = 'REC'"
cQuery += " AND SE1.E1_VENCTO <= '" + cDtCP + "'"
cQuery += " AND SE1.E1_XFLAGES = 'S'"
cQuery += " AND SE1.E1_XCONTRA = '"+ cNVenda +"'"
cQuery += " AND SE1.E1_CLIENTE = '"+ cCodCli +"'"
cQuery += " AND SE1.E1_LOJA = '"+ cLojaCli +"'"
cQuery += " AND SE1.D_E_L_E_T_ = ''"

cQuery:=ChangeQuery(cQuery)

If Select(cCP)>0
	(cCP)->(dbCloseArea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cCP, .T., .T. )

nValCP := (cCP)->VALOR

(cCP)->(dbCloseArea())

//Marca o E1.XFLAGES
cSql := "UPDATE "+RetSqlName("SE1")+" SET E1_XFLAGES = '', E1_XVECTOA = '', E1_XSALDOA = ''"
cSql += " WHERE "
cSql += " E1_FILIAL = '"+ xFilial("SE1") +"'"
cSql += " AND E1_TIPO = 'REC'"
cSql += " AND E1_VENCTO <= '" + cDtCP + "'"
cSql += " AND E1_XFLAGES = 'S'"
cSql += " AND E1_XCONTRA = '"+ cNVenda +"'"
cSql += " AND E1_CLIENTE = '"+ cCodCli +"'"
cSql += " AND E1_LOJA = '"+ cLojaCli +"'"
cSql += " AND E1_XSALDOA > 0"
cSql += " AND D_E_L_E_T_ = ''"

TCSQLEXEC(cSql)
TCREFRESH(RetSqlName("SE1"))

Return nValCP

//-----------------------------------------------------------------------
/*/{Protheus.doc} ConVRLP()

Soma os valores de curto prazo para serem contabilizados

@param		cNVenda  -> Número da Venda
			cCodCli  -> Código do Cliente
			cLojaCli -> Loja Cliente
			cDtCP	 -> Data de Curto Prazo
			dDtOper	 -> Data da Operação
			
@return		Valor de Longo Prazo
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ConVRLP( cNVenda, cCodCli, cLojaCli, cDtCP )

Local cQuery
Local cSQL
Local nValLP	:= 0
Local cLP		:= GetNextAlias()

cQuery := "SELECT (SUM(SE1.E1_SALDO)+ SUM(SE1.E1_SDACRES) - SUM(SE1.E1_SDDECRE)) AS VALOR"
cQuery += " FROM " + RetSqlName("SE1") + " SE1"
cQuery += " WHERE "
cQuery += " SE1.E1_FILIAL = '"+ xFilial("SE1") +"'"
cQuery += " AND SE1.E1_TIPO = 'REC'"
cQuery += " AND SE1.E1_VENCTO > '" + cDtCP + "'"
cQuery += " AND SE1.E1_XFLAGES = 'S'"
cQuery += " AND SE1.E1_XCONTRA = '"+ cNVenda +"'"
cQuery += " AND SE1.E1_CLIENTE = '"+ cCodCli +"'"
cQuery += " AND SE1.E1_LOJA = '"+ cLojaCli +"'"
cQuery += " AND SE1.D_E_L_E_T_ = ''"

cQuery:=ChangeQuery(cQuery)

If Select(cLP)>0
	(cLP)->(dbCloseArea())
Endif

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cLP, .T., .T. )

nValLP := (cLP)->VALOR

(cLP)->(dbCloseArea())

//Marca o E1.XFLAGES
cSql := "UPDATE "+RetSqlName("SE1")+" SET E1_XFLAGES = '', E1_XVECTOA = '', E1_XSALDOA = ''"
cSql += " WHERE "
cSql += " E1_FILIAL = '"+ xFilial("SE1") +"'"
cSql += " AND E1_TIPO = 'REC'"
cSql += " AND E1_VENCTO > '" + cDtCP + "'"
cSql += " AND E1_XFLAGES = 'S'"
cSql += " AND E1_XCONTRA = '"+ cNVenda +"'"
cSql += " AND E1_CLIENTE = '"+ cCodCli +"'"
cSql += " AND E1_LOJA = '"+ cLojaCli +"'"
cSql += " AND E1_XSALDOA > 0"
cSql += " AND D_E_L_E_T_ = ''"

TCSQLEXEC(cSql)
TCREFRESH(RetSqlName("SE1"))

Return nValLP

//-----------------------------------------------------------------------
/*/{Protheus.doc} ConsTpVd()

Consulta Tipo da Venda

@param		Número da venda
@return		Tipo da Venda
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ConsTpVd(cVenda)
LOCAL cParseURL	:= ALLTRIM(SuperGetMv("AS_RMURLWS",.T.,"http://localhost:8051")) + "/wsConsultaSQL/MEX?wsdl"
LOCAL cUser		:= SuperGetMv("AS_RMUWS",.T.,"mestre")
LOCAL cPass		:= SuperGetMv("AS_RMPWS",.T.,"totvs")
LOCAL oWsdl
LOCAL xRet		:= .F.
LOCAL lRet		:= .T.
LOCAL cRETSend	:= ""
LOCAL aSimple	:= {}
LOCAL nX		:= 0
LOCAL cErro		:= ""
LOCAL cAviso	:= ""
LOCAL aResult   := {}
LOCAL cResult   := ""
LOCAL cName		:= "ASTIN005"

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
	xRet := oWsdl:SetAuthentication( cUser, cPass )
	IF !xRet
		cRETSend 	:= "Não foi possível autenticar o usuário (" + cUser + ") no serviço RM: " + oWsdl:cError
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
			oWsdl:SetValue( nID, cName )
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "CODCOLIGADA"
			oWsdl:SetValue( nID, "0" )
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "CODSISTEMA"
			oWsdl:SetValue( nID, "X"  ) // TOP = M, TIN = X
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "PARAMETERS"
			oWsdl:SetValue( nID, "CVENDA=" + cVenda )
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
		cRETSend	:= "Não foi possível enviar a mensagem ao serviço RM: " + oWsdl:cError
		lRet 		:= .F.
	ENDIF
ENDIF


//-----------------------------------------------------------------------
// Pega a mensagem de resposta
//-----------------------------------------------------------------------
IF lRet
	cXML := oWsdl:GetSoapResponse()
	cXML := STRTRAN(cXML, "&lt;", "<")
	cXML := STRTRAN(cXML, "&gt;", ">")
	cXML := STRTRAN(cXML, "&#xD;", "")
	
	IF "<TIPOVENDA>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_TIPOVENDA:TEXT
			aAdd(aResult,cResult)
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Atenção" )
		ENDIF
	ENDIF
	IF "<TXFINANCIAMENTO>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_TXFINANCIAMENTO:TEXT
			aAdd(aResult,cResult)
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Atenção" )
		ENDIF
	ENDIF
	
	
ELSE
	IF !EMPTY(cRETSend)
		ApMsgAlert( cRETSend, "Atenção" )
	ENDIF
ENDIF

RETURN aResult

//-----------------------------------------------------------------------
/*/{Protheus.doc} ConsReaj()

Consulta data do reajuste e entrega da chave do RM

@param		Número da venda
@return		Tipo da Venda
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ConsReaj(cVenda)
LOCAL cParseURL	:= ALLTRIM(SuperGetMv("AS_RMURLWS",.T.,"http://localhost:8051")) + "/wsConsultaSQL/MEX?wsdl"
LOCAL cUser		:= SuperGetMv("AS_RMUWS",.T.,"mestre")
LOCAL cPass		:= SuperGetMv("AS_RMPWS",.T.,"totvs")
LOCAL oWsdl
LOCAL xRet		:= .F.
LOCAL lRet		:= .T.
LOCAL cRETSend	:= ""
LOCAL aSimple	:= {}
LOCAL nX		:= 0
LOCAL cErro		:= ""
LOCAL cAviso	:= ""
LOCAL aResult   := {}
LOCAL cResult   := ""
LOCAL cName		:= "ASTIN007"

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
	xRet := oWsdl:SetAuthentication( cUser, cPass )
	IF !xRet
		cRETSend 	:= "Não foi possível autenticar o usuário (" + cUser + ") no serviço RM: " + oWsdl:cError
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
			oWsdl:SetValue( nID, cName )
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "CODCOLIGADA"
			oWsdl:SetValue( nID, "0" )
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "CODSISTEMA"
			oWsdl:SetValue( nID, "X"  ) // TOP = M, TIN = X
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "PARAMETERS"
			oWsdl:SetValue( nID, "CVENDA=" + cVenda )
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
		cRETSend	:= "Não foi possível enviar a mensagem ao serviço RM: " + oWsdl:cError
		lRet 		:= .F.
	ENDIF
ENDIF


//-----------------------------------------------------------------------
// Pega a mensagem de resposta
//-----------------------------------------------------------------------
IF lRet
	cXML := oWsdl:GetSoapResponse()
	cXML := STRTRAN(cXML, "&lt;", "<")
	cXML := STRTRAN(cXML, "&gt;", ">")
	cXML := STRTRAN(cXML, "&#xD;", "")
	
	IF "<DTREAJUSTE>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_DTREAJUSTE:TEXT
			aAdd(aResult,cResult)
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Atenção" )
		ENDIF
	ENDIF
	IF "<DATAENTREGACHAVE>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_DATAENTREGACHAVE:TEXT
			aAdd(aResult,cResult)
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Atenção" )
		ENDIF
	ENDIF
	
	
ELSE
	IF !EMPTY(cRETSend)
		ApMsgAlert( cRETSend, "Atenção" )
	ENDIF
ENDIF

RETURN aResult

//-----------------------------------------------------------------------
/*/{Protheus.doc} ConsReaj()

Consulta data do reajuste e entrega da chave do RM

@param		Número da venda
@return		Tipo da Venda
@author 	Fabiano Albuquerque
@since 		23/03/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ConsReCM( cVenda, dReajust, dLP )
LOCAL cParseURL	:= ALLTRIM(SuperGetMv("AS_RMURLWS",.T.,"http://localhost:8051")) + "/wsConsultaSQL/MEX?wsdl"
LOCAL cUser		:= SuperGetMv("AS_RMUWS",.T.,"mestre")
LOCAL cPass		:= SuperGetMv("AS_RMPWS",.T.,"totvs")
LOCAL oWsdl
LOCAL xRet		:= .F.
LOCAL lRet		:= .T.
LOCAL cRETSend	:= ""
LOCAL aSimple	:= {}
LOCAL nX		:= 0
LOCAL cErro		:= ""
LOCAL cAviso	:= ""
LOCAL aResult   := {}
LOCAL cResult   := ""
LOCAL cName		:= "ASTIN006"

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
	xRet := oWsdl:SetAuthentication( cUser, cPass )
	IF !xRet
		cRETSend 	:= "Não foi possível autenticar o usuário (" + cUser + ") no serviço RM: " + oWsdl:cError
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
			oWsdl:SetValue( nID, cName )
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "CODCOLIGADA"
			oWsdl:SetValue( nID, "0" )
		ENDIF
		IF UPPER(ALLTRIM(cNome)) == "CODSISTEMA"
			oWsdl:SetValue( nID, "X"  ) // TOP = M, TIN = X
		ENDIF
//		IF UPPER(ALLTRIM(cNome)) == "PARAMETERS"
//			oWsdl:SetValue( nID, "CVENDA=" + cVenda )
//		ENDIF
//		IF UPPER(ALLTRIM(cNome)) == "PARAMETERS"
//			oWsdl:SetValue( nID, "DREAJUST=" + Dtos(dReajust) )
//		ENDIF
//		IF UPPER(ALLTRIM(cNome)) == "PARAMETERS"
//			oWsdl:SetValue( nID, "DLP=" + Dtos(dLP) )
//		ENDIF
		
		IF UPPER(ALLTRIM(cNome)) == "PARAMETERS"
				oWsdl:SetValue( nID, "CVENDA=" + cVenda + ";DREAJUST=" + Dtos(dReajust) + ";DLP=" + Dtos(dLP) )
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
		cRETSend	:= "Não foi possível enviar a mensagem ao serviço RM: " + oWsdl:cError
		lRet 		:= .F.
	ENDIF
ENDIF


//-----------------------------------------------------------------------
// Pega a mensagem de resposta
//-----------------------------------------------------------------------
IF lRet
	cXML := oWsdl:GetSoapResponse()
	cXML := STRTRAN(cXML, "&lt;", "<")
	cXML := STRTRAN(cXML, "&gt;", ">")
	cXML := STRTRAN(cXML, "&#xD;", "")
	
	IF "<VALORCP>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_VALORCP:TEXT
			aAdd(aResult,cResult)
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Atenção" )
		ENDIF
	ENDIF
	IF "<VALORLP>" $ cXML
		oResult	:= XmlParser(cXML, "_", @cErro, @cAviso)
		IF EMPTY(cErro)
			cResult := oResult:_S_ENVELOPE:_S_BODY:_RealizarConsultaSQLResponse:_RealizarConsultaSQLResult:_NEWDATASET:_RESULTADO:_VALORLP:TEXT
			aAdd(aResult,cResult)
		ELSE
			cRETSend 	:= ALLTRIM(cErro)
			
			ApMsgAlert( cRETSend, "Atenção" )
		ENDIF
	ENDIF
	
	
ELSE
	IF !EMPTY(cRETSend)
		ApMsgAlert( cRETSend, "Atenção" )
	ENDIF
ENDIF

RETURN aResult