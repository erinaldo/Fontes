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
Local aParam := {}                
Local aBox   := {}    
Private dRef := CTOD(SPACE(8))
Private cInveste := ""
Private cContaPL := ""
Private cCadastro := "Equivalência Patrimonial"
Private cTexto1   := ""
Private cTexto2   := ""
Private cTexto3   := ""

AADD(aBox,	{ 1, "Mes e ano de referência", Space(6),"@!","" ,"",".T.",20,.T.	}) 
AADD(aBox,	{ 1, "Investidora", Space(7),"@!","" ,"SM0",".T.",20,.T.	}) 
//AADD(aBox,	{ 1, "Conta PL", Space(20),"@!","" ,"CT1",".T.",50,.T.	}) 


If ParamBox( aBox,cCadastro,aParam,,,,,,,,.F.,.T.)
	dRef := CTOD("01/"+SUBSTR(ALLTRIM(aParam[1]),1,2)+"/"+SUBSTR(ALLTRIM(aParam[1]),3,4))
	cInveste:= cEmpAnt+ALLTRIM(aParam[2])
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
Local oCell         
Local aOrdem   := {}                             

oReport:= TReport():New("ASCTBR01","Equivalência Patrimonial","", {|oReport| Ledados(oReport)},"Equivalência Patrimonial") 

oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Controle de Equivalência Patrimonial",{})
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderPage()
oSection1:SetEditCell(.F.)                        
                                                                                          
TRCell():New(oSection1,"EMPRESA"  ,,""  ,/*Picture*/,50,.F., 	 {|| cTexto1})
TRCell():New(oSection1,"TEXTO"    ,,""  ,/*Picture*/,50,.F.,     {|| PADR(cTexto2,50)})
//TRCell():New(oSection1,"TEXTO3"   ,,""  ,/*Picture*/,50,.F.,     {|| PADR(cTexto3,50)})

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
Local cRevisao  := "000"
Local cUlDataPar:= SPACE(8)         
Local cQ		:= ""  
Local nSaldo	:= 0     
Local cFilOld	:= cFilAnt 

oReport:SetMeter(8)

// Empresa investidora
oSection1:Init()                 
                    
cQ := "SELECT MAX(Z0_REVISAO) REVISAO FROM "+RetSqlName("SZ0")+" WHERE D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                                                                                      
cRevisao := XSZ0->REVISAO
XSZ0->(DBCLOSEAREA())
    
cQ := "SELECT Z0_EMPRESA, Z0_RAZAO FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+cInveste+"' AND Z0_REVISAO = '"+cRevisao+"' AND D_E_L_E_T_ = ' ' "
TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                                                                                      
cTexto1 := XSZ0->Z0_EMPRESA+" - "+ALLTRIM(XSZ0->Z0_RAZAO)                 
XSZ0->(DBCLOSEAREA())
oReport:PrintText(cTexto1)       

oReport:SkipLine()   
oReport:IncMeter()

cTexto1 := "REFERENCIA: "+DTOC(dRef)
oReport:PrintText(cTexto1)       
oReport:SkipLine()   

// Empresas investidas - Patrimonio Liquido
cTexto1 :="Patrimonio Liquido"
oReport:PrintText(cTexto1)       
oReport:ThinLine()
oReport:SkipLine()   
                        
cQ := "SELECT MAX(Z2_DTBASE) REVISAO FROM "+RetSqlName("SZ2")+" WHERE Z2_DTBASE <= '"+DTOS(LastDay(dRef))+"' AND  D_E_L_E_T_ = ' '"
TcQuery ChangeQuery(cQ) ALIAS "YSZ2" NEW                                                                                      
cUlDataPar := YSZ2->REVISAO
YSZ2->(DBCLOSEAREA())
    
cQ := "SELECT Z2_EMP, Z2_EMPPAR, Z2_QUANT FROM "+RetSqlName("SZ2")+" WHERE Z2_EMP = '"+cInveste+"' AND  Z2_DTBASE = '"+cUlDataPar+"' AND  D_E_L_E_T_ = ' ' "
TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW                                                                                      

WHILE XSZ2->(!EOF())

	cQ := "SELECT Z0_EMPRESA, Z0_RAZAO FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+XSZ2->Z2_EMPPAR+"' AND Z0_REVISAO = '"+cRevisao+"' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW

    cFilAnt := SUBSTR(XSZ0->Z0_EMPRESA,3,7) 
    	                                                                                      
	cTexto1 := ALLTRIM(XSZ0->Z0_RAZAO)                 
	XSZ0->(DBCLOSEAREA())
    
    // Saldo do PL, mês atual
	nSaldo := CtSmEntMov("203001001001001","203999999999999",FirstDay(dRef),LastDay(dRef),"01","1",2)  


	cTexto2 :=  TRANSFORM(nSaldo,"@E 99,999,999,999.99")
                                        
    cFilAnt := cFilOld

	oSection1:PrintLine()
   

    XSZ2->(DBSKIP())

END               

oReport:IncMeter()   
oReport:SkipLine()   


// Resultado do mês
cTexto1 := "Resultado do mês"
oReport:PrintText(cTexto1)       
oReport:ThinLine()
oReport:SkipLine()   
                        
XSZ2->(DBGOTOP())
WHILE XSZ2->(!EOF())

	cQ := "SELECT Z0_EMPRESA, Z0_RAZAO FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+XSZ2->Z2_EMPPAR+"' AND Z0_REVISAO = '"+cRevisao+"' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                                                                                      
    cFilAnt := SUBSTR(XSZ0->Z0_EMPRESA,3,7)	
	cTexto1 := ALLTRIM(XSZ0->Z0_RAZAO)                 
	XSZ0->(DBCLOSEAREA())
    
    // Resultado do mês atual
	nSaldo := CtSmEntMov("301001001001001","305002001001002",FirstDay(dRef),LastDay(dRef),"01","1",3)
	
	cTexto2 :=  TRANSFORM(nSaldo,"@E 99,999,999,999.99")
	
	cFilAnt := cFilOld

	oSection1:PrintLine()
   

    XSZ2->(DBSKIP())

END
                     
oReport:SkipLine()   
oReport:IncMeter()

// Quantidade de Ações/Quotas da empresa
cTexto1 := "Quantidade de Ações/Quotas da empresa"
oReport:PrintText(cTexto1)       
oReport:ThinLine()
oReport:SkipLine()   
                     
XSZ2->(DBGOTOP())
WHILE XSZ2->(!EOF())

	cQ := "SELECT Z0_EMPRESA, Z0_RAZAO FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+XSZ2->Z2_EMPPAR+"' AND Z0_REVISAO = '"+cRevisao+"' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                                                                                      
	cTexto1 := ALLTRIM(XSZ0->Z0_RAZAO)                 
                                
    // Quantidade de Ações do mês
	cQ := "SELECT Z3_EMP, Z3_EMPPAR, Z3_EVENTO, Z3_VALOR, Z3_CT2, Z3_ACOES, Z3_QUOTAS FROM "+RetSqlName("SZ3")+" WHERE Z3_EMP = '"+cInveste+"' AND Z3_EMPPAR = '"+XSZ0->Z0_EMPRESA+"' AND Z3_DTBASE = '"+DTOS(LastDay(dRef))+"' AND Z3_STATUS = 'ATIVO' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ3" NEW                                                                                      

    // Ações e Quotas
	cTexto2 :=  TRANSFORM(XSZ3->Z3_ACOES,"@E 9,999,999,999,999") 
     
	XSZ0->(DBCLOSEAREA())
	XSZ3->(DBCLOSEAREA())

	oSection1:PrintLine()
   

    XSZ2->(DBSKIP())

END                  

oReport:SkipLine()   
oReport:IncMeter()

// Quantidade de Ações/Quotas detidas
cTexto1 := "Quantidade de ações/quotas detidas"
oReport:PrintText(cTexto1)       
oReport:ThinLine()
oReport:SkipLine()   

// Quantidade de ações/quotas detidas
XSZ2->(DBGOTOP())
WHILE XSZ2->(!EOF())

	cQ := "SELECT Z0_EMPRESA, Z0_RAZAO FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+XSZ2->Z2_EMPPAR+"' AND Z0_REVISAO = '"+cRevisao+"' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                                                                                      
	cTexto1 := ALLTRIM(XSZ0->Z0_RAZAO)                 
                                
    // Quantidade de Ações do mês
	cQ := "SELECT Z3_EMP, Z3_EMPPAR, Z3_EVENTO, Z3_VALOR, Z3_CT2, Z3_ACOES, Z3_QUOTAS FROM "+RetSqlName("SZ3")+" WHERE Z3_EMP = '"+cInveste+"' AND Z3_EMPPAR = '"+XSZ0->Z0_EMPRESA+"' AND Z3_DTBASE = '"+DTOS(LastDay(dRef))+"' AND Z3_STATUS = 'ATIVO' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ3" NEW                                                                                      
    
    // Ações e Quotas detidas
	cTexto2 :=  TRANSFORM(XSZ3->Z3_QUOTAS,"@E 9,999,999,999,999") 
     
	XSZ0->(DBCLOSEAREA())
	XSZ3->(DBCLOSEAREA())

	oSection1:PrintLine()
   

    XSZ2->(DBSKIP())

END                  

oReport:SkipLine()   

oReport:IncMeter()

// Percentual de Participação
cTexto1 := "Percentual de Participação"
oReport:PrintText(cTexto1)       
oReport:ThinLine()
oReport:SkipLine()   

     
// Percentual de participação                       
XSZ2->(DBGOTOP())
WHILE XSZ2->(!EOF())

	cQ := "SELECT Z0_EMPRESA, Z0_RAZAO FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+XSZ2->Z2_EMPPAR+"' AND Z0_REVISAO = '"+cRevisao+"' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                                                                                      
	cTexto1 := ALLTRIM(XSZ0->Z0_RAZAO)                 
                                
    // Quantidade de Ações do mês
	cQ := "SELECT Z3_EMP, Z3_EMPPAR, Z3_EVENTO, Z3_VALOR, Z3_CT2, Z3_ACOES, Z3_QUOTAS FROM "+RetSqlName("SZ3")+" WHERE Z3_EMP = '"+cInveste+"' AND Z3_EMPPAR = '"+XSZ0->Z0_EMPRESA+"' AND Z3_DTBASE = '"+DTOS(LastDay(dRef))+"' AND Z3_STATUS = 'ATIVO' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ3" NEW                                                                                      
    
    // Ações e Quotas detidas
	cTexto2 :=  TRANSFORM( XSZ3->Z3_QUOTAS / XSZ3->Z3_ACOES * 100,"@E 9999.99999") 
     
	XSZ0->(DBCLOSEAREA())
	XSZ3->(DBCLOSEAREA())

	oSection1:PrintLine()
   

    XSZ2->(DBSKIP())

END
                     
oReport:SkipLine()   

oReport:IncMeter()

// Valor do Investimento atual
cTexto1 := "Valor do Investimento atual"
oReport:PrintText(cTexto1)       
oReport:ThinLine()
oReport:SkipLine()   
      
// Valor do investimento atual
                       
XSZ2->(DBGOTOP())
WHILE XSZ2->(!EOF())

	cQ := "SELECT Z0_EMPRESA, Z0_RAZAO, Z0_CONTA, Z0_ITEMCTA, Z0_MOEDA, Z0_CNPJ FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+XSZ2->Z2_EMPPAR+"' AND Z0_REVISAO = '"+cRevisao+"' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                                                                                      
    cFilAnt := SUBSTR(XSZ0->Z0_EMPRESA,3,7)
	cTexto1 := ALLTRIM(XSZ0->Z0_RAZAO)                 
  
	IF !EMPTY(XSZ0->Z0_ITEMCTA) .AND. !EMPTY(XSZ0->Z0_CNPJ)
                                
		// Investimento atual 
		nSaldo := MovClass(XSZ0->Z0_CONTA,,XSZ0->Z0_ITEMCTA,,LastDay(dRef),LastDay(dRef),"01","1",4)
		cTexto2 :=  TRANSFORM(nSaldo,"@E 99,999,999,999.99")
	ELSE
		// Investimento atual empresa do Exterior 
		nSaldo := MovConta(XSZ0->Z0_CONTA,LastDay(dRef),LastDay(dRef),"01","1",4)
		//nSaldo := MovClass(XSZ0->Z0_CONTA,,XSZ0->Z0_ITEMCTA,,LastDay(dRef),LastDay(dRef),XSZ0->Z0_MOEDA,"1",4)
		cTexto2 :=  TRANSFORM(nSaldo,"@E 99,999,999,999.99")

	ENDIF

	XSZ0->(DBCLOSEAREA())

    cFilAnt := cFilOld
	oSection1:PrintLine()
   

    XSZ2->(DBSKIP())

END
                     
oReport:SkipLine()   

// Valor do Investimento atual
cTexto1 := "Lançamentos Contábeis"
oReport:PrintText(cTexto1)       
oReport:ThinLine()
oReport:SkipLine()   

// Lançamentos Contábeis
                       
XSZ2->(DBGOTOP())
WHILE XSZ2->(!EOF())

	cQ := "SELECT Z0_EMPRESA, Z0_RAZAO, Z0_CONTA, Z0_ITEMCTA, Z0_MOEDA, Z0_CNPJ FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+XSZ2->Z2_EMPPAR+"' AND Z0_REVISAO = '"+cRevisao+"' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW                                                                                      
    cFilAnt := SUBSTR(XSZ0->Z0_EMPRESA,3,7)
	cTexto1 := ALLTRIM(XSZ0->Z0_RAZAO)                 
	cTexto2 := ""
	oSection1:PrintLine()
	
	
	
    // Lancamentos em eventos no mês
	cQ := "SELECT Z3_CT2 FROM "+RetSqlName("SZ3")+" WHERE Z3_EMP = '"+cInveste+"' AND Z3_EMPPAR = '"+XSZ0->Z0_EMPRESA+"' AND Z3_DTBASE = '"+DTOS(LastDay(dRef))+"' AND Z3_STATUS = 'ATIVO' AND D_E_L_E_T_ = ' ' "
	TcQuery ChangeQuery(cQ) ALIAS "XSZ3" NEW                                                                                      
	WHILE XSZ3->(!EOF())
		CT2->(DBSETORDER(1))
		CT2->(DBSEEK(ALLTRIM(XSZ3->Z3_CT2)))
		
		cTexto1 := ""
		cTexto2 := "D-"+CT2->CT2_DEBITO + ALLTRIM(POSICIONE("CT1",1,XFILIAL("CT1")+CT2->CT2_DEBITO,"CT1_DESC01"))
		oSection1:PrintLine()
				
		cTexto2 := "C-"+CT2->CT2_CREDIT + ALLTRIM(POSICIONE("CT1",1,XFILIAL("CT1")+CT2->CT2_CREDIT,"CT1_DESC01"))
		oSection1:PrintLine()
		
		cTexto2 :=  TRANSFORM(CT2->CT2_VALOR,"@E 99,999,999,999.99")		
		oSection1:PrintLine()		
		oReport:SkipLine()		
		XSZ3->(DBSKIP())
    END

    XSZ3->(DBCLOSEAREA())

	XSZ0->(DBCLOSEAREA())

    XSZ2->(DBSKIP())

END

XSZ2->(DBCLOSEAREA())

oSection1:Finish()

Return()                
	