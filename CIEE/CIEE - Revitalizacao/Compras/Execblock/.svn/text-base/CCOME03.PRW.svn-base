#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOME03
Consulta Aprovador - Solicitação de Compras
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CCOME03()
local oDlg			 		                   
local oGetD01	
local aHeadAux	 	:= {} 
local aColsAux	 	:= {}
local aYesFields	:= {"ZA2_STATUS","ZA2_NOMAP","ZA2_CCUSTO","ZA2_DATLIB","ZA2_HORLIB"} 

cQry := " SELECT * FROM "+RETSQLNAME("ZA2")+" ZA2"+CRLF
IF ISINCALLSTACK("U_CCOMA02")
	cQry += " WHERE ZA2_FILIAL='"+xfilial("ZA2")+"'"+CRLF
	cQry += " 	AND ZA2_NUMSC='"+ZA1->ZA1_COD+"'"+CRLF
	cQry += " 	AND ZA2_TIPO='2'"+CRLF
ELSE
	cQry += " WHERE ZA2_FILIAL='"+xfilial("ZA2")+"'"+CRLF
	cQry += " 	AND ZA2_NUMSC='"+SC1->C1_NUM+"'"+CRLF
	cQry += " 	AND ZA2_TIPO='1'"+CRLF
ENDIF

cQry += " 	AND ZA2.D_E_L_E_T_=''"+CRLF
cQry += " ORDER BY R_E_C_N_O_"+CRLF
	
FillGetDados(2,"ZA2",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },/*aNoFields*/,aYesFields,/*lOnlyYes*/,cQry,/*bMontCols*/,/*lEmpty*/,aHeadAux,aColsAux)
	
DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 300,650 OF oMainWnd PIXEL  
	EnchoiceBar(oDlg,{|| oDlg:End() },{|| oDlg:End()},,)
	oGetD01:= MsNewGetDados():New(1,1,1,1,0,"AllwaysTrue","AllwaysTrue",,,,999,"AllwaysTrue()",,,oDlg,aHeadAux,aColsAux)
	oGetD01:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT			
ACTIVATE MSDIALOG oDlg CENTERED 

RETURN 