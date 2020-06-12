//#INCLUDE "SIGAWF.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "Wfc002.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ WFC002   ³ Autor ³ Marcelo Abe           ³ Data ³ 30.03.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta de Processos por Usuario                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Void WFC002(void)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TSTWF2()
	Local nC
	Local oDlg
	Local aItens := {}
	Local cUserName := Subs(cUsuario,7,15), cIDProcess := "", cProcess := "", cDesc := ""

	PRIVATE oUserName, oDias, oBmp, oBmp1, oBmp2, oBmp3, oBmp4, oWF
	PRIVATE aUsers 

	oWF := TWFObj()

	ChkFile("WFA")    
 
	DEFINE MSDIALOG oDlg TITLE STR0001 From 0,0 To 260,515 PIXEL
	
	@ 110,06 BITMAP oBmp RESNAME "ENABLE" oF oDlg SIZE 20,20 NOBORDER PIXEL  
	@ 110,15 SAY STR0008 of oDlg SIZE 100,10 PIXEL  
	@ 120,06 BITMAP oBmp RESNAME "DISABLE" oF oDlg SIZE 20,20 NOBORDER PIXEL 
	@ 120,15 SAY STR0009 of oDlg SIZE 100,10 PIXEL 
	@  15,06 SAY STR0002 of oDlg PIXEL SIZE 20,10

	If ( __cUserID == "000000" )
		aUsers  := AllUsers(.T.)
		for nC := 1 to len( aUsers )
			if ( aUsers[nC,1,1] == __cUserID )
				cUserName := aUsers[nC,1,2]
			end
			AAdd( aItens, aUsers[nC,1,2] )
		next 
		@ 15, 50 COMBOBOX oUserName VAR cUserName ITEMS aItens PIXEL SIZE 110,10 OF oDlg;
		ON CHANGE WFC002Ref(cUserName)
	else
		@ 15, 50 MSGET oUserName VAR cUserName SIZE 92,10 OF oDlg PIXEL
//		oUserName:bLostFocus := {|| WFC002Ref(cUserName) }
		oUserName:SetDisable()
	end

	@ 28,6 SAY STR0003 of oDlg  PIXEL  SIZE 100,10
	@ 35,6 LISTBOX oDias FIELDS HEADER " ", STR0004, STR0005, STR0006, STR0007	FIELDSIZES 14, 50,120,50,50 SIZE 250, 70 PIXEL OF oDlg

	WFC002Ref(cUserName)
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT ( oUserName:SetFocus(), EnchoiceBar(oDlg, {|| oDlg:End() },{|| oDlg:End()} ) )

	if Select( "WFA" ) <> 0  
		WFA->(dbCloseArea())
	end
Return .T.

Static Function WFC002Ref(cUserName)
	Local nC, nPos
	Local oOk, oNo
	Local aDias := {}, aValues := {}
	Local cProcess, cDesc, cCodUser, cValFile, cWFAFindKey, cWF3FindKey

	oOk := LoadBitmap( GetResources(), "ENABLE" )
	oNo := LoadBitmap( GetResources(), "DISABLE" )

	if ( __cUserID == "000000" )
		for nC := 1 to Len(aUsers)
			if ( Alltrim(aUsers[nC][1][2]) == Alltrim(cUserName) )
				cCodUser := aUsers[nC][1][1] 
				exit
			end
		next 
	else  
		cCoduser := __cUserID
	end

	if empty( cCodUser )
		help("",1,"WFUSERINV")  
		Return .f. 
	end
         
	//Preenche o ListBox com os Processos do Usuário corrente
	dbSelectArea("WFA")          
	dbSetOrder(3) //filial+Usuario+Tipo+Ident
//  dbSeek(xFilial("WFA")+cCodUser+'3')
	cWFAFindKey := xFilial("WFA") + cCodUser
	dbSeek( cWFAFindKey )

	while !eof() .and. ( WFA_FILIAL + WFA_USRSIG == cWFAFindKey )
		
		if file( cValFile := lower( oWF:cProcessDir + AllTrim( WFA_IDENT ) + ".val" ) )
			aValues := WFLoadValFile( cValFile )
			if ( nPos := AScan( aValues, { |x| x[1] == "cSubject" } ) ) > 0
				cDesc := aValues[ nPos,3 ]
			end
			aValues := nil

			dbSelectArea("WF3")   
			dbSetOrder(1)
			cWF3FindKey := xFilial("WF3") + upper( PadR( left( WFA->WFA_IDENT,5 ) + "." + substr( WFA->WFA_IDENT,6,2 ),100 ) )
			dbSeek( cWF3FindKey )
			cProcess := WF3_PROC
		
		  	dbSelectArea("WFA")
			Aadd(aDias,{ WFA_TIPO == WF_ARCHIVE, cProcess, cDesc, DTOC(WFA_DATA), WFA_HORA } )
	  	end
		dbSkip()                                       
	end
	
	if len(aDias) == 0 
		aadd(aDias,{.t.,'','','','' })
	end
  
//	aDias := ASort( aDias,,,{ |x,y| x[1] > y[1] .and. x[4] < y[4] } )
	aDias := ASort( aDias,,,{ |x,y| x[1] < y[1] } )
	oDias:SetArray(aDias)
	oDias:bLine := {|| {iif(aDias[oDias:nAt,1],oOK,oNo),aDias[oDias:nAt,2],aDias[oDias:nAt,3],aDias[oDias:nAt,4],aDias[oDias:nAt,5]} }
	oDias:Refresh()
	oDias:GoTop()
Return .T.

