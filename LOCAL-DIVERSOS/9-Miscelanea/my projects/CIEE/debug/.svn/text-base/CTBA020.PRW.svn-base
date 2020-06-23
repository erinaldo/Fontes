#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWADAPTEREAI.CH"
#INCLUDE "CTBA020.CH"

Static lCTB020AUT := .F.
Static lDefTopCtb := IfDefTopCTB()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTBA020  ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 29/10/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastramento de Contas Contabeis - SIGACTB                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBA020()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
Function CTBA020(aRotAuto,nOpcAuto,aRotItem)

Local nOrdemSX3
Local nRecnoSX3

Local aCores := {	{ "CT1_BLOQ == '1'" , "BR_VERMELHO"	},; // Conta Bloqueada
					{ "CT1_BLOQ == '2' .AND. ( ( Empty( CT1_DTEXIS ) .Or. CT1_DTEXIS <= dDatabase ) .AND. ( Empty( CT1_DTEXSF ) .Or. CT1_DTEXSF >= dDatabase ) ) .AND. ( ( Empty( CT1_DTBLIN ) .OR. CT1_DTBLIN >= dDatabase ) .Or. ( Empty( CT1_DTBLFI ) .Or. CT1_DTBLFI <= dDatabase ) )" , "BR_VERDE"   	},; // Sem Restrição
					{ "CT1_BLOQ == '2' .AND. ( ! Empty( CT1_DTEXIS ) .AND. CT1_DTEXIS >= dDatabase )" , "BR_AMARELO"	},; // Exercicio Não Iniciado
					{ "CT1_BLOQ == '2' .AND. ( ! Empty( CT1_DTEXSF ) .AND. CT1_DTEXSF <= dDatabase )" , "BR_CINZA"		},; // Exercicio Finalizado
					{ "CT1_BLOQ == '2' .AND. ( ( ! Empty( CT1_DTBLIN ) .AND. CT1_DTBLIN <= dDatabase ) .OR. ( ! Empty( CT1_DTBLFI ) .Or. CT1_DTBLFI >= dDatabase ) )" , "BR_LARANJA"}} // Bloqueado no periodo

PRIVATE aRotina   := MenuDef()
PRIVATE cCadastro := OemToAnsi(STR0006)  //"Plano de Contas"
PRIVATE cCvdCodPla:= ""
PRIVATE lExstCdPla:= .F.

DEFAULT aRotAuto := {}
DEFAULT aRotItem := {}
DEFAULT nOpcAuto := 3
SetFunName('CTBA020')
// Verificar existencia do campo "CVD_CODPLA"
SX3->(DbSetOrder(2))
If SX3->(DbSeek("CVD_CODPLA"))
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
		lExstCdPla := .T.
	ENDIF
Else
	cCvdCodPla:= "*" //Para não proibir alteração do campo
EndIf
SX3->(DbSetOrder(1))
CT020hlp()
Ct020AjSXB()
Ct020AjSX3()

If Len(aRotAuto) > 0
	lCTB020AUT := .T.
Else
	SetKey(VK_F12,{|a,b|AcessaPerg("CTB020",.T.)})
EndIf
             
Pergunte("CTB020",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						³
//³ mv_par01		// Gera Cod. Reduz.? Autom/Formula/Digit 	³
//³ mv_par02		// Formula Cod Reduzido   				 	³
//³ mv_par03		// Gera Cta Sup? Autom/Formula/Digit	  	³
//³ mv_par04		// Formula Cta Sup							³
//³ mv_par05		// Cta Variacao Monetaria					³
//³ mv_par06		// Cta Redutora da Variacao				  	³
//³ mv_par07		// Conta de Lucros e Perdas				  	³
//³ mv_par08		// Conta Ponte de Lucros e Perdas		  	³
//³ mv_par09		// Cadastro em arvore (Nao/Sim/Perguntar) 	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                      

// Alteração no campo X3_RESERV referente ao campo CT1_BOOK  e CT1_TRNSEF da tabela SX3, para permitir que 
// atraves do configurador, o usuario consiga alterar o tamanho do campo CT1_BOOK da tabela CT1

dbSelectArea("SX3")
nOrdemSX3 := IndexOrd()           
nRecnoSX3 := Recno()
DbSetOrder(2)
DbSeek("CT1_BOOK")
If !Eof()                               
	If X3_RESERV <> ( Chr(150) + Chr(192) ) 
		If RecLock( "SX3", .F. )		
    		X3_RESERV := Chr(150) + Chr(192)
			MsUnlock()
		EndIf
	EndIf
EndIf
dbSetOrder(nOrdemSX3)
DbGoto(nRecnoSX3)

dbSelectArea("SX3")
nOrdemSX3 := IndexOrd()           
nRecnoSX3 := Recno()
DbSetOrder(2)
DbSeek("CT1_TRNSEF")
If !Eof()                               
	If X3_RESERV <> ( Chr(150) + Chr(192) ) 
		If RecLock( "SX3", .F. )		
    		X3_RESERV := Chr(150) + Chr(192)
			MsUnlock()
		EndIf
	EndIf
EndIf

dbSelectArea("SX3")
DbSetOrder(2)
DbSeek("CT1_CTLALU")
If !Eof()                               
	If X3_RESERV <> ( Chr(150) + Chr(192) ) 
		If RecLock( "SX3", .F. )		
    		X3_RESERV := Chr(150) + Chr(192)
			MsUnlock()
		EndIf
	EndIf
EndIf


dbSetOrder(nOrdemSX3)
DbGoto(nRecnoSX3)

dbSelectArea("CT1")
If FieldPos("CT1_TPLALU") > 0 .AND. ExistBlock("CT998X5LL")
	CT998x5LL()
Endif

If lCTB020Aut
	PRIVATE aAutoCab   := Aclone(aRotAuto)
	PRIVATE aAutoItens := aRotItem
	MBrowseAuto(nOpcAuto,aAutoCab,"CT1")
Else  
	If mv_par09 == 2
		CtbaTree("CT1")
		SET KEY VK_F12 to
		Return	
	ElseIf mv_par09 == 3
		If MsgYesNo(STR0010)
			CtbaTree("CT1")
			SET KEY VK_F12 to
			Return
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a funcao de BROWSE                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"CT1",,,,,,aCores)
	dbSetOrder(1)
	SET KEY VK_F12 to
EndIf

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ctba020del³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 04/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de exclusao de Contas                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctba020del(cAlias,nReg,nOpc)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³GENERICO                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function ctba020Del(cAlias,nReg,nOpc)

Local lRet		:= .T.
Local cCtaSup
Local oDlg
LOCAL nOpcA 	:= 0
Local nOrder 	:= IndexOrd()
Local lCtb020Vld := ExistBlock("CTB020VLD")
Local i
Local aSize     := {}
Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aRegNo    := {}
Local nUsado    := 0
Local nX        := 0   

Local aButtons  := {}
Local lCT020But	:= ExistBlock("CT020BUT")     
Local lCT20ExcA := ExistBlock("CT20EXCA")   //P.E. executado antes da exclusao da conta  
Local lCT20ExcD := ExistBlock("CT20EXCD")  // P.E. executado depois da exclusao da conta  
Local lCT020Exc := ExistBlock("CT020EXC")
Local lPcoSync  := .F. //Verifico se a integracao do PCO esta ativada e se esta sincronizado com o CTB
Local lPcoExcl  := .T.

Private aHeader := {}
Private aCols   := {}
Private aTELA[0][0]
Private aGETS[0]

dbSelectArea(cAlias)
dbSetOrder(1)

If !SoftLock(cAlias)
	Return
EndIf    
               
If lCT20ExcA
	ExecBlock("CT20EXCA",.F.,.F.)
Endif

//Fará a verificação somente para topconect
#IFDEF TOP
	lPcoSync  := GetMV("MV_PCOINTE") == "1" .And. GetMV("MV_PCOSINC") == "2" //Verifico se a integracao do PCO esta ativada e se esta sincronizado com o CTB
#ENDIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os dados da Enchoice                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "CT1", .F., .T. )                                             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aheader                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AliasInDic("CVD") 
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("CVD")
	While !Eof() .And. SX3->X3_ARQUIVO=="CVD"
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE ,;
				SX3->X3_TAMANHO ,;
				SX3->X3_DECIMAL ,;
				SX3->X3_VALID	,;
				SX3->X3_USADO	,;
				SX3->X3_TIPO	,;
				SX3->X3_ARQUIVO ,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do acols                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CVD")
	dbSetOrder(1)
	MsSeek(xFilial("CVD")+M->CT1_CONTA)
	While !Eof() .And. xFilial("CVD") == CVD->CVD_FILIAL .And. M->CT1_CONTA == CVD->CVD_CONTA
		aadd(aCOLS,Array(nUsado+1))
		For nX := 1 To nUsado
			If aHeader[nX][10]=="V"
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
			Else
				aCols[Len(aCols)][nX] := CVD->(FieldGet(FieldPos(aHeader[nX][2])))
			EndIf
		Next nX
		aCOLS[Len(aCols)][nUsado+1] := .F.
		aadd(aRegNo,CVD->(RecNo()))
		dbSelectArea("CVD")
		dbSkip()
	EndDo
	If Empty(aCols)
		aadd(aCOLS,Array(nUsado+1))
		For nX := 1 To nUsado
			aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
		Next nX
		aCOLS[Len(aCols)][nUsado+1] := .F.
	EndIf
EndIf
If lCtb020Vld
	If !ExecBlock("CTB020VLD", .F., .F.,nOpc)
		Return
    EndIf
EndIf
             
If lCT020BUT
	aButtons := ExecBlock("CT020BUT",.F.,.F.,aButtons)
Endif

If !lCTB020AUT		// SE FOR ROTINA AUTOMATICA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo do tamanho dos objetos                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	If !(cPaisLoc $ "DOM|MEX") .And. AliasInDic("CVD") 
		AAdd( aObjects, { 100, 060, .t., .f. } )	
	EndIf
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }                                        
	aPosObj := MsObjSize( aInfo, aObjects )

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	EnChoice( "CT1", nReg, nOpc, , , , , aPosObj[1],NaoAltera(cAlias,{"CT1_DC"}),3)
	If !(cPaisLoc $ "DOM|MEX") .And. AliasInDic("CVD") 
		oGetD:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"Ctba020LOk","Ctba020TOk","",.T.,,1,,999,"Ctba020FOk")
	EndIf
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 2,Ctba020TOk(),oDlg:End()}, {|| nOpca := 1,oDlg:End()},,aButtons)
Else
	nOpcA := 2
EndIf

If nOpcA == 2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Saldo da Conta permite a     ³
	//³ delecao da mesma.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	lRet	:= CtbValDel("CT1",{{"CT7",3,CT1->CT1_CONTA+'1'}})	//Saldo Aberto
	                                                                
	If lRet
		lRet	:= CtbValDel("CT1",{{"CT7",3,CT1->CT1_CONTA+'2'}})		//Saldo Fechado
	EndIf
         
	If lRet
		lRet	:= CtbValDel("CT1",{{"CT7",3,CT1->CT1_CONTA+'4'}})		//Saldo Bloqueado
	EndIf
	
	If !lRet .and. !lCTB020AUT
		Help(" ",1,"CTAMOVIM")
	EndIf
	            
	MsGoTo( nReg ) 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe sint‚tica em nivel superior       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF lRet
		IF CT1->CT1_CLASSE == "1"				// Sintetica
			cCtaSup := CT1->CT1_CONTA
			dbSkip( )       
			IF !Eof() .and. CT1->CT1_FILIAL == xFilial("CT1") .And. ALLTRIM(CT1->CT1_CTASUP) == ALLTRIM(cCtaSup)
				If !lCTB020AUT
					Help(" ",1,"020SUPERIO" )
				EndIf
				lRet:=.F.
			EndIf
			DbGoTo( nReg )
		EndIf
	EndIf

	If lRet .And. lCT020Exc
	   lRet:= ExecBlock("CT020EXC",.F.,.F.,nOpc)
	Endif

	If lPcoSync
		lPcoExcl := PCOA010ELK()
	EndIf

	IF lRet .And. lPcoExcl 

		BEGIN TRANSACTION
		
			If ExistBlock("CTBA20CT")
				ExecBlock("CTBA20CT",.F.,.F.,nOpc)
			Endif
       
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Apaga Conta no Arquivo de Saldos					      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CT7")
			DbSetOrder(2)
			dbSeek(xFilial("CT7")+CT1->CT1_CONTA)
			While CT7_CONTA == CT1->CT1_CONTA .and. !eof()
				Reclock("CT7",.F.,.T.)
				dbDelete()
				MsUnLock()
				dbSkip()
			EndDo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Apaga Conta no Arquivo de Cadastro						   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( cAlias )
			MsGoTo( nReg )
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica a integração com o SIGAPCO                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SuperGetMV("MV_PCOINTE",.T.,"2")=="1"
				If PCOVLDSINC("CT1",CT1->CT1_CONTA)
					PcoSincCO("CT1",3)
				Else
					DisarmTransaction()
					MsUnlockAll()
					dbSelectArea(cAlias)
					dbSetOrder(nOrder)
					dbGoTo(nReg)
					Return				
				EndIf
			EndIf
			
			PlnCtaGrv(3,aRegNo) 
			
			If lCT20ExcD
				ExecBlock("CT20EXCD",.F.,.F.)
			Endif  
			
		END TRANSACTION

		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Integracao SIGAOMS X SIGAGFE	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If FindFunction("MaEnvEAI")
			MaEnvEAI(/*EMPRESA*/,/*FILIAL*/,nOpc,"CTBA020",{ { "CT1", "CTBA020_CT1", NIL, NIL, NIL, NIL } } )                   
		EndIf	

	EndIf
EndIf
      
MsUnlockAll()

dbSelectArea(cAlias)
dbSetOrder(nOrder)
dbGoTo(nReg)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb020Prox³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 04/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Devolve o proximo numero do codigo reduzido                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb020Prox()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Valida‡„o do SX3 do campo CT1_CLASSE                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION CTB020PROX()

Local aSaveAREA := GetArea()
Local aAmbCT1  	:= { CT1->(Indexord()), CT1->(Recno()) }
Local nEndereco , lRet := .T.
Local nEnd1 , nEnd2
Local nTamanho 	:= len(M->CT1_RES)
Local cMemMvs 	:= Sv020Mem()		// Funcao que salva os mv_par??
Local cRes		:= ' '
Local cQuery	:= ""
Local cAliasCT1 := "CT1"

If lDefTopCTB == Nil
	lDefTopCTB := IfDefTopCTB()
Endif

If ALTERA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se estiver alterando, nao deixa alterar Classe da Conta ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If M->CT1_CLASSE != CT1->CT1_CLASSE
		Help(" ",1,"NALTCLASSE")
		Return .F.
	Endif
Endif

IF M->CT1_CLASSE == "2"						// Analitica
	Pergunte("CTB020",.F.)
	If Empty(M->CT1_RES)
		If mv_par01 != 3					// Automatico / Formula

			If mv_par01 == 1				// Automatico -> Formula Siga
				If lDefTopCTB
					cQuery := "SELECT MAX(CT1.CT1_RES) CT1RES "
					cQuery += "  FROM " + RetSqlName( "CT1" ) + " CT1 "
					cQuery += " WHERE CT1.CT1_FILIAL = '" + xFilial( "CT1" ) + "'"
					cQuery += "   AND CT1.D_E_L_E_T_ = ' '"
					
					cQuery := ChangeQuery( cQuery )
					
					// gera um novo alias
					cAliasCT1 := GetNextAlias()
					
					dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasCT1 )
		
					If Select( cAliasCT1 ) > 0
						cRes := ( cAliasCT1 )->CT1RES
					Endif
					
					(cAliasCT1)->( dbCloseArea() )
					dbSelectArea("CT1")
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona no ultimo codigo reduzido da filial atual     ³
					//³ para calcular o pr¢ximo c¢digo reduzido.                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("CT1")
					dbSetOrder(2)
					DbSeek(StrZero(Int(Val(xFilial()))+1,2),.T.)  
					dbSkip(-1)

					cRes := CT1->CT1_RES
					
					DbSetOrder(aAmbCT1[1])
					DbGoto(aAmbCT1[2])			
				EndIf

				If Empty( Alltrim( cRes ) )
					M->CT1_RES	:= StrZero(Val(Soma1(cRes)),nTamanho)
				Else
					M->CT1_RES	:= Soma1(cRes)
				EndIf
			ElseIf mv_par01 == 2			// Formula    -> Do Usuario
				If !Empty(mv_par02)
					M->CT1_RES	:= &(mv_par02)
				EndIf
			EndIf

		EndIf                                      				
	Endif
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso a conta seja sint‚tica, limpa c¢digo reduzido.     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	M->CT1_RES:=Space(nTamanho)	
EndIF

If (nEndereco := Ascan(aGets,{ |x| Subs(x,9,7) == "CT1_RES" } )) > 0
	nEnd1 := Val(Subs(aGets[nEndereco],1,2))
	nEnd2 := Val(Subs(aGets[nEndereco],3,1))*2
	aTela[nEnd1][nEnd2] := M->CT1_RES
	lRefresh := .T.
EndIf

Sv020Mem(cMemMvs)

RestArea(aSaveAREA)

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb020NoRe³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 04/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Verifica se o codigo reduzido foi preenchido com Analiticas!³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTB020NoRe()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T./.F.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Valida‡„o no SX3 do campo CT1_RES (Cod. Reduzido)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION CTB020NoRe()

Local lRet := .T.

If M->CT1_CLASSE == "2"						// Analitica
	If Empty(M->CT1_RES)
		Help(" ",1,"CA020NORES")
		lRet:=.F.
	EndIf
Else
	IF !empty(M->CT1_RES)
		Help(" ",1,"CA020SINT")
		lRet:=.F.
	EndIf
Endif

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctb020DC  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 04.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se usuario tentou mudar digito na Enchoice        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb020DC()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T./.F.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FuncTion Ctb020DC()
Local lRet:=.T.
IF M->CT1_DC != CT1->CT1_DC
	Help(" ",1,"ALT-DIGIT")
	lRet:=.F.
EndIf
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctb020cust³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 04/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preenche CT1_CC de acordo com o numero de bytes para C Custo³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb020cust()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T./.F.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO			                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb020Cust()
Local lRet := .T.
If M->CT1_NCUSTO >= Len(alltrim(M->CT1_CONTA))
	Help(" ",1,"DIGCCINVAL")
	lRet := .F.
Else
	M->CT1_CC := If(M->CT1_NCUSTO > 0 ,;
			Right(Alltrim(M->CT1_CONTA),M->CT1_NCUSTO),"")
	lRefresh:=.T.
Endif
Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Ctb020Sup ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 08/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera o c¢digo da conta superior a partir da conta atual.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctb020Sup(cCodigo)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Valida‡„o do SX3 do Campo CT1_Conta                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo da Conta                   				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb020Sup(cCodigo)
Local nEndereco
Local nEnd1,nEnd2
Local cMemMvs := Sv020Mem()		// Funcao que salva os mv_par??

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada a funcao que gera o cta superior             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("CTB020",.F.)

If mv_par03 != 3					// Automatico / Formula
	If mv_par03 == 1				// Automatico -> Formula Siga
		M->CT1_CTASUP	:= CtbCtaSup(cCodigo)
	ElseIf mv_par03 == 2			// Formula -> do usuario
		If !Empty(mv_par04)
			M->CT1_CTASUP:= &(mv_par04)
		EndIf
	EndIf
EndIf

If (nEndereco := Ascan(aGets,{ |x| Subs(x,9,10) == "CT1_CTASUP" } )) > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exibe na tela a Conta Superior Gerada                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nEnd1	:= Val(Subs(aGets[nEndereco],1,2))
	nEnd2	:= Val(Subs(aGets[nEndereco],3,1))*2
	aTela[nEnd1][nEnd2] := M->ct1_ctasup
	lRefresh := .T.
EndIf

Sv020Mem(cMemMvs)

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb020Dig ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 04.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calcula d¡gito de controle da conta cont bil passada como  ³±±
±±³          ³ parƒmetro.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb020Dig(cCodigo)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Valida‡„o do SX3 do campo CT1_CONTA                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo da Conta                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FuncTion Ctb020Dig(cCodigo)
Local nEndereco
Local nEnd1,nEnd2
If (nEndereco := Ascan(aGets,{ |x| Subs(x,9,6) == "CT1_DC" } )) > 0
	M->CT1_DC:= CtbDigCont(cCodigo)
	nEnd1 	:= Val(Subs(aGets[nEndereco],1,2))
	nEnd2 	:= Val(Subs(aGets[nEndereco],3,1))*2
	aTela[nEnd1][nEnd2] := M->CT1_DC
	lRefresh := .T.
EndIf
Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTBA020Inc³ Autor ³ J£lio Wittwer         ³ Data ³ 14/12/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de inclus„o de Contas Cont beis                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctba020Inc(cAlias,nReg,nOpc)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA020                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do Arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION Ctba020Inc(cAlias,nReg,nOpc)

Local aTam		:= TamSX3("CTT_CUSTO")
Local nOpca 	:= 0
Local nCont		:= 0
Local nQuantas 	:= 0
Local lCtb020Vld := ExistBlock("CTB020VLD")
Local aSize     := {}
Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local oDlg
Local nUsado    := 0
Local nX        := 0
Local cGetD     := ".T."
Local l020VlGrv	:= ExistBlock("CTB020VG")  
Local aButtons	:= {}
Local lCT020BUT := ExistBlock("CT020BUT")  
Local lCT20GRA  := ExistBlock("CT20GRA") // P.E. executado antes da inclusao da conta  
Local lCT20GRD  := ExistBlock("CT20GRD") // P.E. executado depois da inclusao da conta   
Private aHeader := {}
Private aCols   := {}
Private aTELA[0][0]
Private aGETS[0]

//*****************************
// P.E. validação da gravação *
//*****************************
If l020VlGrv

	cGetD	:= "ExecBlock('CTB020VG',.F.,.F.,{3})"

EndIf           

If lCT20GRA
	ExecBlock("CT20GRA",.F.,.F.)
Endif

nQuantas := CtbMoedas()
cSuf	 := ""

Pergunte("CTB020",.F.)

If lCtb020Vld
	If !ExecBlock("CTB020VLD", .F., .F.,nOpc)
		Return
    EndIf
EndIf  
       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os dados da Enchoice                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "CT1", .T., .T. )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aheader                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AliasInDic("CVD") 
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("CVD")
	While !Eof() .And. SX3->X3_ARQUIVO=="CVD"
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE ,;
				SX3->X3_TAMANHO ,;
				SX3->X3_DECIMAL ,;
				SX3->X3_VALID	,;
				SX3->X3_USADO	,;
				SX3->X3_TIPO	,;
				SX3->X3_ARQUIVO ,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do acols                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aCOLS,Array(nUsado+1))
	For nX := 1 To nUsado
		aCols[1][nX] := CriaVar(aHeader[nX][2])
	Next nX
	aCOLS[1][nUsado+1] := .F.
EndIf      

If lCT020BUT
	aButtons := ExecBlock("CT020BUT",.F.,.F.,aButtons)
Endif

If !lCTB020AUT		// SE FOR ROTINA AUTOMATICA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo do tamanho dos objetos                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	If !(cPaisLoc $ "DOM|MEX") .And. AliasInDic("CVD") 
		AAdd( aObjects, { 100, 060, .t., .f. } )	
	EndIf
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	EnChoice( "CT1", nReg, nOpc, , , , , aPosObj[1],NaoAltera(cAlias,{"CT1_DC"}),3)
	If !(cPaisLoc $ "DOM|MEX") .And. AliasInDic("CVD") 
		oGetD:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"Ctba020LOk","Ctba020TOk","",.T.,,1,,999,"Ctba020FOk")
		cGetD:= cGetD + " .and. oGetD:TudoOk()"
	EndIf
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(CTB020Val(),If( !Ctb020Vl() .Or. !Obrigatorio(aGets,aTela) .Or. !(&(cGetD)),nOpcA:=0,oDlg:End()),nOpcA:=0)},{||oDlg:End()},,aButtons)

Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas pela rotina de inclusao automatica     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCvdCodPla := IIf(Type("M->CVD_CODPLA") = "U","",M->CVD_CODPLA)
	If EnchAuto(cAlias,aAutoCab,{|| Obrigatorio(aGets,aTela)},aRotina[nOpc][4]) .and. MsGetDAuto(aAutoItens,"Ctba020LOk",{|| .T.},aAutoCab)
		nOpcA := 1
	EndIf
EndIf

If nOpcA == 1
	BEGIN TRANSACTION  

	
	PlnCtaGrv(1)
	If Empty(CT1->CT1_CTASUP) .and. !lCTB020AUT
		// Aviso de que a conta superior nao foi preenchida
		Help(" ",1,"NOCTASUP")
	EndiF

	Reclock("CT1")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Criterios de convers„o de moedas    ³
	//³ caso estejam em branco.                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCont := 2 To nQuantas
		cSuf := StrZero(nCont,2)
		IF Empty(CT1_CVD&cSuf)
			Replace CT1_CVD&cSuf With "D"
		EndIF
		IF Empty(CT1_CVC&cSuf)
			Replace CT1_CVC&cSuf With "D"
		EndIF
	Next nCont

	// Grava Campo de C.Custo Contabil
	If CT1_NCUSTO > 0
		Replace CT1_CC With RIGHT(ALLTRIM(CT1_CONTA),CT1_NCUSTO)
	Else
		Replace CT1_CC With Space(aTam[1])
	EndIF

	MsUnlock()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o plano de contas esta sincroni- ³
	//³ zado com o plano de contas orcamentario      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SuperGetMV("MV_PCOINTE",.T.,"2")=="1"
		PcoSincCO("CT1",1)
	EndIf
	If FindFunction( "GETROTINTEG" ).AND. !lCTB020AUT
		//Informado o quinto parâmetro "cFunName" para que o ResponseMessage retorne para o adapter correto,
		//no caso da integração ser chamada por outra rotina
		FwIntegDef( 'CTBA020', , , , 'CTBA020' )
	EndIf
	END TRANSACTION
	
	If ExistBlock("CTBA20CT")
		ExecBlock("CTBA20CT",.F.,.F.,nOpc)
	Endif
	
	If lCT20GRD
		ExecBlock("CT20GRD",.F.,.F.)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Integracao SIGAOMS X SIGAGFE	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  
	If FindFunction("MaEnvEAI")
		MaEnvEAI(/*EMPRESA*/,/*FILIAL*/,nOpc,"CTBA020",{ { "CT1", "CTBA020_CT1", NIL, NIL, NIL, NIL } } ) 
    Endif
EndIF 


Return
                        
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctba020Alt³ Autor ³ Julio Wittwer         ³ Data ³ 14.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de Alteracao de Contas Cont beis                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctba020alt(cAlias,nReg,nOpc)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA020                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do Arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION Ctba020Alt(cAlias,nReg,nOpc)
Local nOpcA := 0
Local lCtb020Vld := ExistBlock("CTB020VLD")
Local aSize     := {}
Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aRegNo    := {}
Local oDlg
Local nUsado    := 0
Local nX        := 0
Local cGetD     := ".T."
Local l020VlGrv	:= ExistBlock("CTB020VG")   
Local lCT020BUT := ExistBlock("CT020BUT")     
Local lCT20ALTA := ExistBlock("CT20ALTA") // P.E. executado antes da alteracao da conta    
Local lCT20ALTD := ExistBlock("CT20ALTD") // P.E. executado depois da alteracao da conta    
local aButtons  := {}

Private aHeader := {}
Private aCols   := {}
Private aTELA[0][0]
Private aGETS[0]

//*****************************
// P.E. validação da gravação *
//*****************************
If l020VlGrv

	cGetD	:= "ExecBlock('CTB020VG',.F.,.F.,{4})"

EndIf      

If lCT20ALTA
	ExecBlock("CT20ALTA",.F.,.F.)
Endif

dbSelectArea(cAlias)
dbSetOrder(1)
If !SoftLock(cAlias)
	Return
EndIf
If lCtb020Vld
	If !ExecBlock("CTB020VLD", .F., .F.,nOpc)
		Return
    EndIf
EndIf         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os dados da Enchoice                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "CT1", .F., .T. )
If AliasInDic("CVD") 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aheader                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("CVD")
	While !Eof() .And. SX3->X3_ARQUIVO=="CVD"
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE ,;
				SX3->X3_TAMANHO ,;
				SX3->X3_DECIMAL ,;
				SX3->X3_VALID	,;
				SX3->X3_USADO	,;
				SX3->X3_TIPO	,;
				SX3->X3_ARQUIVO ,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do acols                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CVD")
	dbSetOrder(1)
	MsSeek(xFilial("CVD")+M->CT1_CONTA)
	While !Eof() .And. xFilial("CVD") == CVD->CVD_FILIAL .And. M->CT1_CONTA == CVD->CVD_CONTA
		aadd(aCOLS,Array(nUsado+1))
		For nX := 1 To nUsado
			If aHeader[nX][10]=="V"
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
			Else
				aCols[Len(aCols)][nX] := CVD->(FieldGet(FieldPos(aHeader[nX][2])))
			EndIf
		Next nX
		aCOLS[Len(aCols)][nUsado+1] := .F.
		aadd(aRegNo,CVD->(RecNo()))
		dbSelectArea("CVD")
		dbSkip()
	EndDo
	If Empty(aCols)
		aadd(aCOLS,Array(nUsado+1))
		For nX := 1 To nUsado
			aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
		Next nX
		aCOLS[Len(aCols)][nUsado+1] := .F.
	EndIf
EndIf 

If lCT020BUT
	aButtons := ExecBlock("CT020BUT",.F.,.F.,aButtons)
Endif

If !lCTB020AUT		// SE FOR ROTINA AUTOMATICA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo do tamanho dos objetos                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	If !(cPaisLoc $ "DOM|MEX") .And. AliasInDic("CVD") 
		AAdd( aObjects, { 100, 060, .t., .f. } )	
	EndIf
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	EnChoice( "CT1", nReg, nOpc, , , , , aPosObj[1],NaoAltera(cAlias,{"CT1_DC"}),3)
	If !(cPaisLoc $ "DOM|MEX") .And. AliasInDic("CVD") 
		oGetD:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"Ctba020LOk","Ctba020TOk","",.T.,,1,,999,"Ctba020FOk")
		cGetD:= cGetD + " .and. oGetD:TudoOk()"
	EndIf
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(CTB020Val(),If(!Obrigatorio(aGets,aTela) .Or. !(&(cGetD)),nOpcA:=0,oDlg:End()),nOpcA:=0)},{||oDlg:End()},,aButtons)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas pela rotina de inclusao automatica     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If EnchAuto(cAlias,aAutoCab,{|| Obrigatorio(aGets,aTela)},aRotina[nOpc][4]) .and. MsGetDAuto(aAutoItens,"Ctba020LOk",{|| .T.},aAutoCab)
		nOpcA := 1
	EndIf
EndIf  

If nOpcA == 1
                
	BEGIN TRANSACTION
		PlnCtaGrv(2,aRegNo) 
	END TRANSACTION
	If Empty(CT1->CT1_CTASUP).and. !lCTB020AUT
		// Aviso de que a conta superior nao foi preenchida
		Help(" ",1,"NOCTASUP")
	EndiF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o plano de contas esta sincroni- ³
	//³ zado com o plano de contas orcamentario      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SuperGetMV("MV_PCOINTE",.T.,"2")=="1"
		PcoSincCO("CT1",2)
	EndIf


	Reclock("CT1")

	If ExistBlock("CTBA20CT")
		ExecBlock("CTBA20CT",.F.,.F.,nOpc)
	Endif

   	MsUnlock()  
   	
	If lCT20ALTD
		ExecBlock("CT20ALTD",.F.,.F.)
	Endif
   	If FindFunction( "GETROTINTEG" ).AND. !lCTB020AUT
		//Informado o quinto parâmetro "cFunName" para que o ResponseMessage retorne para o adapter correto,
		//no caso da integração ser chamada por outra rotina
		FwIntegDef( 'CTBA020', , , , 'CTBA020' )
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Integracao SIGAOMS X SIGAGFE	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 
	If FindFunction("MaEnvEAI")
		MaEnvEAI(/*EMPRESA*/,/*FILIAL*/,nOpc,"CTBA020",{ { "CT1", "CTBA020_CT1", NIL, NIL, NIL, NIL } } )   
	Endif
EndIF

MsUnlockAll()  

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ctba020Vis³ Autor ³ Eduardo Riera         ³ Data ³19.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de Visualizacao do Plano de Contas                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctba020Vis(cAlias,nReg,nOpc)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA020                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do Arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION Ctba020Vis(cAlias,nReg,nOpc)
Local nOpcA := 0
Local aSize     := {}
Local aObjects  := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aRegNo    := {}
Local oDlg
Local nUsado    := 0
Local nX        := 0
Local cGetD     := ".T."  
Local lCT020BUT := ExistBlock("CT020BUT")
Local aButtons  := {}
Private aHeader := {}
Private aCols   := {}
Private aTELA[0][0]
Private aGETS[0]

dbSelectArea(cAlias)
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os dados da Enchoice                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lCT020BUT
	aButtons := ExecBlock("CT020BUT",.F.,.F.,aButtons)
Endif
	
RegToMemory( "CT1", .F., .T. ) 
If AliasInDic("CVD") 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aheader                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("CVD")
	While !Eof() .And. SX3->X3_ARQUIVO=="CVD"
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE ,;
				SX3->X3_TAMANHO ,;
				SX3->X3_DECIMAL ,;
				SX3->X3_VALID	,;
				SX3->X3_USADO	,;
				SX3->X3_TIPO	,;
				SX3->X3_ARQUIVO ,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do acols                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CVD")
	dbSetOrder(1)
	MsSeek(xFilial("CVD")+M->CT1_CONTA)
	While !Eof() .And. xFilial("CVD") == CVD->CVD_FILIAL .And. M->CT1_CONTA == CVD->CVD_CONTA
		aadd(aCOLS,Array(nUsado+1))
		For nX := 1 To nUsado
			If aHeader[nX][10]=="V"
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
			Else
				aCols[Len(aCols)][nX] := CVD->(FieldGet(FieldPos(aHeader[nX][2])))
			EndIf
		Next nX
		aCOLS[Len(aCols)][nUsado+1] := .F.
		aadd(aRegNo,CVD->(RecNo()))
		dbSelectArea("CVD")
		dbSkip()
	EndDo
	If Empty(aCols)
		aadd(aCOLS,Array(nUsado+1))
		For nX := 1 To nUsado
			aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
		Next nX
		aCOLS[Len(aCols)][nUsado+1] := .F.
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo do tamanho dos objetos                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )

If !(cPaisLoc $ "DOM|MEX") .And. AliasInDic("CVD") 
	AAdd( aObjects, { 100, 060, .t., .f. } )
EndIf

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
EnChoice( "CT1", nReg, nOpc, , , , , aPosObj[1],NaoAltera(cAlias,{"CT1_DC"}),3)

If !(cPaisLoc $ "DOM|MEX") .And. AliasInDic("CVD") 
	oGetD:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"Ctba020LOk","Ctba020TOk","",.T.,,1,,999,"Ctba020FOk")
	cGetD:="oGetD:TudoOk()"
EndIf
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(.T.,If(!Obrigatorio(aGets,aTela) .Or. !(&(cGetD)),nOpcA:=0,oDlg:End()),nOpcA:=0)},{||oDlg:End()},,aButtons)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb020LP  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 04/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Sugere conta de Lucros e Perdas                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb020LP()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Valida‡„o do SX3 do campo CT1_CLASSE                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION CTB020LP()

Local aSaveAREA := GetArea()

LOCAL nEndereco , lRet := .T.
LOCAL nEnd1 , nEnd2
Local aTamConta	:= TamSX3("CT1_CONTA")
Local nTamanho 	:= aTamConta[1]
Local cMemMvs 	:= Sv020Mem()		// Funcao que salva os mv_par??

IF m->ct1_classe=="2"						// Analitica
	Pergunte("CTB020",.F.)
	If Empty(M->CT1_CTALP)
		M->CT1_CTALP := mv_par07			// Conta de Apuracao de Lucros e Perdas
	EndIf
	If Empty(M->CT1_CTAPON)	
		M->CT1_CTAPON:= mv_par08			// Conta Ponte de Apuracao de Lucros e Perdas
	Endif
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso a conta seja sint‚tica, limpa                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	M->CT1_CTALP	:= Space(nTamanho)	
	M->CT1_CTAPON 	:= Space(nTamanho)
EndIF

If (nEndereco := Ascan(aGets,{ |x| Subs(x,9,7) == "CT1_CTALP" } )) > 0
	nEnd1 := Val(Subs(aGets[nEndereco],1,2))
	nEnd2 := Val(Subs(aGets[nEndereco],3,1))*2
	aTela[nEnd1][nEnd2] := M->CT1_CTALP
	lRefresh := .T.
EndIf

If (nEndereco := Ascan(aGets,{ |x| Subs(x,9,7) == "CT1_CTAPON" } )) > 0
	nEnd1 := Val(Subs(aGets[nEndereco],1,2))
	nEnd2 := Val(Subs(aGets[nEndereco],3,1))*2
	aTela[nEnd1][nEnd2] := M->CT1_CTAPON
	lRefresh := .T.
EndIf

Sv020Mem(cMemMvs)

RestArea(aSaveAREA)

Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb020Var ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 04/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Sugere conta de Variacao Monetaria                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb020Var()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Valida‡„o do SX3 do campo CT1_CLASSE                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION CTB020Var()

Local aSaveAREA := GetArea()

LOCAL nEndereco , lRet := .T.
LOCAL nEnd1 , nEnd2
Local aTamConta	:= TamSX3("CT1_CONTA")
Local nTamanho 	:= aTamConta[1]
Local cMemMvs 	:= Sv020Mem()		// Funcao que salva os mv_par??

IF m->ct1_classe=="2"						// Analitica
	Pergunte("CTB020",.F.)
	If Empty(M->CT1_CTAVM)
		M->CT1_CTAVM := mv_par05			// Conta de Variacao Monetaria
	EndIf	
	If Empty(M->CT1_CTARED)
		M->CT1_CTARED:= mv_par06			// Conta Redutora da Variacao Monetaria
	Endif
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso a conta seja sint‚tica, limpa                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	M->CT1_CTAVM	:= Space(nTamanho)	
	M->CT1_CTARED 	:= Space(nTamanho)
EndIF

If (nEndereco := Ascan(aGets,{ |x| Subs(x,9,7) == "CT1_CTAVM" } )) > 0
	nEnd1 := Val(Subs(aGets[nEndereco],1,2))
	nEnd2 := Val(Subs(aGets[nEndereco],3,1))*2
	aTela[nEnd1][nEnd2] := M->CT1_CTAVM
	lRefresh := .T.
EndIf

If (nEndereco := Ascan(aGets,{ |x| Subs(x,9,7) == "CT1_CTARED" } )) > 0
	nEnd1 := Val(Subs(aGets[nEndereco],1,2))
	nEnd2 := Val(Subs(aGets[nEndereco],3,1))*2
	aTela[nEnd1][nEnd2] := M->CT1_CTARED
	lRefresh := .T.
EndIf

Sv020Mem(cMemMvs)

RestArea(aSaveAREA)

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Sv020Mem ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 12/11/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Salva as variaveis mv_par?? caso seja via chamada externa   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Sv020Mem(ParC1)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ParC1 = Nome do arquivo com as variaveis de memoria        ³±±
±±³          ³         Caso nao for passado indica a gravacao dos MV_PAR??³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Sv020Mem(cMemMvs)

If cMemMvs = Nil
//	If FunName() # "CTBA020"	// Somente se for Chamada externa

/*		Restore from AP6 Nao esta funcionando - Substituido ate ser corrigido

		cMemMvs := CriaTrab(, .F.) + ".Mem"
		SAVE ALL LIKE MV_PAR* TO (cMemMvs)	// Salvo e restauro caso seja chamado externamente
											// Via F3 - Tratamento deveria estar na chamada do F3
											// Pois pode ocorrer em outras situacoes, caso tipos
											// dos mv_par?? da rotina que chamou for diferente
		                                    // da existente do grupo CTB020
*/

		cMemMvs := { 	MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04, MV_PAR05,;
						MV_PAR06, MV_PAR07, MV_PAR08 }

//	Endif

// ElseIf File(cMemMvs)

ElseIf cMemMvs <> Nil

//	RESTORE From (cMemMvs) ADDITIVE
//	Ferase(cMemMvs)

	MV_PAR01 := cMemMvs[1]		// Restauro o conteudo anterior
	MV_PAR02 := cMemMvs[2]
	MV_PAR03 := cMemMvs[3]
	MV_PAR04 := cMemMvs[4]
	MV_PAR05 := cMemMvs[5]
	MV_PAR06 := cMemMvs[6]
	MV_PAR07 := cMemMvs[7]
	MV_PAR08 := cMemMvs[8]

Endif

Return cMemMvs     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ctb020Cta ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 27/06/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Validacao da Conta digitada -> SX3                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb020Cta()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctb020cta()

Local aSaveArea := GetArea()
Local lRet 		:= .T.

lRet := Iif((ExistChav("CT1",,1) .And. Ctb020Sup(m->ct1_conta) .And. ;
		Ctb020Dig(m->ct1_conta) .And. Ctb020Prox(.t.) .And.;
		FreeForUse("CT1",m->ct1_conta)),.T.,.F.)
		
RestArea(aSaveArea)                                                         
  
// Verifica se conta que esta sendo incluida consta no cache como conta invalida e atualiza o cache.
//
If FindFunction("AtuVldEnt")
	AtuVldEnt("CT1", M->CT1_CONTA)
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ct020AjSXB³ Autor ³ Simone Mie Sato       ³ Data ³ 03/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Apagar opcao de Cadastra Novo do SXB do Rateio On-line(CT9) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb020Cta()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ct020AjSXB()

Local aSaveArea	:= GetArea()

dbSelectArea("SXB")
dbSetOrder(1)
If MsSeek("CT9   "+"3"+"01"+"01",.F.)
	Reclock("SXB",.F.,.T.)
	dbDelete()
	MsUnlock()
EndIf
RestArea(aSaveArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³PlnCtaGrv ³ Autor ³ Eduardo Riera         ³ Data ³19.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de gravacao do plano de contas                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Sempre .T.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: 1 - Inclusao                                         ³±±
±±³          ³       2 - Alteracao                                        ³±±
±±³          ³       3 - Exclusao                                         ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function	PlnCtaGrv(nOpcA,aRegNo)

Local aArea    := GetArea("CT1")
Local nX       := 0
Local nY       := 0
Local nMaxFor  := Len(aCols)
Local nDeleted := Len(aHeader)+1
Local nPEnt    := aScan(aHeader,{|x| AllTrim(x[2])=="CVD_ENTREF"})
Local bCampo   := {|nCPO| Field(nCPO) }
Local lTravou  := .F.
Local nOpc      := 0  
Local aCposHistor := {}

DEFAULT aRegNo := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a operacao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcA <> 3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o cabecalho                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CT1")
	dbSetOrder(1)
	If MsSeek(xFilial("CT1")+M->CT1_CONTA)
		RecLock("CT1")
	Else
		RecLock("CT1",.T.)
	EndIf
	For nY := 1 To FCount()
		AADD(aCposHistor,{CT1->(FieldName(nY)),CT1->&(EVAL(bCampo,nY)),""})
	Next nY	
	
	For nY := 1 TO FCount()
		FieldPut(nY,M->&(EVAL(bCampo,nY)))
	Next nY
	CT1->CT1_FILIAL := xFilial("CT1")
	CT1->( FKCommit() ) 	



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava Histórico de Alterações na tabela CW4.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpc := If(nOpcA == 1,3,If(nOpcA==2,4,5))               
	If nOpc == 3
		CTBGrvHist(xFilial("CT1"),"CT1"		,CT1->CT1_CONTA,      ,ValType(CT1->CT1_CONTA),"CT1_CONTA",""       ,CT1->CT1_CONTA,nOpc)
		//		   cFilTabela	 ,cEntidade ,cCodigo       ,cGrupo,cTipoCampo             ,cCampo,cValorAnt,cValorNovo    ,nOpc)
	Else	  
		For nY := 1 To Len(aCposHistor)
			aCposHistor[nY][3] := CT1->&(EVAL(bCampo,nY))	  
			If aCposHistor[nY][2] <> aCposHistor[nY][3]
				CTBGrvHist(xFilial("CT1"),"CT1"     ,CT1->CT1_CONTA,      ,ValType(aCposHistor[nY][1]),aCposHistor[nY][1],aCposHistor[nY][2],aCposHistor[nY][3],nOpc)
				//           cFilTabela	 ,cEntidade ,cCodigo       ,cGrupo,cTipoCampo                 ,cCampo            ,cValorAnt         ,cValorNovo        ,nOpc)
        	EndIf
    	Next nY
    EndIf

	If AliasInDic("CVD") 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os itens                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 To nMaxFor // Exclui primeiro os registros deletados para nao violação de chave primaria 
			If ( aCols[nX][nDeleted] )     
				If ( Len(aRegNo) >= nX )
					dbSelectArea("CVD")
					MsGoto(aRegNo[nX])
					RecLock("CVD")
					dbDelete()
					MsUnLock()
				EndIf
			EndIf		
		Next nX			
		For nX := 1 To nMaxFor        
			If ( aCols[nX][nDeleted] )
				loop // Nao considerado os itens deletado pois ja foram excluidos da base no laco de cima 
			Endif
			If ( Len(aRegNo) >= nX )
				dbSelectArea("CVD")
				MsGoto(aRegNo[nX])
				RecLock("CVD")
				lTravou := .T.
			Else
				If ( !aCols[nX][nDeleted] .And. !Empty(aCols[nX][nPEnt]) )
					RecLock("CVD",.T.)
					lTravou := .T.
				Else
					lTravou := .F.
				EndIf
			EndIf
			If lTravou
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza os itens                                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nY := 1 to Len(aHeader)
					If aHeader[nY][10] <> "V"
						CVD->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
					EndIf
				Next nY
				CVD->CVD_FILIAL := xFilial("CVD")
				CVD->CVD_CONTA  := M->CT1_CONTA
			EndIf
		Next nX	
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exclucao dos itens                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AliasInDic("CVD") 
		For nX := 1 To nMaxFor
			If ( Len(aRegNo) >= nX )
				dbSelectArea("CVD")
				MsGoto(aRegNo[nX])
				RecLock("CVD")
				dbDelete()
				MsUnlock()
			EndIf
		Next nX
			
		CVD->( FKCommit() ) 
	EndIf
	dbSelectArea("CT1")
	dbSetOrder(1)
	If MsSeek(xFilial("CT1")+M->CT1_CONTA)
	
  		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui o Registro do De-Para                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		If FindFunction( "GETROTINTEG" ).AND. !lCTB020AUT
			//Informado o quinto parâmetro "cFunName" para que o ResponseMessage retorne para o adapter correto,
			//no caso da integração ser chamada por outra rotina
			FwIntegDef( 'CTBA020', , , , 'CTBA020' )
		EndIf
		
		RecLock("CT1")
		dbDelete()
		MsUnLock()
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava Histórico de Alterações na tabela CW4.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpc := If(nOpcA == 1,3,If(nOpcA==2,4,5))
	CTBGrvHist(xFilial("CT1"),"CT1"     ,CT1->CT1_CONTA,      ,ValType(CT1->CT1_CONTA),"CT1_CONTA",M->CT1_CONTA,""        ,nOpc)
	//		   cFilTabela	 ,cEntidade ,cCodigo       ,cGrupo,cTipoCampo             ,cCampo          ,cValorAnt   ,cValorNovo,nOpc)
	
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a integridade da rotina                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ctba020LOk³ Autor ³ Eduardo Riera         ³ Data ³19.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de validacao da linhaOk da Getdados                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Expl1: Indica se a linha é valida                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctba020LOk()

Local nX        :=  1
Local nUsado    := Len(aHeader)
Local nPEnt     := aScan(aHeader,{|x| AllTrim(x[2])=="CVD_ENTREF"})
Local nPPla     := aScan(aHeader,{|x| AllTrim(x[2])=="CVD_CODPLA"})
Local nPCta     := aScan(aHeader,{|x| AllTrim(x[2])=="CVD_CTAREF"})
Local nPCc      := aScan(aHeader,{|x| AllTrim(x[2])=="CVD_CUSTO" })
Local lRetorno  := .T.
Local lCT020LOK := ExistBlock("CT020LOK")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica os campo obrigatorios                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aCols) == 1   					// se tem soh uma linha criada da getdaos verifica se codigo plano referencial esta preenchido 
	If !aCols[1][nUsado+1] .And. Empty(aCols[1][nPEnt]) .And. IIf(lExstCdPla,Empty(aCols[1][nPPla]),.T.) .And. Empty(aCols[1][nPCta])
		aCols[1, nUsado+1 ] := .T.  		//caso nao esteja preenchido exclui a linha para nao validar obrigatoriedade do campo CVD_TPUTIL
	EndIf
EndIf
lRetorno := MaCheckCols(aHeader,aCols,N)
If !aCols[n][nUsado+1] .And. (!Empty(aCols[n][nPEnt]) .Or. IIf(lExstCdPla,!Empty(aCols[n][nPPla]),.F.) .Or. !Empty(aCols[n][nPCta]))
	If Empty(aCols[n][nPEnt]) .Or. IIf(lExstCdPla,Empty(aCols[n][nPPla]),.F.) .Or. Empty(aCols[n][nPCta])
		Help(" ",1,"HELP","OBRIGATORIO",STR0053+Chr(10)+Chr(13)+STR0054+IIf(lExstCdPla,STR0055,"")+STR0056,3,1)  //"Favor preencher todos os campos da grade abaixo:"##"'Entidade'"##", 'Plano Ref.'"##" e a 'Conta Ref' pois um ou mais deles está vazio."
		lRetorno := .F.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a duplicidade de registros                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetorno
	For nX := 1 To Len(aCols)
		If !aCols[nX][nUsado+1]  .And. !aCols[n][nUsado+1] 
			If nX <> N
				// Valida se existe outro plano, conta e centro de custo iguais
				If (aCols[n][nPEnt] == aCols[nX][nPEnt] .and. aCols[n][nPCta] == aCols[nX][nPCta] .and. aCols[n][nPCc] == aCols[nX][nPCc])
					Help(" ",1,"JAEXISTINF")
					lRetorno := .F.
				EndIf
			EndIf
		EndIf
	Next nX
EndIf

//Limpa variavel para nova linha ficar travada para consulta
//F3 antes de escolher o plano e a conta referencial
If lRetorno .And. lExstCdPla .And. !lCTB020AUT
	cCvdCodPla := ""
EndIf

If lCT020LOK
	If !ExecBlock("CT020LOK",.F.,.F.)
		lRetorno := .F.	
    Endif 
Endif    
     

Return(lRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ctba020FOk³ Autor ³ Felipe Aurelio de Melo³ Data ³10.09.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de validacao do campoOk da Getdados                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Expl1: Indica se o campo e valido                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function Ctba020FOk()

Local nColPosNow := oGetD:oBrowse:nColPos
Local nLinPosNow := oGetD:oBrowse:nAt
Local nCodPlaPos := aScan(aHeader,{|x|Alltrim(x[2])=="CVD_CODPLA" })
Local lRetorno   := .T.

If lExstCdPla .And. nColPosNow = nCodPlaPos
	cCvdCodPla := IIf(Type("M->CVD_CODPLA") = "U","",M->CVD_CODPLA)
Else
	If !lExstCdPla
		cCvdCodPla := "*" //Para não proibir alteração do campo
	EndIf
EndIf    
 
Return(lRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ctba020TOk³ Autor ³ Felipe Aurelio de Melo³ Data ³15.09.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de validacao do cTudoOk da Getdados                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Expl1: Indica se o o conteúdo dos campos são válidos        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Function Ctba020TOk()

Local nColEnt  := aScan(aHeader,{|x|Alltrim(x[2])=="CVD_ENTREF" })
Local nColPla  := aScan(aHeader,{|x|Alltrim(x[2])=="CVD_CODPLA" })
Local nColCta  := aScan(aHeader,{|x|Alltrim(x[2])=="CVD_CTAREF" })
Local nUsado   := Len(aHeader)
Local nLinPos  := 1      
Local lCT020TOK := ExistBlock("CT020TOK")
Local lRetorno := .T.
		

If !(cPaisLoc $ "DOM|MEX") .And. AliasInDic("CVD") 
If Len(aCols) == 1   					// se tem soh uma linha criada da getdaos verifica se codigo plano referencial esta preenchido 
	If !aCols[1][nUsado+1] .And. Empty(aCols[1][nColEnt]) .And. IIf(lExstCdPla,Empty(aCols[1][nColPla]),.T.) .And. Empty(aCols[1][nColCta])
		aCols[1, nUsado+1 ] := .T.  		//caso nao esteja preenchido exclui a linha para nao validar obrigatoriedade do campo CVD_TPUTIL
	EndIf
EndIf		
	If ( !Empty(aCols[n][nColEnt]) .Or. IIf(lExstCdPla,!Empty(aCols[n][nColPla]),.F.) .Or. !Empty(aCols[n][nColCta]) ) .And. !aCols[n][nUsado+1] 
		If Empty(aCols[n][nColEnt]) .Or. IIf(lExstCdPla, Empty(aCols[n][nColPla]),.F.) .Or.  Empty(aCols[n][nColCta])
			lRetorno := .F.
			Help(" ",1,"HELP","OBRIGATORIO","Favor preencher todos os campos da grade abaixo:"+Chr(10)+Chr(13)+"'Entidade'"+IIf(lExstCdPla,", 'Plano Ref.'","")+" e a 'Conta Ref' pois um ou mais deles está vazio.",3,1)
		Else
			If lExstCdPla
				CVN->(DbSetOrder(2))
				For nLinPos:=1 To Len(aCols)
					If CVN->(!DbSeek(xFilial("CVN")+aCols[nLinPos,nColPla]+aCols[nLinPos,nColCta]))
						lRetorno := .F.
						nLinPos:=Len(aCols)
						Help(" ",1,"HELP","CORRIGIR","Favor corrigir 'Plano Ref.' e a 'Conta Ref' pois estão inconsistentes.",3,1)
					EndIf
				Next nLinPos
			EndIf
		EndIf
	EndIf    
EndIf
If lCT020TOK
	If !ExecBlock("CT020TOK",.F.,.F.)
		lRetorno := .F.	
    Endif 
Endif

//Integração Protheus com SIGAGFE  T
If lRetorno
	If !IntProtGfe( IIF(INCLUI,3, IIF(ALTERA,4,5) ) )
		lRetorno := .F.
	EndIf
EndIf

Return(lRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CTBA020LEGEN ³ Autor ³ Renato F. Campos  ³ Data ³ 29/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe a legenda referente ao status                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBA020LEGEN()                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CTBA020                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Ctba020leg()

BrwLegenda(STR0011,STR0012,{	{ "BR_VERDE"    , STR0013},;  //"Legenda"###"Conta Contabil"###"Sem Restrição"
								{ "BR_VERMELHO" , STR0014},;  //"Bloqueado"
								{ "BR_AMARELO"	, STR0015},;  //"Exercicio Não Inciado"
								{ "BR_CINZA"	, STR0016},;  //"Exercicio Finalizado"
								{ "BR_LARANJA"	, STR0017}})   //"Bloqueado no Periodo"
									

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Paulo Carnelossi      ³ Data ³07/03/07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados         ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()

Local aRotina := {	{ OemToAnsi(STR0001),"AxPesqui"	  ,0 , 1,,.F.},;  //"Pesquisar"
					{ OemToAnsi(STR0002),"Ctba020Vis",0 , 2},;  //"Visualizar"
					{ OemToAnsi(STR0003),"Ctba020Inc",0 , 3},;  //"Incluir"
					{ OemToAnsi(STR0004),"Ctba020Alt",0 , 4},;  //"Alterar"
					{ OemToAnsi(STR0005),"Ctba020Del",0 , 5},;  //"Excluir"
					{ OemToAnsi(STR0034),"Ctba020Imp",0 , 3},;  //"Importar"
					{ OemToAnsi(STR0035),"Ctba020Exp",0 , 4},;  //"Exportar"
					{ OemToAnsi(STR0011),"Ctba020leg",0 , 6,,.F.},; //"Legenda"
					{ OemToAnsi(STR0045),"MSDOCUMENT", 0 , 4} }		// "Conhecimento" 

Return(aRotina)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ct020AjSX3 ºAutor  ³Davi Torchio			 º Data ³  06/09/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajusta o combo para os campos CT1_CVD+MOEDA E CT1_CVC+MOEDA    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSintaxe   ³ AjustaSX3()                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nenhum                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso      ³ SIGACTB                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nenhum                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ct020AjSX3()
Local aSaveArea	:= GetArea() 
Local nCont     := 0
Local nQuantMod := 0

nQuantMod:= CtbMoedas()
cSuf     := ""

For nCont := 2 To nQuantMod
	cSuf := StrZero(nCont,2)
	

	
	SX3->( DbSetOrder(2) )
	SX3->( DbSeek( "CT1_CVD" + cSuf ) )
	
	If ! SX3->( EOF() )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento da opcao A=Nao Ajusta                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("SX3")
		SX3->X3_VALID   := "Pertence('123456789A')" 
		SX3->X3_CBOX    := "1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento;A=Nao Ajusta"
		SX3->X3_CBOXSPA := "1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene Conversion;6=Fijo;7=Mensual Hist.;8=Promedio Hist.;9=Vencimiento;A=No Ajusta"
		SX3->X3_CBOXENG := "1=Daily;2=Averg;3=Mthly.;4=Informed;5=No Conversion;6=Fixed;7=Monthly History;8=Average History; 9=Due Date;A=Not Adjust"
		MsUnlock()
	EndIf                          
	
	
	SX3->( DbSetOrder(2) )
	SX3->( DbSeek( "CT1_CVC"+cSuf ) )
	If ! SX3->( EOF() )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento da opcao A=Nao Ajusta                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("SX3")
		SX3->X3_VALID   := "Pertence('123456789A')" 
		SX3->X3_CBOX 	:= "1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento;A=Nao Ajusta"
		SX3->X3_CBOXSPA := "1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene Conversion;6=Fijo;7=Mensual Hist.;8=Promedio Hist.;9=Vencimiento;A=No Ajusta"
		SX3->X3_CBOXENG := "1=Daily;2=Averg;3=Mthly.;4=Informed;5=No Conversion;6=Fixed;7=Monthly History;8=Average History; 9=Due Date;A=Not Adjust"
		MsUnlock()
	EndIf
	
		
Next nCont


SX3->( DbSetOrder(2) )
IF SX3->( DbSeek( "CT1_DTBLIN" ) ) .AND. EMPTY(SX3->X3_VALID)
	RecLock("SX3")
	SX3->X3_VALID:=	"CTB020DTIN()"
	MsUnlock()
EndIf

SX3->( DbSetOrder(2) )
IF SX3->( DbSeek( "CT1_DTBLFI" ) ) .AND. EMPTY(SX3->X3_VALID)
	RecLock("SX3")
	SX3->X3_VALID:=	"CTB020DTFI()"
	MsUnlock()
EndIf

SX3->( DbSetOrder(2) )
IF SX3->( DbSeek( "CT1_DTEXIS" ) ) .AND. EMPTY(SX3->X3_VALID)
	RecLock("SX3")
	SX3->X3_VALID:=	"CTB20DEXIN()"
	MsUnlock()
EndIf

SX3->( DbSetOrder(2) )
IF SX3->( DbSeek( "CT1_DTEXSF" ) ) .AND. EMPTY(SX3->X3_VALID)
	RecLock("SX3")
	SX3->X3_VALID:=	"CTB20DEXFI()"
	MsUnlock()
EndIf
              


SX3->( DbSetOrder(2) )
	SX3->( DbSeek( "CT2_CRCONV" ) )
	
	If ! SX3->( EOF() )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento da opcao A=Nao Ajusta                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("SX3")
		SX3->X3_CBOX 	:= "1=Diaria;2=Media;3=Mensal;4=Informada;5=Nao tem Conversao;6=Fixo;7=Mensal Historica;8=Media Historica;9=Vencimento;A=Nao Ajusta"
		SX3->X3_CBOXSPA := "1=Diaria;2=Promedio;3=Mensual;4=Informada;5=No tiene Conversion;A=No Ajusta"
		SX3->X3_CBOXENG := "1=Daily;2=Average;3=Monthly;4=Entered;5=No Conversion;6=Fixed;A=Not Adjust"
		MsUnlock()
	EndIf

	SX3->( DbSetOrder(2) )
	SX3->( DbSeek( "CT1_AJ_INF"  ) )
	
	If ! SX3->( EOF() )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento da opcao A=Nao Ajusta                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("SX3")
		SX3->X3_WHEN    := "M->CT1_CLASSE=='2'" 
		MsUnlock()
	EndIf                 


RestArea(aSaveArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB020DTIN  ³Autor ³ Eduardo Lima         ³ Data ³ 27/08/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a data de inicio de bloqueio						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTB020DTIN()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T./.F.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Valida‡„o no SX3 do campo CT1_DTBLIN (Data de Bloqueio)    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION CTB020DTIN()

Local lRet := .T.

If !empty(M->CT1_DTBLIN) .and. !empty(M->CT1_DTEXIS) .and. M->CT1_DTBLIN < M->CT1_DTEXIS
	Help(" ",1,"HELP","DTBLIN",STR0058,3,1)  //A data de inicio bloqueio não pode ser menor que a data de inicio de existencia.
	lRet:=.F.
Endif                                                                                                                    

IF	lRet .and. !empty(M->CT1_DTBLFI) .and. !empty(M->CT1_DTBLIN) .and. M->CT1_DTBLFI < M->CT1_DTBLIN
	Help(" ",1,"HELP","DTBLIN",STR0059,3,1)  //A data de inicio bloqueio não pode ser maior que a data de final de bloqueio.
	lRet:=.F.
Endif

Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB020DTFI  ³Autor ³ Eduardo Lima         ³ Data ³ 27/08/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a data de fim de bloqueio	    					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   CTB020DTFI()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T./.F.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Valida‡„o no SX3 do campo CT1_DTBLFI (Data de Bloqueio)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION CTB020DTFI()

Local lRet := .T.

If !empty(M->CT1_DTBLFI) .and. !empty(M->CT1_DTEXIS) .and. M->CT1_DTBLFI < M->CT1_DTEXIS
	Help(" ",1,"HELP","DTBLFI",STR0060,3,1)//A data de final de bloqueio não pode ser menor que a data de inicio de existencia.
	lRet:=.F.
Endif

If lRet .and. !empty(M->CT1_DTBLFI) .and. !empty(M->CT1_DTBLIN) .and. M->CT1_DTBLFI < M->CT1_DTBLIN
	Help(" ",1,"HELP","DTBLFI",STR0061,3,1)  //A data de final de bloqueio não pode ser menor que a data de inicio de bloqueio
	lRet:=.F.
Endif

Return lRet




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB20DEXIN  ³Autor ³ Eduardo Lima         ³ Data ³ 27/08/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a data de inicio de existencia    					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   CTB20DEXIN()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T./.F.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Valida‡„o no SX3 do campo CT1_DTEXIS (Data de Ini Existecia)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION CTB20DEXIN()

Local lRet := .T.

If !empty(M->CT1_DTEXIS) .and. !empty(M->CT1_DTEXSF) .and. M->CT1_DTEXSF < M->CT1_DTEXIS
	Help(" ",1,"HELP","DTEXIN",STR0062,3,1)  //A data de inicio de existencia não pode ser maior que a data de fim de existencia 
	lRet:=.F.
Endif

If lRet .and. !empty(M->CT1_DTEXIS) .and. !empty(M->CT1_DTBLFI) .and.  M->CT1_DTBLFI < M->CT1_DTEXIS
	Help(" ",1,"HELP","DTEXIN",STR0063,3,1)//A data de inicio de existencia não pode ser maior que a data de final de bloqueio     
	lRet:=.F.
Endif


If lRet .and. !empty(M->CT1_DTEXIS) .and. !empty(M->CT1_DTBLIN) .and.  M->CT1_DTBLIN < M->CT1_DTEXIS
	Help(" ",1,"HELP","DTEXIN",STR0064,3,1)    //A data de inicio de existencia não pode ser maior que a data de inicio de bloqueio
	lRet:=.F.
Endif


Return lRet



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB20DEXFI  ³Autor ³ Eduardo Lima         ³ Data ³ 27/08/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a data de fim de existencia    					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   CTB20DEXFI()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T./.F.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Valida‡„o no SX3 do campo CT1_DTEXIS (Data de Fim Existecia)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum.                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION CTB20DEXFI()

Local lRet := .T.

If !empty(M->CT1_DTEXSF) .and. !empty(M->CT1_DTEXIS) .and. M->CT1_DTEXSF <  M->CT1_DTEXIS 
	Help(" ",1,"HELP","DTEXFI",STR0065,3,1)  //A data de fim de existencia não pode ser menor que a data de inicio de existencia 	
	lRet:=.F.
Endif
Return lRet









/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTB020VAL ºAutor  ³Marcello            ºFecha ³ 27/04/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica os dados digitados para a gravação.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ctba020 - lancamento complementar                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CTB020Val()
Local lRet		:= .T.
Local cFilCT1	:= ""
Local aCT1	:= {}
Local aArea		:= {}

If FindFunction("CTBLCUSO") .And. CTBLCUso()
	If M->CT1_LCCMPL == "1"
		If Empty(M->CT1_CTPART) .Or. Empty(M->CT1_CTCPAR)
			Help(" ",1,"CT1CRIA",,STR0046 + "." + STR0047 + ".",1,0)//"Para o uso de lançamentos complementares, são necessárias as contas de partida e contra-partida"###"Informe-as nos campos correspondetes"
			lRet := .F.
		Else
			aArea := GetArea()
			DbSelectArea("CT1")
			aCT1 := GetArea()
			CT1->(DbSetOrder(1))
			cFilCT1 := xFilial("CT1")
			/* verificando a conta de partida para o lancamento complementar */
			If DbSeek(cFilCT1 + M->CT1_CTPART)
				If CT1->CT1_CLASSE == "1"	/* conta sintetica */
					Help(" ",1,"CT1CRIA2",,STR0048 + "." + STR0049 + ".",1,0)//"As contas para lançamentos complementares devem ser de classe analítica"###"Informe uma conta válida"
					lRet := .F.
				Else
					If CT1->CT1_LCCMPL == "1"
						Help(" ",1,"CT1CRIA3",,STR0050 + "." + STR0049 + ".",1,0)//"As conta para lançamentos complementares não podem exigir lançamento complementar"
						lRet := .F.
					Endif
				Endif
			Else
				Help(" ",1,"CT1CRIA4",,STR0051 + "." + STR0049 + ".",1,0)//"A conta de partida para o lançamento complementar não foi encontrada"
				lRet := .F.
			Endif
			/* verificando a conta de partida para o lancamento complementar */
			If lRet
				If DbSeek(cFilCT1 + M->CT1_CTCPAR)
					If CT1->CT1_CLASSE == "1"	/* conta sintetica */
						Help(" ",1,"CT1CRIA1",,STR0048 + "." + STR0049 + ".",1,0)
						lRet := .F.
					Else
						If CT1->CT1_LCCMPL == "1"
							Help(" ",1,"CT1CRIA1",,STR0050 + "." + STR0049 + ".",1,0)
							lRet := .F.
						Endif
					Endif
				Else
					Help(" ",1,"CT1CRIA1",,STR0052 + "." + STR0049 + ".",1,0) //"A conta de contra-partida para o lançamento complementar não foi encontrada"
					lRet := .F.
				Endif
			Endif
			RestArea(aCT1)
			RestArea(aArea)
		Endif
	Else
		M->CT1_CTPART := ""
		M->CT1_CTCPAR := ""
	Endif
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Ctb020Vl  ºAutor  ³Marcelo Celi Marques   º Data ³  21/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Permite no ponto de entrada a validacao dos campos de memoria  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Verdadeiro ou Falso                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso      ³ SIGACTB                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nenhum                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function Ctb020Vl()
	Local lRet:=.T.     
	If ExistBlock("AT020VCA")
	   lRet:=ExecBlock("AT020VCA",.F.,.F.,)
	EndIf
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBA020ExpºAutor  ³Marcelo Akama       º Data ³  11/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exporta o plano de contas para arquivo .CSV                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CTBA020Exp()
Local aRet		:=	{}   

If !FindFunction("CTBExpCSV")
	Aviso(STR0035,STR0044,{STR0033}) //"Exportar"###"Funcao nao disponivel" //"Fechar"
	Return .F.
EndIf

SaveInter()

If ParamBox({	{6,STR0021,padr("",150),"",,"",90 ,.T.,STR0022,"",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE}},; //"Estrut. de plano de contas"###"Arquivo .CSV |*.CSV"
		STR0023,@aRet)  //"Exportar para estrutura de plano de contas"

	oProcess:= MsNewProcess():New( {|lEnd| CTBExpCSV( lEnd, oProcess, aRet[1], { {"CT1",1}, {"CVD",1} } )} )
	oProcess:Activate()

EndIf

RestInter()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBA020ImpºAutor  ³Marcelo Akama       º Data ³  11/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importa plano de contas de arquivo .CSV                     º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CTBA020Imp()
Local aRet		:= {}
Local aArea		:= CT1->(GetArea())
Local aAreaCVD	:= CVD->(GetArea())
Local aCfg
Local cCampos

If !FindFunction("CTBImpCSV")
	Aviso(STR0034,STR0044,{STR0033}) //"Importar"###"Funcao nao disponivel" //"Fechar"
	Return .F.
EndIf

CT1->(dbGoTop())
CVD->(dbGoTop())
If !( CT1->(Eof()) .And. CT1->(Bof()) ) .Or. !( CVD->(Eof()) .And. CVD->(Bof()) )
	Aviso(STR0034,STR0036+CRLF+STR0037,{STR0033}) //"Importar"###"A importacao do plano de contas so pode ser"##"feita com o plano de contas vazio" //"Fechar"
	RestArea(aAreaCVD)
	RestArea(aArea)
	Return .F.
EndIf

SaveInter()
Pergunte("CTB020",.F.)
cCampos:="CT1_CONTA,CT1_DESC01,CT1_DESC02,CT1_DESC03,CT1_DESC04,CT1_DESC05,CT1_CLASSE,CT1_NORMAL"
If mv_par01 == 3 // Cod reduzido digitado
	cCampos += ",CT1_RES"
EndIf
cCampos += ",CT1_BLOQ,CT1_DTBLIN,CT1_DTBLFI,CT1_CVD02,CT1_CVD03,CT1_CVD04,CT1_CVD05,CT1_CVC02,CT1_CVC03,CT1_CVC04,CT1_CVC05,CT1_CTASUP,CT1_HP,CT1_ACITEM,CT1_ACCUST,CT1_ACCLVL,CT1_DTEXIS,CT1_DTEXSF,CT1_CTAVM,CT1_CTARED,CT1_CTALP,CT1_CTAPON,CT1_BOOK,CT1_GRUPO,CT1_RGNV1,CT1_RGNV2,CT1_RGNV3,CT1_CCOBRG,CT1_ITOBRG,CT1_CLOBRG,CT1_TRNSEF,CT1_LALUR,CT1_CTLALU,CT1_TPLALU,CT1_LALHIR,CT1_RATEIO,CT1_ACATIV,CT1_ATOBRG,CT1_ACET05,CT1_05OBRG"
aCfg := { { "CT1", cCampos, {||MsExecAuto({|x,y,z| CTBA020(x,y,z)}, xAutoCab, 3)} }, {"CVD",,} }

If ParamBox({	{6,STR0021,padr("",150),"",,"", 90 ,.T.,STR0022,"",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE}},;	 //"Estrut. plano de contas"###"Arquivo .CVE |*.CVE" 
		STR0028,@aRet)  //"Importar estrutura de plano de contas"

	oProcess:= MsNewProcess():New( {|lEnd| CTBImpCSV( lEnd, oProcess, aRet[1], aCfg )} )
	oProcess:Activate()
	lCTB020AUT := .F.

EndIf

RestInter()
RestArea(aAreaCVD)
RestArea(aArea)

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBA020hlpºAutor  ³Microsiga           º Data ³  04/26/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria Help para cadastro de plano de contas				  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CT020hlp() 
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpEsp	:= {}   

aHelpPor := { "Define se aceita as outras informações",;
			   "contábeis a débito ou a crédito." }           			   
IF cPaisLoc == "MEX" 
	aHelpEsp := {"Define si acepta las otras informaciones",;
	             "contables a cargo o a abono."}
EndIf    
                                                                                
PutHelp( "PCT1_ACATIV",aHelpPor,aHelpEng,aHelpEsp,.T. )   

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}   

aHelpPor := { "Define se as outras informações        ",;    
              " contábeis a débito ou a crédito serão ",;    
              "obrigatórias." }           

IF cPaisLoc == "MEX" 
	aHelpEsp := {"Define si las otras informaciones",;
				 "contables a cargo o a abono seran",;	
	             "obligatorias."}
else
	aHelpEsp := {"Define si la otra informacion contable a",;
				 " debito o a credito es obligatoria."}
EndIf
                                                                                    
PutHelp( "PCT1_ATOBRG",aHelpPor,aHelpEng,aHelpEsp,.T. )   

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}   

Aadd(aHelpPor,"Especifica o critério de conversão a ser" )
Aadd(aHelpPor,"utilizado na conversão dos valores " )
Aadd(aHelpPor,"lançados no Lançamento Contábil. Este " )
Aadd(aHelpPor,"critério será utilizado para lançamentos" )
Aadd(aHelpPor,"a débito na Moeda 02. Os critérios" )
Aadd(aHelpPor,"poderão ser:" )
Aadd(aHelpPor,"1 - Taxa Diária: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores pela taxa diária " )
Aadd(aHelpPor,"(informada no Cadastro de Câmbio)" )
Aadd(aHelpPor,"2 - Taxa" )
Aadd(aHelpPor,"Média: o sistema efetua a conversão dos" )
Aadd(aHelpPor,"valores utilizando a taxa da média do " )
Aadd(aHelpPor,"mês (o cálculo da média mensal é" )
Aadd(aHelpPor,"efetuado a partir do Cadastro de " )
Aadd(aHelpPor,"Câmbio)." )
Aadd(aHelpPor,"3 - Taxa Mensal: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores utilizando a taxa" )
Aadd(aHelpPor,"do último dia do mês (informada no " )
Aadd(aHelpPor,"Cadastro de Câmbio)." )
Aadd(aHelpPor,"4 - Informada: informado no lançamento " )
Aadd(aHelpPor,"- o valor da conversão é informada " )
Aadd(aHelpPor,"na hora do lançamento." )
Aadd(aHelpPor,"5 - Não tem conversao: não existe " )
Aadd(aHelpPor,"conversão para essa moeda." )
Aadd(aHelpPor,"6 - Fixo: terá sempre o mesmo valor " )
Aadd(aHelpPor,"estipulado." )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Obs: No caso do critério de" )
Aadd(aHelpPor,"conversão a débito ser diferente do " )
Aadd(aHelpPor,"crédito, não é aconselhável que se " )
Aadd(aHelpPor,"façam lançamentos contábeis de partida" )
Aadd(aHelpPor,"dobrada. " )
Aadd(aHelpPor,"Nesta situação crie duas linhas de " )
Aadd(aHelpPor,"lançamentos contábeis (Déb. / Créd.)" )
Aadd(aHelpPor,"Exemplo:" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 11101 " )
Aadd(aHelpPor,"Crit. Déb. => 1 (Diário)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 21101" )
Aadd(aHelpPor,"Crit. Créd. => 2 (Mensal)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"No lançamento contábil partida " )
Aadd(aHelpPor,"dobrada, o sistema considerará o " )
Aadd(aHelpPor,"critério da última conta digitada." )
Aadd(aHelpPor,"Caso não seja conveniente esse " )
Aadd(aHelpPor,"procedimento, crie duas linhas de " )
Aadd(aHelpPor,"lançamento contábil.  " )                     

IF cPaisLoc == "MEX"                                                               
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores registrados en el Asiento " )
	Aadd(aHelpEsp,"Contable. Este criterio se utilizara " )
	Aadd(aHelpEsp,"para asientos a cargo en la Moneda 02. " )
	Aadd(aHelpEsp,"Los criterios podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua " )
	Aadd(aHelpEsp,"la conversion de los valores por la " )
	Aadd(aHelpEsp,"tasa diaria (informada en el " )
	Aadd(aHelpEsp,"Archivo de Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedia: el sistema efectua" )
	Aadd(aHelpEsp,"la conversion de los valores" )
	Aadd(aHelpEsp,"utilizando la tasa del promedio del mes" )
	Aadd(aHelpEsp,"(el calculo del promedio mensual se efe" )
	Aadd(aHelpEsp,"ctua a partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 " )
	Aadd(aHelpEsp,"- Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando" )
	Aadd(aHelpEsp,"la tasa del ultimo dia del mes" )
	Aadd(aHelpEsp,"(informada en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en" )
	Aadd(aHelpEsp,"el momento del asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moeda." )
	Aadd(aHelpEsp,"6 - Fijo: " )
	Aadd(aHelpEsp,"tendrá siempre el mismo valor estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: En el caso de que el criterio de" )
 	Aadd(aHelpEsp,"conversion a cargo sea diferente del a " )
	Aadd(aHelpEsp,"abono, no es aconsejable hacer asientos " )
	Aadd(aHelpEsp,"contables de partida doble. En esa" )
	Aadd(aHelpEsp,"situacion, cree dos lineas de asientos " )
	Aadd(aHelpEsp,"contables (Car. / Abo.)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta => 111" )
	Aadd(aHelpEsp,"01 " )
	Aadd(aHelpEsp,"Crit. Carg. => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta =>" )
 	Aadd(aHelpEsp,"21101" )
	Aadd(aHelpEsp,"Crit. Abon. => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, " )
	Aadd(aHelpEsp,"el sistema considerara el criterio de " )
	Aadd(aHelpEsp,"la ultima cuenta digitada. Si ese" )
	Aadd(aHelpEsp,"procedimiento no es conveniente, " )
	Aadd(aHelpEsp,"cree dos lineas de asiento contable.                     " )
else
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable." )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a debito en la Moneda 02. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema " )
	Aadd(aHelpEsp,"efectua la conversion de los valores por" )
	Aadd(aHelpEsp," la tasa diaria (informada en el Archivo" )
	Aadd(aHelpEsp,"de Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema efectua la" )
	Aadd(aHelpEsp,"conversion de los valores utilizando la" )
	Aadd(aHelpEsp,"tasa del promedio del mes (el calculo" )
	Aadd(aHelpEsp,"del promedio mensual se efectua a " )
	Aadd(aHelpEsp,"partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - " )
	Aadd(aHelpEsp,"Tasa Mensual: el sistema efectua la conv" )
	Aadd(aHelpEsp,"ersion de valores utilizando la tasa del" )
	Aadd(aHelpEsp,"ultimo dia del mes (informada en el " )
	Aadd(aHelpEsp,"Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento - " )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra " )
	Aadd(aHelpEsp,"siempre el mismo valor estipulado." )
	Aadd(aHelpEsp,"Obs:" )
	Aadd(aHelpEsp,"Obs: En caso que el criterio de " )
	Aadd(aHelpEsp,"conversion a debito sea diferente del" )
	Aadd(aHelpEsp,"credito, no es aconsejable que se " )
	Aadd(aHelpEsp,"realicen asientos contables de partida" )
	Aadd(aHelpEsp,"doble. En esta situacion cree dos " )
	Aadd(aHelpEsp,"lineas de asientos contables " )
	Aadd(aHelpEsp,"(Deb. / Cred.)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta =>" )
	Aadd(aHelpEsp,"11101 " )
	Aadd(aHelpEsp,"Crit. Deb. => 1 (Diario)" )
	Aadd(aHelpEsp,"Cuenta" )
    Aadd(aHelpEsp,"=> 21101" )
	Aadd(aHelpEsp,"Crit. Cred. => 2 (Mensual)" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, " )
	Aadd(aHelpEsp,"el sistema considerara el criterio de " )
	Aadd(aHelpEsp,"la ultima cuenta digitada. En caso de " )
	Aadd(aHelpEsp,"que no sea conveniente este " )
	Aadd(aHelpEsp,"procedimiento, creedos lineas de asiento contable." )
EndIf                                                                                    

 
PutHelp( "PCT1_CVD02",aHelpPor,aHelpEng,aHelpEsp,.T. )   

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}   

Aadd(aHelpPor,"Especifica o critério de conversão a ser" )
Aadd(aHelpPor,"utilizado na conversão dos valores " )
Aadd(aHelpPor,"lançados no Lançamento Contábil. Este " )
Aadd(aHelpPor,"critério será utilizado para lançamentos" )
Aadd(aHelpPor,"a débito na Moeda 03. Os critérios" )
Aadd(aHelpPor,"poderão ser:" )
Aadd(aHelpPor,"1 - Taxa Diária: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores pela taxa diária " )
Aadd(aHelpPor,"(informada no Cadastro de Câmbio)" )
Aadd(aHelpPor,"2 - Taxa" )
Aadd(aHelpPor,"Média: o sistema efetua a conversão dos" )
Aadd(aHelpPor,"valores utilizando a taxa da média do " )
Aadd(aHelpPor,"mês (o cálculo da média mensal é " )
Aadd(aHelpPor,"efetuado a partir do Cadastro de" )
Aadd(aHelpPor,"Câmbio)." )
Aadd(aHelpPor,"3 - Taxa Mensal: " )
Aadd(aHelpPor,"o sistema efetua a conversão " )
Aadd(aHelpPor,"dos valores utilizando a taxa do último " )
Aadd(aHelpPor,"dia do mês (informada no Cadastro de " )
Aadd(aHelpPor,"Câmbio)." )
Aadd(aHelpPor,"4 - Informada: informado no lançamento -" )
Aadd(aHelpPor,"o valor da conversão é informada " )
Aadd(aHelpPor,"na hora do lançamento." )
Aadd(aHelpPor,"5 - Não tem conversao: não existe " )
Aadd(aHelpPor,"conversão para essa moeda." )
Aadd(aHelpPor,"6 - Fixo: terá sempre o mesmo valor " )
Aadd(aHelpPor,"estipulado." )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Obs: No caso do critério de" )
Aadd(aHelpPor,"conversão a débito ser diferente do " )
Aadd(aHelpPor,"crédito, não é aconselhável que se" )
Aadd(aHelpPor,"façam lançamentos contábeis de partida" )
Aadd(aHelpPor,"dobrada. Nesta situação crie duas " )
Aadd(aHelpPor,"linhas de lançamentos contábeis " )
Aadd(aHelpPor,"(Déb. / Créd.)" )
Aadd(aHelpPor,"Exemplo:" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 11101 " )
Aadd(aHelpPor,"Crit. Déb. => 1 (Diário)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 21101" )
Aadd(aHelpPor,"Crit. Créd. => 2 (Mensal)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"No lançamento contábil partida dobrada," )
Aadd(aHelpPor,"o sistema considerará o critério da" )
Aadd(aHelpPor,"última conta digitada. Caso não seja " )
Aadd(aHelpPor,"conveniente esse procedimento, crie duas" )
Aadd(aHelpPor,"linhas de lançamento contábil. " )

IF cPaisLoc == "MEX" 
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable." )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a cargo en la Moneda 03. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores por la tasa " )
	Aadd(aHelpEsp,"diaria (informada en el Archivo de " )
	Aadd(aHelpEsp,"Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema" )
	Aadd(aHelpEsp,"efectua la conversion de los valores " )
	Aadd(aHelpEsp,"utilizando la tasa del promedio del mes " )
	Aadd(aHelpEsp,"(el calculo del promedio mensual se " )
	Aadd(aHelpEsp,"efectua a partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso que el criterio de " )
	Aadd(aHelpEsp,"conversion a cargo sea diferente del a " )
	Aadd(aHelpEsp,"abono, no es aconsejable que se realicen " )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de " )
	Aadd(aHelpEsp,"asientos contables (Cargo / Abono)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta" )
 	Aadd(aHelpEsp,"=> 11101 " )
	Aadd(aHelpEsp,"Crit. Cargo => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. Abono => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, " )
	Aadd(aHelpEsp,"el sistema considerara el criterio de la" )
 	Aadd(aHelpEsp,"ultima cuenta digitada. En caso de que " )
	Aadd(aHelpEsp,"no sea conveniente este procedimiento, " )
	Aadd(aHelpEsp,"creedos lineas de asiento contable." )
else
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
 	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
 	Aadd(aHelpEsp,"valores emitidos en el asiento " )
 	Aadd(aHelpEsp,"contable. " )
 	Aadd(aHelpEsp,"Este criterio se utilizara para " )
 	Aadd(aHelpEsp,"asientos a debito en la Moneda 03. " )
 	Aadd(aHelpEsp,"Los criterios podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema " )
	Aadd(aHelpEsp,"efectua la conversion de los valores por" )
 	Aadd(aHelpEsp,"la tasa diaria (informada en el Archivo" )
 	Aadd(aHelpEsp,"de Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema efectua la" )
 	Aadd(aHelpEsp,"conversion de los valores utilizando la" )
 	Aadd(aHelpEsp,"tasa del promedio del mes (el calculo " )
 	Aadd(aHelpEsp,"del promedio mensual se efectua a " )
 	Aadd(aHelpEsp,"partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
 	Aadd(aHelpEsp,"el valor de la conversion se informa en" )
 	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor" )
 	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso que el criterio de " )
	Aadd(aHelpEsp,"conversion a debito sea diferente del " )
	Aadd(aHelpEsp,"credito, no es aconsejable que se " )
	Aadd(aHelpEsp,"realicen asientos contables de partida " )
	Aadd(aHelpEsp,"doble. En esta situacion cree dos lineas" )
	Aadd(aHelpEsp,"de asientos" )
	Aadd(aHelpEsp,"contables (Deb. / Cred.)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta => 11101 " )
	Aadd(aHelpEsp,"Crit. Deb. => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. Cred. => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, " )
	Aadd(aHelpEsp,"el sistema considerara el criterio de la" )
	Aadd(aHelpEsp,"ultima cuenta digitada. En caso de que " )
	Aadd(aHelpEsp,"no sea conveniente este procedimiento, " )
	Aadd(aHelpEsp,"cree dos lineas de asiento contable." )
EndIf                                                                                    

 
PutHelp( "PCT1_CVD03",aHelpPor,aHelpEng,aHelpEsp,.T. )   

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}   

Aadd(aHelpPor,"Especifica o critério de conversão a ser" )
Aadd(aHelpPor,"utilizado na conversão dos valores " )
Aadd(aHelpPor,"lançados no Lançamento Contábil. Este " )
Aadd(aHelpPor,"critério será utilizado para " )
Aadd(aHelpPor,"lançamentos a débito na Moeda 04. " )
Aadd(aHelpPor,"Os critérios poderão ser:" )
Aadd(aHelpPor,"1 - Taxa Diária: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores pela taxa diária " )
Aadd(aHelpPor,"(informada no Cadastro de Câmbio)" )
Aadd(aHelpPor,"2 - Taxa" )
Aadd(aHelpPor,"Média: o sistema efetua a conversão dos" )
Aadd(aHelpPor,"valores utilizando a taxa da média do " )
Aadd(aHelpPor,"mês (o cálculo da média mensal é" )
Aadd(aHelpPor,"efetuado a partir do Cadastro de" )
Aadd(aHelpPor,"Câmbio)." )
Aadd(aHelpPor,"3 - Taxa Mensal:" )
Aadd(aHelpPor," o sistema efetua a conversão dos " )
Aadd(aHelpPor,"valores utilizando a taxa do último " )
Aadd(aHelpPor,"dia do mês (informada no Cadastro de " )
Aadd(aHelpPor,"Câmbio)." )
Aadd(aHelpPor,"4 - Informada: informado no lançam" )
Aadd(aHelpPor,"ento - o valor da conversão é informada " )
Aadd(aHelpPor,"na hora do lançamento." )
Aadd(aHelpPor,"5 - Não tem conversao: " )
Aadd(aHelpPor,"não existe conversão para essa moeda." )
Aadd(aHelpPor,"6 - Fixo: terá sempre o mesmo valor " )
Aadd(aHelpPor,"estipulado." )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Obs: No caso do critério de" )
Aadd(aHelpPor," conversão a débito ser diferente do " )
Aadd(aHelpPor," crédito, não é aconselhável que se " )
Aadd(aHelpPor,"façam  lançamentos contábeis de partida" )
Aadd(aHelpPor,"dobrada. " )
Aadd(aHelpPor,"Nesta situação crie duas linhas de " )
Aadd(aHelpPor,"lançamentos contábeis (Déb. / Créd.)" )
Aadd(aHelpPor,"Exemplo:" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 11101 " )
Aadd(aHelpPor,"Crit. Déb. => 1 (Diário)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 21101" )
Aadd(aHelpPor,"Crit. Créd. => 2 (Mensal)" )
Aadd(aHelpPor,"" )                                        
Aadd(aHelpPor,"No lançamento contábil partida dobrada," )
Aadd(aHelpPor,"o sistema considerará o critério da" )
Aadd(aHelpPor,"última conta digitada. Caso não seja " )
Aadd(aHelpPor,"conveniente esse procedimento, crie " )
Aadd(aHelpPor,"duas linhas de lançamento contábil. " )         

IF cPaisLoc == "MEX" 
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable." )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a cargo en la Moneda 04. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores por la tasa " )
	Aadd(aHelpEsp,"diaria (informada en el Archivo de " )
	Aadd(aHelpEsp,"Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema efectua la" )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del promedio del mes (el calculo " )
	Aadd(aHelpEsp,"del promedio mensual se efectua a partir" )
	Aadd(aHelpEsp,"del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la" )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso que el criterio de " )
	Aadd(aHelpEsp,"conversion a cargo sea diferente del a " )
	Aadd(aHelpEsp,"abono, no es aconsejable que se realicen" )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de " )
	Aadd(aHelpEsp,"asientos contables (Cargo / Abono)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta" )
 	Aadd(aHelpEsp,"=> 11101 " )
	Aadd(aHelpEsp,"Crit. Cargo => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. Abono => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, " )
	Aadd(aHelpEsp,"el sistema considerara el criterio de la" )
 	Aadd(aHelpEsp,"ultima cuenta digitada. En caso de que " )
	Aadd(aHelpEsp,"no sea conveniente este procedimiento, " )
	Aadd(aHelpEsp,"cree dos lineas de asiento contable." )
else
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable." )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a debito en la Moneda 04. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores por la tasa " )
	Aadd(aHelpEsp,"diaria (informada en el Archivo de " )
	Aadd(aHelpEsp,"Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema efectua la" )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del promedio del mes (el calculo " )
	Aadd(aHelpEsp,"del promedio mensual se efectua a partir" )
	Aadd(aHelpEsp,"del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la" )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso que el criterio de " )
	Aadd(aHelpEsp,"conversion a debito sea diferente del a " )
	Aadd(aHelpEsp,"credito, no es aconsejable que se realicen" )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de " )
	Aadd(aHelpEsp,"asientos contables (debito / credito)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta" )
 	Aadd(aHelpEsp,"=> 11101 " )
	Aadd(aHelpEsp,"Crit. debito => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. credito => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, " )
	Aadd(aHelpEsp,"el sistema considerara el criterio de la" )
 	Aadd(aHelpEsp,"ultima cuenta digitada. En caso de que " )
	Aadd(aHelpEsp,"no sea conveniente este procedimiento, " )
	Aadd(aHelpEsp,"cree dos lineas de asiento contable." )
EndIf                                                                                    

 
PutHelp( "PCT1_CVD04",aHelpPor,aHelpEng,aHelpEsp,.T. )

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}   

Aadd(aHelpPor,"Especifica o critério de conversão a ser" )
Aadd(aHelpPor,"utilizado na conversão dos valores " )
Aadd(aHelpPor,"lançados no Lançamento Contábil. Este " )
Aadd(aHelpPor,"critério será utilizado para lançamentos" )
Aadd(aHelpPor,"a débito na Moeda 05. Os critérios " )
Aadd(aHelpPor,"poderão ser:" )
Aadd(aHelpPor,"1 - Taxa Diária: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores pela taxa diária " )
Aadd(aHelpPor,"(informada no Cadastro de Câmbio)" )
Aadd(aHelpPor,"2 - Taxa" )
Aadd(aHelpPor," Média: o sistema efetua a conversão dos" )
Aadd(aHelpPor," valores utilizando a taxa da média do " )
Aadd(aHelpPor,"mês (o cálculo da média mensal é " )
Aadd(aHelpPor,"efetuado a partir do Cadastro de " )
Aadd(aHelpPor,"Câmbio)." )
Aadd(aHelpPor,"3 - Taxa Mensal: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores utilizando a taxa" )
Aadd(aHelpPor,"do último dia do mês (informada no " )
Aadd(aHelpPor,"Cadastro de Câmbio)." )
Aadd(aHelpPor,"4 - Informada: informado no lançamento -" )
Aadd(aHelpPor,"o valor da conversão é informada na hora" )
Aadd(aHelpPor,"do lançamento." )
Aadd(aHelpPor,"5 - Não tem conversao: não existe " )
Aadd(aHelpPor,"conversão para essa moeda." )
Aadd(aHelpPor,"6 - Fixo: terá sempre o mesmo valor " )
Aadd(aHelpPor,"estipulado." )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Obs: No caso do critério de" )
Aadd(aHelpPor,"conversão a débito ser diferente do " )
Aadd(aHelpPor,"crédito, não é aconselhável que se " )
Aadd(aHelpPor,"façam lançamentos contábeis de partida " )
Aadd(aHelpPor,"dobrada. " )
Aadd(aHelpPor,"Nesta situação crie duas linhas de " )
Aadd(aHelpPor,"lançamentos contábeis (Déb. / Créd.)" )
Aadd(aHelpPor,"Exemplo:" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 11101 " )
Aadd(aHelpPor,"Crit. Déb. => 1 (Diário)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 21101" )
Aadd(aHelpPor,"Crit. Créd. => 2 (Mensal)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"No lançamento contábil partida dobrada," )
Aadd(aHelpPor,"o sistema considerará o critério da" )
Aadd(aHelpPor,"última conta digitada. Caso não seja " )
Aadd(aHelpPor,"conveniente esse procedimento, crie " )
Aadd(aHelpPor,"duas linhas de lançamento contábil. " )

IF cPaisLoc == "MEX" 
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable. " )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a cargo en la Moneda 05. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores por " )
	Aadd(aHelpEsp,"la tasa diaria (informada en el Archivo " )
	Aadd(aHelpEsp,"de Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema" )
	Aadd(aHelpEsp,"efectua la conversion de los valores " )
	Aadd(aHelpEsp,"utilizando la tasa del promedio del mes " )
	Aadd(aHelpEsp,"(el calculo del promedio mensual se " )
	Aadd(aHelpEsp,"efectua a partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso que el criterio de " )
	Aadd(aHelpEsp,"conversion a cargo sea diferente del a " )
	Aadd(aHelpEsp,"abono, no es aconsejable que se realicen" )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de " )
	Aadd(aHelpEsp,"asientos contables (Cargo / Abono)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta" )
 	Aadd(aHelpEsp,"=> 11101 " )
	Aadd(aHelpEsp,"Crit. Cargo => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. Abono => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, " )
	Aadd(aHelpEsp,"el sistema considerara el criterio de la" )
	Aadd(aHelpEsp,"ultima cuenta digitada. En caso de que " )
	Aadd(aHelpEsp,"no sea conveniente este procedimiento, " )
	Aadd(aHelpEsp,"cree dos lineas de asiento contable." )
else
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable. " )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a debito en la Moneda 05. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores por " )
	Aadd(aHelpEsp,"la tasa diaria (informada en el Archivo " )
	Aadd(aHelpEsp,"de Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema" )
	Aadd(aHelpEsp,"efectua la conversion de los valores " )
	Aadd(aHelpEsp,"utilizando la tasa del promedio del mes " )
	Aadd(aHelpEsp,"(el calculo del promedio mensual se " )
	Aadd(aHelpEsp,"efectua a partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso que el criterio de " )
	Aadd(aHelpEsp,"conversion a debito sea diferente del a " )
	Aadd(aHelpEsp,"credito, no es aconsejable que se realicen" )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de " )
	Aadd(aHelpEsp,"asientos contables (debito / credito)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta" )
 	Aadd(aHelpEsp,"=> 11101 " )
	Aadd(aHelpEsp,"Crit. debito => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. credito => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, " )
	Aadd(aHelpEsp,"el sistema considerara el criterio de la" )
	Aadd(aHelpEsp,"ultima cuenta digitada. En caso de que " )
	Aadd(aHelpEsp,"no sea conveniente este procedimiento, " )
	Aadd(aHelpEsp,"cree dos lineas de asiento contable." )
EndIf                                                                                    

 
PutHelp( "PCT1_CVD05",aHelpPor,aHelpEng,aHelpEsp,.T. )   

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}   

Aadd(aHelpPor,"Especifica o critério de conversão a ser" )
Aadd(aHelpPor,"utilizado na conversão dos valores " )
Aadd(aHelpPor,"lançados no Lançamento Contábil. Este " )
Aadd(aHelpPor,"critério será utilizado para lançamentos" )
Aadd(aHelpPor,"a crédito na Moeda 02. Os critérios " )
Aadd(aHelpPor,"poderão ser:" )
Aadd(aHelpPor,"1 - Taxa Diária: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores pela taxa diária " )
Aadd(aHelpPor,"(informada no Cadastro de Câmbio)" )
Aadd(aHelpPor,"2 - Taxa Média: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores utilizando a taxa " )
Aadd(aHelpPor,"da média do mês (o cálculo da média " )
Aadd(aHelpPor,"mensal é efetuado a partir do Cadastro " )
Aadd(aHelpPor,"de Câmbio)." )
Aadd(aHelpPor,"3 - Taxa Mensal: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores utilizando a taxa " )
Aadd(aHelpPor,"do último dia do mês (informada no " )
Aadd(aHelpPor,"Cadastro de Câmbio)." )
Aadd(aHelpPor,"4 - Informada: informado no lançamento -" )
Aadd(aHelpPor,"o valor da conversão é informada na hora" )
Aadd(aHelpPor,"do lançamento." )
Aadd(aHelpPor,"5 - Não tem conversao: não existe " )
Aadd(aHelpPor,"conversão para essa moeda." )
Aadd(aHelpPor,"6 - Fixo: terá sempre o mesmo valor" )
Aadd(aHelpPor,"estipulado." )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Obs: No caso do critério de conversão a " )
Aadd(aHelpPor,"débito ser diferente do crédito, não é " )
Aadd(aHelpPor,"aconselhável que se façam lançamentos " )
Aadd(aHelpPor,"contábeis de partida dobrada." )
Aadd(aHelpPor,"Nesta situação crie duas linhas de " )
Aadd(aHelpPor,"lançamentos contábeis (Déb. / Créd.)" )
Aadd(aHelpPor,"Exemplo" )
Aadd(aHelpPor,":" )
Aadd(aHelpPor,"Conta => 11101 " )
Aadd(aHelpPor,"Crit. Déb. => 1 (Diário)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 21101" )
Aadd(aHelpPor,"Crit. Créd. => 2 (Mensal)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"No lançamento contábil partida dobrada, " )
Aadd(aHelpPor,"o sistema considerará o critério da " )
Aadd(aHelpPor,"última conta digitada. Caso não seja " )
Aadd(aHelpPor,"conveniente esse procedimento, crie duas " )
Aadd(aHelpPor,"linhas de lançamento contábil. " )

IF cPaisLoc == "MEX" 
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable." )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a abono en la Moneda 02. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores por la tasa " )
	Aadd(aHelpEsp,"diaria (informada en el Archivo de " )
	Aadd(aHelpEsp,"Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema" )
	Aadd(aHelpEsp,"efectua la conversion de los valores " )
	Aadd(aHelpEsp,"utilizando la tasa del promedio del mes " )
	Aadd(aHelpEsp,"(el calculo del promedio mensual se " )
	Aadd(aHelpEsp,"efectua a partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: En caso de que el criterio de " )
	Aadd(aHelpEsp,"conversion a cargo sea diferente del a " )
	Aadd(aHelpEsp,"abono, no es aconsejable que se realicen" )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de " )
	Aadd(aHelpEsp,"asientos contables (Cargo / Abono)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta => 11101 " )
	Aadd(aHelpEsp,"Crit. Cargo => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. Abono => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, el" )
	Aadd(aHelpEsp,"sistema considerara el criterio de la " )
	Aadd(aHelpEsp,"ultima cuenta digitada. En caso de que " )
	Aadd(aHelpEsp,"no sea conveniente este procedimiento," )
	Aadd(aHelpEsp,"cree dos lineas de asiento contable." )
else
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable." )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a credito en la Moneda 02. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores por la tasa " )
	Aadd(aHelpEsp,"diaria (informada en el Archivo de " )
	Aadd(aHelpEsp,"Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema" )
	Aadd(aHelpEsp,"efectua la conversion de los valores " )
	Aadd(aHelpEsp,"utilizando la tasa del promedio del mes " )
	Aadd(aHelpEsp,"(el calculo del promedio mensual se " )
	Aadd(aHelpEsp,"efectua a partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: En caso de que el criterio de " )
	Aadd(aHelpEsp,"conversion a debito sea diferente del a " )
	Aadd(aHelpEsp,"credito, no es aconsejable que se realicen" )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de " )
	Aadd(aHelpEsp,"asientos contables (debito / credito)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta => 11101 " )
	Aadd(aHelpEsp,"Crit. debito => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. credito => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, el" )
	Aadd(aHelpEsp,"sistema considerara el criterio de la " )
	Aadd(aHelpEsp,"ultima cuenta digitada. En caso de que " )
	Aadd(aHelpEsp,"no sea conveniente este procedimiento," )
	Aadd(aHelpEsp,"cree dos lineas de asiento contable." )
EndIf                                                                                    

 
PutHelp( "PCT1_CVC02",aHelpPor,aHelpEng,aHelpEsp,.T. )   

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}   

Aadd(aHelpPor,"Especifica o critério de conversão a ser" )
Aadd(aHelpPor,"utilizado na conversão dos valores " )
Aadd(aHelpPor,"lançados no Lançamento Contábil. Este " )
Aadd(aHelpPor,"critério será utilizado para lançamentos" )
Aadd(aHelpPor,"a crédito na Moeda 03. Os critérios " )
Aadd(aHelpPor,"poderão ser:" )
Aadd(aHelpPor,"1 - Taxa Diária: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores pela taxa diária " )
Aadd(aHelpPor,"(informada no Cadastro de Câmbio)" )
Aadd(aHelpPor,"2 - Taxa Média: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores utilizando a taxa " )
Aadd(aHelpPor,"da média do mês (o cálculo da média " )
Aadd(aHelpPor,"mensal é efetuado a partir do Cadastro " )
Aadd(aHelpPor,"de Câmbio)." )
Aadd(aHelpPor,"3 - Taxa Mensal: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores utilizando a taxa " )
Aadd(aHelpPor,"do último dia do mês (informada no " )
Aadd(aHelpPor,"Cadastro de Câmbio)." )
Aadd(aHelpPor,"4 - Informada: informado no lançamento -" )
Aadd(aHelpPor,"o valor da conversão é informada na hora" )
Aadd(aHelpPor,"do lançamento." )
Aadd(aHelpPor,"5 - Não tem conversao: não existe " )
Aadd(aHelpPor,"conversão para essa moeda." )
Aadd(aHelpPor,"6 - Fixo: terá sempre o mesmo valor" )
Aadd(aHelpPor,"estipulado." )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Obs: No caso do critério de conversão a " )
Aadd(aHelpPor,"débito ser diferente do crédito, não é " )
Aadd(aHelpPor,"aconselhável que se façam lançamentos " )
Aadd(aHelpPor,"contábeis de partida dobrada." )
Aadd(aHelpPor,"Nesta situação crie duas linhas de " )
Aadd(aHelpPor,"lançamentos contábeis (Déb. / Créd.)" )
Aadd(aHelpPor,"Exemplo" )
Aadd(aHelpPor,":" )
Aadd(aHelpPor,"Conta => 11101 " )
Aadd(aHelpPor,"Crit. Déb. => 1 (Diário)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 21101" )
Aadd(aHelpPor,"Crit. Créd. => 2 (Mensal)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"No lançamento contábil partida " )
Aadd(aHelpPor,"dobrada, o sistema considerará o " )
Aadd(aHelpPor,"critério da última conta digitada. Caso " )
Aadd(aHelpPor,"não seja conveniente esse procedimento, " )
Aadd(aHelpPor,"crie duas linhas de lançamento contábil.  " )

IF cPaisLoc == "MEX" 
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable. " )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos" )
	Aadd(aHelpEsp,"a abono en la Moneda 03. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema " )
	Aadd(aHelpEsp,"efectua la conversion de los valores por" )
	Aadd(aHelpEsp,"la tasa diaria (informada en el Archivo" )
	Aadd(aHelpEsp,"de Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema efectua la" )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del promedio del mes " )
	Aadd(aHelpEsp,"(el calculo del promedio mensual se " )
	Aadd(aHelpEsp,"efectua a partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - " )
	Aadd(aHelpEsp,"Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso de que el criterio de " )
	Aadd(aHelpEsp,"conversion a cargo sea diferente del a " )
	Aadd(aHelpEsp,"abono, no es aconsejable que se realicen " )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de " )
	Aadd(aHelpEsp,"asientos contables (Cargo / Abono)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta => 11101 " )
	Aadd(aHelpEsp,"Crit. Cargo => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. Abono => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, el" )
	Aadd(aHelpEsp,"sistema considerara el criterio de" )
	Aadd(aHelpEsp,"la ultima cuenta digitada. En caso de " )
	Aadd(aHelpEsp,"que no sea conveniente este " )
	Aadd(aHelpEsp,"procedimiento, cree dos lineas de " )
	Aadd(aHelpEsp,"asiento contable." )
else
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable. " )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos" )
	Aadd(aHelpEsp,"a credito en la Moneda 03. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema " )
	Aadd(aHelpEsp,"efectua la conversion de los valores por" )
	Aadd(aHelpEsp,"la tasa diaria (informada en el Archivo" )
	Aadd(aHelpEsp,"de Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema efectua la" )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del promedio del mes " )
	Aadd(aHelpEsp,"(el calculo del promedio mensual se " )
	Aadd(aHelpEsp,"efectua a partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - " )
	Aadd(aHelpEsp,"Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso de que el criterio de " )
	Aadd(aHelpEsp,"conversion a debito sea diferente del a " )
	Aadd(aHelpEsp,"credito, no es aconsejable que se realicen " )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de " )
	Aadd(aHelpEsp,"asientos contables (debito / credito)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta => 11101 " )
	Aadd(aHelpEsp,"Crit. debito => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. credito => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble, el" )
	Aadd(aHelpEsp,"sistema considerara el criterio de" )
	Aadd(aHelpEsp,"la ultima cuenta digitada. En caso de " )
	Aadd(aHelpEsp,"que no sea conveniente este " )
	Aadd(aHelpEsp,"procedimiento, cree dos lineas de " )
	Aadd(aHelpEsp,"asiento contable." )
EndIf                                                                                    

 
PutHelp( "PCT1_CVC03",aHelpPor,aHelpEng,aHelpEsp,.T. )   

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}   

Aadd(aHelpPor,"Especifica o critério de conversão a ser" )
Aadd(aHelpPor,"utilizado na conversão dos valores " )
Aadd(aHelpPor,"lançados no Lançamento Contábil. Este " )
Aadd(aHelpPor,"critério será utilizado para lançamentos" )
Aadd(aHelpPor,"a crédito na Moeda 04. Os critérios " )
Aadd(aHelpPor,"poderão ser:" )
Aadd(aHelpPor,"1 - Taxa Diária: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores pela taxa diária " )
Aadd(aHelpPor,"(informada no Cadastro de Câmbio)" )
Aadd(aHelpPor,"2 - Taxa Média: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores utilizando a taxa " )
Aadd(aHelpPor,"da média do mês (o cálculo da média " )
Aadd(aHelpPor,"mensal é efetuado a partir do Cadastro " )
Aadd(aHelpPor,"de Câmbio)." )
Aadd(aHelpPor,"3 - Taxa Mensal: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores utilizando a taxa " )
Aadd(aHelpPor,"do último dia do mês (informada no " )
Aadd(aHelpPor,"Cadastro de Câmbio)." )
Aadd(aHelpPor,"4 - Informada: informado no lança" )
Aadd(aHelpPor,"mento - o valor da conversão é informada" )
Aadd(aHelpPor,"na hora do lançamento." )
Aadd(aHelpPor,"5 - Não tem conversao: não existe " )
Aadd(aHelpPor,"conversão para essa moeda." )
Aadd(aHelpPor,"6 - Fixo: terá sempre o mesmo valor " )
Aadd(aHelpPor,"estipulado." )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Obs: No caso do critério de conversão a " )
Aadd(aHelpPor,"débito ser diferente do crédito, não é " )
Aadd(aHelpPor,"aconselhável que se façam lançamentos " )
Aadd(aHelpPor,"contábeis de partida dobrada." )
Aadd(aHelpPor,"Nesta situação crie duas linhas de " )
Aadd(aHelpPor,"lançamentos contábeis (Déb. / Créd.)" )
Aadd(aHelpPor,"Exemplo" )
Aadd(aHelpPor,":" )
Aadd(aHelpPor,"Conta => 11101 " )
Aadd(aHelpPor,"Crit. Déb. => 1 (Diário)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 21101" )
Aadd(aHelpPor,"Crit. Créd. => 2 (Mensal)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"No lançamento contábil partida dobrada, " )
Aadd(aHelpPor,"o sistema considerará o critério da " )
Aadd(aHelpPor,"última conta digitada. Caso não seja " )
Aadd(aHelpPor,"conveniente esse procedimento, crie duas " )
Aadd(aHelpPor,"linhas de lançamento contábil. " )

IF cPaisLoc == "MEX" 
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable." )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a abono en la Moneda 04. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua " )
	Aadd(aHelpEsp,"la conversion de los valores por " )
	Aadd(aHelpEsp,"la tasa diaria (informada en el Archivo " )
	Aadd(aHelpEsp,"de Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema" )
	Aadd(aHelpEsp,"efectua la conversion de los valores " )
	Aadd(aHelpEsp,"utilizando la tasa del promedio del mes " )
	Aadd(aHelpEsp,"(el calculo del promedio mensual se " )
	Aadd(aHelpEsp,"efectua a partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa el ultimo dia del mes (informada en" )
	Aadd(aHelpEsp,"el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso de que el criterio de " )
	Aadd(aHelpEsp,"conversion a cargo sea diferente del a " )
	Aadd(aHelpEsp,"abono, no es aconsejable que se realicen" )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de" )
	Aadd(aHelpEsp,"asientos contables (Cargo / Abono)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta => 11101 " )
	Aadd(aHelpEsp,"Crit. Cargo => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. Abono => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida " )
	Aadd(aHelpEsp,"doble, el sistema considerara el " )
	Aadd(aHelpEsp,"criterio de la ultima cuenta digitada. " )
	Aadd(aHelpEsp,"En caso de que no sea conveniente este " )
	Aadd(aHelpEsp,"procedimiento, cree dos lineas de " )
	Aadd(aHelpEsp,"asiento contable." )
else
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable." )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a credito en la Moneda 04. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua " )
	Aadd(aHelpEsp,"la conversion de los valores por " )
	Aadd(aHelpEsp,"la tasa diaria (informada en el Archivo " )
	Aadd(aHelpEsp,"de Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema" )
	Aadd(aHelpEsp,"efectua la conversion de los valores " )
	Aadd(aHelpEsp,"utilizando la tasa del promedio del mes " )
	Aadd(aHelpEsp,"(el calculo del promedio mensual se " )
	Aadd(aHelpEsp,"efectua a partir del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa el ultimo dia del mes (informada en" )
	Aadd(aHelpEsp,"el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso de que el criterio de " )
	Aadd(aHelpEsp,"conversion a debito sea diferente del a " )
	Aadd(aHelpEsp,"credito, no es aconsejable que se realicen" )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de" )
	Aadd(aHelpEsp,"asientos contables (debito / credito)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta => 11101 " )
	Aadd(aHelpEsp,"Crit. debito => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. credito => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida " )
	Aadd(aHelpEsp,"doble, el sistema considerara el " )
	Aadd(aHelpEsp,"criterio de la ultima cuenta digitada. " )
	Aadd(aHelpEsp,"En caso de que no sea conveniente este " )
	Aadd(aHelpEsp,"procedimiento, cree dos lineas de " )
	Aadd(aHelpEsp,"asiento contable." )
EndIf                                                                                    

 
PutHelp( "PCT1_CVC04",aHelpPor,aHelpEng,aHelpEsp,.T. )   

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}   

Aadd(aHelpPor,"Especifica o critério de conversão a ser" )
Aadd(aHelpPor,"utilizado na conversão dos valores " )
Aadd(aHelpPor,"lançados no Lançamento Contábil. Este " )
Aadd(aHelpPor,"critério será utilizado para lançamentos" )
Aadd(aHelpPor,"a crédito na Moeda 05. Os critérios " )
Aadd(aHelpPor,"poderão ser:" )
Aadd(aHelpPor,"1 - Taxa Diária: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores pela taxa diária " )
Aadd(aHelpPor,"(informada no Cadastro de Câmbio)" )
Aadd(aHelpPor,"2 - Taxa Média: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores utilizando a taxa " )
Aadd(aHelpPor,"da média do mês (o cálculo da média " )
Aadd(aHelpPor,"mensal é efetuado a partir do Cadastro " )
Aadd(aHelpPor,"de Câmbio)." )
Aadd(aHelpPor,"3 - Taxa Mensal: o sistema efetua a " )
Aadd(aHelpPor,"conversão dos valores utilizando a taxa " )
Aadd(aHelpPor,"do último dia do mês (informada no " )
Aadd(aHelpPor,"Cadastro de Câmbio)." )
Aadd(aHelpPor,"4 - Informada: informado no lançamento -" )
Aadd(aHelpPor,"o valor da conversão é informada na hora" )
Aadd(aHelpPor,"do lançamento." )
Aadd(aHelpPor,"5 - Não tem conversao: não existe " )
Aadd(aHelpPor,"conversão para essa moeda." )
Aadd(aHelpPor,"6 - Fixo: terá sempre o mesmo valor" )
Aadd(aHelpPor,"estipulado." )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Obs: No caso do critério de conversão a " )
Aadd(aHelpPor,"débito ser diferente do crédito, não é " )
Aadd(aHelpPor,"conselhável que se façam lançamentos " )
Aadd(aHelpPor,"contábeis de partida dobrada." )
Aadd(aHelpPor,"Nesta situação crie duas linhas de " )
Aadd(aHelpPor,"lançamentos contábeis (Déb. / Créd.)" )
Aadd(aHelpPor,"Exemplo" )
Aadd(aHelpPor,":" )
Aadd(aHelpPor,"Conta => 11101 " )
Aadd(aHelpPor,"Crit. Déb. => 1 (Diário)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Conta => 21101" )
Aadd(aHelpPor,"Crit. Créd. => 2 (Mensal)" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"No lançamento contábil partida dobrada," )
Aadd(aHelpPor,"o sistema considerará o critério da " )
Aadd(aHelpPor,"última conta digitada. Caso não seja " )
Aadd(aHelpPor,"conveniente esse procedimento, crie duas " )
Aadd(aHelpPor,"linhas de lançamento contábil.  " )      

IF cPaisLoc == "MEX" 
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable." )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a abono en la Moneda 05. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores por la tasa " )
	Aadd(aHelpEsp,"diaria (informada en el Archivo de " )
	Aadd(aHelpEsp,"Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema efectua la" )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del promedio del mes (el calculo " )
	Aadd(aHelpEsp,"del promedio mensual se efectua a partir" )
	Aadd(aHelpEsp,"del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso de que el criterio de " )
	Aadd(aHelpEsp,"conversion a cargo sea diferente del a " )
	Aadd(aHelpEsp,"abono, no es aconsejable que se realicen" )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de " )
	Aadd(aHelpEsp,"asientos contables (Cargo / Abono)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta => 11101 " )
	Aadd(aHelpEsp,"Crit. Cargo => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. Abono => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble,el " )
	Aadd(aHelpEsp,"sistema considerara el criterio dela " )
	Aadd(aHelpEsp,"ultima cuenta digitada. En caso de que " )
	Aadd(aHelpEsp,"no sea conveniente este procedimiento, " )
	Aadd(aHelpEsp,"cree dos lineas de asiento contable." )
else
	Aadd(aHelpEsp,"Especifica el criterio de conversion que" )
	Aadd(aHelpEsp,"se utilizara en la conversion de los " )
	Aadd(aHelpEsp,"valores emitidos en el asiento contable." )
	Aadd(aHelpEsp,"Este criterio se utilizara para asientos " )
	Aadd(aHelpEsp,"a credito en la Moneda 05. Los criterios " )
	Aadd(aHelpEsp,"podran ser:" )
	Aadd(aHelpEsp,"1 - Tasa Diaria: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores por la tasa " )
	Aadd(aHelpEsp,"diaria (informada en el Archivo de " )
	Aadd(aHelpEsp,"Cambio)" )
	Aadd(aHelpEsp,"2 - Tasa Promedio: el sistema efectua la" )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del promedio del mes (el calculo " )
	Aadd(aHelpEsp,"del promedio mensual se efectua a partir" )
	Aadd(aHelpEsp,"del Archivo de Cambio)." )
	Aadd(aHelpEsp,"3 - Tasa Mensual: el sistema efectua la " )
	Aadd(aHelpEsp,"conversion de los valores utilizando la " )
	Aadd(aHelpEsp,"tasa del ultimo dia del mes (informada " )
	Aadd(aHelpEsp,"en el Archivo de Cambio)." )
	Aadd(aHelpEsp,"4 - Informada: informado en el asiento -" )
	Aadd(aHelpEsp,"el valor de la conversion se informa en " )
	Aadd(aHelpEsp,"la hora del  asiento." )
	Aadd(aHelpEsp,"5 - No tiene conversion: no existe " )
	Aadd(aHelpEsp,"conversion para esa moneda." )
	Aadd(aHelpEsp,"6 - Fijo: tendra siempre el mismo valor " )
	Aadd(aHelpEsp,"estipulado." )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Obs: Obs: En caso de que el criterio de " )
	Aadd(aHelpEsp,"conversion a debito sea diferente del a " )
	Aadd(aHelpEsp,"credito, no es aconsejable que se realicen" )
	Aadd(aHelpEsp,"asientos contables de partida doble. En " )
	Aadd(aHelpEsp,"esta situacion cree dos lineas de " )
	Aadd(aHelpEsp,"asientos contables (debito / credito)" )
	Aadd(aHelpEsp,"Ejemplo:" )
	Aadd(aHelpEsp,"Cuenta => 11101 " )
	Aadd(aHelpEsp,"Crit. debito => 1 (Diario)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"Cuenta => 21101" )
	Aadd(aHelpEsp,"Crit. credito => 2 (Mensual)" )
	Aadd(aHelpEsp,"" )
	Aadd(aHelpEsp,"En el asiento contable partida doble,el " )
	Aadd(aHelpEsp,"sistema considerara el criterio dela " )
	Aadd(aHelpEsp,"ultima cuenta digitada. En caso de que " )
	Aadd(aHelpEsp,"no sea conveniente este procedimiento, " )
	Aadd(aHelpEsp,"cree dos lineas de asiento contable." )
EndIf                                                                                    

 
PutHelp( "PCT1_CVC05",aHelpPor,aHelpEng,aHelpEsp,.T. )   

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}   

Aadd(aHelpPor,"Aceita a 5a. entidade contábil a débito " )      
Aadd(aHelpPor,"ou a crédito.                           " )      

IF cPaisLoc == "MEX" 
	Aadd(aHelpEsp,"Acepta el 5o. ente contable a cargo o " )
	Aadd(aHelpEsp,"a abono." )
else
	Aadd(aHelpEsp,"Acepta el 5o. ente contable a debito o " )
	Aadd(aHelpEsp,"a credito." )
EndIf                                                                                    

 
PutHelp( "PCT1_ACET05",aHelpPor,aHelpEng,aHelpEsp,.T. )   

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}   

Aadd(aHelpPor,"Define se a entidade contábil 05 a " )      
Aadd(aHelpPor,"débito ou a crédito serão obrigatórias. " )           

IF cPaisLoc == "MEX" 
	Aadd(aHelpEsp,"Define si el ente contable 05 a cargo o " )
	Aadd(aHelpEsp,"a abono sera obligatorio.               " )
else
	Aadd(aHelpEsp,"Define si el ente contable 05 a debito o " )
	Aadd(aHelpEsp,"a credito sera obligatorio.               " )
EndIf                                                                                    

 
PutHelp( "PCT1_05OBRG",aHelpPor,aHelpEng,aHelpEsp,.T. )   

aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}


Aadd(aHelpPor,"Identificador do tipo a ser utilizado no" )
Aadd(aHelpPor,"Lalur:" )
Aadd(aHelpPor,"0 = Não pertence ao Lalur" )
Aadd(aHelpPor,"1 = Adição Dedutível" )
Aadd(aHelpPor,"2 = Adição Idedutível" )
Aadd(aHelpPor,"3 = Exclusão Dedutível" )
Aadd(aHelpPor,"4 = Exclusão Idedutível" )
Aadd(aHelpPor,"5 = Lucro antes Contr Social.     " )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"" )
Aadd(aHelpPor,"Esta identificação é válida ao se " )
Aadd(aHelpPor,"utilizar a integração do módulo " )
Aadd(aHelpPor,"Contabilidade Gerencial com o sistema " )
Aadd(aHelpPor,"LALUR da LALUR Ltda." )
Aadd(aHelpEng,"Identifier of the type to be used in the" )
Aadd(aHelpEng,"Lalur:" )
Aadd(aHelpEng,"0 = Doesn´t belong to Lalur" )
Aadd(aHelpEng,"1 = Deductible addition" )
Aadd(aHelpEng,"2 = Non-deductible addition" )
Aadd(aHelpEng,"3 = Deductible exclusion" )
Aadd(aHelpEng,"4 = Non-deductible exclusion" )
Aadd(aHelpEng,"5 = Profit before social contribution" )
Aadd(aHelpEng,"This identification is valid when you " )
Aadd(aHelpEng,"use the integration of the Management " )
Aadd(aHelpEng,"Accounting with the LALUR of LALUR Ltda. " )
Aadd(aHelpEsp,"Identificador del tipo que se utiliza en" )
Aadd(aHelpEsp,"el Lalur:" )
Aadd(aHelpEsp,"0- No pertenece al Lalur." )
Aadd(aHelpEsp,"1 = Adicion Deductible" )
Aadd(aHelpEsp,"2 = Adicion Indeductible" )
Aadd(aHelpEsp,"3 = Borrado Deductible" )
Aadd(aHelpEsp,"4 = Borrado Indeductible" )
Aadd(aHelpEsp,"5 = Ganancia antes Contr. Social.     " )
Aadd(aHelpEsp,"" )
Aadd(aHelpEsp,"" )
Aadd(aHelpEsp,"Esta identificacion es valida cuando se " )
Aadd(aHelpEsp,"utiliza la integracion del modulo " )
Aadd(aHelpEsp,"Contabilidad de gestion con el sistema " )
Aadd(aHelpEsp,"LALUR de LALUR Ltda." )
PutHelp( "PCT1_LALUR",aHelpPor,aHelpEng,aHelpEsp,.T. )   
aHelpPor	:= {}
aHelpEng	:= {}
aHelpEsp	:= {}
   
return .T.                                                      

//-------------------------------------
/*	Modelo do Browser
@author  	Leandro Ferreira Paulino
@version 	P10 R1.4
@build		7.00.101202A
@since 		17/08/2011
@return 	oModel Objeto do Modelo	 */
//-------------------------------------
Static Function ModelDef()
Local oModel 	:= Nil
Local oStruCT1	:= Nil

If GetBuild() >= '7.00.101202A'
	
	oStruCT1 := FwFormStruct(1,"CT1")        

	// Tira validação da estrutura
	oStruCT1:SetProperty( '*'         , MODEL_FIELD_VALID, { || .T. } )
	oStruCT1:SetProperty( '*'         , MODEL_FIELD_WHEN,  NIL )             

	oModel:= MpFormModel():New("CTBA020",/*Pre-Validacao*/, /*Pos-Validacao*/, /*Commit*/,/*Cancel*/)
	oModel:AddFields("CTBA020_CT1",Nil,oStruCT1,/*Pre-Validacao*/,/*Pos-Validacao*/,/*Carga*/)
	oModel:SetDescription(STR0006) // Metodo XML
	oModel:GetModel("CTBA020_CT1"):SetDescription(STR0006)
	oModel:SetPrimaryKey({"CC1_CONTA"})
	
EndIf

Return ( oModel )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INTEGDEF  ºAutor  ³Wilson.Godoi         º Data ³ 23/01/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para a interação com EAI                             º±±
±±º          ³envio e recebimento                                         º±±
±±º          ³Cod.Conta       ( CT1_CONTA)                                º±±
±±º          ³Descr.Moeda     ( CT1_DESC01)                               º±±
±±º          ³Classe da Conta ( CT1_CLASSE)                               º±±
±±º          ³Cond.Normal     ( CT1_NORMAL)                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
Static Function IntegDef( cXml, nType, cTypeMsg )  
	Local aRet := {}
	aRet:= CTBI020( cXml, nType, cTypeMsg )
Return aRet 

//-----------------------------------------------------
/*/	Valid após a confirmação de inclusão/alteração/exclusão
@author Felipe Machado de Oliveira
@version P11
@since 18/04/2013
/*/
//------------------------------------------------------
Static Function IntProtGfe(nOperation)
Local lRet := .T.
Local lIntGFE := SuperGetMv("MV_INTGFE",.F.,.F.)
Local cIntGFE2 := SuperGetMv("MV_INTGFE2",.F.,"2")

If lIntGFE == .T. .And. cIntGFE2 $ "1"
	If !InterGUE(nOperation)
		lRet := .F.
	EndIf
EndIf
	
Return lRet
//-----------------------------------------------------
/*/	Integra a tabela CT1(Protheus) com GUE(SIGAGFE) a cada registro novo
@author Felipe Machado de Oliveira
@version P11
@since 18/04/2013
/*/
//------------------------------------------------------
Static Function InterGUE(nOperation)
	Local aAreaGUE := GUE->( GetArea() )
	Local lRet :=  .T.
	Local oModelGUE := FWLoadModel("GFEA090")
	Local nTpOpSetad
	Local cMsg
	
	dbSelectArea("GUE")
	GUE->( dbSetOrder(1) )
	GUE->( dbSeek( xFilial("GUE")+M->CT1_CONTA ) )
	If !GUE->( Eof() ) .And. GUE->GUE_FILIAL == xFilial("GUE");
						 .And. AllTrim(GUE->GUE_CTACTB) == AllTrim(M->CT1_CONTA)

		oModelGUE:SetOperation( MODEL_OPERATION_UPDATE )
		nTpOpSetad := MODEL_OPERATION_UPDATE
		
	Else	
		oModelGUE:SetOperation( MODEL_OPERATION_INSERT )
		nTpOpSetad := MODEL_OPERATION_INSERT
		
	EndIf
	
	oModelGUE:Activate()
	
	If nOperation <> MODEL_OPERATION_DELETE
		oModelGUE:SetValue( 'GFEA090_GUE', 'GUE_TITULO'  , M->CT1_DESC01 )
		
		If nTpOpSetad == MODEL_OPERATION_UPDATE
			If nOperation == MODEL_OPERATION_INSERT
				oModelGUE:LoadValue( 'GFEA090_GUE', 'GUE_SIT', "1" )
			Endif
		Else
			oModelGUE:SetValue( 'GFEA090_GUE', 'GUE_FILIAL', xFilial("CT1") )
			oModelGUE:SetValue( 'GFEA090_GUE', 'GUE_CTACTB', M->CT1_CONTA )
		EndIf
		
	Else
		If nTpOpSetad <> MODEL_OPERATION_INSERT
			oModelGUE:LoadValue( "GFEA090_GUE", "GUE_SIT", "2" )
		EndIf
	Endif
	
	If nOperation != MODEL_OPERATION_DELETE .Or. nTpOpSetad != MODEL_OPERATION_INSERT
		If oModelGUE:VldData()
			oModelGUE:CommitData()
		Else
			lRet := .F.
			cMsg := STR0066+CRLF+CRLF+oModelGUE:GetErrorMessage()[6]
		EndIf
	EndIf
	
	oModelGUE:Deactivate()
	
	If !lRet
		Help( ,, STR0057,,cMsg, 1, 0 ) //"Atenção"
	EndIf
	
	RestArea( aAreaGUE )
	
Return lRet
