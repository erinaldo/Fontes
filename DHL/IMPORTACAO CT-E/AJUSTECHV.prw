#Include 'Protheus.ch'

User Function AJUSTECHV()
/*
Private oDlg     := NIL
Private cAnexo   := Space(200)
Private cMask    := "Todos os arquivos (*.*) |*.*|"
Private nOpc     := 2

Private _cDtIni  := Date()
Private _cHrIni  := TIME()

	DEFINE MSDIALOG oDlg TITLE "Importação CT-e" FROM 0,0 TO 350,570 OF oDlg PIXEL
	
	@ 051,003 SAY "Arquivo"    SIZE 30,7 PIXEL OF oDlg
	
	@ 050,035 MSGET cAnexo   PICTURE "@" SIZE 233, 8 PIXEL OF oDlg
	@ 049,269 BUTTON "..." SIZE 13,11 PIXEL OF oDlg ACTION cAnexo:=AllTrim(cGetFile(cMask,"Inserir anexo"))
	
	@ 100,060 BUTTON "&OK" SIZE 36,13 PIXEL ACTION (nOpc:=1,oDlg:End())
	@ 100,180 BUTTON "&Cancelar" SIZE 36,13 PIXEL ACTION (nOpc:=2,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED

If nOpc == 2 //Cancelar
	Return
Else
	Processa( {|| GCTE01Run(cAnexo) }, "Processando Importação..." )
EndIf

DbSelectArea("ZZ0")
DbGotop()
*/
Return

Static Function GCTE01Run(cAnexo)
_aArea   := GetArea()
MV_PAR01 := cAnexo
If (nHandle := FT_FUse(AllTrim(MV_PAR01)))== -1
	Help(" ",1,"NOFILE")
	Return
EndIf

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

_nLi	  := 1 //Linhas processadas
_lCont   := .F.

//Inicio Processamento arquivo
Do While !FT_FEOF()
	_cBuffer := FT_FREADLN()

	IncProc("Numero de Linhas "+ alltrim(strzero(_nLi,6)))
	
	_lCont     := .F.
	
	Begin Transaction

	If Substr(_cBuffer,1,1) == "A"
		FT_FSKIP()
	ElseIf Substr(_cBuffer,1,1) == "B"
		X6_FILDOC := Substr(_cBuffer,187,004)
		X6_DOC    := Substr(_cBuffer,191,009)
		X6_SERIE  := Substr(_cBuffer,200,003)
		X6_DOCTMS := Substr(_cBuffer,293,001)
		X6_CHVCTE := Substr(_cBuffer,492,044)
		X6_CODNFE := Substr(_cBuffer,466,008)
		X6_CLIDEV  := Substr(_cBuffer,389,014)//3
		X6_LOJDEV  := Substr(_cBuffer,403,004)

		_Cliente := X6_CLIDEV
		_Loja    := X6_LOJDEV

		_nLi++
		FT_FSKIP()

	ElseIf Substr(_cBuffer,1,1) == "C"
		X8_XCFOP   := Substr(_cBuffer,146,004)
		_nLi++
		FT_FSKIP()
		_lCont := .T.
	EndIf
	
	If _lCont
		cTESAnula  := SuperGetMv("MV_TESANUL",,"")
		_cCFAnul := Posicione("SF4", 1, xFilial("SF4")+cTESAnula, "F4_CF")
		_cEstCli := Posicione("SA1", 1, xFilial("SA1")+_Cliente+_Loja, "A1_EST")
		_cEstEmp := SM0->M0_ESTCOB
	
		_xCFOP		:= X8_XCFOP
		
		DbSelectArea("SF2")
		DbSetOrder(1)
		If DbSeek(X6_FILDOC+X6_DOC+X6_SERIE+_Cliente+_Loja)
			If ALLTRIM(X6_DOCTMS) == "8" //Complementar
				RecLock("SF2",.F.)
				SF2->F2_TIPO := "C"
				MsUnLock()
			EndIf
		EndIf
			
		DbSelectArea("SD2")
		DbSetOrder(3)
		If DbSeek(X6_FILDOC+X6_DOC+X6_SERIE+_Cliente+_Loja)
			Do While !EOF() .and. X6_FILDOC+X6_DOC+X6_SERIE+_Cliente+_Loja == SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
				RecLock("SD2",.F.)
				SD2->D2_CF := _xCFOP
				If ALLTRIM(X6_DOCTMS) == "8" //Complementar
					SD2->D2_TIPO := "C"
				EndIf
				MsUnLock()
				SD2->(DbSkip())
			EndDo
		EndIf
			
		DbSelectArea("SF3")
		DbSetOrder(5)
		If DbSeek(X6_FILDOC+X6_SERIE+X6_DOC+_Cliente+_Loja)
			RecLock("SF3",.F.)
			SF3->F3_CFO     := _xCFOP
			SF3->F3_CHVNFE  := IIF(alltrim(X6_CODNFE) == "102", "", X6_CHVCTE) //Codigo de CT-e Inutilizado. Para esses casos a Chave tem que ser Branca
			SF3->F3_CODRSEF := X6_CODNFE
			If ALLTRIM(X6_DOCTMS) == "8" //Complementar
				SF3->F3_TIPO := "C"
			EndIf
			MsUnLock()
		EndIf
				
		DbSelectArea("SFT")
		DbSetOrder(1)
		If DbSeek(X6_FILDOC+"S"+X6_SERIE+X6_DOC+_Cliente+_Loja)
			Do While !EOF() .and. X6_FILDOC+"S"+X6_SERIE+X6_DOC+_Cliente+_Loja == SFT->(FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA) 
				RecLock("SFT",.F.)
				SFT->FT_CFOP    := _xCFOP
				SFT->FT_CHVNFE  := IIF(alltrim(X6_CODNFE) == "102", "", X6_CHVCTE) //Codigo de CT-e Inutilizado. Para esses casos a Chave tem que ser Branca
				If ALLTRIM(X6_DOCTMS) == "8" //Complementar
					SFT->FT_TIPO := "C"
				EndIf
				MsUnLock()
				SFT->(DbSkip())
			EndDo
		EndIf	
		
		If ALLTRIM(X6_DOCTMS) == "M" //Anulação
			If _cEstCli == "EX"
				_cCFAnul := "3"+Substr(_cCFAnul,2,3)
			ElseIf _cEstCli == _cEstEmp
				_cCFAnul := "1"+Substr(_cCFAnul,2,3)
			ElseIf _cEstCli <> _cEstEmp
				_cCFAnul := "2"+Substr(_cCFAnul,2,3)
			Else
				_cCFAnul := _cCFAnul
			EndIf
	
			DbSelectArea("SD1")
			DbSetOrder(1)
			If DbSeek(X6_FILDOC+X6_DOC+X6_SERIE+_Cliente+_Loja)
				Do While !EOF() .and. X6_FILDOC+X6_DOC+X6_SERIE+_Cliente+_Loja == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
					RecLock("SD1",.F.)
					SD1->D1_CF      := _cCFAnul
					MsUnLock()
					SD1->(DbSkip())
				EndDo
			EndIf
	
			DbSelectArea("SF3")
			DbSetOrder(5)
			If DbSeek(X6_FILDOC+X6_SERIE+X6_DOC+_Cliente+_Loja)
				RecLock("SF3",.F.)
				SF3->F3_CFO     := _cCFAnul
				MsUnLock()
			EndIf
	
			DbSelectArea("SFT")
			DbSetOrder(1)
			If DbSeek(X6_FILDOC+"E"+X6_SERIE+X6_DOC+_Cliente+_Loja)
				Do While !EOF() .and. X6_FILDOC+"E"+X6_SERIE+X6_DOC+_Cliente+_Loja == SFT->(FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA) 
					RecLock("SFT",.F.)
					SFT->FT_CFOP    := _cCFAnul
					MsUnLock()
				SFT->(DbSkip())
				EndDo
			EndIf	
	
		EndIf

		_Cliente 	:= ""
		_Loja		:= ""

	EndIf
	
	End Transaction

EndDo

FT_FUSE()

Aviso("AJUSTE", "Ajuste Finalizado"+CHR(13)+CHR(10)+"Iniciado em : "+dtoc(_cDtIni)+CHR(13)+CHR(10)+"Finalizado em: "+dtoc(Date())+" "+ELAPTIME(_cHrIni,TIME()), {"Sair"} )

RestArea(_aArea)

Return()
