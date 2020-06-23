#include "protheus.ch"
#include "rwmake.ch"
#include "TOTVS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "DBSTRUCT.CH"
#INCLUDE "MSGRAPHI.CH"

/*
=====================================================================================
Programa.:              IMP001
Autor....:              Tiago Barbieri
Data.....:              05/09/2016
Descricao / Objetivo:   Importação de cadastros
Doc. Origem:            
Solicitante:            Cliente
Uso......:               
Obs......:              Tela de Importação de cadastros
=====================================================================================
*/

User Function IMP001()    

	Local oRadMenu1
	Local oSay
	Local aOpcoes := {}
	Static oDlg3
	Private nRadMenu1 := 1

	aadd(aOpcoes,"Cadastros de Produtos SB1")                              //01 SB1
	aadd(aOpcoes,"Estrutura de Produtos SG1")                              //02 SG1
	aadd(aOpcoes,"Clientes SA1")                                           //03 SA1
	aadd(aOpcoes,"Fornecedores SA2")                                       //04 SA2
	aadd(aOpcoes,"Representantes/Vendedores SA3")                          //05 SA3
	aadd(aOpcoes,"Veículos DA3")                                           //06 DA3
	aadd(aOpcoes,"Transportadoras SA4")                                    //07 SA4
	aadd(aOpcoes,"Cadastro de Bens 'Ativo Fixo' - 2 arquivos SN1/SN3")     //08 SN1/SN3
	aadd(aOpcoes,"Saldos de Estoque SB9")                                  //09 SB9
	aadd(aOpcoes,"Lotes de Estoque SD5")                                   //10 SD5
	aadd(aOpcoes,"Pedidos de Compra em Aberto SC7")                        //11 SC7
	aadd(aOpcoes,"Pedidos de Venda em Aberto - 2 arquivos SC5/SC6")        //12 SC5/SC6
	aadd(aOpcoes,"Movimento Financeiro Contas a Pagar em Aberto SE2")      //13 SE2
	aadd(aOpcoes,"Movimento Financeiro Contas a Receber em Aberto SE1")    //14 SE1
	aadd(aOpcoes,"Ordens de Compra SC1")     							   //15 SC1

	DEFINE MSDIALOG oDlg3 TITLE "Importação de Cadastros " FROM 000, 000  TO 380, 400 COLORS 0, 16777215 PIXEL
	oRadMenu1:= tRadMenu():New(20,06,aOpcoes,{|u|if(PCount()>0,nRadMenu1:=u,nRadMenu1)}, oDlg3,,,,,,,,159,130,,,,.T.)
	@ 006, 006 SAY oSay1 PROMPT "Selecione o cadastro a importar :" SIZE 091, 007 OF oDlg3 COLORS 0, 16777215 PIXEL
	@ 170,  90 BUTTON "Importar" SIZE 050, 012 PIXEL OF oDlg3 Action(processa ({|| ImpCad()},"Importação de Cadastros Básicos"))
	@ 170, 150 BUTTON "Cancelar" SIZE 050, 012 PIXEL OF oDlg3 Action(oDlg3:End())

	ACTIVATE MSDIALOG oDlg3 CENTERED

Return

/*
========================================================
Função de importação de arquivo CSV com separador ";"
========================================================
*/
Static Function ImpCad
	Local cArq	     := ""
	Local cArqd	     := ""
	Local cLogDir    := ""
	Local cLogFile   := ""
	Local cTime      := ""
	Local aLog       := {}
	Local cLogWrite  := ""
	Local cLogWritet := ""
	Local nHandle
	Local cLinha     := ''
	Local cLinhad    := ''
	Local lPrim      := .T.
	Local lPrimd     := .T.
	Local aCampos    := {}
	Local aCamposd   := {}
	Local aDados     := {}
	Local aDadosd    := {}
	Local cBKFilial  := cFilAnt
	Local nCampos    := 0
	Local nCamposd   := 0
	Local cSQL       := ''
	Local cSQLd      := ''
	Local aExecAuto  := {}
	Local aExecAutod := {}
	Local aExecAutol := {}
	Local aTipoImp   := {}
	Local aTipoImpd  := {}
	Local nTipoImp   := 0
	Local nTipoImpd  := 0
	Local cTipo      := ''
	Local cTipod     := ''
	Local cTab       := ''
	Local cTabd      := ''
	Local nI
	Local nId
	Local nX
	Local cNiv
	Local cCod
	Local cBemN1
	Local cBemN3
	Local cItemN1
	Local cItemN3
	Private lMsErroAuto    := .F.
	Private lMsHelpAuto	   := .F.
	Private lAutoErrNoFile := .T. 
	Private aTabExclui     := {{'B1',{"SB1"} },;
	{'G1',{"SG1"} },;
	{'A1',{"SA1"} },;
	{'A2',{"SA2"} },;
	{'A3',{"SA3"} },;
	{'DA3',{"DA3"} },;
	{'A4',{"SA4"} },;
	{'N1',{"SN1","SN3","SN4","SN5"} },;
	{'B9',{"SB2","SB9"} },;
	{'D5',{"SD5"} },;
	{'C7',{"SC7"} },;
	{'C5',{"SC5"} },;
	{'C6',{"SC6"} },;
	{'E2',{"SE2"} },;
	{'E1',{"SE1"} },;
	{'C1',{"SC1"} } }

	IF nRadMenu1 !=8 .AND. nRadMenu1 !=12
		cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)
	Endif

	/*
	========================================================
	Importa tabela de Produtos SB1
	========================================================
	*/
	IF nRadMenu1 == 1 // Opção 1 - Produtos
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		// Valida os campos encontrados no arquivo
		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('B1'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		//Prepara a opção para excluir ou não os dados da tabela
		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName('AO4')+" where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		//Lendo arquivo texto
		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		//Processando arquivo texto
		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)

			IncProc("Importando arquivo...")
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos

			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y| MATA010(x,y)},aExecAuto,3) // SB1 Produto

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			msginfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Estrutura de Produtos SG1
		========================================================
		*/
	ElseIF nRadMenu1 == 2 // Opção 2 - Estrutura de Produtos
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('G1'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		//Pergunta se deseja excluir os dados do cadastro de estrutura antes de importar

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...") // Lendo linhas do arquivo
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		// Processando arquivo
		cNiv := "01"
		cCod := ""
		cCpoCab := "G1_COD"
		ProcRegua(Len(aDados))

		For nI:=1 to  Len(aDados)
			IncProc("Importando arquivo...")

			If cCod # aDados[nI][1] .AND. cNiv == aDados[nI][8]
				IF Len(aExecAuto) > 0
					lMsErroAuto := .F.
					Begin Transaction
						MSExecAuto({|x,y,z| MATA200(x,y,z)},aExecAuto,aExecAutod,3) // SG1 Estrutura de Produto

						//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
						If lMsErroAuto
							aLog := {}
							aLog := GetAutoGRLog()
							If nI <= 100
								DisarmTransaction()
								cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
								//MostraErro()
								For nX :=1 to Len(aLog)
									cLogWritet += aLog[nX]+CRLF
								next nX
								MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
								cFilAnt := cBKFilial
								Return
							Else
								cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
								For nX :=1 to Len(aLog)
									cLogWrite += aLog[nX]+CRLF
								next nX
							Endif
						EndIF
					End Transaction
					aExecAuto  := {}
					aExecAutod := {}
				Endif

				//Montando array de Cabeçalho
				For nCampos := 1 To Len(aCampos)
					If Alltrim(aCampos[nCampos]) $ cCpoCab
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					Endif
				Next nCampos
				aAdd(aExecAuto ,{"G1_QUANT",1,NIL})
				aAdd(aExecAuto ,{"NIVALT","S",NIL})
			Endif
			nCampos := 1
			cCod := aDados[nI][1]

			//Monta array de ITENS
			aExecAutol := {}
			For nCampos := 1 To Len(aCampos)-1
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAutol ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAutol ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAutol ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			aAdd(aExecAutod, aExecAutol)
		Next nI

		// Processa execauto da ultima linha do arquivo lido
		lMsErroAuto := .F.
		Begin Transaction
			MSExecAuto({|x,y,z| MATA200(x,y,z)},aExecAuto,aExecAutod,3) // SG1 Estrutura de Produto
			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
				cFilAnt := cBKFilial
				Return
			EndIF
		End Transaction

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Clientes SA1
		========================================================
		*/
	ElseIF nRadMenu1 == 3 // Opção 3 - Clientes
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('A1'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)

			IncProc("Importando arquivo...")
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y| MATA030(x,y)},aExecAuto,3) // SA1 Cliente

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif

		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Fornecedores SA2
		========================================================
		*/
	ElseIF nRadMenu1 == 4 // Opção 4 - Fornecedores
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('A2'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)

			IncProc("Importando arquivo...")
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y| MATA020(x,y)},aExecAuto,3) // SA2 Fornecedores

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Representantes/Vendedores SA3
		========================================================
		*/
	ElseIF nRadMenu1 == 5 // Opção 5 - Representantes/Vendedores
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('A3'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)

			IncProc("Importando arquivo...")
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	UPPER(aDados[nI,nCampos] )	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y| MATA040(x,y)},aExecAuto,3) // SA3 Representantes/Vendedores

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Veículos DA3
		========================================================
		*/
	ElseIF nRadMenu1 == 6 // Opção 6 - Veículos
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,3)

		IF !(cTIPO $('DA3'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)

			IncProc("Importando arquivo...")
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y| OMSA060(x,y)},aExecAuto,3) // DA3 Veículos

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Transportadoras SA4
		========================================================
		*/
	ElseIF nRadMenu1 == 7 // Opção 7 - Transportadoras
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('A4'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)

			IncProc("Importando arquivo...")
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y| MATA050(x,y)},aExecAuto,3) // SA4 Transportadoras

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Cadastro de Bens (Ativo Fixo) SN1/SN3
		========================================================
		*/
	ElseIF nRadMenu1 == 8 // Opção 8 - Cadastro de Bens (Ativo Fixo)

		//Arquivo Cabeçalho
		MsgAlert("Essa opção precisa de 2 arquivos, o primeiro é o arquivo de CABEÇALHO!","ATENÇÃO")
		cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('N1'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		//Arquivo Itens
		MsgAlert("Agora é o arquivo de DETALHE!","ATENÇÃO")
		cArqd := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

		If !File(cArqd)
			MsgStop("O arquivo " +cArqd + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArqd)
		FT_FGOTOP()
		cLinhad    := FT_FREADLN()
		aTipoImpd  := Separa(cLinhad,";",.T.)
		cTipod     := SUBSTR(aTipoImpd[1],1,2)

		IF !(cTIPOd $('N3'))
			MsgAlert('Não é possivel importar a tabela: '+cTipod+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nId := 1 To Len(aTipoImpd)
			IF cTipod <> SUBSTR(aTipoImpd[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImpd[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImpd[nId]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImpd[nId]+' !!')
				Return
			ENDIF
		Next nId

		/*nTipoImpd  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipod } )

		cTabd := ''
		For nId := 1 To Len(aTabExclui[nTipoImpd,2])
			cTabd += aTabExclui[nTipoImpd,2,nId]+' '
		Next nId

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTabd+"antes da importação ? ")
			For nId := 1 To Len(aTabExclui[nTipoImpd,2])
				cSQLd := "delete from "+RetSqlName(aTabExclui[nTipoImpd,2,nId])
				If (TCSQLExec(cSQLd) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nId
		EndIf*/

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinhad := FT_FREADLN()
			If lPrimd
				aCamposd := Separa(cLinhad,";",.T.)
				lPrimd := .F.
			Else
				AADD(aDadosd,Separa(cLinhad,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		cBemN1  := ""
		cBemN3  := ""
		cItemN1 := ""
		cItemN3 := ""

		//Monta array do cabeçalho
		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)
			IncProc("Importando arquivos...")
			aExecAuto  := {}
			aExecAutod := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			cBemN1  := aDados[nI][2]
			cItemN1 := aDados[nI][3]

			//Monta array dos itens
			For nId:=1 to  Len(aDadosd)
				cBemN3  := aDadosd[nId][1]
				cItemN3 := aDadosd[nId][2]
				aExecAutol := {}
				IF cBemN3 == cBemN1 .AND. cItemN3 == cItemN1
					For nCamposd := 1 To Len(aCamposd)
					//	IF  SUBSTR(Upper(aCamposd[nCamposd]),4,6)=='FILIAL'
					//		IF !EMpty(aDadosd[nId,nCamposd])
					//			cFilAnt := aDadosd[nId,nCamposd]
					//		ENDIF
					//	Else
							IF  TamSx3(Upper(aCamposd[nCamposd]))[3] =='N'
								aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]), 	VAL(aDadosd[nId,nCamposd] )	,Nil})
							ELSEIF TamSx3(Upper(aCamposd[nCamposd]))[3] =='D'
								aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]),  CTOD(aDadosd[nId,nCamposd] )	,Nil})
							ELSE
								aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]), 	aDadosd[nId,nCamposd] 	,Nil})
							ENDIF
					//	ENDIF
					Next nCamposd
					aAdd(aExecAutod, aExecAutol)
				ENDIF
			Next nId

			// Executa MSEXECAUTO
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y,z| ATFA012(x,y,z)},aExecAuto,aExecAutod,3) // SN1/SN3 Bens Ativo Fixo CABECALHO/ITENS

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					/*If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else*/
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					//Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Saldos de Estoque SB9
		========================================================
		*/
	ElseIF nRadMenu1 == 9 // Opção 9 - Saldos de Estoque
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('B9'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)

			IncProc("Importando arquivo...")
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y| MATA220(x,y)},aExecAuto,3) // SB9 Saldo de estoque

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Lotes de Estoque SD5
		========================================================
		*/
	ElseIF nRadMenu1 == 10 // Opção 10 - Lotes de Estoque
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('D5'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)

			IncProc("Importando arquivo...")
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y| MATA390(x,y)},aExecAuto,3) // SD5 Lote de estoque

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Pedidos de compra em aberto SC7
		========================================================
		*/
	ElseIF nRadMenu1 == 11 // Opção 11 - Pedidos de compra em aberto
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('C7'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		//Pergunta se deseja excluir os dados do cadastro de estrutura antes de importar

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...") // Lendo linhas do arquivo
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		// Processando arquivo
		cCpoCab  := "C7_NUM/C7_EMISSAO/C7_FORNECE/C7_LOJA/C7_COND/C7_FILENT/C7_CONTATO"
		cCpoIte  := "C7_ITEM/C7_PRODUTO/C7_UM/C7_DESCRI/C7_QUANT/C7_PRECO/C7_TOTAL/C7_LOCAL/C7_IPI/C7_DATPRF/C7_TES"
		cPedCom  := ""
        cItemPed := "0001"

		ProcRegua(Len(aDados))

		For nI:=1 to  Len(aDados)
			IncProc("Importando arquivo...")

			If cPedCom # aDados[nI][1] .AND. cItemPed == aDados[nI][8]
				IF Len(aExecAuto) > 0
					lMsErroAuto := .F.
					Begin Transaction
						MSExecAuto({|x,y,z| MATA121(x,y,z)},aExecAuto,aExecAutod,3) // SC7 Pedido de Compra

						//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
						If lMsErroAuto
							aLog := {}
							aLog := GetAutoGRLog()
							If nI <= 100
								DisarmTransaction()
								cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
								//MostraErro()
								For nX :=1 to Len(aLog)
									cLogWritet += aLog[nX]+CRLF
								next nX
								MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
								cFilAnt := cBKFilial
								Return
							Else
								cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
								For nX :=1 to Len(aLog)
									cLogWrite += aLog[nX]+CRLF
								next nX
							Endif
						EndIF
					End Transaction
					aExecAuto  := {}
					aExecAutod := {}
				Endif

				//Montando array de Cabeçalho
				For nCampos := 1 To Len(aCampos)
					If Alltrim(aCampos[nCampos]) $ cCpoCab
						IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
						ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
						ELSE
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
						ENDIF
					ENDIF
				Next nCampos
			Endif
			nCampos := 1
			cPedCom := aDados[nI][1]

			//Monta array de ITENS
			aExecAutol := {}
			For nCampos := 1 To Len(aCampos)-1
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAutol ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAutol ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAutol ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			aAdd(aExecAutod, aExecAutol)
		Next nI

		// Processa execauto da ultima linha do arquivo lido
		lMsErroAuto := .F.
		Begin Transaction
			MSExecAuto({|x,y,z| MATA121(x,y,z)},aExecAuto,aExecAutod,3) // SC7 Pedido de Compra
			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
				cFilAnt := cBKFilial
				Return
			EndIF
		End Transaction

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Pedidos de venda em aberto SC5/SC6
		========================================================
		*/
	ElseIF nRadMenu1 == 12 // Opção 12 - Pedidos de venda em aberto

		//Arquivo Cabeçalho
		MsgAlert("Essa opção precisa de 2 arquivos, o primeiro é o arquivo de CABEÇALHO!","ATENÇÃO")
		cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('C5'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		//Arquivo Itens
		MsgAlert("Agora é o arquivo de DETALHE!","ATENÇÃO")
		cArqd := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório onde se encontra o arquivo."), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

		If !File(cArqd)
			MsgStop("O arquivo " +cArqd + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArqd)
		FT_FGOTOP()
		cLinhad    := FT_FREADLN()
		aTipoImpd  := Separa(cLinhad,";",.T.)
		cTipod     := SUBSTR(aTipoImpd[1],1,2)

		IF !(cTIPOd $('C6'))
			MsgAlert('Não é possivel importar a tabela: '+cTipod+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nId := 1 To Len(aTipoImpd)
			IF cTipod <> SUBSTR(aTipoImpd[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImpd[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImpd[nId]+' !!')
				Return
			ELSEIF (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImpd[nId]+' !!')
				Return
			ENDIF
		Next nId

		nTipoImpd  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipod } )

		cTabd := ''
		For nId := 1 To Len(aTabExclui[nTipoImpd,2])
			cTabd += aTabExclui[nTipoImpd,2,nId]+' '
		Next nId

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTabd+"antes da importação ? ")
			For nId := 1 To Len(aTabExclui[nTipoImpd,2])
				cSQLd := "delete from "+RetSqlName(aTabExclui[nTipoImpd,2,nId])
				If (TCSQLExec(cSQLd) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImpd,2,nId] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nId
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinhad := FT_FREADLN()
			If lPrimd
				aCamposd := Separa(cLinhad,";",.T.)
				lPrimd := .F.
			Else
				AADD(aDadosd,Separa(cLinhad,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		cPedC5    := ""
		cPedC6    := ""
		cPedItens := "C6_ITEM/C6_PRODUTO/C6_QTDVEN/C6_PRCVEN/C6_VALOR/C6_TES/C6_ENTREG"

		//Monta array do cabeçalho
		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)
			IncProc("Importando arquivos...")
			aExecAuto  := {}
			aExecAutod := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			cPedC5  := aDados[nI][1]

			//Monta array dos itens
			For nId:=1 to  Len(aDadosd)
				cPedC6  := aDadosd[nId][1]
				aExecAutol := {}
				IF cPedC6 == cPedC5
					For nCamposd := 1 To Len(aCamposd)
						If Alltrim(aCamposd[nCamposd]) $ cPedItens
							IF  SUBSTR(Upper(aCamposd[nCamposd]),4,6)=='FILIAL'
								IF !EMpty(aDadosd[nId,nCamposd])
									cFilAnt := aDadosd[nId,nCamposd]
								ENDIF
							Else
								IF  TamSx3(Upper(aCamposd[nCamposd]))[3] =='N'
									aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]), 	VAL(aDadosd[nId,nCamposd] )	,Nil})
								ELSEIF TamSx3(Upper(aCamposd[nCamposd]))[3] =='D'
									aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]),  CTOD(aDadosd[nId,nCamposd] )	,Nil})
								ELSE
									aAdd(aExecAutol ,{Upper(aCamposd[nCamposd]), 	aDadosd[nId,nCamposd] 	,Nil})
								ENDIF
							ENDIF
						ENDIF
					Next nCamposd
					aAdd(aExecAutod, aExecAutol)
				ENDIF
			Next nId

			// Executa MSEXECAUTO
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y,z| MATA410(x,y,z)},aExecAuto,aExecAutod,3) // SC5/SC6 Pedidos de Venda CABECALHO/ITENS

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Contas a Pagar em aberto SE2
		========================================================
		*/

	ElseIF nRadMenu1 == 13 // Opção 13 - Contas a Pagar em aberto
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('E2'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)

			IncProc("Importando arquivo...")
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|y,z| FINA050(y,z)},aExecAuto,3)   // SE2 Contas a Pagar em aberto MESTRE

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Contas a Receber em aberto SE1
		========================================================
		*/
	ElseIF nRadMenu1 == 14 // Opção 14 - Contas a Receber em aberto
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('E1'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_VISUAL $ ('V') ) .OR. (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)

			IncProc("Importando arquivo...")
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y| FINA040(x,y)},aExecAuto,3)   // SE1 Contas a Receber em aberto MESTRE

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

		/*
		========================================================
		Importa tabela de Ordens de Compra SC1
		========================================================
		*/
	ElseIF nRadMenu1 == 15 // Opção 15 - Ordens de Compra
		If !File(cArq)
			MsgStop("O arquivo " +cArq + " não foi selecionado. A importação será abortada!","ATENCAO")
			Return
		EndIf

		FT_FUSE(cArq)
		FT_FGOTOP()
		cLinha    := FT_FREADLN()
		aTipoImp  := Separa(cLinha,";",.T.)
		cTipo     := SUBSTR(aTipoImp[1],1,2)

		IF !(cTIPO $('C1'))
			MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
			Return
		ENDIF

		dbSelectArea("SX3")
		DbSetOrder(2)
		For nI := 1 To Len(aTipoImp)
			IF cTipo <> SUBSTR(aTipoImp[nI],1,2)
				MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
				Return
			ENDIF
			IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (SX3->X3_CONTEXT == "V"  )
				MsgAlert('Campo marcado na tabela como virtual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI

		nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

		cTab := ''
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cTab += aTabExclui[nTipoImp,2,nI]+' '
		Next nI

		If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
			For nI := 1 To Len(aTabExclui[nTipoImp,2])
				cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
				cSQL := "delete from "+RetSqlName("AO4") + " where AO4_ENTIDA = '" + aTabExclui[nTipoImp,2,nI] + "'"
				If (TCSQLExec(cSQL) < 0)
					Return MsgStop("TCSQLError() " + TCSQLError())
				EndIf
			Next nI
		EndIf

		ProcRegua(FT_FLASTREC())
		FT_FGOTOP()
		While !FT_FEOF()
			IncProc("Lendo arquivo texto...")
			cLinha := FT_FREADLN()
			If lPrim
				aCampos := Separa(cLinha,";",.T.)
				lPrim := .F.
			Else
				AADD(aDados,Separa(cLinha,";",.T.))
			EndIf
			FT_FSKIP()
		EndDo

		// Processando arquivo
		cCpoCab  := "C1_NUM/C1_SOLICIT/C1_EMISSAO"
		cCpoIte  := "C1_ITEM/C1_PRODUTO/C1_QUANT/C1_DATPRF"
		cSolCom  := ""
        cItemPed := "0001"

		ProcRegua(Len(aDados))

		For nI:=1 to  Len(aDados)
			IncProc("Importando arquivo...")

			If cSolCom # aDados[nI][1] .AND. cItemPed == aDados[nI][2]
				IF Len(aExecAuto) > 0
					lMsErroAuto := .F.
					Begin Transaction
						MSExecAuto({|x,y,z| MATA110(x,y,z)},aExecAuto,aExecAutod,3) // SC1 Solicitação de Compra

						//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
						If lMsErroAuto
							aLog := {}
							aLog := GetAutoGRLog()
							If nI <= 100
								DisarmTransaction()
								cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
								//MostraErro()
								For nX :=1 to Len(aLog)
									cLogWritet += aLog[nX]+CRLF
								next nX
								MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
								cFilAnt := cBKFilial
								Return
							Else
								cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
								For nX :=1 to Len(aLog)
									cLogWrite += aLog[nX]+CRLF
								next nX
							Endif
						EndIF
					End Transaction
					aExecAuto  := {}
					aExecAutod := {}
				Endif

				//Montando array de Cabeçalho
				For nCampos := 1 To Len(aCampos)
					If Alltrim(aCampos[nCampos]) $ cCpoCab
						IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
						ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
						ELSE
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
						ENDIF
					ENDIF
				Next nCampos
			Endif
			nCampos := 1
			cSolCom := aDados[nI][1]

			//Monta array de ITENS
			aExecAutol := {}
			For nCampos := 1 To Len(aCampos)-1
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAutol ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAutol ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAutol ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			aAdd(aExecAutod, aExecAutol)
		Next nI

		// Processa execauto da ultima linha do arquivo lido
		lMsErroAuto := .F.
		Begin Transaction
			MSExecAuto({|x,y,z| MATA110(x,y,z)},aExecAuto,aExecAutod,3) // SC1 Solicitação de Compra
			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
				cFilAnt := cBKFilial
				Return
			EndIF
		End Transaction

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial

/*		ProcRegua(Len(aDados))
		For nI:=1 to  Len(aDados)

			IncProc("Importando arquivo...")
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y| MATA110(x,y)},aExecAuto,3) // SC1 Ordes de compra em aberto

				//Caso ocorra erro, verifica se ocorreu antes ou depois dos primeiros 100 registros do arquivo
				If lMsErroAuto
					aLog := {}
					aLog := GetAutoGRLog()
					If nI <= 100
						DisarmTransaction()
						cLogWritet += "Linha do erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						//MostraErro()
						For nX :=1 to Len(aLog)
							cLogWritet += aLog[nX]+CRLF
						next nX
						MsgAlert(StrTran(cLogWritet,"< --","-->"),"Erro no arquivo!")
						cFilAnt := cBKFilial
						Return
					Else
						cLogWrite += "Linha com o erro no arquivo CSV: "+str(nI+1)+CRLF+CRLF
						For nX :=1 to Len(aLog)
							cLogWrite += aLog[nX]+CRLF
						next nX
					Endif
				EndIF
			End Transaction
		Next nI

		//Grava arquivo de LOG caso o erro ocorra depois do 100o registro
		If !Empty(cLogWrite)
			cTime     := Time()
			cLogDir   := cGetFile("Arquivo |*.log", OemToAnsi("Informe o diretório para gravar o LOG."), 0, "SERVIDOR\", .T., GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ,.F.)
			cLogFile  := cLogDir+"IMP_"+substr(cTime,1,2)+substr(cTime,4,2)+substr(cTime,7,2)+".LOG"
			nHandle   := MSFCreate(cLogFile,0)
			FWrite(nHandle,cLogWrite)
			FClose(nHandle)
			msgAlert("LOG de erro gerado em "+cLogFile)
		Else
			MsgInfo("Arquivo importado com sucesso!!")
		Endif
		FT_FUSE()
		cFilAnt := cBKFilial
*/
	Endif
Return
