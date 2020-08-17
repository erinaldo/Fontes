#include 'protheus.ch'
#include 'parmtype.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA01
@Cadastro de Eventos de Equivalência 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
user function ASCTBA02()
Private cTitulo := OEMTOANSI("Eventos de Equivalência")    
Private cCadastro := cTitulo
Private aRotina := MenuDef()         
Private cDelFunc := "U_ASCTB02E()" // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString  := "SZ1"

dbSelectArea(cString)         
(cString)->(dbSetOrder(1))

mBrowse( 6,1,22,75,cString)

Return        
//-----------------------------------------------------------------------
/*{Protheus.doc} MenuDef
@Definição de aRotina 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
Static Function MenuDef()
Local aRotina :=  { {"Pesquisar","AxPesqui" ,0,1},;
					{"Visualizar","AxVisual",0,2},;
					{"Incluir"   ,"AxInclui",0,3},;
					{"Alterar"   ,"AxAltera",0,4},;
					{"Excluir"   ,"AxDeleta",0,5}}
Return aRotina       
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB02E
@Valida a exclusão 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                                                                                 
USER FUNCTION ASCTB02E
Local lRet := .T.

// Verifica se o evento está vinculado a algum relacionamento de equivalência

IF !MsgYesNo("Confirma a exclusão do evento?")
	lRet := .F.
ENDIF

Return(lRet)
//-----------------------------------------------------------------------
/*{Protheus.doc} APUR
@Calcula a apuracao de resultado do mes 
@param		grupo+empresa+unidade+filial, grupos de contas de apuracao (3, 4, 5) , tipo de saldo, moeda, Empresa/Filial
@return		valor calculado
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                      
User Function APUR(pEmpresa, pGrpCon, pTpSld, pMoeda)
Local cProc		:= 'POPUTRB_'+CriaTrab(nil,.F.)                            
Local cSQL      := ""
Local aResult   := {}
Local cGrpEmp	:= SUBSTR(pEmpresa,1,2)
Local cEmpresa  := RIGHT(pEmpresa,TAMSX3("CVX_FILIAL")[1])
Local cGrpCon   := FormatIN(IF(TYPE("pGrpCon") == "C", pGrpCon, "3,4,5"),",")
Local cTpSld	:= IF(TYPE("pTpSld") == "C", pTpSld, "1")
Local cMoeda    := IF(TYPE("pMoeda") == "C", pMoeda, "01")
Local cData     := DTOS(LASTDAY(dDataBase))
Local cTabCVX 	:= U_RtTab("CVX",cGrpEmp)       
Local nValAp    := 0


cSQL:="create procedure "+cProc+" (@OUT_RET numeric(17,2) output) as"+CRLF
cSQL+="Declare @credito     numeric(17,2)"+CRLF                            
cSQL+="Declare @debito      numeric(17,2)"+CRLF                           
cSQL+="Declare @conta       varchar("+alltrim(str(TamSX3('CVX_NIV01')[1]))+")"+CRLF                            
cSQL+="Declare @natureza    varchar(1)"+CRLF      
cSQL+="Declare @saldoap     numeric(17,2)"+CRLF
cSQL+="Begin "+CRLF
cSQL+=" "+CRLF
cSQL+="		select @saldoap = 0 "+CRLF 
cSQL+=" "+CRLF
cSQL+="		declare CVXCUR01 cursor for"+CRLF
cSQL+="		select "+CRLF
cSQL+="     SUM(CVX_SLDCRD) AS CREDITO,"+CRLF
cSQL+="     SUM(CVX_SLDDEB) AS DEBITO,"+CRLF
cSQL+="     CVX_NIV01 "+CRLF
cSQL+= " 	from "+cTabCVX
cSQL += "   where CVX_FILIAL = '"+cEmpresa+"' AND CVX_CONFIG = '01' AND SUBSTRING(CVX_NIV01,1,1) IN "+cGrpCon+" "+CRLF  
cSQL += "         and CVX_MOEDA= '"+cMoeda+"' and CVX_TPSALD = '"+cTpSld+"' and CVX_DATA <= '"+cData+"' and D_E_L_E_T_ = ' '"+CRLF

cSQL += " 	group by CVX_NIV01 "+CRLF

cSQL+="		open CVXCUR01 "+CRLF
cSQL+=" 	fetch next from CVXCUR01 into "+CRLF
cSQL+=" 	@credito,"+CRLF  
cSQL+=" 	@debito,"+CRLF 
cSQL+=" 	@conta"+CRLF 
cSQL+=" "+CRLF
cSQL+="		while @@FETCH_STATUS = 0 "+CRLF                         
cSQL+="			begin"+CRLF                  
cSQL+=" 			Select @natureza = CT1_NORMAL from "+RetSqlName("CT1")+" where CT1_FILIAL = '"+XFILIAL("CT1")+"' and CT1_CONTA = @conta and D_E_L_E_T_ = ' ' "+CRLF
cSQL+=" "+CRLF     
cSQL+="             If @natureza = '1' Begin "+CRLF     // Natureza devedora, subtrai  do  resultado o saldo da conta (debito - credito)
cSQL+="             	Select @saldoap = @saldoap - (@debito - @credito) end "+CRLF
cSQL+="             Else Begin"+CRLF					// Natureza credora,  adiciona no  resultado o saldo da conta (credito - debito)
cSQL+="               	Select @saldoap = @saldoap + (@credito - @debito) "+CRLF
cSQL+=" 		 	end"+CRLF                     
cSQL+=" "+CRLF
cSQL+=" 		fetch next from CVXCUR01 into "+CRLF
cSQL+=" 		@credito,"+CRLF  
cSQL+=" 		@debito,"+CRLF 
cSQL+=" 		@conta"+CRLF 
cSQL+=" "+CRLF
cSQL+=" 	end"+CRLF   
cSQL+=" 	close CVXCUR01"+CRLF
cSQL+=" 	deallocate CVXCUR01"+CRLF
cSQL+=" 	commit"+CRLF
cSQL+=" 	Select @OUT_RET = @saldoap"+CRLF
cSQL+=" "+CRLF
cSQL+="end"+CRLF

MemoWrite("APURA.SQL",cSQL)	     		
		
// Ajusta a expressão para o Banco de Dados
cSQL:=MsParse(cSQL,Alltrim(TcGetDB()))
                                            
IF EMPTY(cSQL)                                                                      
	ApMsgAlert("Erro ao criar a stored procedure - PARSE.")
	lRet := .F.
ELSE                                  
	MemoWrite("APURP.SQL",cSQL)	
	cRet:=TcSqlExec(cSQL)
	IF cRet <> 0
		ApMsgAlert("Erro ao criar a stored procedure - TCSQLEXEC.")
		lRet := .F.
	ELSE
		aResult := TCSPExec( cProc, '' )	
		
		if empty(aResult)                                                                                   
			ApMsgAlert("Erro ao executar a stored procedure.")
			lRet := .F.    
		endif      
	
	ENDIF
ENDIF                     

IF TCSPExist( cProc ) 
	TcSqlExec('DROP PROCEDURE '+cProc)
endif                

nValAp := aResult[1]
           

RETURN(nValAp)                                                                                                
//-----------------------------------------------------------------------
/*{Protheus.doc} SALDOMOV
@Apura o saldo do movimento de um conjunto de contas
@param		grupo+empresa+unidade+filial, conta inicial, database, moeda, tipo de saldo, conta final, data inicial
@return		valor calculado
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                      
USER FUNCTION SALDOMOV(pEmpresa,pConta, pDataBase, pMoeda, pTpSaldo,pContaF,pDataIni)
Local cProc		:= 'POPUTRB_'+CriaTrab(nil,.F.)                            
Local cSQL      := ""
Local aResult   := {}
Local cGrpEmp	:= SUBSTR(pEmpresa,1,2)
Local cEmpresa  := RIGHT(pEmpresa,TAMSX3("CVX_FILIAL")[1])
Local cContaIni := pConta         
Local cContaFim	:= IF(EMPTY(pContaF),pConta,pContaF)
Local cDataFim  := DTOS(dDataBase)
Local cDataIni  := DTOS(dDataIni)
Local cMoeda    := IF(TYPE("pMoeda") == "C", pMoeda, "01") 
Local cTpSaldo  := pTpSaldo
Local cTabCVX 	:= U_RtTab("CVX",cGrpEmp)       
Local nValAp    := 0                 

cSQL:="create procedure "+cProc+" (@OUT_RET numeric(17,2) output) as"+CRLF
cSQL+="Declare @credito     numeric(17,2)"+CRLF                            
cSQL+="Declare @debito      numeric(17,2)"+CRLF                           
cSQL+="Declare @conta       varchar("+alltrim(str(TamSX3('CVX_NIV01')[1]))+")"+CRLF                            
cSQL+="Declare @natureza    varchar(1)"+CRLF      
cSQL+="Declare @saldoap     numeric(17,2)"+CRLF
cSQL+="Begin "+CRLF
cSQL+=" "+CRLF
cSQL+="		select @saldoap = 0 "+CRLF 
cSQL+=" "+CRLF
cSQL+="		declare CVXCUR01 cursor for"+CRLF
cSQL+="		select "+CRLF
cSQL+="     SUM(CVX_SLDCRD) AS CREDITO,"+CRLF
cSQL+="     SUM(CVX_SLDDEB) AS DEBITO,"+CRLF
cSQL+="     CVX_NIV01 "+CRLF
cSQL+= " 	from "+cTabCVX
cSQL += "   where CVX_FILIAL = '"+cEmpresa+"' AND CVX_CONFIG = '01' AND CVX_NIV01 >= '"+pContaIni+"' AND CVX_NIV01 <= '"+pContaFim+"' "+CRLF  
cSQL += "         and CVX_MOEDA= '"+cMoeda+"' and CVX_TPSALD = '"+cTpSldo+"' and CVX_DATA >= '"+cDataIni+"' and CVX_DATA <= '"+cDataFim+"' and D_E_L_E_T_ = ' '"+CRLF

cSQL += " 	group by CVX_NIV01 "+CRLF

cSQL+="		open CVXCUR01 "+CRLF
cSQL+=" 	fetch next from CVXCUR01 into "+CRLF
cSQL+=" 	@credito,"+CRLF  
cSQL+=" 	@debito,"+CRLF 
cSQL+=" 	@conta"+CRLF 
cSQL+=" "+CRLF
cSQL+="		while @@FETCH_STATUS = 0 "+CRLF                         
cSQL+="			begin"+CRLF                  
cSQL+=" 			Select @natureza = CT1_NORMAL from "+RetSqlName("CT1")+" where CT1_FILIAL = '"+XFILIAL("CT1")+"' and CT1_CONTA = @conta and D_E_L_E_T_ = ' ' "+CRLF
cSQL+=" "+CRLF     
cSQL+="             If @natureza = '1' Begin "+CRLF     // Natureza devedora, subtrai  do  resultado o saldo da conta (debito - credito)
cSQL+="             	Select @saldoap = @saldoap - (@debito - @credito) end "+CRLF
cSQL+="             Else Begin"+CRLF					// Natureza credora,  adiciona no  resultado o saldo da conta (credito - debito)
cSQL+="               	Select @saldoap = @saldoap + (@credito - @debito) "+CRLF
cSQL+=" 		 	end"+CRLF                     
cSQL+=" "+CRLF
cSQL+=" 		fetch next from CVXCUR01 into "+CRLF
cSQL+=" 		@credito,"+CRLF  
cSQL+=" 		@debito,"+CRLF 
cSQL+=" 		@conta"+CRLF 
cSQL+=" "+CRLF
cSQL+=" 	end"+CRLF   
cSQL+=" 	close CVXCUR01"+CRLF
cSQL+=" 	deallocate CVXCUR01"+CRLF
cSQL+=" 	commit"+CRLF
cSQL+=" 	Select @OUT_RET = @saldoap"+CRLF
cSQL+=" "+CRLF
cSQL+="end"+CRLF

MemoWrite("SALDOMOVS.SQL",cSQL)	     		
		
// Ajusta a expressão para o Banco de Dados
cSQL:=MsParse(cSQL,Alltrim(TcGetDB()))
                                            
IF EMPTY(cSQL)                                                                      
	ApMsgAlert("Erro ao criar a stored procedure - PARSE.")
	lRet := .F.
ELSE                                  
	MemoWrite("SALDOMOVP.SQL",cSQL)	
	cRet:=TcSqlExec(cSQL)
	IF cRet <> 0
		ApMsgAlert("Erro ao criar a stored procedure - TCSQLEXEC.")
		lRet := .F.
	ELSE
		aResult := TCSPExec( cProc, '' )	
		
		if empty(aResult)                                                                                   
			ApMsgAlert("Erro ao executar a stored procedure.")
			lRet := .F.    
		endif      
	
	ENDIF
ENDIF                     

IF TCSPExist( cProc ) 
	TcSqlExec('DROP PROCEDURE '+cProc)
endif                

nValAp := aResult[1]

RETURN(nValAp)

//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB02V
@Valida a Fórmula digitada
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION ASCTB02V(pForm)    
Local lRet       := .T.
Local bError     := ErrorBlock( { |e| AvaliaErro(e) } )
xRet             := ""
BEGIN SEQUENCE
	xRet := &(pForm)
	Recover
    lRet := .F.
END SEQUENCE
IF !lRet
	MSGALERT("Erro na formula.")
ENDIF                                              
RETURN(lRet)      
STATIC FUNCTION AvaliaErro(e)
cMenErro := e:Description
If !Empty(cMenErro)
	Break
	Return(.F.)
EndIf
RETURN(.T.)