#Include 'Protheus.ch'

User Function BXAJUST()

Private oDlg     := NIL
Private cAnexo   := Space(200)
Private cMask    := "Todos os arquivos (*.*) |*.*|"
Private nOpc     := 2

	DEFINE MSDIALOG oDlg TITLE "Ajusta Cadastro de Produto" FROM 0,0 TO 350,570 OF oDlg PIXEL
	
	@ 051,003 SAY "Arquivo"    SIZE 30,7 PIXEL OF oDlg
	
	@ 050,035 MSGET cAnexo   PICTURE "@" SIZE 233, 8 PIXEL OF oDlg
	@ 049,269 BUTTON "..." SIZE 13,11 PIXEL OF oDlg ACTION cAnexo:=AllTrim(cGetFile(cMask,"Inserir anexo"))
	
	@ 100,060 BUTTON "&OK" SIZE 36,13 PIXEL ACTION (nOpc:=1,oDlg:End())
	@ 100,180 BUTTON "&Cancelar" SIZE 36,13 PIXEL ACTION (nOpc:=2,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED

If nOpc == 2 //Cancelar
	Return
Else
	Processa( {|| GCTE01Run(cAnexo) }, "Processando Atualização..." )
EndIf

Return



Static Function GCTE01Run(cAnexo)

MV_PAR01 := cAnexo
If (nHandle := FT_FUse(AllTrim(MV_PAR01)))== -1
	Help(" ",1,"NOFILE")
	Return
EndIf

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

_nLi	  := 1 //Linhas processadas
//Inicio Processamento arquivo
Do While !FT_FEOF()

	IncProc("Linhas "+ alltrim(strzero(_nLi,6)))

	_cBuffer := FT_FREADLN()
	
	_cCodigo := Substr(_cBuffer, 1, at(";",_cBuffer)-1 )
	
	_cBuffer := Substr(_cBuffer, at(";",_cBuffer)+1 , 300  )
	_cAtivo  := Substr(_cBuffer, 1, at(";",_cBuffer)-1 ) 
	
	_cBuffer := Substr(_cBuffer, at(";",_cBuffer)+1 , 300  )
	_cDescB5 := Substr(_cBuffer, 1, at(";",_cBuffer)-1 )

	_cBuffer := Substr(_cBuffer, at(";",_cBuffer)+1 , 300  )
	_cDescB1 := _cBuffer
	


	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+alltrim(_cCodigo))
		Reclock("SB1",.F.)
		SB1->B1_DESC   := _cDescB1
		SB1->B1_MSBLQL := Iif(alltrim(_cAtivo) == "False","1","2") //1-Bloqueado Sim; 2-Bloqueado Não
		MsUnLock()
	EndIf
	
	DbSelectArea("SB5")
	DbSetOrder(1)
	If DbSeek(xFilial("SB5")+alltrim(_cCodigo))
		Reclock("SB5",.F.)
		SB5->B5_CEME := _cDescB5
		MsUnLock()
	Else
		Reclock("SB5",.T.)
		SB5->B5_COD  := _cCodigo
		SB5->B5_CEME := _cDescB5
		MsUnLock()
	EndIf
	
	_nLi++
	FT_FSKIP()
	
EndDo

alert("fim")

Return