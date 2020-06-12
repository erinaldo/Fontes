#include 'protheus.ch'
#include 'topconn.ch'                                                    
#Include "ApWizard.ch"
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA6S
@Gera lançamentos de consolidação - Job
@param		{GRP,EMP+UN+FILIAL,Codigo,Numero de meses " 1, mês corrente, 2, dois úmtimos meses...,99 - Exercício}
@           Job: U_ASCTBA6S({"01","0110001","001",1})
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION ASCTBA6S(aParam)         
CONOUT("INICIO DO JOB - CONSOLIDAÇÃO")
CONOUT("Código: "+aParam[3])
CONOUT("Período: "+STR(aParam[4]),2)
CONOUT("Grupo: "+aParam[1])
CONOUT("Empresa: "+aParam[2])

RpcSetType( 3 )
RpcSetEnv( aParam[1], aParam[2],,,'CTB')	
Private cPatch := GetSrvProfString("StartPath","")+"TEMP\"
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
Local dIniSche  := CTOD(SPACE(8)) 
Local dCalcDt	:= dDataBase
Local nX        := 0            
Local nOpca     := 0       
Local aSays     := {}
Local aButtons  := {}
Local aParam 	:= {}                
Local _aParNew  := {}
Local lSche   	:= IF(VALTYPE(pSche)=="L",pSche,.F.)
Local cPar		:= ""
Private cCodigo 	:= ""
Private dIniPer 	:= FirstDay(dDataBase)
Private dFimPer		:= LastDay(dDataBase)
Private oWizard, oPanel                                      
Private lContinua 	:= .T.
Private cArqPar 	:= "ASCTBA06.INI"                 
Private cMail		:= Space(100)
Private cContaMEP	:= SPACE(TAMSX3("CT1_CONTA")[1])
Private cGRPL		:= SPACE(TAMSX3("CT1_CONTA")[1])
Private cResul		:= SPACE(10)

IF lSche      
            
	IF aParam[4] == 99                                                                         
		dIniSche := CTOD("01/01/"+STR(YEAR(dDataBase),4))
	ELSE           
		dIniSche := dDataBase			
		FOR nX := 1 TO aParam[4]	
			dIniSche := FirstDay(dCalcDt)
			dCalcDt  := dIniSche - 1
		NEXT
	ENDIF	

	cCodigo 	:= aParam[3]
	dIniPer 	:= dIniSche
	dFimPer 	:= dDataBase
	nOpca    	:= 1
	lContinua 	:= .T.

ELSE	                    

	DEFINE WIZARD oWizard TITLE "Consolidação Contábil" ;
			HEADER "Efetua a contabilização entre empresas conforme estrutura." ;
			MESSAGE "Assistente para consolidação contábil entre as empresas configuradas." ;
			TEXT "Este assistente tem como abjetivo auxiliar na Consolidação Contábil entre as empresas conforme estrutura de consolidação." ;
			NEXT {|| PARINI(), .T.} ;
			FINISH {|| .T. } ; 
       		PANEL

	// Codigo da estrutura
 	CREATE PANEL oWizard ;
          	HEADER "Parâmetros de consolidação" ;
          	MESSAGE "Informe os parâmetros de consolidação." ;
          	BACK {|| IF(!Empty(cCodigo),VLDDOC(cCodigo),.T.) } ;
			NEXT {|| IF(!Empty(cCodigo),.T.,.F.).AND. lContinua } ;
			FINISH {|| IF(!Empty(cCodigo),VLDDOC(cCodigo),.T.).AND. IF(!lContinua,MSGINFO("ATENÇÃO! Informe um código de consolidação válido!"),.T.) } ;
			PANEL
			oPanel := oWizard:GetPanel(1)
   			@ 15,15 SAY "Estrutura de Consolidação" SIZE 100,8 PIXEL OF oPanel
			@ 25,15 MSGET cCodigo PICTURE "@!" F3 "SZ6" VALID Eval({||IF(!Empty(cCodigo),VLDDOC(cCodigo),.T.),;
		    IF(!lContinua,MSGINFO("Estrutura invalida."),.T.) ,;
		    lContinua }) SIZE 50,10 PIXEL OF oPanel  
			@ 45,15 SAY "Periodo de" SIZE 45,8 PIXEL OF oPanel
			@ 55,15 MSGET dIniPer PICTURE "@D" VALID Eval({|| IF(Empty(dIniPer), lContinua := .F., lContinua := .T.), IF(!lContinua, MsgInfo("Informe uma data válida."),.T.),lContinua}) SIZE 60,10 PIXEL OF oPanel  
			@ 75,15 SAY "Periodo ate" SIZE 45,8 PIXEL OF oPanel
			@ 85,15 MSGET dFimPer PICTURE "@D" VALID Eval({|| IF(Empty(dFimPer) .OR. dFimPer < dIniPer, lContinua := .F., lContinua := .T.), IF(!lContinua, MsgInfo("Informe uma data válida."),.T.),lContinua}) SIZE 60,10 PIXEL OF oPanel   

	// Contas do PL
 	CREATE PANEL oWizard ;
          	HEADER "Contas de eliminação do MEP & PL." ;
          	MESSAGE "Contas de eliminação do MEP & PL." ;
          	BACK {|| .T. } ;
          	NEXT {|| lContinua } ;
          	FINISH {|| lContinua } ;
          	EXEC {|| lContinua } ; 
		  	PANEL                    	
			oPanel := oWizard:GetPanel(2)
   			@ 15,15 SAY "Conta do MEP" SIZE 100,8 PIXEL OF oPanel
			@ 25,15 MSGET cContaMEP PICTURE "@!" F3 "CT1" VALID Eval({||lContinua := CT1->(DBSEEK(XFILIAL("CT1")+cContaMEP)),;
		    IF(!lContinua,MSGINFO("Conta do MEP inválida."),.T.) ,;
		    lContinua }) SIZE 50,10 PIXEL OF oPanel  
			@ 45,15 SAY "Grupo de Contas do PL" SIZE 45,8 PIXEL OF oPanel
			@ 55,15 MSGET cGRPL     PICTURE "@!" F3 "CT1"  VALID Eval({||lContinua := CT1->(DBSEEK(XFILIAL("CT1")+cGRPL)),;
		    IF(!lContinua,MSGINFO("Grupo de contas inválido."),.T.) ,;
		    lContinua }) SIZE 50,10 PIXEL OF oPanel  
			@ 75,15 SAY "Grupos de contas de resultado, Ex: 3, 4, 5" SIZE 45,8 PIXEL OF oPanel
			@ 85,15 MSGET cResul     PICTURE "@!" SIZE 50,10 PIXEL OF oPanel  

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

cPar := cCodigo + CRLF
cPar += DTOC(dIniPer) + CRLF
cPar += DTOC(dFimPer) + CRLF
cPar += ALLTRIM(cMail) + CRLF

MEMOWRITE(cArqPar,cPar)

IF lContinua   

	Aadd(aSays, OemToAnsi(" Esta rotina ira gerar a consolidação das empresas conforme os parâmetros:"))
	Aadd(aSays, OemToAnsi(" Estrutura  : "+cCodigo ))
	Aadd(aSays, OemToAnsi(" Empresa    : "+SM0->M0_CODIGO+"-"+SM0->M0_CODFIL+" - "+SM0->M0_NOMECOM))
	Aadd(aSays, OemToAnsi(" Periodo de : "+DTOC(dIniPer)+" a "+DTOC(dFimPer)))
	Aadd(aButtons, { 1, .T., { || nOpca := 1, FechaBatch()  }})	
	Aadd(aButtons, { 2, .T., { || nOpca := 0, FechaBatch() }})

	FormBatch("Consolidação de Empresas", aSays, aButtons)

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
		aAdd(_aParNew, cFilAnt 			)
		aAdd(_aParNew, cCodigo			)
		aAdd(_aParNew, dIniPer			)
		aAdd(_aParNew, dFimPer			)
		aAdd(_aParNew, .T.				)			
		aAdd(_aParNew, cUserName		)						
		aAdd(_aParNew, cMail			)								
		aAdd(_aParNew, cContaMEP		)								
		aAdd(_aParNew, cGRPL			)												
		aAdd(_aParNew, cResul			)														
		//Inicia Processamento via JOB
		StartJob('U_ASCTBA07', GetEnvServer(), .F., _aParNew )
			
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
cQ := "SELECT Z6_EMP, Z6_CODIGO"
cQ += " FROM "+RetSqlName("SZ6")+" SZ6 "   
cQ += " WHERE Z6_CODIGO = '"+cCodigo+"'"
cQ += " AND D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ6" NEW	
			
IF XSZ6->(EOF())
	lContinua := .F.
ELSE
	// Verifica se está na consolidadora da estrutura selecionada
	IF SUBSTR(cEmpAnt,1,2) <> SUBSTR(XSZ6->Z6_EMP,1,2)
		ApMsgAlert("E necessário estar na consolidadora da estrutura selecionada para executar a consolidação!")
		lContinua := .F.
	ENDIF
ENDIF   

XSZ6->(DBCLOSEAREA())

RETURN(lContinua)

Static Function PARINI
Local nHDL	  	:= 0
Local nConta	:= 0

nHDL := FT_FUSE(cArqPar)
IF nHDL > 0
                  
	FT_FGOTOP()                
	While ! FT_FEOF()                   
		nConta++
		  
		DO CASE
			CASE nConta == 1
				cCodigo := ALLTRIM(FT_FREADLN())		
			CASE nConta == 2
				dIniPer := CTOD(ALLTRIM(FT_FREADLN()))
			CASE nConta == 3
				dFimPer := CTOD(ALLTRIM(FT_FREADLN()))
			CASE nConta == 4
				cMail   := ALLTRIM(FT_FREADLN())
				cMail   := cMail+SPACE(100-LEN(cMail))
		ENDCASE		
        
		FT_FSKIP()			        

	END

ENDIF

FCLOSE(nHDL)
FT_FUSE()

Return