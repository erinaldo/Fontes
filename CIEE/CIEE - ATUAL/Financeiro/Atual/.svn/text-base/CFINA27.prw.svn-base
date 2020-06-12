#INCLUDE "rwmake.ch"
#Include "COLORS.CH"
#Include "FONT.CH"


User Function CFINA27()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Cadastro de . . ."
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array (tambem deve ser aRotina sempre) com as definicoes das opcoes ³
//³ que apareceram disponiveis para o usuario. Segue o padrao:          ³
//³ aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ³
//³              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ³
//³              . . .                                                  ³
//³              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      ³
//³ Onde: <DESCRICAO> - Descricao da opcao do menu                      ³
//³       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  ³
//³                     duplas e pode ser uma das funcoes pre-definidas ³
//³                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA ³
//³                     e AXDELETA) ou a chamada de um EXECBLOCK.       ³
//³                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-³
//³                     clarar uma variavel chamada CDELFUNC contendo   ³
//³                     uma expressao logica que define se o usuario po-³
//³                     dera ou nao excluir o registro, por exemplo:    ³
//³                     cDelFunc := 'ExecBlock("TESTE")'  ou            ³
//³                     cDelFunc := ".T."                               ³
//³                     Note que ao se utilizar chamada de EXECBLOCKs,  ³
//³                     as aspas simples devem estar SEMPRE por fora da ³
//³                     sintaxe.                                        ³
//³       <TIPO>      - Identifica o tipo de rotina que sera executada. ³
//³                     Por exemplo, 1 identifica que sera uma rotina de³
//³                     pesquisa, portando alteracoes nao podem ser efe-³
//³                     tuadas. 3 indica que a rotina e de inclusao, por³
//³                     tanto, a rotina sera chamada continuamente ao   ³
//³                     final do processamento, ate o pressionamento de ³
//³                     <ESC>. Geralmente ao se usar uma chamada de     ³
//³                     EXECBLOCK, usa-se o tipo 4, de alteracao.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aRotina padrao. Utilizando a declaracao a seguir, a execucao da     ³
//³ MBROWSE sera identica a da AXCADASTRO:                              ³
//³                                                                     ³
//³ cDelFunc  := ".T."                                                  ³
//³ aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               ³
//³                { "Visualizar"   ,"AxVisual" , 0, 2},;               ³
//³                { "Incluir"      ,"AxInclui" , 0, 3},;               ³
//³                { "Alterar"      ,"AxAltera" , 0, 4},;               ³
//³                { "Excluir"      ,"AxDeleta" , 0, 5} }               ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","U_CFINA27A(2)",0,2} ,;
{"Incluir","U_CFINA27A(3)",0,4} ,;
{"Alterar","U_CFINA27A(4)",0,4} ,;
{"Excluir","U_CFINA27A(5)",0,5} ,;
{"Impressao","U_CFINR019",0,2} ,;
{"Legenda","U_CFINA27A(6)",0,4} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZC"
Private aCores    := {}
dbSelectArea("SZC")
dbSetOrder(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a funcao MBROWSE. Sintaxe:                                  ³
//³                                                                     ³
//³ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ³
//³ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ³
//³                        exibido. Para seguir o padrao da AXCADASTRO  ³
//³                        use sempre 6,1,22,75 (o que nao impede de    ³
//³                        criar o browse no lugar desejado da tela).   ³
//³                        Obs.: Na versao Windows, o browse sera exibi-³
//³                        do sempre na janela ativa. Caso nenhuma este-³
//³                        ja ativa no momento, o browse sera exibido na³
//³                        janela do proprio SIGAADV.                   ³
//³ Alias                - Alias do arquivo a ser "Browseado".          ³
//³ aCampos              - Array multidimensional com os campos a serem ³
//³                        exibidos no browse. Se nao informado, os cam-³
//³                        pos serao obtidos do dicionario de dados.    ³
//³                        E util para o uso com arquivos de trabalho.  ³
//³                        Segue o padrao:                              ³
//³                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ³
//³                                     {<CAMPO>,<DESCRICAO>},;         ³
//³                                     . . .                           ³
//³                                     {<CAMPO>,<DESCRICAO>} }         ³
//³                        Como por exemplo:                            ³
//³                        aCampos := { {"TRB_DATA","Data  "},;         ³
//³                                     {"TRB_COD" ,"Codigo"} }         ³
//³ cCampo               - Nome de um campo (entre aspas) que sera usado³
//³                        como "flag". Se o campo estiver vazio, o re- ³
//³                        gistro ficara de uma cor no browse, senao fi-³
//³                        cara de outra cor.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_nIndOrd := IndexOrd()
_cIndKey := IndexKey(2)
_cFiltro := 'SZC->ZC_PREFIXO$"SBAxSECxIRR" .AND. SZC->ZC_REGULAR == "N" '   // dbFilter()


IndRegua(cString, _nIndOrd, _cIndKey,, _cFiltro,"Selecionando Registros")

dbSelectArea(cString)




mBrowse( 6,1,22,75,cString,,,,,,Legenda(0))

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA27A   º Autor ³ AP6 IDE            º Data ³  19/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para Controle dos saldos das irregularidades        º±±
±±º          ³ apuradas no RDR.                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - Fiba Lancamentos                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINA27A(_nOpc)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


// _nOpc
// 1 - Pesquisar
// 2 - Visual
// 3 - Incluir
// 4 - Alterar
// 5 - Excluir
// 6 - Legenda
// Os registros "SZJ" em SX3 com o campo X3_PROPRI=="L" sairão no Acols
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lRet := .T., _aCpos, _cMsg, _aArea, _aAreaZ8, _aAreaX3, _aAreaZF
Local _aAux1, _nAux1, _nAux2, _aDel
Local _cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk, _cValid
Local _nOpcE, _nOpcG, _cFieldOk, _cVirtual, _nLinhas, _aAltEnch
Private aCols, aHeader
Private _nItem := 1
Private _nOpcao := _nOpc
Private LVISUAL := (_nOpc == 2)
Private LINCLUI := (_nOpc == 3)
Private LALTERA := (_nOpc == 4)
Private LEXCLUI := (_nOpc == 5)
Private _cString := "SZC"
Private _dDataMov
Private _dDataOri
Private _nSaldMov := 0
Private _cConv
Private _cDocMov
Private _cItemIr
Private _nItem := 0
Private _cNumIr
Private _cPsItem
Private ItemAux
Private _cPsNum
Private NumAux
Private _cLim
Private onSaldo, _nSaldo := 0
Private oGetDados
Private _nTotMov

// Campos que serao exibidos na tela.
DEFINE FONT oFnt     NAME "ARIAL" SIZE 10,23 BOLD
dbSelectArea("SZC")
dbSetOrder(2)

_aCpos := {"ZC_EMISSAO", "ZC_CONV", "ZC_EMPRESA", "ZC_VALORT", "ZC_VALORB", "ZC_VALORC"  }
// Armazena o posicionamento do alias SZC antes de processa-lo.
_aAreaZC := SZC->(GetArea())

Do Case
	Case _nOpc == 1  // Pesquisar.
		// Nao fazer nada.
		
	Case _nOpc == 2  // Visualizar.
		If !Empty(ZC_BAIXA)
			// Exibe a capa do registro bolsa auxilio
			_lRet := (AxVisual(_cString, &(_cString)->(RecNo()), _nOpc, _aCpos) == 1)
		Else
			
			
			IF Empty(SZC->ZC_NUM )
				MsgAlert("Nao Foram Digitados os Itens para Irregularidades!!")
				Return
			Endif
			SZJ->(dbSetOrder(3))
			IF !SZJ->(dbSeek(xFilial("SZJ") + SZC->ZC_NUM))
				MsgAlert("Nao Foram Digitados os Itens para Irregularidades!!")
				Return
			Endif
			
			
			// Exibe o titulo Do Fiba Cadastro de Diferença.
			_cTitulo  := "Movimentação das Irregularidades"
			_cAlias1  := _cString         // Alias da enchoice.
			_cAlias2  := "SZJ"            // Alias da GetDados.
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
			SX3->(DBGOTOP())
			SX3->(dbSeek(_cAlias2))
			Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == _cAlias2)
				If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. X3_PROPRI=="U" .and. X3_BROWSE == "S" )
					aAdd(aHeader, {TRIM(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE,;
					SX3->X3_TAMANHO, SX3->X3_DECIMAL, "AllwaysTrue()", SX3->X3_USADO,;
					SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT})
				Endif
				SX3->(dbSkip())
			EndDo
			SX3->(RestArea(_aArea))
			
			// Monta a aCols com os itens do SZJ.
			aCols := {}
			_aAreaZJ := SZJ->(GetArea())
			_aAreaX3 := SX3->(GetArea())
			SX3->(dbSetOrder(2))  // X3_CAMPO.
			SZJ->(dbSetOrder(3))
			SZJ->(dbSeek(xFilial("SZJ") + SZC->ZC_NUM))
			While (xFilial("SZJ")+SZJ->ZJ_NUM) == (xFilial("SZC")+SZC->ZC_NUM)
				_aAux1 := {}
				For _nAux1 := 1 to len(aHeader)
					SX3->(dbSeek(aHeader[_nAux1, 2]))
					
					If SX3->X3_CONTEXT == "V" .OR. SX3->X3_BROWSE == "N"
						aAdd(_aAux1, &(SX3->X3_RELACAO))
					Else
						aAdd(_aAux1, SZJ->(&(aHeader[_nAux1, 2])))
					Endif
					
				Next _nAux1
				aAdd(_aAux1, .F.)
				aAdd(aCols, _aAux1)
				SZJ->(dbSkip())
			End
			
			_cPsItem := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_ITEM" })
			
			
			
			aCols := ASORT(aCols,,, { |x, y| x[_cPsItem] < y[_cPsItem] })
			
			SX3->(RestArea(_aAreaX3))
			SZC->(RestArea(_aAreaZC))
			
			// Exibe a tela de modelo 3.
			_lRet := _Modelo3(_cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk,;
			_nOpcE, _nOpcG, _cFieldOk, &(_cVirtual), _nLinhas, _aAltEnch)
		Endif
		
	Case _nOpc == 3  // Inclusão dos Dados no Acols
	
	    If !Empty(ZC_BAIXA)
	    	_cMsg := "Diferença já Regularizada!!"
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
	    
	    
		If Empty(ZC_CONV)
			_cMsg := "Não foi digitado os movimentos referente a data e convenio, posicionado "
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
		
		
		_cTitulo  := "Movimentação das Irregularidades"
		_cAlias1  := _cString         // Alias da enchoice.
		_cAlias2  := "SZJ"            // Alias da GetDados.
		_aMyEncho := _aCpos           // Campos da Enchoice.
		_cFieldOk := "U_cfina27b(1)"  // Valida cada campo da GetDados.
		_cLinOk   := "U_cfina27b(2)"  // Valida a linha.
		_cTudoOk  := "U_cfina27b(3)"  // Valida toda a GetDados.
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
		SX3->(dbSeek(_cAlias2,.T.))
		
		Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == _cAlias2)
			If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. SX3->X3_PROPRI=="U".and. X3_BROWSE == "S")
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
		
		SZJ->(dbSetOrder(3))
		IF EMPTY(SZC->ZC_NUM)
			For _nAux1 := 1 to len(aHeader)
				aCols[1, _nAux1] := ;
				IIf (SX3->(dbSeek(aHeader[_nAux1, 2])) .and. !empty(SX3->X3_RELACAO),;
				&(SX3->X3_RELACAO), CriaVar(aHeader[_nAux1, 2]))
			Next _nAux1
			
		Else
			SZJ->(dbSeek(xFilial("SZJ") + SZC->ZC_NUM))
			While (xFilial("SZJ")+SZJ->ZJ_NUM) == (xFilial("SZC")+SZC->ZC_NUM)
				_aAux1 := {}
				For _nAux1 := 1 to len(aHeader)
					SX3->(dbSeek(aHeader[_nAux1, 2]))
					If SX3->X3_CONTEXT == "V" .OR. SX3->X3_BROWSE == "N"
						aAdd(_aAux1, &(SX3->X3_RELACAO))
					Else
						aAdd(_aAux1, SZJ->(&(aHeader[_nAux1, 2])))
					Endif
				Next _nAux1
				aAdd(_aAux1, .F.)
				aAdd(aCols, _aAux1)
				ItemAux := SZJ->ZJ_ITEM
				NumAux  := SZJ->ZJ_NUM
				SZJ->(dbSkip())
			End
			
			For _nAux1 := 1 to len(aHeader)
				aCols[1, _nAux1] := ;
				IIf (SX3->(dbSeek(aHeader[_nAux1, 2])) .and. !empty(SX3->X3_RELACAO),;
				&(SX3->X3_RELACAO), CriaVar(aHeader[_nAux1, 2]))
			Next _nAux1
			
		Endif
		
		_dDataOri := SZC->ZC_EMISSAO
		_nSaldMov := SZC->ZC_VALORT
		_cConv    := SZC->ZC_CONV
		
		//		aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_DATAORI"})]   := _dDataOri
		//		aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_CONV"})]      := _cConv
		aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_VALORBA"})]   := 0
		aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_VALORCI"})]   := 0
		aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_TOTMOV"})]    := 0
		_cPsNum  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_NUM" })
		_cPsItem := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_ITEM" })
		IF !Empty(ItemAux)
			Acols[1][ _cPsItem] := StrZero(val(ItemAux)+=1,2)
			Acols[1][_cPsNum]   := NumAux
		EndIf
		
		
		aCols[1, len(aHeader) + 1] := .F.
		aCols := ASORT(aCols,,, { |x, y| x[_cPsItem] < y[_cPsItem] })
		SX3->(RestArea(_aArea))
		
		// Exibe a tela de modelo 3.
		_lRet := _Modelo3(_cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk,;
		_nOpcE, _nOpcG, _cFieldOk, &(_cVirtual), _nLinhas, _aAltEnch) // Object oModel
		If _lRet  .AND. Empty(SZC->ZC_NUM)   // Usuario confirmou a operacao.
			Begin Transaction
			// Grava os itens da prestacao de contas (SZF).
			_nTotPrest := 0
			_cNumIr := GetSxENum("SZJ","ZJ_NUM")
			_cItemIr := StrZero(_nItem+=1,2)
			
			For _nAux1 := 1 to len(aCols)
				// Varre todos os itens.
				If !aCols[_nAux1, len(aHeader) + 1]
					RecLock("SZJ", .T.)
					SZJ->ZJ_FILIAL   := xFilial("SZJ")
					//					SZJ->ZJ_DATAMOV  := dDATABASE
					SZJ->ZJ_CONV     := SZC->ZC_CONV
					SZJ->ZJ_DATAORI  := SZC->ZC_EMISSAO
					For _nAux2 := 1 to len(aHeader)
						SZJ->(&(aHeader[_nAux2, 2])) := aCols[_nAux1, _nAux2]
					Next _nAux2
					SZJ->ZJ_NUM      := _cNumIr
					SZJ->ZJ_ITEM     := _cItemIr
					SZJ->(msUnLock())
					//				    _dDataMov := aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_DATAMOV"})]
					//					_dDataOri := aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_DATAORI"})]
					//			_nSaldMov := aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_SALDO"})]
					//					_cConv    := aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_CONV"})]
					_cDocMov  := aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_DOCMOV"})]
				Endif
				_cItemIr := StrZero(_nItem+=1,2)
			Next _nAux1
			DbSelectArea("SZC")
			RecLock("SZC",.F.)
			SZC->ZC_NUM := _cNumIr
			SZC->ZC_BAIXA := IIf(ABS(_nTotMov) == ABS(SZC->ZC_VALORT),"E","")
			SZC->(MsUnlock())
            
			ConfirmSX8()
			End Transaction
		Else
			If _lRet
				Begin Transaction
				_nTotPrest := 0
				For _nAux1 := 1 to len(aCols)
					// Varre todos os itens.
					
					If !aCols[_nAux1, len(aHeader) + 1]
						
						DbSelectarea("SZJ")
						SZJ->(dbSetOrder(3))
						IF !SZJ->(dbSeek(xFilial("SZJ") + Acols[_nAux1,_cPsNum]+Acols[_nAux1,_cPsItem],.T.))
							RecLock("SZJ", .T.)
						ELSE
							RecLock("SZJ", .F.)
						ENDIF
						SZJ->ZJ_FILIAL   := xFilial("SZJ")
						SZJ->ZJ_CONV     := SZC->ZC_CONV
						SZJ->ZJ_DATAORI  := SZC->ZC_EMISSAO
						If !aCols[_nAux1, len(aHeader) + 1]
							For _nAux2 := 1 to len(aHeader)
								SZJ->(&(aHeader[_nAux2, 2])) := aCols[_nAux1, _nAux2]
							Next _nAux2
							SZJ->(msUnLock())
						Endif
					EndIf
				Next _nAux1
		
    			DbSelectArea("SZC")
	    		RecLock("SZC",.F.)
		    	SZC->ZC_BAIXA := IIf(ABS(_nTotMov) == ABS(SZC->ZC_VALORT),"E","")
			    SZC->(MsUnlock())

				End Transaction
			Endif
		Endif
		
	Case _nOpc == 4  // Alterar
		
	    If !Empty(ZC_BAIXA)
	    	_cMsg := "Diferença já Regularizada!!"
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
		If Empty(ZC_CONV)
			_cMsg := "Não foi digitado os movimentos referente a data e convenio, posicionado "
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
		
		SZJ->(dbSetOrder(3))  // ZJ_FILIAL+ZJ_DATAMOV+ZC_CONV.
		IF !SZJ->(dbSeek(xFilial("SZJ") + SZC->ZC_NUM))
			MsgAlert("Nao Foram Digitados os Itens para as Irregularidades!!")
			Return
		Endif
		_cTitulo  := "Movimentação das Irregularidades"
		_cAlias1  := _cString         // Alias da enchoice.
		_cAlias2  := "SZJ"            // Alias da GetDados.
		_aMyEncho := _aCpos           // Campos da Enchoice.
		_cFieldOk := "U_cfina27b(1)"  // Valida cada campo da GetDados.
		_cLinOk   := "U_cfina27b(2)"  // Valida a linha.
		_cTudoOk  := "U_cfina27b(3)"  // Valida toda a GetDados.
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
		SX3->(dbSeek(_cAlias2,.T.))
		Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == _cAlias2)
			If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. SX3->X3_PROPRI=="U" .and. X3_BROWSE == "S")
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
		
		
		aCols := {}
		_aAreaZJ := SZJ->(GetArea())
		_aAreaX3 := SX3->(GetArea())
		SX3->(dbSetOrder(2))  // X3_CAMPO.
		SZJ->(dbSetOrder(3))  // ZJ_FILIAL+ZJ_DATAMOV+ZC_CONV.
		//		SZJ->(dbSeek(xFilial("SZJ") + DTOS(SZC->ZC_EMISSAO)+SZC->ZC_CONV, .T.))  // +StrZero(SZ8->(RECNO()),15), .F.))
		SZJ->(dbSeek(xFilial("SZJ") + SZC->ZC_NUM))
		While (xFilial("SZJ")+SZJ->ZJ_NUM) == (xFilial("SZC")+SZC->ZC_NUM)
			_aAux1 := {}
			For _nAux1 := 1 to len(aHeader)
				SX3->(dbSeek(aHeader[_nAux1, 2]))
				If SX3->X3_CONTEXT == "A"
					aAdd(_aAux1, &(SX3->X3_RELACAO))
				Else
					aAdd(_aAux1, SZJ->(&(aHeader[_nAux1, 2])))
				Endif
			Next _nAux1
			aAdd(_aAux1, .F.)
			aAdd(aCols, _aAux1)
			SZJ->(dbSkip())
		End
		_cPsItem  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_ITEM" })
		aCols[1, len(aHeader) + 1] := .F.
		aCols := ASORT(aCols,,, { |x, y| x[_cPsItem] < y[_cPsItem] })
		SX3->(RestArea(_aArea))
		_cLim := Len(Acols)
		// Exibe a tela de modelo 3.
		_lRet := _Modelo3(_cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk,;
		_nOpcE, _nOpcG, _cFieldOk, &(_cVirtual), _nLinhas, _aAltEnch)
		If _lRet  // Usuario confirmou a operacao.
			
			//			_dPsDtOri := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_DATAORI" })
			_dPsDtMv  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_DATAMOV" })
			//			_cPsConv  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_CONV" })
			_cPsDoc   := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_DOCMOV" })
			_cPsNum   := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_NUM" })
			_cPsItem  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_ITEM" })
			
			Begin Transaction
			_nTotPrest := 0
			For _nAux1 := 1 to len(aCols)
				// Varre todos os itens.
				If aCols[_nAux1, len(aHeader) + 1] 
					IF SZJ->(dbSeek(xFilial("SZJ")+Acols[_nAux1,_cPsNum]+Acols[_nAux1,_cPsItem]))
						RecLock("SZJ", .F.)
						SZJ->(dbDelete())
						SZJ->(msUnLock())
					EndIF
				Else
					DbSelectarea("SZJ")
					SZJ->(dbSetOrder(3))  // ZJ_FILIAL+ZJ_DATAMOV+ZC_CONV+ZJ_DATAORI+ZJ_DOCMOV
					IF !SZJ->(dbSeek(xFilial("SZJ")+Acols[_nAux1,_cPsNum]+Acols[_nAux1,_cPsItem]))
						RecLock("SZJ", .T.)
					ELSE
						RecLock("SZJ", .F.)
					ENDIF
					SZJ->ZJ_FILIAL   := xFilial("SZJ")
					SZJ->ZJ_CONV     := SZC->ZC_CONV
					SZJ->ZJ_DATAORI  := SZC->ZC_EMISSAO
					If !aCols[_nAux1, len(aHeader) + 1]
						For _nAux2 := 1 to len(aHeader)
							SZJ->(&(aHeader[_nAux2, 2])) := aCols[_nAux1, _nAux2]
						Next _nAux2
						SZJ->(msUnLock())
					Endif
				EndIf
			Next _nAux1
				DbSelectArea("SZC")
	    		RecLock("SZC",.F.)
		    	SZC->ZC_BAIXA := IIf(ABS(_nTotMov) == ABS(SZC->ZC_VALORT),"E","")
			    SZC->(MsUnlock())
			End Transaction
		Endif
	Case _nOpc == 5  // Cancelar prestacao.
		
		// Trata os erros.
		/*
		If !Empty(SZC->ZC_BAIXA)   // Baixado
			_cMsg := "Movimento de Irregularidade Fechado"
			MsgAlert(_cMsg, "Atenção")
			Return .F.
		Endif
		*/
		SZJ->(dbSetOrder(3))
		IF !SZJ->(dbSeek(xFilial("SZJ") + SZC->ZC_NUM))
			MsgAlert("Nao Foram Digitados os Itens para Irregularidades!!")
			Return
		Endif
		// Exibe o titulo Do Fiba Cadastro de Diferença.
		_cTitulo  := "Movimentação das Irregularidades - Exclusao"
		_cAlias1  := _cString         // Alias da enchoice.
		_cAlias2  := "SZJ"            // Alias da GetDados.
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
		SX3->(DBGOTOP())
		SX3->(dbSeek(_cAlias2))
		Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == _cAlias2)
			If SX3->(X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. X3_PROPRI=="U" .and. X3_BROWSE == "S")
				aAdd(aHeader, {TRIM(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE,;
				SX3->X3_TAMANHO, SX3->X3_DECIMAL, "AllwaysTrue()", SX3->X3_USADO,;
				SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT})
			Endif
			SX3->(dbSkip())
		EndDo
		SX3->(RestArea(_aArea))
		
		// Monta a aCols com os itens do SZJ.
		aCols := {}
		_aAreaZJ := SZJ->(GetArea())
		_aAreaX3 := SX3->(GetArea())
		SX3->(dbSetOrder(2))  // X3_CAMPO.
		SZJ->(dbSetOrder(3))
		SZJ->(dbSeek(xFilial("SZJ") + SZC->ZC_NUM))
		
		
		While (xFilial("SZJ")+SZJ->ZJ_NUM) == (xFilial("SZC")+SZC->ZC_NUM)
			_aAux1 := {}
			For _nAux1 := 1 to len(aHeader)
				SX3->(dbSeek(aHeader[_nAux1, 2]))
				If SX3->X3_CONTEXT == "V"
					aAdd(_aAux1, &(SX3->X3_RELACAO))
				Else
					aAdd(_aAux1, SZJ->(&(aHeader[_nAux1, 2])))
				Endif
			Next _nAux1
			aAdd(_aAux1, .F.)
			aAdd(aCols, _aAux1)
			SZJ->(dbSkip())
		End
		SX3->(RestArea(_aAreaX3))
		SZC->(RestArea(_aAreaZC))
		
		// Exibe a tela de modelo 3.
		_lRet := _Modelo3(_cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk,;
		_nOpcE, _nOpcG, _cFieldOk, &(_cVirtual), _nLinhas, _aAltEnch)
		
		
		
		//		_lRet := U_cfina27(2)
		
		If _lRet
			_cOpYes := MsgYesNo("Confirma Exclusao dos Registros!!!")
			IF !_cOpYes
				Return
			Endif
		EndIf
		If _lRet  // Usuario confirmou a operacao.
			Begin Transaction
			
			
			_aDel := {}
			
			SZJ->(dbSetOrder(3))  // ZJ_FILIAL+ZJ_DATAMOV+ZC_CONV.
			SZJ->(dbSeek(xFilial("SZJ") + SZC->ZC_NUM))
			While (xFilial("SZJ")+SZJ->ZJ_NUM) == (xFilial("SZC")+SZC->ZC_NUM)
				aAdd(_aDel, SZJ->(RecNo()))
				SZJ->(dbSkip())
			End
			
			For _nAux1 := 1 to len(_aDel)
				SZJ->(dbGoTo(_aDel[_nAux1]))
				RecLock("SZJ", .F.)
				SZJ->(dbDelete())
				SZJ->(msUnLock())
			Next _nAux1
			DbSelectArea("SZC")
			RecLock("SZC",.F.)
			SZC->ZC_NUM := " "
            SZC->ZC_BAIXA:= " "
			SZC->(MsUnlock())
			End Transaction
		Endif
		
	Case _nOpc == 6  // Legenda.
		Legenda()
		
	OtherWise
EndCase

// Retorna o posicionamento do alias SZC.
SZC->(RestArea(_aAreaZC))
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
User Function cfina27b(_nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lRet := .T.
Local _nAux1
//Local nPsVlBA  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_VALORBA", ObjectMethod(oPsVlBA,"Refresh()")})
//Local nPsVlCI  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_VALORCI", ObjectMethod(oPsVlCI,"Refresh()")})
Private _nPsVlBA  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_VALORBA"})
Private _nPsVlCI  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_VALORCI"})
Private _nPsTLMOV := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_TOTMOV"})
//Private _nPsSaldo := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_SALDO" })
//Private _nPsDtOri := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_DATAORI" })
Private _nPsDtMv  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_DATAMOV" })
Private _nPsDocMv  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_DOCMOV" })
Private cVALOR := 0
// ObjectMethod(oPsVlBA,"Activate()")
// ObjectMethod(oPsVlCI,"Activate()")


Do Case
	Case _nOpc == 1  // Valida o campo.
		
		//	bBloco := {|acols| acols }
		//   eval(bbloco, acols[N][6]:= "CLAUDIO" )
		
		IF lAltera == .T. .AND. n > _cLim
			_cMsg := "Nao é Permitido Alteracao nas linhas Incluidas, utilize a opcao Inclusao!"
			MsgAlert(_cMsg, "Atenção")
			aCols[n][len(AHeader)+1] := .T.
			Return(.F.)
		EndIf
		
		If Len(acols) > 1 .and. n == Len(acols)
			
			/*			If ABS(acols[n][_nPsVlBA])+(acols[n][_nPsVlCI]) > ABS(acols[n -1][_nPsSaldo])
			_cMsg := "Valor maior que o saldo!"
			MsgAlert(_cMsg, "Atenção")
			//      _lRet := .F.
			EndIf
			*/
			
			IF !(_lRet := aCols[n, len(aHeader) + 1])
				//       acols[n][_nPsTLMOV] := (acols[n][_nPsVlBA])+(acols[n][_nPsVlCI])
				//       acols[n][_nPsSaldo] := (acols[n-1][_nPsSaldo]) + ((acols[n][_nPsVlBA])+ (acols[n][_nPsVlCI]))
				acols[n][_nPsDtMv]  := acols[n-1][_nPsDtMv]
				bBloco := {|acols| acols }
				If lAltera <> .T.
					eval(bbloco, acols[n][_nPsTLMOV]:= (acols[n][_nPsVlBA])+(acols[n][_nPsVlCI]))
					//				eval(bbloco, acols[n][_nPsSaldo]:= (acols[n-1][_nPsSaldo]) + ((acols[n][_nPsVlBA])+ (acols[n][_nPsVlCI])))
				Else
					IF n == 1
						eval(bbloco, acols[n][_nPsTLMOV]:= (acols[n][_nPsVlBA])+(acols[n][_nPsVlCI]))
						//					eval(bbloco, acols[n][_nPsSaldo]:= SZC->ZC_VALORT + ((acols[n][_nPsVlBA])+ (acols[n][_nPsVlCI])))
					ELSE
						eval(bbloco, acols[n][_nPsTLMOV]:= (acols[n][_nPsVlBA])+(acols[n][_nPsVlCI]))
						//					eval(bbloco, acols[n][_nPsSaldo]:= (acols[n-1][_nPsSaldo]) + ((acols[n][_nPsVlBA])+ (acols[n][_nPsVlCI])))
					ENDIF
					
					
				ENDIF
				
				_lRet := .T.
			ENDIF
			
		Else
			
			IF !EMPTY(SZC->ZC_NUM) .and. lAltera <> .T.
				Return(.F.)
			Else
				bBloco := {|acols| acols }
				eval(bbloco, acols[n][_nPsTLMOV]:= (acols[n][_nPsVlBA])+(acols[n][_nPsVlCI]))
				//		eval(bbloco, acols[n][_nPsSaldo]:= SZC->ZC_VALORT + ((acols[n][_nPsVlBA])+ (acols[n][_nPsVlCI])))
			ENDIF
			
		EndIf
		//		       oGetDados:oBrowse:Refresh()
		
		lRefresh:=.t.
		
		U_VerSaldo()
	Case _nOpc == 2  // Valida a linha.
		//	   u_VerSaldo()
		
		
		If aCols[n, len(aHeader) + 1]
			Return(.T.)
		Endif
		
		IF lAltera == .T. .AND. n > _cLim
			_cMsg := "Nao é Permitido Alteracao nas linhas Incluidas, utilize a opcao Inclusao!"
			MsgAlert(_cMsg, "Atenção")
			aCols[n][len(AHeader)+1] := .T.
			Return(.F.)
		EndIf
		IF Empty(aCols[n, _nPsDtMv])
			_cMsg := "Preencha a Data do Movimento!"
			MsgAlert(_cMsg, "Atenção")
			Return(.F.)
		EndIf
		
		
		IF Empty(aCols[n, _nPsDocMv])
			_cMsg := "Preencha o Documento!"
			MsgAlert(_cMsg, "Atenção")
			Return(.F.)
		EndIf
		
		IF Empty(aCols[n, _nPsVlBA]) .AND.  Empty(aCols[n, _nPsVlCI])
			_cMsg := "Preencha um dos valores BA ou CI !"
			MsgAlert(_cMsg, "Atenção")
			Return(.F.)
		ENDIF
		
		//          _lRet := .F.
		
		/*      ELSE
		RecLOck("SZC")
		//       SZC->ZC_SALDO := Acols[n,_nPsSaldo]
		cVALOR := Acols[n,_nPsSaldo]
		SZC->(MsUnlock())
		_lRet := .T.
		Endif
		*/
		
		If lAltera == .T.
			IF Empty(aCols[n, _nPsDocMv])
				_cMsg := "Teste para validar a linha!"
				MsgAlert(_cMsg, "Atenção")
				Return(.F.)
			ENDIF
		EndIf
		
		
	Case _nOpc == 3  // Valida a aCols.
		//    	aCols[n, _nPsDtOri] := SZC->ZC_EMISSAO
		If (_lRet := U_cfina27b(2))
			_nTotal := 0
			For _nAux1 := 1 to len(aCols)
				If !aCols[_nAux1, len(aHeader) + 1]
					_nTotal +=	aCols[_nAux1, _nPsTLMOV]
					If ABS(_nTotal) > ABS(SZC->ZC_VALORT)
						_cMsg := "Valor maior que o Saldo!"
						MsgAlert(_cMsg, "Atenção")
						_lRet := .F.
					EndIf
				Endif
			Next _nAux1
		EndIf
		If Len(Acols) == 1 .and. lAltera == .T.  .and. aCols[n, len(aHeader) + 1]
			_cMsg := "Existe apenas um item cadastrado utilize a opção Exclusão!"
			MsgInfo(_cMsg, "Atenção")
			_lRet := .F.
		Endif
EndCase

Return(_lRet)


Static Function _Modelo3(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze,aAlter)
Local lRet, nOpca := 0,cSaveMenuh,nReg:=(cAlias1)->(Recno())
local oDlg

Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

nOpcE := If(nOpcE==Nil,3,nOpcE)
nOpcG := If(nOpcG==Nil,3,nOpcG)
lVirtual := Iif(lVirtual==Nil,.F.,lVirtual)
nLinhas:=Iif(nLinhas==Nil,99,nLinhas)

//DEFINE MSDIALOG oDlg TITLE cTitulo From 5,0 to 28,90	of oMainWnd
DEFINE MSDIALOG oDlg TITLE cTitulo From 5,0 to 35,90	of oMainWnd
EnChoice(cAlias1,nReg,nOpcE,,,,aMyEncho,{11,1,75,355},aAltEnchoice,3,,,,,,lVirtual)
// oGetDados := MsGetDados():New(70,1,170,355,nOpcG,cLinOk,cTudoOk,"",.T.,aAlter,2/*nFreeze*/,,nLinhas,cFieldOk)
oGetDados := MsGetDados():New(80,1,190,355,nOpcG,cLinOk,cTudoOk,"",.T.,aAlter,2/*nFreeze*/,,nLinhas,cFieldOk)//object oGetDados
// oGetDados:oBrowse:NFreeze := 1

oGetDados:oBrowse:Refresh()
oGetDados:oBrowse:SetFocus()

@ 200,050 SAY "Saldo : " COLOR CLR_BLUE OBJECT oSaldo
oSaldo:oFont := oFnt
@ 200,90 GET _nSaldo Picture "@E 99,999,999.99" WHEN .F. SIZE 60,40 OBJECT onSALDO
u_versaldo()

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)},{||oDlg:End()}) CENTERED
lRet:=(nOpca==1)
Return lRet



// eVal( ogetDados:obrowse:badd )


User Function VerSaldo()


Private _nPsVlBA  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_VALORBA"})
Private _nPsVlCI  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_VALORCI"})
Private _nPsTLMOV := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_TOTMOV"})
// Private _nPsSaldo := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_SALDO" })

_nSaldo := 0
_nTotMov := 0

IF !lAltera
	If Len(acols) == 1
		_nSaldo = (SZC->ZC_VALORT)+ ((acols[N][_nPsVlBA])+ (acols[N][_nPsVlCI]))
		_nTotMov +=  ((acols[N][_nPsVlBA])+ (acols[N][_nPsVlCI]))
		
	Else
		If Len(Acols) > 1
			
			For _Nr := 1 to Len(Acols)
				_nTotMov +=  ((acols[_Nr][_nPsVlBA])+ (acols[_Nr][_nPsVlCI]))
			Next
			_nSaldo =  SZC->ZC_VALORT + _nTotMov
			
		Endif
		
	ENDIF
ELSE
	
	For _Nr := 1 to Len(Acols)
		_nTotMov +=  ((acols[_Nr][_nPsVlBA])+ (acols[_Nr][_nPsVlCI]))
	Next
	_nSaldo =  SZC->ZC_VALORT + _nTotMov
	
	
ENDIF



onSaldo:Refresh()
oGetDados:Refresh()
oGetDados:oBrowse:Refresh()
oGetDados:oBrowse:SetFocus()

If lAltera == .T. ; oGetdados:nMax:=_cLim ; EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Legenda   ºAutor  ³ Cláudio Barros     º Data ³  16/09/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Legenda(_uPar)
Local _uRet, _aFlag

_aLeg := {;
{"BR_VERDE",    "Diferenças em aberto"},;
{"BR_AMARELO",  "Diferenças Parciais"},;
{"BR_VERMELHO", "Diferenças Regularizadas"}}

//{"BR_AZUL", ""}}



If ValType(_uPar) != "U" .and. _uPar == 0
	_aFlag := {;
	{' empty(ZC_BAIXA).and. Empty(ZC_NUM)',                        _aLeg[1][1]},;  // Verde
	{' !empty(ZC_NUM) .and. empty(ZC_BAIXA)'  , _aLeg[2][1]},;  // Amarelo
	{' !empty(ZC_BAIXA) .and. !empty(ZC_NUM)' , _aLeg[3][1]}}  // Vermelho
	_uRet := _aFlag
Else
	BrwLegenda(cCadastro, "Legenda", _aLeg)
Endif
Return (_uRet)



User Function VerSMov()

Local _nTotLin := 0
Local _nSaldoLin := 0
Local _lRet := .T.
Local _nPsVlBA  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_VALORBA"})
Local _nPsVlCI  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZJ_VALORCI"})


For _Nr := 1 to Len(Acols)
	_nTotLin +=  ((acols[_Nr][_nPsVlBA])+ (acols[_Nr][_nPsVlCI]))
Next

If ABS(_nTotLin)	> ABS(SZC->ZC_VALORT)
	_cMsg := "Valor informado maior que o saldo inicial!"
	MsgAlert(_cMsg, "Atenção")
	_lRet := .F.
EndIf

Return(_lRet)
