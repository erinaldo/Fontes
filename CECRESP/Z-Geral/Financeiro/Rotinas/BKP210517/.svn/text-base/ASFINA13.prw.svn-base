#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FILEIO.CH'
#INCLUDE "RWMAKE.CH"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA13()

Importação de baixas de títulos a receber de parceiros, via CSV

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		28/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA13()
	LOCAL aArea		:= GetArea()
	LOCAL nOpc     	:= 0
	LOCAL aSay   	:= {}
	LOCAL aButton 	:= {}    
	LOCAL cDesc1	:= OemToAnsi('O objetivo desta rotina é importar arquivo CSV de baixas.   ')
	LOCAL cDesc2	:= OemToAnsi('                                                            ')
	LOCAL cDesc3	:= OemToAnsi('')
	LOCAL cDesc4	:= OemToAnsi('Abrir = Importar arquivo')
	LOCAL cDesc5	:= OemToAnsi('Salvar = Visualizar registros importados e processar a baixa')
	LOCAL cDesc6	:= OemToAnsi('')
	LOCAL cDesc7  	:= OemToAnsi('')
	LOCAL aPar		:= {}
	LOCAL aRet		:= {}
	LOCAL cRetImp	:= ""
	LOCAL cMsgInfo	:= ""
	LOCAL cOpcBaixa	:= "1=Baixar não processados"
	LOCAL nRetOpen	:= 0
	LOCAL nTolVal	:= 0
	LOCAL nTolPer	:= 0
	
	PRIVATE cCadastro 	:= OEMTOANSI("Importação de baixa de títulos a receber de parceiros")
	PRIVATE nProcess	:= 0
	PRIVATE nErroProc	:= 0
	PRIVATE cCRLF		:= CHR(13) + CHR(10)
	PRIVATE cArqCSV		:= ""
	PRIVATE cArqLog		:= ""
	PRIVATE cArqErrLog	:= ""	
		
	// Mensagens de Tela Inicial
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	aAdd( aSay, cDesc4 )
	aAdd( aSay, cDesc5 )
	aAdd( aSay, cDesc6 )
	aAdd( aSay, cDesc7 )

	aAdd( aButton, { 14,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 13,.T.,{|| nOpc := 2,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( cCadastro, aSay, aButton )

	IF nOpc == 1	
		//-----------------------------------------------------------------------
		// Definição dos Parametros da Rotina
		//-----------------------------------------------------------------------
		// 6 - File
		//  [2] : Descrição
		//  [3] : String contendo o inicializador do campo
		//  [4] : String contendo a Picture do campo
		//  [5] : String contendo a validação
		//  [6] : String contendo a validação When
		//  [7] : Tamanho do MsGet
		//  [8] : Flag .T./.F. Parâmetro Obrigatório ?
		//  [9] : Texto contendo os tipos de arquivo Ex.: "Arquivos .CSV |*.CSV"
		//  [10]: Diretório inicial do cGetFile
		//  [11]: PARAMETROS do cGETFILE

		aAdd(aPar,{6	,"Arquivo de origem"		,SPACE(200)	, "", , ,080,.T.,"Arquivos .CSV |*.CSV"})
		aAdd(aPar,{1	,"Tolerância em valor"		,0			, "@E 9,999.99", , 		, , 020, .F.})
		aAdd(aPar,{1	,"Tolerância em percentual"	,0			, "@E 999.99", , 		, , 020, .F.})
		
		//Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet

		lRet 	:= ParamBox(aPar,"",@aRet,,,,,,,"ASFINA13A",.T.,.T.)
		IF lRet
			IF !Len(aRet) == Len(aPar)
				MsgAlert("É necessário indicar os parâmetros da importação do arquivo CSV!", "Atenção")
			ELSE
				//-----------------------------------------------------------------------
				// Processa
				//-----------------------------------------------------------------------
				cArqCSV	:= ALLTRIM( aRet[01] )
				nTolVal	:= aRet[02]
				nTolPer	:= aRet[03]
				cRetImp	:= ""
				Processa({|| cRetImp := Importa( cArqCSV, nTolVal, nTolPer )},"Processando", "", .F.)

				IF EMPTY(cRetImp)
					IF !EMPTY(cArqLog)
						IF MsgYesNo( "Processo concluído. Foi(ram) lido(s) " + ALLTRIM(STR(nProcess)) + " registro(s). Foi(ram) encontrado(s) " + ALLTRIM(STR(nErroProc)) + " erro(s). Deseja abrir o arquivo com o log de erros?", "Confirme")
							nRetOpen := ShellExecute("OPEN", SUBSTR( cArqLog, RAT("\", cArqLog)+1, LEN(cArqLog) ), "", LEFT( cArqLog, RAT("\", cArqLog) ), 1)
							IF nRetOpen <= 32
								MsgAlert("Não foi possível abrir o arquivo " + cArqLog + "!", "Atenção")
							ENDIF 
						ENDIF
					ELSE
						MsgInfo( "Processo concluído. Foi(ram) lido(s) " + ALLTRIM(STR(nProcess)) + " registro(s).", "Ok")
					ENDIF
				
					IF MsgYesNo("Deseja processar as baixas?", "Confirme")
						//-----------------------------------------------------------------------
						// Processa
						//-----------------------------------------------------------------------
						cOpcBaixa := "1=Baixar não processados"
						Processa({|| TelaMark(cOpcBaixa)},"Selecionando registros", "", .F.)
					ENDIF
				ELSE
					MsgAlert(cRetImp,"Atenção")
				ENDIF	
			ENDIF
		ENDIF
	ELSEIF nOpc == 2
		//-----------------------------------------------------------------------
		// Definição dos Parametros da Rotina
		//-----------------------------------------------------------------------
		// 2 - Combo
		// [2] : Descrição
		// [3] : Numérico contendo a opção inicial do combo
		// [4] : Array contendo as opções do Combo
		// [5] : Tamanho do Combo
		// [6] : Validação
		// [7] : Flag .T./.F. Parâmetro Obrigatório ?

		aAdd(aPar,{2	,"Opção"		,cOpcBaixa	, {"1=Baixar não processados","2=Consultar já processados"},090,,.T.})
		
		//Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet

		lRet 	:= ParamBox(aPar,"",@aRet,,,,,,,"ASFINA13B",.T.,.T.)
		IF lRet
			IF !Len(aRet) == Len(aPar)
				MsgAlert("É necessário selecionar uma das opções!", "Atenção")
			ELSE
				//-----------------------------------------------------------------------
				// Processa
				//-----------------------------------------------------------------------
				cOpcBaixa := aRet[01]
				Processa({|| TelaMark(cOpcBaixa)},"Selecionando registros", "", .F.)
			ENDIF
		ENDIF
  
	ENDIF

	RestArea( aArea )
	
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} Importa

Importação de baixa de títulos a receber via CSV 

@param		cArqCSV = Local e nome do arquivo CSV
			nTolVal, nTolPer
@return		cRetImp = Mensagem de retorno preenchida quando tiver erro 
@author 	Fabio Cazarini
@since 		28/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION Importa( cArqCSV, nTolVal, nTolPer )
	LOCAL nHandle 	:= 0
	LOCAL cCabec		:= ""
	LOCAL aCabec		:= {}
	LOCAL cLinha		:= ""
	LOCAL aLinha		:= {}
	LOCAL nLinha		:= 0
	LOCAL lEmptyStr		:= .T.
	LOCAL cRetImp		:= ""
	LOCAL nX			:= 0
	LOCAL nY			:= 0
	LOCAL cCampo		:= ""

	LOCAL nPOSEMPR 		:= 0
	LOCAL nPOSBLOC 		:= 0				
	LOCAL nPOSUNID 		:= 0				
	LOCAL nPOSCPFC 		:= 0				
	LOCAL nPOSPARC 		:= 0				
	LOCAL nPOSCOMP 		:= 0				
	LOCAL nPOSGRUP 		:= 0				
	LOCAL nPOSVLPA 		:= 0				
	LOCAL nPOSPCPA 		:= 0				
	LOCAL nPOSDTBA 		:= 0																																	

	LOCAL cEMPREEN 		:= ""
	LOCAL cBLOCO 		:= ""				
	LOCAL cUNIDADE 		:= ""				
	LOCAL cCPFCNPJ 		:= ""				
	LOCAL cPARCELA 		:= ""				
	LOCAL cCOMPONE 		:= ""				
	LOCAL cGRUPO 		:= ""				
	LOCAL nVLPAGO 		:= 0				
	LOCAL nPCPART 		:= 0				
	LOCAL dDTBAIXA 		:= CTOD("//")																																	
	
	LOCAL aFields		:= {}
	LOCAL xFieldVal		
	LOCAL lBaixaReg		:= .T.
	LOCAL aRegSobrep	:= {}
	LOCAL cQuery		:= ""
	LOCAL nCampo		:= 0
	LOCAL cCPFCNPJRM	:= ""
	LOCAL nVLATTIN		:= 0
	LOCAL nVLATDES		:= 0
	LOCAL cVALOK		:= "N"
	LOCAL nVLPART		:= 0
	LOCAL lCliOk 		:= .F.
	LOCAL nDIFVAL		:= 0
	LOCAL aTitE1		:= {}
	
	//-----------------------------------------------------------------------
	// Abre o arquivo origem CSV
	//-----------------------------------------------------------------------
	nHandle := FT_FUse(cArqCSV)
	IF nHandle < 0
		cRetImp := "Nao foi possivel abrir o arquivo " + cArqCSV
		RETURN cRetImp
	ENDIF

	//-----------------------------------------------------------------------
	// Monta TRB com registros não processados Z8_DTPROC = ''
	//-----------------------------------------------------------------------
	cQuery := " SELECT SZ8.R_E_C_N_O_  AS REGSZ8 "
	cQuery += " FROM " + RetSqlName("SZ8") + " SZ8 "
	cQuery += " WHERE	SZ8.Z8_FILIAL = '" + xFILIAL("SZ8") + "' " 
	cQuery += " 	AND SZ8.Z8_DTPROC = ' ' "
	cQuery += " 	AND SZ8.D_E_L_E_T_ = ' '	"

	IF SELECT("TRBSZ8") > 0
		TRBSZ8->( dbCloseArea() )
	ENDIF    
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSZ8" ,.F.,.T.)

	//-----------------------------------------------------------------------
	// Processa arquivo texto CSV
	//-----------------------------------------------------------------------
	ProcRegua( 0 )
	nProcess	:= 0
	nLinha		:= 0
	FT_FGOTOP()
	DO WHILE !FT_FEOF()
		IncProc( "Aguarde..." + ALLTRIM(STR(nLinha)) )
		//-----------------------------------------------------------------------
		// Valida o cabecalho - nome dos campos
		//-----------------------------------------------------------------------
		IF nLinha == 0 // cabecalho
			nLinha++
			cCabec 	:= FT_FREADLN()
			cCabec	:= STRTRAN(cCabec, "ï»¿", "")
			aCabec	:= {}
			aCabec 	:= StrTokArr2(cCabec, ";", lEmptyStr)

			IF LEN(aCabec) == 0
				cRetImp	:= "Estrutura do arquivo inválida: O cabeçalho do arquivo não tem o nome dos campos"
				EXIT
			ENDIF

			FOR nX := 1 TO LEN(aCabec)
				cCampo	:= ALLTRIM(aCabec[nX])

				IF PADR(cCampo,10) $ "Z8_FILIAL |Z8_CHVRM  |Z8_CHVPROT|Z8_VLATTIN|Z8_VLATDES|Z8_VALOK  |Z8_VLPART |Z8_DTPROC "
					cRetImp	:= "Estrutura do arquivo inválida: Campo especificado no cabeçalho não é válido (controle): " + cCampo
					EXIT
				ENDIF
				
				DbSelectArea("SX3")
				DbSetOrder(2) // X3_CAMPO
				IF MsSEEK( PADR(cCampo, LEN(SX3->X3_CAMPO) ) ) 
					AADD( aFields, {cCampo, SX3->X3_TIPO, SX3->X3_TAMANHO} )
				ELSE
					cRetImp	:= "Estrutura do arquivo inválida: Campo especificado no cabeçalho não é válido: " + cCampo
					EXIT
				ENDIF	

				IF cCampo == "Z8_EMPREEN"
					nPOSEMPR := nX
				ELSEIF cCampo == "Z8_BLOCO"
					nPOSBLOC := nX				
				ELSEIF cCampo == "Z8_UNIDADE"
					nPOSUNID := nX				
				ELSEIF cCampo == "Z8_CPFCNPJ"
					nPOSCPFC := nX				
				ELSEIF cCampo == "Z8_PARCELA"
					nPOSPARC := nX				
				ELSEIF cCampo == "Z8_COMPONE"
					nPOSCOMP := nX				
				ELSEIF cCampo == "Z8_GRUPO"
					nPOSGRUP := nX				
				ELSEIF cCampo == "Z8_VLPAGO"
					nPOSVLPA := nX				
				ELSEIF cCampo == "Z8_PCPART"
					nPOSPCPA := nX				
				ELSEIF cCampo == "Z8_DTBAIXA"
					nPOSDTBA := nX																																	
				ENDIF	
			NEXT nX

			IF nPOSEMPR == 0
				cRetImp	:= "Estrutura do arquivo inválida: Campo obrigatório não informado " + "Z8_EMPREEN"
				EXIT
			ENDIF
			IF nPOSBLOC == 0				
				cRetImp	:= "Estrutura do arquivo inválida: Campo obrigatório não informado " + "Z8_BLOCO"
				EXIT
			ENDIF
			IF nPOSUNID == 0				
				cRetImp	:= "Estrutura do arquivo inválida: Campo obrigatório não informado " + "Z8_UNIDADE"
				EXIT
			ENDIF
			IF nPOSCPFC == 0				
				cRetImp	:= "Estrutura do arquivo inválida: Campo obrigatório não informado " + "Z8_CPFCNPJ"
				EXIT
			ENDIF
			IF nPOSPARC == 0				
				cRetImp	:= "Estrutura do arquivo inválida: Campo obrigatório não informado " + "Z8_PARCELA"
				EXIT
			ENDIF
			IF nPOSCOMP == 0				
				cRetImp	:= "Estrutura do arquivo inválida: Campo obrigatório não informado " + "Z8_COMPONE"
				EXIT
			ENDIF
			IF nPOSGRUP == 0				
				cRetImp	:= "Estrutura do arquivo inválida: Campo obrigatório não informado " + "Z8_GRUPO"
				EXIT
			ENDIF
			IF nPOSVLPA == 0				
				cRetImp	:= "Estrutura do arquivo inválida: Campo obrigatório não informado " + "Z8_VLPAGO"
				EXIT
			ENDIF
			IF nPOSPCPA == 0				
				cRetImp	:= "Estrutura do arquivo inválida: Campo obrigatório não informado " + "Z8_PCPART"
				EXIT
			ENDIF
			IF nPOSDTBA == 0																																	
				cRetImp	:= "Estrutura do arquivo inválida: Campo obrigatório não informado " + "Z8_DTBAIXA"
				EXIT
			ENDIF
			
			IF !EMPTY(cRetImp)
				EXIT
			ENDIF

			FT_FSKIP()
			LOOP
		ENDIF

		//-----------------------------------------------------------------------
		// Lê a linha
		//-----------------------------------------------------------------------
		nLinha++
		cLinha 	:= FT_FREADLN()
		aLinha	:= {}
		aLinha 	:= StrTokArr2(cLinha, ";", lEmptyStr)
		
		IF EMPTY(cLinha)
			FT_FSKIP()
			LOOP
		ENDIF

		IF LEN(aFields) <> LEN(aLinha)
			LogSZ8Erro("Registro inválido - Colunas do registro divergem com o cabeçalho do arquivo CSV", nLinha)
			nErroProc++
		ELSE
			//-----------------------------------------------------------------------
			// Importa a linha
			//-----------------------------------------------------------------------
			cEMPREEN 	:= PADR( aLinha[nPOSEMPR], TAMSX3("Z8_EMPREEN")[1] )
			cBLOCO 		:= PADR( aLinha[nPOSBLOC], TAMSX3("Z8_BLOCO")[1] )				
			cUNIDADE 	:= PADR( aLinha[nPOSUNID], TAMSX3("Z8_UNIDADE")[1] )				
			cCPFCNPJ 	:= PADR( STRTRAN(STRTRAN(STRTRAN(STRTRAN(aLinha[nPOSCPFC],"-",""),".",""),"\",""),"/",""), TAMSX3("Z8_CPFCNPJ")[1] )				
			cPARCELA 	:= PADR( aLinha[nPOSPARC], TAMSX3("Z8_PARCELA")[1] )				
			cCOMPONE 	:= PADR( aLinha[nPOSCOMP], TAMSX3("Z8_COMPONE")[1] )				
			cGRUPO 		:= PADR( aLinha[nPOSGRUP], TAMSX3("Z8_GRUPO")[1] )
			nVLPAGO 	:= ROUND( VAL( STRTRAN(aLinha[nPOSVLPA],",",".") ), TAMSX3("Z8_VLPAGO")[2] )
			nPCPART 	:= ROUND( VAL( STRTRAN(aLinha[nPOSPCPA],",",".") ), TAMSX3("Z8_PCPART")[2] )
			IF "\" $ aLinha[nPOSDTBA]
				dDTBAIXA 	:= CTOD( aLinha[nPOSDTBA] )
			ELSE
				dDTBAIXA 	:= STOD( aLinha[nPOSDTBA] )		
			ENDIF																																		
	
			//-----------------------------------------------------------------------
			// Grava dados na tabela SZ8
			//-----------------------------------------------------------------------
			lBaixaReg := .T.
			DbSelectArea("SZ8")
			DbSetOrder(1) // Z8_FILIAL+Z8_EMPREEN+Z8_BLOCO+Z8_UNIDADE+Z8_CPFCNPJ+Z8_PARCELA+Z8_COMPONE+Z8_GRUPO
			IF MsSeek(xFILIAL("SZ8") + cEMPREEN + cBLOCO + cUNIDADE + cCPFCNPJ + cPARCELA + cCOMPONE + cGRUPO) 
				IF !EMPTY(SZ8->Z8_DTPROC) // registro já processado (baixado)
					//LogSZ8Erro("Já baixado: " + cCRLF +;
					// 				"Empreendimento: " + cEMPREEN + cCRLF +;
					// 				"Unidade (Quadra): " + cBLOCO + cCRLF +;
					// 				"Subunidade (Nro. Lote): " + cUNIDADE + cCRLF +;
					// 				"Cpf/Cnpj Cliente: " + cCPFCNPJ + cCRLF +;
					// 				"Parcela: " + cPARCELA + cCRLF +;
					// 				"Componente: " + cCOMPONE + cCRLF +;
					// 				"Grupo: " + cGRUPO ;				 								 								 								 								 								 				
					// 			, nLinha)
					//nErroProc++
					//lBaixaReg := .F.

					//-----------------------------------------------------------------------
					// Se já baixado, reprocessa (ExecAuto valida de já baixado)
					//-----------------------------------------------------------------------
					RecLock("SZ8", .F. )
					SZ8->Z8_DTPROC := CTOD("//")
				ELSE
					RecLock("SZ8", .F. )
				ENDIF
			ELSE
				RecLock("SZ8", .T. )	
				SZ8->Z8_FILIAL := xFILIAL("SZ8")	
			ENDIF
			
			IF lBaixaReg

				cCPFCNPJRM 	:= IIF( LEN(ALLTRIM(cCPFCNPJ)) > 11, TRANSFORM(cCPFCNPJ, "@r 99.999.999/9999-99") , TRANSFORM(cCPFCNPJ, "@r 999.999.999-99") )
				cCHVPROT 	:= U_ASFINA27( cEMPREEN, cBLOCO, cUNIDADE, cCPFCNPJRM, cPARCELA, cCOMPONE, cGRUPO, .T. )

				//-----------------------------------------------------------------------
				// 01|0010001|1|TST000183||NF
				// Sendo: 
				// 01| 			-> 1 - Grupo de Empresas
				// 0010001| 	-> 2 - Filial 
				// 1| 			-> 3 - Prefixo
				// TST000183| 	-> 4 - Número do Título
				//  | 			-> 5 - Parcela
				// NF 			-> 6 - Tipo
				//-----------------------------------------------------------------------
				//aTitE1 := STRTOKARR(cCHVPROT, "|")
				aTitE1 := SEPARA(cCHVPROT, "|")
				IF LEN(aTitE1) < 6
					cCHVPROT	:= SPACE(LEN(cEMPANT)) + SPACE(LEN(cFILANT)) + SPACE(TAMSX3("E1_PREFIXO")[1]) + SPACE(TAMSX3("E1_NUM")[1]) + SPACE(TAMSX3("E1_PARCELA")[1]) + SPACE(TAMSX3("E1_TIPO")[1])
				ELSE 
					cCHVPROT	:= PADR(SUBSTR(aTitE1[2],1,LEN(ALLTRIM(XFILIAL("SE1")))), LEN(cFILANT))
					cCHVPROT	+= PADR(aTitE1[3], TAMSX3("E1_PREFIXO")[1])
					cCHVPROT	+= PADR(aTitE1[4], TAMSX3("E1_NUM")[1])
					cCHVPROT	+= PADR(aTitE1[5], TAMSX3("E1_PARCELA")[1])					
					cCHVPROT	+= PADR(aTitE1[6], TAMSX3("E1_TIPO")[1])
				ENDIF

				nVLATTIN	:= 0
				nVLATDES	:= 0
				cVALOK		:= "N"
				nVLPART		:= 0

				//-----------------------------------------------------------------------
				// Localiza e valida se o CPF/CNPJ confere (importação vs título) 
				//-----------------------------------------------------------------------
				IF !EMPTY(cCHVPROT)
					DbSelectArea("SE1")
					DbSetOrder(1) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
					IF MsSEEK( ALLTRIM(cCHVPROT) )
						DbSelectArea("SA1")
						DbSetOrder(1) // A1_FILIAL+A1_COD+A1_LOJA
						IF MsSEEK( xFILIAL("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA)
							lCliOk 		:= .F.
							
							IF !EMPTY(cCPFCNPJ) .OR. !EMPTY(SA1->A1_CGC)
								IF ALLTRIM(cCPFCNPJ) == ALLTRIM(SA1->A1_CGC)
									lCliOk := .T.
								ENDIF
							ELSE
								lCliOk := .T.
							ENDIF
							
							IF lCliOk
								//-----------------------------------------------------------------------
								// Retorna o saldo atual do título a receber, com decréscimo, acréscimo, 
								// multa, taxa de permanência
								//-----------------------------------------------------------------------
								nDescont	:= 0 // participação do parceiro
								nVLATTIN	:= RetValAtu(SE1->E1_FILIAL, SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO, dDTBAIXA, @nDescont)
								nVLATDES	:= nDescont
								nVLPART		:= nVLATTIN - nVLATDES
								
								IF nVLPAGO == nVLATTIN
									cVALOK := "S"
								ELSE
									//-----------------------------------------------------------------------
									// Verifica se a diferença está dentro da tolerância 
									// (a menor entre valor e percentual)
									//-----------------------------------------------------------------------
									nDIFVAL := ABS(nVLPAGO - nVLATTIN)
									IF nDIFVAL > nTolVal .AND. nTolVal > 0
										cVALOK := "N"
									ELSE
										IF nDIFVAL > (nVLATTIN * nTolPer / 100) .AND. nTolPer > 0
											cVALOK := "N"
										ELSE
											//IF nVLPAGO > nVLATTIN
												cVALOK := "N"
											//ELSE
												cVALOK := "S"
											//ENDIF	
										ENDIF
									ENDIF
								ENDIF
							ELSE
								LogSZ8Erro("CPF/CNPJ não confere: " + cCRLF +;
								 				"Empreendimento: " + cEMPREEN + cCRLF +;
								 				"Unidade (Quadra): " + cBLOCO + cCRLF +;
								 				"Subunidade (Nro. Lote): " + cUNIDADE + cCRLF +;
								 				"Cpf/Cnpj Cliente: " + cCPFCNPJ + cCRLF +;
								 				"Cpf/Cnpj Título: " + ALLTRIM(SA1->A1_CGC) + cCRLF +;
								 				"Parcela: " + cPARCELA + cCRLF +;
								 				"Componente: " + cCOMPONE + cCRLF +;
								 				"Grupo: " + cGRUPO +;
								 				"Chave Protheus: " + cCHVPROT ;				 								 								 								 								 								 				
								 			, nLinha)
								nErroProc++
							ENDIF
						ELSE
							LogSZ8Erro("CPF/CNPJ não encontrado: " + cCRLF +;
							 				"Empreendimento: " + cEMPREEN + cCRLF +;
							 				"Unidade (Quadra): " + cBLOCO + cCRLF +;
							 				"Subunidade (Nro. Lote): " + cUNIDADE + cCRLF +;
							 				"Cpf/Cnpj Cliente: " + cCPFCNPJ + cCRLF +;
							 				"Parcela: " + cPARCELA + cCRLF +;
							 				"Componente: " + cCOMPONE + cCRLF +;
							 				"Grupo: " + cGRUPO +;
							 				"Chave Protheus: " + cCHVPROT ;				 								 								 								 								 								 				
							 			, nLinha)
							nErroProc++
						ENDIF
					ELSE
						LogSZ8Erro("Título não encontrado: " + cCRLF +;
						 				"Empreendimento: " + cEMPREEN + cCRLF +;
						 				"Unidade (Quadra): " + cBLOCO + cCRLF +;
						 				"Subunidade (Nro. Lote): " + cUNIDADE + cCRLF +;
						 				"Cpf/Cnpj Cliente: " + cCPFCNPJ + cCRLF +;
						 				"Parcela: " + cPARCELA + cCRLF +;
						 				"Componente: " + cCOMPONE + cCRLF +;
						 				"Grupo: " + cGRUPO +;
						 				"Chave Protheus: " + cCHVPROT ;				 								 								 								 								 								 				
						 			, nLinha)
						nErroProc++
					ENDIF
				ELSE
					LogSZ8Erro("Título não encontrado: " + cCRLF +;
					 				"Empreendimento: " + cEMPREEN + cCRLF +;
					 				"Unidade (Quadra): " + cBLOCO + cCRLF +;
					 				"Subunidade (Nro. Lote): " + cUNIDADE + cCRLF +;
					 				"Cpf/Cnpj Cliente: " + cCPFCNPJ + cCRLF +;
					 				"Parcela: " + cPARCELA + cCRLF +;
					 				"Componente: " + cCOMPONE + cCRLF +;
					 				"Grupo: " + cGRUPO +;
					 				"Chave Protheus: " + cCHVPROT ;				 								 								 								 								 								 				
					 			, nLinha)
					nErroProc++
				ENDIF
				
				DbSelectArea("SZ8")
				SZ8->Z8_CHVPROT := cCHVPROT 	// chave primária do Protheus
				SZ8->Z8_VLATTIN := nVLATTIN 	// Valor Atualizado 
				SZ8->Z8_VLATDES := nVLATDES 	// Valor Atualizado do desconto (participação do parceiro)
				SZ8->Z8_VALOK	:= cVALOK 		// Valor consistente com o TIN RM: S = SIM / N = NÃO
				SZ8->Z8_VLPART	:= nVLPART 		// Valor pago – taxa administração – seg. prestamista
				
				FOR nY := 1 TO LEN(aFields)
					IF aFields[nY][02] == "N"
						xFieldVal := ROUND( VAL( ALLTRIM(STRTRAN(aLinha[nY],",",".")) ), TAMSX3(aFields[nY][01])[2] )
					ELSEIF aFields[nY][02] == "D"
						IF "\" $ ALLTRIM(aLinha[nY])
							xFieldVal := CTOD( ALLTRIM(aLinha[nY]) )
						ELSE
							xFieldVal := STOD( ALLTRIM(aLinha[nY]) )						
						ENDIF
					ELSEIF aFields[nY][02] == "L"
						xFieldVal := IIF( ALLTRIM(aLinha[nY]) == '.T.', .T., .F.)				
					ELSEIF aFields[nY][02] == "C"
						IF ALLTRIM(aFields[nY][01]) == "Z8_CPFCNPJ"
							xFieldVal := cCPFCNPJ
						ELSE
							xFieldVal := PADR(aLinha[nY], aFields[nY][03])
						ENDIF	
					ELSE // Memo
						xFieldVal := aLinha[nY]
					ENDIF										
					
					nCampo := SZ8->( FIELDPOS(aFields[nY][01]) )
					IF nCampo > 0
						SZ8->( FIELDPUT( nCampo , xFieldVal) )
					ENDIF	
				NEXT nY
		
				SZ8->( MsUnLock() )
				AADD( aRegSobrep, SZ8->( RECNO() ) ) // armazena linha sobreposta (para não apagar no final do processo)
				nProcess++
			ENDIF
		ENDIF
		
		FT_FSKIP()
	ENDDO
	FT_FUSE()

	//-----------------------------------------------------------------------
	// Limpa registros não processados EMPTY(SZ8->Z8_DTPROC )
	//-----------------------------------------------------------------------
	DbSelectArea("TRBSZ8")
	DbGoTop()
	DO WHILE !EOF()
		nREGSZ8 := TRBSZ8->REGSZ8
	
		IF ASCAN(aRegSobrep , nREGSZ8) == 0 // deleta o registro se ele não foi reprocessado (sobreposto)
			DbSelectArea("SZ8")
			DbGoTo( nREGSZ8 )
			RecLock("SZ8", .F. )
			SZ8->( DbDelete() )
			SZ8->( MsUnLock() )
		ENDIF
		
		DbSelectArea("TRBSZ8")
		DbSkip()
	ENDDO
	TRBSZ8->( DbCloseArea() )
	
RETURN cRetImp


//-----------------------------------------------------------------------
/*/{Protheus.doc} LogSZ8Erro()

Loga erro, gerando arquivo no mesmo local do arquivo origem

@param		cDesErro = Descrição do erro
			nLinha = Número da linha em que ocorreu o erro
@return		Nenhum
@author 	Fabio Cazarini
@since 		28/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION LogSZ8Erro(cDesErro, nLinha )
	LOCAL nHandle 	:= 0
	LOCAL cSeq		:= "000"
	
	IF EMPTY(cArqLog)
		cArqLog := LEFT( cArqCSV, RAT("\", cArqCSV) ) + "BAIXAREC_" + DTOS(dDATABASE)
		DO WHILE .T.
			cSeq := SOMA1(cSeq)
			IF !FILE(cArqLog + "_" + cSeq + ".LOG")
				cArqLog := cArqLog + "_" + cSeq + ".LOG"
				EXIT
			ENDIF
		ENDDO  
		nHandle := FCREATE(cArqLog)
		IF nHandle > 0
			FWRITE(nHandle, "================================================================================" + cCRLF)
		ENDIF
	ELSE
		nHandle := FOPEN(cArqLog , FO_READWRITE + FO_SHARED )                                       
	ENDIF
	
	IF nHandle > 0
		FSEEK(nHandle, 0, FS_END)
		FWRITE(nHandle, "Linha: " + STRZERO(nLinha,6) + cCRLF + cCRLF)
		FWRITE(nHandle, cDesErro + cCRLF)
		FWRITE(nHandle, "--------------------------------------------------------------------------------" + cCRLF)
		
		FCLOSE(nHandle)
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} TelaMark()

Tela estilo MarkBrowse para seleção dos registros de baixa

@param		cOpcBaixa = 1=Baixar não processados,2=Consultar já processados
@return		Nenhum
@author 	Fabio Cazarini
@since 		29/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION TelaMark(cOpcBaixa)
	
	LOCAL aCores    	:= {}
	
	PRIVATE arotina 	:= {}
	PRIVATE cCADASTRO	:= "Baixas de parceiros"
	PRIVATE cMark		:= GetMark()
	PRIVATE aFields		:= {}
	PRIVATE cArq		:= ""
	PRIVATE bOpc1 		:= {|| MarcaTud()}
	PRIVATE bOpc2 		:= {|| MarcaIte()}
	PRIVATE cErrLog		:= ""

	IF LEFT(cOpcBaixa,1) == "1"
		AADD( aRotina, { "Executar a baixa"	,"U_ASFIA13B" 	, 0, 4} )
		AADD( aRotina, { "Visualiza log" 	,"U_ASFIA13C" 	, 0, 4} )
	ENDIF	

	aCores := {;
					{'TRB->ERREXEC'										,'BR_PRETO'		},;
					{'!EMPTY(TRB->Z8_DTPROC)'							,'BR_VERMELHO'	},;
			 		{'TRB->Z8_VALOK <> "N" .AND. EMPTY(TRB->Z8_DTPROC)'	,'BR_VERDE'		},;
			 		{'TRB->Z8_VALOK == "N" .AND. EMPTY(TRB->Z8_DTPROC)'	,'BR_AMARELO'	};
			 	}

	//-----------------------------------------------------------------------
	// Gera arquivo temporario 
	//-----------------------------------------------------------------------
	Processa({|| MontaTrb(cOpcBaixa)},"Processando...", "", .F.)

	DbSelectArea("TRB")
	DbGotop()
	MarkBrow( 'TRB', 'Z8_OK',,aFields,, cMark ,"Eval(bOpc1)"   ,,,,"Eval(bOpc2)"   ,,,.T.,aCores)
	
	//-----------------------------------------------------------------------
	// Apaga a tabela temporária
	//-----------------------------------------------------------------------
	DbSelectArea("TRB")
	DbCloseArea() 
	MsErase(cArq+GetDBExtension(),,"DBFCDX")

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} MontaTRB

Monta arquivo temporario de acordo com os parametros selecionados

@param		cOpcBaixa = 1=Baixar não processados,2=Consultar já processados
@return		Nenhum
@author 	Fabio Cazarini
@since 		29/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MontaTRB(cOpcBaixa)
	//-----------------------------------------------------------------------
	// Declaracao de Variaveis
	//-----------------------------------------------------------------------
	LOCAL aStru		:= {}
	LOCAL aCampos	:= {}
	LOCAL nX          
	LOCAL bCampo
	LOCAL cCampo	:= ""
	LOCAL cQuery	:= ""
	LOCAL nREGSZ8	:= 0

	//-----------------------------------------------------------------------
	// Monta TRB com registros não processados Z8_DTPROC = ''
	//-----------------------------------------------------------------------
	cQuery := " SELECT SZ8.R_E_C_N_O_  AS REGSZ8 "
	cQuery += " FROM " + RetSqlName("SZ8") + " SZ8 "
	cQuery += " WHERE	SZ8.Z8_FILIAL = '" + xFILIAL("SZ8") + "' " 
	IF LEFT(cOpcBaixa,1) == "1" 	// 1=Baixar não processados
		cQuery += " 	AND SZ8.Z8_DTPROC = ' ' "
	ELSE				// 2=Consultar já processados
		cQuery += " 	AND SZ8.Z8_DTPROC <> ' ' "
	ENDIF	
	cQuery += " 	AND SZ8.D_E_L_E_T_ = ' '	"

	IF SELECT("TRBSZ8") > 0
		TRBSZ8->( dbCloseArea() )
	ENDIF    
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSZ8" ,.F.,.T.)

	ProcRegua(0)

	//-----------------------------------------------------------------------
	// Cria arquivo temporario
	//-----------------------------------------------------------------------
	aStru	:= {}
	aFields	:= {}
	aCampos	:= {}

	//-----------------------------------------------------------------------
	// Para criar a estrutura temporaria
	//-----------------------------------------------------------------------
	AADD(aStru,	{"Z8_OK"	, "C", TAMSX3("E1_OK")[01]	, 0	})
	AADD(aStru,	{"SZ8REG"	, "N", 10					, 0	})
	AADD(aStru,	{"RETEXEC"	, "C", 254					, 0	})
	AADD(aStru,	{"ERREXEC"	, "L", 1					, 0	})
	
	//-----------------------------------------------------------------------
	// Lista das colunas do MarkBrowse
	//-----------------------------------------------------------------------
	AADD(aFields,	{"Z8_OK", "", ""})

	dbSelectArea("SX3")
	DbSetOrder(1)
	DbGoTop()
	dbSeek("SZ8")
	While !Eof().And.(SX3->x3_arquivo=="SZ8")
		If 			Alltrim(SX3->x3_campo)=="Z8_FILIAL" ;
			.OR. 	Alltrim(SX3->x3_campo)=="Z8_OK" ;
			.OR. 	Alltrim(SX3->x3_campo)=="Z8_PCPART" ;
			.OR. 	Alltrim(SX3->x3_campo)=="Z8_TAXADM" ;
			.OR. 	Alltrim(SX3->x3_campo)=="Z8_SEGPRES" ;
			.OR. 	Alltrim(SX3->x3_visual)=="V" 

			dbSelectArea("SX3")
			dbSkip()
			Loop
		Endif
		If (X3USO(SX3->x3_usado) .AND. ALLTRIM(UPPER(SX3->x3_browse)) == 'S')
			// para criar a estrutura temporaria
			AADD(aStru,	{SX3->x3_campo, SX3->x3_tipo, SX3->x3_tamanho, SX3->x3_decimal})
			
			// lista das colunas do MarkBrowse
			AADD(aFields,	{SX3->x3_campo, SX3->x3_tipo, SX3->x3_titulo, SX3->X3_picture, SX3->x3_tamanho, SX3->x3_decimal })
			
			// lista das campos para popular no MarkBrowse
			AADD( aCampos, "TRB->"+ALLTRIM(SX3->x3_campo) + " := " + "SZ8->"+ALLTRIM(SX3->x3_campo) )
		Endif

		dbSelectArea("SX3")
		dbSkip()
	Enddo

	//-----------------------------------------------------------------------
	// Campos necessários ao processo de baixa
	//-----------------------------------------------------------------------
	AADD(aStru,		{"Z8_PCPART", "N", TAMSX3("Z8_PCPART")[1], TAMSX3("Z8_PCPART")[2]})
	AADD(aFields,	{"Z8_PCPART", "N", "Perc. Partic", PESQPICT("SZ8","Z8_PCPART"), TAMSX3("Z8_PCPART")[1], TAMSX3("Z8_PCPART")[2] })

	AADD(aStru,		{"Z8_TAXADM", "N", TAMSX3("Z8_TAXADM")[1], TAMSX3("Z8_TAXADM")[2]})
	AADD(aFields,	{"Z8_TAXADM", "N", "Vl. taxa adm", PESQPICT("SZ8","Z8_TAXADM"), TAMSX3("Z8_TAXADM")[1], TAMSX3("Z8_TAXADM")[2] })

	AADD(aStru,		{"Z8_SEGPRES", "N", TAMSX3("Z8_SEGPRES")[1], TAMSX3("Z8_SEGPRES")[2]})
	AADD(aFields,	{"Z8_SEGPRES", "N", "Vl.seg.prest", PESQPICT("SZ8","Z8_SEGPRES"), TAMSX3("Z8_SEGPRES")[1], TAMSX3("Z8_SEGPRES")[2] })

	AADD(aFields,	{"RETEXEC", "C", "Erros"})

	//-----------------------------------------------------------------------
	// Cria a tabela temporária
	//-----------------------------------------------------------------------
	IF SELECT("TRB") > 0
		DBSELECTAREA("TRB")
		DBCLOSEAREA()
	ENDIF
	cArq	:=	"T_"+Criatrab(,.F.)
	MsCreate(cArq,aStru,"DBFCDX") // atribui a tabela temporária ao alias TRB
	dbUseArea(.T.,"DBFCDX",cArq,"TRB",.T.,.F.)// alimenta a tabela temporária

	//-----------------------------------------------------------------------
	// Popula a tabela temporária
	//-----------------------------------------------------------------------
	DbSelectArea("TRBSZ8")
	DbGoTop()
	DO WHILE !EOF()
		nREGSZ8 := TRBSZ8->REGSZ8
	
		DbSelectArea("SZ8")
		DbGoTo( nREGSZ8 )

		DBSELECTAREA("TRB")
		RECLOCK("TRB",.T.)
		FOR nX := 1 TO LEN( aCampos )
			bCampo := aCampos[nX]
			&bCampo
		NEXT
		IF SZ8->Z8_VALOK == "S"
			TRB->Z8_OK 	:= cMark
		ENDIF	
		TRB->Z8_PCPART	:= SZ8->Z8_PCPART 
		TRB->Z8_TAXADM 	:= SZ8->Z8_TAXADM 
		TRB->Z8_SEGPRES	:= SZ8->Z8_SEGPRES 
		TRB->SZ8REG 	:= nREGSZ8

		MSUNLOCK()
		
		DbSelectArea("TRBSZ8")
		DbSkip()
	ENDDO
	TRBSZ8->( DbCloseArea() )

RETURN 

//-----------------------------------------------------------------------
/*/{Protheus.doc} MarcaTud

Marca ou desmarca todos os itens do Markbrowse

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		06/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaTud()

	DbSelectArea("TRB")
	DbGoTop()
	DO WHILE !EOF()
		MarcaIte()
	
		TRB->( DbSkip() )
	ENDDO

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} MarcaIte

Marca ou desmarca o item do Markbrowse

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		06/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaIte()

	IF IsMark("Z8_OK",cMark )
		RecLock("TRB",.F.)
		TRB->Z8_OK := ""
		TRB->( MsUnLock() ) 
	ELSE
		RecLock("TRB",.F.)
		TRB->Z8_OK := IIF( TRB->Z8_VALOK == "S" .AND. EMPTY(TRB->Z8_DTPROC) , cMark, "")
 		TRB->( MsUnLock() )
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFIA13B

Baixa os títulos marcados

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		29/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFIA13B()
	LOCAL lErroExec		:= .F.
	LOCAL aPar			:= {}
	LOCAL aRet			:= {}
	LOCAL lRet			:= .F.
	LOCAL nCntBaixa		:= 0
	
	//-----------------------------------------------------------------------
	// Definição dos Parametros da Rotina
	//-----------------------------------------------------------------------
	// 6 - File
	//  [2] : Descrição
	//  [3] : String contendo o inicializador do campo
	//  [4] : String contendo a Picture do campo
	//  [5] : String contendo a validação
	//  [6] : String contendo a validação When
	//  [7] : Tamanho do MsGet
	//  [8] : Flag .T./.F. Parâmetro Obrigatório ?
	//  [9] : Texto contendo os tipos de arquivo Ex.: "Arquivos .CSV |*.CSV"
	//  [10]: Diretório inicial do cGetFile
	//  [11]: PARAMETROS do cGETFILE

	aAdd(aPar,{6	,"Arquivo de log"		,SPACE(200)	, "", , ,080,.T.,"Arquivos .LOG |*.LOG"})
		
	//Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet

	lRet 	:= ParamBox(aPar,"",@aRet,,,,,,,"ASFINA13C",.T.,.T.)
	IF !lRet
		RETURN
	ENDIF
	IF !Len(aRet) == Len(aPar)
		MsgAlert("É necessário indicar o arquivo de log de erros!", "Atenção")
		RETURN
	ENDIF
	
	cErrLog := aRet[1]
	IF EMPTY(cErrLog)
		MsgAlert("É necessário indicar o arquivo de log de erros!", "Atenção")
		RETURN
	ENDIF
		
	Processa({|| lErroExec := BaixaSE1( @nCntBaixa )},"Baixando")

	IF lErroExec
		MSGALERT("O processo foi concluído com erros. Foi(ram) baixado(s) " + ALLTRIM(STR(nCntBaixa)) + " título(s) com sucesso." + cCRLF + "Visualize o log para detalhe(s) do erro dos título(s) não baixado(s)", "Atenção")
	ELSE
		MSGALERT("Processo concluído sem erros. Foi(ram) baixado(s) " + ALLTRIM(STR(nCntBaixa)) + " título(s) com sucesso.", "Ok")
	ENDIF
	
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} BaixaSE1

Processa a baixa dos títulos marcados

@param		nCntBaixa = Quantidade de registros baixados
@return		Nenhum
@author 	Fabio Cazarini
@since 		29/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION BaixaSE1( nCntBaixa )
	LOCAL cRetExec		:= ""
	LOCAL aDadosSE1		:= {}
	LOCAL lErroExec		:= .F.
	LOCAL lEmptyStr		:= .T.
	LOCAL cBCOPAR		:= ""
	LOCAL aBCOPAR		:= {}
	LOCAL cAUTBANCO		:= ""
	LOCAL cAUTAGENCI	:= ""
	LOCAL cAUTCONTA		:= ""
	LOCAL cAUTMOTBX		:= ""
	LOCAL cMOTPAR		:= SUPERGETMV("AS_MOTPAR", .T., "") // Motivo da baixa
	LOCAL cMOTSEC		:= SUPERGETMV("AS_MOTSEC", .T., "") // Motivo da baixa para securitizados
	LOCAL cSITSE1		:= SUPERGETMV("AS_SITSE1", .T., "") // Situação dos títulos securitizados
	LOCAL cSITSE9		:= SUPERGETMV("AS_SITSE9", .T., "") // Situação dos títulos securitizados vencidos
	LOCAL cSITUACA		:= ""
	LOCAL nRegSE1		:= 0
	LOCAL nTamFil		:= LEN(SE1->E1_FILIAL) 
	LOCAL nTamPre		:= LEN(SE1->E1_PREFIXO)
	LOCAL nTamNum		:= LEN(SE1->E1_NUM) 
	LOCAL nTamPar		:= LEN(SE1->E1_PARCELA) 
	LOCAL nTamTpP		:= LEN(SE1->E1_TIPO) 
	LOCAL cFilTit		:= ""
	LOCAL cPrefixo		:= ""
	LOCAL cNum			:= ""
	LOCAL cParcel		:= ""
	LOCAL cTpParcel		:= ""
	LOCAL cTpAB			:= ""
	LOCAL nCntProc 		:= 0
	LOCAL nValParcei	:= 0
	LOCAL nValAguaSa	:= 0
	LOCAL cMOTDAC		:= ""

	TRB->(dbEval({|| nCntProc++ },,{|| !Eof() .AND. TRB->Z8_OK == cMark .AND. EMPTY(TRB->Z8_DTPROC) .AND. !TRB->ERREXEC}))

	ProcRegua( nCntProc )

	DbSelectArea("TRB")
	DbGoTop()
	DO WHILE !TRB->( EOF() )
		IF TRB->Z8_OK == cMark .AND. EMPTY(TRB->Z8_DTPROC) .AND. !TRB->ERREXEC
			
			IncProc( "Aguarde..." )
			DbSelectArea("SE1")
			DbSetOrder(1) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			IF MsSEEK( ALLTRIM(TRB->Z8_CHVPROT) )
				nRegSE1 	:= SE1->( RecNo() )

				cFilTit		:= SUBSTR( TRB->Z8_CHVPROT, 1									, nTamFil )
				cPrefixo	:= SUBSTR( TRB->Z8_CHVPROT, 1+nTamFil							, nTamPre )
				cNum		:= SUBSTR( TRB->Z8_CHVPROT, 1+nTamFil+nTamPre					, nTamNum )
				cParcel		:= SUBSTR( TRB->Z8_CHVPROT, 1+nTamFil+nTamPre+nTamNum			, nTamPar )
				cTpParcel	:= SUBSTR( TRB->Z8_CHVPROT, 1+nTamFil+nTamPre+nTamNum+nTamPar	, nTamTpP )
				cTpAB		:= PADR( "AB-", nTamTpP )

				//-----------------------------------------------------------------------
				// Participação do parceiro e participação da Aguassanta
				//-----------------------------------------------------------------------
				nValParcei	:= NOROUND( (TRB->Z8_VLPAGO-TRB->Z8_TAXADM-TRB->Z8_SEGPRES) * TRB->Z8_PCPART / 100, TAMSX3("E1_VALOR")[2]) + TRB->Z8_TAXADM + TRB->Z8_SEGPRES
				nValAguaSa 	:= TRB->Z8_VLPAGO - nValParcei

				//-----------------------------------------------------------------------
				// Participação prevista parceiro - Exclui o título de abatimento AB-
				//-----------------------------------------------------------------------
				cRetExec 	:= ""
			
				DbSelectArea("SE1")
				DbSetOrder(1) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
				IF DbSEEK( cFilTit + cPrefixo + cNum + cParcel + cTpAB )
					aDadosSE1 	:= {}

					aadd(aDadosSE1, {"E1_FILIAL"	, SE1->E1_FILIAL	, NIL })
					aadd(aDadosSE1, {"E1_PREFIXO"	, SE1->E1_PREFIXO	, NIL })
					aadd(aDadosSE1, {"E1_NUM"		, SE1->E1_NUM		, NIL })
					aadd(aDadosSE1, {"E1_PARCELA"	, SE1->E1_PARCELA	, NIL })
					aadd(aDadosSE1, {"E1_TIPO"		, SE1->E1_TIPO		, NIL })
					aadd(aDadosSE1, {"E1_CLIENTE"	, SE1->E1_CLIENTE	, NIL })
					aadd(aDadosSE1, {"E1_LOJA"		, SE1->E1_LOJA		, NIL })
					aadd(aDadosSE1, {"E1_EMISSAO"	, SE1->E1_EMISSAO	, NIL })
					aadd(aDadosSE1, {"E1_VENCTO"	, SE1->E1_VENCTO	, NIL })
					aadd(aDadosSE1, {"E1_VENCREA"	, SE1->E1_VENCREA	, NIL })
					aadd(aDadosSE1, {"E1_VALOR"		, SE1->E1_VALOR		, NIL })

					//-----------------------------------------------------------------------
					// Exclui o título de abatimento AB- via ExecAuto
					//-----------------------------------------------------------------------
					cRetExec := ExcluiAB(aDadosSE1, cEMPANT, SE1->E1_MSFIL)
				ENDIF
				
				IF EMPTY(cRetExec) // se não ocorreu erro na exclusão do AB-				
					//-----------------------------------------------------------------------
					// Participação da Aguassanta:
					// Baixa o saldo
					//-----------------------------------------------------------------------
					DbSelectArea("SE1")
					SE1->( DbGoTo(nRegSE1) )
	
					//-----------------------------------------------------------------------
					// Define o motivo da baixa, dependendo da situação
					//-----------------------------------------------------------------------
					cSITUACA := SE1->E1_SITUACA
					IF cSITUACA $ cSITSE1 .OR. cSITUACA $ cSITSE9 // se titulo securitizado
						cAUTMOTBX := cMOTSEC
					ELSE
						cAUTMOTBX := cMOTPAR				
					ENDIF 
	
					//-----------------------------------------------------------------------
					// Define o banco, agência e conta
					//-----------------------------------------------------------------------
					cAUTBANCO 	:= ""
					cAUTAGENCI	:= ""
					cAUTCONTA	:= ""
					cAUTMOTBX := PADR(cAUTMOTBX, TAMSX3("E5_MOTBX")[1] )
					IF MovBcobx(cAUTMOTBX, .T.) // Responde com T ou F se uma baixa movimenta um banco
						//-----------------------------------------------------------------------
						// Parâmetro exclusivo p/filial p/identificar o banco, agencia e conta
						//-----------------------------------------------------------------------
						cBCOPAR := GETNEWPAR( "AS_BCOPAR", "001|0001|0000001", SE1->E1_MSFIL )
						aBCOPAR	:= StrTokArr2(cBCOPAR, "|", lEmptyStr)
						IF LEN(aBCOPAR) == 3
							cAUTBANCO 	:= aBCOPAR[1]
							cAUTAGENCI	:= aBCOPAR[2]
							cAUTCONTA	:= aBCOPAR[3]
						ENDIF	
					ENDIF
					cAUTBANCO 	:= PADR( cAUTBANCO, TAMSX3("E5_BANCO")[1] )
					cAUTAGENCI	:= PADR( cAUTAGENCI, TAMSX3("E5_AGENCIA")[1] )
					cAUTCONTA	:= PADR( cAUTCONTA, TAMSX3("E5_CONTA")[1] )
					
					//-----------------------------------------------------------------------
					// Array para o ExecAuto
					//-----------------------------------------------------------------------
					aDadosSE1 := {}
					aadd(aDadosSE1, {"E1_FILIAL"	, SE1->E1_FILIAL				, NIL } )
					aadd(aDadosSE1, {"E1_PREFIXO"	, SE1->E1_PREFIXO				, NIL } )
					aadd(aDadosSE1, {"E1_NUM"		, SE1->E1_NUM					, NIL } )
					aadd(aDadosSE1, {"E1_PARCELA"	, SE1->E1_PARCELA				, NIL } )
					aadd(aDadosSE1, {"E1_TIPO"		, SE1->E1_TIPO					, NIL } )
					aadd(aDadosSE1, {"E1_CLIENTE"	, SE1->E1_CLIENTE				, NIL } )
					aadd(aDadosSE1, {"E1_LOJA"		, SE1->E1_LOJA					, NIL } )
					aadd(aDadosSE1, {"E1_NATUREZ"	, SE1->E1_NATUREZ				, NIL } )
					aadd(aDadosSE1, {"AUTMOTBX"		, cAUTMOTBX						, NIL } )
					aadd(aDadosSE1, {"AUTBANCO"		, cAUTBANCO						, NIL } )
					aadd(aDadosSE1, {"AUTAGENCIA"	, cAUTAGENCI					, NIL } )
					aadd(aDadosSE1, {"AUTCONTA"		, cAUTCONTA						, NIL } )
					aadd(aDadosSE1, {"AUTDTBAIXA"	, TRB->Z8_DTBAIXA				, NIL } )
					aadd(aDadosSE1, {"AUTDTCREDITO"	, DataValida(TRB->Z8_DTBAIXA)	, NIL } )
					aadd(aDadosSE1, {"AUTHIST"		, ""							, NIL } )
					aadd(aDadosSE1, {"AUTVALREC"	, nValAguaSa					, NIL } )

					//aadd(aDadosSE1, {"AUTDESCONT"	, TRB->Z8_VLATDES				, NIL, .T. } )
					//aadd(aDadosSE1, {"AUTJUROS"	, 0								, NIL,.T.} )
					//aadd(aDadosSE1, {"AUTMULTA"	, 0								, NIL,.T.} )
		
					//-----------------------------------------------------------------------
					// Baixa o título a receber via ExecAuto
					//-----------------------------------------------------------------------
					cRetExec := ExecBaixa(aDadosSE1, cEMPANT, SE1->E1_MSFIL)
				ENDIF

				IF EMPTY(cRetExec) // se não ocorreu erro na baixa da parte Aguassanta
					//-----------------------------------------------------------------------
					// Participação do parceiro:
					// Baixa por DAÇÃO o valor do título de abatimento AB- excluído 
					// anteriormente
					//-----------------------------------------------------------------------
					IF nValParcei > 0
						DbSelectArea("SE1")
						SE1->( DbGoTo(nRegSE1) )
		
						cMOTDAC := GETNEWPAR( "AS_MOTDAC", "PAR", SE1->E1_MSFIL )
		
						//-----------------------------------------------------------------------
						// Define o banco, agência e conta
						//-----------------------------------------------------------------------
						cAUTMOTBX 	:= PADR(cMOTDAC	, TAMSX3("E5_MOTBX")[1] )
						cAUTBANCO 	:= PADR( ""		, TAMSX3("E5_BANCO")[1] )
						cAUTAGENCI	:= PADR( ""		, TAMSX3("E5_AGENCIA")[1] )
						cAUTCONTA	:= PADR( ""		, TAMSX3("E5_CONTA")[1] )
						
						//-----------------------------------------------------------------------
						// Array para o ExecAuto
						//-----------------------------------------------------------------------
						aDadosSE1 := {}
						aadd(aDadosSE1, {"E1_FILIAL"	, SE1->E1_FILIAL				, NIL } )
						aadd(aDadosSE1, {"E1_PREFIXO"	, SE1->E1_PREFIXO				, NIL } )
						aadd(aDadosSE1, {"E1_NUM"		, SE1->E1_NUM					, NIL } )
						aadd(aDadosSE1, {"E1_PARCELA"	, SE1->E1_PARCELA				, NIL } )
						aadd(aDadosSE1, {"E1_TIPO"		, SE1->E1_TIPO					, NIL } )
						aadd(aDadosSE1, {"E1_CLIENTE"	, SE1->E1_CLIENTE				, NIL } )
						aadd(aDadosSE1, {"E1_LOJA"		, SE1->E1_LOJA					, NIL } )
						aadd(aDadosSE1, {"E1_NATUREZ"	, SE1->E1_NATUREZ				, NIL } )
						aadd(aDadosSE1, {"AUTMOTBX"		, cAUTMOTBX						, NIL } )
						aadd(aDadosSE1, {"AUTBANCO"		, cAUTBANCO						, NIL } )
						aadd(aDadosSE1, {"AUTAGENCIA"	, cAUTAGENCI					, NIL } )
						aadd(aDadosSE1, {"AUTCONTA"		, cAUTCONTA						, NIL } )
						aadd(aDadosSE1, {"AUTDTBAIXA"	, TRB->Z8_DTBAIXA				, NIL } )
						aadd(aDadosSE1, {"AUTDTCREDITO"	, DataValida(TRB->Z8_DTBAIXA)	, NIL } )
						aadd(aDadosSE1, {"AUTHIST"		, ""							, NIL } )
						aadd(aDadosSE1, {"AUTVALREC"	, nValParcei					, NIL } )
		
						//-----------------------------------------------------------------------
						// Baixa o título a receber via ExecAuto
						//-----------------------------------------------------------------------
						cRetExec := ExecBaixa(aDadosSE1, cEMPANT, SE1->E1_MSFIL)
					ENDIF
				ENDIF
				
				IF !EMPTY(cRetExec) 
					//-----------------------------------------------------------------------
					// ocorreu erro no ExecAuto
					//-----------------------------------------------------------------------
					lErroExec := .T.
					
					DbSelectArea("TRB")
					RecLock("TRB", .F. )
					TRB->RETEXEC	:= cRetExec
					TRB->ERREXEC 	:= .T.
					TRB->( MsUnLock() )
				ELSE				
					//-----------------------------------------------------------------------
					// baixou o título
					//-----------------------------------------------------------------------
					DbSelectArea("SZ8")
					DbGoTo( TRB->SZ8REG )
					RecLock("SZ8", .F. )
					SZ8->Z8_DTPROC := dDATABASE
					SZ8->( MsUnLock() )
					
					DbSelectArea("TRB")
					RecLock("TRB", .F. )
					TRB->Z8_DTPROC 	:= dDATABASE
					TRB->ERREXEC 	:= .F.
					TRB->( MsUnLock() )
					
					nCntBaixa++
				ENDIF
			ENDIF
		ENDIF
		
		DbSelectArea("TRB")
		TRB->( DbSkip() )
	ENDDO
	TRB->( DbGoTop() )

RETURN lErroExec


//-----------------------------------------------------------------------
/*/{Protheus.doc} ExecBaixa

Baixa o título a pagar via ExecAuto

@param		aDadosSE1 = Array do Execauto
			cEMPANT = Grupo de empresa da baixa
			cFILANT = Filial da baixa
@return		cRet = Se ocorreu erro, retorna o erro. Senão retorna vazio
@author 	Fabio Cazarini
@since 		07/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ExecBaixa(aDadosSE1, cEMPPAR, cFILPAR)
	LOCAL cRet		:= ""
	LOCAL aErros	:= {}   
	LOCAL cLinErr	:= {}
	LOCAL nY 		:= 0
	LOCAL nOPC		:= 3
	LOCAL cEMPAUX	:= cEMPANT
	LOCAL cFILAUX	:= cFILANT
	LOCAL nSaldoAnt	:= SE1->E1_SALDO
	LOCAL nSaldoAtu	:= 0
	
	PRIVATE lMsErroAuto 	:= .F.	// variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
	PRIVATE lMsHelpAuto		:= .T.	// força a gravação das informações de erro em array para manipulação da gravação ao invés de gravar direto no arquivo temporário
	PRIVATE lAutoErrNoFile	:= .T.

	//-----------------------------------------------------------------------
	// Indica o grupo de empresas e filial da baixa
	//-----------------------------------------------------------------------
	cEMPANT := cEMPPAR
	cFILANT	:= cFILPAR

	//-----------------------------------------------------------------------
	// Baixa título (nOpc = 3)
	//-----------------------------------------------------------------------
	nOPC := 3

	IF EMPTY(cRet)
		//-----------------------------------------------------------------------
		// Ordenar um vetor conforme o dic. para uso em rotinas de MSExecAuto
		//-----------------------------------------------------------------------
		aDadosSE1	:= FWVetByDic( aDadosSE1, 'SE1' )

		DbSelectArea("SE1")
		lMsErroAuto := .F.
		BeginTran()
		MSExecAuto({|x,y| Fina070(x,y)}, aDadosSE1, nOPC)//  3=Baixa de Título; 5=Cancelamento de baixa; 6=Exclusão de Baixa
		
		nSaldoAtu := SE1->E1_SALDO
		If lMsErroAuto .OR. (nSaldoAnt == nSaldoAtu)
			DisarmTransaction()
			 
			//-----------------------------------------------------------------------
			// Atribui a cRet o MOSTRAERRO()
			//-----------------------------------------------------------------------
			cRet 	:= "Erro na execução da baixa do título: " + cCRLF

			IF !lMsErroAuto
				cRet 	+= "Inconsistência na baixa do título " + SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + cCRLF
				cRet 	+= "Não foi possível efetuar a baixa. Verifique o log do EAI" + cCRLF
			ELSE
				aErros	:= GetAutoGRLog()   
				FOR nY := 1 TO LEN(aErros)
					cLinErr	:= aErros[nY]
					cRet 	+= cLinErr + cCRLF
				NEXT
			ENDIF
			
			LogExeErro(cRet)                                
		Else
			EndTran()
			
			cRet := ""
		EndIf
		
		MsUnlockAll()
	ENDIF

	//-----------------------------------------------------------------------
	// Restaura o grupo de empresas e filial
	//-----------------------------------------------------------------------
	cEMPANT := cEMPAUX
	cFILANT	:= cFILAUX

RETURN cRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} ExcluiAB

Exclui o título AB-

@param		aDadosSE1 = Array do Execauto
			cEMPANT = Grupo de empresa da baixa
			cFILANT = Filial da baixa
@return		cRet = Se ocorreu erro, retorna o erro. Senão retorna vazio
@author 	Fabio Cazarini
@since 		04/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ExcluiAB(aDadosSE1, cEMPPAR, cFILPAR)
	LOCAL cRet		:= ""
	LOCAL aErros	:= {}   
	LOCAL cLinErr	:= {}
	LOCAL nY 		:= 0
	LOCAL nOPC		:= 5
	LOCAL cEMPAUX	:= cEMPANT
	LOCAL cFILAUX	:= cFILANT
	
	PRIVATE lMsErroAuto 	:= .F.	// variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
	PRIVATE lMsHelpAuto		:= .T.	// força a gravação das informações de erro em array para manipulação da gravação ao invés de gravar direto no arquivo temporário
	PRIVATE lAutoErrNoFile	:= .T.

	//-----------------------------------------------------------------------
	// Indica o grupo de empresas e filial da baixa
	//-----------------------------------------------------------------------
	cEMPANT := cEMPPAR
	cFILANT	:= cFILPAR

	//-----------------------------------------------------------------------
	// Exclui título (nOpc = 5)
	//-----------------------------------------------------------------------
	nOPC := 5

	IF EMPTY(cRet)
		//-----------------------------------------------------------------------
		// Ordenar um vetor conforme o dic. para uso em rotinas de MSExecAuto
		//-----------------------------------------------------------------------
		aDadosSE1	:= FWVetByDic( aDadosSE1, 'SE1' )

		DbSelectArea("SE1")
		lMsErroAuto := .F.
		BeginTran()
		MsExecAuto({|x,y| FINA040(x,y)}, aDadosSE1, nOPC)

		If lMsErroAuto
			DisarmTransaction()
			 
			//-----------------------------------------------------------------------
			// Atribui a cRet o MOSTRAERRO()
			//-----------------------------------------------------------------------
			cRet 	:= "Erro na execução da exclusão do título AB-: " + cCRLF
			
			aErros	:= GetAutoGRLog()   
			FOR nY := 1 TO LEN(aErros)
				cLinErr	:= aErros[nY]
				cRet 	+= cLinErr + cCRLF
			NEXT
			
			LogExeErro(cRet)                                
		Else
			EndTran()
			
			cRet := ""
		EndIf
		
		MsUnlockAll()
	ENDIF

	//-----------------------------------------------------------------------
	// Restaura o grupo de empresas e filial
	//-----------------------------------------------------------------------
	cEMPANT := cEMPAUX
	cFILANT	:= cFILAUX

RETURN cRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} LogExeErro()

Loga erro do ExecAuto

@param		cDesErro = Descrição do erro
@return		Nenhum
@author 	Fabio Cazarini
@since 		07/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION LogExeErro(cDesErro)
	LOCAL nHandle 	:= 0

	IF EMPTY(cErrLog)
		RETURN
	ENDIF
	
	IF EMPTY(cArqErrLog)
		cArqErrLog := cErrLog
		nHandle := FCREATE(cArqErrLog)
		IF nHandle > 0
			FWRITE(nHandle, "================================================================================" + cCRLF)
		ENDIF
	ELSE
		nHandle := FOPEN(cArqErrLog , FO_READWRITE + FO_SHARED )                                       
	ENDIF
	
	IF nHandle > 0
		FSEEK(nHandle, 0, FS_END)
		FWRITE(nHandle, cDesErro + cCRLF)
		FWRITE(nHandle, "--------------------------------------------------------------------------------" + cCRLF)
		
		FCLOSE(nHandle)
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFIA13C

Visualiza o log de erros do ExecAuto

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		07/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFIA13C()
	LOCAL nRetOpen	:= 0
	
	IF !EMPTY(cArqErrLog)
		IF FILE(cArqErrLog)
			nRetOpen := ShellExecute("OPEN", SUBSTR( cArqErrLog, RAT("\", cArqErrLog)+1, LEN(cArqErrLog) ), "", LEFT( cArqErrLog, RAT("\", cArqErrLog) ), 1)
			IF nRetOpen <= 32
				MsgAlert("Não foi possível abrir o arquivo " + cArqErrLog + "!", "Atenção")
			ENDIF 
		ELSE
			MsgAlert("Arquivo com o log de erros " + cArqErrLog + " não encontrado!", "Atenção")			
		ENDIF
	ELSE
		MsgAlert("Não foi gerado log de erros!", "Atenção")
	ENDIF

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} RetValAtu

Retorna o saldo atual do título a receber, com decréscimo, acréscimo, 
multa, taxa de permanência

@param		cFILIALTIT = Filial do título
			cPREFIXO = prefixo
			cNUM = número do título
			cPARCELA = parcela
			cTIPO = tipo do título
			dDtCredito = data da baixa
			nDescont = Desconto do título, enviado como referência - 
						Participação do parceiro
@return		Saldo atual do título
@author 	Fabio Cazarini
@since 		07/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION RetValAtu(cFILIALTIT, cPREFIXO, cNUM, cPARCELA, cTIPO, dDtCredito, nDescont)
LOCAL nRET 			:= 0
LOCAL nSaldo		:= 0
LOCAL cMvJurTipo	:= SuperGetMv("MV_JURTIPO",,"")  // calculo de Multa do Loja , se JURTIPO == L
LOCAL lMulLoj		:= SuperGetMv("MV_LJINTFS", ,.F.) //Calcula multa conforme regra do loja, se integração com financial estiver habilitada
LOCAL lLojxRMul		:= .T.

//-----------------------------------------------------------------------
// Define variáveis
//-----------------------------------------------------------------------
PRIVATE nValRec 	:= 0
PRIVATE nValTot 	:= 0
PRIVATE nTotAGer	:= 0
PRIVATE nTotADesp	:= 0
PRIVATE nTotADesc	:= 0
PRIVATE nTotAMul	:= 0
PRIVATE nTotAJur	:= 0
PRIVATE nValPadrao	:= 0
PRIVATE nValEstrang	:= 0
PRIVATE cLote
PRIVATE cLoteFin	:= If(Type("cLoteFin") != "C", Space(TamSX3("E1_LOTE")[1]), cLoteFin)
PRIVATE cNaturLote	:= Space (10)
PRIVATE nAcresc		:= 0
PRIVATE nDecresc	:= 0
PRIVATE aCaixaFin	:= xCxFina() // Caixa Geral do Financeiro (MV_CXFIN)
Private cCodDiario	:= ""
PRIVATE nAcrescF	:= 0 
PRIVATE nDeCrescF	:= 0 
PRIVATE nTotAbat  	:= 0
PRIVATE nTotAbImp 	:= 0
PRIVATE nTotAbLiq 	:= 0
PRIVATE dBaixa		:= dDtCredito
PRIVATE nDecrVlr	:= 0		//tratar visualizacao da varivel na tela de valores  
PRIVATE aBxAcr		:= {} 
PRIVATE aBxDec		:= {} 
PRIVATE nMoedaBco	:= 1   
PRIVATE nTxMoeda
PRIVATE nJuros 		:= 0
PRIVATE nMulta 		:= 0
PRIVATE nCM1     	:= 0
PRIVATE nProRata 	:= 0
PRIVATE nVlRetPis	:= 0
PRIVATE nVlRetCof	:= 0
PRIVATE nVlRetCsl	:= 0
PRIVATE aDadosRet 	:= Array(7)
PRIVATE nIrrf 		:= 0 
PRIVATE nPIS		:= 0
PRIVATE nCOFINS		:= 0
PRIVATE nCSLL		:= 0
PRIVATE nCM

DbSelectArea("SE1")
DbSetOrder(1) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
IF MsSEEK( cFILIALTIT + cPREFIXO + cNUM + cPARCELA + cTIPO )
	nSaldo := SE1->E1_SALDO
		
	//-----------------------------------------------------------------------
	// Verifica se o tipo de calculo de juros é igual (L)loja ou Indicacao do 
	// calculo de Multa do Loja, calcula a multa
	//-----------------------------------------------------------------------
	If cMvJurTipo == "L" .OR. lMulLoj
		//-----------------------------------------------------------------------
		// Calcula o valor da Multa  :funcao LojxRMul :fonte Lojxrec
		//-----------------------------------------------------------------------
		If lLojxRMul
		  nMulta := LojxRMul( , , ,SE1->E1_SALDO, SE1->E1_ACRESC, SE1->E1_VENCREA, dDtCredito , , SE1->E1_MULTA, ,;
		  					 SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_CLIENTE, SE1->E1_LOJA, "SE1" )   
		Else
		  nMulta := 0
		Endif
	Endif

	nTxMoeda 	:= If(SE1->E1_MOEDA > 1, If(SE1->E1_TXMOEDA > 0, SE1->E1_TXMOEDA,RecMoeda(dBaixa,SE1->E1_MOEDA)),0)

	nAcrescF    := SE1->E1_SDACRES 
	nDeCrescF	:= SE1->E1_SDDECRE  + nDecrVlr 

	//-----------------------------------------------------------------------
	// Calcula acréscimos e descréscimos
	//-----------------------------------------------------------------------	
	nAcresc     := Round(NoRound(xMoeda(nAcrescF,SE1->E1_MOEDA,nMoedaBco,dBaixa,3,nTxMoeda),3),2)
	nDecresc    := Round(NoRound(xMoeda(nDeCrescF,SE1->E1_MOEDA,nMoedaBco,dBaixa,3,nTxMoeda),3),2)

	//-----------------------------------------------------------------------
	// Calcula abatimentos
	// Não será mais considerado o abatimento na validação do valor pago com  
	// o valor total do título. 
	// O abatimento (AB-) é a participação do parceiro. Essa participação será 
	// baixada como DAÇÃO para não gerar movimento financeiro.
	// O título AB- gerado na inclusão do título pelo PE F055IT, será 
	// excluído.
	//-----------------------------------------------------------------------	
	//nTotAbat  	:= SumAbatRec(cPrefixo,cNum,cParcela,SE1->E1_MOEDA,"S",dBaixa,@nTotAbImp,,,,,,, nTxMoeda) 
	//nTotAbLiq 	:= nTotAbat - nTotAbImp

	//-----------------------------------------------------------------------
	// Calcula o desconto financeiro
	//-----------------------------------------------------------------------	
	nDescont 	:= FaDescFin("SE1",dBaixa,SE1->E1_SALDO-nTotAbat,nMoedaBco)

	//-----------------------------------------------------------------------
	// Calcula juros
	//-----------------------------------------------------------------------	
	nJuros 		:= 0
	nCM1     	:= 0
	nProRata 	:= 0

	fa070Juros(nMoedaBco)

	If nCM1 > 0
		nJuros -= nCM1
	Else
		nDescont += nCM1
	EndIf

	If nProRata > 0
		nJuros -= nProRata
	Else
		nDescont += nProRata
	EndIf

	//-----------------------------------------------------------------------
	// Executado antes da baixa, para customizar valores
	//-----------------------------------------------------------------------
	If ExistBlock("F070ACRE")
		ExecBlock("F070ACRE",.F.,.F.)
	EndIf

	//-----------------------------------------------------------------------
	// Retorna o valor atualizado do título (exceto o desconto, que será 
	// considerado somente na execução da baixa pois se trata da participação
	// do parceiro)
	//-----------------------------------------------------------------------	
	nRET := nSaldo + nAcresc - nDecresc - nTotAbLiq + nJuros + nMulta // - nDescont 
ENDIF

RETURN nRET