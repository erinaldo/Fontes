#INCLUDE "rwmake.ch"
#DEFINE _EOL chr(13) + chr(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA22   º Autor ³ Andy Pudja         º Data ³  12/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rateio e Contabilizacao de CNI                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE - Financeiro                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CFINA22(_cFunName)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cVldAlt := ".T."   // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local _cVldExc := ".T."   // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private _cString := "SZ8", _bFiltraBrw, _aIndex := {}, _cFiltro
Private aRotina, cCadastro
Private _cAntCon :=space(10)
Private _cAntNat :=space(10)
Private _cAntRMU :=space(01)

SZ8->(dbSetOrder(2))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRotina := {;
  {"Pesquisar"      , "AxPesqui"       ,  0, 1},;
  {"Visualizar"     , "U_cfina22a(2)"  ,  0, 2},;
  {"Rateio"         , "U_cfina22a(6)"  ,  0, 4},;
  {"Cancelar Rateio", "U_cfina22a(7)"  ,  0, 5},;
  {"Relatorio"      , "U_CFINR012"     ,  0, 6},;
  {"Alterar Rateio" , "U_cfina22a(4)"  ,  0, 7},;
  {"Legenda"        , "U_cfina22a(999)",  0, 8}}

//{"Estornar"       , "U_EstSZF"       ,  0, 7},;

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exibe a tela de cadastro.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCadastro := "Cadastro de CNI"
mBrowse(06, 01, 22, 75, _cString,,,,,, Legenda(0))

// Limpa o filtro do cadastro de contas a pagar.
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA22   ºAutor  ³ Felipe Raposo      º Data ³  12/03/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CFINA22a(_nOpc)
// _nOpc
// 1 - Pesquisar
// 2 - Visual
// 3 - Incluir
// 4 - Alterar
// 5 - Excluir
// 6 - Legenda
// Os registros "SZF" em SX3 com o campo X3_PROPRI=="L" sairão no Acols
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lRet := .T., _aCpos, _cMsg, _aArea, _aAreaZ8, _aAreaX3, _aAreaZF
Local _aAux1, _nAux1, _nAux2, _aDel
Local _cNumTit, _cNum, _cFornece, _cLoja, _nDif, _nTotPrest
Local _cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk, _cValid
Local _nOpcE, _nOpcG, _cFieldOk, _cVirtual, _nLinhas, _aAltEnch
Local _nCPMFAliq := 0.38  // Aliquota de CPMF.
Private aCols, aHeader
Private _nItem := 1
Private _nOpcao := _nOpc
Private LVISUAL := (_nOpc == 2)
Private LINCLUI := (_nOpc == 3)
Private LALTERA := (_nOpc == 4)
Private LEXCLUI := (_nOpc == 5)

// Campos que serao exibidos na tela.
_aCpos := {"Z8_BANCO", "Z8_AGENCIA", "Z8_CONTA", "Z8_EMISSAO", "Z8_CCONT", "Z8_VALOR"}

// Armazena o posicionamento do alias SE2 antes de processa-lo.
_aAreaZ8 := SZ8->(GetArea())

Do Case
	Case _nOpc == 1  // Pesquisar
		//Nao faz nada.
		
	Case _nOpc == 2  // Visualizar.
		If Empty(Z8_RATEIO)
			// Exibe o titulo adiantado.
			_lRet := (AxVisual(_cString, &(_cString)->(RecNo()), _nOpc, _aCpos) == 1)
		Else
			// Exibe o titulo com a prestacao de contas.
			_cTitulo  := "Rateio do CNI- Visualizar"
			_cAlias1  := _cString         // Alias da enchoice.
			_cAlias2  := "SZF"            // Alias da GetDados.
			_aMyEncho := _aCpos           // Campos da Enchoice.
			_cFieldOk := "AllwaysTrue()"  // Valida cada campo da GetDados.
			_cLinOk   := "AllwaysTrue()"  // Valida a linha.
			_cTudoOk  := "AllwaysTrue()"  // Valida toda a GetDados.
			_nOpcE    := 2                // Opcao da Enchoice.
			_nOpcG    := 2                // Opcao da GetDados.
			_cVirtual := ".T."            // Exibe os campos virtuais na GetDados.
			_nLinhas  := 99               // Numero maximo de linhas na GetDados.
			_aAltEnch := nil              // Campos alteraveis na Enchoice (nil = todos).
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria variaveis M->????? da Enchoice.                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RegToMemory(_cAlias1, .F.)
			
			// Monta a aHeader.
			aHeader := {}
			_aArea := SX3->(GetArea())
			SX3->(dbSetOrder(1))  // X3_ARQUIVO+X3_ORDEM.
			SX3->(dbSeek(_cAlias2))
			Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == _cAlias2)
				If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. X3_PROPRI=="L")
					aAdd(aHeader, {TRIM(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE,;
					SX3->X3_TAMANHO, SX3->X3_DECIMAL, "AllwaysTrue()", SX3->X3_USADO,;
					SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT})
				Endif
				SX3->(dbSkip())
			EndDo
			SX3->(RestArea(_aArea))
			
			// Monta a aCols com os itens do SZF.
			aCols := {}
			_aAreaZF := SZF->(GetArea())
			_aAreaX3 := SX3->(GetArea())
			SX3->(dbSetOrder(2))  // X3_CAMPO.
			SZF->(dbSetOrder(1))  // ZF_FILIAL+ZF_NUM.
			SZF->(dbSeek(xFilial("SZF") + SZ8->Z8_BANCO+SZ8->Z8_AGENCIA+SZ8->Z8_CONTA+DTOS(SZ8->Z8_EMISSAO)+SZ8->Z8_REGISTR, .F.))  // +StrZero(SZ8->(RECNO()),15), .F.))
			Do While SZF->(ZF_FILIAL+ZF_BANCO+ZF_AGENCIA+ZF_CONTA+DTOS(ZF_EMISSAO)+ZF_REGISTR) == xFilial("SZ8")+SZ8->Z8_BANCO+SZ8->Z8_AGENCIA+SZ8->Z8_CONTA+DTOS(SZ8->Z8_EMISSAO)+SZ8->Z8_REGISTR //+StrZero(SZ8->(RECNO()),15), .F.))
			   
			    If SZF->ZF_RDR <> SZ8->Z8_RDR
				   SZF->(dbSkip())
				   Loop
                EndIf  

				_aAux1 := {}
				For _nAux1 := 1 to len(aHeader)
					SX3->(dbSeek(aHeader[_nAux1, 2]))
					If SX3->X3_CONTEXT == "V"
						aAdd(_aAux1, &(SX3->X3_RELACAO))
					Else
						aAdd(_aAux1, SZF->(&(aHeader[_nAux1, 2])))
					Endif
				Next _nAux1
				aAdd(_aAux1, .F.)
				aAdd(aCols, _aAux1)
				SZF->(dbSkip())
			EndDo
			SX3->(RestArea(_aAreaX3))
			SZF->(RestArea(_aAreaZF))

		
			// Exibe a tela de modelo 3.
			_lRet := Modelo3(_cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk,;
							_nOpcE, _nOpcG, _cFieldOk, &(_cVirtual), _nLinhas, _aAltEnch)
		Endif

	Case _nOpc == 4  // Alterar Rateio
			// Trata os erros.
		If Empty(Z8_RDR)       // Fechado
			_cMsg := "Não houve informe de RDR nesse lançamento "
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
		
/*		If Empty(Z8_RATEIO)
			// Exibe o titulo adiantado.
			_lRet := (AxAltera(_cString, &(_cString)->(RecNo()), _nOpc, _aCpos) == 1)
		Else
*/
		If !Empty(Z8_FECRAT)   // Fechado Rateio
			_cMsg := "Já houve FECHAMENTO DE RATEIO desse lançamento "
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif

		// Exibe o titulo com a prestacao de contas.
		_cTitulo  := "Rateio do CNI- Visualizar"
		_cAlias1  := _cString         // Alias da enchoice.
		_cAlias2  := "SZF"            // Alias da GetDados.
		_aMyEncho := _aCpos           // Campos da Enchoice.

		_cFieldOk := "U_cfina22b(1)"  // Valida cada campo da GetDados.
		_cLinOk   := "U_cfina22b(2)"  // Valida a linha.
		_cTudoOk  := "U_cfina22b(3)"  // Valida toda a GetDados.
		_nOpcE    := 2                // Opcao da Enchoice.
		_nOpcG    := 3                // Opcao da GetDados.
		_cVirtual := ".T."            // Exibe os campos virtuais na GetDados.
		_nLinhas  := 99               // Numero maximo de linhas na GetDados.
		_aAltEnch := nil              // Campos alteraveis na Enchoice (nil = todos).
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria variaveis M->????? da Enchoice.                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RegToMemory(_cAlias1, .F.)
		
		// Monta a aHeader.
		aHeader := {}
		_aArea := SX3->(GetArea())
		SX3->(dbSetOrder(1))  // X3_ARQUIVO+X3_ORDEM.
		SX3->(dbSeek(_cAlias2))
		Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == _cAlias2)
			If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. X3_PROPRI=="L")
				aAdd(aHeader, {TRIM(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE,;
				SX3->X3_TAMANHO, SX3->X3_DECIMAL, "AllwaysTrue()", SX3->X3_USADO,;
				SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT})
			Endif
			SX3->(dbSkip())
		EndDo
		SX3->(RestArea(_aArea))
		
		// Monta a aCols com os itens do SZF.
		aCols := {}
		_aAreaZF := SZF->(GetArea())
		_aAreaX3 := SX3->(GetArea())
		SX3->(dbSetOrder(2))  // X3_CAMPO.
		SZF->(dbSetOrder(1))  // ZF_FILIAL+ZF_NUM.
		SZF->(dbSeek(xFilial("SZF") + SZ8->Z8_BANCO+SZ8->Z8_AGENCIA+SZ8->Z8_CONTA+DTOS(SZ8->Z8_EMISSAO)+SZ8->Z8_REGISTR, .F.))  // +StrZero(SZ8->(RECNO()),15), .F.))
		Do While SZF->(ZF_FILIAL+ZF_BANCO+ZF_AGENCIA+ZF_CONTA+DTOS(ZF_EMISSAO)+ZF_REGISTR) == xFilial("SZ8")+SZ8->Z8_BANCO+SZ8->Z8_AGENCIA+SZ8->Z8_CONTA+DTOS(SZ8->Z8_EMISSAO)+SZ8->Z8_REGISTR //+StrZero(SZ8->(RECNO()),15), .F.))
		   
		    If SZF->ZF_RDR <> SZ8->Z8_RDR
			   SZF->(dbSkip())
			   Loop
               EndIf  
				_aAux1 := {}
			For _nAux1 := 1 to len(aHeader)
				SX3->(dbSeek(aHeader[_nAux1, 2]))
				If SX3->X3_CONTEXT == "V"
					aAdd(_aAux1, &(SX3->X3_RELACAO))
				Else
					aAdd(_aAux1, SZF->(&(aHeader[_nAux1, 2])))
				Endif
			Next _nAux1
			aAdd(_aAux1, .F.)
			aAdd(aCols, _aAux1)
			SZF->(dbSkip())
		EndDo
		SX3->(RestArea(_aAreaX3))
		SZF->(RestArea(_aAreaZF))
		
		// Exibe a tela de modelo 3.
		_lRet := Modelo3(_cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk,;
						_nOpcE, _nOpcG, _cFieldOk, &(_cVirtual), _nLinhas, _aAltEnch)
		If _lRet  // Usuario confirmou a operacao.
			Begin Transaction
			SZF->(dbSetOrder(1))
			SZF->(dbSeek(xFilial("SZF") + SZ8->Z8_BANCO+SZ8->Z8_AGENCIA+SZ8->Z8_CONTA+DTOS(SZ8->Z8_EMISSAO)+SZ8->Z8_REGISTR, .F.))
			// Grava os itens da prestacao de contas (SZF).
			_nTotPrest := 0
			For _nAux1 := 1 to len(aCols)
				// Varre todos os itens.
				SZF->(dbSetOrder(4))
				If SZF->(dbSeek(xFilial("SZF") + SZ8->Z8_BANCO+SZ8->Z8_AGENCIA+SZ8->Z8_CONTA+DTOS(SZ8->Z8_EMISSAO)+SZ8->Z8_REGISTR+aCols[_nAux1,1], .F.))
					If !aCols[_nAux1, len(aHeader) + 1]
						RecLock("SZF", .F.)
						SZF->ZF_FILIAL  := xFilial("SZF")
						SZF->ZF_BANCO   := SZ8->Z8_BANCO
						SZF->ZF_AGENCIA := SZ8->Z8_AGENCIA
						SZF->ZF_CONTA   := SZ8->Z8_CONTA
						SZF->ZF_EMISSAO := SZ8->Z8_EMISSAO
						SZF->ZF_REGISTR := SZ8->Z8_REGISTR
						SZF->ZF_RDR     := SZ8->Z8_RDR
						For _nAux2 := 1 to len(aHeader)
							SZF->(&(aHeader[_nAux2, 2])) := aCols[_nAux1, _nAux2]
						Next _nAux2
						SZF->(msUnLock())
						_cAntCon :=aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_CCONTA"})]
						_cAntNat :=aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_NATUREZ"})]
						_cAntRMU :=aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_RMU"})]
					Else
						RecLock("SZF", .F.)
						SZF->(dbDelete())
						SZF->(msUnLock())
					Endif
				Else
					If !aCols[_nAux1, len(aHeader) + 1]
						RecLock("SZF", .T.)
						SZF->ZF_FILIAL  := xFilial("SZF")
						SZF->ZF_BANCO   := SZ8->Z8_BANCO
						SZF->ZF_AGENCIA := SZ8->Z8_AGENCIA
						SZF->ZF_CONTA   := SZ8->Z8_CONTA
						SZF->ZF_EMISSAO := SZ8->Z8_EMISSAO
						SZF->ZF_REGISTR := SZ8->Z8_REGISTR
						SZF->ZF_RDR     := SZ8->Z8_RDR
						For _nAux2 := 1 to len(aHeader)
							SZF->(&(aHeader[_nAux2, 2])) := aCols[_nAux1, _nAux2]
						Next _nAux2
						SZF->(msUnLock())
						_cAntCon :=aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_CCONTA"})]
						_cAntNat :=aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_NATUREZ"})]
						_cAntRMU :=aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_RMU"})]
					Endif
				EndIf
			Next _nAux1
		
			End Transaction
		Endif
				
	Case _nOpc == 6  // Prestar conta.
		
		// Trata os erros.
		If Empty(Z8_RDR)       // Fechado
			_cMsg := "Não houve informe de RDR nesse lançamento "
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
		
		If !Empty(Z8_RATEIO)   // Baixado
			_cMsg := "Já houve RATEIO desse lançamento "
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
      
		If Empty(Z8_FECHA)   // Não Fechado CNI
			_cMsg := "NÃO FECHAMENTO CNI desse lançamento "
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
		
		If !Empty(Z8_FECRAT)   // Fechado Rateio
			_cMsg := "Já houve FECHAMENTO DE RATEIO desse lançamento "
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
		
		_cTitulo  := "Rateio - CNI"
		_cAlias1  := _cString         // Alias da enchoice.
		_cAlias2  := "SZF"            // Alias da GetDados.
		_aMyEncho := _aCpos           // Campos da Enchoice.
		_cFieldOk := "U_cfina22b(1)"  // Valida cada campo da GetDados.
		_cLinOk   := "U_cfina22b(2)"  // Valida a linha.
		_cTudoOk  := "U_cfina22b(3)"  // Valida toda a GetDados.
		_nOpcE    := 2                // Opcao da Enchoice.
		_nOpcG    := 3                // Opcao da GetDados.
		_cVirtual := ".T."            // Exibe os campos virtuais na GetDados.
		_nLinhas  := 99               // Numero maximo de linhas na GetDados.
		_aAltEnch := nil              // Campos alteraveis na Enchoice (nil = todos).
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria variaveis M->????? da Enchoice.                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RegToMemory(_cAlias1, .F.)
		
		// Monta a aHeader.
		aHeader := {}
		_aArea := SX3->(GetArea())
		SX3->(dbSetOrder(1))  // X3_ARQUIVO+X3_ORDEM.
		SX3->(dbSeek(_cAlias2))
		Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == _cAlias2)
			If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. SX3->X3_PROPRI=="L")
				_cValid := IIf (!empty(SX3->X3_VALID), SX3->X3_VALID, "")
				_cValid += IIf (!empty(_cValid) .and. !empty(SX3->X3_VLDUSER), ".and." , "")
				_cValid += IIf (!empty(SX3->X3_VLDUSER), SX3->X3_VLDUSER, "")
				_cValid := IIf (empty(_cValid), "AllwaysTrue()", _cValid)
				
				aAdd(aHeader, {TRIM(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE,;
				SX3->X3_TAMANHO, SX3->X3_DECIMAL, _cValid, SX3->X3_USADO,;
				SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT})
			Endif
			SX3->(dbSkip())
		EndDo
		
		// Monta a aCols em branco.
		SX3->(dbSetOrder(2))  // X3_CAMPO.
		aCols := {Array(len(aHeader) + 1)}
		For _nAux1 := 1 to len(aHeader)
			aCols[1, _nAux1] :=;
			IIf (SX3->(dbSeek(aHeader[_nAux1, 2])) .and. !empty(SX3->X3_RELACAO),;
			&(SX3->X3_RELACAO), CriaVar(aHeader[_nAux1, 2]))
		Next _nAux1
		
		aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_ITEM"})]    := "01"
		aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_VALOR"})]   := SZ8->Z8_VALOR
		aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_CCONTA"})]  := _cAntCon
		aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_NATUREZ"})] := _cAntNat
		aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_RMU"})]     := _cAntRMU				

		aCols[1, len(aHeader) + 1] := .F.
		SX3->(RestArea(_aArea))
		
		// Exibe a tela de modelo 3.
		_lRet := Modelo3(_cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk,;
						_nOpcE, _nOpcG, _cFieldOk, &(_cVirtual), _nLinhas, _aAltEnch)
		If _lRet  // Usuario confirmou a operacao.
			Begin Transaction
			
			// Marca o titulo (adiantamento) como conta prestada e
			// o tira do fluxo de caixa.
			RecLock("SZ8", .F.)
			SZ8->Z8_RATEIO  := "S"
			SZ8->(msUnLock())
			
			// Grava os itens da prestacao de contas (SZF).
			_nTotPrest := 0
			For _nAux1 := 1 to len(aCols)
				// Varre todos os itens.
				If !aCols[_nAux1, len(aHeader) + 1]
					RecLock("SZF", .T.)
					SZF->ZF_FILIAL  := xFilial("SZF")
					SZF->ZF_BANCO   := SZ8->Z8_BANCO
					SZF->ZF_AGENCIA := SZ8->Z8_AGENCIA
					SZF->ZF_CONTA   := SZ8->Z8_CONTA
					SZF->ZF_EMISSAO := SZ8->Z8_EMISSAO
					SZF->ZF_REGISTR := SZ8->Z8_REGISTR // StrZero(SZ8->(RECNO()),15)
					SZF->ZF_RDR     := SZ8->Z8_RDR
					
					For _nAux2 := 1 to len(aHeader)
						SZF->(&(aHeader[_nAux2, 2])) := aCols[_nAux1, _nAux2]
					Next _nAux2
					
					SZF->(msUnLock())
					_cAntCon :=aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_CCONTA"})]
					_cAntNat :=aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_NATUREZ"})]
					_cAntRMU :=aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_RMU"})]										
				Endif
			Next _nAux1
			
			
			End Transaction
		Endif
		
	Case _nOpc == 7  // Cancelar prestacao.
		
		// Trata os erros.
		If Empty(SZ8->Z8_RATEIO)   // Baixado
			_cMsg := "Não houve  RATEIO  desse lançamento para ser cancelado!"
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
		
		If !Empty(SZ8->Z8_FECRAT)   // Fechado
			_cMsg := "Já houve FECHAMENTO desse lançamento para ser cancelado!"
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
		
		
		_lRet := U_cfina22a(2)
		If _lRet  // Usuario confirmou a operacao.
			Begin Transaction
			
			// Desmarca o titulo (adiantamento) como conta prestada e
			// o coloca de volta no fluxo de caixa.
			RecLock("SZ8", .F.)
			SZ8->Z8_RATEIO := " "
			SZ8->(msUnLock())
			
			// Apaga os itens da prestacao de contas (SZ4).
			_aDel := {}
			SZF->(dbSetOrder(1))
			SZF->(dbSeek(xFilial("SZF") + SZ8->Z8_BANCO+SZ8->Z8_AGENCIA+SZ8->Z8_CONTA+DTOS(SZ8->Z8_EMISSAO)+SZ8->Z8_REGISTR), .F.) //+StrZero(SZ8->(RECNO()),15), .F.))
			Do While SZF->(ZF_FILIAL+ZF_BANCO+ZF_AGENCIA+ZF_CONTA+DTOS(ZF_EMISSAO)+ZF_REGISTR) == xFilial("SZ4")+SZ8->Z8_BANCO+SZ8->Z8_AGENCIA+SZ8->Z8_CONTA+DTOS(SZ8->Z8_EMISSAO)+SZ8->Z8_REGISTR // +StrZero(SZ8->(RECNO()),15)
				aAdd(_aDel, SZF->(RecNo()))
				SZF->(dbSkip())
			EndDo
			
			For _nAux1 := 1 to len(_aDel)
				SZF->(dbGoTo(_aDel[_nAux1]))
				RecLock("SZF", .F.)
				SZF->(dbDelete())
				SZF->(msUnLock())
			Next _nAux1
			
			
			End Transaction
		Endif
		
	Case _nOpc == 999  // Legenda.
		Legenda()
		
	OtherWise
EndCase

// Retorna o posicionamento do alias SE2.
SZ8->(RestArea(_aAreaZ8))
Return(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA22b  ºAutor  ³Microsiga           º Data ³  03/17/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a digitacao do usuario na GetDados.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ _nOpc:                                                     º±±
±±º          ³ 1 - Para validar cada campo.                               º±±
±±º          ³ 2 - Para validar a linha.                                  º±±
±±º          ³ 3 - Para validar a aCols inteira.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ .T. - Validacao ok.                                        º±±
±±ºesperado  ³ .F. - Nao validado.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function cfina22b(_nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lRet := .F.
Local _nAux1
Local _nPsItem  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_ITEM"  })
Local _nPsConta := aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_CCONTA"})
Local _nPsCusto := aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_CCUSTO"})
Local _nPsValor := aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_VALOR" })
Local _nPsDC    := aScan(aHeader, {|x| AllTrim(x[2]) == "ZF_DC"    })

Do Case
	Case _nOpc == 1  // Valida o campo.
		_lRet := .T.
	Case _nOpc == 2  // Valida a linha.
		If (_lRet := aCols[n, len(aHeader) + 1] .or. !( Empty(aCols[n, _nPsConta]) .or. Empty(aCols[n, _nPsValor]) ))
			_nItem := val(aCols[len(aCols), _nPsItem]) + 1
		Else
			_cMsg := "Preencha todos os campos!"
			MsgAlert(_cMsg, "Atenção")
		Endif
	Case _nOpc == 3  // Valida a aCols.
		If (_lRet := U_cfina22b(2))
			// Conta o total dos itens da prestacao de contas.
			_nTotal := 0
			For _nAux1 := 1 to len(aCols)
				If !aCols[_nAux1, len(aHeader) + 1]
					If aCols[_nAux1, _nPsDC] == "D"
						_nTotal -= aCols[_nAux1, _nPsValor]
					Else
						_nTotal += aCols[_nAux1, _nPsValor]
					EndIf
				Endif
			Next _nAux1
			
			If M->Z8_VALOR <> _nTotal
				_cMsg := "O valor total do rateio (" +;
				AllTrim(Transform(_nTotal, tm(_nTotal, 14))) +;
				") não bate com o valor do crédito (" +;
				AllTrim(Transform(M->Z8_VALOR, tm(M->Z8_VALOR, 14))) + ")." + _EOL
				_lRet := .F.
				MsgAlert(_cMsg, "Atenção")
			Endif
		EndIf
EndCase

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Legenda   ºAutor  ³ Andy               º Data ³  12/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exibe a legenda ou retorna a matriz referente a legenda    º±±
±±º          ³ para a mBrowse.                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ _uPar:                                                     º±±
±±º          ³      0 - Retorna a matriz.                                 º±±
±±º          ³    nil - Exibe a legenda na tela.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Legenda(_uPar)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _uRet, _aFlag

_aLeg := {;
{"BR_VERDE"   ,  "Sem Rateio"},;
{"BR_AMARELO" ,  "Com Rateio"},;
{"BR_VERMELHO",  "Com Rateio  e Fechamento"}}

If ValType(_uPar) != "U" .and. _uPar == 0
	_aFlag := {;
	{'!Empty(Z8_FECRAT)', _aLeg[3][1]},;  // Vermelho.
	{'!Empty(Z8_RATEIO)', _aLeg[2][1]},;  // Amarelo.
	{' Empty(Z8_RATEIO)', _aLeg[1][1]}}   // Verde.
	_uRet := _aFlag
Else
	BrwLegenda(cCadastro, "Legenda", _aLeg)
Endif
Return (_uRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA22   ºAutor  ³Microsiga           º Data ³  03/28/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EstSZF
If AllTrim(SubStr(cUsuario,7,11)) $ "Siga/Cristiano/Luis Carlos/Adilson"
	RecLock("SZ8", .F.)
	SZ8->Z8_FECRAT := ctod("  /  /  ")
	msUnLock()
EndIf
Return