#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//**************************************************************************************
//**************************************************************************************
//** Ferramenta para a análise de campos do SX3        
//**************************************************************************************
//**************************************************************************************
User Function SX3AVAL()
//**************************************************************************************
	
	Local oProcess
	Local lOk 			:= .F.
	Local a			:= 0
	Local cTxtLog		:= ""
	Local cEol 		:= chr(13)+ chr(10)
	Local lCabAcent	:= .T.
	Local lCabObrig	:= .T.
	Local lCabCGC 	:= .T.
	Local lCabPertenc	:= .T.
	Local lCabRelac	:= .T.
	Local nHandle
	Local cDirLog		:= ""
	Local cArqLog		:= ""
	Local cDtTmIni	:= ""
	Local cDtTmFim	:= ""
	
	Private cTab		:= "   "
	Private nTam		:= 0
	Private nDec		:= 0
	Private cDir		:= SPACE(100)
	Private cSep		:= "|"
	Private aLogRet 	:= {}
	Private lChk1		:= .F.
	Private aStr1		:= {}
	Private aStr2		:= {}
	Private aCpoAval	:= {}
	Private aFilAval	:= {}


	DEFINE MSDIALOG oDlg TITLE "Análise de campos - SX3" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 015, 011 SAY oSay1 PROMPT "Tamanho referencia dos campos" SIZE 150, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 014, 120 GET oGet1 VAR nTam Picture "@E 99" SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 035, 011 SAY oSay1 PROMPT "Decimal referencia dos campos" SIZE 150, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 034, 120 GET oGet1 VAR nDec Picture "@E 9" SIZE 020, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 055, 011 SAY oSay2 PROMPT "Informe o caminho do arquivo com os campos para analise" SIZE 150, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 068, 011 GET oGet2 VAR cDir Picture "@!" SIZE 190, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
	DEFINE SBUTTON oSButton3 FROM 068, 210 TYPE 14 OF oDlg ENABLE action(cDir := ALLTRIM(cGetFile("Arquivo TEXTO|*.TXT",'Selecão de pasta', 0,'', .T., GETF_LOCALHARD + GETF_RETDIRECTORY,.F.)))
	DEFINE SBUTTON oSButton1 FROM 110, 210 TYPE 01 OF oDlg ENABLE action(lOk:=VLDOK(),IIF(lOk,oDlg:end(),.T.))
	DEFINE SBUTTON oSButton2 FROM 110, 170 TYPE 02 OF oDlg ENABLE action(oDlg:end())

	ACTIVATE MSDIALOG oDlg CENTERED

	If lOk
		/// Posiciona no ALIAS 
		dbSelectArea("SX2")
		dbSetOrder(1)
		If dbSeek(cTab)
			cArquivo := Upper(Alltrim(SX2->X2_ARQUIVO))
		Else
			cArquivo := cTab
		EndIf

		lOk := ApMsgYesNo("Confirma a execução da análise da tabela "+AllTrim(cArquivo)+" ?")
		
		If lOk
			
			cDtTmIni := DTOC(Date()) + " " + Time()
		
			oProcess := MsNewProcess():New({|lEnd| ProcIni(lEnd,oProcess)},"Processando análise de dados","Aguarde...",.T.)
			oProcess:Activate()

			cDtTmFim := DTOC(Date()) + " " + Time()
			
			cArqLog := AllTrim(cDir) + "LOG_CAMPOS_" + DTOS(DATE())+"_"+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+".TXT"
			nHandle := MsfCreate(cArqLog,0)
			IF nHandle < 0
				MsgAlert( "Falha na criação do arquivo de LOG." )
			Else
				If Len(aLogRet)<=0
					fWrite(nHandle, "Nenhuma inconsistencia encontrada..." )
				Else
				
					cTxtLog := "LOG DE PROCESSAMENTO" + cEol
					fWrite(nHandle, cTxtLog )
					cTxtLog := "INICIO : " + cDtTmIni + cEol
					fWrite(nHandle, cTxtLog )
					cTxtLog := "FINAL  : " + cDtTmFim + cEol
					fWrite(nHandle, cTxtLog )
	
					///Ordena o vetor por tabela e tipo de ocorrência
					aLogRet 	:= aSort(aLogRet,,,{|x,y| x[1]< y[1]} )
					For a:=1 to Len(aLogRet)
						Do Case
						Case aLogRet[a,1] == "CAMPO MAIOR"
							If lCabAcent
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos com tamanho maior na base" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "REFERENCIA" + cSep + "CAMPO" + cSep + "TAMANHO" + cSep + "DECIMAL" + cEol
								fWrite(nHandle, cTxtLog )
								lCabAcent := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4] + cEol
							fWrite(nHandle, cTxtLog )

						Case aLogRet[a,1] == "TIPO ERRADO"
							If lCabAcent
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos com tipo não numérico" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "REFERENCIA" + cSep + "CAMPO" + cSep + "TIPO" + cSep + "XXX" + cEol
								fWrite(nHandle, cTxtLog )
								lCabAcent := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cEol
							fWrite(nHandle, cTxtLog )

						Case aLogRet[a,1] == "CAMPO NAO ENCONTRADO"
							If lCabAcent
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos não encontrados" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "REFERENCIA" + cSep + "CAMPO" + cSep + "XXX" + cSep + "	XXX" + cEol
								fWrite(nHandle, cTxtLog )
								lCabAcent := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4] + cEol
							fWrite(nHandle, cTxtLog )
					
						EndCase
					Next
				Endif
				fClose(nHandle)
				ApMsgInfo("Gerado o arquivo de LOG : " + cEol+ cArqLog)
			EndIf
		EndIf
	EndIf
	
Return



Static Function VLDOK()
	Local lRet := .F.

	If nTam > 0 .and. nDec > 0 .and. !Empty(cDir)
		If GetCpos()
			lRet := .T.
		Else
			ApMsgInfo("Arquivo de configuração CAMPOS_QUANT.INI não encontrado na pasta "+AllTrim(cDir))
		EndIf
	Else
		ApMsgInfo("Parametros não informados corretamente !")
	EndIf

Return(lRet)



Static Function ProcIni(lEnd,oObj)
	Local aSX3			:= {}
	Local a			:= 0
	Local aRet 		:= {}
	Local cArquivo	:= ""
	Local lObrig		:= .F.
	Local i			:= 0
			
	oObj:SetRegua1(Len(aCpoAval))
	If Len(aCpoAval)>0
		For i:=1 to Len(aCpoAval)
			oObj:IncRegua1("Analisando ..." )
			dbSelectArea("SX3")
			dbSetOrder(2)
			If dbSeek(aCpoAval[i])
				If SX3->X3_CONTEXT <> "V"
					If SX3->X3_TIPO == "N"	
						If SX3->X3_TAMANHO > nTam .or. SX3->X3_DECIMAL > nDec
							AADD(aLogRet,{"CAMPO MAIOR",X3_CAMPO, STR(X3_TAMANHO), STR(X3_DECIMAL) })
						EndIf
					Else
						AADD(aLogRet,{"TIPO ERRADO",X3_CAMPO, X3_TIPO,""})
					EndIf
				Else
					AADD(aLogRet,{"CAMPO NAO ENCONTRADO",aCpoAval[i],"",""})
				EndIf
			Else
				AADD(aLogRet,{"CAMPO NAO ENCONTRADO",aCpoAval[i],"",""})
			EndIf
		Next
				
	EndIf
	
Return Nil


Static Function GetCpos()

	Local cArqConf	:= "campos_quant.INI"
	Local cBuffer		:= ""
	Local cChar		:= ""
	Local j 			:= 1
	Local nLin			:= 0
	
	
	aStr1 := {}
	aStr2 := {}
	
	If Empty(cDir)
		cArqConf := "\temp\"+cArqConf
	Else
		cArqConf := AllTrim(cDir)+cArqConf
	EndIf
	cArqConf := lower(cArqConf)
	If !File(cArqConf)
		Return(.F.)
	EndIf

	FT_FUSE(cArqConf) 	//ABRIR O ARQUIVO
	FT_FGOTOP() 			//PONTO NO TOPO
	While !FT_FEOF() 		//FACA ENQUANTO NAO FOR FIM DE ARQUIVO
		cBuffer 	:= FT_FREADLN() //LENDO LINHA
		nLin		+= 1
		If !Empty(AllTrim(cBuffer))
			AADD(aCpoAval,AllTrim(cBuffer))
		EndIf
		
		//----------------------------------------------
		FT_FSKIP() //próximo registro no arquivo txt
		//----------------------------------------------
	EndDo
	FT_FUSE() //fecha o arquivo txt

Return(.T.)

