#INCLUDE 'TOTVS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³GPPA10    ³Autor  ³TOTVS Ibirapuera        #FIDIC           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Substituicao dos titulos em processo de Operacao/Deposito   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GPPA10(cAlias, nReg, nOpc)
Default cAlias   := 'SE1'
Default nReg     := SE1->(RecNo())

If nOpc == 1
	// -------------------------------------------
	// SELECAO DOS TITULOS PARA O PROCESSO DE FIDC
	// ------------------------------------------- 
	GPPA10Gera()

ElseIf nOpc == 2
	// ------------------------------------
	// CHAMA TELA PADRAO PARA GERACAO
	// DO BORDERO P/ OS TITULOS SUBSTITUTOS
	// ------------------------------------
	SE1->(DbGoTo(nReg))
	Fin740060('SE1', nReg, 2)

EndIf

//--NAO CHAMA NOVAMENTE A TELA
MBRCHGLoop()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³GPPA10Gera³Autor  ³TOTVS Ibirapuera                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Funcao responsavel pela selecao dos titulos do bordero para ³±±
±±³          ³realizacao do processo de Operacao/Deposito                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GPPA10Gera()
Local aParams      := {}
Local cAliasQry    := ''
Local aHeader      := {}
Local aTitulos     := {}
Local oOk          := LoadBitmap( GetResources(), "LBOK")
Local oNo          := LoadBitmap( GetResources(), "LBNO")
Local bBlock       := {|| }

Local oDlg         := NIL
Local oBrowse      := NIL
Local oGrpBrowse   := NIL
Local oGrpValSel   := NIL
Local oGetValSel   := NIL
Local nValSel      := 0
Local lOk          := .F.
Local cNotTpFdc    := GPPA10Tipos()

// ---------------------------------
// DETERMINA OS PARAMETROS DA ROTINA
// ---------------------------------
AAdd(aParams, {1, 'Do Banco'			, CriaVar('E1_PORTADO', .F.)	, PesqPict('SE1', 'E1_PORTADO')	,, 'SA6',, 30, .F.})
AAdd(aParams, {1, 'Da Agência'			, CriaVar('E1_AGEDEP', .F.)		, PesqPict('SE1', 'E1_AGEDEP')	,, ''	,, 35, .F.})
AAdd(aParams, {1, 'Da Conta'			, CriaVar('E1_CONTA', .F.)		, PesqPict('SE1', 'E1_CONTA')	,, ''	,, 40, .F.})
AAdd(aParams, {1, 'Até o Banco'			, CriaVar('E1_PORTADO', .F.)	, PesqPict('SE1', 'E1_PORTADO')	,, 'SA6',, 30, .F.})
AAdd(aParams, {1, 'Até a Agência'		, CriaVar('E1_AGEDEP', .F.)		, PesqPict('SE1', 'E1_AGEDEP')	,, ''	,, 35, .F.})
AAdd(aParams, {1, 'Até a Conta'			, CriaVar('E1_CONTA', .F.)		, PesqPict('SE1', 'E1_CONTA')	,, ''	,, 40, .F.})
AAdd(aParams, {1, 'Do Borderô'			, CriaVar('E1_NUMBOR', .F.)		, PesqPict('SE1', 'E1_NUMBOR')	,, ''	,, 35, .F.})
AAdd(aParams, {1, 'Até o Borderô'		, CriaVar('E1_NUMBOR', .F.)		, PesqPict('SE1', 'E1_NUMBOR')	,, ''	,, 35, .F.})
AAdd(aParams, {1, 'Prefixo De'			, CriaVar('E1_PREFIXO', .F.)	, PesqPict('SE1', 'E1_PREFIXO')	,, ''	,, 30, .F.})
AAdd(aParams, {1, 'Prefixo Ate'			, CriaVar('E1_PREFIXO', .F.)	, PesqPict('SE1', 'E1_PREFIXO')	,, ''	,, 30, .F.})
AAdd(aParams, {1, 'do Tipo'				, CriaVar('E1_TIPO', .F.)		, PesqPict('SE1', 'E1_TIPO')	,, '05'	,, 35, .F.})
AAdd(aParams, {1, 'Até Tipo'			, CriaVar('E1_TIPO', .F.)		, PesqPict('SE1', 'E1_TIPO')	,, '05'	,, 35, .F.})
AAdd(aParams, {1, 'Do Numero'			, CriaVar('E1_NUM', .F.)		, PesqPict('SE1', 'E1_NUM')		,, ''	,, 50, .F.})
AAdd(aParams, {1, 'Até o Numero'		, CriaVar('E1_NUM', .F.)		, PesqPict('SE1', 'E1_NUM')		,, ''	,, 50, .F.})
AAdd(aParams, {1, 'Da Natureza'			, CriaVar('E1_NATUREZ', .F.)	, PesqPict('SE1', 'E1_NATUREZ')	,, 'SED',, 70, .F.})
AAdd(aParams, {1, 'Até a Natureza'		, CriaVar('E1_NATUREZ', .F.)	, PesqPict('SE1', 'E1_NATUREZ')	,, 'SED',, 70, .F.})
AAdd(aParams, {1, 'Do Cliente'			, CriaVar('E1_CLIENTE', .F.)	, PesqPict('SE1', 'E1_CLIENTE')	,, 'SA1',, 60, .F.})
AAdd(aParams, {1, 'Da Loja'				, CriaVar('E1_LOJA', .F.)		, PesqPict('SE1', 'E1_LOJA')	,, ''	,, 35, .F.})
AAdd(aParams, {1, 'Até o Cliente'		, CriaVar('E1_CLIENTE', .F.)	, PesqPict('SE1', 'E1_CLIENTE')	,, 'SA1',, 60, .F.})
AAdd(aParams, {1, 'Ate a Loja'			, CriaVar('E1_LOJA', .F.)		, PesqPict('SE1', 'E1_LOJA')	,, ''	,, 35, .F.})
AAdd(aParams, {1, 'Emissão De'			, CriaVar('E1_EMISSAO', .F.)	, PesqPict('SE1', 'E1_EMISSAO')	,, ''	,, 65, .F.})
AAdd(aParams, {1, 'Emissão Até'			, CriaVar('E1_EMISSAO', .F.)	, PesqPict('SE1', 'E1_EMISSAO')	,, ''	,, 65, .F.})
AAdd(aParams, {1, 'Vencimento De'		, CriaVar('E1_VENCTO', .F.)		, PesqPict('SE1', 'E1_VENCTO')	,, ''	,, 65, .F.})
AAdd(aParams, {1, 'Vencimento Até'		, CriaVar('E1_VENCTO', .F.)		, PesqPict('SE1', 'E1_VENCTO')	,, ''	,, 65, .F.})

// --------------------
// SELECIONA OS TITULOS
// --------------------
//Verifica parametro para a geração do PIS/COF/CSL na Baixa
//Caso seja na baixa inclui os campos na query para subtrair do valor (Valor Liquido)
lImpBx := Iif(GetMv("MV_BR10925") = "1" ,.T.,.F.)
If (lImpBx)
   cValImp := "%(SE1L.E1_CSLL+SE1L.E1_COFINS+SE1L.E1_PIS)%"
Else
   cValImp := "%0%"
EndIf

If ParamBox(aParams, 'Parâmetros')
	cAliasQry := GetNextAlias()
	BeginSQL Alias cAliasQry
		SELECT SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SX5.X5_DESCRI, SE1.E1_NATUREZ, SED.ED_DESCRIC,
		       SE1.E1_CLIENTE, SE1.E1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ, SE1.E1_EMISSAO, SE1.E1_VENCTO, SE1.E1_VENCREA,SE1.E1_NFELETR, 
		       ( SELECT 
			   		SUM(CASE WHEN SE1L.E1_TIPO = 'NF' THEN SE1L.E1_VALOR-%Exp:cValImp% ELSE (SE1L.E1_VALOR*-1) END ) AS LIQUIDO 
				FROM 
					%Table:SE1% SE1L
				WHERE 
					SE1L.E1_FILIAL = SE1.E1_FILIAL
					AND SE1L.E1_PREFIXO = SE1.E1_PREFIXO
					AND SE1L.E1_NUM = SE1.E1_NUM
					AND SE1L.E1_CLIENTE = SE1.E1_CLIENTE
					AND SE1L.E1_LOJA = SE1.E1_LOJA
					AND SE1L.E1_NFELETR = SE1.E1_NFELETR
					AND SE1L.%NOTDEL%
			    ) AS E1_LIQ
				, E1_VALOR
			   , SE1.E1_PORTADO, SE1.E1_AGEDEP, SE1.E1_CONTA, SE1.E1_NUMBOR, SE1.R_E_C_N_O_ SE1Recno
		  FROM %Table:SE1% SE1
		  JOIN %Table:SX5% SX5
		    ON SX5.X5_FILIAL = %xFilial:SX5%
		   AND SX5.X5_TABELA = %Exp:'05'%
		   AND SX5.X5_CHAVE = SE1.E1_TIPO
		   AND SX5.%NotDel%
		  JOIN %Table:SED% SED
		    ON SED.ED_FILIAL = %xFilial:SED%
		   AND SED.ED_CODIGO = SE1.E1_NATUREZ
		   AND SED.%NotDel%
		  JOIN %Table:SA1% SA1
		    ON SA1.A1_FILIAL = %xFilial:SA1%
		   AND SA1.A1_COD = SE1.E1_CLIENTE
		   AND SA1.A1_LOJA = SE1.E1_LOJA
		   AND SA1.%NotDel%
		 WHERE SE1.E1_FILIAL = %xFilial:SE1%
		   AND SE1.E1_PREFIXO BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
		   AND SE1.E1_TIPO BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12%		   
		   AND SE1.E1_TIPO NOT IN %Exp:cNotTpFdc%
		   AND SE1.E1_NUM BETWEEN %Exp:MV_PAR13% AND %Exp:MV_PAR14%
		   AND SE1.E1_NATUREZ BETWEEN %Exp:MV_PAR15% AND %Exp:MV_PAR16%
		   AND SE1.E1_CLIENTE BETWEEN %Exp:MV_PAR17% AND %Exp:MV_PAR19%
		   AND SE1.E1_LOJA BETWEEN %Exp:MV_PAR18% AND %Exp:MV_PAR20%
		   AND SE1.E1_EMISSAO BETWEEN %Exp:DtoS(MV_PAR21)% AND %Exp:DtoS(MV_PAR22)%
		   AND SE1.E1_VENCTO BETWEEN %Exp:DtoS(MV_PAR23)% AND %Exp:DtoS(MV_PAR24)%
		   AND SE1.E1_PORTADO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR04%
		   AND SE1.E1_AGEDEP BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR05%
		   AND SE1.E1_CONTA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR06%
		   AND SE1.E1_NUMBOR BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
		   AND SE1.E1_SALDO = SE1.E1_VALOR
		   AND SE1.R_E_C_N_O_ NOT IN (SELECT SE1b.E1_RECORI
		                                FROM %Table:SE1% SE1b
		                               WHERE SE1b.E1_FILIAL = %xFilial:SE1%
		                                 AND SE1b.E1_RECORI = SE1.R_E_C_N_O_
		                                 AND SE1b.%NotDel%)
		   AND SE1.%NotDel%
	EndSQL
	
	If !(cAliasQry)->(Eof())
		aHeader := {	'',;
						RetTitle('E1_FILIAL'),;
						RetTitle('E1_PREFIXO'),;
						RetTitle('E1_NUM'),;
						RetTitle('E1_NFELETR'),;
						"Valor Bruto",;
						"Valor Liquido",;
						RetTitle('E1_VENCTO'),;
						RetTitle('E1_VENCREA'),;
						RetTitle('E1_CLIENTE'),;
						RetTitle('E1_LOJA'),;
						RetTitle('A1_NOME'),;
						RetTitle('A1_NREDUZ'),;
						RetTitle('E1_PARCELA'),;
						RetTitle('E1_TIPO'),;
						RetTitle('E1_NUMBOR'),;
						RetTitle('E1_PORTADO'),;
						RetTitle('E1_AGEDEP'),;
						RetTitle('E1_CONTA'),;
						RetTitle('E1_NATUREZ'),;
						RetTitle('ED_DESCRIC'),;
						RetTitle('E1_EMISSAO')}
		
		bBlock := {|| AAdd(aTitulos, {	.F.,;						//--[01]
										(cAliasQry)->E1_FILIAL,;	//--[02]
										(cAliasQry)->E1_PREFIXO,;	//--[03]
										(cAliasQry)->E1_NUM,;		//--[04]
										(cAliasQry)->E1_NFELETR,;	//--[05]
										(cAliasQry)->E1_VALOR,;	    //--[06]
										(cAliasQry)->E1_LIQ,;	    //--[07]
										(cAliasQry)->E1_VENCTO,;	//--[08]
										(cAliasQry)->E1_VENCREA,;	//--[09]
										(cAliasQry)->E1_CLIENTE,;	//--[10]
										(cAliasQry)->E1_LOJA,;		//--[11]
										(cAliasQry)->A1_NOME,;		//--[12]
										(cAliasQry)->A1_NREDUZ,;	//--[13]
										(cAliasQry)->E1_PARCELA,;	//--[14]
										(cAliasQry)->E1_TIPO,;		//--[15]
										(cAliasQry)->E1_NUMBOR,;	//--[16]
										(cAliasQry)->E1_PORTADO,;	//--[17]
										(cAliasQry)->E1_AGEDEP,;	//--[18]
										(cAliasQry)->E1_CONTA,;		//--[19]
										(cAliasQry)->E1_NATUREZ,;	//--[20]
										(caliasQry)->ED_DESCRIC,;	//--[21]									
										(cAliasQry)->E1_EMISSAO,;	//--[22]										
										(cAliasQry)->SE1Recno })}	//--[23]
			
		(cAliasQry)->(DBEval(bBlock, {|| .T.}, {|| !Eof()}))
		(cAliasQry)->(DbCloseArea())

		// --------------------------
		// TRATA INTERFACE C/ USUARIO
		// --------------------------
		If Len(aTitulos) > 0
			DEFINE MSDialog oDlg Title 'Indique os Títulos para o processo de Operação/Depósito' From 000, 000 To 470, 800 Pixel
				oGrpBrowse := TGroup():New(045, 005, 200, 395, '', oDlg, CLR_BLUE,, .T.)
				oBrowse := TWBrowse():New(050, 010, 380, 140, NIL, aHeader, NIL, oDlg, NIL, NIL, NIL,,,,,,,,,, "ARRAY", .T.)

				oBrowse:SetArray(aTitulos)
				oBrowse:bLine := {|| {	If(aTitulos[oBrowse:nAT, 01], oOk, oNo),;								//--[01]MARCA
										aTitulos[oBrowse:nAT, 02],;												//--[02]FILIAL
										aTitulos[oBrowse:nAT, 03],;												//--[03]PREFIXO
										aTitulos[oBrowse:nAT, 04],;												//--[04]NUMERO DO TITULO
										aTitulos[oBrowse:nAT, 05],;												//--[04]NOTA
										Transform(aTitulos[oBrowse:nAT, 06], PesqPict('SE1', 'E1_VALOR')),;		//--[05]VALOR BRUTO
										Transform(aTitulos[oBrowse:nAT, 07], PesqPict('SE1', 'E1_VALOR')),;		//--[06]VALOR LIQUIDO										
										StoD(aTitulos[oBrowse:nAT, 08]),;										//--[08]VENCIMENTO
										StoD(aTitulos[oBrowse:nAT, 09]),;										//--[09]VENCIMENTO REAL
										aTitulos[oBrowse:nAT, 10],;												//--[10]CLIENTE
										aTitulos[oBrowse:nAT, 11],;												//--[11]LOJA
										aTitulos[oBrowse:nAT, 12],;												//--[12]RAZAO SOCIAL
										aTitulos[oBrowse:nAT, 13],;												//--[13]NOME FANTASIA
										aTitulos[oBrowse:nAT, 14],;												//--[14]PARCELA
										aTitulos[oBrowse:nAT, 15],;												//--[15]TIPO
										aTitulos[oBrowse:nAT, 16],;												//--[16]BORDERO
										aTitulos[oBrowse:nAT, 17],;												//--[17]PORTADOR (BANCO)
										aTitulos[oBrowse:nAT, 18],;												//--[18]AGENCIA
										aTitulos[oBrowse:nAT, 19],;												//--[19]CONTA
										aTitulos[oBrowse:nAT, 20],;												//--[20]NATUREZA
										aTitulos[oBrowse:nAT, 21],;												//--[21]DESCR. NATUREZA
										StoD(aTitulos[oBrowse:nAT, 22]);										//--[22]DATA DE EMISSAO
										 }}
									
				oBrowse:blDblClick := {|| aTitulos[oBrowse:nAt,1] := !aTitulos[oBrowse:nAt,1],; 
											If(aTitulos[oBrowse:nAt,1], nValSel += aTitulos[oBrowse:nAt, 07], nValSel -= aTitulos[oBrowse:nAt, 07]),;
											oGetValSel:Refresh(), oBrowse:Refresh() }

				oBrowse:bHeaderClick := {|| AEval(aTitulos, {|e| e[1] := !e[1], If(e[1], nValSel += e[07], nValSel -= e[07])}), oGetValSel:Refresh(), oBrowse:Refresh()}

				oGrpValSel := TGroup():New(205, 295, 230, 395, 'Valor Selecionado:', oDlg, CLR_BLUE,, .T.)
				oGetValSel := TGet():New(213, 300, {|u| If(PCount() > 0, nValSel := u, nValSel)}, oGrpValSel, 90, 10, PesqPict('SE1', 'E1_VALOR'),;
											{|| .T.},,,, .F.,, .T.,, .F., {|| .F. }, .F., .F.,, .F., .F.)

			ACTIVATE MSDialog oDlg On Init EnchoiceBar(oDlg, {|| lOk := .T., oDlg:End()}, {|| lOk := .F., oDlg:End()}) CENTER

			If lOk
				If AScan(aTitulos, {|x| x[1] == .T.}) > 0
					If MsgYesNo('Confirma a operação para os títulos selecionados?')
						Processa({|| GPPA10Proc(aTitulos)},, 'Aguarde, realizando processamento...')
					EndIf
				Else
					Help(,, 'GPPA10',, 'Não foram selecionados títulos para realização do processso. Processo cancelado...', 1, 0 )
				EndIf
			EndIf
		Else
			Help(,, 'GPPA10',, 'Não existem dados para os parâmetros informados! Verifique os parâmetros e tente novamente.', 1, 0 )
		EndIf
	Else
		Help(,, 'GPPA10',, 'Não existem dados para os parâmetros informados! Verifique os parâmetros e tente novamente.', 1, 0 )
	EndIf
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³GPPA10Proc  ³Autor  ³TOTVS Ibirapuera                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Funcao responsavel pelo processamento                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GPPA10Proc(aTitulos)
Local aDadosAuto  := {}
Local cTpRec     := SuperGetMV('ES_TPDESCR',, 'DP')		//--TIPO DOS TITULOS "DUBLES"
Local cPrefRec   := SuperGetMV('ES_PRDESCR',, '') 		//--PREFIXO DOS TITULOS "DUBLES"
Local cNatRec    := SuperGetMV('ES_NTDESCR',, '10100')	//--NATUREZA DOS TITULOS "DUBLES"
Local nCountA    := 0

ProcRegua(Len(aTitulos))
For nCountA := 1 To Len(aTitulos)
	If aTitulos[nCountA, 1]
		aDadosAuto := {	{'E1_TIPO'		, cTpRec						, NIL},;    
						{'E1_PREFIXO'	, cPrefRec						, NIL},;     
						{'E1_NUM'		, aTitulos[nCountA, 04]			, NIL},;
						{'E1_PARCELA'	, aTitulos[nCountA, 14]			, NIL},;   
						{'E1_NATUREZ'	, cNatRec						, NIL},;			
						{'E1_CLIENTE'	, aTitulos[nCountA, 10]			, NIL},;
						{'E1_LOJA'		, aTitulos[nCountA, 11]			, NIL},;
						{'E1_EMISSAO'	, StoD(aTitulos[nCountA, 22])	, NIL},;
						{'E1_VENCTO'	, StoD(aTitulos[nCountA, 08])	, NIL},;
						{'E1_VALOR'		, aTitulos[nCountA, 07]			, NIL},;
						{'E1_FLUXO'		, 'N'							, NIL},;
						{'E1_RECORI'	, aTitulos[nCountA, 23]			, NIL}}

		lMsErroAuto := .F.
		MSExecAuto({|x,y| FINA040(x, y)}, aDadosAuto, 3)   
		If lMsErroAuto
			Help(,, 'GPPA10Proc',, 'Não foi possível realizar a cópia do título para o processo de Operação/Depósito! Realize a inclusão do título manualmente. Título: ' + cTpRec + '/' + cPrefRec + '/' + aTitulos[nCountA, 03], 1, 0 )
			MostraErro()
		EndIf

	EndIf
	IncProc()
Next nCountA

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³GPPA10Tipos ³Autor  ³TOTVS Ibirapuera                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Retorna os tipos que nao devem ser considerados para filtro ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GPPA10Tipos()
Local cTipos    := ''

cTipos += MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVENVBCOR+"/"
cTipos += MVABATIM+"/"+MVIRABT+"/"+MVCSABT+"/"+MVCFABT+"/"+MVPIABT+"/"
cTipos := '%' + Formatin( strTran( strTran( Formatin(cTipos,"/"), "('", ""), "')", ""),"|") + '%'

Return(cTipos)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³GPPA10Calc  ³Autor  ³TOTVS Ibirapuera                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Funcao responsavel pelo calculo do valor "liquido" a ser    ³±±
±±³          ³considerado nas operacoes FIDC. Esta funcao devera estar    ³±±
±±³          ³amarrada a uma formula o Cadastro de Formulas (SM4)         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GPPA10Calc()
Local aTitulos    := {}
Local nCountA     := 0
Local lOk         := .F.
Local nRet        := 0
Local aButtons    := {}
Local aArea       := GetArea()
Local aAreaTRB    := {}
Local oDlg        := NIL
Local oGrpVOP     := NIL
Local oGetVOP     := NIL
Local nVOP        := 0
Local oGrpFloat   := NIL
Local oGetFloat   := NIL
Local nFloat      := 0
Local oGrpPrazo   := NIL
Local oGetPrazo   := NIL
Local nPrazo      := 0
Local oGrpPercFt  := NIL
Local oGetPercFt  := NIL
Local nPercFt     := 0
Local oGrpTAC     := NIL
Local oGetTAC     := NIL
Local nTAC        := 0
Local oGrpTitulo  := NIL
Local oGetTitulo  := NIL
Local nTitulo     := 0
Local oGrpTED     := NIL
Local oGetTED     := NIL
Local nTED        := 0
Local oGrpTerm    := NIL
Local oGetTerm    := NIL
Local nTerm       := 0
Local oGrpCons    := NIL
Local oGetCons    := NIL
Local nCons       := 0
Local oGrpOutrTrf := NIL
Local oGetOutrTrf := NIL
Local nOutrTrf    := 0
Local oGrpVlrFt   := NIL
Local oGetVlrFt   := NIL
Local nVlrFt      := 0
Local oGrpTarifas := NIL
Local oGetTarifas := NIL
Local nTarifas    := 0
Local oGrpLiquido := NIL
Local oGetLiquido := NIL
Local nLiquido    := 0

// -------------------------------------------
// TRATA OS VALORES PARA REALIZACAO DO CALCULO
// -------------------------------------------
If IsInCallStack('FA060Trans')
	AAdd(aTitulos, {SE1->E1_VALOR,;		//--[01]VALOR DO TITULO				
					SE1->E1_VENCTO,;	//--[02]VENCIMENTO
					CtoD(Space(08)),;	//--[03]FLOATING
					0,;					//--[04]DIAS PRAZO
					0})					//--[05]MEDIA DIAS x FLOATING

	nVOP := SE1->E1_VALOR

ElseIf IsInCallStack('FA060Borde')
	aAreaTRB := TRB->(GetArea())
	TRB->(DbGoTop())
	While !TRB->(Eof())
		If TRB->E1_OK == cMarca
			AAdd(aTitulos, {TRB->E1_VALOR,;			//--[01]VALOR DO TITULO				
							TRB->E1_VENCTO,;		//--[02]VENCIMENTO
							CtoD(Space(08)),;		//--[03]FLOATING
							0,;						//--[04]DIAS PRAZO
							0})						//--[05]MEDIA DIAS x FLOATING

			nVOP += TRB->E1_VALOR
		EndIf
		TRB->(DbSkip())
	End
	RestArea(aAreaTRB)
EndIf

// -------------------------------------------
// ACOES DA DIALOG
// -------------------------------------------
AAdd( aButtons, { '', {|| GPPA10AtuCalc(aTitulos, nFloat, @nPrazo, nPercFt, nTAC, @nTitulo, nTED, nTerm, nCons, @nVlrFt, nOutrTrf, @nTarifas, @nLiquido),; 
							GPPA10Refresh(@oGetPrazo, @oGetTitulo, @oGetVlrFt, @oGetTarifas, @oGetLiquido) }, 'Calcular' })

// ----------------------
// INTERFACE COM O USUARIO
// -----------------------
DEFINE MSDialog oDlg Title 'Memória de Cálculo' From 000, 000 To 465, 715 Pixel

	oGrpVOP := TGroup():New(040, 005, 065, 115, 'VOP', oDlg,,, .T.)
	oGetVOP := TGet():New(048, 010, {|u| If(PCount() > 0, nVOP := u, nVOP)}, oGrpVOP, 100, 010, PesqPict('SE1', 'E1_VALOR'),;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .F.}, .F., .F.,, .F., .F.,, 'nVOP')

	oGrpFloat := TGroup():New(040, 120, 065, 235, 'Floating', oDlg,,, .T.)
	oGetFloat := TGet():New(048, 125, {|u| If(PCount() > 0, nFloat := u, nFloat)}, oGrpFloat, 100, 010, '@e 999.99',;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .T.}, .F., .F.,, .F., .F.,, 'nFloat')

	oGrpPrazo := TGroup():New(040, 240, 065, 355, 'Prazo', oDlg,,, .T.)
	oGetPrazo := TGet():New(048, 245, {|u| If(PCount() > 0, nPrazo := u, nPrazo)}, oGrpPrazo, 100, 010, '@e 999',;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .F.}, .F., .F.,, .F., .F.,, 'nPrazo')

	oGrpPercFt := TGroup():New(070, 005, 095, 115, 'Fator', oDlg,,, .T.)
	oGetPercFt := TGet():New(078, 010, {|u| If(PCount() > 0, nPercFt := u, nPercFt)}, oGrpPercFt, 100, 010, '@e 999.99',;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .T.}, .F., .F.,, .F., .F.,, 'nPercFt')

	oGrpTAC := TGroup():New(070, 120, 095, 235, 'TAC', oDlg,,, .T.)
	oGetTAC := TGet():New(078, 125, {|u| If(PCount() > 0, nTAC := u, nTAC)}, oGrpTAC, 100, 010, PesqPict('SE1', 'E1_VALOR'),;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .T.}, .F., .F.,, .F., .F.,, 'nTAC')

	oGrpTitulo := TGroup():New(070, 240, 095, 355, 'Titulo', oDlg,,, .T.)
	oGetTitulo := TGet():New(078, 245, {|u| If(PCount() > 0, nTitulo := u, nTitulo)}, oGrpTitulo, 100, 010, PesqPict('SE1', 'E1_VALOR'),;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .F.}, .F., .F.,, .F., .F.,, 'nTitulo')

	oGrpTED := TGroup():New(100, 005, 125, 115, 'TED', oDlg,,, .T.)
	oGetTED := TGet():New(108, 010, {|u| If(PCount() > 0, nTED := u, nTED)}, oGrpTED, 100, 010, PesqPict('SE1', 'E1_VALOR'),;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .T.}, .F., .F.,, .F., .F.,, 'nTED')

	oGrpTerm := TGroup():New(100, 120, 125, 235, 'Termo Comprova', oDlg,,, .T.)
	oGetTerm:= TGet():New(108, 125, {|u| If(PCount() > 0, nTerm := u, nTerm)}, oGrpTerm, 100, 010, PesqPict('SE1', 'E1_VALOR'),;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .T.}, .F., .F.,, .F., .F.,, 'nTerm')

	oGrpCons := TGroup():New(100, 240, 125, 355, 'Consulta', oDlg,,, .T.)
	oGetCons:= TGet():New(108, 245, {|u| If(PCount() > 0, nCons := u, nCons)}, oGrpCons, 100, 010, PesqPict('SE1', 'E1_VALOR'),;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .T.}, .F., .F.,, .F., .F.,, 'nCons')

	oGrpVlrFt := TGroup():New(130, 005, 155, 115, 'Fator R$', oDlg,,, .T.)
	oGetVlrFt := TGet():New(138, 010, {|u| If(PCount() > 0, nVlrFt := u, nVlrFt)}, oGrpVlrFt, 100, 010, PesqPict('SE1', 'E1_VALOR'),;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .F.}, .F., .F.,, .F., .F.,, 'nVlrFt')

	oGrpOutrTrf := TGroup():New(130, 120, 155, 235, 'Outras Tarifas', oDlg,,, .T.)
	oGetOutrTrf := TGet():New(138, 125, {|u| If(PCount() > 0, nOutrTrf := u, nOutrTrf)}, oGrpOutrTrf, 100, 010, PesqPict('SE1', 'E1_VALOR'),;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .T.}, .F., .F.,, .F., .F.,, 'nOutrTrf')

	oGrpTarifas := TGroup():New(130, 240, 155, 355, 'Tarifas', oDlg,,, .T.)
	oGetTarifas := TGet():New(138, 245, {|u| If(PCount() > 0, nTarifas := u, nTarifas)}, oGrpTarifas, 100, 010, PesqPict('SE1', 'E1_VALOR'),;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -12, .F., .T.), .F.,, .T.,, .F., {|| .F.}, .F., .F.,, .F., .F.,, 'nTarifas')

	oGrpLiquido := TGroup():New(170, 120, 195, 235, 'Liquido a Pagar', oDlg, CLR_BLUE,, .T.)
	oGetLiquido := TGet():New(178, 125, {|u| If(PCount() > 0, nLiquido := u, nLiquido)}, oGrpLiquido, 100, 010, PesqPict('SE1', 'E1_VALOR'),;
								{|| .T.}, CLR_BLUE,, TFont():New('Courier New', 0, -14, .T., .T.), .F.,, .T.,, .F., {|| .F.}, .F., .F.,, .F., .F.,, 'nLiquido')


ACTIVATE MSDialog oDlg On Init EnchoiceBar(oDlg, {|| lOk := .T., oDlg:End()}, {|| lOk := .F., oDlg:End()},, aButtons) CENTER

// -------------------------
// GATILHA VALOR P/ OPERACAO
// -------------------------
If lOk
	GPPA10AtuCalc(aTitulos, nFloat, @nPrazo, nPercFt, nTAC, @nTitulo, nTED, nTerm, nCons, @nVlrFt, nOutrTrf, @nTarifas, @nLiquido)
	nRet := nLiquido
Else
	nRet := nVOP
EndIf


//--Restaura Ambiente:
RestArea(aArea)

Return(nRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³GPPA10AtuCalc ³Autor  ³TOTVS Ibirapuera                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Processa o calculo de acordo com as informacoes inseridas   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GPPA10AtuCalc(aTitulos, nFloat, nPrazo, nPercFt, nTAC, nTitulo, nTED, nTerm, nCons, nVlrFt, nOutrTrf, nTarifas, nLiquido)

Local nCountA     := 0
Local nValTitulos := 0
Local nValMedia   := 0

// -----------------------------
// CALCULA O FLOATING POR TITULO
// -----------------------------
For nCountA := 1 To Len(aTitulos)

	If Dow(aTitulos[nCountA, 2] + nFloat) == 1 //--DOMINGO
		aTitulos[nCountA, 3] := aTitulos[nCountA, 2] + nFloat + 1  
	ElseIf Dow(aTitulos[nCountA, 2] + nFloat) == 7 //--SABADO
		aTitulos[nCountA, 3] := aTitulos[nCountA, 2] + nFloat + 2
	Else
		aTitulos[nCountA, 3] := aTitulos[nCountA, 2] + nFloat
	EndIf

	//--Calcula o No de Dias com base no Floating
	aTitulos[nCountA, 4] := aTitulos[nCountA, 3] - dDataMov
	aTitulos[nCountA, 5] := Round(aTitulos[nCountA, 4] * aTitulos[nCountA, 1], 2)

	//--Acumula Totais p/ os demais calculos
	nValTitulos += aTitulos[nCountA, 1]
	nValMedia   += aTitulos[nCountA, 5]

Next nCountA

// -------------
// OBTEM O PRAZO 
// -------------
nPrazo := Round(nValMedia / nValTitulos, 2)

// -------------------------
// CALCULA O VALOR P/ TITULO
// -------------------------
nTitulo := Len(aTitulos) * 5.5

// ---------------
// CALCULA O FATOR
// ---------------
nVlrFt := (((nPercFt/100)/30)*nPrazo*nValTitulos)

// ----------------
// OBTEM AS TARIFAS
// ----------------
nTarifas := (nTAC + nTitulo + nTED + nTerm + nCons + nOutrTrf)

// -------------------
// APURA VALOR LIQUIDO
// -------------------
nLiquido := nValTitulos - nVlrFt - nTarifas


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³GPPA10Refresh ³Autor  ³TOTVS Ibirapuera                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Forca refresh nos objetos Get                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GPPA10Refresh(oGetPrazo, oGetTitulo, oGetVlrFt, oGetTarifas, oGetLiquido)

oGetPrazo:Refresh()
oGetTitulo:Refresh()
oGetVlrFt:Refresh()
oGetTarifas:Refresh()
oGetLiquido:Refresh()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³GPPA10Contr   ³Autor  ³TOTVS Ibirapuera                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Atualiza informacoes do contrato nos titulos a receber      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GPPA010Contr()
Local aParams  := {}
Local aArea    := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSE9 := SE9->(GetArea())

AAdd(aParams, {1, 'Bordero'			, CriaVar('E1_NUMBOR', .F.)		, PesqPict('SE1', 'E1_NUMBOR')	, 'ExistCpo("SE1", MV_PAR01, 5)', ''	,, 30, .F.})
AAdd(aParams, {1, 'No. do Contrato'	, CriaVar('E1_CONTRAT', .F.)	, PesqPict('SE1', 'E1_CONTRAT')	, 'ExistCpo("SE9", MV_PAR02, 1)', 'SE9',, 75, .F.})
If ParamBox(aParams, 'Parâmetros') .And. MsgYesNo('Confirma atribuição do contrato em questão para o borderô informado?')
	SE1->(DbSetOrder(5)) //--E1_FILIAL+E1_NUMBOR+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If SE1->(DbSeek(xFilial('SE1')+MV_PAR01))
		SE9->(DbSetOrder(1)) //--E9_FILIAL+E9_NUMERO+E9_BANCO+E9_AGENCIA
		If SE9->(DbSeek(xFilial('SE9')+MV_PAR02+SE1->(E1_PORTADO+E1_AGEDEP)))
			While SE1->(E1_FILIAL+E1_NUMBOR) == xFilial('SE1')+MV_PAR01 .And. !SE1->(Eof())
				RecLock('SE1', .F.)
				SE1->E1_CONTRAT := MV_PAR02
				SE1->(MsUnLock())
				SE1->(DbSkip())
			End
			MsgInfo('Processo realizado com sucesso!')
		Else
			Help(,, 'GPPA10Contr',, 'Contrato não encontrado ou o contrato informado não está amarrado ao banco/agência vinculado ao borderô!', 1, 0 )		
		EndIf
	EndIf
EndIf
	
//-- Restaura ambiente:
RestArea(aArea)
RestArea(aAreaSE1)
RestArea(aAreaSE9)

Return