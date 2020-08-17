#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ QESPG014 บ Autor ณ Eduardo Yorgaciov    บ Data ณ 01/09/2004  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณ Rotina para gerar arquivo TXT (delimitado/largura fixa) com  บฑฑ
ฑฑบ          ณ a lista de acessos de usuarios do sistema, para posteriormen-บฑฑ
ฑฑบ          ณ te ser importada em uma planilha Excel, Access, etc...       บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Atualizacoes sofridas desde a construcao inicial                        บฑฑ
ฑฑฬอออออออออออออออออออัออออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                   ณ        ณ                                            บฑฑ
ฑฑศอออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function QESPG014()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local 	oDlg,oGrpMsg,oGrpTp,oRadioTp,oSayMsg,oFonte14
Local	cMsg  := "Este programa tem como objetivo, gerar um arquivo texto (delimitado ou fixo) " 
		cMsg  := cMsg + "com todos os acessos de usuแrios cadastrados no sistema (sigaadv.pss)."
Private	nTipo 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Apontador de Rotinas...                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//u_AponRot()

oDlg						:= MSDIALOG():Create()
oDlg	:cName				:= "oDlg"
oDlg	:cCaption			:= OemToAnsi("Acessos [Gerar TXT]")
oDlg	:nLeft				:= 0
oDlg	:nTop				:= 0
oDlg	:nWidth				:= 421
oDlg	:nHeight			:= 201
oDlg	:lShowHint			:= .F.
oDlg	:lCentered			:= .T.

oFonte14	:= TFont():New("Verdana",,14,,.F.,,,,.F.,.F.)

oGrpMsg						:= TGROUP():Create(oDlg)
oGrpMsg	:cName				:= "oGrpMsg"
oGrpMsg	:nLeft				:= 7
oGrpMsg	:nTop				:= 5
oGrpMsg	:nWidth				:= 400
oGrpMsg	:nHeight			:= 93
oGrpMsg	:lShowHint 			:= .F.
oGrpMsg	:lReadOnly 			:= .F.
oGrpMsg	:Align 				:= 0
oGrpMsg	:lVisibleControl 	:= .T.

oSayMsg						:= TSAY():Create(oDlg)
oSayMsg	:cName				:= "oSayMsg"
oSayMsg	:cCaption 			:= OemToAnsi(cMsg)
oSayMsg	:nLeft				:= 14
oSayMsg	:nTop 				:= 14
oSayMsg	:nWidth 			:= 383
oSayMsg	:nHeight 			:= 76
oSayMsg	:lShowHint 			:= .F.
oSayMsg	:lReadOnly 			:= .F.
oSayMsg	:Align 				:= 0
oSayMsg	:cVariable 			:= "cMsg"
oSayMsg	:bSetGet 			:= {|u| If(PCount() > 0,cMsg:=u,cMsg) }
oSayMsg	:lVisibleControl 	:= .T.
oSayMsg	:lWordWrap 			:= .T.
oSayMsg	:lTransparent 		:= .T.
oSayMsg	:oFont				:= oFonte14

oGrpTp						:= TGROUP():Create(oDlg)
oGrpTp	:cName				:= "oGrpTp"
oGrpTp	:cCaption 			:= OemToAnsi("Tipo de arquivo TXT")
oGrpTp	:nLeft 				:= 7
oGrpTp	:nTop 				:= 104
oGrpTp	:nWidth 			:= 270
oGrpTp	:nHeight 			:= 63
oGrpTp	:lShowHint 			:= .F.
oGrpTp	:lReadOnly 			:= .F.
oGrpTp	:Align 				:= 0
oGrpTp	:lVisibleControl	:= .T.

oRadioTp					:= TRADMENU():Create(oDlg)
oRadioTp:cName 				:= "oRadioTp"
oRadioTp:nLeft 				:= 14
oRadioTp:nTop 				:= 121
oRadioTp:nWidth 			:= 100
oRadioTp:nHeight 			:= 42
oRadioTp:lShowHint 			:= .F.
oRadioTp:lReadOnly 			:= .F.
oRadioTp:Align 				:= 0
oRadioTp:cVariable 			:= "nTipo"
oRadioTp:bSetGet 			:= {|u| If(PCount()>0,nTipo:=u,nTipo) }
oRadioTp:lVisibleControl 	:= .T.
oRadioTp:nOption 			:= 0
oRadioTp:aItems 			:= {"Delimitado","Largura Fixa"}
oRadioTp:oFont				:= oFonte14

nTipo := 1
oRadioTp:Refresh()

@ 4.95, 36	BUTTON "&Gerar Arquivo"	SIZE 60,17 ACTION ( StartProc(), oDlg:End() )
@ 6.6 , 36	BUTTON "&Sair"			SIZE 60,17 ACTION ( oDlg:End() )

oDlg:Activate()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบ Funcao   ณ StartProc บ Autor ณ Eduardo Yorgaciov    บ Data ณ 02/09/2004 บฑฑ
ฑฑศออออออออออฯอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function StartProc()

	Private oProcess
	Private aUsers		:= {}
	Private aGroups		:= {}
	Private aModulos	:= {}
	Private aSigamat	:= {}
	Private	cArqLog := "acessos.txt"
	Private nHandle	:= u_GrvArq(cArqLog,,"C",)
	
	If !Empty(nHandle) .and. nHandle <> -1 
		MsgRun( OemToAnsi("Preparando base de usuarios ..."  ),,			{|| aUsers := AllUsers(.t.)})
		MsgRun( OemToAnsi("Carregando informa็๕es do sigamat.emp..."  ),,	{|| LoadSM0()})
		MsgRun( OemToAnsi("Carregando informa็๕es dos m๓dulos..."  ),,		{|| aModulos := RetModName()})
		
		oProcess := MsNewProcess():New({|lEnd| GeraTxt(oProcess,.f.)},"","",.T.)
		oProcess:Activate()				
	Endif
	
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraTxt  บ Autor ณ Eduardo Yorgaciov   บ Data ณ 02/09/2004 บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GeraTxt(oObj)

	Local	cLinha,u,e,m
	Local	aEmps := {}
	Local	aMods := {}
	
	oObj:SetRegua1(Len(aUsers))
	
	For U = 2 to Len(aUsers)    
	    		
		oObj:IncRegua1( alltrim(aUsers[U][01][02]) + ' - ' + upper(aUsers[U][01][04]) )
		
		aEmps	:= aUsers[U][02][06]
		aMods	:= aUsers[U][03]	
        
        If !aUsers[U][01][17]
			If AScan( aEmps, "@@@@") = 0		
				oObj:SetRegua2(Len(aEmps)*Len(aMods))
				For E = 1 to Len(aEmps)
					For M = 1 to Len(aMods)
						oObj:IncRegua2( "Empresa/Filial : " + left(aEmps[E],2) + "/" + right(aEmps[E],2) + "   Modulo : " + left(aMods[M],2) )
						If upper(substr(aMods[M],3,1)) <> 'X'
							GravaLin(	aUsers[U][01][01], 	;	// ID
										aUsers[U][01][02], 	;	// Usuario
										aUsers[U][01][04], 	;	// Nome Completo
										left(aEmps[E],2),		;	// Empresa
										right(aEmps[E],2),		;	// Filial
										left(aMods[M],2),		;	// Modulo
										substr(aMods[M],3,1),  ;	// Nivel
										substr(aMods[M],4),   	;	// Menu
										aUsers[U][02][03],		;	// Relato
										)						
						Endif
					Next M
			    Next E		    	    
			Else
				oObj:SetRegua2(Len(aMods))
				For M = 1 to Len(aMods)		
					oObj:IncRegua2( "Empresa/Filial : @@/@@   Modulo : " + left(aMods[M],2) )
					If upper(substr(aMods[M],3,1)) <> 'X'
						GravaLin(	aUsers[U][01][01], 	;	// ID
									aUsers[U][01][02], 	;	// Usuario
									aUsers[U][01][04], 	;	// Nome Completo
									'@@',					;	// Empresa
									'@@',					;	// Filial
									left(aMods[M],2),		;	// Modulo
									substr(aMods[M],3,1),  ;	// Nivel
									substr(aMods[M],4),   	;	// Menu
									aUsers[U][02][03]		;	// Relato
									)						
					Endif
				Next M
			Endif
		Else
			oObj:SetRegua2(1)
			GravaLin(	aUsers[U][01][01], 	;	// ID
						aUsers[U][01][02], 	;	// Usuario
						aUsers[U][01][04], 	;	// Nome Completo
						'USUARIO BLOQUEADO',	;	// Empresa
						'USUARIO BLOQUEADO',	;	// Filial
						'--',					;	// Modulo
						'X',  					;	// Nivel
						replicate('-',40),		;	// Menu
						replicate('-',100),		;	// Relato
						)
			oObj:IncRegua2( "Empresa/Filial : XX/XX   Modulo : XX" )
		Endif
	Next U
	
	u_GrvArq(cArqLog,,"F",nHandle)	
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ GravaLin บ Autor ณ Eduardo Yorgaciov   บ Data ณ 02/09/2004 บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GravaLin( cID, cUser, cNome, cEmp, cFil, cMod, cNivel, cMenu, cRelato )
	
	Local cEmpNome := iif(ascan(aSigamat,{|x| x[1] == cEmp+cFil}) <> 0,  aSigamat[ascan(aSigamat,{|x| x[1] == cEmp+cFil})][2],  space(15))
	Local cFilNome := iif(ascan(aSigamat,{|x| x[1] == cEmp+cFil}) <> 0,  aSigamat[ascan(aSigamat,{|x| x[1] == cEmp+cFil})][3],  space(15))
	Local cModNome := iif(ascan(aModulos,{|x| x[1] = val(cMod)}) <> 0,  aModulos[ascan(aModulos,{|x| x[1] = val(cMod)})][3], space(35))

	If nTipo = 1
		cLinha  := 	Alltrim( cID     )	+ '^' + ;
					Alltrim( cUser   )	+ '^' + ;
					Alltrim( cNome   )	+ '^' + ;
					iif( cEmp == '@@',  Alltrim( '[TODAS AS EMPRESAS] ' ),  Alltrim( '[' + cEmp + '] ' + cEmpNome ) )	+ '^' +;
					iif( cEmp == '@@',  Alltrim( '[TODAS AS FILIAIS]  ' ),  Alltrim( '[' + cFil + '] ' + cFilNome )	)	+ '^' +;
					Alltrim( '[' + cMod + '] ' + cModNome )	+ '^' + ;
					Alltrim( cNivel  )	+ '^' + ;
					Alltrim( cMenu   )	+ '^' + ;
					Alltrim( cRelato )
	Else
		cLinha  := 	substr( cID		, 1, 6	) + ;
					substr( cUser	, 1, 15	) + ;
					substr( cNome	, 1, 30	) + ;
					iif( cEmp == '@@', substr( '[TODAS AS EMPRESAS] ', 1, 20), substr('['+cEmp+'] '+cEmpNome, 1, 20))	+ ;
					iif( cEmp == '@@', substr( '[TODAS AS FILIAIS]  ', 1, 20), substr('['+cFil+'] '+cFilNome, 1, 20))	+ ;
					('['+cMod+'] '+ cModNome) + space(40-Len('['+cMod+'] '+cModNome)) + ;
					substr( cNivel	, 1, 1   ) + ;
					substr( cMenu	, 1, 40  ) + ;
					substr( cRelato	, 1, 100 )
	Endif
	
	u_GrvArq(cArqLog,cLinha,"G",nHandle)
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ LoadEmp  บ Autor ณ Eduardo Yorgaciov   บ Data ณ 02/09/2004 บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function LoadSM0()
    
    Local cSaveAlias	:= Alias()
    Local cSaveIdx		:= IndexOrd()
    Local cSavePos		:= Recno()
    
	dbSelectArea("SM0")
	dbSetOrder(1)
	
	dbGotop()
	While !SM0->(eof())
		AADD(aSigamat ,{ SM0->M0_CODIGO+SM0->M0_CODFIL, Upper(M0_NOME), Upper(M0_FILIAL) })
		dbSkip()
	End
	
    dbSelectArea(cSaveAlias)
    dbSetOrder(cSaveIdx)
    dbGoto(cSavePos)    
    
Return