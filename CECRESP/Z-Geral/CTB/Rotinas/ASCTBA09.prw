#include 'protheus.ch'
#include 'topconn.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA09
@Verifica semaforo SZ4
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
User Function ASCTBA09(aSemaforo)
Local lContinua := .F.
Local _nCont    := 0
Local _nTenta   := 0    
Local cQ        := ""
Local nVezes    := 0

// Aguarda a finalização dos eventos
WHILE !lContinua                        
	FOR _nCont := 1 TO LEN(aSemaforo)
		IF aSemaforo[_nCont][2] == "A"
			cQ := "SELECT Z4_STATUS FROM "+U_RtTab("SZ4",cEmpAnt)+" WHERE "
			cQ += " Z4_SEMAF = '"+ALLTRIM(aSemaforo[_nCont][1])+"'" 
			TcQuery ChangeQuery(cQ) ALIAS "XSZ4" NEW
			aSemaforo[_nCont][2] := XSZ4->Z4_STATUS 
			XSZ4->(DBCLOSEAREA())  
		ENDIF			
	NEXT                    

	
	IF ASCAN(aSemaforo,{|x| x[2] == "A"}) == 0 
		lContinua := .T. 
	ELSEIF ASCAN(aSemaforo,{|x| x[2] == "X"}) > 0           
		EXIT 		
	ENDIF			
	    
	IF !lContinua                                   

		SLEEP(5000)     
		nVezes++
	
	ENDIF
	
	IF nVezes >= 100
		EXIT
	ENDIF
	
END                            

RETURN(lContinua)
