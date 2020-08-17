
User Function _xCM_SE1

Local cTexto 	  := ""
Local cObserv     := ""
Local aObserv     := {} 
Local cFile
Local _nI
Local cMask

_aArea   := GetArea()
MV_PAR01 := "C:\TEMP\AJUSTE_SE1_ADT.txt" //Arquivo TXT enviado pela CM para atualização da tabela SE1 com a Chave correta para contabilizacao
If (nHandle := FT_FUse(AllTrim(MV_PAR01)))== -1
	Help(" ",1,"NOFILE")
	Return
EndIf

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

_nLi	  := 1 //Linhas processadas
_lProc   := .F.

//Inicio Processamento arquivo
Do While !FT_FEOF()
	_cBuffer := FT_FREADLN()

	IncProc("Numero de Linhas "+ alltrim(strzero(_nLi,6)))
	
	cChave 	:= substr(_cBuffer,1,at(";",_cBuffer)-1)
	cHist	:= substr(_cBuffer,at(";",_cBuffer)+1)

	DbSelectArea("XXF")
	DbSetOrder(1) //XXF_REFER + XXF_TABLE + XXF_ALIAS + XXF_FIELD + XXF_EXTVAL
	If DbSeek("BEMATECH       SE1040SE1E1_NUM    "+alltrim(cChave))
		_cBuffer:= XXF->XXF_INTVAL

		//04|01HA0001|GJP|E20798212||RA
		//04|01HA0001|GJP|21395017||RA
		xEmpresa 	:= substr(_cBuffer,1,at("|",_cBuffer)-1)
		_cBuffer	:= substr(_cBuffer,at("|",_cBuffer)+1, 200)
		
		xFilial 	:= substr(_cBuffer,1,at("|",_cBuffer)-1)
		_cBuffer	:= substr(_cBuffer,at("|",_cBuffer)+1, 200)

		xPrefixo 	:= substr(_cBuffer,1,at("|",_cBuffer)-1)
		_cBuffer	:= substr(_cBuffer,at("|",_cBuffer)+1, 200)

		xNumero 	:= substr(_cBuffer,1,at("|",_cBuffer)-1)
		_cBuffer	:= substr(_cBuffer,at("|",_cBuffer)+1, 200)

		xParcela 	:= substr(_cBuffer,1,at("|",_cBuffer)-1)
		_cBuffer	:= substr(_cBuffer,at("|",_cBuffer)+1, 200)

		xTipo	 	:= alltrim(_cBuffer)
		
		DbSelectArea("SE1")
		DbSetOrder(1)
		If DbSeek(xFilial+xPrefixo+If(len(xNumero)<9,xNumero+Space(9-len(xNumero)),xNumero)+If(len(xParcela)<3,xParcela+Space(3-len(xParcela)),xParcela)+xTipo)
			Do While !EOF() .and. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == xFilial+xPrefixo+If(len(xNumero)<9,xNumero+Space(9-len(xNumero)),xNumero)
				If ALLTRIM(SE1->E1_TIPO) == xTipo
					RecLock("SE1",.F.)
					SE1->E1_CTRBCO := SE1->E1_HIST
					SE1->E1_HIST   := cHist
					MsUnLock()
				EndIf
				SE1->(DbSkip())
			EndDo
		EndIf

		aadd(aObserv,{cChave,cHist, "OK" })

    Else
    
	    aadd(aObserv,{cChave,cHist, "ERRO" })
	
	EndIf

	_nLi++
	FT_FSKIP()
	
EndDo

FT_FUSE()


cObserv:= "CHAVE;OBS;STATUS;"+chr(13)+chr(10) // Insere texto no arquivo

For _nI := 1 to len(aObserv)
    cObserv+= aObserv[_nI,1]+";"+aObserv[_nI,2]+";"+aObserv[_nI,3]+";"+chr(13)+chr(10) // Insere texto no arquivo
Next _nI

If msgyesno("Confirma a exportação do arquivo para .csv?")
	cTexto += cObserv
	cFile := cGetFile( cMask, "O arquivo será salvo como '.csv'",0,"C:\",.F.,GETF_LOCALHARD)
	If !empty(cFile)
		MemoWrite( cFile+".csv", cTexto )
		msginfo("Arquivo salvo com sucesso no caminho "+alltrim(cFile)+".csv")
	EndIf
EndIf


alert("Fim do Processamento")

Return