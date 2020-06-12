#INCLUDE "TOTVS.CH"    
/*---------------------------------------------------------------------------------------
{Protheus.doc} CFINA02
Rotina credito não identificado - Conciliação

@class		Nenhum
@from 		Nenhum
@param    	Nenhum
@attrib    	Nenhum
@protected  Nenhum
@author     AF Custom
@version    P.11
@since      01/10/2014
@return    	Nenhum
@sample   	Nenhum
@obs      	Nenhum
@project    CIEE - Revitalização
@menu    	Nenhum
@history    Nenhum
---------------------------------------------------------------------------------------*/
User Function CFINA02()
Private aRotina 	:= {}
Private aCores	 	:= {}
Private cCadastro 	:= "CNI - Conciliação"  
Private aRotina 	:= {	{"Pesquisar" 	, "AxPesqui"    ,0,1},;
							{"Visualizar"	, "axvisual"  	,0,2},;
							{"Manutenção"	, "U_C6A02MAT"  ,0,3}}
							

dbSelectArea("SA1")
dbSetOrder(1)
dbGoTop()

mBrowse(6,1,22,74,"SA1")

return   
/*------------------------------------------------------------------------
*
* C6A02MAT()
* Tela de manutenção
*
------------------------------------------------------------------------*/
User Function C6A02MAT(cAlias,nReg,nOpc)
local aSize      	:= MsAdvSize()
local oDlg			:= nil
local oLayer		:= nil
local oPnl01		:= nil
local oPnl02		:= nil
local oPnl03		:= nil
local oPnl04		:= nil  
local oNome			:= nil 
local cNome 		:= SA1->A1_NOME
local oConv			:= nil 
local cConv 		:= SA1->A1_XCONV
local oCodFid		:= nil 
local cCodFid 		:= SA1->A1_CODFID
local oGroup		:= nil  
local oGroup2		:= nil 
local aHead01	 	:= {}
local aHead02	 	:= {}
local aHead03	 	:= {} 
local aCols01	 	:= {}
local aCols02	 	:= {}
local aCols03	 	:= {}
local aCamp01	 	:= {"Z8_BANCO","Z8_AGENCIA","Z8_CONTA","Z8_EMISSAO","Z8_VALOR","Z8_VLRBA","Z8_VLRCI","Z8_BA","Z8_CI","Z8_OBSNOT","Z8_REGISTR"} 
local aCamp02	 	:= {} // Não preenchido para todos
local aCamp03	 	:= {} // Não preenchido para todos
local aButons		:= {} 
local cPerg			:= "CFINA02"
local aAlterGD1		:= {"Z8_VLRBA","Z8_VLRCI","Z8_OBSNOT"}
local oEsp			:= nil
Private oSaldo		:= nil 
Private nSaldo 		:= 0 
Private oTotExt		:= nil 
Private nTotExt 	:= 0 
Private oTotTit		:= nil 
Private nTotTit 	:= 0 
Private oTotRec		:= nil 
Private nTotRec 	:= 0  
Private oTEstRec	:= nil 
Private nTEstRec 	:= 0  
Private oTotNRec	:= nil 
Private nTotNRec 	:= 0  
Private oTEstNRec	:= nil 
Private nTEstNRec 	:= 0
Private oGetD01		:= nil
Private oGetD02		:= nil 
Private cLbNo		:= "LBNO"
Private cLbOk		:= "LBOK" 
Private aMvPar		:= {}  

C6A02SX1(cPerg)
if PERGUNTE(cPerg,.T.)  
	For nMv := 1 To 8
	   aadd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv
endif

if !empty(aMvPar)
	                          		
	C6A02MHD("SZ8",@aHead01,aCamp01,.T.)
	C6A02MHD("SE1",@aHead02,aCamp02,.T.)
	C6A02MHD("ZA5",@aHead03,aCamp03,.T.)
	
	C6A02MAC("SZ8",aHead01,@aCols01)
	C6A02MAC("SE1",aHead02,@aCols02)
	C6A02MAC("ZA5",aHead03,@aCols03)   
	
	
	// Insere um SetKey
	//SetKey(VK_F12, {|| PERGUNTE("FIN330",.T.) }) 	
	
	DEFINE FONT oFont NAME "Arial" SIZE 0, -13
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL  
	
		aadd(aButons,{"Sair"			,{|| oDlg:End() }})
		aadd(aButons,{"Encerrar"		,{|| C6A02ENCF()}}) 
		aadd(aButons,{"Desvincular BA"	,{|| C6A02DESV(1)}})
		aadd(aButons,{"Desvincular CI"	,{|| C6A02DESV(2)}})		
		aadd(aButons,{"Vincular BA"		,{|| C6A02VINC(1)}})
		aadd(aButons,{"Vincular CI"		,{|| C6A02VINC(2)}})
		aadd(aButons,{"Legenda"			,{|| C6A02LEGE() }})
		aadd(aButons,{"Vis. Folha"		,{|| C6A02FOLH() }})
		C6A02BAR(oDlg,aButons,1)
	        
		oLayer:= FWLayer():new()
		oLayer:Init(oDlg,.F.,.T.)	
		
		oLayer:addCollumn("Col01",50,.F.)
		oLayer:addCollumn("Col02",50,.F.)
		oLayer:addWindow("Col01","Jan01","Dados do cliente",30,.F.,.F.,,,)
		oLayer:addWindow("Col01","Jan02","Extrato bancários",70,.F.,.F.,,,)
		oLayer:addWindow("Col02","Jan03","Titulos",50,.F.,.F.,,,)
		oLayer:addWindow("Col02","Jan04","Folha de pagamento",50,.F.,.F.,,,)
		oLayer:SetColSplit('Col01',CONTROL_ALIGN_LEFT,,/* {|| } */)
		oLayer:SetColSplit('Col02',CONTROL_ALIGN_LEFT,,/* {|| } */)
		
		// Janela 1
		oPnl01:= oLayer:getWinPanel("Col01","Jan01")   	
		  
	    @ 004, 004 SAY RetTitle("A1_NOME") SIZE 021, 007 OF oPnl01  PIXEL
	    @ 003, 052 MSGET oNome VAR cNome WHEN .F. SIZE 240, 010 OF oPnl01  PIXEL       
	    @ 020, 004 SAY RetTitle("A1_XCONV") SIZE 025, 007 OF oPnl01  PIXEL
	    @ 019, 052 MSGET oConv VAR cConv  WHEN .F. SIZE 159, 010 OF oPnl01 PIXEL
	    @ 037, 004 SAY RetTitle("A1_CODFID") SIZE 043, 007 OF oPnl01  PIXEL
	    @ 035, 052 MSGET oCodFid VAR cCodFid WHEN .F. SIZE 159, 010 OF oPnl01  PIXEL     
	    @ 016, 217 GROUP oGroup TO 048, 290 PROMPT "Saldo" OF oPnl01 PIXEL
	    @ 025, 221 MSGET oSaldo VAR nSaldo  WHEN .F. PICTURE PESQPICT("SE1","E1_VALOR") SIZE 065, 016 OF oPnl01  PIXEL	
		                		 	 		
		// Janela 2		                                       	
		oPnl02:= oLayer:getWinPanel("Col01","Jan02") 
		
		aButons:= {}
		aadd(aButons,{"Alt. Ext.", {|| C6A02ALTE() }})
		aadd(aButons,{"Exc. Tit.", {|| C6A02EXCT() }})
		oPnl05 := C6A02BAR(oPnl02,aButons,2) 

		oEsp := TPanel():New(0,0 ,'' ,oPnl05 ,oDlg:oFont ,.T. ,.T. ,,,110,12,.F.,.F. )
		oEsp:Align := CONTROL_ALIGN_RIGHT 			
		                                                        
		@ 001, 005 SAY "Total Extrato:" SIZE 050, 007 OF oEsp  PIXEL
	    @ 000, 040 MSGET oTotExt VAR nTotExt WHEN .F. PICTURE PESQPICT("SE1","E1_VALOR") SIZE 070, 005 OF oEsp  PIXEL	    	                                                                              
	  	    
	
		oGetD01:= MsNewGetDados():New(1,1,1,1,3,"U_C6A02LOK(1)","AllwaysTrue",,aAlterGD1,,999,"AllwaysTrue",,,oPnl02,aHead01,aCols01)
		oGetD01:OBROWSE:BCHANGE:= {|| C6A02MARK(1) }  
		oGetD01:LINSERT:= .F.
		oGetD01:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT
	
		// Janela 3		                                       	
		oPnl03:= oLayer:getWinPanel("Col02","Jan03") 
		
		oPnl06 := TPanel():New(0,0 ,'' ,oPnl03 ,oDlg:oFont ,.T. ,.T. ,,,0,12,.F.,.F. )
		oPnl06:Align := CONTROL_ALIGN_BOTTOM 
		
		oEsp := TPanel():New(0,0 ,'' ,oPnl06 ,oDlg:oFont ,.T. ,.T. ,,,100,12,.F.,.F. )
		oEsp:Align := CONTROL_ALIGN_RIGHT 				
		                                                        
		@ 003, 005 SAY "Total CI:" SIZE 050, 007 OF oEsp  PIXEL
	    @ 001, 030 MSGET oTotTit VAR nTotTit WHEN .F. PICTURE PESQPICT("SE1","E1_VALOR") SIZE 070, 007 OF oEsp  PIXEL	    	                                                                              
			
		oGetD02:= MsNewGetDados():New(1,1,1,1,0,"AllwaysTrue","AllwaysTrue",,,,999,"AllwaysTrue()",,,oPnl03,aHead02,aCols02)
		oGetD02:oBrowse:blDblClick 	:= {|| C6A02MARK(2) }
		oGetD02:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT  
		
		// Janela 4		                                       	
		oPnl04:= oLayer:getWinPanel("Col02","Jan04")  
	
		oPnl07 := TPanel():New(0,0 ,'' ,oPnl04 ,oDlg:oFont ,.T. ,.T. ,,,0,12,.F.,.F. )
		oPnl07:Align := CONTROL_ALIGN_BOTTOM  
		
		oEsp := TPanel():New(0,0 ,'' ,oPnl07 ,oDlg:oFont ,.T. ,.T. ,,,110,12,.F.,.F. )
		oEsp:Align := CONTROL_ALIGN_RIGHT 			                    
		
		@ 003, 001 SAY "Total Não Rec." SIZE 050, 007 OF oEsp  PIXEL
	    @ 001, 040 MSGET oTotNRec VAR nTotNRec WHEN .F. PICTURE PESQPICT("ZA5","ZA5_TOTFOL") SIZE 070, 007 OF oEsp PIXEL		
	    
		oEsp := TPanel():New(0,0 ,'' ,oPnl07 ,oDlg:oFont ,.T. ,.T. ,,,150,12,.F.,.F. )
		oEsp:Align := CONTROL_ALIGN_RIGHT 	    
		
		@ 003, 005 SAY "Total de Estagiario Não Rec." SIZE 080, 007 OF oEsp  PIXEL
	    @ 001, 075 MSGET oTEstNRec VAR nTEstNRec WHEN .F. PICTURE PESQPICT("ZA5","ZA5_TOTFOL") SIZE 070, 007 OF oEsp PIXEL		
				                                                        

		oPnl08 := TPanel():New(0,0 ,'' ,oPnl04 ,oDlg:oFont ,.T. ,.T. ,,,0,12,.F.,.F. )
		oPnl08:Align := CONTROL_ALIGN_BOTTOM  
		
		oEsp := TPanel():New(0,0 ,'' ,oPnl08 ,oDlg:oFont ,.T. ,.T. ,,,110,12,.F.,.F. )
		oEsp:Align := CONTROL_ALIGN_RIGHT		 

		@ 003, 001 SAY "Total Rec." SIZE 050, 007 OF oEsp  PIXEL
	    @ 001, 040 MSGET oTotRec VAR nTotRec WHEN .F. PICTURE PESQPICT("ZA5","ZA5_TOTFOL") SIZE 070, 007 OF oEsp PIXEL	
	    
		oEsp := TPanel():New(0,0 ,'' ,oPnl08 ,oDlg:oFont ,.T. ,.T. ,,,150,12,.F.,.F. )
		oEsp:Align := CONTROL_ALIGN_RIGHT 
		
		@ 003, 005 SAY "Total de Estagiario Rec." SIZE 080, 007 OF oEsp  PIXEL
	    @ 001, 075 MSGET oTEstRec VAR nTEstRec WHEN .F. PICTURE PESQPICT("ZA5","ZA5_TOTFOL") SIZE 070, 007 OF oEsp PIXEL			    	    	                                                                              
					
		oGetD03:= MsNewGetDados():New(1,1,1,1,0,"AllwaysTrue","AllwaysTrue",,,,999,"AllwaysTrue()",,,oPnl04,aHead03,aCols03)
		oGetD03:oBrowse:blDblClick 	:= {|| C6A02MARK(3) }
		oGetD03:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT	 
		
			
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT(C6A02SLD())   

	//SetKey(VK_F12, nil ) 
Endif

return           
/*------------------------------------------------------------------------
*
* C6A02ENCF()
* Encerrar conciliação da folha
*
------------------------------------------------------------------------*/
static function C6A02ENCF() 
local nPosMrkBA := ASCAN(oGetD03:AHEADER,{|x| "_XMARK"$x[2] })                        
local cCodFolha	:= ""
local nMarkBA 	:= 0 
local lRet		:= .t.

if (nMarkBA:=ascan(oGetD03:ACOLS,{|x| x[nPosMrkBA] == cLbOk } ) ) > 0
	cCodFolha	:= GDFIELDGET("ZA5_COD",nMarkBA,,oGetD03:AHEADER,oGetD03:ACOLS)

	dbselectarea("ZA5")
	dbsetorder(1)
	if dbseek(xfilial("ZA5")+cCodFolha)
		if ZA5->ZA5_ENCFOL== "S"                   
			MSGALERT("A folha selecionada já foi encerrada!")	
			lRet:= .F. 
		endif
		
		if lRet .and. ZA5->ZA5_ENCIDE== "S"                   
			MSGALERT("A identificação da folha selecionada já foi concluída!")	
			lRet:= .F. 
		endif

	endif		
ELSE
	MSGALERT("Selecione a folha para a encerramento!")	
	lRet:= .F. 				  
Endif
                                                  
if lRet                                           
	cMsg:= "Conforma o encerramento da identificação da folha ?"+CRLF
	cMsg+= cCodFolha +CRLF
	if msgyesno(cMsg)
		reclock("ZA5",.f.) 
		ZA5->ZA5_ENCIDE:= "S"
		msunlock()         
		
		// Envia xml para rotina de integração ESB
		u_CEAIA12(ZA5->ZA5_FILIAL+ZA5->ZA5_COD) 			
		                 				
		msginfo("Folha encerrada com sucesso.")
	Endif 
Endif

return      
/*------------------------------------------------------------------------
*
* C6A02VINC()
* Rotina de vinculo
*
------------------------------------------------------------------------*/
static function C6A02VINC(nTipo) 
local nPosMrkExt:= ASCAN(oGetD01:AHEADER,{|x| "_XMARK"$x[2] }) 
local nPosMrkCI := ASCAN(oGetD02:AHEADER,{|x| "_XMARK"$x[2] }) 
local nPosMrkBA := ASCAN(oGetD03:AHEADER,{|x| "_XMARK"$x[2] })                        
local cRegBan	:= ""
local nValCI	:= 0
local nValBA	:= 0
local cPrefixo	:= ""
local cNum		:= ""
local cParcela	:= ""
local cTipoTit	:= ""
local cCodFolha	:= ""
local lRet		:= .T.                    
local cMsg		:= ""  
local ARECRA	:= {}             
local aRecSE1	:= {}
local aRAVlr	:= {} 
local nMarkExt 	:= ascan(oGetD01:ACOLS,{|x| x[nPosMrkExt] == cLbOk } )
local nMarkCI 	:= 0 
local nMarkBA 	:= 0
local nVincBA 	:= 0
local nTotVBA 	:= 0
local nTipoTit 	:= 0

if (lRet:= nMarkExt > 0)
	cRegBan	:= GDFIELDGET("Z8_REGISTR",nMarkExt,,oGetD01:AHEADER,oGetD01:ACOLS)  
	nValCI	:= GDFIELDGET("Z8_VLRCI",nMarkExt,,oGetD01:AHEADER,oGetD01:ACOLS)
	nValBA	:= GDFIELDGET("Z8_VLRBA",nMarkExt,,oGetD01:AHEADER,oGetD01:ACOLS) 
endif

dbselectarea("SZ8")
dbsetorder(8)
if lRet .and. SZ8->(dbseek(xfilial("SZ8")+cRegBan)) 

	if SZ8->Z8_FLGDEV == "S" 
		msgalert("Extrato com crédito devolvido!")
		lRet:= .F.	
	endif
	
	if lRet .and. Empty(SZ8->Z8_NUMTIT)
		nTipoTit:= Aviso(cCadastro,"Confirma o crédito?",{"Confirmar","Devolver","Cancelar"})
		IF nTipoTit == 1  
			MsgRun("Aguarde...", "Gerando titulo.",{|| lRet:= C6A02TIT("1",3) })			
		elseif nTipoTit == 2
			MsgRun("Aguarde...", "Gerando titulo.",{|| lRet:= C6A02TIT("2",3) })
			lRet:= .f.			
		else
			lRet:= .f.	
		endif				
	endif
	
	if lRet .and. (SZ8->Z8_CI + SZ8->Z8_BA + nValCI + nValBA) > SZ8->Z8_VALOR 
		msgalert("O valor da CI + BA não pode ser maior que o valor do extrato!")
		lRet:= .F.
	Endif

	if lRet .and. Empty(SZ8->Z8_RDR) .and. Empty(SZ8->Z8_IDENT)
		msgalert("Extrato não foi identificado.")
		lRet:= .F.
	Endif   
	       
	if lRet .and. Empty(SZ8->Z8_IRRDR).and. SZ8->Z8_IR<>0
		msgalert("Extrato não foi regularizado.")
		lRet:= .F.
	Endif
	
	if nTipo == 1 		// Vinculo BA	     
	
		if lRet .and. nValBA == 0
			cMsg:= "É necessário o preenchimento do campo valor BA:"+CRLF
			cMsg+= "BA   : "+CVALTOCHAR(nValBA)+CRLF
			MSGALERT(cMsg)
			lRet:= .F.
		Endif 
		
		if lRet .and. nValBA > 0 		
			if (nMarkBA:=ascan(oGetD03:ACOLS,{|x| x[nPosMrkBA] == cLbOk } ) ) > 0
				cCodFolha	:= GDFIELDGET("ZA5_COD",nMarkBA,,oGetD03:AHEADER,oGetD03:ACOLS)
				
				dbselectarea("ZA5")
				dbsetorder(1)
				if dbseek(xfilial("ZA5")+cCodFolha)
					if ZA5->ZA5_ENCFOL== "S"                   
						MSGALERT("A folha selecionada já foi encerrada!")	
						lRet:= .F. 
					endif
					
					if lRet .and. ZA5->ZA5_ENCIDE== "S"                   
						MSGALERT("A identificação da folha selecionada já foi concluída!")	
						lRet:= .F. 
					endif

				endif			
							
			ELSE
				MSGALERT("Selecione a folha para a amarração!")	
				lRet:= .F. 				  
			Endif
		Endif
		
		if lRet 
			if MSGYESNO("Confima a excução do vinculo ?")				
				if nValBA > 0 .and. !empty(cCodFolha) 
				
					dbselectarea("ZA6")
					dbsetorder(1)
					dbseek(xfilial("ZA6")+cCodFolha)
					while ZA6->(!eof()) .and. ZA6->(ZA6_FILIAL+ZA6_COD)==xfilial("ZA6")+cCodFolha
						if empty(ZA6->ZA6_CODEXT)
							if ZA6->ZA6_VLRCON <= nValBA
								nVincBA++
							    reclock("ZA6",.F.) 
							    	ZA6->ZA6_CODEXT:= cRegBan
							    	ZA6->ZA6_SITPAG:= "S"
							    msunlock()
								nValBA:= nValBA - ZA6->ZA6_VLRCON 
								nTotVBA+= ZA6->ZA6_VLRCON
							else
								exit	
							Endif
						Endif 
					ZA6->(dbskip())
					end
					
					if nTotVBA > 0
					    reclock("SZ8",.F.) 
					    	SZ8->Z8_BA:= SZ8->Z8_BA + nTotVBA 
					    msunlock()	 
					Endif 			
					                                             
					C6A02ATU(3,nMarkBA,xfilial("ZA6")+cCodFolha)
					
					msginfo("Total de estagiários vinculados: "+cvaltochar(nVincBA))			
				Endif		
			Endif
		Endif	

	
	elseif nTipo == 2 	// Vinculo CI  

		if lRet .and. nValCI == 0 
			cMsg:= "É necessário o preenchimento do campo valor CI:"+CRLF
			cMsg+= "CI   : "+CVALTOCHAR(nValCI)+CRLF
			MSGALERT(cMsg)
			lRet:= .F.
		Endif 
		
		if lRet .and. nValCI > 0		
			if (nMarkCI:=ascan(oGetD02:ACOLS,{|x| x[nPosMrkCI] == cLbOk } ) ) > 0
				cPrefixo:= GDFIELDGET("E1_PREFIXO",nMarkCI,,oGetD02:AHEADER,oGetD02:ACOLS) 
				cNum	:= GDFIELDGET("E1_NUM",nMarkCI,,oGetD02:AHEADER,oGetD02:ACOLS) 
				cParcela:= GDFIELDGET("E1_PARCELA",nMarkCI,,oGetD02:AHEADER,oGetD02:ACOLS) 
				cTipoTit:= GDFIELDGET("E1_TIPO",nMarkCI,,oGetD02:AHEADER,oGetD02:ACOLS)		
			else
				MSGALERT("Selecione o titulo para a amarração!")	
				lRet:= .F.   
			Endif
		Endif
		
		if lRet 
			if MSGYESNO("Confima a excução do vinculo ?")				
				if nValCI > 0 
													
					// Pega Recno do titulo NF   
					DBSELECTAREA("SE1")
					DBSETORDER(1) 
					if DBSEEK(xFilial("SE1")+cPrefixo+cNum+cParcela+cTipoTit)			
						aadd(aRecSE1,SE1->(RECNO()))
					Endif
					  
					// Pega Recno do titulo RA
					DBSELECTAREA("SE1")
					DBSETORDER(1) 
					if DBSEEK(xFilial("SE1")+SZ8->Z8_PRXTIT+SZ8->Z8_NUMTIT+" "+"RA ")			
						aadd(aRecRA,SE1->(RECNO()))
					Endif				
					
					aRAVlr:= {nValCI} 				  
			   		                                                                                                                                     
					if MaIntBxCR(3,aRecSE1,,aRecRA,,{.T.,.F.,.T.,.F.,.F.,.F.},,,,,DDATABASE,,aRAVlr)					   	                         					    
						
						C6A02ATU(2,nMarkCI,xFilial("SE1")+cPrefixo+cNum+cParcela+cTipoTit)
										
				        MSGINFO("Registros vinculados com sucesso.")
			        ELSE
			             Help("XAFCMPAD",1,"HELP","XAFCMPAD","Não foi possível a compensação"+CRLF+" do titulo do adiantamento",1,0)
			             lRet := .F.
					Endif			
				Endif		
			Endif
		Endif		 			
	
	endif
	
	if lRet
		C6A02ATU(1,nMarkExt,"")
		C6A02SLD()	
	endif
	
Endif
      
return      
/*------------------------------------------------------------------------
*
* C6A02DESV()
* Rotina de desvinculo
*
------------------------------------------------------------------------*/
static function C6A02DESV(nTipo)
local nPosMrkExt:= ASCAN(oGetD01:AHEADER,{|x| "_XMARK"$x[2] }) 
local nPosMrkCI := ASCAN(oGetD02:AHEADER,{|x| "_XMARK"$x[2] }) 
local nPosMrkBA := ASCAN(oGetD03:AHEADER,{|x| "_XMARK"$x[2] })                        
local cRegBan	:= ""
local nValCI	:= 0
local nValBA	:= 0
local cPrefixo	:= ""
local cNum		:= ""
local cParcela	:= ""
local cTipoTit	:= ""
local cCodFolha	:= ""
local lRet		:= .T.                    
local cMsg		:= ""  
local ARECRA	:= {}             
local aRecSE1	:= {}
local aRAVlr	:= {}
local nMarkExt 	:= ascan(oGetD01:ACOLS,{|x| x[nPosMrkExt] == cLbOk } ) 
local nMarkCI 	:= 0 
local nMarkBA 	:= 0
local nVincBA 	:= 0
local nTotVBA 	:= 0
      
if (lRet:= nMarkExt > 0)
	cRegBan	:= GDFIELDGET("Z8_REGISTR",nMarkExt,,oGetD01:AHEADER,oGetD01:ACOLS)  
	nValCI	:= GDFIELDGET("Z8_CI",nMarkExt,,oGetD01:AHEADER,oGetD01:ACOLS)
	nValBA	:= GDFIELDGET("Z8_BA",nMarkExt,,oGetD01:AHEADER,oGetD01:ACOLS) 
endif

dbselectarea("SZ8")
dbsetorder(8)
if lRet .and. SZ8->(dbseek(xfilial("SZ8")+cRegBan)) 
	
	if SZ8->Z8_FLGDEV == "S" 
		msgalert("Extrato com crédito devolvido!")
		lRet:= .F.	
	endif
	
	if lRet .and. Empty(SZ8->Z8_NUMTIT)  
		msgalert("O extrato não possui vinculos!")
		lRet:= .F.		
	endif
	
	if nTipo == 1 		// Desvinculo BA 

		if lRet .and. nValBA > 0 		
			if (nMarkBA:=ascan(oGetD03:ACOLS,{|x| x[nPosMrkBA] == cLbOk } ) ) > 0
				cCodFolha	:= GDFIELDGET("ZA5_COD",nMarkBA,,oGetD03:AHEADER,oGetD03:ACOLS)
				
				dbselectarea("ZA5")
				dbsetorder(1)
				if dbseek(xfilial("ZA5")+cCodFolha)
					if ZA5->ZA5_ENCFOL== "S"                   
						MSGALERT("A folha selecionada já foi encerrada!")	
						lRet:= .F. 
					endif             
					
					if lRet .and. ZA5->ZA5_ENCIDE== "S"                   
						MSGALERT("A identificação da folha selecionada já foi concluída!")	
						lRet:= .F. 
					endif
					
				endif				
				
			ELSE
				MSGALERT("Selecione a folha para realizar o desvinculo!")	
				lRet:= .F. 				  
			Endif
		Endif 
		
		if lRet 
			if MSGYESNO("Confima a excução do vinculo ?")
			
				if nValBA > 0 .and. !empty(cCodFolha) 
				
					dbselectarea("ZA6")
					dbsetorder(1)
					dbseek(xfilial("ZA6")+cCodFolha)
					while ZA6->(!eof()) .and. ZA6->(ZA6_FILIAL+ZA6_COD)==xfilial("ZA6")+cCodFolha
						if !empty(ZA6->ZA6_CODEXT) .and. ZA6->ZA6_CODEXT == cRegBan  
							if ZA6->ZA6_VLRCON <= nValBA
								nVincBA++
							    reclock("ZA6",.F.) 
							    	ZA6->ZA6_CODEXT:= ""
							    	ZA6->ZA6_SITPAG:= ""
							    msunlock()
								nValBA:= nValBA - ZA6->ZA6_VLRCON 
								nTotVBA+= ZA6->ZA6_VLRCON
							else
								exit	
							Endif
						Endif 
					ZA6->(dbskip())
					end
					
					if nTotVBA > 0
					    reclock("SZ8",.F.) 
					    	SZ8->Z8_BA:= SZ8->Z8_BA - nTotVBA 
					    msunlock()	 
					Endif 			
					        
					C6A02ATU(3,nMarkBA,xfilial("ZA6")+cCodFolha)
					
					msginfo("Total de estagiários vinculados: "+cvaltochar(nVincBA))			
				Endif			
						
			Endif
		Endif		
		
	elseif nTipo == 2 	// Desvinculo CI
		
		if lRet 
			if MSGYESNO("Confima a excução do desvinculo ?")
			
				if nValCI > 0   
				  									  
					// Pega Recno do titulo RA
					DBSELECTAREA("SE1")
					DBSETORDER(1) 
					if DBSEEK(xFilial("SE1")+SZ8->Z8_PRXTIT+SZ8->Z8_NUMTIT+" "+"RA ")			
						Fina330(4)
					Endif				
				
				Endif			
						
			Endif
		Endif		
	endif	
	
	if lRet
		C6A02ATU(1,nMarkExt,"")	
		C6A02ATU(4)
		C6A02SLD() 
	endif
		
Endif

return 
/*------------------------------------------------------------------------
*
* C6A02TIT()
* Gera titulo RA - NDC
*
------------------------------------------------------------------------*/
static function C6A02TIT(cTipo,nOpc)
local aAreaSZ8:= SZ8->(getarea())
local lRet:= .T.
local aTit:= {} 
local cPref:=trim(GetMv("CI_PRXSZ8",.F.,""))   
local cNatu:=trim(GetMv("CI_NATSZ8",.F.,""))
private lMsErroAuto	:= .F. 
                                       
if nOpc == 3         

	aadd(aTit,{'E1_FILIAL '	, XFILIAL("SE1")			, nil })
	aadd(aTit,{'E1_PREFIXO'	, cPref 					, nil })
	aadd(aTit,{'E1_NUM    '	, RIGHT(SZ8->Z8_REGISTR,9)	, nil }) 
	aadd(aTit,{'E1_TIPO   '	, 'RA'   					, nil })
	aadd(aTit,{'CBANCOADT'	, SZ8->Z8_BANCO   			, nil })
	aadd(aTit,{'CAGENCIAADT', SZ8->Z8_AGENCIA   		, nil })
	aadd(aTit,{'CNUMCON'	, SZ8->Z8_CONTA   			, nil })	
	aadd(aTit,{'E1_CLIENTE'	, SA1->A1_COD	 			, nil })
	aadd(aTit,{'E1_LOJA   '	, SA1->A1_LOJA 				, nil })
	aadd(aTit,{'E1_NATUREZ'	, cNatu						, nil })
	aadd(aTit,{'E1_EMISSAO'	, DDATABASE  				, nil })
	aadd(aTit,{'E1_VENCTO'	, DDATABASE					, nil })
	aadd(aTit,{'E1_VALOR'	, SZ8->Z8_VALOR		 		, nil })
	aadd(aTit,{'E1_ORIGEM'	, "CFINA02"		 			, nil })		

elseif nOpc == 5 

	aadd(aTit,{'E1_FILIAL '	, SE1->E1_FILIAL	, nil })
	aadd(aTit,{'E1_PREFIXO'	, SE1->E1_PREFIXO	, nil })
	aadd(aTit,{'E1_NUM    '	, SE1->E1_NUM		, nil })
	aadd(aTit,{'E1_PARCELA'	, SE1->E1_PARCELA 	, nil }) 
	aadd(aTit,{'E1_TIPO   '	, SE1->E1_TIPO   	, nil })
	aadd(aTit,{'E1_CLIENTE'	, SE1->E1_CLIENTE	, nil })
	aadd(aTit,{'E1_LOJA   '	, SE1->E1_LOJA 		, nil })
	aadd(aTit,{'E1_NATUREZ'	, SE1->E1_NATUREZ	, nil })
	aadd(aTit,{'E1_EMISSAO'	, SE1->E1_EMISSAO  	, nil })
	aadd(aTit,{'E1_VENCTO'	, SE1->E1_VENCTO	, nil })
	aadd(aTit,{'E1_VALOR'	, SE1->E1_VALOR		, nil })

endif	

MsExecAuto({|x,y| FINA040(x,y)} , aTit,nOpc) 

If lMsErroAuto	
	lRet:= .F.
	MostraErro() 
	restarea(aAreaSZ8)
Else  
	restarea(aAreaSZ8)                  
	reclock("SZ8",.F.)
	SZ8->Z8_PRXTIT:= iif(nOpc==3,SE1->E1_PREFIXO,"")
	SZ8->Z8_NUMTIT:= iif(nOpc==3,SE1->E1_NUM,"") 	
	SZ8->Z8_TIPTIT:= iif(nOpc==3,SE1->E1_TIPO,"")
	
	if cTipo == "3"
		SZ8->Z8_FLGDEV:= ""
	endif
	
	msunlock()   
	
	if cTipo == "2"  
		aadd(aTit,{'E1_FILIAL '		, SE1->E1_FILIAL	, nil })
		aadd(aTit,{'E1_PREFIXO'		, SE1->E1_PREFIXO	, nil })
		aadd(aTit,{'E1_NUM    '		, SE1->E1_NUM		, nil }) 
		aadd(aTit,{'E1_PARCELA'		, SE1->E1_PARCELA 	, nil })
		aadd(aTit,{'E1_TIPO   '		, SE1->E1_TIPO   	, nil })		
		aadd(aTit,{'AUTMOTBX'		, 'NOR'				, nil })
		aadd(aTit,{'AUTBANCO' 		, SZ8->Z8_BANCO		, nil })
		aadd(aTit,{'AUTAGENCIA'		, SZ8->Z8_AGENCIA	, nil })
		aadd(aTit,{'AUTCONTA'		, SZ8->Z8_CONTA  	, nil })
		aadd(aTit,{'AUTDTBAIXA'		, dDataBase			, nil })
		aadd(aTit,{'AUTDTCREDITO'	, dDataBase			, nil })		
		aadd(aTit,{'AUTHIST'		, "Devolução crédito - CNI", nil })
		aadd(aTit,{'AUTJUROS'		, 0					, nil })
		aadd(aTit,{'AUTVALREC'		, SE1->E1_VALOR		, nil })
		
		MSExecAuto({|x,y| Fina070(x,y)},aTit,3)
		
		If lMsErroAuto	
			lRet:= .F.
			MostraErro()
		Else                
			restarea(aAreaSZ8)                  
			reclock("SZ8",.F.)
			SZ8->Z8_FLGDEV:= "S"
			msunlock()   		
			msginfo("Credito devolvido com sucesso.")	 
		endif		  			
	endif
EndIf
	
return lRet
/*------------------------------------------------------------------------
*
* C6A02SLD()
* Calcula o saldo atual do cliente
*
------------------------------------------------------------------------*/
static function C6A02SLD()   
local cTab	:= GetNextAlias() 
local cQry	:= ""          
local nSldPos:= 0  
local nSldNeg:= 0 
local nSldIde:= 0 

BeginSQL Alias cTab
	SELECT E1_TIPO AS TIPO
		   ,E1_SALDO AS VALOR 
	FROM %Table:SE1% SE1
	WHERE E1_FILIAL=%xFilial:SE1% 
		AND E1_CLIENTE=%Exp:SA1->A1_COD%
		AND E1_LOJA=%Exp:SA1->A1_LOJA%
		AND E1_TIPO IN ('NF','NCC','RA','NDC')	
		AND SE1.D_E_L_E_T_ = ''
	UNION ALL
	SELECT 'IDE' AS TIPO
			,ZA6_VLRCON AS VALOR
	 FROM %Table:ZA6% ZA6
	INNER JOIN %Table:ZA5% ZA5 ON ZA5_FILIAL=%xFilial:ZA5%
		AND ZA5_CGC=%Exp:TRIM(SA1->A1_CGC)% 
		AND ZA5_NUMTIT=''
		AND ZA5.D_E_L_E_T_=''
	WHERE ZA6_FILIAL=%xFilial:ZA6%	
		AND ZA6_COD=ZA5_COD
		AND ZA6_SITPAG='S'
		AND ZA6.D_E_L_E_T_=''		
EndSQL                           

TCSETFIELD(cTab,"E1_BAIXA","D")

(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF())

	if TRIM((cTab)->TIPO)$"RA,NCC"  
		nSldPos+= (cTab)->VALOR 
	ELSEif TRIM((cTab)->TIPO)$"NF,NDC"
		nSldNeg+= (cTab)->VALOR           
	ELSEif TRIM((cTab)->TIPO)$"IDE"
		nSldIde+= (cTab)->VALOR           				
	Endif

(cTab)->(DBSKIP())
END                   
(cTab)->(dbCloseArea())	

nSaldo:= nSldPos - (nSldNeg + nSldIde)  
oSaldo:Refresh()

return   
/*------------------------------------------------------------------------
*
* C6A02BAR()
* Monta a barra de botoões
*
------------------------------------------------------------------------*/
static function C6A02BAR(oPnl,aButons,nAlinha)
local oBar 	:= nil
local oTBut	:= nil  
local oEsp	:= nil  
local nCnt	:=0
	
oBar:= TPanel():New(1,1,'' ,oPnl,,.T. ,.T. ,,,10,16,.F.,.F. )
oBar:Align := CONTROL_ALIGN_BOTTOM	   

oEsp:= TPanel():New(1,1,'' ,oBar,,.T. ,.T. ,,,10,3,.F.,.F. )
oEsp:Align := CONTROL_ALIGN_TOP

oEsp:= TPanel():New(1,1,'' ,oBar,,.T. ,.T. ,,,10,3,.F.,.F. )
oEsp:Align := CONTROL_ALIGN_BOTTOM

oEsp:= TPanel():New(1,1,'' ,oBar,,.T. ,.T. ,,,5,5,.F.,.F. )
oEsp:Align := iif(nAlinha==1,CONTROL_ALIGN_RIGHT,CONTROL_ALIGN_LEFT)

FOR nCnt:= 1 TO LEN(aButons)	
	oTBut:= TButton():New(002,002,aButons[nCnt][1],oBar,aButons[nCnt][2], 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTBut:Align:= iif(nAlinha==1,CONTROL_ALIGN_RIGHT,CONTROL_ALIGN_LEFT)
              
	oEsp:= TPanel():New(1,1,'' ,oBar,,.T. ,.T. ,,,5,5,.F.,.F. )
	oEsp:Align := iif(nAlinha==1,CONTROL_ALIGN_RIGHT,CONTROL_ALIGN_LEFT)
NEXT nCnt
	
return oBar
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C6A02LOK   ºAutor  ³ Totvs        	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação linha ok         				                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
User Function C6A02LOK(nObj)  
local lRet	:= .T.

if nObj == 1
	C6A02MARK(1)
Endif

return lRet  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C6A02WHN   ºAutor  ³ Totvs        	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação X3_when         				                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/
User Function C6A02WHN()                                                         
local lRet:= .T.

lRet:= TRIM(FUNNAME())=="CFINA02" .and. !isincallstack("C6A02ALTE")        

return lRet     
/*------------------------------------------------------------------------
*
* C6A02MARK()
* marca registro posicionado
*
------------------------------------------------------------------------*/
static function C6A02MARK(nObj,nOpc) 
local nPosMark	:= 0
local nMarknAt	:= 0
local nPosVlr 	:= 0
local cCodFolha	:= ""
                         
if nObj == 1	 
	if (nPosMark:= ASCAN(oGetD01:AHEADER,{|x| "_XMARK"$x[2] })) > 0
		oGetD01:ACOLS[oGetD01:nAt][nPosMark]:= Iif(oGetD01:ACOLS[oGetD01:nAt][nPosMark]==cLbNo,oGetD01:ACOLS[oGetD01:nAt][nPosMark]:=cLbOk,oGetD01:ACOLS[oGetD01:nAt][nPosMark]:=cLbNo) 
		oGetD01:oBrowse:Refresh()
	Endif 
	
	if (nPosVlr:=GDFieldPos("Z8_VALOR",oGetD01:AHEADER)) > 0 
		nTotExt:= 0	
		aEval(oGetD01:ACOLS,{|x| Iif(x[nPosMark]==cLbOk,nTotExt+=x[nPosVlr] ,nil)  }) 
		oTotExt:Refresh()
	Endif
		
ELSEif nObj == 2

	if (nPosMark:= ASCAN(oGetD02:AHEADER,{|x| "_XMARK"$x[2] })) > 0
			
		if (nMarknAt:= ASCAN(oGetD02:ACOLS,{|x| x[nPosMark]==cLbOk  })) > 0 
			if nMarknAt != oGetD03:nAt
				oGetD02:ACOLS[nMarknAt][nPosMark]:= Iif(oGetD02:ACOLS[nMarknAt][nPosMark]==cLbNo,oGetD02:ACOLS[nMarknAt][nPosMark]:=cLbOk,oGetD02:ACOLS[nMarknAt][nPosMark]:=cLbNo) 
				oGetD02:oBrowse:Refresh() 
			Endif	
		Endif
			
		oGetD02:ACOLS[oGetD02:nAt][nPosMark]:= Iif(oGetD02:ACOLS[oGetD02:nAt][nPosMark]==cLbNo,oGetD02:ACOLS[oGetD02:nAt][nPosMark]:=cLbOk,oGetD02:ACOLS[oGetD02:nAt][nPosMark]:=cLbNo) 
		oGetD02:oBrowse:Refresh()
	Endif  
	
	if (nPosVlr:=GDFieldPos("E1_VALOR",oGetD02:AHEADER)) > 0 
		nTotTit:= 0	
		aEval(oGetD02:ACOLS,{|x| Iif(x[nPosMark]==cLbOk,nTotTit+=x[nPosVlr] ,nil)  }) 
		oTotTit:Refresh()
	Endif
		
ELSEif nObj == 3              

	if (nPosMark:= ASCAN(oGetD03:AHEADER,{|x| "_XMARK"$x[2] })) > 0
		
		if (nMarknAt:= ASCAN(oGetD03:ACOLS,{|x| x[nPosMark]==cLbOk  })) > 0 
			if nMarknAt != oGetD03:nAt
				oGetD03:ACOLS[nMarknAt][nPosMark]:= Iif(oGetD03:ACOLS[nMarknAt][nPosMark]==cLbNo,oGetD03:ACOLS[nMarknAt][nPosMark]:=cLbOk,oGetD03:ACOLS[nMarknAt][nPosMark]:=cLbNo) 
				oGetD03:oBrowse:Refresh()
			Endif
		Endif		
		
		oGetD03:ACOLS[oGetD03:nAt][nPosMark]:= Iif(oGetD03:ACOLS[oGetD03:nAt][nPosMark]==cLbNo,oGetD03:ACOLS[oGetD03:nAt][nPosMark]:=cLbOk,oGetD03:ACOLS[oGetD03:nAt][nPosMark]:=cLbNo) 
		oGetD03:oBrowse:Refresh()  

		cCodFolha:= GDFIELDGET("ZA5_COD",oGetD03:nat,,oGetD03:AHEADER,oGetD03:ACOLS)
		C6A02ATU(3,oGetD03:nAt,xfilial("ZA6")+cCodFolha)
		
		/*nTotRec := 0  
		nTEstRec := 0   
		nTotNRec := 0   
		nTEstNRec:= 0 
		
		if oGetD03:ACOLS[oGetD03:nAt][nPosMark] == cLbOk		
			cCodFolha:= GDFIELDGET("ZA5_COD",oGetD03:nat,,oGetD03:AHEADER,oGetD03:ACOLS)
			
			dbselectarea("ZA6")
			dbsetorder(1)
			dbseek(xfilial("ZA6")+cCodFolha)
			while ZA6->(!eof()) .and. ZA6->(ZA6_FILIAL+ZA6_COD)==xfilial("ZA6")+cCodFolha
				if !empty(ZA6->ZA6_CODEXT)
					nTotRec+= ZA6->ZA6_VLRCON
					nTEstRec++   
				else 
					nTotNRec+= ZA6->ZA6_VLRCON
					nTEstNRec++
				Endif 
			ZA6->(dbskip())
			end 
		Endif  
		
		oTotRec:Refresh()   
		oTEstRec:Refresh() 
		oTotNRec:Refresh() 
		oTEstNRec:Refresh()		
		*/
	Endif

	/* 
	if (nPosVlr:=GDFieldPos("ZA5_VALOR",oGetD03:AHEADER)) > 0 
		nTotRec:= 0	
		aEval(oGetD03:ACOLS,{|x| Iif(x[nPosMark]==cLbOk,nTotRec+=x[nPosVlr] ,nil)  }) 
		oTotRec:Refresh()
	Endif
	*/	
Endif

return  
/*------------------------------------------------------------------------
*
* C6A02ATU()
* atualiza os objetos
*
------------------------------------------------------------------------*/
static function C6A02ATU(nTipo,nLin,cChave)  
local nPosMark	:= 0
local nPosLeg	:= 0
local nMarknAt	:= 0
local nPosVlr 	:= 0
local aAux		:= {}
                         
if nTipo == 1	        

	FOR nCnta := 1 TO SZ8->(FCOUNT())    
		cCampo:= TRIM(SZ8->(FIELDNAME(nCnta)))
		if ascan(oGetD01:AHEADER,{|x| trim(x[2])==cCampo }) > 0
			GDFIELDPUT(cCampo,SZ8->&(cCampo),nLin,oGetD01:AHEADER,oGetD01:ACOLS)
		endif	
	NEXT nCnta 
	
	oGetD01:Refresh()
		
ELSEif nTipo == 2  

	DBSELECTAREA("SE1")
	DBSETORDER(1) 
	if DBSEEK(cChave)
                				
		FOR nCnta := 1 TO SE1->(FCOUNT())    
			cCampo:= TRIM(FIELDNAME(nCnta))
			if ascan(oGetD02:AHEADER,{|x| trim(x[2])==cCampo }) > 0
				GDFIELDPUT(cCampo,SE1->&(cCampo),nLin,oGetD02:AHEADER,oGetD02:ACOLS)
			endif			
		NEXT nCnta
		
		if (nPosLeg:= ASCAN(oGetD02:AHEADER,{|x| "_XLEG"$x[2] })) > 0					
			if SE1->E1_SALDO == 0
		    	oGetD02:ACOLS[nLin][nPosLeg]:= "BR_VERMELHO"	//  "Titulo Compensado Totalmente"		    
		    elseif SE1->E1_SALDO <> SE1->E1_VALOR
		    	oGetD02:ACOLS[nLin][nPosLeg]:= "BR_AZUL"		// "Titulo Compensado Parcialmente" 		    
		    elseif SE1->E1_SALDO ==  SE1->E1_VALOR
		    	oGetD02:ACOLS[nLin][nPosLeg]:= "BR_VERDE"	 	// "Titulo nao Compensado"
			Endif	
		Endif		    					  	            					
	
		oGetD02:Refresh()	
				
	Endif     	
		
ELSEif nTipo == 3                       

	if (nPosMark:= ASCAN(oGetD03:AHEADER,{|x| "_XMARK"$x[2] })) > 0
		
		nTotRec := 0  
		nTEstRec := 0   
		nTotNRec := 0   
		nTEstNRec:= 0 
		
		if oGetD03:ACOLS[nLin][nPosMark] == cLbOk					
			dbselectarea("ZA6")
			dbsetorder(1)
			dbseek(cChave)
			while ZA6->(!eof()) .and. ZA6->(ZA6_FILIAL+ZA6_COD)==cChave
				if !empty(ZA6->ZA6_CODEXT)
					nTotRec+= ZA6->ZA6_VLRCON
					nTEstRec++   
				else 
					nTotNRec+= ZA6->ZA6_VLRCON
					nTEstNRec++
				Endif 
			ZA6->(dbskip())
			end 
		Endif  
		
		oTotRec:Refresh()   
		oTEstRec:Refresh() 
		oTotNRec:Refresh() 
		oTEstNRec:Refresh()
	Endif 

ELSEif nTipo == 4
	
	C6A02MAC("SE1",oGetD02:AHEADER,@aAux)	
	oGetD02:acols:= aclone(aAux)
	oGetD02:Refresh()
					
Endif

return   
/*------------------------------------------------------------------------
*
* C6A02MHD()
* Monta aHeader
*
------------------------------------------------------------------------*/
static function C6A02MHD(cArq,aHeaderAux,aCamps,lMark)
local lAddCmp:= .T.
                   
if lMark
	aadd(aHeaderAux,{"",cArq+"_XMARK","@BMP",1,0,"",,"C","","V","","",,"V","",,})
	
	if cArq == "SE1"
		aadd(aHeaderAux,{"",cArq+"_XLEG","@BMP",1,0,"",,"C","","V","","",,"V","",,})
	Endif
Endif

DBSELECTAREA("SX3")        
SX3->(DBSETORDER(1))
SX3->(DBSEEK(cArq))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cArq
	              
	lAddCmp := .T.
	if !EMPTY(aCamps)
		lAddCmp := ASCAN(aCamps,{|x| x==TRIM(SX3->X3_CAMPO) }) > 0 
	Endif
 
	if X3USO(SX3->X3_USADO) .and. lAddCmp  		
		aadd(aHeaderAux,{	AllTrim(X3Titulo()),;
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
	Endif
SX3->(dbSkip())		
EndDo	

return 
/*------------------------------------------------------------------------
*
* C6A02MAC()
* Monta aCols
*
------------------------------------------------------------------------*/
static function C6A02MAC(cArq,aHeaderAux,aAcolsAux)
local cTab		:= GetNextAlias()
local cQry		:= "" 

if cArq=="SZ8"       
	      
	BeginSQL Alias cTab	                         
		SELECT * FROM %Table:SZ8% SZ8 
		WHERE Z8_FILIAL=%xFilial:SZ8% 	
			AND Z8_CONTA BETWEEN %Exp:aMvPar[1]% AND %Exp:aMvPar[2]% 
			AND Z8_EMISSAO BETWEEN %Exp:aMvPar[3]% AND %Exp:aMvPar[4]%
			AND SZ8.D_E_L_E_T_=''
		ORDER BY Z8_REGISTR 		
	EndSQL                           

	TCSETFIELD(cTab,"Z8_EMISSAO","D")
		
ELSEif cArq=="SE1" 

	BeginSQL Alias cTab	                         	
		SELECT * FROM %Table:SE1% SE1
		WHERE E1_FILIAL=%xFilial:SE1%
			AND E1_CLIENTE=%Exp:SA1->A1_COD%
			AND E1_LOJA=%Exp:SA1->A1_LOJA%
			AND E1_NUM BETWEEN %Exp:aMvPar[5]% AND %Exp:aMvPar[6]%   
			AND E1_EMISSAO BETWEEN %Exp:DTOS(aMvPar[7])% AND %Exp:DTOS(aMvPar[8])% 
			AND E1_TIPO IN ('NF','NCC')					
			AND SE1.D_E_L_E_T_=''
		ORDER BY E1_NUM 	
	EndSQL                           

	TCSETFIELD(cTab,"E1_EMISSAO","D")     
	TCSETFIELD(cTab,"E1_VENCTO","D")
	TCSETFIELD(cTab,"E1_VENCREA","D")  
	
ELSEif cArq=="ZA5"
      
	BeginSQL Alias cTab	                         	
		SELECT * FROM %Table:ZA5% ZA5
		WHERE ZA5_FILIAL=%xFilial:ZA5%	
			AND ZA5_CGC=%Exp:TRIM(SA1->A1_CGC)% 
			AND ZA5.D_E_L_E_T_=''
		ORDER BY ZA5_COD
	EndSQL                           

	TCSETFIELD(cTab,"ZA5_DTAPRO","D")     
	TCSETFIELD(cTab,"ZA5_DTPORI","D")
	TCSETFIELD(cTab,"ZA5_DTPAG","D") 	
	TCSETFIELD(cTab,"ZA5_DTGERA","D")
	TCSETFIELD(cTab,"ZA5_DTPROP","D")
	 
Endif

(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF())        		
	
	nUsado01:= LEN(aHeaderAux)
	aadd(aAcolsAux,ARRAY(nUsado01+1))
	nTot:= LEN(aAcolsAux)   	       				
	For nCnt:= 1 TO nUsado01  
		if "_XMARK"$aHeaderAux[nCnt][2]
			aAcolsAux[nTot][nCnt]:= cLbNo			
		ELSEif "_XLEG"$aHeaderAux[nCnt][2]		
			if (cTab)->E1_SALDO == 0
		    	aAcolsAux[nTot][nCnt]:= "BR_VERMELHO"	//  "Titulo Compensado Totalmente"		    
		    elseif (cTab)->E1_SALDO <> (cTab)->E1_VALOR
		    	aAcolsAux[nTot][nCnt]:= "BR_AZUL"		// "Titulo Compensado Parcialmente" 		    
		    elseif (cTab)->E1_SALDO ==  (cTab)->E1_VALOR
		    	aAcolsAux[nTot][nCnt]:= "BR_VERDE"	 	// "Titulo nao Compensado"
			Endif		
		ELSE
			if aHeaderAux[nCnt][10] != "V" .AND. !"_OBS"$aHeaderAux[nCnt][2] 					
				aAcolsAux[nTot][nCnt]:= (cTab)->&(aHeaderAux[nCnt][2])				
			Endif	
		Endif	
	NEXT nCntc    
	aAcolsAux[nTot][nUsado01+1]:= .F.					    	   	   	   
(cTab)->(dbSkip())	
ENDDO  
(cTab)->(dbCloseArea()) 


return       
/*------------------------------------------------------------------------
*
* C6A02FOLH()
* Visualização analitica da folha
*
------------------------------------------------------------------------*/
static function C6A02FOLH() 
local nPosMrkBA := ASCAN(oGetD03:AHEADER,{|x| "_XMARK"$x[2] })                        
local nMarkBA 	:= 0 

if (nMarkBA:=ascan(oGetD03:ACOLS,{|x| x[nPosMrkBA] == cLbOk } ) ) > 0
	u_C6A02VFOL(GDFIELDGET("ZA5_COD",nMarkBA,,oGetD03:AHEADER,oGetD03:ACOLS),.t.)
ELSE
	MSGALERT("Selecione a folha para a visualização!")				  
Endif

return 
/*------------------------------------------------------------------------
*
* C6A02VFOL()
* Visualização analitica da folha
*
------------------------------------------------------------------------*/
user function C6A02VFOL(cCodFol,lFilRec)   
LOCAL oDlg		
LOCAL oGetD
LOCAL oEnCh
LOCAL cQuery    := ""
LOCAL aHeader 	:= {}
LOCAL aCols		:= {}
LOCAL aNoFields	:= {"ZA6_COD"}  
LOCAL aSize		:= MsAdvSize(.T.)
LOCAL aPosObj 	:= MsObjSize({aSize[1],aSize[2],aSize[3],aSize[4],3,3},{{ 0, 0, .T., .T. },{ 0, 0, .T., .T. }})                 
default lFilRec	:= .f.
  
	
cQuery:= " SELECT * FROM "+RETSQLNAME("ZA6")
cQuery+= " WHERE ZA6_FILIAL='"+XFILIAL("ZA6")+"'"	
cQuery+= "	AND ZA6_COD='"+cCodFol+"'"	
if lFilRec
	cQuery+= "	AND ZA6_CODEXT=''"	
endif		
cQuery+= "	AND D_E_L_E_T_=''"
cQuery+= " ORDER BY ZA6_COD,ZA6_SEQ,ZA6_CODEST"
	
FillGetDados(2,"ZA6",1,,,{|| .T. },aNoFields,,,cQuery,,,aHeader,aCols)

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL 
	EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()},,)                                                     
	oEnCh:= MsMGet():New("ZA5",ZA5->(RECNO()),2,,,,,aPosObj[1],,,,,,,,,.T.)      		
	oGetD:=	MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],0,,,,,,,,,,oDlg,aHeader,aCols)       	
ACTIVATE MSDIALOG oDlg CENTERED

return       
/*------------------------------------------------------------------------
*
* C6A02ALTE()
* Alterar extrato
*
------------------------------------------------------------------------*/
static function C6A02ALTE()
local cRegBan:= GDFIELDGET("Z8_REGISTR",oGetD01:nat,,oGetD01:AHEADER,oGetD01:ACOLS) 
local nOpcA:= 0
local oSize
local cCampo
local aPosEnch      
Private aRotina 	:= {	{"Pesquisar" 	, "AxPesqui"    ,0,1},;
							{"Visualizar"	, "axvisual"  	,0,2},;							
							{"Incluir"		, "axinclui"	,0,3},;
							{"Alterar"		, "axaltera"  	,0,4}}  

dbselectarea("SZ8")
dbsetorder(8)
if SZ8->(dbseek(xfilial("SZ8")+cRegBan))

	RegToMemory("SZ8",.F.)
	ALTERA:= .F.
	INCLUI:= .T. 		
	 		
	oSize := FwDefSize():New( .T. ) 					
	oSize:lLateral     := .F.  
	oSize:AddObject( "OBJ_1", 100, 100, .T., .T. ) 
	oSize:Process() 
	
	aPosEnch := {oSize:GetDimension("OBJ_1","LININI"),;
				 oSize:GetDimension("OBJ_1","COLINI"),;
				 oSize:GetDimension("OBJ_1","LINEND"),;
				 oSize:GetDimension("OBJ_1","COLEND")}
						
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL OF oMainWnd		
	   	EnchoiceBar(oDlg,{|| nOpcA:=1 , oDlg:End() },{|| nOpcA:= 0, oDlg:End()}) 
			
		oEnCh:= MsMGet():New( "SZ8",SZ8->(recno()), 4,,,,,aPosEnch,,1,,,,,,,.T.) 
		oEnCh:oBox:align := CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oDlg CENTERED 
	
	if nOpcA == 1   
		RecLock("SZ8",.f.)                 				
		FOR nCnta := 1 TO SZ8->(FCOUNT())    
			cCampo:= TRIM(FIELDNAME(nCnta))
			SZ8->(FieldPut(nCnta,M->&(cCampo) ))	
			GDFIELDPUT(cCampo,M->&(cCampo),oGetD01:nat,oGetD01:AHEADER,oGetD01:ACOLS)
		NEXT nCnta    		
		SZ8->(MSUNLOCK())					  	            					
	
		oGetD01:Refresh()
	Endif  

Endif

return   
/*------------------------------------------------------------------------
*
* C6A02EXCT()
* Exclui titulo
*
------------------------------------------------------------------------*/
static function C6A02EXCT()
local cRegBan:= GDFIELDGET("Z8_REGISTR",oGetD01:nat,,oGetD01:AHEADER,oGetD01:ACOLS)   
local lRet:= .t.

dbselectarea("SZ8")
dbsetorder(8)
if SZ8->(dbseek(xfilial("SZ8")+cRegBan))

	if SZ8->Z8_BA > 0 .or. SZ8->Z8_CI > 0
		msgalert("O extrato já possui vinculos!")
		lRet:= .F.    
	endif         
	
	if Empty(SZ8->Z8_NUMTIT)
		msgalert("O extrato não possui titulo gerado!")
		lRet:= .F.  	
	endif  
	
	DBSELECTAREA("SE1")
	DBSETORDER(1) 
	if DBSEEK(xFilial("SE1")+SZ8->Z8_PRXTIT+SZ8->Z8_NUMTIT+" "+SZ8->Z8_TIPTIT)				 	
	 	if SE1->E1_VALOR != SE1->E1_SALDO
			msgalert("O titulo possui movimentações de baixa!")
			lRet:= .F. 		 	
	 	endif	 	
    Endif	
	
	if lRet .and. MSGYESNO("Confima a exclusão do titulo ?")  			 	
    	if C6A02TIT("3",5)
	    	msginfo("Titulo excluido com sucesso.")
    	endif
    Endif
Endif

return 

/*------------------------------------------------------------------------
*
* C6A02LEGE()
* Visualiza legendas
*
------------------------------------------------------------------------*/
static function C6A02LEGE() 
Local aLegenda := {	{"BR_VERDE"		, "Titulo nao Compensado"	},; 
				   	{"BR_VERMELHO"	, "Titulo Compensado Totalmente"	},; 
					{"BR_AZUL"		, "Titulo Compensado Parcialmente"	}} 
																					
BrwLegenda(cCadastro, "Legenda", aLegenda)
return
/*------------------------------------------------------------------------
*
* C6A02SX1()
* Atualiza parametros SX1
*
------------------------------------------------------------------------*/
static function C6A02SX1(cPerg)
local aArea    	:= GetArea()
local aAreaDic 	:= SX1->( GetArea() )
local aEstrut  	:= {}
local aStruDic 	:= SX1->( dbStruct() )
local aDados	:= {}
local nXa       := 0
local nXb       := 0
local nXc		:= 0
local nTam1    	:= Len( SX1->X1_GRUPO )
local nTam2    	:= Len( SX1->X1_ORDEM )
local lAtuHelp 	:= .F.            
local aHelp		:= {}	

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , 'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , 'X1_VAR01'  , 'X1_DEF01'  , ;
             'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , 'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', ;
             'X1_CNT02'  , 'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , 'X1_VAR04'  , ;
             'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , 'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', ;
             'X1_DEFENG5', 'X1_CNT05'  , 'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }
                      
aadd(aDados,{cPerg,'01','Conta de           ?','Conta de           ?','Conta de           ?','MV_CH1','C',10,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','N','','',''} )
aadd(aDados,{cPerg,'02','Conta Até          ?','Conta Até          ?','Conta Até          ?','MV_CH2','C',10,0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','','','N','','',''} )
aadd(aDados,{cPerg,'03','Importação de      ?','Importação de      ?','Importação de      ?','MV_CH3','D',8,0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','','','N','','',''} )
aadd(aDados,{cPerg,'04','Importação Até     ?','Importação Até     ?','Importação Até     ?','MV_CH4','D',8,0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','','','N','','',''} )
aadd(aDados,{cPerg,'05','Titulo de          ?','Titulo de          ?','Titulo de          ?','MV_CH5','C',10,0,0,'G','','MV_PAR05','','','','','','','','','','','','','','','','','','','','','','','','','','','N','','',''} )
aadd(aDados,{cPerg,'06','Titulo até         ?','Titulo até         ?','Titulo até         ?','MV_CH6','C',10,0,0,'G','','MV_PAR06','','','','','','','','','','','','','','','','','','','','','','','','','','','N','','',''} )
aadd(aDados,{cPerg,'07','Emissão titulo de  ?','Emissão titulo de  ?','Emissão titulo de  ?','MV_CH3','D',8,0,0,'G','','MV_PAR07','','','','','','','','','','','','','','','','','','','','','','','','','','','N','','',''} )
aadd(aDados,{cPerg,'08','Emissão titulo Até ?','Emissão titulo Até ?','Emissão titulo Até ?','MV_CH4','D',8,0,0,'G','','MV_PAR08','','','','','','','','','','','','','','','','','','','','','','','','','','','N','','',''} )

//
// Atualizando dicionário
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aDados )
	if !SX1->( dbSeek( PadR( aDados[nXa][1], nTam1 ) + PadR( aDados[nXa][2], nTam2 ) ) )
		lAtuHelp:= .T.
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aDados[nXa] )
			if aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aDados[nXa][nXb] ) )
			Endif
		Next nXb
		MsUnLock()
	Endif
Next nXa

// Atualiza Helps
if lAtuHelp 
	aadd(aHelp, {'01',{'Conta corrente inicial.'},{''},{''}})
	aadd(aHelp, {'02',{'Conta corrente final.'},{''},{''}})
	aadd(aHelp, {'03',{'Data de importarção inicial.'},{''},{''}})
	aadd(aHelp, {'04',{'Data de importarção final.'},{''},{''}}) 
	aadd(aHelp, {'05',{'Numero do titulo inicial.'},{''},{''}})
	aadd(aHelp, {'06',{'Numero do titulo final.'},{''},{''}})
	aadd(aHelp, {'07',{'Data inicial de emissão do titulo.'},{''},{''}})
	aadd(aHelp, {'08',{'Data final de emissão do titulo.'},{''},{''}}) 	

	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	

Endif	

RestArea( aAreaDic )
RestArea( aArea )   
return