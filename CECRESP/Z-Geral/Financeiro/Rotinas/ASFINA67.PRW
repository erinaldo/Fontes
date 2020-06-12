#include "rwmake.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FILEIO.CH'
#INCLUDE "RWMAKE.CH"
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA67()

Importacao de arquivos do GCAF (Movimentacao Bancaria)

@param		
@return		
@author 	Pedro Augusto
@since 		21/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA67()
	LOCAL aArea		:= GetArea()
	LOCAL nOpc     	:= 0
	LOCAL aSay   	:= {}
	LOCAL aButton 	:= {}    
	LOCAL cDesc1	:= OemToAnsi('O objetivo desta rotina é importar arquivos CSV de movimentação bancaria (GCAF)')
	LOCAL cDesc2	:= OemToAnsi('')
	LOCAL cDesc3	:= OemToAnsi('Abrir = Selecionar arquivo para importação')
	LOCAL cDesc4	:= OemToAnsi('')
	LOCAL cDesc5	:= OemToAnsi('')
	LOCAL aPar		:= {}
	LOCAL aRet		:= {}
	LOCAL cRetImp	:= ""
//	LOCAL cMsgInfo	:= ""
//	LOCAL cOpcTran	:= "1=Transferir não processados"
	LOCAL nRetOpen	:= 0
	
	PRIVATE cCadastro 	:= OEMTOANSI("Importação de movimentação bancária - GCAF")
//	PRIVATE nProcess	:= 0
	PRIVATE nLidos		:= 0
	PRIVATE nErroProc	:= 0
	PRIVATE cCRLF		:= CHR(13) + CHR(10)
	PRIVATE cArqCSV		:= ""
	PRIVATE cArqLog		:= ""
//	PRIVATE cArqErrLog	:= ""	
		
	// Mensagens de Tela Inicial
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	aAdd( aSay, cDesc4 )
	aAdd( aSay, cDesc5 )

	aAdd( aButton, { 14,.T.,{|| nOpc := 1,FechaBatch()}})
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

		lRet 	:= ParamBox(aPar,"",@aRet,,,,,,,"ASGCAF01",.T.,.T.)

		IF lRet
			IF !Len(aRet) == Len(aPar)
				MsgAlert("É necessário indicar os parâmetros da importação do arquivo CSV!", "Atenção")
			ELSE
				//-----------------------------------------------------------------------
				// Processa
				//-----------------------------------------------------------------------
				cArqCSV	:= ALLTRIM( aRet[01] )
				cRetImp	:= ""
				Processa({|| cRetImp := Importa( cArqCSV )},"Processando", "", .F.)

				IF EMPTY(cRetImp)
					IF !EMPTY(cArqLog)
						IF MsgYesNo( "Processo concluído. " + ALLTRIM(STR(nLidos)) + " registro(s) lidos. " + ALLTRIM(STR(nErroProc)) + " erro(s) encontrado(s). Arquivo não processado. Deseja abrir o log de erros?", "Confirme")
							nRetOpen := ShellExecute("OPEN", SUBSTR( cArqLog, RAT("\", cArqLog)+1, LEN(cArqLog) ), "", LEFT( cArqLog, RAT("\", cArqLog) ), 1)
							IF nRetOpen <= 32
								MsgAlert("Não foi possível abrir o arquivo " + cArqLog + "!", "Atenção")
							ENDIF 
						ENDIF
					ELSE
						MsgInfo("Processo concluído. " + ALLTRIM(STR(nLidos)) + " registro(s) processado(s).")
					ENDIF
				ELSE
					MsgAlert(cRetImp,"Atenção")
				ENDIF	
			ENDIF
		ENDIF
	ENDIF
	RestArea( aArea )
	
RETURN

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} Importa
Gerencia a execução do processo de importação.
/*/
//------------------------------------------------------------------------------------------
STATIC FUNCTION Importa( cArqCSV)
	LOCAL nHandle 	:= 0
	LOCAL cLinha		:= ""
	LOCAL nLinha		:= 0
	LOCAL cRetImp		:= ""
	LOCAL _lRet 		:= .T.
	LOCAL _i			:= 0
	LOCAL _k			:= 0
	
	Private _aCab		:= {}
	Private _aCSV		:= {}
//	Private _aErros		:= {}
	Private _aEfetiva   := {}

	//-----------------------------------------------------------------------
	// Abre o arquivo origem CSV
	//-----------------------------------------------------------------------
	nHandle := FT_FUse(cArqCSV)
	IF nHandle < 0
		cRetImp := "Nao foi possivel abrir o arquivo " + cArqCSV
		RETURN cRetImp
	ENDIF

	//-----------------------------------------------------------------------
	// Processa arquivo texto CSV
	//-----------------------------------------------------------------------
	ProcRegua( 0 )
	// Montagem do array
	FT_FGOTOP()
	DO WHILE !FT_FEOF()
		IncProc( "Aguarde..." + ALLTRIM(STR(nLinha)) )
		nLinha++
		cLinha 	:= FT_FREADLN()
		cLinha	:= STRTRAN(cLinha, "ï»¿", "")
		If nLinha == 1
			Aadd(_aCab , StrTokArr2(cLinha, ";",.t.))
		Else
			Aadd(_aCSV , StrTokArr2(cLinha, ";",.t.))
			nLidos ++
		Endif
		FT_FSKIP()
	ENDDO
	FT_FUSE()           
	// Validar campos para execucao da execauto
		
	If Len(_aCSV)> 0
		// para descartar o cabecalho //
		For _i := 1 to Len(_aCSV)
			If Len(_aCSV[_i]) < Len(_aCab[1]) // linha com numero de elementos diferente do cabecalho
				LogErGCAF("Registro inválido - Numero de elementos diferente do cabecalho", _i)
                nErroProc++
//				Aadd(_aErros, "linha "+Alltrim(Str(_i+1))+" com numero de elementos diferente do cabecalho")
//				Alert("linha "+Alltrim(Str(nLidos))+" com numero de elementos diferente do cabecalho")
			Else
				cTipoTran	:= "TB"
				cFil := cFilOri	:= cFilDes	:= _aCSV[_i][02]
//				dData		:= Stod(_aCSV[_i][03])
//				nMoeda		:= _aCSV[_i][04]
//				nValor		:= Val(_aCSV[_i][05])
				nValor		:= Val(StrTran(_aCSV[_i][05],",","."))
				cNatur		:= _aCSV[_i][06]
				cBco		:= _aCSV[_i][07]
				cAgen		:= _aCSV[_i][08]
				cCta		:= _aCSV[_i][09]
				cBenef100	:= _aCSV[_i][10]
				cHist100	:= _aCSV[_i][11]
				cBcoOrig	:= _aCSV[_i][12]
				cAgenOrig	:= _aCSV[_i][13]
				cCtaOrig	:= _aCSV[_i][14]
				cNaturOri	:= _aCSV[_i][15]
				cBcoDest	:= _aCSV[_i][16] 
				cAgenDest	:= _aCSV[_i][17]
				cCtaDest	:= _aCSV[_i][18]   
				cNaturDes	:= _aCSV[_i][19]
				cDocTran	:= Iif(Len(_aCSV[_i])>19,_aCSV[_i][20],"")
	
	
				If Val(_aCSV[_i][1]) == 3 .or. Val(_aCSV[_i][1]) == 4 // Validar registros: Operação tipo 3 e 4  - Movimentação DÉBITO e CREDITO
					_lRet := ValidMov(_i,cNatur,cBco,cAgen,cCta,nValor,cBenef100,cHist100,cFil)			
	
				ElseIf Val(_aCSV[_i][1]) == 7 // Validar registros: Operação tipo 7 - Movimentação TRANSFERENCIA
					_lRet := ValidTran(_i,"TB",cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValor,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig,cHist100,cFilOri,cFilDes)

			    Else
					LogErGCAF("Tipo de registro inválido - Numero de elementos diferente do cabecalho: "+Alltrim(Str(_aCSV[_i][1])), _i)
	                nErroProc++
//					Alert("Tipo de registro invalido :"+Alltrim(Str(_aCSV[_i][1])))
					_lRet := .F.

				Endif    
//				If _lRet .and. nErroProc = 0
				If nErroProc = 0
					Aadd(_aEfetiva,_aCSV[_i])		    
				Else
					_lRet := .t.
				Endif					
			Endif
		Next _i	    
		
		If Len(_aEfetiva) > 0
			// Efetiva movimentacao
			For _k := 1 to Len(_aEfetiva)
				IncProc( "Efetivando movimentacao...: " + ALLTRIM(STR(_k)) +" de "+ALLTRIM(STR(Len(_aEfetiva)))+" REGISTROS")
				Efetiva(_aEfetiva[_k])
			Next _k
		Endif

	Else 
		_lRet := .F.
		Alert("Arquivo vazio...")
	Endif

	RETURN cRetImp

//-----------------------------------------------------------------------
/*/{Protheus.doc} ValidTran()

Valida os dados da transferência de mútuo

@param		cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,
			nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig,
			cHist100,cFilOri,cFilDes
@return		lRet = .T. ou .F.
@author 	Fabio Cazarini
@since 		18/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ValidTran(nLinha,cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig,cHist100,cFilOri,cFilDes)
	LOCAL lRet 		:= .T.
	LOCAL cFILSED	:= ""
	LOCAL cFILSE5	:= ""
	LOCAL aFilAce	:= {}                                              
	nLinha := nLinha + 1 // para considerar o cabecalho

	IF EMPTY(cFilOri) .OR. EMPTY(cBcoOrig)  .OR. EMPTY(cAgenOrig)  .OR. EMPTY(cCtaOrig)  
		LogErGCAF("Informe os dados da conta origem da transferência!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe os dados da conta origem da transferência!" )
		lRet := .F.
	ELSE
		IF !EMPTY(xFILIAL("SE5"))
			cFILSE5 := LEFT(cFilOri, LEN(ALLTRIM(xFILIAL("SE5"))) )
			cFILSE5 := PADR(cFILSE5, LEN(xFILIAL("SE5")) ) 
		ELSE
			cFILSE5 := xFILIAL("SE5")
		ENDIF
	
		DbSelectArea("SA6")
		DbSetOrder(1) // A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON

		cAgenOrig 	:= PADR(cAgenOrig, LEN(SA6->A6_AGENCIA) ) 
		cCtaOrig 	:= PADR(cCtaOrig , LEN(SA6->A6_NUMCON ) ) 
		
		IF !DbSEEK( cFILSE5 + cBcoOrig + cAgenOrig + cCtaOrig )
			LogErGCAF("Dados da conta origem transferência inválidos! ("+cBcoOrig + "-" + cAgenOrig + "-" + cCtaOrig+")", nLinha)
            nErroProc++
//			Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Dados da conta origem transferência inválidos!" )
			lRet := .F.
		ENDIF
	ENDIF

	IF EMPTY(cNaturOri)
		LogErGCAF("Informe a natureza origem da transferência!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe a natureza origem da transferência!" )
		lRet := .F.
	ELSE
		IF !EMPTY(xFILIAL("SED"))
			cFILSED := LEFT(cFilOri, LEN(ALLTRIM(xFILIAL("SED"))) )
			cFILSED := PADR(cFILSED, LEN(xFILIAL("SED")) ) 
		ELSE
			cFILSED := xFILIAL("SED")
		ENDIF

		DbSelectArea("SED")
		DbSetOrder(1) // ED_FILIAL+ED_CODIGO
		IF !DbSEEK( cFILSED + cNaturOri )
			LogErGCAF("Natureza origem da transferência inválida! ("+cNaturOri+")", nLinha)
            nErroProc++
//			Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Natureza origem da transferência inválida!"  )
			lRet := .F.
		ENDIF
	ENDIF

	IF EMPTY(cFilDes) .OR. EMPTY(cBcoDest)  .OR. EMPTY(cAgenDest)  .OR. EMPTY(cCtaDest)  
		LogErGCAF("Informe os dados da conta destino da transferência!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe os dados da conta destino da transferência!"  )
		lRet := .F.
	ELSE
		IF !EMPTY(xFILIAL("SE5"))
			cFILSE5 := LEFT(cFilDes, LEN(ALLTRIM(xFILIAL("SE5"))) )
			cFILSE5 := PADR(cFILSE5, LEN(xFILIAL("SE5")) ) 
		ELSE
			cFILSE5 := xFILIAL("SE5")
		ENDIF
	
		DbSelectArea("SA6")
		DbSetOrder(1) // A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON

		cAgenDest 	:= PADR(cAgenDest, LEN(SA6->A6_AGENCIA) ) 
		cCtaDest 	:= PADR(cCtaDest , LEN(SA6->A6_NUMCON ) ) 

		IF !DbSEEK( cFILSE5 + cBcoDest + cAgenDest + cCtaDest )
			LogErGCAF("Dados da conta destino transferência inválidos! ("+cBcoDest + "-" + cAgenDest + "-" + cCtaDest+")", nLinha)
            nErroProc++
//			Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Dados da conta destino transferência inválidos!"  )
			lRet := .F.
		ENDIF
	ENDIF

	IF EMPTY(cNaturDes)
		LogErGCAF("Informe a natureza destino da transferência!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe a natureza destino da transferência!"  )
		lRet := .F.
	ELSE
		IF !EMPTY(xFILIAL("SED"))
			cFILSED := LEFT(cFilDes, LEN(ALLTRIM(xFILIAL("SED"))) )
			cFILSED := PADR(cFILSED, LEN(xFILIAL("SED")) ) 
		ELSE
			cFILSED := xFILIAL("SED")
		ENDIF

		DbSelectArea("SED")
		DbSetOrder(1) // ED_FILIAL+ED_CODIGO
		IF !DbSEEK( cFILSED + cNaturDes )
			LogErGCAF("Natureza destino da transferência inválida! ("+cNaturDes+")", nLinha)
            nErroProc++
//			Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Natureza destino da transferência inválida!"  )
			lRet := .F.
		ENDIF
	ENDIF

	IF EMPTY(cTipoTran)
		LogErGCAF("Informe o tipo da movimentação de transferência!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe o tipo da movimentação de transferência!"  )
		lRet := .F.
	ENDIF

	IF EMPTY(nValorTran)
		LogErGCAF("Informe o valor da transferência!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe o valor da transferência!"  )
		lRet := .F.
	ENDIF

	IF EMPTY(cHist100)
		LogErGCAF("Informe o histórico da transferência!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe o histórico da transferência!"  )
		lRet := .F.
	ENDIF

	IF EMPTY(cBenef100)
		LogErGCAF("Informe o beneficiário da transferência!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe o beneficiário da transferência!"  )
		lRet := .F.
	ENDIF

RETURN lRet

STATIC FUNCTION ValidMov(nLinha,cNatur,cBco,cAgen,cCta,nValor,cBenef100,cHist100,cFil)
	LOCAL lRet 		:= .T.
	LOCAL cFILSED	:= ""
	LOCAL cFILSE5	:= ""
	LOCAL aFilAce	:= {}

	nLinha := nLinha + 1 // para considerar o cabecalho

	IF EMPTY(cFil) .OR. EMPTY(cBco)  .OR. EMPTY(cAgen)  .OR. EMPTY(cCta)  
		LogErGCAF("Linha "+Alltrim(str(nLinha))+": Informe os dados da conta (Banco / Agencia / Conta)!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe os dados da conta (Banco / Agencia / Conta)!" )
		lRet := .F.
	ELSE
		IF !EMPTY(xFILIAL("SE5"))
			cFILSE5 := LEFT(cFil, LEN(ALLTRIM(xFILIAL("SE5"))) )
			cFILSE5 := PADR(cFILSE5, LEN(xFILIAL("SE5")) ) 
		ELSE
			cFILSE5 := xFILIAL("SE5")
		ENDIF
	
		DbSelectArea("SA6")
		DbSetOrder(1) // A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON

		cAgen 	:= PADR(cAgen, LEN(SA6->A6_AGENCIA) ) 
		cCta 	:= PADR(cCta , LEN(SA6->A6_NUMCON ) ) 
		                                         
		IF !DbSEEK( cFILSE5 + cBco + cAgen + cCta )
			LogErGCAF("Chave SE5: "+cFILSE5 + cBco + cAgen + cCta, nLinha)
            nErroProc++
			LogErGCAF("Dados da conta inválidos!  ("+cBco + "-" + cAgen + "-" + cCta+")", nLinha)
            nErroProc++
//			Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Dados da conta inválidos!" )
			lRet := .F.
		ENDIF
	ENDIF

	IF EMPTY(cNatur)
		LogErGCAF("Informe a natureza origem da transferência!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe a natureza origem da transferência!" )
		lRet := .F.
	ELSE
		IF !EMPTY(xFILIAL("SED"))
			cFILSED := LEFT(cFil, LEN(ALLTRIM(xFILIAL("SED"))) )
			cFILSED := PADR(cFILSED, LEN(xFILIAL("SED")) ) 
		ELSE
			cFILSED := xFILIAL("SED")
		ENDIF

		DbSelectArea("SED")
		DbSetOrder(1) // ED_FILIAL+ED_CODIGO
		IF !DbSEEK( cFILSED + cNatur )
			LogErGCAF("Natureza inválida! ("+cNatur+")", nLinha)
            nErroProc++
//			Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Natureza inválida!"  )
			lRet := .F.
		ENDIF
	ENDIF

	IF EMPTY(nValor)
		LogErGCAF("Informe o valor!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe o valor!"  )
		lRet := .F.
	ENDIF

	IF EMPTY(cHist100)
		LogErGCAF("Informe o histórico!", nLinha)
        nErroProc++
//		Aadd(_aErros, "Linha "+Alltrim(str(nLinha))+": Informe o histórico!"  )
		lRet := .F.
	ENDIF

	RETURN lRet

//-----------------------------------------------------------------------
/*/{Protheus.doc} Efetiva(): Realiza movimentacao bancaria (GCAF)

@author 	Pedro Augusto
@since 		18/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION Efetiva(_aLinhaProc)
	LOCAL lRet 			:= .F.
	LOCAL cFilAux		:= cFilAnt
	LOCAL aFINP100		:= {}
	PRIVATE lMsErroAuto := .F.
	Private dDatasys	:= dDatabase

	_nOpc		:= Val(_aLinhaProc[01])
	cFilAnt		:= _aLinhaProc[02]
	dDataE5 	:= Stod(_aLinhaProc[03])
	cMoeda	 	:= _aLinhaProc[04]
//	nValor	    := Val(_aLinhaProc[05])
	nValor		:= Val(StrTran(_aLinhaProc[05],",","."))
	cNatureza	:= _aLinhaProc[06]
	cBanco		:= _aLinhaProc[07]
	cAgencia	:= _aLinhaProc[08]
	cConta		:= _aLinhaProc[09]
	cBenef		:= _aLinhaProc[10]
	cHistor		:= _aLinhaProc[11]
	cBcoOri		:= _aLinhaProc[12]
	cAgenOri	:= _aLinhaProc[13]
	cCtaOri		:= _aLinhaProc[14]
	cNaturOri	:= _aLinhaProc[15]
	cBcoDest	:= _aLinhaProc[16]
	cAgenDest	:= _aLinhaProc[17]
	cCtaDest 	:= _aLinhaProc[18]
	cNaturDest	:= _aLinhaProc[19]                        
	cDocto		:= _aLinhaProc[20]                        

	dDatabase := dDataE5
	
	If _nOpc == 3 .or. _nOpc == 4 // Pagar / Receber
		cRecPag := Iif(_nOpc == 3,"P","R")
		aFINP100 := {;
					{"E5_DATA"		, dDataE5	, NIL},;
					{"E5_DOCUMEN" 	, ""		, NIL},;
					{"E5_MOEDA"		, cMoeda	, NIL},;
					{"E5_RECPAG"	, cRecPag	, NIL},;
					{"E5_VALOR"		, nValor	, NIL},;
					{"E5_NATUREZ"	, cNatureza	, NIL},;
					{"E5_BANCO"		, cBanco	, NIL},;
					{"E5_AGENCIA"	, cAgencia	, NIL},;
					{"E5_CONTA"		, cConta	, NIL},;
					{"E5_BENEF"		, cBenef	, NIL},;
					{"E5_HISTOR"	, cHistor	, NIL};
					}
	
	MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINP100,_nOpc)
	IF lMsErroAuto
		MostraErro()
		lRet := .F.
	ENDIF     
    	
	ElseIf _nOpc == 7 // Transferencia

		aFINP100 := {;
					{"E5_DATA"		, dDataE5	, NIL},;
					{"E5_MOEDA"		, cMoeda	, NIL},;
					{"E5_RECPAG"	, "P"		, NIL},;
					{"E5_TIPODOC"	, "TR"		, NIL},;
					{"E5_VALOR"		, nValor	, NIL},;
					{"E5_NATUREZ"	, cNaturOri	, NIL},;
					{"E5_BANCO"		, cBcoOri	, NIL},;
					{"E5_AGENCIA"	, cAgenOri	, NIL},;
					{"E5_CONTA"		, cCtaOri	, NIL},;
					{"E5_NUMCHEQ"	, cDocto	, NIL},;
					{"E5_BENEF"		, cBenef	, NIL},;
					{"E5_HISTOR"	, cHistor	, NIL};
					}
		MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINP100,3)
		IF lMsErroAuto
			MostraErro()
			lRet := .F.
		ENDIF     

		aFINP100 := {;
					{"E5_DATA"		, dDataE5	, NIL},;
					{"E5_MOEDA"		, cMoeda	, NIL},;
					{"E5_RECPAG"	, "R"		, NIL},;
					{"E5_TIPODOC"	, "TR"		, NIL},;
					{"E5_VALOR"		, nValor	, NIL},;
					{"E5_NATUREZ"	, cNaturDest, NIL},;
					{"E5_BANCO"		, cBcoDest	, NIL},;
					{"E5_AGENCIA"	, cAgenDest	, NIL},;
					{"E5_CONTA"		, cCtaDest	, NIL},;
					{"E5_DOCUMEN"	, cDocto	, NIL},;
					{"E5_BENEF"		, cBenef	, NIL},;
					{"E5_HISTOR"	, cHistor	, NIL};
					}
		MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINP100,4)
		IF lMsErroAuto
			MostraErro()
			lRet := .F.
		ENDIF     
	Endif
	dDatabase := dDatasys

	//-----------------------------------------------------------------------
	// Retorna a filial
	//-----------------------------------------------------------------------
	cFilAnt := cFilAux
	RETURN lRet
	
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
STATIC FUNCTION LogErGCAF(cDesErro, nLinha )
	LOCAL nHandle 	:= 0
	LOCAL cSeq		:= "000"
	
	IF EMPTY(cArqLog)
		cArqLog := LEFT( cArqCSV, RAT("\", cArqCSV) ) + "ERR_GCAF_" + DTOS(dDATABASE)
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
