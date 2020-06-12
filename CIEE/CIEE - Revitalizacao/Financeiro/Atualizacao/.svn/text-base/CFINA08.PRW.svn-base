#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CFINA08
CNAB Automatico de Faturamento SOE
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CFINA08()
local cNumBor	:= "" 
local cBanco	:= "237" 
local cAgencia	:= "03030"
local cConta	:= "21376366" 

cNumBor := Soma1(GetMV("MV_NUMBORR"),6)
cNumBor := Replicate("0",6-Len(Alltrim(cNumBor)))+Alltrim(cNumBor)
While !MayIUseCode("SE1"+xFilial("SE1")+cNumBor)  //verifica se esta na memoria, sendo usado
	// busca o proximo numero disponivel 
	cNumBor := Soma1(cNumBor)
EndDo

dbselectarea("SE1")
dbsetorder(1)
IF SE1->(dbseek(xfilial("SE1")+"XXX"+"000000001")) 

	// Gerar bordero automatico
	RecLock("SEA",.T.)
	SEA->EA_FILIAL	:= xFilial()
	SEA->EA_NUMBOR 	:= cNumBor
	SEA->EA_DATABOR	:= dDataBase
	SEA->EA_PORTADO	:= cBanco
	SEA->EA_AGEDEP 	:= cAgencia
	SEA->EA_NUMCON 	:= cConta
	SEA->EA_NUM 	:= SE1->E1_NUM
	SEA->EA_PARCELA := SE1->E1_PARCELA
	SEA->EA_PREFIXO := SE1->E1_PREFIXO
	SEA->EA_TIPO	:= SE1->E1_TIPO
	SEA->EA_CART	:= "R"
	SEA->EA_SITUACA	:= "1"
	SEA->EA_SITUANT	:= SE1->E1_SITUACA
	SEA->EA_FILORIG	:= SE1->E1_FILORIG
	SEA->EA_PORTANT	:= SE1->E1_PORTADO
	SEA->EA_AGEANT 	:= SE1->E1_AGEDEP
	SEA->EA_CONTANT := SE1->E1_CONTA 					
	MsUnlock() 
	
	RecLock("SE1",.F.)
	SE1->E1_PORTADO	:= cBanco
	SE1->E1_AGEDEP 	:= cAgencia
	SE1->E1_SITUACA	:= "1"
	SE1->E1_CONTRAT	:= ""
	SE1->E1_NUMBOR 	:= cNumBor
	SE1->E1_DATABOR	:= dDataBase
	SE1->E1_MOVIMEN	:= dDataBase
	SE1->E1_CONTA	:= cConta	
	MsUnlock()
	
	// Gerar cnab automatico
	
	pergunte("AFI150",.f.)   
	
	/*
	//Variaveis utilizadas para parametros  
	mv_par01:= "      "		 				// Do Bordero 		   
	mv_par02:= "ZZZZZZ"		 				// Ate o Bordero 	   
	mv_par03:= "bradesco.rem"				// Arq.Config 		   
	mv_par04:= "c:\FINNET\bradesco\bra"	// Arq. Saida    	   
	mv_par05:= cBanco		 				// Banco     			   
	mv_par06:= cAgencia		 				// Agenciao     		   
	mv_par07:= cConta		 				// Conta   			   
	mv_par08:= "001"		 				// Sub-Conta  		   
	mv_par09:= 1	 						// Cnab 1 / Cnab 2     
	mv_par10:= 1		 					// Considera Filiais   
	mv_par11:= replicate(" ",LEN(cfilant))	// De Filial   		   
	mv_par12:= replicate("Z",LEN(cfilant))	// Ate Filial          
	mv_par13:= 3		 					// Quebra por ?		   
	*/
	
	fa150Gera("SE1") 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe o mesmo numero de bordero gravado, quando ³
	//³ ocorrer geracao de bordero em usuarios simultaneos.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cProxNum := cNumBor
	Do While !FA060Num( cProxNum, .F. )
		cNumBor  := cProxNum
		cProxNum := Soma1( cNumBor )
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o N£mero do bordero atualizado						 ³
	//³ Posicionar no sx6 sempre usando GetMv. N„o utilize Seek !!!  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX6")         
	PutMv("MV_NUMBORR",cNumBor)

endif 

RETURN   

USER FUNCTION C6A08JOB()        
LOCAL cEmp		:= "01"
LOCAL cFil		:= "0001"

RpcSetType(3)
IF RPCSetEnv(cEmp,cFil)                                                                                                              
	CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINA08] Processo Iniciado para "+cEmp+"-"+cFil)
	U_CFINA08(1)  	
	CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINA08] Processo Finalizado para "+cEmp+"-"+cFil)	
	RpcClearEnv()
ENDIF	

RETURN  