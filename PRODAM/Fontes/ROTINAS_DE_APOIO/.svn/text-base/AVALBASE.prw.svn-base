#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//**************************************************************************************
//**************************************************************************************
//** Ferramenta para a análise de conteúdo em tabelas padrões do Protheus        
//** As situações analisadas são:
//** - Campos com caracteres especiais ou acentuados;                                   
//** - Campos obrigatórios sem conteúdo;
//** - Campos de CGC/CNPJ com conteúdo inválido (para cliente e fornecedor);
//** - Campos validados com PERTENCE e com conteúdo inválido;
//** - Campos com referência em outra tabela e com conteúdo inválido.     
//**************************************************************************************
//**************************************************************************************
User Function AVALBASE()
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
	Private cDir		:= SPACE(100)
	Private cSep		:= "|"
	Private aLogRet 	:= {}
	Private lChk1		:= .F.
	Private aStr1		:= {}
	Private aStr2		:= {}
	Private aCpoAval	:= {}
	Private aFilAval	:= {}


	DEFINE MSDIALOG oDlg TITLE "Análise de base" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

	@ 015, 011 SAY oSay1 PROMPT "Informe o ALIAS da tabela a ser analisada " SIZE 150, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 014, 120 GET oGet1 VAR cTab Picture "@!" SIZE 020, 010 VALID VLDSX2(cTab) OF oDlg COLORS 0, 16777215 PIXEL
	@ 035, 011 SAY oSay2 PROMPT "Informe o caminho para salvar o arquivo de LOG da análise " SIZE 150, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 048, 011 GET oGet2 VAR cDir Picture "@!" SIZE 190, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
	@ 065, 011 SAY oSay3 PROMPT "Realizar as seguintes correções:" SIZE 150, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 075, 015 CheckBox oChkMar1 Var  lChk1 Prompt "- corrigir caracteres acentuados, trocando-os pelos respectivos caracteres sem o acento;"   Message  Size 250, 010 Pixel Of oDlg
	DEFINE SBUTTON oSButton3 FROM 048, 210 TYPE 14 OF oDlg ENABLE action(cDir := ALLTRIM(cGetFile("Arquivo TEXTO|*.TXT",'Selecão de pasta', 0,'', .T., GETF_LOCALHARD + GETF_RETDIRECTORY,.F.)))
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
			
			cArqLog := AllTrim(cDir) + "LOG_TAB_" + cTab + "_" + DTOS(DATE())+"_"+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2)+".TXT"
			nHandle := MsfCreate(cArqLog,0)
			IF nHandle < 0
				MsgAlert( "Falha na criação do arquivo de LOG." )
			Else
				If Len(aLogRet)<=0
					fWrite(nHandle, "Nenhuma inconsistencia encontrada..." )
				Else
				
					cTxtLog := "LOG DE PROCESSAMENTO DA TABELA " + cArquivo + cEol
					fWrite(nHandle, cTxtLog )
					cTxtLog := "INICIO : " + cDtTmIni + cEol
					fWrite(nHandle, cTxtLog )
					cTxtLog := "FINAL  : " + cDtTmFim + cEol
					fWrite(nHandle, cTxtLog )
					If lChk1
						cTxtLog := " - Selecionada a opcao de correcao dos caracteres acentuados."+cEol
						fWrite(nHandle, cTxtLog )
					EndIf
	
					///Ordena o vetor por tabela e tipo de ocorrência
					aLogRet 	:= aSort(aLogRet,,,{|x,y| x[1]+x[2]< y[1]+y[2]} )
					For a:=1 to Len(aLogRet)
						Do Case

						Case aLogRet[a,1] == "PROCACENT"
							If lCabAcent
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos com caracteres especiais ou acentuados" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "TIPO" + cSep + "TABELA" + cSep + "REGISTRO" + cSep + "CAMPO" + cSep + "CONTEUDO"  + cEol
								fWrite(nHandle, cTxtLog )
								lCabAcent := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cSep + aLogRet[a,5] + cEol
							fWrite(nHandle, cTxtLog )

						Case aLogRet[a,1] == "PROCOBRIG"
							If lCabObrig
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos obrigatorios sem conteudo" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "TIPO" + cSep + "TABELA" + cSep + "REGISTRO" + cSep + "CAMPO" + cSep + "CONTEUDO"  + cEol
								fWrite(nHandle, cTxtLog )
								lCabObrig := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cSep + aLogRet[a,5] + cEol
							fWrite(nHandle, cTxtLog )
					
						Case aLogRet[a,1] == "PROCCGC"
							If lCabCGC
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos de CGC/CNPJ com conteudo invalido" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "TIPO" + cSep + "TABELA" + cSep + "REGISTRO" + cSep + "CAMPO" + cSep + "CONTEUDO"  + cEol
								fWrite(nHandle, cTxtLog )
								lCabCGC := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cSep + aLogRet[a,5] + cEol
							fWrite(nHandle, cTxtLog )
					
						Case aLogRet[a,1] == "PROCPERTENC"
							If lCabPertenc
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos validados com PERTENCE e com conteudo invalido" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "TIPO" + cSep + "TABELA" + cSep + "REGISTRO" + cSep + "CAMPO" + cSep + "CONTEUDO ESPERADO"  + cSep + "CONTEUDO"  + cEol
								fWrite(nHandle, cTxtLog )
								lCabPertenc := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cSep + aLogRet[a,5]+ cSep + aLogRet[a,6] + cEol
							fWrite(nHandle, cTxtLog )
					
						Case aLogRet[a,1] == "PROCRELAC"
							If lCabRelac
								cTxtLog := " "+cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "Inconsistencias : Campos com referencia em outra tabela e com conteudo invalido" + cEol
								fWrite(nHandle, cTxtLog )
								cTxtLog := "TIPO" + cSep + "TABELA" + cSep + "REGISTRO" + cSep + "CONSULTA<F3>" + cSep + "CAMPO" + cSep + "CONTEUDO"  + cEol
								fWrite(nHandle, cTxtLog )
								lCabRelac := .F.
							EndIf
							cTxtLog := aLogRet[a,1] + cSep + aLogRet[a,2] + cSep + aLogRet[a,3] + cSep + aLogRet[a,4]+ cSep + aLogRet[a,5] + cSep + aLogRet[a,6] + cEol
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


Static Function VLDSX2()
	Local lRet := .F.

	dbSelectArea("SX2")
	dbSetOrder(1)
	If Empty(cTab) .or. dbseek(cTab)
		lRet := .T.
	Else
		ApMsgInfo("ALIAS " + cTab + " não encontrado.")
	EndIf

Return(lRet)



Static Function VLDOK()
	Local lRet := .F.

	If !Empty(cTab) .and. !Empty(cDir)
		If GetAcento()
			lRet := .T.
		Else
			ApMsgInfo("Arquivo de configuração AVALBASE.CFG não encontrado na pasta "+AllTrim(cDir))
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

			
	/// Posiciona no ALIAS 
	dbSelectArea("SX2")
	dbSetOrder(1)
	If dbSeek(cTab)
		cArquivo := Upper(Alltrim(SX2->X2_ARQUIVO))
				
		aSX3 := {}
		dbSelectArea("SX3")
		dbSetOrder(1)
		If dbSeek(cTab)
			Do While !EOF() .And. SX3->X3_ARQUIVO == cTab
				If SX3->X3_CONTEXT <> "V"
					lObrig :=X3Obrigat(X3_CAMPO)
					AADD(aSX3,{ TRIM(X3_TITULO), X3_CAMPO, X3_TIPO, X3_TAMANHO, X3_DECIMAL, X3_F3, lObrig, X3_VALID })
				EndIf
				dbSelectArea("SX3")
				dbSkip()
			EndDo
		EndIf
				
		oObj:SetRegua1(5)
				
		oObj:IncRegua1("Analisando " + AllTrim(cArquivo) + " ..." )
		ProcExec(oObj,cArquivo,aSX3)
		Inkey(0.5)

	EndIf
	
Return Nil





Static Function ProcExec(oObj,cArquivo,aSX3)
	Local cChave 		:= SX2->X2_CHAVE
	Local cX2Unic		:= AllTrim(SX2->X2_UNICO)
	LOcal cCampo		:= ""
	Local cChaveReg	:= ""
	Local Conteud 	:= ""
	Local lValid
	Local x			:= 0
	Local i			:= 0
	Local nPos			:= 0
	//Local aStr
	Local nRecCount	:= 0
	Local nCount		:= 0
	Local cPercent	:= "0"
	Local cFiltro 	:= ""
	Local nFil			:= 0	
	
	nFil := aScan(aFilAval,{|x|AllTrim(x[1]) == cChave})
	If nFil > 0
		cFiltro := aFilAval[nFil,2] //"SUBSTR(B1_COD,1,2) == '10'"
	EndIf
 
	///Abre a tabela e posiciona no primeiro registro
	dbSelectArea(cChave)
	If !Empty(cFiltro)
		dbSetFilter({|| &cFiltro},cFiltro)
	EndIf
	///Retira o Indice, pois se houver a necessidade de atualizar um conteúdo que é chave, não irá deslocar o ponteiro
	dbSetOrder(0)
	///Vai para o primeiro tegistro.
	dbGoTop()
	///Executa o Loop abaixo até o final da tabela
	nRecCount := RecCount()
	oObj:SetRegua2(nRecCount)
	Do While !Eof()
		aAreaAnt := GETAREA()
		nCount += 1
		cPercent := AllTrim(Transform(nCount / nRecCount * 100 ,"@E 9999"))
		oObj:IncRegua2("Analisando ... " + cPercent + " %" )
		For x:=1 to Len(aSX3)
			cCampo 	:= aSX3[x][2]
			cTipo  	:= aSX3[x][3]
			cF3 		:= aSX3[x][6]
			lObrig 	:= aSX3[x][7]
			cValid 	:= alltrim( upper (aSX3[x][8] ) )
			nPosPert  	:= AT("PERTENCE(",cValid)
			xConteud 	:= &(cChave+"->"+cCampo)
			cChaveReg 	:= IIF(Empty(cX2Unic),"",&(cChave+"->("+cX2Unic+")"))

			///------------------------------
			///Valida Caracteres Acentuados
			///------------------------------
			IF cTipo $ "CM" .and. !("_USERL" $ cCampo) .and. IIF(Len(aCpoAval)>0,aScan(aCpoAval,AllTrim(cCampo))>0,.T.)
				///Executa a apena a análise do conteúdo para verificar se possui acento e retorna .T. ou .F.
				lValid := fAcento(xConteud,.F.)
				If lValid
					AADD(aLogRet,{"PROCACENT",cChave,cChaveReg,cCampo,xConteud})
					///-------------------------------------------------------------------------------------------
					///Se foi selecionada a opção de correção de acentuação, executa a atualização do campo.
					///-------------------------------------------------------------------------------------------
					If lChk1
						cCpoAtu 	:= cChave+"->"+cCampo
						cContNew 	:= fAcento(xConteud,.T.)
						If RecLock(cChave,.F.)
							&(cCpoAtu) := cContNew
							MsUnlock()
						EndIf
					EndIf
				EndIf
			EndIf


			///--------------------------------------
			///Valida Campos Obrigatórios em branco
			///--------------------------------------
			If lObrig
				
				IF cTipo == "C"
					lValid := AllTrim(xConteud) == ""
					If lValid
						AADD(aLogRet,{"PROCOBRIG",cChave,cChaveReg,cCampo,xConteud})
					EndIf
				EndIf

				IF cTipo == "N"
					lValid := xConteud = 0
					If lValid
						AADD(aLogRet,{"PROCOBRIG",cChave,cChaveReg,cCampo,STR(xConteud)})
					EndIf
				EndIf
				
				IF cTipo == "D"
					lValid := AllTrim(DTOS(xConteud)) == ""
					If lValid
						AADD(aLogRet,{"PROCOBRIG",cChave,cChaveReg,cCampo,dtos(xConteud)})
					EndIf
				EndIf
				
			EndIf



			///--------------------------------------
			///Valida CNPJ / CPF
			///--------------------------------------
			If AllTrim(cCampo) $ "A1_CGC#A2_CGC" .and. !Empty(xConteud)
				IF ! CGC(xConteud,,.F.)
					AADD(aLogRet,{"PROCCGC",cChave,cChaveReg,cCampo,xConteud})
				EndIf
			EndIf
			

			///------------------------------------------
			///Valida conteúdo de campos com o PERTENCE
			///------------------------------------------
			If cTipo == "C" .and. nPosPert > 0
				If !Empty(xConteud)
					cContem := Substr(cValid,nPosPert+10)
					nPosFim := AT(")",cContem)
					If nPosFim > 0
						cContem := Substr(cContem,1,nPosFim-2)
					EndIf
					If !(xConteud $ cContem)
						AADD(aLogRet,{"PROCPERTENC",cChave, cChaveReg, cCampo, cContem, xConteud})
					EndIf
				EndIf
			EndIf


			///--------------------------------------------------------
			///Valida relacionamento de campos com outras tabelas
			///--------------------------------------------------------
			If cTipo == "C" .and. !Empty(cF3)
				lValid 	:= .F.
				If Len(AllTrim(cF3)) = 3 .and. !Empty(xConteud)
	
					dbSelectArea(cF3)
					dbSetOrder(1)
					cChvRel := xFilial(AllTrim(cF3)) + xConteud
					If !dbSeek(cChvRel)
						lValid := .T.
					EndIf

					If lValid
						AADD(aLogRet,{"PROCRELAC",cChave, cChaveReg, cF3, cCampo, xConteud})
					EndIf

					//EndIf
				EndIf
				If Len(AllTrim(cF3)) = 2 .and. !Empty(xConteud)
	
					dbSelectArea("SX5")
					dbSetOrder(1)
					cChvRel := xFilial("SX5") + AllTrim(cF3) + xConteud
					If !dbSeek(cChvRel)
						lValid := .T.
					EndIf

					If lValid
						AADD(aLogRet,{"PROCRELAC",cChave, cChaveReg, "SX5"+cF3, cCampo, xConteud})
					EndIf

					//EndIf
				EndIf
			EndIf
			
		Next
		
		RestArea(aAreaAnt)
		dbSelectArea(cChave)
		dbSKip()

	EndDo
	dbClearFilter()
	
Return




Static Function fAcento(cTxt,lChange)
	Local xRet
	Local cRet		:= ""
	Local i		:= 0
	Local nPos		:= 0
	Local lAcento	:= .F.

	If cTxt = Nil .or. ValType(cTxt)<> "C"
		cTxt := ""
	EndIf

	If Len(cTXT) > 0
		For i:=1 to Len(cTXT)
			nPos := aScan(aStr1,Substr(cTXT,i,1))
			If nPos > 0
				cRet := cRet + aStr2[nPos]
				lAcento := .T.
			Else
				cRet := cRet + Substr(cTXT,i,1)
			EndIf
		Next
	EndIf

	If lChange
		xRet := cRet
	Else
		xRet := lAcento
	EndIf

Return(xRet)





Static Function GetAcento()

	Local cArqConf	:= "AVALBASE.CFG"
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
		For j:=1 to 1000
			cChar := Substr(cBuffer,j,1)
			If Len(cChar) > 0
				If nLin = 1 
					AADD(aStr1,cChar)
				EndIf
				If nLin = 2 
					AADD(aStr2,cChar)
				EndIf
			EndIf
		Next
		If nLin > 2
			If Substr(cBuffer,1,3) == "CPO" 
				If !Empty(AllTrim(cBuffer))
					AADD(aCpoAval,Substr(AllTrim(cBuffer),4))
				EndIf		
			EndIf
			If Substr(cBuffer,1,3) == "FIL" 
				If !Empty(AllTrim(cBuffer))
					AADD(aFilAval,{Substr(AllTrim(cBuffer),4,3),Substr(AllTrim(cBuffer),7)})
				EndIf		
			EndIf
		EndIf
		
		//----------------------------------------------
		FT_FSKIP() //próximo registro no arquivo txt
		//----------------------------------------------
	EndDo
	FT_FUSE() //fecha o arquivo txt

Return(.T.)

