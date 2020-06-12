#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CFINA06
Configura็ใo de Modelo de presta็ใo de contas
@author     Totvs
@since     	01/08/2014
@version  	P.11      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera็๕es Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
	    	|                 | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CFINA06() 
LOCAL cAlias		:= "ZA7" 
Local cFiltra 		:= ""                            
LOCAL aCores 		:= {{ "ZA7_STATUS == 'R'",	'BR_VERMELHO'	},;	//Modelo em revisใo
						{ "ZA7_STATUS == 'L'",	'BR_VERDE'		}}	//Modelo Liberado
Private cCadastro 	:= "Modelo de presta็ใo de contas" 
Private aRotina 	:= {	{"Pesquisar" ,"AxPesqui"    ,0,1},;
							{"Visualizar","U_C6A06MAT"   ,0,2},; 
							{"Incluir"   ,"U_C6A06MAT"   ,0,3},; 
							{"Alterar"   ,"U_C6A06MAT"   ,0,4},;
							{"Excluir"   ,"U_C6A06MAT"   ,0,5},;
							{"Revisar"   ,"U_C6A06MAT"   ,0,6},;
							{"Legenda"   ,"U_C6A06LEG"	  ,0,7}}								
	

dbSelectArea(cAlias)
dbSetOrder(1)							
mBrowse(6,1,22,75,cAlias,,,,,,aCores)						
	
RETURN  
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A06MAT   บAutor  ณTotvs		       บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Manuten็ใo					 	 					      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
USER FUNCTION C6A06MAT(cAlias,nReg,nOpc) 
LOCAL oDlg			:= NIL 
Local oLayer		:= NIL
Local oPnl01		:= NIL
Local oPnl02		:= NIL
Local oPnl03		:= NIL
LOCAL aSize			:= MsAdvSize(.T.)
LOCAL nOpcA			:= 0 
LOCAL cQuery    	:= ""
LOCAL aHeadJan1 	:= {}
LOCAL aColsJan1		:= {} 
LOCAL aHeadJan2 	:= {}
LOCAL aColsJan2		:= {} 
LOCAL nModo			:= IIF(nOpc==3 .OR. nOpc==4,GD_INSERT+GD_DELETE+GD_UPDATE,0) 
LOCAL lRet			:= .T.       
Local aButtons		:= {}  
LOCAL cTxtSql		:= "" 
Local oFont     	:= NIL
Private oEnCh		:= NIL
Private oGetJan1	:= NIL   
Private oGetJan2	:= NIL
Private oMemoSQL    := NIL  
Private aDadAcols2	:= {}
Private cItIW		:= ""


IF nOpc == 3              					
	RegToMemory("ZA7",.T.)			
	FillGetDados(nOpc,"ZA8",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.T.,aHeadJan1,aColsJan1)
	GDFieldPut("ZA8_ITEM",StrZero(1,TamSX3("ZA8_ITEM")[1]),1,aHeadJan1,aColsJan1)
	
	FillGetDados(nOpc,"ZA9",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.T.,aHeadJan2,aColsJan2)			
	//GDFieldPut("ZA9_ITEM",StrZero(1,TamSX3("ZA9_ITEM")[1]),1,aHeadJan2,aColsJan2)
ELSE      
	
	cQuery:= " SELECT * FROM "+RETSQLNAME("ZA8")
	cQuery+= " WHERE ZA8_FILIAL='"+XFILIAL("ZA8")+"'"	
	cQuery+= "	AND ZA8_COD='"+(cAlias)->ZA7_COD+"'"	
	cQuery+= "	AND D_E_L_E_T_=''"
	cQuery+= " ORDER BY "+SqlOrder(ZA8->(IndexKey()))
		
	RegToMemory("ZA7",.F.)
	FillGetDados(nOpc,"ZA8",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,cQuery,/*bMontCols*/,/*lEmpty*/,aHeadJan1,aColsJan1)		
	
	FillGetDados(nOpc,"ZA9",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.T.,aHeadJan2,aColsJan2)
	//GDFieldPut("ZA9_ITEM",StrZero(1,TamSX3("ZA9_ITEM")[1]),1,aHeadJan2,aColsJan2)
ENDIF

Define Font oFont Name "Mono AS" Size 8, 14
DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL 
	EnchoiceBar(oDlg,{|| Iif(U_C6A06TOK(nOpc),(nOpcA := 1, oDlg:End()),NIL)},{|| oDlg:End()},,aButtons)                                                     
	
	oLayer:= FWLayer():new()        
	oLayer:Init(oDlg,.F.,.T.)

	oLayer:addLine("Lin01",25,.F.) 
	oLayer:addLine("Lin02",75,.F.)
	oLayer:addCollumn("Col01",100,.F.,"Lin01")
	oLayer:addCollumn("Col02",50,.F.,"Lin02")
	oLayer:addCollumn("Col03",50,.F.,"Lin02")	
	
	oLayer:addWindow("Col02","Jan01","Indicadores Word",100,.F.,.F.,,"Lin02")
	oLayer:addWindow("Col03","Jan02","Expressใo SQL",30,.F.,.F.,,"Lin02")
	oLayer:addWindow("Col03","Jan03","Indicadores Tabela x Expressใo SQL",70,.F.,.F.,,"Lin02")
 	 	                                          	
	oPnl01:= oLayer:getColPanel("Col01","Lin01")
	oPnl02:= oLayer:getWinPanel("Col02","Jan01","Lin02")
	oPnl03:= oLayer:getWinPanel("Col03","Jan02","Lin02")
	oPnl04:= oLayer:getWinPanel("Col03","Jan03","Lin02")
	
	/* 	 	                                          	
	oPnl01:= oLayer:getColPanel("Col01","Lin01")
	oPnl02:= oLayer:getColPanel("Col02","Lin02") 
	oPnl03:= oLayer:getColPanel("Col03","Lin02") 
	*/	
		
	oEnCh:= MsMGet():New(cAlias,nReg,nOpc,,,,,,,,,,,oPnl01)
	oEnCh:OBOX:ALIGN:= CONTROL_ALIGN_ALLCLIENT
	
	oGetJan1:=	MsNewGetDados():New(1,1,1,1,nModo,"U_C6A06LOK()","AllwaysTrue()","+ZA8_ITEM",,,999,"U_C6A06FOK()",,"AllwaysTrue()",oPnl02,aHeadJan1,aColsJan1)  
    oGetJan1:OBROWSE:BCHANGE:= {|| C6A06GD2(nOpc,1) }
	oGetJan1:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT  
	
	@ 5, 5 Get oMemoSQL Var cTxtSql Memo Size 20, 20 Of oPnl03 Pixel
	oMemoSQL:bRClicked := { || AllwaysTrue() }
	oMemoSQL:oFont     := oFont
	oMemoSQL:align:= CONTROL_ALIGN_ALLCLIENT	
	
	oGetJan2:=	MsNewGetDados():New(1,1,1,1,nModo,"U_C6A06LOK()","AllwaysTrue()","+ZA9_ITEM",,,999,"AllwaysTrue()",,"AllwaysTrue()",oPnl04,aHeadJan2,aColsJan2) 	
	oGetJan2:OBROWSE:BLOSTFOCUS:= {|| C6A06GD2(nOpc,2) }
	oGetJan2:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT
		     	
ACTIVATE MSDIALOG oDlg CENTERED   

IF nOpcA > 0 .and. nOpc!=2   
	Begin TransAction         
	    Processa({|| C6A06GRV(cAlias,nOpc) },"Gravando, aguarde...")		
		If __lSX8
			ConfirmSX8()
		EndIf
	End TransAction	
ELSE
	If __lSX8
		RollBackSX8()
	EndIf
ENDIF         


RETURN  
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A06GD2   บAutor  ณTotvs		       บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza get 2   			 	 					      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/       
STATIC FUNCTION C6A06GD2(nOpc,nObj)  
LOCAL aHeadJan2 	:= {}
LOCAL aColsJan2		:= {}  
LOCAL nTem			:= 0  
LOCAL nCnt			:= 0


IF nObj == 1
    
	cItIW:= GDFieldGet("ZA8_ITEM",oGetJan1:nAt,,oGetJan1:AHEADER,oGetJan1:ACOLS)
	
	IF (nTem:= ASCAN(aDadAcols2,{|x| x[1]= M->ZA7_COD+M->ZA7_REV+cItIW })) == 0  	
		cQuery:= " SELECT * FROM "+RETSQLNAME("ZA9")
		cQuery+= " WHERE ZA9_FILIAL='"+XFILIAL("ZA9")+"'"	
		cQuery+= "	AND ZA9_COD='"+M->ZA7_COD+"'"	
		cQuery+= "	AND ZA9_REV='"+M->ZA7_REV+"'"	
		cQuery+= "	AND ZA9_ITIW='"+cItIW+"'"
		cQuery+= "	AND D_E_L_E_T_=''"
		cQuery+= " ORDER BY "+SqlOrder(ZA9->(IndexKey()))
			
		FillGetDados(nOpc,"ZA9",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,cQuery,/*bMontCols*/,/*lEmpty*/,aHeadJan2,aColsJan2)		
		
		IF EMPTY(GDFieldGet("ZA9_ITEM",1,,aHeadJan2,aColsJan2))   
			GDFieldPut("ZA9_ITEM",StrZero(1,TamSX3("ZA9_ITEM")[1]),1,aHeadJan2,aColsJan2)
		ENDIF	
	ELSE
		aColsJan2:= ACLONE(aDadAcols2[nTem][2])
	ENDIF
	
	
	
	//oGetJan2:AHEADER:= aCLONE(aHeadJan2)
	oGetJan2:ACOLS	:= aCLONE(aColsJan2) 
	oGetJan2:oBrowse:Refresh()

ELSEIF nObj == 2

   	/*	
   	FOR nCnt:= 1 TO LEN(oGetJan2:ACOLS)
		IF !oGetJan2:ACOLS[nCnt][LEN(oGetJan1:ACOLS[nCnt])]
	    
	    ELSE
	    
	    ENDIF
	NEXT nCnt
	*/	

ENDIF

RETURN
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A06GRV   บAutor  ณTotvs		       บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime a presta็ใo de contas 	 					      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/       
STATIC FUNCTION C6A06GRV(cAlias,nOpc)
LOCAL nCnta		:= 0
LOCAL nCntb		:= 0
LOCAL nCntc		:= 0       
LOCAL lInc		:= nOpc==3
LOCAL lDel		:= nOpc==5     


RecLock(cAlias,lInc)
IF lDel
	(cAlias)->(DBDELETE())
ELSE                  	
	FOR nCnta := 1 TO (cAlias)->(FCOUNT()) 
		cCampo:= TRIM(FIELDNAME(nCnta))
		IF "_FILIAL"$cCampo
			(cAlias)->(FieldPut(nCnta,XFILIAL("ZA7"))) 
		ELSE
			(cAlias)->(FieldPut(nCnta,M->&(cCampo) ))
		ENDIF	
	NEXT nCnta    
ENDIF
(cAlias)->(MSUNLOCK())   

DBSELECTAREA("ZA8")
ZA8->(DBSETORDER(1))
FOR nCntb:=1 TO LEN(oGetJan1:ACOLS)  	       				
	IF !oGetJan1:ACOLS[nCntb][LEN(oGetJan1:ACOLS[nCntb])]
		IF lInc
			RecLock("ZA8",lInc)
				ZA8->ZA8_FILIAL	:= XFILIAL("ZA8") 
				ZA8->ZA8_COD	:= M->ZA7_COD
				ZA8->ZA8_REV	:= M->ZA7_REV
				For nCntc:= 1 TO LEN(oGetJan1:AHEADER)-1 
					ZA8->(FieldPut(FieldPos(Trim(oGetJan1:AHEADER[nCntc][2])),oGetJan1:ACOLS[nCntb][nCntc]))
				NEXT nCntc        		
			ZA8->(MSUNLOCK())		
		ELSE
			lInc:= !ZA8->(DBSEEK(XFILIAL("ZA8")+M->ZA7_COD+M->ZA7_REV+oGetJan1:ACOLS[nCntb][GDFieldPos("ZA8_ITEM",oGetJan1:AHEADER)]))
			RecLock("ZA8",lInc)
			IF lDel
				ZA8->(DBDELETE())  
			ELSE      
				ZA8->ZA8_FILIAL	:= XFILIAL("ZA8") 
				ZA8->ZA8_COD	:= M->ZA7_COD 
				ZA8->ZA8_REV	:= M->ZA7_REV
				For nCntc:= 1 TO LEN(oGetJan1:AHEADER)-1 
					ZA8->(FieldPut(FieldPos(Trim(oGetJan1:AHEADER[nCntc][2])),oGetJan1:ACOLS[nCntb][nCntc]))
				NEXT nCntc 
			ENDIF                     		
			ZA8->(MSUNLOCK()) 		
		ENDIF	              		
	ELSE
		IF ZA8->(DBSEEK(XFILIAL("ZA8")+M->ZA7_COD+M->ZA7_REV+oGetJan1:ACOLS[nCntb][GDFieldPos("ZA8_ITEM",oGetJan1:AHEADER)]))
			RecLock("ZA8",.F.)
				ZA8->(DBDELETE())      		
			ZA8->(MSUNLOCK())
		ENDIF	
	ENDIF
NEXT nCntb         
                   	
RETURN
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A06LOK   บAutor  ณTotvs		       บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo linhaok			 	 					      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
USER FUNCTION C6A06LOK()
LOCAL lRet	:= .T. 	

RETURN lRet   
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A06TOK   บAutor  ณTotvs		       บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo tudook			 	 					      	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
USER FUNCTION C6A06TOK()
LOCAL lRet	:= .T. 	

RETURN lRet      
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A06WHN   บAutor  ณTotvs		       บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo x3_when		 	 					      	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
USER FUNCTION C6A06WHN() // U_C6A06WHN()
LOCAL cCampo	:= TRIM(READVAR())
LOCAL lRet		:= .T.        

DO CASE                										
	CASE cCampo == "M->ZA8_FORM"
		IF GDFieldGet("ZA8_TIPO",oGetJan1:nAt,,oGetJan1:AHEADER,oGetJan1:ACOLS)$"T,I"							
        	lRet:= .F.
        ENDIF
ENDCASE

	
RETURN lRet 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A06FOK   บAutor  ณTotvs		       บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo de campo 		 	 					      	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
USER FUNCTION C6A06FOK()
LOCAL cCampo	:= TRIM(READVAR())
LOCAL lRet		:= .T.        

DO CASE                										
	CASE cCampo == "M->ZA8_TIPO"
		IF M->ZA8_TIPO == "T"							
        	GDFieldPut("ZA8_FORM",'""',oGetJan1:nAt,oGetJan1:AHEADER,oGetJan1:ACOLS)
        ELSEIF M->ZA8_TIPO == "I"	
	        GDFieldPut("ZA8_FORM",'"INSERIR A IMAGEM AQUI..."',oGetJan1:nAt,oGetJan1:AHEADER,oGetJan1:ACOLS)
	    ELSE
			GDFieldPut("ZA8_FORM",SPACE(TamSX3("ZA8_FORM")[1]),oGetJan1:nAt,oGetJan1:AHEADER,oGetJan1:ACOLS)	        
        ENDIF
ENDCASE

	
RETURN lRet
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A06LEG   บAutor  ณTotvs		       บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Legenda					 	 					      	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
user function C6A06LEG()

RETURN