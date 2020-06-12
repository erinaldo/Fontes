#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     º Autor ³ AP6 IDE            º Data ³  30/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CCOMA05()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local oDlg
Local oDlg1
Local oCbx
Local lInverte := .F.
Local nProxReg
Local lEof
Local nOpcA    := 0
Local nC       := 0
Local cIndex   := ""
Local cChave   := ""
Local nSavOrd1 := SC1->(IndexOrd() - 1)
Local cArquivo
Local nX := 0
Local nRec
Local nRegAtu
Local nIndex
Local aCampos := {}
Local cMarca    := GetMark()
Local cDesmarca := ThisMark()
Private cPerg       := "COMA05    "
//Local lOk := Pergunte("FIN580", .T.)
//If !lOk
//	Return .T.
//Endif

CALIAS := "SC1"


//IF !Alltrim(Subs(cUsuario,7,15)) $ GETMV("MV_USERRES")
IF !Alltrim(cUserName) $ GETMV("MV_USERRES")
   MsgInfo("Usuario nao autorizado a eliminar residuos", "Atencao!!")
   Return
EndIf   


ValidPerg()
pergunte(cPerg,.T.)

Do While .T.
	nRec := SC1->(RecNo())
	
	dbSelectArea(cAlias)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta express„o do Filtro para sele‡„o                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cIndex    := CriaTrab(nil, .F.)
	cChave    := SC1->(IndexKey())
	nOldIndex := IndexOrd()
	IndRegua("SC1", cIndex, cChave,,"C1_QUJE<C1_QUANT .AND. C1_NUM >= MV_PAR01 .AND. C1_NUM <= MV_PAR02", "Selecionando Registros..." )
	nIndex := RetIndex("SC1")
	dbSelectArea("SC1")
	#IFNDEF TOP
		dbSetIndex(cIndex + OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex + 1)
	dbGoTop()
	
	If bof() .and. eof()
		Help(" ", 1, "RECNO")
		RetIndex("SC1")
		Set Filter to
		Exit
	EndIf
	nOpcA	:= 0
	aCampos := {}
	aAdd(aCampos,{"C1_OK", "", "  ", ""})
	dbSelectArea("SX3")
	dbSeek ("SC1")
	Do While !eof() .and. (X3_ARQUIVO == "SC1")
		If X3USO(X3_USADO)  .and. cNivel >= X3_NIVEL .and. X3_CONTEXT != "V" .or. ;
			AllTrim(X3_CAMPO) == "C1_QUJE"
			AADD(aCampos,{X3_CAMPO, "", X3Titulo(), X3_PICTURE})
		Endif
		dbSkip()
	EndDo
	dbSelectArea("SC1")
//	If mv_par01 <> 2
//		MarcaRegs("SC1", cMarca)
//	Endif
	    DesMarca("SC1", cMarca)
	Define MsDialog oDlg1 Title OemToAnsi("Eliminação de Residuos") From 09, 00 to 28, 80 of oMainWnd
	oMark := MsSelect():New(cAlias	,;
	"C1_OK"			,;
		,;
	aCampos			,;
	@lInverte		,;
	@cMarca			,;
	{015, 001, 143, 315})
	
	oMark:oBrowse:lhasMark    := .T.
	oMark:oBrowse:lCanAllmark := .T.
//	oMark:oBrowse:bAllMark    := {|| DesMarca("SC1",cMarca)}
	
	Activate MsDialog oDlg1 on init EnchoiceBar(oDlg1,{|| nOpcA := 1,oDlg1:End()},;
	{|| nOpcA := 000, ODlg1:End()}) Center
	
	dbSelectArea("SC1")
	If nOpcA == 1
		dbSelectArea("SC1")
		MsUnlockAll()
		dbGoTop()
		Do While !Eof() // .and. E2_FILIAL == cFilial
			// If marked(E2_OK) .and. empty(E2_DATALIB)
			If C1_OK == cMarca .and. SC1->C1_QUJE < SC1->C1_QUANT
				dbSelectArea("SC1")
				RecLock("SC1",.F.)
				SC1->C1_QUJE := SC1->C1_QUANT   
//				SC1->C1_OBS  := "Eliminado "+dtoc(dDataBase)+"-"+ALLTRIM(SUBS(cUsuario,7,12)) 
				SC1->C1_OBS  := "Eliminado "+dtoc(dDataBase)+"-"+ALLTRIM(cUserName) 
				SC1->(MsUnlock())
			EndIf
			SC1->(dbSKip())
		EndDo
	
	    MsgInfo("Residuos Eliminados com Sucesso!!!", "Informativo...")
	EndIf
	dbSelectArea("SC1")
	RetIndex("SC1")
	Set Filter to
	Exit
EndDo
dbSelectArea("SC1")
RetIndex("SC1")
dbSetOrder(1)
dbGoTop()
#IFNDEF TOP
	FErase (cIndex + OrdBagExt())
#ENDIF
Return (.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa580Marca³ Autor ³ Alessandro B. Freire  ³ Data ³ 21/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Trata o valor	para marcar e desmarcar item.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fa580Marca(ExpN1, ExpD1, ExpD2)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA580                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarcaRegs(cAlias, cMarca)
Local cAliasAnt, _aArea
cAliasAnt := Alias()
dbSelectArea(cAlias)
_aArea := GetArea()
dbGoTop()
Do While !eof()
	RecLock(cAlias, .F.)
	SC1->C1_OK := cMarca
	msUnLock()
	dbSkip()
EndDo
RestArea(_aArea)
dbSelectArea(cAliasAnt)
Return



Static Function DesMarca(cAlias, cMarca)
Local cAliasAnt, _aArea
cAliasAnt := Alias()
dbSelectArea(cAlias)
_aArea := GetArea()
dbGoTop()
Do While !eof()
	RecLock(cAlias, .F.)
	SC1->C1_OK := " " //cMarca
	msUnLock()
	dbSkip()
EndDo
RestArea(_aArea)
dbSelectArea(cAliasAnt)
Return



Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

//          Grupo/Ordem/Pergunta             /Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Solicitacao de    ?","","","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Solicitacao ate   ?","","","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return



