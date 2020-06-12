#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CATFE01
Controle de confirmação de recebimento de plaqueta
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CATFE01(nOpc)
local oDlg			 		                   
local oGetD01	           
local oPnl01
local oCbase
local oItem
local cCbase  		:= ""
local cItem			:= ""
local aHeadAux	 	:= {} 
local aColsAux	 	:= {}
local aYesFields	:= {} 
local lCmp			:= .T.	
Local cTab			:= ""	
Local nUsado		:= 0  
Local nLin			:= 0


IF nOpc == 1                        

	// Tratamento via classificação do bem
	u_C1E01GRV(nOpc,SN1->N1_CBASE,SN1->N1_ITEM) 
				
ELSEIF nOpc == 2  

	// Tratamento via chamada no cadastro de ativos 
	aYesFields	:= {"ZA3_STATUS","ZA3_NOMAP","ZA3_CCUSTO","ZA3_DATA","ZA3_HORA"}		
	cCbase  	:= M->N1_CBASE
	cItem		:= M->N1_ITEM
		
	DBSELECTAREA("SX3")        
	SX3->(DBSETORDER(1))
	SX3->(DBSEEK("ZA3"))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "ZA3"
		              
		lCmp := .T.
		IF !EMPTY(aYesFields)
			lCmp := ASCAN(aYesFields,{|x| x==TRIM(SX3->X3_CAMPO) }) > 0 
		ENDIF
	 
		IF X3USO(SX3->X3_USADO) .and. lCmp  		
			Aadd(aHeadAux,{	AllTrim(X3Titulo()),;
							TRIM(SX3->X3_CAMPO),;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT,;
							SX3->X3_CBOX,;
							"",;
							SX3->X3_WHEN,;
							SX3->X3_VISUAL,;
							SX3->X3_VLDUSER,;
							SX3->X3_PICTVAR,;
							SX3->X3_OBRIGAT})			
		ENDIF
	SX3->(dbSkip())		
	EndDo	         
	
	cTab:= GetNextAlias()	

	BeginSQL Alias cTab
		SELECT * FROM %Table:ZA3% ZA3
		WHERE ZA3_FILIAL = %xFilial:ZA3% 
			and ZA3_CBASE= %Exp:cCbase% 
			and ZA3_ITEM = %Exp:cItem%  
			and ZA3.D_E_L_E_T_ = ''
	EndSQL
    
	TCSETFIELD((cTab),"ZA3_DATA","D")
	(cTab)->(dbSelectArea((cTab)))                    
	(cTab)->(dbGoTop())                               	
	While (cTab)->(!Eof())        		
		
		nUsado:= len(aHeadAux)
		AADD(aColsAux,Array(nUsado+1))
		nLin:= len(aColsAux)   	       				
		For nCnt:= 1 TO nUsado  
			aColsAux[nLin][nCnt]:= (cTab)->&(aHeadAux[nCnt][2])				
		NEXT nCntc    
		aColsAux[nLin][nUsado+1]:= .F.					    	   	   	   
	(cTab)->(dbSkip())	
	End  
	(cTab)->(dbCloseArea()) 	

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 300,700 OF oMainWnd PIXEL     
	    
		oPnl01 := TPanel():New(0,0 ,'' ,oDlg ,oDlg:oFont ,.T. ,.T. ,,,0,30,.F.,.F. )
		oPnl01:Align := CONTROL_ALIGN_TOP   

		@ 003, 010 SAY RetTitle("N1_CBASE") SIZE 080, 007 OF oPnl01  PIXEL
	    @ 013, 010 MSGET oCbase VAR cCbase WHEN .F. SIZE 070, 007 OF oPnl01 PIXEL	    	                                                                              
		@ 003, 120 SAY RetTitle("N1_ITEM") SIZE 050, 007 OF oPnl01  PIXEL
	    @ 013, 120 MSGET oItem VAR cItem WHEN .F. SIZE 070, 007 OF oPnl01 PIXEL	    	                                                                              
			
		EnchoiceBar(oDlg,{|| iif(u_C1E01GRV(nOpc,cCbase,cItem),oDlg:End(),nil) },{|| oDlg:End()},,)
		oGetD01:= MsNewGetDados():New(1,1,1,1,0,"AllwaysTrue","AllwaysTrue",,,,999,"AllwaysTrue()",,,oDlg,aHeadAux,aColsAux)
		oGetD01:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT			
	ACTIVATE MSDIALOG oDlg CENTERED

ENDIF 

RETURN
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C1E01GRV   ºAutor  ³ Totvs	    	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ rotina de gravação da tabela de aprovação de plaquetas     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
user function C1E01GRV(nOpc,cCodbase,cCodItem,cStatus,cObs)
local aAreaSN3	:= SN3->(getarea())
local aAreaZA3	:= ZA3->(getarea())
local lRet		:= .F.   
local cTab		:= ""	                      
default cStatus	:= ""
default cObs	:= ""

if nOpc == 1 
    
	// Tratamento via classificação do bem
	dbselectarea("SN3")   
	SN3->(dbsetorder(1)) //N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ 
	if dbseek(xfilial("SN3")+cCodbase+cCodItem)	
			
		lRet:= MSGYESNO("Deseja realizar o envio da plaqueta ?") 	
		
		reclock("ZA3",.T.)
			ZA3->ZA3_FILIAL	:= XFILIAL("ZA3")
			ZA3->ZA3_CBASE	:= cCodbase
			ZA3->ZA3_ITEM	:= cCodItem
			ZA3->ZA3_SEQ	:= C1E01SEQ(cCodbase,cCodItem)
			ZA3->ZA3_CCUSTO	:= SN3->N3_CUSTBEM 
			//ZA3->ZA3_NOMAP	:= POSICIONE("CTT",1,XFILIAL("CTT")+SN3->N3_CUSTBEM,"CTT_XNOME") 
			//ZA3->ZA3_USRAPR	:= POSICIONE("CTT",1,XFILIAL("CTT")+SN3->N3_CUSTBEM,"CTT_XUSER")
			ZA3->ZA3_NOMRES	:= POSICIONE("CTD",1,XFILIAL("CTD")+SN3->N3_SUBCCON,"CTD_XNOME") 
			ZA3->ZA3_EMAILR	:= POSICIONE("CTD",1,XFILIAL("CTD")+SN3->N3_SUBCCON,"CTD_XEMAIL")
			ZA3->ZA3_USRRES	:= __CUSERID
			ZA3->ZA3_DATA	:= DATE()
			ZA3->ZA3_HORA	:= TIME()
			ZA3->ZA3_STATUS	:= iif(lRet,"2","1")
		msunlock()
	endif

elseif nOpc == 2    
    
	// Tratamento via chamada no cadastro de ativos
	cTab:= GetNextAlias()	

	BeginSQL Alias cTab
		SELECT TOP 1 ZA3_STATUS FROM %Table:ZA3% ZA3
		WHERE ZA3_FILIAL = %xFilial:ZA3% 
			and ZA3_CBASE= %Exp:cCodbase% 
			and ZA3_ITEM = %Exp:cCodItem%  
			and ZA3.D_E_L_E_T_ = ''
		ORDER BY ZA3_STATUS DESC 	
	EndSQL

	(cTab)->(dbSelectArea((cTab)))                    
	(cTab)->(dbGoTop())                               	
	if (cTab)->(!Eof()) 
		
		if (cTab)->ZA3_STATUS == "2"
			msgalert("Já existe uma confirmação em andamento!")
		else
			dbselectarea("SN3")   
			SN3->(dbsetorder(1)) //N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ 
			if dbseek(xfilial("SN3")+M->N1_CBASE+M->N1_ITEM)	
			
				if MSGYESNO("Deseja realizar o envio da plaqueta ?") 
					lRet:= .t.			
					reclock("ZA3",.T.)
						ZA3->ZA3_FILIAL	:= XFILIAL("ZA3")
						ZA3->ZA3_CBASE	:= M->N1_CBASE
						ZA3->ZA3_ITEM	:= M->N1_ITEM
						ZA3->ZA3_SEQ	:= C1E01SEQ(M->N1_CBASE,M->N1_ITEM)
						ZA3->ZA3_CCUSTO	:= SN3->N3_CUSTBEM 
						//ZA3->ZA3_NOMAP	:= POSICIONE("CTT",1,XFILIAL("CTT")+SN3->N3_CUSTBEM,"CTT_XNOME") 
						//ZA3->ZA3_USRAPR	:= POSICIONE("CTT",1,XFILIAL("CTT")+SN3->N3_CUSTBEM,"CTT_XUSER")
						ZA3->ZA3_NOMRES	:= POSICIONE("CTD",1,XFILIAL("CTD")+SN3->N3_SUBCCON,"CTD_XNOME") 
						ZA3->ZA3_EMAILR	:= POSICIONE("CTD",1,XFILIAL("CTD")+SN3->N3_SUBCCON,"CTD_XEMAIL")
						ZA3->ZA3_USRRES	:= __CUSERID
						ZA3->ZA3_DATA	:= DATE()
						ZA3->ZA3_HORA	:= TIME()						
						ZA3->ZA3_STATUS	:= "2"
					msunlock()
				endif
			endif
		endif
	endif    

elseif nOpc == 3
	
	// Tratamento via schedule
	dbselectarea("SN3")   
	SN3->(dbsetorder(1)) //N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ 
	if dbseek(xfilial("SN3")+cCodbase+cCodItem)	
		lRet:= .t.					
		reclock("ZA3",.T.)
			ZA3->ZA3_FILIAL	:= XFILIAL("ZA3")
			ZA3->ZA3_CBASE	:= cCodbase
			ZA3->ZA3_ITEM	:= cCodItem
			ZA3->ZA3_SEQ	:= C1E01SEQ(cCodbase,cCodItem)
			ZA3->ZA3_CCUSTO	:= SN3->N3_CUSTBEM 
			//ZA3->ZA3_NOMAP	:= POSICIONE("CTT",1,XFILIAL("CTT")+SN3->N3_CUSTBEM,"CTT_XNOME") 
			//ZA3->ZA3_USRAPR	:= POSICIONE("CTT",1,XFILIAL("CTT")+SN3->N3_CUSTBEM,"CTT_XUSER")
			ZA3->ZA3_NOMRES	:= POSICIONE("CTD",1,XFILIAL("CTD")+SN3->N3_SUBCCON,"CTD_XNOME") 
			ZA3->ZA3_EMAILR	:= POSICIONE("CTD",1,XFILIAL("CTD")+SN3->N3_SUBCCON,"CTD_XEMAIL")
			ZA3->ZA3_USRRES	:= ""  
			ZA3->ZA3_WF		:= "2"			// Status 2 - respondido
			ZA3->ZA3_OBS	:= cObs   			
			ZA3->ZA3_DATA	:= DATE()
			ZA3->ZA3_HORA	:= TIME()
			ZA3->ZA3_STATUS	:= cStatus
		msunlock()
	endif
		
endif	
	             
restarea(aAreaZA3)
restarea(aAreaSN3)
return lRet    
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C1E01SEQ   ºAutor  ³ Totvs	    	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a proxima sequencia 							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C1E01SEQ(cCodbase,cCodItem)
Local cTab	:= GetNextAlias() 
Local cRet	:= "001"


BeginSQL Alias cTab
	SELECT MAX(ZA3_SEQ) AS SEQ FROM %Table:ZA3% ZA3
	WHERE ZA3_FILIAL = %xFilial:ZA3% 
		and ZA3_CBASE= %Exp:cCodbase% 
		and ZA3_ITEM = %Exp:cCodItem%  
		and ZA3.D_E_L_E_T_ = ''	
EndSQL
	
(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
if (cTab)->(!Eof())        		
	cRet:= SOMA1((cTab)->SEQ)					    	   	   	   
Endif
  
(cTab)->(dbCloseArea()) 

return cRet