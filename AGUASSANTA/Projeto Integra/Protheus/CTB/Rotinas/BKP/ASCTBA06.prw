#include 'protheus.ch'
#include 'topconn.ch'                                                    
#Include "ApWizard.ch"
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA6S
@Gera lançamentos de consolidação - Job
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
CONOUT("INICIO DO JOB - CONSOLIDAÇÃO")
CONOUT("Grupo: "+aParam[1])
CONOUT("Empresa: "+aParam[2])
CONOUT("Código: "+aParam[3])

RpcSetType( 3 )
RpcSetEnv( aParam[1], aParam[2],,,'CTB')	
U_ASCTBA06(.T.,aParam)
RpcClearEnv()                         
CONOUT("FIM DO JOB DE CONSOLIDAÇÃO")
RETURN
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA06
@Gera lançamentos de consolidação
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

	// Verifica se está na consolidadora da estrutura selecionada
	cQ := "SELECT Z6_EMP "
	cQ += " FROM "+RetSqlName("SZ6")+" SZ6 "   
	cQ += " WHERE LEFT(Z6_EMP,2) = '"+SUBSTR(cEmpAnt,1,2)+"'"
	cQ += " AND D_E_L_E_T_ = ' '"
	TcQuery ChangeQuery(cQ) ALIAS "XSZ6" NEW	

	IF SUBSTR(cEmpAnt,1,2) <> SUBSTR(XSZ6->Z6_EMP,1,2)
		ApMsgAlert("E necessário estar no grupo de consolidação: "+SUBSTR(SZ6->Z6_EMP,1,2)+", para executar a consolidação!")
		lContinua := .F.
	ENDIF
    
    XSZ6->(DBCLOSEAREA())
    
    IF lContinua

		DEFINE WIZARD oWizard TITLE "Consolidação Contábil" ;
				HEADER "Efetua a contabilização entre empresas conforme estrutura." ;
				MESSAGE "Assistente para consolidação contábil entre as empresas configuradas." ;
				TEXT "Este assistente tem como abjetivo auxiliar na Consolidação Contábil entre as empresas conforme estrutura de consolidação." ;
				NEXT {|| .T.} ;
				FINISH {|| lContinua := .F., .T. } ; 
	       		PANEL                        
				oPanel := oWizard:GetPanel(1)       		
	
		// Codigo da estrutura
	 	CREATE PANEL oWizard ;
	          	HEADER "Parâmetros de consolidação" ;
	          	MESSAGE "Informe os parâmetros de consolidação." ;
				NEXT {|| IF(!Empty(cCodigo),.T.,.F.) .AND. lContinua } ;
				FINISH {|| lContinua := .F., .T. } ;
				PANEL
				oPanel := oWizard:GetPanel(2)
	   			@ 45,15 SAY "Estrutura de Consolidação" SIZE 100,8 PIXEL OF oPanel
				@ 55,15 MSGET cCodigo PICTURE "!!!" F3 "SZ6" VALID Eval({|| VLDDOC(cCodigo),;
			    IF(!lContinua,MSGINFO("Estrutura invalida."),.T.) ,;
			    lContinua }) SIZE 50,10 PIXEL OF oPanel                                   
				@ 55,60 MSGET cDesCod PICTURE "@!" WHEN .F.	SIZE 100,10 PIXEL OF oPanel		    
				@ 75,15  SAY "Ref. Mes e Ano " SIZE 45,8 PIXEL OF oPanel
				@ 85,15  MSGET cPer PICTURE "999999" VALID Eval({|| IF(Empty(cPer), lContinua := .F., lContinua := .T.), IF(!lContinua, MsgInfo("Informe um período válido."),.T.),lContinua}) SIZE 60,10 PIXEL OF oPanel  
	
	   	// Email de confirmação
	   	CREATE PANEL oWizard ;
				HEADER "E-mail de confirmação" ;
	   			MESSAGE "Informe o e-mail de confirmação do encerramento da consolidação." ;
	          	BACK {|| .T. } ;
	          	NEXT {|| .F. } ;
	          	FINISH {|| lContinua } ;
	          	EXEC {|| lContinua } ; 
			  	PANEL          
			   	oPanel := oWizard:GetPanel(3)
				@ 15,15 SAY "E-mail de confirmação" SIZE 100,8 PIXEL OF oPanel
				@ 25,15 MSGET cMail  SIZE 150,10 PIXEL OF oPanel  
	
		ACTIVATE WIZARD oWizard CENTERED

	ENDIF
	
ENDIF

IF lContinua

	dIniPer := CTOD("01/"+SUBSTR(cPer,1,2)+"/"+SUBSTR(cPer,3,4))
	dFimPer := LastDay(dIniPer)	
 
	IF  !EMPTY(dIniPer)

		Aadd(aSays, OemToAnsi(" Esta rotina ira gerar a consolidação das empresas conforme os parâmetros:"))
		Aadd(aSays, OemToAnsi(" Estrutura  : "+cCodigo+" "+cDesCod ))
		Aadd(aSays, OemToAnsi(" Empresa    : "+cEmpCons))
		Aadd(aSays, OemToAnsi(" Periodo de : "+DTOC(dIniPer)+" a "+DTOC(dFimPer)))
		Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})	
		Aadd(aButtons, { 2, .T., { || nOpca := 0, FechaBatch() }})

		FormBatch("Consolidação de Empresas", aSays, aButtons)
		
    ENDIF
ENDIF

If nOpca == 1 
                           
	// Verifica se algum usuário está consolidando 

	If ! ( MayIUseCode('ASCTBA06_'+cCodigo,cUserName) )// Trava o codigo da estrutura de modo exclusivo
		ApMsgAlert("A rotina já está em execução para esta estrutura.")		               		
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
			ApMsgInfo("Processamento iniciado. Quando encerrar será enviado e-mail para: "+ALLTRIM(cMail)+".   Para acompanhar utilize o Monitor de Consolidação.")
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
