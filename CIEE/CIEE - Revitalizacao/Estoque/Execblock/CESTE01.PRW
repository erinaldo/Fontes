#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTE01
Criar gatilho de c๓digo de reten็ใo na entrada da NF
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera็๕es Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
user function CESTE01() 
local aArea	:= GETAREA()
local nOperac	:= PARAMIXB[1] //3-Inclusใo/4-Classificar/5-Exclusใo 
local nConfirm:= PARAMIXB[2] //1-Confirmou                       
local aParam	:= {} 
local aRet		:= {} 
local cCordAux	:= ""
      
if nConfirm == 1 .AND. (nOperac == 3 .OR. nOperac == 4)	
	dbselectarea("SE2")
	SE2->(dbsetorder(6))
	if SE2->(dbseek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DUPL))
		
		if !empty(cCodRet) 
			cCordAux:= cCodRet
		elseif !empty(SA2->A2_XCODRET)
			cCordAux:= SA2->A2_XCODRET
		endif     
		
		AADD(aParam,{2,RetTitle("E2_DIRF"),if(!empty(cCordAux),1,2),{"Sim","Nใo"},70,"",.F.})
		aAdd(aParam,{1,RetTitle("E2_CODRET"),cCordAux,"",,"37","",0,.F.})
		
		if ParamBox(aParam,"DIRF",@aRet,{|| C4E01TOK() }) 
			RecLock("SE2",.F.) 
				SE2->E2_DIRF	:= CVALTOCHAR(aRet[1])
				SE2->E2_CODRET	:= aRet[2] 
			SE2->(MSUNLOCK())
		endif	
	
	endif 	
endif
 
RESTAREA(aArea)
RETURN 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C4E01TOK   บAutor  ณ Totvs	    	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo tudo ok    						              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C4E01TOK() 
local lRet:= .T.

if (iif(valtype(MV_PAR01)=='N',MV_PAR01==1,MV_PAR01=='Sim')) 
	if empty(MV_PAR02)
		ALERT("Informe o c๓digo de reten็ใo!")
		lRet:= .F.
	else
		lRet:= EXISTCPO("SX5","37"+MV_PAR02) 
	endif			
endif 

RETURN lRet