#Include 'Protheus.ch'

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOMA02
Solicitação de compras WEB
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CCOMA02()      
LOCAL cAlias		:= "ZA1" 
LOCAL aCores 		:= {{"ZA1_STATUS == '1'",	'BR_AMARELO' 	},;	// Em aprovação
						{"ZA1_STATUS == '2'",	'BR_VERDE' 	},;	// Pendente
						{"ZA1_STATUS == '3'",	'BR_CINZA' 	},;	// Reprovado
						{ "ZA1_STATUS == '4'",	'BR_VERMELHO'}}	// Finalizado
Private cCadastro 	:= "Solicitação de compras WEB" 
Private aRotina 	:= {	{"Pesquisar" 		,"AxPesqui"    	,0,1},;
							{"Visualizar" 	,"U_C2A02MAT"    	,0,2},; 
							{"Conhecimento" 	,"MsDocument"  	,0,3},;
							{"Alterar"   		,"U_C2A02MAT" 	,0,4},;							
							{"Excluir"   		,"U_C2A02MAT" 	,0,5},;
							{"Cons. Aprovação","U_CCOME03" 		,0,6},; 
							{"Legenda"   		,"U_C2A02LEG"	  	,0,7}}															
														

dbSelectArea(cAlias)
dbSetOrder(1)							
mBrowse(6,1,22,75,cAlias,,,,,,aCores)							

RETURN  
/*------------------------------------------------------------------------
*
* C2A02MAT()
* Rotina de manutenção 
*
------------------------------------------------------------------------*/
USER FUNCTION C2A02MAT(cAlias,nReg,nOpc) 
LOCAL oDlg			:= NIL
LOCAL aSize		:= MsAdvSize(.T.)
LOCAL aPosObj 	:= MsObjSize({aSize[1],aSize[2],aSize[3],aSize[4],3,3},{{ 0, 0, .T., .T. },{ 0, 0, .T., .T. }})            
LOCAL nOpcA		:= 0 
LOCAL cQuery    	:= ""
LOCAL aHeader 	:= {}
LOCAL aCols		:= {} 
LOCAL nModo		:= IIF(nOpc == 4,GD_INSERT+GD_DELETE+GD_UPDATE,0)
LOCAL aCpoEnch	:= {}
LOCAL aField		:= {}
LOCAL aYesFields	:= {"ZA1_ITEM","ZA1_PRODUT","ZA1_DESC","ZA1_QUANT","ZA1_UM"}
Private oGetD		:= NIL  	 

if nOpc == 4 .or. nOpc == 5
	IF ZA1->ZA1_STATUS == "1"
		msgalert("Formulário aguardando aprovação.")
		Return	
	ENDIF
		
	IF ZA1->ZA1_STATUS == "3"
		msgalert("Formulário de solicitação já finalizado.")
		Return	
	ENDIF		 
endif

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(cAlias)
While !Eof() .And. SX3->X3_ARQUIVO == cAlias	
	
	IF ASCAN(aYesFields,{|x| trim(x)==Trim(SX3->X3_CAMPO) }) == 0
		If !("_FILIAL"$SX3->X3_CAMPO ) .And. X3Uso(SX3->X3_USADO)		
			AADD(aCpoEnch,SX3->X3_CAMPO)
			
			AADD(aField, {X3TITULO(),;			
							SX3->X3_CAMPO,;			
							SX3->X3_TIPO,;			
							SX3->X3_TAMANHO,;			
							SX3->X3_DECIMAL,;			
							SX3->X3_PICTURE,;			
							SX3->X3_VALID,; 			
							.F.,;			
							SX3->X3_NIVEL,;			
							SX3->X3_RELACAO,;			
							SX3->X3_F3,;			
							SX3->X3_WHEN,;			
							.F.,;			
							.F.,;			
							SX3->X3_CBOX,;			
							Val(SX3->X3_FOLDER),;			
							.F.,;			
							SX3->X3_PICTVAR,;			
							SX3->X3_TRIGGER})			
				
		EndIf		 
	EndIf	
DbSkip()
End	

 
RegToMemory("ZA1",.F.)	
cQuery:= " SELECT * FROM "+RETSQLNAME("ZA1")
cQuery+= " WHERE ZA1_FILIAL='"+XFILIAL("ZA1")+"'"	
cQuery+= "	AND ZA1_COD='"+ZA1->ZA1_COD+"'"			
cQuery+= "	AND D_E_L_E_T_=''"
cQuery+= " ORDER BY ZA1_ITEM,ZA1_PRODUT"
		
FillGetDados(nOpc,"ZA1",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },/*aNoFields*/,aYesFields,/*lOnlyYes*/,cQuery,/*bMontCols*/,/*lEmpty*/,aHeader,aCols)


DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL 
	EnchoiceBar(oDlg,{|| Iif(U_C2A02TOK(nOpc),(nOpcA := 1, oDlg:End()),NIL)},{|| oDlg:End()},,)                                                     
	oEnCh:= MsMGet():New(cAlias,nReg,nOpc,,,,,aPosObj[1],aCpoEnch,,2,,,oDlg,,.T.,,,,,aField)
	oGetD:=	MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nModo,;
	"AllwaysTrue()","AllwaysTrue()","+ZA1_ITEM",,,999,"AllwaysTrue()",,"AllwaysTrue()",oDlg,aHeader,aCols)      	
ACTIVATE MSDIALOG oDlg CENTERED 
 
IF nOpcA > 0  
	C2A02GRV(nOpc)		
ENDIF

RETURN   
/*------------------------------------------------------------------------
*
* C2A02TOK()
* Validação tudook
*
------------------------------------------------------------------------*/
USER FUNCTION C2A02TOK(nOpc)
LOCAL lRet:= .T.      

if nOpc == 5

	If !MsgNoYes( "Deseja realmente excluir esta solicitação?", "Atencão" )
		lRet:= .F.	
	Endif
	
endif

RETURN lRet            
/*------------------------------------------------------------------------
*
* C2A02GRV()
* Processa a gravação
*
------------------------------------------------------------------------*/
STATIC FUNCTION C2A02GRV(nOpc)
local cCodSol	:= M->ZA1_COD
LOCAL nCnta	:= 0   
LOCAL nPosIt	:= GDFieldPos("ZA1_ITEM",oGetD:AHEADER) 
LOCAL aCabec	:= {} 
LOCAL aLin 	:= {}
LOCAL aItens	:= {}
LOCAL cNumSc	:= ""
LOCAL nTamIt	:= TAMSX3("C1_ITEM")[1]
LOCAL nSeqItem:= 0
Private lMsErroAuto:=.F.

If nOpc == 5		
	IF MSGYESNO("Deseja gera a solicitação de compras WEB?", "Atencão")
		cNumSc	:= M->ZA1_NUMSC
	
		IF !EMPTY(cNumSc)
			DBSELECTAREA("SC1")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SC1")+cNumSc)
			
		
			
				AADD(aCabec,{"C1_FILIAL"		, SC1->C1_FILIAL })				
				AADD(aCabec,{"C1_NUM"     	, SC1->C1_NUM })		

				WHILE SC1->(!EOF()) .AND. SC1->(C1_FILIAL+C1_NUM) == xfilial("SC1")+cNumSc
					aLin := {}
					AADD(aLin,{"C1_ITEM"   	, SC1->C1_ITEM		, Nil})			
					AADD(aLin,{"C1_PRODUTO"	, SC1->C1_PRODUTO		, Nil})			
					AADD(aLin,{"C1_DESCRI"	, SC1->C1_DESCRI		, Nil})			
					AADD(aLin,{"C1_QUANT"  	, SC1->C1_QUANT   	, Nil})			
					AADD(aLin,{"C1_UM"		, SC1->C1_UM			, Nil})
					AADD(aLin,{"C1_DATPRF"	, SC1->C1_DATPRF	 	, Nil})
					AADD(aLin,{"C1_USER"		, SC1->C1_USER 		, Nil})						  
					AADD(aLin,{"C1_ORIGEM"	, SC1->C1_ORIGEM		, Nil})				
					AADD(aItens,aLin)
				SC1->(DBSKIP())	
				END			
			
			
				IF !EMPTY(aItens)
					
					MSExecAuto({|x,y| MATA110(x,y)},aCabec,aItens,5)
					
					IF lMsErroAuto   	 	
						MostraErro() 													
					ELSE    
						dbselectarea("ZA1")
						ZA1->( dbSetOrder(1) )
						ZA1->( dbSeek( xFilial( "ZA1" ) + cCodSol ) )
						While ZA1->( !EOF() ) .And. xFilial( "ZA1" ) == ZA1->ZA1_FILIAL .And. cCodSol == ZA1->ZA1_COD
							RecLock( "ZA1", .F. )
							ZA1->( dbDelete() )
							ZA1->( MsUnlock() )
							ZA1->( dbSkip() )
						End	
						
						msginfo("Exclusão realizada com sucesso.")
					ENDIF 				
							
				ENDIF
			ENDIF
		ENDIF	
	ENDIF
	
Else	
	// Gravar dados do GRID
	FOR nCnta:=1 TO LEN(oGetD:ACOLS)  	       				
		IF !oGetD:ACOLS[nCnta][LEN(oGetD:ACOLS[nCnta])]
			lInc:= !ZA1->(DBSEEK(XFILIAL("ZA1")+cCodSol+oGetD:ACOLS[nCnta][nPosIt]))
			RecLock("ZA1",lInc)    
				ZA1->ZA1_FILIAL	:= XFILIAL("ZA1") 
				ZA1->ZA1_COD		:= M->ZA1_COD 
				For nCntb:= 1 TO LEN(oGetD:AHEADER)-1 
					IF (!Trim(oGetD:AHEADER[nCntb][2])$"ZA1_ALI_WT,ZA1_REC_WT")
						ZA1->(FieldPut(FieldPos(Trim(oGetD:AHEADER[nCntb][2])),oGetD:ACOLS[nCnta][nCntb]))
					ENDIF
				NEXT nCntb          		
			ZA1->(MSUNLOCK()) 
			
			nSeqItem++
			aLin := {}	 		                               			 
			AADD(aLin,{"C1_ITEM"   	, STRZERO(nSeqItem,nTamIt)	, Nil})			
			AADD(aLin,{"C1_PRODUTO"	, ZA1->ZA1_PRODUT				, Nil})			
			AADD(aLin,{"C1_DESCRI"	, POSICIONE("SB1",1,xfilial("SB1")+ZA1->ZA1_PRODUT,"B1_DESC"), Nil})			
			AADD(aLin,{"C1_QUANT"  	, ZA1->ZA1_QUANT   			, Nil})			
			AADD(aLin,{"C1_UM"		, POSICIONE("SB1",1,xfilial("SB1")+ZA1->ZA1_PRODUT,"B1_UM"), Nil})
			AADD(aLin,{"C1_DATPRF"	, ZA1->ZA1_PRAZO	 			, Nil})
			AADD(aLin,{"C1_USER"		, __cUserID	 				, Nil})						  
			AADD(aLin,{"C1_CONTA"	, POSICIONE("SB1",1,xfilial("SB1")+ZA1->ZA1_PRODUT,"B1_CONTA"), Nil})
			AADD(aLin,{"C1_CC"		, POSICIONE("CTT",1,xfilial("CTT")+ZA1->ZA1_CR,"CTD_XCCPDR"), Nil})
			AADD(aLin,{"C1_ITEMCTA"	, ZA1->ZA1_CR					, Nil})
			AADD(aLin,{"C1_ORIGEM"	, "CCOMA02"		 			, Nil})				
			AADD(aItens,aLin)									
		ELSE
			IF ZA1->(DBSEEK(XFILIAL("ZA1")+cCodSol+oGetD:ACOLS[nCnta][nPosIt]))
				RecLock("ZA1",.F.)
					ZA1->(DBDELETE())       		
				ZA1->(MSUNLOCK())
			ENDIF	
		ENDIF
	NEXT nCnta 	
	
	IF MSGYESNO("Deseja gerar a solicitação de compras ?", "Atencão")
		
		cNumSc	:= GetNumSc1()
		
		AADD(aCabec,{"C1_FILIAL"		, xFilial("SC1")})				
		AADD(aCabec,{"C1_NUM"     	, cNumSc})		
		AADD(aCabec,{"C1_SOLICIT" 	, UsrRetName(__cUserId) })		
		AADD(aCabec,{"C1_EMISSAO" 	, dDataBase})
		
		
		IF !EMPTY(aItens)
			MSExecAuto({|x,y| MATA110(x,y)},aCabec,aItens,3)
			
			IF lMsErroAuto   	 	
				DBSELECTAREA("SC1")			
				SC1->(DBSETORDER(1))
				IF SC1->(DBSEEK(xFilial("SC1")+cNumSc))
					ConfirmSX8()
					
					dbselectarea("ZA1")
					ZA1->( dbSetOrder(1) )
					ZA1->( dbSeek( xFilial( "ZA1" ) + cCodSol ) )
					While ZA1->( !EOF() ) .And. xFilial( "ZA1" ) == ZA1->ZA1_FILIAL .And. cCodSol == ZA1->ZA1_COD
						RecLock( "ZA1", .F. )
						ZA1->ZA1_NUMSC	:= cNumSc
						ZA1->ZA1_STATUS	:= "4"
						ZA1->( MsUnlock() )
					ZA1->( dbSkip() )
					End						
					
					//U_CCOME02()
					
					msginfo("Solicitação de compras gerado com sucesso.")					
				ELSE
					ROLLBACKSX8()
					MostraErro() 													
				ENDIF
			ELSE    
				DBSELECTAREA("SC1")			
				SC1->(DBSETORDER(1))
				IF SC1->(DBSEEK(xFilial("SC1")+cNumSc))				
					ConfirmSX8()
							
					dbselectarea("ZA1")
					ZA1->( dbSetOrder(1) )
					ZA1->( dbSeek( xFilial( "ZA1" ) + cCodSol ) )
					While ZA1->( !EOF() ) .And. xFilial( "ZA1" ) == ZA1->ZA1_FILIAL .And. cCodSol == ZA1->ZA1_COD
						RecLock( "ZA1", .F. )
						ZA1->ZA1_NUMSC	:= cNumSc
						ZA1->ZA1_STATUS	:= "4"
						ZA1->( MsUnlock() )
					ZA1->( dbSkip() )
					End		
					
					//U_CCOME02()
						
					msginfo("Solicitação de compras gerado com sucesso.")	
				ELSE
					ROLLBACKSX8()
					MostraErro() 													
				ENDIF										
			ENDIF 			
		ENDIF			
	Endif		
		
Endif
	
RETURN   
/*------------------------------------------------------------------------
*
* C2A02LEG()
* Exibe legenda
*
------------------------------------------------------------------------*/                      
USER FUNCTION C2A02LEG()   
LOCAL aLegenda		:= {{"BR_AMARELO"		, "Em aprovação" 	},;
							{"BR_VERDE" 		, "Pendente" 		},;
							{"BR_CINZA" 		, "Reprovado" 	},;			
							{"BR_VERMELHO" 	, "Finalizado" 	}}	
						
BrwLegenda(cCadastro, "Legenda", aLegenda)
RETURN