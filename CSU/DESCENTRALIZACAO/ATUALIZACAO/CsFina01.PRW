#Include "Protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSFINA01 ºAutor  ³Microsiga           º Data ³  02/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSFINA01()

ChkFile("SZI")

PRIVATE cMarca  	:= GetMark()
PRIVATE cUsr	    := Space(06) //CriaVar("ZI_USUARIO",.F.)
PRIVATE cSolic 		:= Space(30) //CriaVar("ZI_NOMEUSR")
Private aIndNome    := {}

PRIVATE nQtdTit 	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa array com as moedas existentes.						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

While .T.
	
	nOpca := 0
	
	DEFINE MSDIALOG oDlg TITLE "Informe Solicitante" FROM 9,0 To 20,40 OF oMainWnd
	@ 1.0, 1.5 	Say "Usuario : "  // "Cliente : "
	@ 1.0, 5.5	MSGET cUsr F3 "USR" Picture "@9" SIZE 50,10 VALID fVldUsr(cUsr) of oDlg
	@ 2.0, 1.5 	Say "Solicitante : " // "Loja : "
	@ 2.0, 5.5	MSGET cSolic Picture "@!" SIZE 90,10 When .f. Of oDlg
	
	@ 0.3, 1 TO 4.7,17.8 OF oDlg
	
	DEFINE SBUTTON FROM 068,057.3 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 068,084.4 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpca == 0
		Exit
	Endif
	
	
	cMark      := GetMark()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria indice condicional												  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	cQuery := "SELECT '  ' [CTT_OK], CTT_CUSTO, CTT_DESC01 "+Chr(13)
	cQuery += "FROM "+RetSqlName("CTT")+Chr(13)
	cQuery += "WHERE D_E_L_E_T_ <> '*'"+Chr(13)
	cQuery += "ORDER BY CTT_CUSTO"+Chr(13)
	MemoWrite( "c:\CSFINA.sql", cQuery )
	
	__nContRes := U_MontaView(cQuery, "CTTTRB" )
	dbSelectArea("CTTTRB")
	
	cArq := CriaTrab(.f.,.f.)
	__dbCopy( cArq )
	
	CTTTRB->( dbCloseArea() )
	dbUseArea( .T. , , cArq,"CTTTRB", .T., .F. )
	
	Index On CTT_CUSTO TAG 1 To &(cArq)
	Index On CTT_DESC01 TAG 2 To &(cArq)
	
	dbSetIndex(cArq)
	
	AADD(aIndNome,{1,"Centro de Custo"})
	AADD(aIndNome,{2,"Descricao Centro de Custo"})
	
	CTTTRB->( dbSetOrder(1) )
	CTTTRB->( DbGoTop() )
	// 	Predefinir os CC já anotados para este usuário pela tabela SZI
	
	dbSelectArea("SZI")
	dbSetOrder(1)
	SZI->(dbSeek(xFilial(" SZI")+cUsr))
	
	While SZI->(!Eof() .And. ZI_USUARIO == cUsr )
		If CTTTRB->(dbSeek(SZI->ZI_CCUSTO))
			RecLock("CTTTRB", .f.)
			CTTTRB->CTT_OK := cMark
			CTTTRB->(MsUnlock())
		EndIf
		SZI->(dbSkip())
	EndDo
	
	dbSelectArea("CTTTRB")
	CTTTRB->(dbGoTop())
	//Campos de exibicao
	aCampos    := {}
	Aadd( aCampos, {"CTT_OK"     , "", ""} )
	Aadd( aCampos, {"CTT_CUSTO"  , "", "CCusto"})
	Aadd( aCampos, {"CTT_DESC01" , "", "Descricao"})
	
	//	lgravaLib  := .F.
	cCadastro  := "Cadastro de usuario x centro de custo"
	
	aRotina := menudef()
	
//	Aadd( aRotina, { "Pesquisar"     ,'U_PesqBrow("Pesquisa ","CTTTRB",1,aIndNome)'  ,0,3} )
//	Aadd( aRotina, { "Incluir"       ,'U_CsF01Inc(cMark)'     ,0,5} )
//	Aadd( aRotina, { "Total Marcado" ,'U_TotMkAll(cMark,.t.)' ,0,6} )
 //	Aadd( aRotina, { "Visualizar"    ,'U_CSF01Vis()' ,0,2} )
	cDelFunc := ".T."
	
	Markbrow("CTTTRB","CTT_OK",,aCampos,,@cMark,'U_MarkAll( "CTTTRB", "CTT_OK", cMark )',,,,)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finalize e deleta os arquivos temporarios criados.           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
ENDDO
If nOpca <> 0
	dbSelectArea("CTTTRB")
	dbSetOrder(0)
	DbCloseArea()
	Ferase(cArq+".cdx")
Endif


Return(nil)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³CSF01Vis  ³ Autor ³ Cristiano Denardi     ³ Data ³22.02.05  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Visualiza Titulo a partir da tela de Bordero				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA060	 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CSF01Vis()

Local 	aArea 		:= GetArea()
Private cCadastro 	:= OemToAnsi( "Centro de Custo" )

DbSelectArea("CTT")
DbSetOrder(1)
If DbSeek( xFilial("CTT")+CTTTRB->CTT_CUSTO)
	AxVisual( "CTT", CTT->( Recno() ), 2 )
Endif

RestArea( aArea )
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSFINA01 ºAutor  ³Microsiga           º Data ³  02/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fVldUsr(cUsr)
Local lRet := .f.
If !Empty(cUsr)
	cSolic := UsrFullName(cUsr)
	lRet := .t.
EndIf
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³TotMkAll    Autor ³ Cristian Werneck      ³ Data ³ 15/02/2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Totaliza qtos de NFe marcadas                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revisao  ³                                          ³      ³            ³±±
±±³          ³                                          ³      ³            ³±±
±±³          ³                                          ³      ³            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TotMkAll( cMark, lVisual)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a area corrente para evitar problemas de desposicionam.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAreas := GetArea()
Local oDlgTotMkAll,oGrp1,oSay2,oSay3,oGet4,oGet5,oSBtn6,oSBtn7

_nQtde := 0 // zerando os totalizadores

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no primeiro registro                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre os registros e marca o flag                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbGoTop()
While !Eof()
	if ( CTT_OK == cMark)
		_nQtde++
	EndIf
	dbSkip()
EndDo

if lVisual // visualiza resultado?
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criacao da Interface                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oDlgTotMkAll := MSDIALOG():Create()
	oDlgTotMkAll:cName := "oDlgTotMkAll"
	oDlgTotMkAll:cCaption := "Total marcado"
	oDlgTotMkAll:nLeft := 0
	oDlgTotMkAll:nTop := 0
	oDlgTotMkAll:nWidth := 305
	oDlgTotMkAll:nHeight := 183
	oDlgTotMkAll:lShowHint := .F.
	oDlgTotMkAll:lCentered := .T.
	
	oGrp1 := TGROUP():Create(oDlgTotMkAll)
	oGrp1:cName := "oGrp1"
	oGrp1:cCaption := "Totais"
	oGrp1:nLeft := 24
	oGrp1:nTop := 13
	oGrp1:nWidth := 252
	oGrp1:nHeight := 102
	oGrp1:lShowHint := .F.
	oGrp1:lReadOnly := .F.
	oGrp1:Align := 0
	oGrp1:lVisibleControl := .T.
	
	oSay2 := TSAY():Create(oDlgTotMkAll)
	oSay2:cName := "oSay2"
	oSay2:cCaption := "Quantidade"
	oSay2:nLeft := 41
	oSay2:nTop := 39
	oSay2:nWidth := 65
	oSay2:nHeight := 17
	oSay2:lShowHint := .F.
	oSay2:lReadOnly := .F.
	oSay2:Align := 0
	oSay2:lVisibleControl := .T.
	oSay2:lWordWrap := .F.
	oSay2:lTransparent := .F.
	
	oGet4 := TGET():Create(oDlgTotMkAll)
	oGet4:cName := "oGet4"
	oGet4:nLeft := 116
	oGet4:nTop := 41
	oGet4:nWidth := 121
	oGet4:nHeight := 21
	oGet4:lShowHint := .F.
	oGet4:lReadOnly := .F.
	oGet4:Align := 0
	oGet4:cVariable := "_nQtde"
	oGet4:bSetGet := {|u| If(PCount()>0,_nQtde:=u,_nQtde) }
	oGet4:lVisibleControl := .T.
	oGet4:lPassword := .F.
	oGet4:Picture := "@e 999,999"
	oGet4:lHasButton := .F.
	oGet4:bWhen := {|| .f. }

	oSBtn6 := SBUTTON():Create(oDlgTotMkAll)
	oSBtn6:cName := "oSBtn6"
	oSBtn6:nLeft := 222
	oSBtn6:nTop := 125
	oSBtn6:nWidth := 52
	oSBtn6:nHeight := 22
	oSBtn6:lShowHint := .F.
	oSBtn6:lReadOnly := .F.
	oSBtn6:Align := 0
	oSBtn6:lVisibleControl := .T.
	oSBtn6:nType := 1
	oSBtn6:bAction := {|| oDlgTotMkAll:End() }

	oDlgTotMkAll:Activate()
	
EndIf
RestArea( aAreas )
Return({ _nQtde })

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³MarkAl      Autor ³ Cristian Werneck      ³ Data ³ 15/02/2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Marcar / Desmarcar todos no MarkBrow                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Liberty Paulista Seguros                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Revisao  ³                                          ³      ³            ³±±
±±³          ³                                          ³      ³            ³±±
±±³          ³                                          ³      ³            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MarkAll(cAlias, cCampoOK, cMark )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a area corrente para evitar problemas de desposicionam.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aAreas := GetArea()
Local _Campo := ''
lMarca := (&cCampoOK == cMark)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no primeiro registro                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbGotop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre os registros e marca o flag                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !Eof()
	
	RecLock(cALias,.F.)
	_Campo := cAlias+"->"+cCampoOK
	&_Campo := IIf(!lMarca,cMark," ")
	MsUnLock()
	
	dbSkip()
EndDo

RestArea( aAreas )
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSFINA01 ºAutor  ³Microsiga           º Data ³  02/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CsF01Inc(cMark)
Local cUpDate := ''

// Excluindo dados anteriores
cUpDate := "UPDATE "+RetSqlName("SZI")+Chr(13)
cUpDate += "SET D_E_L_E_T_ = '*'"+Chr(13)
cUpDate += "WHERE ZI_FILIAL = '"+xFilial("SZI")+"'"+Chr(13)
cUpDate += "AND ZI_USUARIO = '"+cUsr+"'"+Chr(13)
cUpDate += "AND D_E_L_E_T_ <> '*'"+Chr(13)
TcSqlExec( cUpdate )

//Incluir os novos registros
dbSelectArea("CTTTRB")
CTTTRB->(dbGoTop())

While CTTTRB->(!Eof())
	If CTTTRB->CTT_OK == cMark
		RecLock("SZI", .T.)
		SZI->ZI_USUARIO := cUsr
		SZI->ZI_NMUSER  := UsrRetName( cUsr ) // Sergio em Jul/2007: Chamado 002077
		SZI->ZI_NOMEUSR := If(Empty(cSolic), UsrFullName(cUsr), cSolic)
		SZI->ZI_CCUSTO  := CTTTRB->CTT_CUSTO
		SZI->ZI_DESCCC  := CTTTRB->CTT_DESC01
		SZI->ZI_MSBLQL  := '2'
		SZI->(MsUnlock())
	EndIf
	CTTTRB->(dbSkip())
EndDo
Return(nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PesqBrow ³ Autor ³ Cristian Werneck      ³ Data ³ 02.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a pesquisa dentro de um arquivo temporario          ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Parametros³  cTitulo -> titulo da dialog                               ³±±
±±³          ³  ArqTmp  -> alias do arquivo temporario                    ³±±
±±³          ³  nOrdem  -> nr. do indexord                                ³±±
±±³          ³  aIndNome-> array contendo os indices                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PesqBrow(Titulo,ArqTmp,nOrdem,aIndNome)
Local oDlgPesq,oSay1,oCombo2,oSay3,oGet4,oSBtn5

cCombo := Titulo
aItems :={}
For n:=1 To Len(aIndNome)
	AADD(aItems,Alltrim(Str(aIndNome[N,1]))+" "+aIndNome[n,2])
Next

dbSelectArea(ArqTmp)
dbSetOrder(nOrdem)

cPesq := Space(75)

oDlgPesq := MSDIALOG():Create()
oDlgPesq:cName := "oDlgPesq"
oDlgPesq:cCaption := "Pesquisar"
oDlgPesq:nLeft := 0
oDlgPesq:nTop := 0
oDlgPesq:nWidth := 339
oDlgPesq:nHeight := 148
oDlgPesq:lShowHint := .F.
oDlgPesq:lCentered := .T.

oSay1 := TSAY():Create(oDlgPesq)
oSay1:cName := "oSay1"
oSay1:cCaption := "Opcao de pesquisa:"
oSay1:nLeft := 12
oSay1:nTop := 18
oSay1:nWidth := 105
oSay1:nHeight := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oCombo2 := TCOMBOBOX():Create(oDlgPesq)
oCombo2:cName := "oCombo2"
oCombo2:cCaption := "oCombo2"
oCombo2:nLeft := 122
oCombo2:nTop := 20
oCombo2:nWidth := 191
oCombo2:nHeight := 21
oCombo2:lShowHint := .F.
oCombo2:lReadOnly := .F.
oCombo2:Align := 0
oCombo2:lVisibleControl := .T.
oCombo2:aItems := aItems
oCombo2:nAt := 0             
oCombo2:cVariable := "cCombo" 
oCombo2:bSetGet := {|u| If(PCount()>0,cCombo:=u,cCombo) }

oSay3 := TSAY():Create(oDlgPesq)
oSay3:cName := "oSay3"
oSay3:cCaption := "Digite"
oSay3:nLeft := 14
oSay3:nTop := 51
oSay3:nWidth := 65
oSay3:nHeight := 17
oSay3:lShowHint := .F.
oSay3:lReadOnly := .F.
oSay3:Align := 0
oSay3:lVisibleControl := .T.
oSay3:lWordWrap := .F.
oSay3:lTransparent := .F.

oGet4 := TGET():Create(oDlgPesq)
oGet4:cName := "oGet4"
oGet4:nLeft := 122
oGet4:nTop := 49
oGet4:nWidth := 190
oGet4:nHeight := 21
oGet4:lShowHint := .F.
oGet4:lReadOnly := .F.
oGet4:Align := 0
oGet4:cVariable := "cPesq"
oGet4:bSetGet := {|u| If(PCount()>0,cPesq:=u,cPesq) }
oGet4:lVisibleControl := .T.
oGet4:lPassword := .F.
oGet4:lHasButton := .F.

oSBtn5 := SBUTTON():Create(oDlgPesq)
oSBtn5:cName := "oSBtn5"
oSBtn5:cCaption := "oSBtn5"
oSBtn5:nLeft := 258
oSBtn5:nTop := 82
oSBtn5:nWidth := 52
oSBtn5:nHeight := 22
oSBtn5:lShowHint := .F.
oSBtn5:lReadOnly := .F.
oSBtn5:Align := 0
oSBtn5:lVisibleControl := .T.
oSBtn5:nType := 1
oSBtn5:bAction := {|| oDlgPesq:End() }

oDlgPesq:Activate()

dbSelectArea(ArqTmp)     // utilizando indice temporario
For nIndex:=1 To Len(aIndNome)
	If Substr(cCombo,1,1) == Alltrim(Str(nIndex))
		DbSetOrder(nIndex)
		Exit
	Endif
Next
DbSeek(	alltrim(cPesq ),.T.)
SysRefresh()
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MenuDEF  º Autor ³Eduardo de Souza    º Data ³12/Jan/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Implementa menu funcional                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Menus                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//³    3 - Duplica o registro corrente do Banco de Dados         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MenuDef()
Local aRotina :=	{{ "Pesquisar"     ,'U_PesqBrow("Pesquisa ","CTTTRB",1,aIndNome)'  ,0,3},;		//"Pesquisar"
				 { "Incluir"       ,'U_CsF01Inc(cMark)'     ,0,5},; 
				 { "Total Marcado" ,'U_TotMkAll(cMark,.t.)' ,0,6},;
				 { "Visualizar"    ,'U_CSF01Vis()' ,0,2}}		

Return aRotina
