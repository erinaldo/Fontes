#include "totvs.ch"
#include "tbiconn.ch"
#include "dbstruct.ch"
//#include "tryexception.ch"
#DEFINE _CRLF	Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ UPDFSW  ³Autor ³ FSW                   ³Data ³ 25.Jun.09³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Compatibilizador de tabelas e campos                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Bardella                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function UPDFSW()
Local aEmpresas  := {}
Local aListUpd   := {}
Local aTitulos   := {' ', 'Id.', 'Update', 'Status', 'Projeto' }
Local cTxtIntro  := ''
Local lMarcaItem := .T.
Local oDlgUpd
Local oListUpd
Local oNo        := LoadBitMap(GetResources(),"LBNO")
Local oOk        := LoadBitMap(GetResources(),"LBOK")
Private aDados   := {}


cTxtIntro := "<table width='100%' border='1'>"
cTxtIntro += "<tr>"
cTxtIntro += "<td colspan='2'><font face='Tahoma' size='+1'>Este programa tem por objetivo compatibilizar o ambiente do cliente "
cTxtIntro += "conforme as atualizacoes selecionadas na lista abaixo:</font></td>"
cTxtIntro += "</tr>
cTxtIntro += "<tr>"
cTxtIntro += "<td colspan='2'><font face='Tahoma' color='#FF0000' size='+1'>Estas atualizacoes somente poderao ser realizadas em modo <b>exclusivo!</b><br>"
cTxtIntro += "Faca um backup dos dicionários e da Base de Dados antes da atualização para eventuais falhas na atualização."
cTxtIntro += "<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>"
cTxtIntro += "</font></td>"
cTxtIntro += "</tr>
cTxtIntro += "</table>

If ( lOpen := MyOpenSm0(.T.) )

	//-- Obtem as Empresas para processamento...
	SM0->(dbGotop())
	While !SM0->(Eof())
  		If Ascan(aEmpresas,{ |x| x[2] == SM0->M0_CODIGO}) == 0 .And. !Empty(SM0->M0_CODIGO) //--So adiciona no array se a empresa for diferente
			Aadd(aEmpresas,{.T.,;
							SM0->M0_CODIGO,;
							SM0->M0_CODFIL,;
							SM0->M0_FILIAL,;
							SM0->(Recno()) })
		EndIf			
		SM0->(dbSkip())
	EndDo	

	SM0->(DbGoTop())
	RpcSetType(3) 
	//RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
	RpcSetEnv("99", "01")
	lMsFinalAuto := .F.
	
	//-- Obtem a lista de Updates disponiveis para execucao:
	aListUpd   := GetListUpd()

	DEFINE MSDIALOG oDlgUpd; 
	TITLE 'Update Compatibilizador' ;
	FROM 00,00 TO 500,700 PIXEL
	
	TSay():New(002,005,{|| cTxtIntro },oDlgUpd,,,,,,.T.,,,340,200,,,,.T.,,.T.)
	
	oListUpd := TWBrowse():New(	53,10,330,140,,aTitulos,,oDlgUpd,,,,,,,,,,,,,"ARRAY",.T.)
	oListUpd:bLDblClick := {|| aListUpd[oListUpd:nAt,1] := !aListUpd[oListUpd:nAt,1], oListUpd:Refresh()}
	oListUpd:SetArray( aListUpd )
	oListUpd:bLine      := {|| {	If(aListUpd[oListUpd:nAt,1], oOk, oNo),;
							   		aListUpd[oListUpd:nAT,2],;
									aListUpd[oListUpd:nAT,3],;
									aListUpd[oListUpd:nAT,4],;
									aListUpd[oListUpd:nAT,5] } }

	TButton():New( 210,140, 'Marca/Desmarca Pendentes', oDlgUpd,;
					{|| Aeval(aListUpd,{|aElem| aElem[1] := If(aElem[4] == 'Pendente', lMarcaItem, .F.)}), lMarcaItem := !lMarcaItem, oListUpd:Refresh() },; 
					075,015,,,,.T.,,,,,,)

	TButton():New( 210,270, 'Marca/Desmarca Todos', oDlgUpd,;
					{|| Aeval(aListUpd,{|aElem|aElem[1] := lMarcaItem}), lMarcaItem := !lMarcaItem, oListUpd:Refresh() },; 
					075,015,,,,.T.,,,,,,)


	TButton():New( 230,005, 'Selecionar Empresas', oDlgUpd,;
					{|| aEmpresas := UPDSelectSM0(@aEmpresas) },; 
					075,015,,,,.T.,,,,,,)


	TButton():New( 230,140, 'Processar...', oDlgUpd,;
					{|| RpcClearEnv(), MsgRun('Aguarde o termino do Processamento',,{||UPDProcUpd( aListUpd, aEmpresas )}), oDlgUpd:End()},; 
					075,015,,,,.T.,,,,,,)

	TButton():New( 230,270, 'Cancelar', oDlgUpd,;
					{|| RpcClearEnv(), oDlgUpd:End()},; 
					075,015,,,,.T.,,,,,,)	
	
	ACTIVATE MSDIALOG oDlgUpd CENTERED
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³UPDPROCUPD³ Autor ³ Fabrica de Software   ³ Data ³ 13.Nov.06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PROCESSA A ATUALIZACAO DO AMBIENTE                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDProcUpd( aListUpd, aEmpresas )
Local nAux       := 0
Local nEmpresa   := 0

Local aEstrutSX3 := {}

Local   cTCBuild  := "TCGetBuild"
Local   cTopBuild := ""

Local aTarefas   := {}
Local aSX3       := {}
Local aAtualiza  := {{},{},{},{},{},{},{},{}}
Local aResumo    := {}

Local aArqUpd    := {}

Local i          := 0
Local j          := 0

aEstrutSX3 := {"X3_ARQUIVO","X3_ORDEM"		,"X3_CAMPO"		,"X3_TIPO"		,"X3_TAMANHO"	,"X3_DECIMAL"	,"X3_TITULO"	,"X3_TITSPA"	,;
		  		   "X3_TITENG" ,"X3_DESCRIC"	,"X3_DESCSPA"	,"X3_DESCENG"	,"X3_PICTURE"	,"X3_VALID"		,"X3_USADO"		,"X3_RELACAO"	,;
				   "X3_F3"		,"X3_NIVEL"		,"X3_RESERV"	,"X3_CHECK"		,"X3_TRIGGER"	,"X3_PROPRI"	,"X3_BROWSE"	,"X3_VISUAL"	,;
				   "X3_CONTEXT","X3_OBRIGAT"	,"X3_VLDUSER"	,"X3_CBOX"		,"X3_CBOXSPA"	,"X3_CBOXENG"	,"X3_PICTVAR"	,"X3_WHEN"		,;
				   "X3_INIBRW"	,"X3_GRPSXG"	,"X3_FOLDER"	,"X3_PYME"	}


For nEmpresa := 1 To Len(aEmpresas)
	If aEmpresas[nEmpresa,1]
		If !( lOpen := MyOpenSm0(.F.) )
			MsgStop( "Atualização da empresa " + aEmpresas[nEmpresa,2] + "/" + aEmpresas[nEmpresa,3] + " não efetuada." )
			Exit
		EndIf
		If lOpen
			SM0->(DbGoTo(aEmpresas[nEmpresa,5]))
			RpcSetType(3) 
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			lMsFinalAuto := .F.

			aTarefas   := {}
			aSX3       := {}
			aAtualiza  := {{},{},{},{},{},{},{},{}}

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³INICIO DAS ATUALIZACOES³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nAux := 1 To Len(aListUpd)
				If aListUpd[nAux,1]
			
					//-- Obtem a lista de tarefas conforme updates selecionados na lista
					aTarefas := &( 'U_' + aListUpd[nAux,2] + '()' )
			
					For i := 1 To Len(aTarefas[3]) //-- SX3
						AAdd( aSX3, aTarefas[3,i] )
					Next
			
				EndIf
			Next
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ATUALIZANDO O SX3 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SX3->(DbSetOrder(2))	
			For i := 1 To Len(aSX3)
				If !Empty(aSX3[i,1])
					If AScan(aArqUpd, aSX3[i,1]) == 0
						aAdd(aArqUpd,aSX3[i,1])
					EndIf
					If !SX3->(dbSeek(aSX3[i,3]))
						RecLock("SX3",.T.)
					Else
						RecLock("SX3",.F.)
					EndIf
					For j:=1 To Len(aSX3[i])
						If SX3->(FieldPos(aEstrutSX3[j])) > 0 .And. aSX3[i,j] != NIL
							SX3->(FieldPut(FieldPos(aEstrutSX3[j]),aSX3[i,j]))
						EndIf
					Next j
					SX3->(dbCommit())
					SX3->(MsUnLock())

					AAdd( aAtualiza[3], aSX3[i] )
					
				EndIf
			Next i
			
			__SetX31Mode(.F.) //// Alteração física dos arquivos

			If FindFunction(cTCBuild)
				cTopBuild := &cTCBuild.()
			EndIf

			For i := 1 To Len(aArqUpd)
				If Select(aArqUpd[i]) > 0
					DbSelectArea(aArqUpd[i])
					dbCloseArea()
				EndIf
	
				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					If ( ( aArqUpd[i] >= "NQ " .AND. aArqUpd[i] <= "NZZ" ) .OR. ( aArqUpd[i] >= "O0 " .AND. aArqUpd[i] <= "NZZ" ) ) .AND.;
						!aArqUpd[i] $ "NQD,NQF,NQP,NQT"
						TcInternal( 25, "CLOB" )
					EndIf
				EndIf

				If Select( aArqUpd[i] ) > 0
					dbSelectArea( aArqUpd[i] )
					dbCloseArea()
				EndIf

				X31UpdTable(aArqUpd[i])
				
				If __GetX31Error()
					MsgAlert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[i] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
				EndIf
				
				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf
			
			Next i

			RpcClearEnv()			
			AAdd(aResumo, {aEmpresas[nEmpresa,2] + ' - ' + aEmpresas[nEmpresa,3] + ': ' + aEmpresas[nEmpresa,4], aAtualiza} )
			
		EndIf
	EndIf
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GetListUpd³ Autor ³FSW                    ³ Data ³ 13.Nov.06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a Lista com os Updates disponiveis para Realizacao ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetListUpd()
Local aList     := {}
Local nAux      := 0

For nAux := 1 To 99
	cUpdate := StrZero(nAux,2)
	If FindFunction( 'U_FSW' + cUpdate + 'Des' )
	
		aRet := &('U_FSW' + cUpdate + 'Des()' )
		AAdd( aList, {	.F.,;
						aRet[1],;
						aRet[2],;
						IIf(aRet[3], 'Executado', 'Pendente'),;
						aRet[4] } )
	EndIf
Next
Return(aList)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³UPDSelectSM0³ Autor ³FSW                  ³ Data ³ 14.Nov.06³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exibe janela para escolha das empresas que devem ser       ³±±
±±³          ³ processadas                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UPDSelectSM0(aEmpresas)
Local oDlgSM0
Local oListBox
Local aHList     := {}
Local oOk        := LoadBitMap(GetResources(),"LBOK")
Local oNo        := LoadBitMap(GetResources(),"LBNO")
Local lMarcaItem := .T.

DEFINE MSDIALOG oDlgSM0 TITLE 'Selecione as Empresas para o processamento...' From 9,0 To 30,52

AAdd( aHList, ' ')
AAdd( aHList, 'Empresa' )
AAdd( aHList, 'Filial' )
AAdd( aHList, 'Nome' )
AAdd( aHList, 'Id.')

oListBox := TWBrowse():New(005,005,155,145,,aHList,,oDlgSM0,,,,,,,,,,,,, "ARRAY", .T. )
oListBox:SetArray( aEmpresas )
oListBox:bLine := {|| {	If(aEmpresas[oListBox:nAT,1], oOk, oNo),;
						aEmpresas[oListBox:nAT,2],;
						aEmpresas[oListBox:nAT,3],;
						aEmpresas[oListBox:nAT,4],;
						aEmpresas[oListBox:nAT,5]}}

oListBox:bLDblClick := {|| aEmpresas[oListBox:nAt,1] := !aEmpresas[oListBox:nAt,1], oListBox:Refresh()}

DEFINE SBUTTON FROM    4,170 TYPE 1 ACTION (oDlgSM0:End())   ENABLE OF oDlgSM0
DEFINE SBUTTON FROM 18.5,170 TYPE 11 ACTION (Aeval(aEmpresas,{|aElem|aElem[1] := lMarcaItem}), lMarcaItem := !lMarcaItem,,oListBox:Refresh()) ONSTOP 'Marca/Desmarca' ENABLE OF oDlgSM0

ACTIVATE MSDIALOG oDlgSM0 CENTERED

Return( aEmpresas )


//--------------------------------------------------------------------
/*/{Protheus.doc} MyOpenSM0
Função de processamento abertura do SM0 modo exclusivo
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MyOpenSM0(lShared)
Local lOpen := .F.
Local nLoop := 0
For nLoop := 1 To 20
	If MPDicInDB()
		If lShared
			OpenSm0(,.T.)
		Else
			OpenSM0Excl(,.F.)
		EndIf
		If !Empty( Select( 'SM0' ) )
			lOpen := .T.
			Exit
		EndIF
	Else
		dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )
		If !Empty( Select( "SM0" ) )
			lOpen := .T.
			dbSetIndex( "SIGAMAT.IND" )
			Exit
		EndIf
	EndIf
	Sleep( 500 )
Next nLoop
/*
If !lOpen
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf
*/
Return lOpen

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VerIndice ³ Autor ³FSW                    ³ Data ³26/01/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza a ordem dos indices                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function UPDIndex(aSIX)
Local nTmp
Local cOrdem

cTab := ""

// verifica se o indice ja existe no SIX
SIX->(dBsetOrder(1))
For nTmp := 1 to Len(aSIX)  
	if cTab <> aSIX[nTmp,1]
		cTab := aSIX[nTmp,1]
		// localiza a ultima ordem
		SIX->(dbSeek(cTab+"z",.T.))
		SIX->(dbskip(-1))
		If SIX->(!Eof()) .and. SIX->INDICE == cTab
			cOrdem := SIX->ORDEM
		Else
			cOrdem := "0"
		EndIf
	Endif	

	if ! Empty(aSIX[nTmp,9])
		SIX->(dbSeek(cTab))
		Do While SIX->(!Eof()) .And. SIX->INDICE == cTab
			If Alltrim(SIX->NICKNAME) == Alltrim(aSIX[nTmp,9])
				aSIX[nTmp,2] := SIX->ORDEM
			Endif	
			SIX->(dbskip())
		EndDo
		if Empty(aSIX[nTmp,2])
			cOrdem 			:= Soma1(cOrdem)
			aSIX[nTmp,2]	:= cOrdem
		Endif	
	Endif	
Next

Return Nil