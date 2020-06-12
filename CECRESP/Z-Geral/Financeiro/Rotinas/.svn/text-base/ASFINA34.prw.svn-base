#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA34()

Converte o campo E1_HIST em E1_XCONTRA 

Chamado pelo Gatilho E1_HIST

@param		"C" - Contrato "E" - Empreendimento
@return		Codigo do Contrato ou Empreendimento
@author 	Zema
@since 		28/10/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA34(nP)
LOCAL cCONTRA := ""  
LOCAL cEMPRE  := ""  
Local cX	  := ""  


IF "VENDA:" $ M->E1_HIST

	cX := SUBSTR(M->E1_HIST, AT("VENDA:",M->E1_HIST)+6,LEN(M->E1_HIST))
	cX := SUBSTR(cX,1,AT(" ", cX ))
	cCONTRA	:= cX

    cX := SUBSTR(M->E1_HIST, AT("EMPR:",M->E1_HIST)+5,LEN(M->E1_HIST))
	cX := SUBSTR(cX,1,AT(" ", cX ))	
	
	cEMPRE := cX
	      
ENDIF	
	            
IF nP == "C"
	cX := 	cCONTRA
ELSE
	cX :=  cEMPRE
ENDIF	
	
RETURN(cX)