#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOME16
Rotina de liberação de documentos especificos
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CCOME16(nOpc)


DO CASE 
	CASE nOpc == 2
		
		C2E16VIS()
		
	CASE nOpc == 3
	
		C2E16LIB()
	
	CASE nOpc == 4 
	
		C2E16EST()
		
ENDCASE	


RETURN
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E16VIS   ºAutor  ³CARLOS HENRIQUE     º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controle de visualização da tela de liberação de documentosº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C2E16VIS()

DO CASE                  
	// Tratamento para revisão de contratos
	CASE SCR->CR_TIPO == "RC"
		
		DBSELECTAREA("CN9")
		CN9->(DBSETORDER(1))
		IF CN9->(DBSEEK(XFILIAL("CN9")+TRIM(SCR->CR_NUM)))
			CN100Manut("CN9",CN9->(Recno()),2,.T.)
		ENDIF

	// Chama a rotina padrao
	OTHERWISE       
	         
		A097Visual()    
	
ENDCASE

RETURN 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E16LIB   ºAutor  ³CARLOS HENRIQUE     º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controle de liberação de documentos						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C2E16LIB()   
                         
DO CASE                  
	// Tratamento para revisão de contratos
	CASE SCR->CR_TIPO == "RC"
		
		C2E16PL(SCR->CR_TIPO)
		
	// Chama a rotina padrao
	OTHERWISE             
	   
		A097Libera("SCR",SCR->(RECNO()),2)    
	
ENDCASE

RETURN
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E16EST   ºAutor  ³CARLOS HENRIQUE     º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Controle de estorno da tela de liberação de documentos	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C2E16EST()

DO CASE                  
	// Tratamento para revisão de contratos
	CASE SCR->CR_TIPO == "RC"
	
		msginfo("Opção não disponivel para aprovação de revisão de contrato.")
		
	// Chama a rotina padrao
	OTHERWISE               
	 
		A097Estorna()
	
ENDCASE

RETURN   
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E16PL    ºAutor  ³CARLOS HENRIQUE     º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa liberação do documento	  						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C2E16PL(cTpDoc)
Local lContinua	:= .T.
Local aArea 		:= GetArea()
Local aRetSaldo 	:= {}
Local cObs 		:= IIF(!Empty(SCR->CR_OBS),SCR->CR_OBS,CriaVar("CR_OBS"))
Local ca097User 	:= RetCodUsr()
Local cTipoLim  	:= ""
Local CRoeda    	:= ""
Local cAprov    	:= ""
Local cName     	:= ""
Local cGrupo		:= ""
Local cCodLiber 	:= SCR->CR_APROV
Local cDocto    	:= SCR->CR_NUM
Local cTipo     	:= SCR->CR_TIPO
Local cFilDoc   	:= SCR->CR_FILIAL
Local dRefer 		:= dDataBase
Local cSCUser		:= ""
Local nReg 		:= SCR->(Recno())
Local lAprov    	:= .F.
Local lLiberou	:= .F.
Local lLibOk    	:= .F.
Local lContinua 	:= .T.
Local nSavOrd   	:= IndexOrd()
Local nSaldo    	:= 0
Local nOpc      	:= 0
Local nSalDif		:= 0
Local nTotal    	:= 0
Local nMoeda		:= 1
Local nX        	:= 1
Local oDlg      	:= NIL
Local oDataRef	:= NIL
Local oSaldo		:= NIL
Local oSalDif		:= NIL
Local oBtn1		:= NIL
Local oBtn2		:= NIL
Local oBtn3		:= NIL
Local oQual		:= NIL
Local aSize 		:= {0,0}
Local cTipoDesc 	:= ""

IF cTpDoc = "RC"
	cTipoDesc := "Rev. de contrato"
Endif

IF  !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#05"
	
	Aviso("Atencao!","Este documento ja foi liberado anteriormente. Somente os documentos que estao aguardando liberacao (destacado em vermelho no Browse) poderao ser liberados.",{"Voltar"},2)
	lContinua := .F.
	
ELSEIF lContinua .And. SCR->CR_STATUS$"01"
	
	Aviso("A097BLQ","Esta operação não poderá ser realizada pois este registro se encontra bloqueado pelo sistema (aguardando outros niveis)",{"Voltar"})
	lContinua := .F.
	
ENDIF

If lContinua
	
	DBSELECTAREA("SAL")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa as variaveis utilizadas no Display.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRetSaldo := MaSalAlc(cCodLiber,dRefer)
	nSaldo 	  := aRetSaldo[1]
	//		CRoeda 	  := A097Moeda(aRetSaldo[2])
	cName  	  := UsrRetName(ca097User)
	nTotal    := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
	
	Do Case
		Case SAK->AK_TIPO == "D"
			cTipoLim :=OemToAnsi("Diario") // "Diario"
		Case  SAK->AK_TIPO == "S"
			cTipoLim := OemToAnsi("Semanal") //"Semanal"
		Case  SAK->AK_TIPO == "M"
			cTipoLim := OemToAnsi("Mensal") //"Mensal"
		Case  SAK->AK_TIPO == "A"
			cTipoLim := OemToAnsi("Anual") //"Anual"
	EndCase
	
	Do Case
		Case cTpDoc == "RC"
		
			dbSelectArea("CN9")
			dbSetOrder(1)
			MsSeek(xFilial("CN9")+TRIM(SCR->CR_NUM))
			cGrupo := CN9->CN9_XGRPAP	
			
			dbSelectArea("SAL")
			dbSetOrder(3)
			MsSeek(xFilial("SAL")+CN9->CN9_XGRPAP+SAK->AK_COD)
			
			IF Eof()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido ³
				//| transferido por Ausência Temporária ou Transferência superior e o aprovador |
				//| de destino não fizer parte do Grupo de Aprovação.                           |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(SCR->(FieldPos("CR_USERORI")))
					dbSeek(xFilial("SAL")+CN9->CN9_XGRPAP+SCR->CR_APRORI)
				EndIf
			ENDIF
					
	EndCase
	
	If SAL->AL_LIBAPR != "A"
		lAprov := .T.
		cAprov := OemToAnsi("VISTO / LIVRE") // "VISTO / LIVRE"
	EndIf        
	
	nSalDif := nSaldo - IIF(lAprov,0,nTotal) 
	
	If (nSalDif) < 0
		Help(" ",1,"A097SALDO") //Aviso(STR0040,STR0041,{STR0037},2) //"Saldo Insuficiente"###"Saldo na data insuficiente para efetuar a liberacao do pedido. Verifique o saldo disponivel para aprovacao na data e o valor total do pedido."###"Voltar"
		lContinua := .F.
	EndIf
	
Endif  

IF lContinua
	aSize := {290,410}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada MT097DLG permite alterar o tamanho da tela.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DEFINE MSDIALOG oDlg FROM 0,0 TO aSize[1],aSize[2] TITLE "Liberacao  - "+cTipoDesc PIXEL
	@ 0.5,01 TO 44,204 LABEL "" OF oDlg PIXEL
	@ 45,01  TO 128,204 LABEL "" OF oDlg PIXEL
	@ 07,06  Say OemToAnsi(cTipoDesc+ " No.") OF oDlg PIXEL
	@ 07,125 Say OemToAnsi("Emissao ") OF oDlg SIZE 50,9 PIXEL
	If cTpDoc$"SC,SA"
		@ 19,06  Say OemToAnsi("Solicitante ") OF oDlg PIXEL
	Endif
	@ 28,06  Say OemToAnsi("Aprovador ") OF oDlg PIXEL SIZE 30,9
	@ 28,125 Say OemToAnsi("Data de ref.  ") SIZE 60,9 OF oDlg PIXEL
	@ 53,06  Say OemToAnsi("Limite min.  ") +CRoeda OF oDlg PIXEL
	@ 53,113 Say OemToAnsi("Limite max. ")+CRoeda SIZE 60,9 OF oDlg PIXEL
	@ 65,06  Say OemToAnsi("Limite  ")+CRoeda  OF oDlg PIXEL
	@ 65,113 Say OemToAnsi("Tipo lim.") OF oDlg PIXEL
	@ 77,06  Say OemToAnsi("Saldo na data  ")+CRoeda OF oDlg PIXEL
	If lAprov .Or. SCR->CR_MOEDA == aRetSaldo[2]
		@ 89,06 Say OemToAnsi("Total do documento ")+CRoeda OF oDlg PIXEL
	Else
		@ 89,06 Say OemToAnsi("Total do documento, convertido em ")+CRoeda OF oDlg PIXEL
	EndIf
	@ 101,06 Say OemToAnsi("Saldo disponivel apos liberacao  ") +CRoeda SIZE 130,10 OF oDlg PIXEL
	@ 113,06 Say OemToAnsi("Observa‡äes ") SIZE 100,10 OF oDlg PIXEL
	@ 07,58  MSGET SCR->CR_NUM     When .F. SIZE 60 ,9 OF oDlg PIXEL

	
	@ 07,155 MSGET SCR->CR_EMISSAO When .F. SIZE 45 ,9 OF oDlg PIXEL
	
	IF cTpDoc $ "RC"   
		PswOrder(2)
		IF PswSeek(TRIM(CN9->CN9_XUSRRE))
			@ 19,45  MSGET PswRet(1)[1][2]  When .F. SIZE 155,9 OF oDlg PIXEL		
		ENDIF		
	ENDIF
	
	@ 28,45  MSGET cName           When .F. SIZE 50 ,9 OF oDlg PIXEL
	@ 28,155 MSGET oDataRef VAR dRefer When .F. SIZE 45 ,9 OF oDlg PIXEL
	@ 53,42  MSGET SAK->AK_LIMMIN Picture PesqPict('SAK','AK_LIMMIN')When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
	@ 53,141 MSGET SAK->AK_LIMMAX Picture PesqPict('SAK','AK_LIMMAX')When .F. SIZE 59,1 OF oDlg PIXEL RIGHT
	@ 65,42  MSGET SAK->AK_LIMITE Picture PesqPict('SAK','AK_LIMITE')When .F. SIZE 60,9 OF oDlg PIXEL RIGHT
	@ 65,141 MSGET cTipoLim When .F. SIZE 59,9 OF oDlg PIXEL CENTERED
	@ 77,115 MSGET oSaldo VAR nSaldo Picture "@E 999,999,999,999.99" When .F. SIZE 85,14 OF oDlg PIXEL RIGHT
	If lAprov
		@ 89,115 MSGET cAprov Picture "@!" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	Else
		@ 89,115 MSGET nTotal Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	EndIf
	@ 101,115 MSGET oSaldif VAR nSalDif Picture "@E 999,999,999,999.99" When .F. SIZE 85,9 OF oDlg PIXEL RIGHT
	@ 113,115 MSGET cObs Picture "@!" SIZE 85,9 OF oDlg PIXEL
	
	@ 132, 80 BUTTON OemToAnsi("Libera Docto") SIZE 40 ,11  FONT oDlg:oFont ACTION If(A097ValObs(cObs),(nOpc:=2,oDlg:End()),Nil)  OF oDlg PIXEL
	@ 132,121 BUTTON OemToAnsi("Cancelar") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=1,oDlg:End())  OF oDlg PIXEL
	@ 132,162 BUTTON OemToAnsi("Bloqueia Docto") SIZE 40 ,11  FONT oDlg:oFont ACTION (nOpc:=3,oDlg:End())  OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	IF nOpc == 2 .Or. nOpc == 3
	
		SCR->(dbClearFilter())
		SCR->(dbGoTo(nReg))
		
		If cTpDoc = "RC"
			lLibOk := C2E16LCK(cTpDoc,TRIM(SCR->CR_NUM))
		EndIf
		
		If lLibOk
			
			BEGIN TRANSACTION
				lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cCodLiber,,cGrupo,,,,,cObs},dRefer,If(nOpc==2,4,6))
				
				IF lLiberou .and. nOpc == 2
					
					IF cTpDoc = "RC"
						U_CGCTE01(1,Alltrim(SCR->CR_NUM))
						U_Gct02Prc(3,cFilAnt,Alltrim(SCR->CR_NUM),CN9->CN9_XUSRRE,,,2,SCR->CR_OBS)
				    Endif
				
				ELSE
					
					IF cTpDoc = "RC" .and. nOpc == 3	    
						U_CGCTE01(2,Alltrim(SCR->CR_NUM))
						U_Gct02Prc(3,cFilAnt,Alltrim(SCR->CR_NUM),CN9->CN9_XUSRRE,,,1,SCR->CR_OBS)					
					ENDIF
					
				ENDIF
			
			END TRANSACTION
			
		ELSE
			HELP(" ",1,"A097LOCK")
		ENDIF
	ENDIF    
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	
	SCR->(Eval(bFilSCRBrw))
	
ENDIF     

RestArea(aArea)
Return .F.
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2E16LCK   ºAutor  ³CARLOS HENRIQUE     º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o registro esta com lock	 					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C2E16LCK(cTpDoc,cNumDoc)
LOCAL aArea    := {}
LOCAL lRet     := .F.   

IF cTpDoc == "RC"

	aArea := CN9->(GETAREA())			
	
	DBSELECTAREA("CN9")
	DBSETORDER(1)
	DBSEEK(xFilial("CN9")+Alltrim(cNumDoc))  
 	WHILE CN9->(!Eof()) .And. CN9->(CN9_FILIAL+CN9_NUMERO+CN9_REVISA) == xFilial("CN9")+ALLTRIM(cNumDoc)   
		IF RECLOCK("CN9")
			lRet := .T.
		ELSE
			lRet := .F.
			EXIT
		ENDIF  
  	CN9->(DBSKIP())  
  	ENDDO	
	
ENDIF

RESTAREA(aArea)
RETURN lRet
