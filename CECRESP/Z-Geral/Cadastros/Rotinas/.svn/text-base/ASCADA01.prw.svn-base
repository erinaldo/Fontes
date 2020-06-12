#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FILEIO.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCADA01()

Importação de clientes via CSV (somente inclusão)

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		22/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCADA01()
	LOCAL aArea		:= GetArea()
	LOCAL nOpc     	:= 0
	LOCAL aSay   	:= {}
	LOCAL aButton 	:= {}    
	LOCAL cDesc1	:= OemToAnsi('O objetivo desta rotina é importar arquivo CSV de cadastro  ')
	LOCAL cDesc2	:= OemToAnsi('de clientes                                                 ')
	LOCAL cDesc3	:= OemToAnsi('')
	LOCAL cDesc4	:= OemToAnsi('Somente serão efetuadas inclusões                           ')
	LOCAL cDesc5	:= OemToAnsi('')
	LOCAL cDesc6	:= OemToAnsi('')
	LOCAL cDesc7  	:= OemToAnsi('')
	LOCAL aPar		:= {}
	LOCAL aRet		:= {}
	LOCAL cRetImp	:= ""
	LOCAL cMsgInfo	:= ""
	LOCAL nRetOpen	:= 0
	
	PRIVATE cCadastro 	:= OEMTOANSI("Importação de clientes via arquivo CSV")
	PRIVATE nProcess	:= 0
	PRIVATE nErroProc	:= 0
	PRIVATE cCRLF		:= CHR(13) + CHR(10)
	PRIVATE cArqCSV		:= ""
	PRIVATE cArqLog		:= ""
		
	// Mensagens de Tela Inicial
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	aAdd( aSay, cDesc4 )
	aAdd( aSay, cDesc5 )
	aAdd( aSay, cDesc6 )
	aAdd( aSay, cDesc7 )

	aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
	aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( cCadastro, aSay, aButton )

	If nOpc == 1	
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

		aAdd(aPar,{6	,"Arquivo de origem"	,SPACE(200)	, "", , ,080,.T.,"Arquivos .CSV |*.CSV"})

		//Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet

		lRet 	:= ParamBox(aPar,"",@aRet,,,,,,,"ASCADA01",.T.,.T.)
		IF lRet
			IF !Len(aRet) == Len(aPar)
				MsgAlert("É necessário indicar o arquivo CSV a importar!")
			ELSE
				//-----------------------------------------------------------------------
				// Processa
				//-----------------------------------------------------------------------
				cArqCSV	:= ALLTRIM( aRet[01] )
				cRetImp	:= ""
				Processa({|| cRetImp := Importa( cArqCSV )},"Processando")

				IF EMPTY(cRetImp)
					cMsgInfo := "Processo concluído. Foram incluídos " + ALLTRIM(STR(nProcess)) + " registros com sucesso" 
					IF nErroProc > 0 .AND. !EMPTY(cArqLog)
						cMsgInfo += cCRLF + "Foram registrados " + ALLTRIM(STR(nErroProc)) + " erros na inclusão"
						IF FILE( cArqLog )
							cMsgInfo += cCRLF + cCRLF + "Arquivo de log disponível em " + cArqLog + ". Deseja abrir este arquivo?"
							
							IF MsgYesNo(cMsgInfo,"Confirme")
							    nRetOpen := ShellExecute("OPEN", SUBSTR( cArqLog, RAT("\", cArqLog)+1, LEN(cArqLog) ), "", LEFT( cArqLog, RAT("\", cArqLog) ), 1)
							    IF nRetOpen <= 32
							        MsgAlert("Não foi possível abrir o arquivo " + cArqLog + "!", "Atenção")
							    ENDIF 
							ENDIF
						ELSE
							MsgInfo(cMsgInfo,"Ok")							
						ENDIF
					ELSE
						MsgInfo(cMsgInfo,"Ok")
					ENDIF
				ELSE
					MsgAlert(cRetImp,"Atenção")
				ENDIF	
			ENDIF
		ENDIF
	ENDIF

	RestArea( aArea )
	
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} Importa

Importação de clientes via CSV (somente inclusão)

@param		cArqCSV = Local e nome do arquivo CSV
@return		cRetImp = Mensagem de retorno preenchida quando tiver erro 
@author 	Fabio Cazarini
@since 		22/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION Importa( cArqCSV )
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
	LOCAL nPOSCNPJ		:= 0
	LOCAL aFields		:= {}
	LOCAL xFieldVal		
	LOCAL aDadosCli		:= {}
	LOCAL nOPC 			:= 3
	LOCAL aCNPJCPF		:= {}
	
	//-----------------------------------------------------------------------
	// Abre o arquivo origem CSV
	//-----------------------------------------------------------------------
	nHandle := FT_FUse(cArqCSV)
	IF nHandle < 0
		cRetImp := "Nao foi possivel abrir o arquivo " + cArqCSV
		RETURN cRetImp
	ENDIF

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
			aCabec	:= {}
			aCabec 	:= StrTokArr2(cCabec, ";", lEmptyStr)

			IF LEN(aCabec) == 0
				cRetImp	:= "Estrutura do arquivo inválida: O cabeçalho do arquivo não tem o nome dos campos"
				EXIT
			ENDIF

			FOR nX := 1 TO LEN(aCabec)
				cCampo	:= ALLTRIM(aCabec[nX])

				DbSelectArea("SX3")
				DbSetOrder(2) // X3_CAMPO
				IF MsSEEK( PADR(cCampo, LEN(SX3->X3_CAMPO) ) ) 
					AADD( aFields, {cCampo, SX3->X3_TIPO, SX3->X3_TAMANHO} )
				ELSE
					cRetImp	:= "Estrutura do arquivo inválida: Campo especificado no cabeçalho não é válido: " + cCampo
					EXIT
				ENDIF	

				IF cCampo == "A1_CGC"
					nPOSCNPJ := nX
				ENDIF	
			NEXT nX

			IF nPOSCNPJ == 0
				cRetImp	:= "Estrutura do arquivo inválida: Coluna com o CNPJ (A1_CGC) não encontrada"
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
			LogSA1Erro("Registro inválido - Colunas do registro diverge com o cabeçalho do arquivo CSV", nLinha)
			nErroProc++
		ENDIF

		//-----------------------------------------------------------------------
		// Importa a linha
		//-----------------------------------------------------------------------
		cCNPJ := PADR( aLinha[nPOSCNPJ], TAMSX3("A1_CGC")[1] )

		//-----------------------------------------------------------------------
		// Elimina duplicidade de CNPJ/CPF
		//-----------------------------------------------------------------------
		IF ASCAN( aCNPJCPF, cCNPJ ) == 0
			AADD( aCNPJCPF, cCNPJ )
	
			DbSelectArea("SA1")
			DbSetOrder(3) // A1_FILIAL+A1_CGC
			IF !MsSeek(xFILIAL("SA1") + cCNPJ) // somente inclui registros na SA1
				aDadosCli := {}
				FOR nY := 1 TO LEN(aFields)
					IF aFields[nY][02] == "N"
						xFieldVal := VAL( ALLTRIM(aLinha[nY]) )

					ELSEIF aFields[nY][02] == "D"
						IF "\" $ ALLTRIM(aLinha[nY])
							xFieldVal := CTOD( ALLTRIM(aLinha[nY]) )
						ELSE
							xFieldVal := STOD( ALLTRIM(aLinha[nY]) )						
						ENDIF
						
					ELSEIF aFields[nY][02] == "L"
						xFieldVal := IIF( ALLTRIM(aLinha[nY]) == '.T.', .T., .F.)				

					ELSEIF aFields[nY][02] == "C"
						xFieldVal := PADR(aLinha[nY], aFields[nY][03])

					ELSE // Memo
						xFieldVal := aLinha[nY]

					ENDIF										
	
					AADD( aDadosCli , {ALLTRIM(UPPER(aFields[nY][01])), xFieldVal, "NIL"} ) 
				NEXT nY
	
				//-----------------------------------------------------------------------
				// Inclui o cliente via ExecAuto
				//-----------------------------------------------------------------------
				nOPC 	:= 3
				cRetImp	:= SA1ExecA(aDadosCli, nOPC)
	
				IF !EMPTY(cRetImp) // se ocorreu algum erro
					LogSA1Erro("Inconsistência encontrada" + cCRLF + cRetImp , nLinha)
					cRetImp := ""
					nErroProc++
				ELSE
					nProcess++
				ENDIF
			ELSE
				LogSA1Erro("Inconsistência encontrada: " + IIF(LEN(ALLTRIM(cCNPJ)) > 11,"CNPJ ","CPF ") + ALLTRIM(cCNPJ) + " já cadastrado", nLinha)
				cRetImp := ""
				nErroProc++
			ENDIF	
		ENDIF
		
		FT_FSKIP()
	ENDDO
	FT_FUSE()

RETURN cRetImp


//-----------------------------------------------------------------------
/*/{Protheus.doc} SA1ExecA()

Execauto MATA030 - Clientes

@param		aDadosCli = Array do execauto MATA030
			nOPC = 3 = Inclusão
@return		cRet = Se não vazio, retorna o erro do execauto
@author 	Fabio Cazarini
@since 		22/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION SA1ExecA(aDadosCli, nOPC)
	LOCAL cRet			:= ""
	LOCAL aErros		:= {}   
	LOCAL cLinErr		:= {}
	LOCAL nY 			:= 0
	LOCAL cA1_COD		:= ""
	LOCAL cA1_LOJA		:= "01"
	LOCAL nPosCOD		:= 0
	LOCAL nPosLOJA		:= 0

	PRIVATE lMsErroAuto 	:= .F.	// variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
	PRIVATE lAutoErrNoFile	:= .T.

	IF nOPC == 3 // inclusao
		//-----------------------------------------------------------------------
		// Busca o ultimo codigo de cliente
		//-----------------------------------------------------------------------
		DO WHILE .T.
			cA1_COD := GetSXENum("SA1","A1_COD")
			ConfirmSX8()

			DbSelectArea("SA1")
			SA1->( dbSetOrder(1) )
			If !SA1->(dbSeek(xFilial('SA1') + cA1_COD + cA1_LOJA))	
				EXIT
			EndIF
		ENDDO

		nPosCOD	:= ASCAN(aDadosCli, { |x| x[1] == "A1_COD" })
		IF nPosCOD > 0
			aDadosCli[nPosCOD][02] := cA1_COD
		ELSE
			aAdd( aDadosCli, { "A1_COD" 	, cA1_COD	, NIL } )	
		ENDIF

		nPosLOJA := ASCAN(aDadosCli, { |x| x[1] == "A1_LOJA" })
		IF nPosLOJA > 0
			aDadosCli[nPosLOJA][02] := cA1_LOJA
		ELSE
			aAdd( aDadosCli, { "A1_LOJA" 	, cA1_LOJA 	, NIL } )	
		ENDIF
	ENDIF

	//-----------------------------------------------------------------------
	// Ordenar um vetor conforme o dicionário do MSExecAuto
	//-----------------------------------------------------------------------
	aDadosCli	:= FWVetByDic( aDadosCli, 'SA1' )

	DbSelectArea("SA1")
	lMsErroAuto := .F.
	BeginTran()
	MSExecAuto( { | x, y | MATA030( x, y ) } , aDadosCli, nOPC )

	If lMsErroAuto
		DisarmTransaction()

		//-----------------------------------------------------------------------
		// Atribui a cRet o MOSTRAERRO()
		//-----------------------------------------------------------------------
		cRet 	:= "Ocorreu um erro na inclusao do cliente: " + cCRLF

		aErros	:= GetAutoGRLog()   
		FOR nY := 1 TO LEN(aErros)
			cLinErr	:= aErros[nY]
			cRet 	+= cLinErr + cCRLF
		NEXT                                
	Else
		IF nOPC == 3 // inclusao
			DbSelectArea("SA1")
			DbSetOrder(1)
			IF !DbSEEK( xFILIAL("SA1") + cA1_COD + cA1_LOJA )
				cRet 	:= "Ocorreu um erro na inclusao do cliente: " + cCRLF
				cRet	+= cCRLF + cCRLF
				cRet	+= "Verifique o log de transacoes no EAI " + cCRLF + cCRLF

				DisarmTransaction()
			ELSE
				EndTran()
				cRet := ""
			ENDIF	
		ELSE
			EndTran()
			cRet := ""
		ENDIF
	EndIf

RETURN cRet


//-----------------------------------------------------------------------
/*/{Protheus.doc} LogSA1Erro()

Loga erro, gerando arquivo no mesmo local do arquivo origem

@param		cDesErro = Descrição do erro
			nLinha = Número da linha em que ocorreu o erro
@return		Nenhum
@author 	Fabio Cazarini
@since 		22/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION LogSA1Erro(cDesErro, nLinha)
	LOCAL nHandle 	:= 0
	LOCAL cSeq		:= "000"
	
	IF EMPTY(cArqLog)
		cArqLog := LEFT( cArqCSV, RAT("\", cArqCSV) ) + "CLIENTES_" + DTOS(dDATABASE)
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