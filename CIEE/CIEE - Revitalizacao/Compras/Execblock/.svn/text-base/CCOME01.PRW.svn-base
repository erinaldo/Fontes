#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOME01
Solicitar aprovação - Solicitação de Compras
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CCOME01()
local oDlg			 		
local aHeadAux	 	:= {} 
local aColsAux	 	:= {}
local aCampUtil	 	:= {"CTD_ITEM","CTD_DESC01","CTD_XNOME","CTD_XEMAIL"}  
local lCmp  
local nOpca			:= 0	         
Private oGetD01	
Private cLbNo		:= "LBNO"
Private cLbOk		:= "LBOK"   

IF SC1->C1_APROV != "B"

	Aadd(aHeadAux,{"","TMP_XMARK","@BMP",1,0,"",,"C","","V","","",,"V","",,}) 
	
	DBSELECTAREA("SX3")        
	SX3->(DBSETORDER(1))
	SX3->(DBSEEK("CTD"))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "CTD"
		              
		lCmp := .T.
		IF !EMPTY(aCampUtil)
			lCmp := ASCAN(aCampUtil,{|x| x==TRIM(SX3->X3_CAMPO) }) > 0 
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
	 	                          		
	C2E01ACOLS(aHeadAux,@aColsAux)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 300,800 OF oMainWnd PIXEL  
		EnchoiceBar(oDlg,{|| nOpca:= 1 ,iif(C2E01TOK(),oDlg:End(),nil) },{|| nOpca:= 0 , oDlg:End()},,)
		oGetD01:= MsNewGetDados():New(1,1,1,1,0,"AllwaysTrue","AllwaysTrue",,,,999,"AllwaysTrue()",,,oDlg,aHeadAux,aColsAux)
		oGetD01:oBrowse:blDblClick 	:= {|| C2E01MARK() }
		oGetD01:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT			
	ACTIVATE MSDIALOG oDlg CENTERED 
	
	if nOpca > 0   
		Processa( {|| C2E01GRV() }, cCadastro ,"Enviando para aprovação, aguarde...", .T. ) 
	endif

else 
	msgalert("Solicitação de compras em aprovação!")
endif	

RETURN  
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E01GRV   ºAutor  ³ Totvs	    	   º Data ³06/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza gravação na tabela de alçadas		              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C2E01GRV   
local nPosMark	:= ASCAN(oGetD01:AHEADER,{|x| trim(x[2])=="TMP_XMARK"  })
local nPosItem	:= ASCAN(oGetD01:AHEADER,{|x| trim(x[2])=="CTD_ITEM"  })
local nPosNom		:= ASCAN(oGetD01:AHEADER,{|x| trim(x[2])=="CTD_XNOME"  })
local nCnt			:= 0
local nPrimeiro	:= 0 
local cKeySC		:= SC1->C1_FILIAL+SC1->C1_NUM 
   
if nPosMark > 0 .and. nPosItem > 0 .and. nPosNom > 0 //.and. nPosEmail > 0

	for nCnt:= 1 to len(oGetD01:ACOLS)
		if oGetD01:ACOLS[nCnt][nPosMark]==cLbOk
	    	nPrimeiro++
	    	reclock("ZA2",.T.)
	    		ZA2->ZA2_FILIAL	:= XFILIAL("ZA2")
	    		ZA2->ZA2_NUMSC	:= SC1->C1_NUM 
	    		ZA2->ZA2_TIPO		:= "1"
	    		ZA2->ZA2_CCUSTO	:= oGetD01:ACOLS[nCnt][nPosItem]
	    		ZA2->ZA2_NOMAP	:= oGetD01:ACOLS[nCnt][nPosNom]  
	    		ZA2->ZA2_USER		:= "XXXXXX" // Não tem usuário no Protheus
	    		IF nPrimeiro == 1
	    			ZA2->ZA2_STATUS	:= "1"
	    		Endif	
	    	msunlock()		    
	    endif
	next         		
	
	dbselectarea("SC1")
	dbsetorder(1) // C1_FILIAL+C1_NUM+C1_ITEM  
	dbseek(cKeySC)
	while SC1->(!eof()) .and. SC1->(C1_FILIAL+C1_NUM) == cKeySC
		reclock("SC1",.F.)
			SC1->C1_APROV:= "B"	
		msunlock()
	SC1->(dbskip())
	end	  				
endif

return 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E01TOK   ºAutor  ³ Totvs	    	   º Data ³06/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação tudo ok    						              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C2E01TOK 
local lRet		:= .t.  
local nPosMark	:= ASCAN(oGetD01:AHEADER,{|x| trim(x[2])=="TMP_XMARK"  })
local nCnt		:= 0 
   
if nPosMark > 0 
	aEval(oGetD01:ACOLS,{|x|  if(x[nPosMark]==cLbOk,nCnt++,nil)  }) 
	
	if nCnt == 0
		lRet:=.f.
		msgalert("Selecione o centro de custo para continuar!") 				
	endif
endif

return lRet
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E01ACOLS  ºAutor  ³ Totvs	    	   º Data ³06/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta acols								              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C2E01ACOLS(aHeadAux,aColsAux)
Local cTab		:= GetNextAlias()
Local nUsado	:= 0  
Local nLin		:= 0
 
BeginSQL Alias cTab
	SELECT CTD_ITEM,CTD_DESC01,CTD_XEMAIL,CTD_XNOME FROM %Table:CTD% CTD
	WHERE CTD_FILIAL = %xFilial:CTD%
	AND CTD_XEMAIL != '' 
	AND CTD.D_E_L_E_T_ = ''
EndSQL

(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
While (cTab)->(!Eof())        		
	
	nUsado:= len(aHeadAux)
	AADD(aColsAux,Array(nUsado+1))
	nLin:= len(aColsAux)   	       				
	For nCnt:= 1 TO nUsado  
		IF trim(aHeadAux[nCnt][2])=="TMP_XMARK"
			aColsAux[nLin][nCnt]:= cLbNo			
		ELSE
			aColsAux[nLin][nCnt]:= (cTab)->&(aHeadAux[nCnt][2])				
		ENDIF	
	NEXT nCntc    
	aColsAux[nLin][nUsado+1]:= .F.					    	   	   	   
(cTab)->(dbSkip())	
End  
(cTab)->(dbCloseArea()) 

return 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E01MARK  ºAutor  ³ Totvs	     	   º Data ³06/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ marca registro posicionado					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C2E01MARK
local nPosMark
      
if (nPosMark:= ASCAN(oGetD01:AHEADER,{|x| trim(x[2])=="TMP_XMARK"  })) > 0
	oGetD01:ACOLS[oGetD01:nAt][nPosMark]:= IIF(oGetD01:ACOLS[oGetD01:nAt][nPosMark]==cLbNo,oGetD01:ACOLS[oGetD01:nAt][nPosMark]:=cLbOk,oGetD01:ACOLS[oGetD01:nAt][nPosMark]:=cLbNo) 
	oGetD01:oBrowse:Refresh()
endif
	
return