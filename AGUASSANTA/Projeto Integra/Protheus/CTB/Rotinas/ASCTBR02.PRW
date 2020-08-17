#include 'protheus.ch'
#include 'topconn.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBR02
@Rotina de impressão da conversão de balanços e da Equivalência
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
USER Function ASCTBR02
Local oReport        
Local aParam 		:= {}                
Local aBox   		:= {}      
Local lContinua		:= .T.
Local lDif          := .F.
Private dRef 		:= CTOD(SPACE(8))
Private cInveste 	:= ""
Private cInvestida 	:= ""
Private cContaPL 	:= "203"          
Private cResultado  := "203007001001001"
Private cCadastro 	:= "Conversão de Balanços e Equivalência"
Private cRevisao  	:= "000"
Private dRevisao  	:= CTOD(SPACE(8))

AADD(aBox,	{ 1, "Mes e Ano Base", 	Space(6),"@!","" ,"",".T.",20,.T.	}) 
AADD(aBox,	{ 1, "Investidora", 		Space(LEN(cFilAnt)+2),"@!","" ,"EMP",".T.",30,.T.	}) 
AADD(aBox,	{ 1, "Investida", 			Space(LEN(cFilAnt)+2),"@!","" ,"EMP",".T.",30,.T.	}) 

If ParamBox( aBox,cCadastro,aParam,,,,,,,,.F.,.T.)
	dRef 		:= CTOD("01/"+SUBSTR(ALLTRIM(aParam[1]),1,2)+"/"+SUBSTR(ALLTRIM(aParam[1]),3,4))
	cInveste	:= ALLTRIM(aParam[2])
	cInvestida	:= ALLTRIM(aParam[3])	
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

oReport:= TReport():New("ASCTBR02","Conversão de Balanços e Equivalência","", {|oReport| Ledados(oReport)},"Conversão de Balanços e Equivalência") 

oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Conversão de Balanços e Equivalência",{})
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderPage()
oSection1:SetEditCell(.F.)                        
                                                                                          
//TRCell():New(oSection1,"EMPRESA"  ,,""  ,/*Picture*/,50,.F., 	 {|| EQVA->EMPRESA})
TRCell():New(oSection1,"TEXTO1"  ,,""  ,/*Picture*/,50,.F.,      {|| EQVA->TEXTO1})
TRCell():New(oSection1,"TEXTO2"  ,,""  ,/*Picture*/,50,.F.,      {|| EQVA->TEXTO2})
TRCell():New(oSection1,"TEXTO3"  ,,""  ,/*Picture*/,50,.F.,      {|| EQVA->TEXTO3})


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
Local nX 		:= 0
Local cMens		:= ""
Local lContinua	:= .F.
Local cFilOld 	:= cFilAnt
Local nPerPar	:= 0                              
Local nTxFinAnt	:= 0
Local nTxFinAtu	:= 0
Local cSeq		:= "000"           
Local cFilOld	:= cFilAnt
Local cSeqConv	:= ""                 
Local nDebito1	:= 0
Local nCredito1	:= 0
Local nDebito2	:= 0
Local nCredito2	:= 0
Local nVaria	:= 0


cFilAnt := RIGHT(cInvestida,TAMSX3("CTO_FILIAL")[1])

CriaTrb()

cQ := "SELECT Z0_EMPRESA, Z0_RAZAO, Z0_MOEDA, Z0_QTACOES FROM "+RetSqlName("SZ0")+" WHERE Z0_EMPRESA = '"+cInvestida+"' AND Z0_DTREVIS = '"+DTOS(dRef)+"' AND D_E_L_E_T_ = ' ' "
TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW  

cQ := "SELECT Z2_QUANT FROM "+RetSqlName("SZ2")+" WHERE Z2_EMP = '"+cInveste+"' AND Z2_EMPPAR = '"+cInvestida+"'AND Z2_DTBASE = '"+DTOS(dRef)+"' AND D_E_L_E_T_ = ' ' "
TcQuery ChangeQuery(cQ) ALIAS "XSZ2" NEW  

cQ := "SELECT Z3_CONTA, Z3_FORMULA AS TAXA, Z3_VALOR AS SALMOEDA, Z3_CTRESN AS SALDOFOR, Z3_VALCTB AS VARIACAO, Z3_CTMEPRP, Z3_CTRESE, Z3_MOEDA FROM "+RetSqlName("SZ3")
cQ += " WHERE Z3_EMP = '"+cInvestida+"' AND Z3_EVENTO = ' ' AND Z3_DTBASE = '"+DTOS(LastDay(dRef))+"' AND D_E_L_E_T_ = ' '"                                    
cQ += " ORDER BY Z3_CONTA "
TcQuery ChangeQuery(cQ) ALIAS "XSZ3" NEW  

nPerPar := ROUND(XSZ0->Z0_QTACOES / XSZ2->Z2_QUANT,7)

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= "000"
EQVA->TEXTO1    := "SEGREGAÇÃO DA VARIAÇÃO CAMBIAL DA EQUIVALÊNCIA"
EQVA->TEXTO2    := "PATRIMONIAL - "+cInveste+" - "
EQVA->TEXTO3    := ALLTRIM(XSZ0->Z0_RAZAO)+" MÊS: "+STRZERO(MONTH(dRef),2)+"/"+STRZERO(YEAR(dRef),4)
MsUnlock()

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= "001" 
EQVA->TEXTO1    := ""
EQVA->TEXTO2    := ""
EQVA->TEXTO3    := ""
MsUnlock()
       
CTO->(DBSETORDER(1))
CTO->(DBSEEK(XFILIAL("CTO")+XSZ0->Z0_MOEDA)) 

CTP->(DBSETORDER(1))
CTP->(DBSEEK(XFILIAL("CTP")+DTOS(LASTDAY(dRef-1))+XSZ0->Z0_MOEDA))
nTxFinAnt := CTP->CTP_TAXA

CTP->(DBSETORDER(1))
CTP->(DBSEEK(XFILIAL("CTP")+DTOS(LASTDAY(dRef))+XSZ0->Z0_MOEDA))
nTxFinAtu := CTP->CTP_TAXA
 
 
RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= "002"
EQVA->TEXTO1	:= ""
EQVA->TEXTO2	:= PADL("Taxa Final "+ALLTRIM(CTO->CTO_DESC)+"  "+STRZERO(MONTH(dRef-1),2)+"/"+STRZERO(YEAR(dRef-1),4),50)
EQVA->TEXTO3	:= PADR(TRANSFORM(nTxFinAnt,"@E 999.9999"),50)
MsUnlock()

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= "003"
EQVA->TEXTO1	:= ""
EQVA->TEXTO2	:= PADL("Taxa Final "+ALLTRIM(CTO->CTO_DESC)+"  "+STRZERO(MONTH(dRef),2)+"/"+STRZERO(YEAR(dRef),4),50)
EQVA->TEXTO3	:= PADR(TRANSFORM(nTxFinAtu,"@E 999.9999"),50)
MsUnlock()

aMedias := CtbMedias(FirstDay(dRef), LastDay(dRef))

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= "004"
EQVA->TEXTO1	:= ""
EQVA->TEXTO2	:= PADL("Taxa Média "+ALLTRIM(CTO->CTO_DESC)+"  "+STRZERO(MONTH(dRef),2)+"/"+STRZERO(YEAR(dRef),4),50)
EQVA->TEXTO3	:= PADR(TRANSFORM(aMedias[VAL(XSZ0->Z0_MOEDA)],"@E 999.999999999"),50)
MsUnlock()

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= "005"
EQVA->TEXTO1	:= ""
EQVA->TEXTO2	:= PADL("% Part.",50)
EQVA->TEXTO3	:= PADR(TRANSFORM(nPerPar,"@E 999.9999999"),50)
MsUnlock()

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= "006"
EQVA->TEXTO1	:= ""
EQVA->TEXTO2	:= ""
EQVA->TEXTO3	:= ""
MsUnlock()

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= "007"
EQVA->TEXTO1	:= "*** CONVERSÕES ***"
EQVA->TEXTO2	:= ""
EQVA->TEXTO3	:= ""
MsUnlock()

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= "008"
EQVA->TEXTO1	:= ""
EQVA->TEXTO2	:= ""
EQVA->TEXTO3	:= ""
MsUnlock()

cSeq := "010"

XSZ3->(DBGOTOP())
WHILE XSZ3->(!EOF())   
	cSeq := SOMA1(cSeq)                    
	
	CT1->(DBSEEK(XFILIAL("CT1")+XSZ3->Z3_CONTA))

	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= cSeq                                                             
	EQVA->TEXTO1	:= PADR(ALLTRIM(CT1->CT1_CONTA)+"-"+ALLTRIM(CT1->CT1_DESC01),50)
	EQVA->TEXTO2	:= PADR(POSICIONE("CTO",1,XFILIAL("CTO")+ALLTRIM(XSZ3->Z3_MOEDA),"CTO_SIMB")+TRANSFORM(XSZ3->SALMOEDA,"@E 999,999,999,999.99"),50)
	EQVA->TEXTO3	:= PADR(POSICIONE("CTO",1,XFILIAL("CTO")+ALLTRIM(XSZ3->Z3_CTRESE),"CTO_SIMB")+TRANSFORM(VAL(XSZ3->SALDOFOR),"@E 999,999,999,999.99"),50)
	MsUnlock()
                                           
	cSeq := SOMA1(cSeq)                    


	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= cSeq                                                             
	EQVA->TEXTO1	:= PADR(ALLTRIM(CT1->CT1_CONTA)+"-"+ALLTRIM(CT1->CT1_DESC01),50)
	EQVA->TEXTO2	:= PADR(POSICIONE("CTO",1,XFILIAL("CTO")+ALLTRIM(XSZ3->Z3_MOEDA),"CTO_SIMB")+TRANSFORM(XSZ3->SALMOEDA,"@E 999,999,999,999.99"),50)
	EQVA->TEXTO3	:= PADR(POSICIONE("CTO",1,XFILIAL("CTO")+ALLTRIM(XSZ3->Z3_CTRESE),"CTO_SIMB")+TRANSFORM(VAL(XSZ3->Z3_CTMEPRP),"@E 999,999,999,999.99"),50)
	MsUnlock()
                                           
	cSeq := SOMA1(cSeq)                    

	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= cSeq                                                             
	EQVA->TEXTO1	:= PADR("Variação",50)
	EQVA->TEXTO2	:= PADR("Taxa: "+TRANSFORM(XSZ3->TAXA,"@E 999.999999999"),50)
	EQVA->TEXTO3	:= PADR(POSICIONE("CTO",1,XFILIAL("CTO")+ALLTRIM(XSZ3->Z3_CTRESE),"CTO_SIMB")+TRANSFORM(XSZ3->VARIACAO,"@E 999,999,999,999.99"),50)
	MsUnlock()
                                           

	cSeq := SOMA1(cSeq)                    

	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= cSeq                                                             
	EQVA->TEXTO1	:= ""
	EQVA->TEXTO2	:= ""
	EQVA->TEXTO3	:= ""
	MsUnlock()

	XSZ3->(DBSKIP())
END

XSZ2->(DBCLOSEAREA())
XSZ3->(DBCLOSEAREA())

cSeq := SOMA1(cSeq)                    

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= cSeq                                                             
EQVA->TEXTO1	:= ""
EQVA->TEXTO2	:= ""
EQVA->TEXTO3	:= ""
MsUnlock()


// ==================================== EQUIVALENCIAS =================================

cSeq := SOMA1(cSeq)                    

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= cSeq
EQVA->TEXTO1	:= ""
EQVA->TEXTO2	:= ""
EQVA->TEXTO3	:= ""
MsUnlock()

cSeq := SOMA1(cSeq)                    

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= cSeq
EQVA->TEXTO1	:= "*** EQUIVALENCIAS ***"
EQVA->TEXTO2	:= ""
EQVA->TEXTO3	:= ""
MsUnlock()

cSeq := SOMA1(cSeq)                    

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= cSeq
EQVA->TEXTO1	:= ""
EQVA->TEXTO2	:= ""
EQVA->TEXTO3	:= ""
MsUnlock()


cQ := "SELECT * FROM "+RetSqlName("SZ3")
cQ += " WHERE Z3_EMP = '"+cInveste+"' AND Z3_EMPPAR = '"+cInvestida+"' AND Z3_EVENTO <> ' ' AND Z3_DTBASE = '"+DTOS(LastDay(dRef))+"' AND Z3_STATUS = 'ATIVO' AND D_E_L_E_T_ = ' '"                                    
cQ += " ORDER BY Z3_EVENTO "
TcQuery ChangeQuery(cQ) ALIAS "XSZ3" NEW  

WHILE XSZ3->(!EOF())
    
	SZ1->(DBSEEK(XFILIAL("SZ1")+XSZ3->Z3_EVENTO))

	cSeq := SOMA1(cSeq)                    

	RECLOCK("EQVA",.T.)
	EQVA->CHAVE 	:= cSeq                                                             
	EQVA->TEXTO1	:= SZ1->Z1_DESC
	EQVA->TEXTO2	:= ""
	EQVA->TEXTO3	:= PADR(TRANSFORM(ABS(XSZ3->Z3_VALCTB),"@E 999,999,999,999.99"),50)
	MsUnlock()

	nVaria += ABS(XSZ3->Z3_VALCTB)
	
	XSZ3->(DBSKIP())
END

cSeq := SOMA1(cSeq)                    

RECLOCK("EQVA",.T.)
EQVA->CHAVE 	:= cSeq                                                             
EQVA->TEXTO1	:= "Total de Equivalência"
EQVA->TEXTO2	:= ""
EQVA->TEXTO3	:= PADR(TRANSFORM(nVaria,"@E 999,999,999,999.99"),50)
MsUnlock()

XSZ0->(DBCLOSEAREA())
XSZ3->(DBCLOSEAREA())


EQVA->(DBGOTOP())

oReport:IncMeter()      
oSection1:Init()    
                         
WHILE EQVA->(!EOF())

	oSection1:PrintLine()
	EQVA->(DBSKIP())       
	oReport:IncMeter()
END


oSection1:Finish()

EQVA->(DBCLOSEAREA())
                                           
cFilAnt := cFilOld

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

aAdd(aCampos,{"CHAVE"	 , "C" , 03,0})  // Conteudo da coluna
aAdd(aCampos,{"TEXTO1"   , "C" , 50,0})  // Conteudo da coluna
aAdd(aCampos,{"TEXTO2"   , "C" , 50,0})  // Conteudo da coluna
aAdd(aCampos,{"TEXTO3"   , "C" , 50,0})  // Conteudo da coluna

cArqTmp := CriaTrab(aCampos)
dbUseArea( .T.,, cArqTmp, "EQVA", .F., .F. )
IndRegua("EQVA", cArqTmp, cOrdem ,,,,)
EQVA->(DBSETORDER(1))      

RETURN
