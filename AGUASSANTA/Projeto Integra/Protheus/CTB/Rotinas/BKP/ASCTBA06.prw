#include 'protheus.ch'
#include 'topconn.ch'                                                    
#Include "ApWizard.ch"
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA6S
@Gera lan�amentos de consolida��o - Job
@param		{Grupo, Empresa, Codigo}
@           Job: U_ASCTBA6S({"01","0110001","001","email"})
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION ASCTBA6S(aParam)         
CONOUT("INICIO DO JOB - CONSOLIDA��O")
CONOUT("Grupo: "+aParam[1])
CONOUT("Empresa: "+aParam[2])
CONOUT("C�digo: "+aParam[3])

RpcSetType( 3 )
RpcSetEnv( aParam[1], aParam[2],,,'CTB')	
U_ASCTBA06(.T.,aParam)
RpcClearEnv()                         
CONOUT("FIM DO JOB DE CONSOLIDA��O")
RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA06
@Gera lan�amentos de consolida��o
@param		pSche,aParam
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
User Function ASCTBA06(pSche,aParam)         
Local nX        := 0            
Local nOpca     := 0       
Local aSays     := {}
Local aButtons  := {}
Local _aParNew  := {}
Local lSche   	:= IF(VALTYPE(pSche)=="L",pSche,.F.)
Local cPar		:= ""
Local cQ		:= ""
Private cCodigo 	:= "   "
Private cDesCod 	:= SPACE(LEN(SZ6->Z6_DESCRI))
Private dIniPer 	:= FirstDay(dDataBase)
Private dFimPer		:= LastDay(dDataBase) 
Private cPer		:= SPACE(06)
Private oWizard, oPanel                                      
Private lContinua 	:= .T.                              
Private cMail		:= Space(100)
Private cEmpCons	:= ""

IF lSche      
	cCodigo 	:= aParam[3]
	dIniPer 	:= FirstDay(dDataBase)
	dFimPer 	:= LastDay(dDataBase)
	cMail		:= aParam[4]
	nOpca    	:= 1
	lContinua 	:= .T.
ELSE	                    

	// Verifica se est� na consolidadora da estrutura selecionada
	cQ := "SELECT Z6_EMP "
	cQ += " FROM "+RetSqlName("SZ6")+" SZ6 "   
	cQ += " WHERE LEFT(Z6_EMP,2) = '"+SUBSTR(cEmpAnt,1,2)+"'"
	cQ += " AND D_E_L_E_T_ = ' '"
	TcQuery ChangeQuery(cQ) ALIAS "XSZ6" NEW	

	IF SUBSTR(cEmpAnt,1,2) <> SUBSTR(XSZ6->Z6_EMP,1,2)
		ApMsgAlert("E necess�rio estar no grupo de consolida��o: "+SUBSTR(SZ6->Z6_EMP,1,2)+", para executar a consolida��o!")
		lContinua := .F.
	ENDIF
    
    XSZ6->(DBCLOSEAREA())
    
    IF lContinua

		DEFINE WIZARD oWizard TITLE "Consolida��o Cont�bil" ;
				HEADER "Efetua a contabiliza��o entre empresas conforme estrutura." ;
				MESSAGE "Assistente para consolida��o cont�bil entre as empresas configuradas." ;
				TEXT "Este assistente tem como abjetivo auxiliar na Consolida��o Cont�bil entre as empresas conforme estrutura de consolida��o." ;
				NEXT {|| .T.} ;
				FINISH {|| lContinua := .F., .T. } ; 
	       		PANEL                        
				oPanel := oWizard:GetPanel(1)       		
	
		// Codigo da estrutura
	 	CREATE PANEL oWizard ;
	          	HEADER "Par�metros de consolida��o" ;
	          	MESSAGE "Informe os par�metros de consolida��o." ;
				NEXT {|| IF(!Empty(cCodigo),.T.,.F.) .AND. lContinua } ;
				FINISH {|| lContinua := .F., .T. } ;
				PANEL
				oPanel := oWizard:GetPanel(2)
	   			@ 45,15 SAY "Estrutura de Consolida��o" SIZE 100,8 PIXEL OF oPanel
				@ 55,15 MSGET cCodigo PICTURE "!!!" F3 "SZ6" VALID Eval({|| VLDDOC(cCodigo),;
			    IF(!lContinua,MSGINFO("Estrutura invalida."),.T.) ,;
			    lContinua }) SIZE 50,10 PIXEL OF oPanel                                   
				@ 55,60 MSGET cDesCod PICTURE "@!" WHEN .F.	SIZE 100,10 PIXEL OF oPanel		    
				@ 75,15  SAY "Ref. Mes e Ano " SIZE 45,8 PIXEL OF oPanel
				@ 85,15  MSGET cPer PICTURE "999999" VALID Eval({|| IF(Empty(cPer), lContinua := .F., lContinua := .T.), IF(!lContinua, MsgInfo("Informe um per�odo v�lido."),.T.),lContinua}) SIZE 60,10 PIXEL OF oPanel  
	
	   	// Email de confirma��o
	   	CREATE PANEL oWizard ;
				HEADER "E-mail de confirma��o" ;
	   			MESSAGE "Informe o e-mail de confirma��o do encerramento da consolida��o." ;
	          	BACK {|| .T. } ;
	          	NEXT {|| .F. } ;
	          	FINISH {|| lContinua } ;
	          	EXEC {|| lContinua } ; 
			  	PANEL          
			   	oPanel := oWizard:GetPanel(3)
				@ 15,15 SAY "E-mail de confirma��o" SIZE 100,8 PIXEL OF oPanel
				@ 25,15 MSGET cMail  SIZE 150,10 PIXEL OF oPanel  
	
		ACTIVATE WIZARD oWizard CENTERED

	ENDIF
	
ENDIF

IF lContinua

	dIniPer := CTOD("01/"+SUBSTR(cPer,1,2)+"/"+SUBSTR(cPer,3,4))
	dFimPer := LastDay(dIniPer)	
 
	IF  !EMPTY(dIniPer)

		Aadd(aSays, OemToAnsi(" Esta rotina ira gerar a consolida��o das empresas conforme os par�metros:"))
		Aadd(aSays, OemToAnsi(" Estrutura  : "+cCodigo+" "+cDesCod ))
		Aadd(aSays, OemToAnsi(" Empresa    : "+cEmpCons))
		Aadd(aSays, OemToAnsi(" Periodo de : "+DTOC(dIniPer)+" a "+DTOC(dFimPer)))
		Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})	
		Aadd(aButtons, { 2, .T., { || nOpca := 0, FechaBatch() }})

		FormBatch("Consolida��o de Empresas", aSays, aButtons)
		
    ENDIF
ENDIF

If nOpca == 1 
                           
	// Verifica se algum usu�rio est� consolidando 

	If ! ( MayIUseCode('ASCTBA06_'+cCodigo,cUserName) )// Trava o codigo da estrutura de modo exclusivo
		ApMsgAlert("A rotina j� est� em execu��o para esta estrutura.")		               		
		lContinua := .F.    		
 	ELSE
		FreeUsedCode(.T.)	 	
	ENDIF	                 

	IF lContinua
		_aParNew := {}		
		aAdd(_aParNew, cEmpAnt 			)   
		aAdd(_aParNew, RIGHT(cEmpCons,7))
		aAdd(_aParNew, cCodigo			)
		aAdd(_aParNew, dIniPer			)
		aAdd(_aParNew, dFimPer			)
		aAdd(_aParNew, .T.				)			
		aAdd(_aParNew, cUserName		)						
		aAdd(_aParNew, cMail			)								
		//Inicia Processamento via JOB
		//StartJob('U_ASCTBA07', GetEnvServer(), .F., _aParNew )
		U_ASCTBA07( _aParNew )

		IF !lSche      
			ApMsgInfo("Processamento iniciado. Quando encerrar ser� enviado e-mail para: "+ALLTRIM(cMail)+".   Para acompanhar utilize o Monitor de Consolida��o.")
		ENDIF
		
	ENDIF

ENDIF
	
Return


Static Function VLDDOC(cCodigo)
Local cQ := ""       
                   
lContinua := .T.

// Verifica se existe a estrutura informada
cQ := "SELECT Z6_EMP, Z6_CODIGO, Z6_DESCRI "
cQ += " FROM "+RetSqlName("SZ6")+" SZ6 "   
cQ += " WHERE Z6_CODIGO = '"+cCodigo+"'"
cQ += " AND D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ6" NEW	
			
IF XSZ6->(EOF())
	lContinua := .F.
ELSE
	cEmpCons := Z6_EMP 
	cDesCod  := XSZ6->Z6_DESCRI  
	oPanel:Refresh()
ENDIF   

XSZ6->(DBCLOSEAREA())          

RETURN(lContinua)
