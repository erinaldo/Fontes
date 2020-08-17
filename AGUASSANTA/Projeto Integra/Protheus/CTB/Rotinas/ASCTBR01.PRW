#include 'protheus.ch'
#include 'topconn.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBR01
@Rotina de impressão do processamento da Equivalência
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
USER Function ASCTBR01
Local oReport        
Local aParam 		:= {}                
Local aBox   		:= {}      
Local lContinua		:= .T.
Local lDif          := .F.                         '
Private dRef 		:= CTOD(SPACE(8))
Private cInveste 	:= ""
Private nPeriodos	:= 0
Private cContaPL 	:= ""
Private cCadastro 	:= "Equivalência Patrimonial"
Private cRevisao  	:= "000"
Private dRevisao  	:= CTOD(SPACE(8))

AADD(aBox,	{ 1, "Mes e Ano Base", 	Space(6),"@!","" ,"",".T.",20,.T.	}) 
AADD(aBox,	{ 1, "Investidora", 	Space(LEN(cFilAnt)+2),"@!","" ,"EMP",".T.",30,.T.	}) 
AADD(aBox,	{ 2, "Periodos Anteriores", 	"0",{"0","1","2","3","4","5","6","7","8","9","10","11","12"},30 ,".T.",.T.}) 

If ParamBox( aBox,cCadastro,aParam,,,,,,,,.F.,.T.)
	dRef 		:= CTOD("01/"+SUBSTR(ALLTRIM(aParam[1]),1,2)+"/"+SUBSTR(ALLTRIM(aParam[1]),3,4))
	cInveste	:= ALLTRIM(aParam[2])
	nPeriodos	:= VAL(aParam[3])+1
	cContaPL:= "203                 "
	oReport := Report()
	oReport:PrintDialog()
ENDIF

RETURN 
//-----------------------------------------------------------------------
/*{Protheus.doc} Report
@Monta objeto de impressão
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
Static Function Report
Local oReport 
Local oSection1

oReport:= TReport():New("ASCTBR01","Equivalência Patrimonial","", {|oReport| Ledados(oReport)},"Equivalência Patrimonial") 

oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Controle de Equivalência Patrimonial",{})
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderPage()
oSection1:SetEditCell(.F.)                        
                                                                                          
TRCell():New(oSection1,"EMPRESA"  ,,""  ,/*Picture*/,50,.F., 	 {|| EQVA->EMPRESA})
TRCell():New(oSection1,"TEXTO01"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO01,50)})
TRCell():New(oSection1,"DIFE01"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE01,50)})
TRCell():New(oSection1,"TEXTO02"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO02,50)})
TRCell():New(oSection1,"DIFE02"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE02,50)})
TRCell():New(oSection1,"TEXTO03"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO03,50)})
TRCell():New(oSection1,"DIFE03"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE03,50)})
TRCell():New(oSection1,"TEXTO04"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO04,50)})
TRCell():New(oSection1,"DIFE04"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE04,50)})
TRCell():New(oSection1,"TEXTO05"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO05,50)})
TRCell():New(oSection1,"DIFE05"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE05,50)})
TRCell():New(oSection1,"TEXTO06"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO06,50)})
TRCell():New(oSection1,"DIFE06"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE01,50)})
TRCell():New(oSection1,"TEXTO07"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO07,50)})
TRCell():New(oSection1,"DIFE07"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE07,50)})
TRCell():New(oSection1,"TEXTO08"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO08,50)})
TRCell():New(oSection1,"DIFE08"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE08,50)})
TRCell():New(oSection1,"TEXTO09"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO09,50)})
TRCell():New(oSection1,"DIFE09"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE09,50)})
TRCell():New(oSection1,"TEXTO10"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO10,50)})
TRCell():New(oSection1,"DIFE10"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE10,50)})
TRCell():New(oSection1,"TEXTO11"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO11,50)})
TRCell():New(oSection1,"DIFE11"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE11,50)})
TRCell():New(oSection1,"TEXTO12"  ,,""  ,/*Picture*/,50,.F.,     {|| PADR(EQVA->TEXTO12,50)})
TRCell():New(oSection1,"DIFE12"  ,,""  ,/*Picture*/,50,.F.,      {|| PADR(EQVA->DIFE12,50)})

Return(oReport)
//-----------------------------------------------------------------------
/*{Protheus.doc} Ledados
@Seleciona os dados de impressão
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
Static Function Ledados(oReport)
Local oSection1 := oReport:Section(1) 
Local cQ		:= ""  
Local nSaldo	:= 0     
Local nX 	:= 0
Local cMens	:= ""
Local dAtu	:= dRef          
Local lPeriodo:= .T.
Local lContinua	:= .F. 
Local aPeriodos := {}
Local cCampo 	:= ""      
CriaTrb()

// Verifica se os periodos possuem os cadastros de participação

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= "002"
EQVA->EMPRESA   := "Períodos: "

FOR nX := 1 TO 12
	
	lPeriodo := .T.

	dRevisao := dAtu

	IF !U_VLDSZ0(.F.)   
		lPeriodo := .F.
	ELSE
		IF !U_VLDSZ2(.F.)   
			lPeriodo := .F.
		ENDIF                                  
	ENDIF

	AADD(aPeriodos,{dRevisao,lPeriodo,cRevisao})

   	cCampo := "TEXTO"+STRZERO(13-nX,2)    
    EQVA->&(cCampo) := PADC(STRZERO(MONTH(dAtu),2)+"/"+ALLTRIM(STR(YEAR(dAtu))),50) 
	
   	cCampo := "DIFE"+STRZERO(13-nX,2)    
    EQVA->&(cCampo) := "Diferença PL"

	dAtu := FirstDay(dAtu - 1)

NEXT nX     

EQVA->(MsUnlock())

// Verifica se existem periodos válidos

FOR nX := 1 TO nPeriodos
	IF !aPeriodos[nX][2]                            
		IF EMPTY(cMens)
			cMens := "Não localizado participação para periodo: "
		ENDIF	
		cMens += DTOC(aPeriodos[nX][1]) + " - "
	ELSE
		lContinua := .T.
	ENDIF
NEXT nX

IF !lContinua
	ApMsgAlert(cMens)
	return()
ENDIF

IF lContinua

	cQ := "SELECT Z0_EMPRESA, Z0_RAZAO FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+cInveste+"' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                                                                                      

	RECLOCK("EQVA",.T.)
 	EQVA->CHAVE 	:= "000"
 	EQVA->EMPRESA   := cInveste+" - "+ALLTRIM(XSZ0->Z0_RAZAO)
 	MsUnlock()
	XSZ0->(DBCLOSEAREA())

	RECLOCK("EQVA",.T.)
 	EQVA->CHAVE 	:= "001"
 	EQVA->EMPRESA   := "Controle de equivalência patrimonial"
 	MsUnlock()

	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= "004"
	EQVA->EMPRESA   := "Patrimônio Líquido"
	MsUnlock()

	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= "005"
	EQVA->EMPRESA   := "Resultado do mês"
	MsUnlock()

	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= "006"
	EQVA->EMPRESA   := "Qdade ações / quotas da empresa"
	MsUnlock()
                                                         
	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= "007"
	EQVA->EMPRESA   := "Qdade ações / quotas detidas"
	MsUnlock()

	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= "008"
	EQVA->EMPRESA   := "Percentual de Participação"
	MsUnlock()

	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= "009"
	EQVA->EMPRESA   := "Valor do Investimento atual"
	MsUnlock()

	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= "010"
	EQVA->EMPRESA   := "Lançamentos Contábeis"
	MsUnlock()


	FOR nX := 1 TO 12     
		IF nX <= nPeriodos
			IF aPeriodos[nX][2]
				lDif := AtuTrb(aPeriodos[nX][1],aPeriodos[nX][3],13-nX)
				IF !lDif
					cCampo := "DIFE"+STRZERO(13-nX,2)
					oSection1:Cell(cCampo):Disable()											
				ENDIF
			ENDIF                               
		ELSE	
			cCampo := "TEXTO"+STRZERO(13-nX,2)
			oSection1:Cell(cCampo):Disable()						                            
			cCampo := "DIFE"+STRZERO(13-nX,2)
			oSection1:Cell(cCampo):Disable()														
		ENDIF
	NEXT
ENDIF

EQVA->(DBGOTOP())

oReport:IncMeter()      
oSection1:Init()    

IF ALLTRIM(EQVA->CHAVE) == "000"
	oReport:PrintText(EQVA->EMPRESA)
	EQVA->(DBSKIP())       
	oReport:IncMeter()
ENDIF
    
IF ALLTRIM(EQVA->CHAVE) == "001"
	oReport:PrintText(EQVA->EMPRESA)       
	EQVA->(DBSKIP())  
	oReport:IncMeter()	     
ENDIF

IF ALLTRIM(EQVA->CHAVE) == "002"
	oSection1:PrintLine()
	oReport:ThinLine()
	oReport:SkipLine()
	EQVA->(DBSKIP())  
	oReport:IncMeter()	     
ENDIF

IF ALLTRIM(EQVA->CHAVE) == "004"
	oReport:PrintText(EQVA->EMPRESA)       
	oReport:ThinLine()
	EQVA->(DBSKIP())  
	oReport:IncMeter()	     

   	WHILE EQVA->(!EOF()) .AND. SUBSTR(ALLTRIM(EQVA->CHAVE),1,3) == "004" .AND. LEN(ALLTRIM(EQVA->CHAVE)) > 3
		oSection1:PrintLine()
		EQVA->(DBSKIP())     
		oReport:IncMeter()	     		
	END                  
	oReport:SkipLine()   
ENDIF
    
IF ALLTRIM(EQVA->CHAVE) == "005"
	oReport:PrintText(EQVA->EMPRESA)       
	oReport:ThinLine()
	EQVA->(DBSKIP())  
	oReport:IncMeter()	     

   	WHILE EQVA->(!EOF()) .AND. SUBSTR(ALLTRIM(EQVA->CHAVE),1,3) == "005" .AND. LEN(ALLTRIM(EQVA->CHAVE)) > 3
		oSection1:PrintLine()
		EQVA->(DBSKIP())
		oReport:IncMeter()	     		
	END                  
	oReport:SkipLine()   
ENDIF

IF ALLTRIM(EQVA->CHAVE) == "006"
	oReport:PrintText(EQVA->EMPRESA)       
	oReport:ThinLine()
	EQVA->(DBSKIP())  
	oReport:IncMeter()	     

   	WHILE EQVA->(!EOF()) .AND. SUBSTR(ALLTRIM(EQVA->CHAVE),1,3) == "006" .AND. LEN(ALLTRIM(EQVA->CHAVE)) > 3
		oSection1:PrintLine()
		EQVA->(DBSKIP())
		oReport:IncMeter()	     		
	END
	oReport:SkipLine()   
ENDIF

IF ALLTRIM(EQVA->CHAVE) == "007"
	oReport:PrintText(EQVA->EMPRESA)       
	oReport:ThinLine()
	EQVA->(DBSKIP())  
	oReport:IncMeter()	     

   	WHILE EQVA->(!EOF()) .AND. SUBSTR(ALLTRIM(EQVA->CHAVE),1,3) == "007" .AND. LEN(ALLTRIM(EQVA->CHAVE)) > 3
		oSection1:PrintLine()
		EQVA->(DBSKIP())
		oReport:IncMeter()	     		
	END
	oReport:SkipLine()   
ENDIF

IF ALLTRIM(EQVA->CHAVE) == "008"
	oReport:PrintText(EQVA->EMPRESA)       
	oReport:ThinLine()
	EQVA->(DBSKIP())  
	oReport:IncMeter()	     

   	WHILE EQVA->(!EOF()) .AND. SUBSTR(ALLTRIM(EQVA->CHAVE),1,3) == "008" .AND. LEN(ALLTRIM(EQVA->CHAVE)) > 3
		oSection1:PrintLine()
		EQVA->(DBSKIP())
		oReport:IncMeter()	     		
	END
	oReport:SkipLine()   	
ENDIF
                                                                       

IF ALLTRIM(EQVA->CHAVE) == "009"
	oReport:PrintText(EQVA->EMPRESA)       
	oReport:ThinLine()
	EQVA->(DBSKIP())  
	oReport:IncMeter()	    
	 
   	WHILE EQVA->(!EOF()) .AND. SUBSTR(ALLTRIM(EQVA->CHAVE),1,3) == "009" .AND. LEN(ALLTRIM(EQVA->CHAVE)) > 3
		oSection1:PrintLine()
		EQVA->(DBSKIP())
		oReport:IncMeter()	     		
	END
	oReport:SkipLine()   
ENDIF
                                                                       
IF ALLTRIM(EQVA->CHAVE) == "010"
	oReport:PrintText(EQVA->EMPRESA)       
	oReport:ThinLine()
	EQVA->(DBSKIP())  
	oReport:IncMeter()	     

   	WHILE EQVA->(!EOF()) .AND. SUBSTR(ALLTRIM(EQVA->CHAVE),1,3) == "010" .AND. LEN(ALLTRIM(EQVA->CHAVE)) > 3
		oSection1:PrintLine()
		EQVA->(DBSKIP())
		oReport:IncMeter()	     		
	END
	oReport:SkipLine()   
ENDIF

oSection1:Finish()

Return()                
//-----------------------------------------------------------------------
/*{Protheus.doc} CriaTrb
@Cria tabela temporária
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		10/11/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            	
Static Function CriaTrb
Local aCampos	:={}
Local cArqTmp 	:= ""
Local nX 		:= 0       
Local cOrdem	:= "CHAVE"

IF SELECT("EQVA") > 0
	EQVA->(DBCLOSEAREA())
ENDIF

aAdd(aCampos,{"CHAVE"	 , "C" , 50,0})  // Conteudo da coluna
aAdd(aCampos,{"EMPRESA"	 , "C" , 50,0})  // Conteudo da coluna
FOR nX := 1 TO 12
	aAdd(aCampos,{"TEXTO"+STRZERO(nX,2)    , "C" , 50,0})  // Conteudo da coluna
NEXT nX                                            
FOR nX := 1 TO 12
	aAdd(aCampos,{"DIFE"+STRZERO(nX,2)    , "C" , 50,0})  // Conteudo da coluna
NEXT nX                                            
cArqTmp := CriaTrab(aCampos)
dbUseArea( .T.,, cArqTmp, "EQVA", .F., .F. )
IndRegua("EQVA", cArqTmp, cOrdem ,,,,)
EQVA->(DBSETORDER(1))      

RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} AtuTrb
@Atualiza periodo
@param		Data de referencia, Código de revisão
@return		Nenhum
@author 	Zema
@since 		10/11/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------   
STATIC FUNCTION AtuTrb(pData, pRevisao, pNum)         
Local cQ 		:= ""
Local cFilOri   := cFilAnt
Local cTexto	:= "" 
Local cTextoDif := "" 
Local nPl		:= 0
Local nVal 		:= 0        
Local nSaldo	:= 0
Local cCampo	:= ""           
Local cConta	:= "000"
Local lDif		:= .F.
Local cEmpLan	:= ""
Local lEmp		:= .T.                                     
Local cOper		:= IIf(Upper(TcGetDb())$'ORACLE.POSTGRES.DB2.INFORMIX','||','+')

// Carrega as investidas no periodo

cQ := "SELECT Z2_EMP, Z2_EMPPAR, Z2_QUANT FROM "+RetSqlName("SZ2")+" WHERE Z2_EMP = '"+cInveste+"' AND  Z2_DTBASE = '"+DTOS(pData)+"' AND  D_E_L_E_T_ = ' ' "
cQ += "ORDER BY Z2_EMPPAR "
TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW                                                                                      

WHILE XSZ2->(!EOF())
                       
	cQ := "SELECT * FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+XSZ2->Z2_EMPPAR+"' AND Z0_REVISAO = '"+pRevisao+"' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                                                                                      

	// 2-PL

    cFilAnt := SUBSTR(XSZ0->Z0_EMPRESA,3,7) 
  
    // Saldo do PL, mês atual
	nSaldo 	:= CtSmEntMov("203001001001001","203999999999999",FirstDay(pData),LastDay(pData),"01","1",2)  
	nPL		:= nSaldo
	cTexto :=  PADL(TRANSFORM(nSaldo,"@E 99,999,999,999.99"),50)
    
    IF !EQVA->(MsSeek("004"+XSZ0->Z0_EMPRESA))
		RECLOCK("EQVA",.T.)
		EQVA->CHAVE 	:= "004"+XSZ0->Z0_EMPRESA
		EQVA->EMPRESA   := ALLTRIM(XSZ0->Z0_RAZAO)
	ELSE
		RECLOCK("EQVA",.F.)	
	ENDIF
   	cCampo := "TEXTO"+STRZERO(pNum,2)    
    EQVA->&(cCampo) := cTexto
	MsUnlock()

	// 3-RESULTADO
    
    // Resultado do mês atual
	nSaldo := CtSmEntMov("301001001001001","305002001001002",FirstDay(pData),LastDay(pData),"01","1",3)
	cTexto :=  PADL(TRANSFORM(nSaldo,"@E 99,999,999,999.99"),50)

    IF !EQVA->(MsSeek("005"+XSZ0->Z0_EMPRESA))
		RECLOCK("EQVA",.T.)
		EQVA->CHAVE 	:= "005"+XSZ0->Z0_EMPRESA
		EQVA->EMPRESA   := ALLTRIM(XSZ0->Z0_RAZAO)
	ELSE
		RECLOCK("EQVA",.F.)	
	ENDIF
   	cCampo := "TEXTO"+STRZERO(pNum,2)    
    EQVA->&(cCampo) := cTexto
	MsUnlock()

	// 4-QUANTIDADE AÇÕES

    // Quantidade de Ações do mês
	cQ := "SELECT Z3_EMP, Z3_EMPPAR, Z3_EVENTO, Z3_VALOR, Z3_CT2, Z3_ACOES, Z3_QUOTAS, Z3_MOEDA FROM "+RetSqlName("SZ3")+" WHERE Z3_EMP = '"+cInveste+"' AND Z3_EMPPAR = '"+XSZ0->Z0_EMPRESA+"' AND Z3_DTBASE = '"+DTOS(LastDay(pData))+"' AND Z3_STATUS = 'ATIVO' AND Z3_EVENTO <> '' AND D_E_L_E_T_ = ' ' "
	cQ += " ORDER BY Z3_EMPPAR, Z3_EVENTO "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ3" NEW                                                                                      

	cTexto :=  PADL(TRANSFORM(XSZ3->Z3_ACOES,"@E 9,999,999,999,999"),50)

    IF !EQVA->(MsSeek("006"+XSZ0->Z0_EMPRESA))
		RECLOCK("EQVA",.T.)
		EQVA->CHAVE 	:= "006"+XSZ0->Z0_EMPRESA
		EQVA->EMPRESA   := ALLTRIM(XSZ0->Z0_RAZAO)
	ELSE
		RECLOCK("EQVA",.F.)	
	ENDIF
   	cCampo := "TEXTO"+STRZERO(pNum,2)    
    EQVA->&(cCampo) := cTexto
	MsUnlock()

	// 5-QUANTIDADE DE AÇÕES DETIDAS                      

	cTexto :=  PADL(TRANSFORM(XSZ3->Z3_QUOTAS,"@E 9,999,999,999,999"),50)

    IF !EQVA->(MsSeek("007"+XSZ0->Z0_EMPRESA))
		RECLOCK("EQVA",.T.)
		EQVA->CHAVE 	:= "007"+XSZ0->Z0_EMPRESA
		EQVA->EMPRESA   := ALLTRIM(XSZ0->Z0_RAZAO)
	ELSE
		RECLOCK("EQVA",.F.)	
	ENDIF
   	cCampo := "TEXTO"+STRZERO(pNum,2)    
    EQVA->&(cCampo) := cTexto
	MsUnlock()

	// 6-PERCENTUAL PARTICIPAÇÃO
	
    // Ações e Quotas detidas
	cTexto 	:=  PADL(TRANSFORM( XSZ3->Z3_QUOTAS / XSZ3->Z3_ACOES * 100,"@E 99999999999.99999"),50)
	nVal	:= XSZ3->Z3_QUOTAS / XSZ3->Z3_ACOES * 100

    IF !EQVA->(MsSeek("008"+XSZ0->Z0_EMPRESA))
		RECLOCK("EQVA",.T.)
		EQVA->CHAVE 	:= "008"+XSZ0->Z0_EMPRESA
		EQVA->EMPRESA   := ALLTRIM(XSZ0->Z0_RAZAO)
	ELSE
		RECLOCK("EQVA",.F.)	
	ENDIF
   	cCampo := "TEXTO"+STRZERO(pNum,2)    
    EQVA->&(cCampo) := cTexto
	MsUnlock()
	
	// 7-INVESTIMENTO ATUAL     --- 21/02 - IMPRIMIR O CALCULADO - NO INVESTIMENTO VERIFICAR TAMBÉM A CONTA DE PASSIVO DESCOBERTO
    
    nVal := Round(nPL * nVal / 100,2)       
    
    cFilAnt := SUBSTR(XSZ2->Z2_EMP,3,7) 

  
	IF !EMPTY(XSZ0->Z0_ITEMCTA) .AND. XSZ0->Z0_MOEDA == "01"

		// Investimento atual 
		nSaldo := MovItem(XSZ0->Z0_CONTA,"ZZZZZZ",XSZ0->Z0_ITEMCTA,FirstDay(pData),LastDay(pData),"01","1",4)  
		cTexto :=  PADL(TRANSFORM(ABS(nSaldo),"@E 99,999,999,999.99"),50)
	ELSE
		// Investimento atual empresa do Exterior 
		nSaldo := MovConta(XSZ0->Z0_CONTA,LastDay(pData),LastDay(pData),"01","1",4)
		cTexto :=  PADL(TRANSFORM(ABS(nSaldo),"@E 99,999,999,999.99"),50)
	ENDIF
    
	IF ABS(nVal) <> ABS(nSaldo)
		nVal := ABS(nSaldo) - ABS(nVal)
	  	PADL(cTextoDif := TRANSFORM(nVal,"@E 99,999,999,999.99"),50)
		lDif	:= .T.
	ELSE
		cTextoDif := ""
	ENDIF	  
	  
    IF !EQVA->(MsSeek("009"+XSZ0->Z0_EMPRESA))
		RECLOCK("EQVA",.T.)
		EQVA->CHAVE 	:= "009"+XSZ0->Z0_EMPRESA
		EQVA->EMPRESA   := ALLTRIM(XSZ0->Z0_RAZAO)
	ELSE
		RECLOCK("EQVA",.F.)	
	ENDIF
   	cCampo := "TEXTO"+STRZERO(pNum,2)    
    EQVA->&(cCampo) := cTexto
    
    IF !EMPTY(cTextoDif)
	   	cCampo := "DIFE"+STRZERO(pNum,2)    
 		EQVA->&(cCampo) := cTextoDif
    ENDIF
    
	MsUnlock()

	cEmpLan := ""
	cConta := "000"

	// 8-LANCAMENTOS CONTÁBEIS           
	WHILE XSZ3->(!EOF())
      
        IF cEmpLan <> XSZ3->Z3_EMPPAR
        	cEmpLan := XSZ3->Z3_EMPPAR
        	lEmp := .T.
        ELSE
        	lEmp := .F.
        ENDIF
        
		cQ := "SELECT * FROM "+RetSqlName("CT2")+" WHERE CT2_FILIAL"+cOper+"CT2_DATA"+cOper+"CT2_LOTE"+cOper+"CT2_SBLOTE"+cOper+"CT2_DOC = '"+ALLTRIM(XSZ3->Z3_CT2)+"' "
 		cQ += " AND D_E_L_E_T_ = ' ' AND CT2_MOEDLC = '"+XSZ3->Z3_MOEDA+"' AND CT2_DC <> '4' ORDER BY CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA"
		TcQuery ChangeQuery(cQ) ALIAS "XCT2" NEW                                                                                      

		WHILE XCT2->(!EOF())

			cTexto := "LCTO: "+DTOC(STOD(XCT2->CT2_DATA))+"/"+XCT2->CT2_LOTE+"/"+XCT2->CT2_DOC+XCT2->CT2_LINHA
		
			cConta := Soma1(cConta)          
			cCampo := "TEXTO"+STRZERO(pNum,2)    
	
			IF !EQVA->(MsSeek("010"+XSZ3->Z3_EMPPAR+cConta))
				RECLOCK("EQVA",.T.)
				EQVA->CHAVE 	:= "010"+XSZ3->Z3_EMPPAR+cConta
				IF lEmp
					EQVA->EMPRESA   := ALLTRIM(XSZ0->Z0_RAZAO)
					lEmp := .F.
				ENDIF
			ELSE
				RECLOCK("EQVA",.F.)
			ENDIF
			EQVA->&(cCampo) := cTexto
			MsUnlock()

			cTexto := "D-"+XCT2->CT2_DEBITO + ALLTRIM(POSICIONE("CT1",1,XFILIAL("CT1")+XCT2->CT2_DEBITO,"CT1_DESC01"))
			cConta := Soma1(cConta)
			cCampo := "TEXTO"+STRZERO(pNum,2)    
		
			IF !EQVA->(MsSeek("010"+XSZ3->Z3_EMPPAR+cConta))
				RECLOCK("EQVA",.T.)
				EQVA->CHAVE 	:= "010"+XSZ3->Z3_EMPPAR+cConta
			ELSE
				RECLOCK("EQVA",.F.)
			ENDIF
		 	EQVA->&(cCampo) := cTexto
			MsUnlock()
		
			cTexto := "C-"+XCT2->CT2_CREDIT + ALLTRIM(POSICIONE("CT1",1,XFILIAL("CT1")+XCT2->CT2_CREDIT,"CT1_DESC01"))
			cConta := Soma1(cConta)
			cCampo := "TEXTO"+STRZERO(pNum,2)    
		
			IF !EQVA->(MsSeek("010"+XSZ3->Z3_EMPPAR+cConta))
				RECLOCK("EQVA",.T.)
				EQVA->CHAVE 	:= "010"+XSZ3->Z3_EMPPAR+cConta
			ELSE
				RECLOCK("EQVA",.F.)
			ENDIF
		 	EQVA->&(cCampo) := cTexto
			MsUnlock()

			cTexto := PADL(TRANSFORM(XCT2->CT2_VALOR,"@E 99,999,999,999.99"),50)
			cConta := Soma1(cConta)
			cCampo := "TEXTO"+STRZERO(pNum,2)    
		
			IF !EQVA->(MsSeek("010"+XSZ3->Z3_EMPPAR+cConta))
				RECLOCK("EQVA",.T.)
				EQVA->CHAVE 	:= "010"+XSZ3->Z3_EMPPAR+cConta
			ELSE
				RECLOCK("EQVA",.F.)
			ENDIF
		 	EQVA->&(cCampo) := cTexto
			MsUnlock()

			cTexto := ""
			cConta := Soma1(cConta)
			cCampo := "TEXTO"+STRZERO(pNum,2)    
		
			IF !EQVA->(MsSeek("010"+XSZ3->Z3_EMPPAR+cConta))
				RECLOCK("EQVA",.T.)
				EQVA->CHAVE 	:= "010"+XSZ3->Z3_EMPPAR+cConta
			ELSE
				RECLOCK("EQVA",.F.)
			ENDIF
		 	EQVA->&(cCampo) := cTexto
			MsUnlock()
								
		 	XCT2->(DBSKIP())                                
		END	 
		XCT2->(DBCLOSEAREA())
		XSZ3->(DBSKIP())
    END

    XSZ3->(DBCLOSEAREA())

	XSZ0->(DBCLOSEAREA())

    XSZ2->(DBSKIP())

    cFilAnt := cFilOri

END   
XSZ2->(DBCLOSEAREA())
RETURN(lDif)
