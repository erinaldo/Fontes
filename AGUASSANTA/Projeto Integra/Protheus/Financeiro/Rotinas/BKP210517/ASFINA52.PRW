#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA52()

Mútuo de títulos a receber -
Adequação a rotina ASFINA44, para efetuar o processo do mútuo receber na confirmação do
movimento bancário.

@param		Nenhum
@return		Nenhum 
@author 	Zema
@since 		24/10/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra 
@releases	10/05/17 Zema: 	- Não considerar os parâmetros - Valor de / ate
							- Campo valor de baixa E5_XVALMUT, somente visual
							- Na seleção do titulo, indicar o valor a ser baixado
							- A titulo selecionado e na confirmação, validar se o total baixado é maior que o valor recebido
							- Não selecionar titulos securitizados   
							- Não selecionar RA - pagamento antecipado
							- Não selecionar PR - provisórios
							- Não selecionar NCC - Nota de crédito
							- Histórico dos titulos baixados por Mútuo = MUTUO - EMPRESA RECEBEDORA
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA52()
LOCAL aPar		:= {}
LOCAL aRet		:= {}
LOCAL cPICTVAL	:= PESQPICT("SE1", "E1_VALOR")
LOCAL lRet		:= .F.	
LOCAL aArea		:= GETAREA()        
Local cOldHist  := M->E5_HISTOR

PRIVATE cSITSE1		:= ALLTRIM(GETNEWPAR( "AS_SITSE1", "8", cFILANT )) // Situações dos títulos a receber securitizados. Sep. p/ '|'. Exemplo: 0|1
PRIVATE cSITSE9		:= ALLTRIM(GETNEWPAR( "AS_SITSE9", "9", cFILANT )) // Situações dos títulos a receber securitizados vencidos. Sep. p/ '|'. Exemplo: 2
PRIVATE cSITSEC		:= cSITSE1 + IIF(RIGHT(cSITSE1,1)=="|","","|") + cSITSE9
PRIVATE cFilialDe	:= SPACE( LEN(cFilAnt) ) 
PRIVATE cFilialAte	:= REPLICATE( "Z", LEN(cFilAnt) )	
PRIVATE dVencReaDe	:= CTOD("//")
PRIVATE dVencReaAt	:= dDATABASE
PRIVATE cClienteDe	:= SPACE(LEN(SE1->E1_CLIENTE))
PRIVATE cClienteAt	:= REPLICATE("Z", LEN(SE1->E1_CLIENTE) )
PRIVATE cTipoDe		:= SPACE(LEN(SE1->E1_TIPO))
PRIVATE cTipoAte	:= REPLICATE("Z", LEN(SE1->E1_TIPO) )
PRIVATE nValorDe	:= 0.00
PRIVATE nValorAte	:= 9999999999999.99

PRIVATE nXVALMUT	:= 0
PRIVATE nE5_VALOR	:= M->E5_VALOR
PRIVATE lContinua   := .T.
PRIVATE nTamFil		:= LEN(ALLTRIM(XFILIAL("SE1")))
PRIVATE nValBX		:= 0                                                  
                                 
// Valida as informações digitadas no movimento bancário
// Banco , agência e conta
             
SA6->(DBSETORDER(1))
IF SA6->(!DBSEEK(XFILIAL("SA6")+M->E5_BANCO+M->E5_AGENCIA+M->E5_CONTA))
	ApMsgAlert("Banco/Agencia/Conta, não cadastrado.")
	lContinua := .F.
ENDIF


// MV_DATAFIN
IF lContinua
	IF M->E5_DATA < SuperGetMv("MV_DATAFIN") 
		ApMsgAlert("Data de movimento inferior a data do ultimo fechamento.")
		lContinua := .F.		                                             
	ENDIF
ENDIF	
     
IF lContinua

	//-----------------------------------------------------------------------
	// Definição dos Parametros da Rotina
	//-----------------------------------------------------------------------
	// 1 - MsGet
	//  [2] : Descrição
	//  [3] : String contendo o inicializador do campo
	//  [4] : String contendo a Picture do campo
	//  [5] : String contendo a validação
	//  [6] : Consulta F3
	//  [7] : String contendo a validação When
	//  [8] : Tamanho do MsGet
	//  [9] : Flag .T./.F. Parâmetro Obrigatório ?
	//
	aAdd(aPar,{1	,"Filial - de"			, cFilialDe 	, "" 		, , "SM0_01"	, , 050, .F.})
	aAdd(aPar,{1	,"Filial - até"			, cFilialAte	, ""		, , "SM0_01"	, , 050, .F.})
	aAdd(aPar,{1	,"Vencimento - de"		, dVencReaDe 	, ""		, , 			, , 050, .F.})
	aAdd(aPar,{1	,"Vencimento - até"		, dVencReaAt	, ""		, , 			, , 050, .F.})
	aAdd(aPar,{1	,"Cliente - de"			, cClienteDe 	, ""		, , "SA1"		, , 050, .F.})
	aAdd(aPar,{1	,"Cliente - até"		, cClienteAt	, ""		, , "SA1"		, , 050, .F.})
	aAdd(aPar,{1	,"Tipo - de"			, cTipoDe 		, ""		, , 			, , 040, .F.})
	aAdd(aPar,{1	,"Tipo - até"			, cTipoAte		, ""		, , 			, , 040, .F.})

/* Release 10/05/17
	aAdd(aPar,{1	,"Valor - de"			, nValorDe 		, cPICTVAL	, , 			, , 080, .F.})
	aAdd(aPar,{1	,"Valor - até"			, nValorAte		, cPICTVAL	, , 			, , 080, .F.})
*/
	//Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet

	lRet 	:= ParamBox(aPar,"Selecionar títulos para a baixa",@aRet,,,,,,,"ASFINA44B",.F.,.F.)
	IF lRet
		cFilialDe	:= PADR(SUBSTR(ALLTRIM(aRet[1]),1,nTamFil),LEN(XFILIAL("SE1")))
		cFilialAte	:= PADR(SUBSTR(ALLTRIM(aRet[2]),1,nTamFil),LEN(XFILIAL("SE2")))
		dVencReaDe	:= aRet[3]
		dVencReaAt	:= aRet[4]
		cClienteDe	:= ALLTRIM(aRet[5])
		cClienteAt	:= ALLTRIM(aRet[6])
		cTipoDe		:= ALLTRIM(aRet[7])
		cTipoAte	:= ALLTRIM(aRet[8])                 
		
// Release 10/05/17		
//		nValorDe	:= aRet[9]
//		nValorAte	:= aRet[10]
	ENDIF
    
    lContinua := lRet

	//-----------------------------------------------------------------------
	// Exibe markbrowse para seleção dos títulos que devem ter a filial 
	// pagadora substituída
	//-----------------------------------------------------------------------
	IF lRet             
		lContinua := .F.
		Processa({|| TelaMark()},"Selecionando registros", "", .F.)
		
		M->E5_HISTOR := cOldHist
		
	ENDIF
    
	IF !lContinua
		ApMsgAlert("Para concluir esta operação, é necessário baixar titulos de mútuo!")
	ENDIF	

ENDIF
	      
RESTAREA(aArea)	
	
RETURN(lContinua)


//-----------------------------------------------------------------------
/*/{Protheus.doc} TelaMark()

Exibe markbrowse para seleção dos títulos que devem ser baixados

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION TelaMark()
	
	PRIVATE arotina 	:= {}
	PRIVATE cCADASTRO	:= "Selecionar títulos para a baixa"
	PRIVATE cMark		:= GetMark()
	PRIVATE aFieSE1		:= {}
	PRIVATE cArqSE1		:= ""
	PRIVATE bOpcMar0 	:= {|| IF(BaixarTit(), CloseBrowse() ,"")}
	PRIVATE bOpcMar1 	:= {|| MarcaTud()}
	PRIVATE bOpcMar2 	:= {|| MarcaIte("A")} 
	PRIVATE bCancel		:= {||CloseBrowse()}
	PRIVATE oTit
	
	AADD( aRotina, { "Baixar títulos selecionados"	,"Eval(bOpcMar0)" 	, 0, 4} )
	AADD( aRotina, { "Cancelar"	,"Eval(bCancel)" 	, 0, 4} )

	//-----------------------------------------------------------------------
	// Gera arquivo temporario 
	//-----------------------------------------------------------------------
	Processa({|| MontaSE1()},"Processando...", "", .F.)

	DbSelectArea("TRBMKB")
	DbGotop()                                                                                     
	MarkBrow( 'TRBMKB', 'E1_OK',,aFieSE1,, cMark ,"Eval(bOpcMar1)"   ,,,,"Eval(bOpcMar2)"   ,,,.T.,)

	//-----------------------------------------------------------------------
	// Apaga a tabela temporária
	//-----------------------------------------------------------------------
	DbSelectArea("TRBMKB")
	DbCloseArea() 
	MsErase(cArqSE1+GetDBExtension(),,"DBFCDX")

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} MontaSE1

Monta arquivo temporario de acordo com os parametros selecionados

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MontaSE1()
	//-----------------------------------------------------------------------
	// Declaracao de Variaveis
	//-----------------------------------------------------------------------
	LOCAL aStru		:= {}
	LOCAL aCampos	:= {}
	LOCAL nX          
	LOCAL bCampo
	LOCAL cCampo	:= ""
	LOCAL cQuery	:= ""
	LOCAL nREGSE1	:= 0
	LOCAL aFilAce	:= {}         
	LOCAL cFilOld   := cFilAnt

	//-----------------------------------------------------------------------
	// Função para retornar as filiais que o usuário corrente tem acesso
	//-----------------------------------------------------------------------
	aFilAce := U_ASCADA02( RetCodUsr() ) 

	//-----------------------------------------------------------------------
	// Monta TRB 
	//-----------------------------------------------------------------------
	cQuery := " SELECT SE1.R_E_C_N_O_  AS REGSE1 "
	cQuery += " FROM " + RetSqlName("SE1") + " SE1 "
	cQuery += " WHERE	SE1.E1_FILIAL BETWEEN '" + cFilialDe + "' AND '" + cFilialAte + "' " 
	cQuery += " 	AND SE1.E1_VENCREA BETWEEN '" + DTOS(dVencReaDe) + "' AND '" + DTOS(dVencReaAt) + "' " 
	cQuery += " 	AND SE1.E1_CLIENTE BETWEEN '" + cClienteDe + "' AND '" + cClienteAt + "' " 
	cQuery += " 	AND SE1.E1_TIPO BETWEEN '" + cTipoDe + "' AND '" + cTipoAte + "' " 

/* Release 10/05/17
	cQuery += " 	AND SE1.E1_VALOR BETWEEN " + ALLTRIM(STR(nValorDe)) + " AND " + ALLTRIM(STR(nValorAte)) + " " 
*/       
	cQuery += "     AND SE1.E1_SITUACA NOT IN "+FORMATIN(cSITSEC,"|")
	cQuery += "		AND SE1.E1_TIPO NOT IN('RA ','NCC', 'PR ') "
  
	cQuery += "		AND SE1.E1_SALDO > 0 " 
	cQuery += " 	AND SE1.D_E_L_E_T_ = ' '	"
	cQuery += " ORDER BY SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_CLIENTE, SE1.E1_LOJA "

	IF SELECT("TRBSE1") > 0
		TRBSE1->( dbCloseArea() )
	ENDIF    
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TRBSE1" ,.F.,.T.)

	ProcRegua(0)

	//-----------------------------------------------------------------------
	// Cria arquivo temporario
	//-----------------------------------------------------------------------
	aStru	:= {}
	aFieSE1	:= {}
	aCampos	:= {}

	//-----------------------------------------------------------------------
	// Para criar a estrutura temporaria
	//-----------------------------------------------------------------------
	AADD(aStru,	{"E1_OK"		, "C", TAMSX3("E2_OK")[01]		, 0	})
	AADD(aStru,	{"E1_FILIAL"	, "C", TAMSX3("E1_FILIAL")[01]	, 0	})
	AADD(aStru,	{"SE1REG"		, "N", 10						, 0	})
	
	//-----------------------------------------------------------------------
	// Lista das colunas do MarkBrowse
	//-----------------------------------------------------------------------
	AADD(aFieSE1,	{"E1_OK"		, "C", ""					})
	AADD(aFieSE1,	{"E1_FILIAL"	, "C", "Filial"				})

	//-----------------------------------------------------------------------
	// para criar a estrutura temporaria - E1_SALDO
	//-----------------------------------------------------------------------
	AADD(aStru,	{"E1_SALDO", "N", TAMSX3("E1_SALDO")[1], TAMSX3("E1_SALDO")[2]})
	AADD(aFieSE1,	{"E1_SALDO", "N", "Saldo em aberto", PESQPICT("SE1", "E1_SALDO"), TAMSX3("E1_SALDO")[1], TAMSX3("E1_SALDO")[2] })

	// Release 10/05/17
	//-----------------------------------------------------------------------
	// para criar a estrutura temporaria - VALOR BAIXADO
	//-----------------------------------------------------------------------
	AADD(aStru,	{"E1_VLBAIXA", "N", TAMSX3("E1_SALDO")[1], TAMSX3("E1_SALDO")[2]})
	AADD(aFieSE1,	{"E1_VLBAIXA", "N", "Valor de Baixa", PESQPICT("SE1", "E1_SALDO"), TAMSX3("E1_SALDO")[1], TAMSX3("E1_SALDO")[2] })

	dbSelectArea("SX3")
	DbSetOrder(1)
	DbGoTop()
	dbSeek("SE1")
	While !Eof().And.(SX3->x3_arquivo=="SE1")
		If Alltrim(SX3->x3_campo)=="E1_FILIAL" .OR. Alltrim(SX3->x3_campo)=="E1_OK" .OR. Alltrim(SX3->x3_campo)=="E1_SALDO" .OR. Alltrim(SX3->x3_visual)=="V" 
			dbSelectArea("SX3")
			dbSkip()
			Loop
		Endif
		If (X3USO(SX3->x3_usado) .AND. ALLTRIM(UPPER(SX3->x3_browse)) == 'S')
			// para criar a estrutura temporaria
			AADD(aStru,	{SX3->x3_campo, SX3->x3_tipo, SX3->x3_tamanho, SX3->x3_decimal})
			
			// lista das colunas do MarkBrowse
			AADD(aFieSE1,	{SX3->x3_campo, SX3->x3_tipo, SX3->x3_titulo, SX3->X3_picture, SX3->x3_tamanho, SX3->x3_decimal })
			
			// lista das campos para popular no MarkBrowse
			AADD( aCampos, "TRBMKB->"+ALLTRIM(SX3->x3_campo) + " := " + "SE1->"+ALLTRIM(SX3->x3_campo) )
		Endif

		dbSelectArea("SX3")
		dbSkip()
	Enddo

	//-----------------------------------------------------------------------
	// Cria a tabela temporária
	//-----------------------------------------------------------------------
	IF SELECT("TRBMKB") > 0
		DBSELECTAREA("TRBMKB")
		DBCLOSEAREA()
	ENDIF
	cArqSE1	:=	"T_"+Criatrab(,.F.)
	MsCreate(cArqSE1,aStru,"DBFCDX") // atribui a tabela temporária ao alias TRB
	dbUseArea(.T.,"DBFCDX",cArqSE1,"TRBMKB",.T.,.F.)// alimenta a tabela temporária

	//-----------------------------------------------------------------------
	// Popula a tabela temporária
	//-----------------------------------------------------------------------
	DbSelectArea("TRBSE1")
	DbGoTop()
	DO WHILE !EOF()
		nREGSE1 := TRBSE1->REGSE1
	
		DbSelectArea("SE1")
		DbGoTo( nREGSE1 )

		IF ! SE1->E1_TIPO $ MVABATIM

			//-----------------------------------------------------------------------
			// Se o usuário tem acesso à filial
			//-----------------------------------------------------------------------
			IF aSCAN( aFilAce, cEmpAnt+SE1->E1_MSFIL ) > 0
				DBSELECTAREA("TRBMKB")
				RECLOCK("TRBMKB",.T.)
				FOR nX := 1 TO LEN( aCampos )
					bCampo := aCampos[nX]
					&bCampo
				NEXT                          
				
				cFilOld := cFilAnt
				cFilAnt := SE1->E1_MSFIL //SE1->E1_FILIAL
				
				SomaAbat("","","","R")
				nAbat :=	SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
				
				cFilAnt := cFilOld
		
				TRBMKB->E1_OK 		:= ""
				TRBMKB->E1_FILIAL	:= SE1->E1_FILIAL
				TRBMKB->E1_SALDO	:= SE1->E1_SALDO - nAbat
				TRBMKB->E1_VLBAIXA	:= SE1->E1_SALDO - nAbat
				TRBMKB->SE1REG 		:= nREGSE1
				MSUNLOCK()
			ENDIF

		ENDIF
				
		DbSelectArea("TRBSE1")
		DbSkip()
	ENDDO
	TRBSE1->( DbCloseArea() )

RETURN 


//-----------------------------------------------------------------------
/*/{Protheus.doc} MarcaTud

Marca ou desmarca todos os itens do Markbrowse

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaTud()

	DbSelectArea("TRBMKB")
	DbGoTop()
	DO WHILE !EOF()
		MarcaIte("B")
	
		TRBMKB->( DbSkip() )
	ENDDO

RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} MarcaIte

Marca ou desmarca o item do Markbrowse

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION MarcaIte(pOpc)
Local oDlgMark
Local nValMark	:= IF(TRBMKB->E1_VLBAIXA == 0, TRBMKB->E1_SALDO, TRBMKB->E1_VLBAIXA)
Local oValMark  
Local lMark		:= .T.

IF IsMark("E1_OK",cMark )
	nXVALMUT -= TRBMKB->E1_VLBAIXA
		
	RecLock("TRBMKB",.F.)
	TRBMKB->E1_OK 		:= ""
	TRBMKB->( MsUnLock() )
ELSE

   IF pOpc == "A"

		Define MsDialog oDlgMark Title "Valor de Baixa" From 000,000 to 100,200 COLORS 0, 16777215 PIXEL
		@002,005 Button "Cancelar " Size 40,12 PIXEL OF oDlgMark action	(lMark:= .F., oDlgMark:end())
		@002,055 Button "Confirmar" Size 40,12 PIXEL OF oDlgMark action	(lMark := ValMark( @nValMark), oDlgMark:end())
		@020,005 MSGET oValMark VAR nValMark  PICTURE "99999999999.99" ;
		Valid ValMark( @nValMark) ;
		SIZE 100, 10 OF oDlgMark PIXEL HASBUTTON
		Activate MsDialog oDlgMark Centered		
 
	ENDIF


    IF lMark

 		nXVALMUT += nValMark

		RecLock("TRBMKB",.F.)
		TRBMKB->E1_OK 		:= cMark
		TRBMKB->E1_VLBAIXA	:= nValMark
 		TRBMKB->( MsUnLock() )
	ENDIF
ENDIF
RETURN           
//-----------------------------------------------------------------------
/*/{Protheus.doc} ValMark

Valida o valor marcado

@param		nValMark - Valor digitado
@return		Nenhum
@author 	Zema
@since 		10/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
Static Function ValMark(nValMark)
Local lRet 		:= .T.
Local nSaldo	:= 0
     
// Verifica se o valor é válido
IF lRet
	IF nValMark <= 0
		ApMsgAlert("Valor inválido.")
		lRet := .F.
	ENDIF
ENDIF 
 
// Verifica se o valor é maior que o saldo disponivel
IF lRet
	IF nValMark > TRBMKB->E1_SALDO
		ApMsgAlert("Valor informado é superior ao saldo do titulo.")
		lRet := .F.
	ENDIF
ENDIF

// Verifica se o valor acumulado é superior ao valor do movimento bancário
IF lRet
	nSaldo := nXVALMUT + nValMark
	IF nSaldo > nE5_VALOR
		ApMsgAlert("Total informado: "+TRANSFORM(nSaldo, PESQPICT("SE5", "E5_VALOR"))+" é superior ao valor do movimento recebido:" +TRANSFORM(nE5_VALOR, PESQPICT("SE5", "E5_VALOR")))
		lRet := .F.
	ENDIF		
ENDIF

Return(lRet)

//-----------------------------------------------------------------------
/*/{Protheus.doc} BaixarTit

Baixa os títulos a receber marcados

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION BaixarTit()
	LOCAL lRet		:= .T.
	LOCAL cCRLF		:= CHR(13) + CHR(10)	

	IF lRet
		IF nE5_VALOR == 0
			MsgAlert("Não existe valor para baixar", "Atenção")
		 	lRet := .F.
		ENDIF
	ENDIF
	
	IF lRet
		IF nXVALMUT == 0
			MsgAlert("É necessário selecionar os títulos a receber para baixar", "Atenção")
		 	lRet := .F.
		ENDIF
	ENDIF
	
	IF lRet
		IF nE5_VALOR <> nXVALMUT
			MsgAlert("Valor da movimentação diverge do valor selecionado para baixa: " + cCRLF + cCRLF +;
		 			 "Valor da movimentação: " + TRANSFORM(nE5_VALOR, PESQPICT("SE5", "E5_VALOR")) + cCRLF +;
		 			 "Valor selecionado: " + TRANSFORM(nXVALMUT, PESQPICT("SE5", "E5_VALOR")), "Atenção")
		 	lRet := .F.
		ENDIF
	ENDIF
				
	IF lRet
		IF MsgNoYes("Deseja realmente baixar os títulos a receber marcados?" + cCRLF + cCRLF +;
		 			 "Valor da movimentação: " + TRANSFORM(nE5_VALOR, PESQPICT("SE5", "E5_VALOR")) + cCRLF +;
		 			 "Valor selecionado: " + TRANSFORM(nXVALMUT, PESQPICT("SE5", "E5_VALOR")), "Confirme")
		 			 
			Processa({|| BaixarPro()},"Processando", "", .F.)
		ENDIF	
	ENDIF
            

RETURN(lRet)


//-----------------------------------------------------------------------
/*/{Protheus.doc} BaixarPro

Processa a baixa dos títulos a rebecer marcados

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION BaixarPro()
	LOCAL nReg		:= 0
	LOCAL nProcess	:= 0
	LOCAL lRetExec	:= .F.
	LOCAL nE1_SALDO	:= 0
	
	TRBMKB->(dbEval({|| nReg++ },,{|| !Eof()}))
	TRBMKB->(dbGoTop())  
                                 
	M->E5_XVALMUT := 0

	ProcRegua(nReg)

	DbSelectArea("TRBMKB")
	TRBMKB->(DbGoTop())
	DO WHILE TRBMKB->(!EOF())
		IncProc("Efetuando a baixa...")
		
		IF IsMark("E1_OK",cMark )
			DbSelectArea("SE1")
			DbGoTo( TRBMKB->SE1REG )
			nE1_SALDO := TRBMKB->E1_VLBAIXA //SE1->E1_SALDO
			
			//-----------------------------------------------------------------------
			// Baixa o título a pagar via ExecAuto
			//-----------------------------------------------------------------------
			lRetExec := ExeBaixa(cEMPANT, SE1->E1_FILIAL, SE1->E1_MSFIL, nE1_SALDO)
				
			IF lRetExec 
				//-----------------------------------------------------------------------
				// baixou o título
				//-----------------------------------------------------------------------
				IF SE5->( FIELDPOS("E5_XVALMUT") ) > 0
					M->E5_XVALMUT := M->E5_XVALMUT + nE1_SALDO
				ENDIF

				nE5_VALOR 	-= nE1_SALDO
		 		nXVALMUT	-= nE1_SALDO
					
				nProcess++
				
		
			ENDIF
		ENDIF

		DbSelectArea("TRBMKB")
		TRBMKB->( DbSkip() )
	ENDDO

	MsgInfo("Processo concluído. Foi(ram) baixado(s) " + ALLTRIM(STR(nProcess)) + " título(s) a receber", "Ok")

	IF nProcess > 0
		lContinua := .T.
	ENDIF
	
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} ExeBaixa

Baixa o título a receber via ExecAuto

@param		cEMPANT = Grupo de empresa da baixa
			cFILANT = Filial da baixa
@return		lRet = Se ocorreu erro
@author 	Fabio Cazarini
@since 		01/08/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ExeBaixa(cEMPPAR, cFILPAR, cFILSET, nVALBX)
	LOCAL aAreaSE5		:= {}
	LOCAL lRet			:= .T.
	LOCAL nOPC			:= 3 // Baixa título (nOpc = 3)
	LOCAL aDadosSE1		:= {}
	LOCAL cAUTBANCO 	:= PADR( "", TAMSX3("E5_BANCO")[1])
	LOCAL cAUTAGENCI	:= PADR( "", TAMSX3("E5_AGENCIA")[1])
	LOCAL cAUTCONTA		:= PADR( "", TAMSX3("E5_CONTA")[1])
	LOCAL cAUTMOTBX 	:= GETNEWPAR( "AS_MOTMUT", "MUT", SE1->E1_FILIAL )
	LOCAL cEMPAUX		:= cEMPANT
	LOCAL cFILAUX		:= cFILANT   
	LOCAL cNomEmp		:= ""      			
	LOCAL cPREFIXO		:= SE1->E1_PREFIXO
	LOCAL cNUM			:= SE1->E1_NUM
	LOCAL cPARCELA		:= SE1->E1_PARCELA
	LOCAL cTIPO			:= SE1->E1_TIPO
	LOCAL cCLIENTE		:= SE1->E1_CLIENTE
	LOCAL cLOJA			:= SE1->E1_LOJA
	LOCAL cNATUREZ		:= SE1->E1_NATUREZ 
	LOCAL nRegSM0		:= SM0->(RECNO())
	
	PRIVATE lMsErroAuto := .F.	// variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
    
  	// Release 10/05/17           
  	SM0->(DBSETORDER(1))
	SM0->(MsSeek(cEMPANT+cFILANT))
	cNomEmp	:= SM0->M0_NOMECOM  
	SM0->(DBGOTO(nRegSM0))


	//-----------------------------------------------------------------------
	// Array para o ExecAuto
	//-----------------------------------------------------------------------
	aDadosSE1 := {;
		{"E1_FILIAL"	, cFILPAR				, NIL		},;
		{"E1_PREFIXO"	, cPREFIXO				, NIL		},;
		{"E1_NUM"		, cNUM					, NIL		},;
		{"E1_PARCELA"	, cPARCELA				, NIL		},;
		{"E1_TIPO"		, cTIPO					, NIL		},;
		{"E1_CLIENTE"	, cCLIENTE				, NIL		},;
		{"E1_LOJA"		, cLOJA					, NIL		},;
		{"E1_NATUREZ"	, cNATUREZ				, NIL		},;
		{"AUTMOTBX"		, cAUTMOTBX				, NIL		},;
		{"AUTBANCO"		, cAUTBANCO				, NIL		},;
		{"AUTAGENCIA"	, cAUTAGENCI			, NIL		},;
		{"AUTCONTA"		, cAUTCONTA				, NIL		},;
		{"AUTDTBAIXA"	, dDATABASE				, NIL		},;
		{"AUTDTCREDITO"	, DataValida(dDATABASE)	, NIL		},;
		{"AUTHIST"		, ""					, NIL    	},;
		{"AUTDESCONT"	, 0						, NIL, .T.	},;
		{"AUTJUROS"		, 0						, NIL, .T.	},;
		{"AUTMULTA"		, 0						, NIL, .T.	},;
		{"AUTVALREC"	, nVALBX				, NIL		};
		}
	
	//-----------------------------------------------------------------------
	// Indica o grupo de empresas e filial da baixa
	//-----------------------------------------------------------------------
	cEMPANT := cEMPPAR
	cFILANT	:= cFILSET

	//-----------------------------------------------------------------------
	// Ordenar um vetor conforme o dic. para uso em rotinas de MSExecAuto
	//-----------------------------------------------------------------------
	aDadosSE1	:= FWVetByDic( aDadosSE1, 'SE1' )

	DbSelectArea("SE1")
	lMsErroAuto := .F.
	BeginTran()
	MSExecAuto({|x,y| Fina070(x,y)}, aDadosSE1, nOPC)//  3=Baixa de Título; 5=Cancelamento de baixa; 6=Exclusão de Baixa
		
	If lMsErroAuto
		DisarmTransaction()
		MostraErro()
			
		lRet := .F.
	Else
		EndTran()

		//-----------------------------------------------------------------------
		// Seta a filial origem da movimentacao bancaria do titulos baixado
		//-----------------------------------------------------------------------
		aAreaSE5 := SE5->( GetArea() )
		DbSelectArea("SE5")
		DbSetOrder(7) // E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
		IF DbSEEK(cFILPAR + cPREFIXO + cNUM + cPARCELA + cTIPO + cCLIENTE + cLOJA)
			DO WHILE !SE5->( EOF() ) .AND. ;
				SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == ;
				cFILPAR + cPREFIXO + cNUM + cPARCELA + cTIPO + cCLIENTE + cLOJA
	
				RecLock("SE5", .F.)
				SE5->E5_XBCOFIL := cFILAUX     
				SE5->E5_HISTOR  := "MUTUO - "+ALLTRIM(cNomEmp)
				SE5->( MsUnLock() )
				
				SE5->( DbSkip() )
			ENDDO
		ENDIF
		SE5->( RestArea(aAreaSE5) )
			
		lRet := .T.
	EndIf
		
	MsUnlockAll()

	//-----------------------------------------------------------------------
	// Restaura o grupo de empresas e filial
	//-----------------------------------------------------------------------
	cEMPANT := cEMPAUX
	cFILANT	:= cFILAUX

RETURN lRet