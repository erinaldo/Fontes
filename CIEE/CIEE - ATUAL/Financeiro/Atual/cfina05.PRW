#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#DEFINE _EOL chr(13) + chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA05   � Autor � Felipe Raposo      � Data �  12/03/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de adiantamento ao funcionario.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE - Financeiro                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CFINA05(_cFunName)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _cVldAlt := ".T."   // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local _cVldExc := ".T."   // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private _cString := "SE2", _bFiltraBrw, _aIndex := {}, _cFiltro
Private aRotina, cCadastro
Private cObs := Space(50)
Private oDlg1   := Nil

// Verifica se o programa principal eh
// esse proprio (.F.) ou se eh outro (.T.).
// Usado no X3_WHEN dos campos que sao X3_PROPRI == "U"
//U_CFINA05("FINA050")
If ValType(_cFunName) == "C"
	Return(FunName() == _cFunName)
Endif

// Efetua o filtro do cadastro de contas a pagar.
// Somente sera exibido os titulos referentes ao adiantamento.
_cFiltro := "E2_TIPO == 'ADF'"
_bFiltraBrw := {|| FilBrowse(_cString, @_aIndex, @_cFiltro)}
Eval(_bFiltraBrw)
SE2->(dbSetOrder(1))  // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.

//������������������������������������������������������������Ŀ
//� Monta um aRotina proprio.                                  �
//��������������������������������������������������������������
aRotina := {;
{"Pesquisar",          "AxPesqui",        0, 1},;
{"Visualizar",         "U_cfina05a(2)",   0, 2},;
{"Prestar Conta",      "U_cfina05a(6)",   0, 4},;
{"Cancelar Presta��o", "U_cfina05a(7)",   0, 4},;
{"Legenda",            "U_cfina05a(999)", 0, 6}}
//{"Incluir",            "U_cfina05a(3)",   0, 3},;
//{"Alterar",            "U_cfina05a(4)",   0, 4},;
//{"Excluir",            "U_cfina05a(5)",   0, 5},;

//������������������������������������������������������������Ŀ
//� Exibe a tela de cadastro.                                  �
//��������������������������������������������������������������
cCadastro := "Cadastro de adiantamento ao funcion�rio"
mBrowse(06, 01, 22, 75, _cString,,,,,, Legenda(0))

// Limpa o filtro do cadastro de contas a pagar.
EndFilBrw(_cString, _aIndex)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA05   �Autor  � Felipe Raposo      � Data �  12/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CFINA05a(_nOpc)
// _nOpc
// 1 - Pesquisar
// 2 - Visual
// 3 - Incluir
// 4 - Alterar
// 5 - Excluir
// 6 - Legenda

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _lRet := .T., _aCpos, _cMsg, _aArea, _aAreaE2, _aAreaX3, _aAreaZ4
Local _aAux1, _nAux1, _nAux2, _aDel
Local _cNumTit, _cNum, _cFornece, _cLoja, _nDif, _nTotPrest
Local _cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk, _cValid
Local _nOpcE, _nOpcG, _cFieldOk, _cVirtual, _nLinhas, _aAltEnch
//Local _nCPMFAliq := 0.38  // Aliquota de CPMF. // Alteracao feita em 21/01/08 por Cristiano, conforme SSI 08/015
Private aCols, aHeader
Private _nItem := 1
Private _nOpcao := _nOpc
Private LVISUAL := (_nOpc == 2)
Private LINCLUI := (_nOpc == 3)
Private LALTERA := (_nOpc == 4)
Private LEXCLUI := (_nOpc == 5)

// Campos que serao exibidos na tela.
_aCpos := {"E2_TIPO", "E2_NUM", "E2_NATUREZ", "E2_FORNECE",;
"E2_LOJA", "E2_NOMFOR", "E2_EMISSAO", "E2_VENCTO", "E2_VENCREA", "E2_VALOR"}

// Armazena o posicionamento do alias SE2 antes de processa-lo.
_aAreaE2 := SE2->(GetArea())

Do Case
	Case _nOpc == 1  // Pesquisar.
		// Nao fazer nada.
		
	Case _nOpc == 2  // Visualizar.
		If empty(E2_ADF)
			// Exibe o titulo adiantado.
			_lRet := (AxVisual(_cString, &(_cString)->(RecNo()), _nOpc, _aCpos) == 1)
		Else
			// Exibe o titulo com a prestacao de contas.
			_cTitulo  := "Presta��o de contas - Visualizar"
			_cAlias1  := _cString         // Alias da enchoice.
			_cAlias2  := "SZ4"            // Alias da GetDados.
			_aMyEncho := _aCpos           // Campos da Enchoice.
			_cFieldOk := "AllwaysTrue()"  // Valida cada campo da GetDados.
			_cLinOk   := "AllwaysTrue()"  // Valida a linha.
			_cTudoOk  := "AllwaysTrue()"  // Valida toda a GetDados.
			_nOpcE    := 2                // Opcao da Enchoice.
			_nOpcG    := 2                // Opcao da GetDados.
			_cVirtual := ".T."            // Exibe os campos virtuais na GetDados.
			_nLinhas  := 99               // Numero maximo de linhas na GetDados.
			_aAltEnch := nil              // Campos alteraveis na Enchoice (nil = todos).
			
			//��������������������������������������������������������������Ŀ
			//� Cria variaveis M->????? da Enchoice.                         �
			//����������������������������������������������������������������
			RegToMemory(_cAlias1, .F.)
			
			// Monta a aHeader.
			aHeader := {}
			_aArea := SX3->(GetArea())
			SX3->(dbSetOrder(1))  // X3_ARQUIVO+X3_ORDEM.
			SX3->(dbSeek(_cAlias2))
			Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == _cAlias2)
				If SX3->(X3USO(X3_USADO) .and. cNivel >= X3_NIVEL)
					aAdd(aHeader, {TRIM(SX3->X3_TITULO), SX3->X3_CAMPO, SX3->X3_PICTURE,;
					SX3->X3_TAMANHO, SX3->X3_DECIMAL, "AllwaysTrue()", SX3->X3_USADO,;
					SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT})
				Endif
				SX3->(dbSkip())
			EndDo
			SX3->(RestArea(_aArea))
			
			// Monta a aCols com os itens do SZ4.
			aCols := {}
			_aAreaZ4 := SZ4->(GetArea())
			_aAreaX3 := SX3->(GetArea())
			SX3->(dbSetOrder(2))  // X3_CAMPO.
			SZ4->(dbSetOrder(1))  // Z4_FILIAL+Z4_NUM.
			SZ4->(dbSeek(xFilial("SZ4") + M->E2_NUM, .F.))
			Do While SZ4->(Z4_FILIAL + Z4_NUM) == xFilial("SZ4") + M->E2_NUM
				_aAux1 := {}
				For _nAux1 := 1 to len(aHeader)
					SX3->(dbSeek(aHeader[_nAux1, 2]))
					If SX3->X3_CONTEXT == "V"
						aAdd(_aAux1, &(SX3->X3_RELACAO))
					Else
						aAdd(_aAux1, SZ4->(&(aHeader[_nAux1, 2])))
					Endif
				Next _nAux1
				aAdd(_aAux1, .F.)
				aAdd(aCols, _aAux1)
				SZ4->(dbSkip())
			EndDo
			SX3->(RestArea(_aAreaX3))
			SZ4->(RestArea(_aAreaZ4))
			
			// Exibe a tela de modelo 3.
			_lRet := Modelo3(_cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk,;
			_nOpcE, _nOpcG, _cFieldOk, &(_cVirtual), _nLinhas, _aAltEnch)
		Endif
		
	Case _nOpc == 6  // Prestar conta.
		
		// Trata os erros.
		If SE2->(E2_SALDO != 0)   // Baixado
			_cMsg := "O t�tulo ainda n�o foi baixado completamente!!!"
			MsgAlert(_cMsg, "Aten��o")
			Return .F.
		Endif
		If !empty(E2_ADF)   // Baixado
			_cMsg := "J� houve a presta��o de conta desse adiantamento!!!"
			MsgAlert(_cMsg, "Aten��o")
			Return .F.
		Endif
		
		_cTitulo  := "Presta��o de contas"
		_cAlias1  := _cString         // Alias da enchoice.
		_cAlias2  := "SZ4"            // Alias da GetDados.
		_aMyEncho := _aCpos           // Campos da Enchoice.
		_cFieldOk := "U_cfina05b(1)"  // Valida cada campo da GetDados.
		_cLinOk   := "U_cfina05b(2)"  // Valida a linha.
		_cTudoOk  := "U_cfina05b(3)"  // Valida toda a GetDados.
		_nOpcE    := 2                // Opcao da Enchoice.
		_nOpcG    := 3                // Opcao da GetDados.
		_cVirtual := ".T."            // Exibe os campos virtuais na GetDados.
		_nLinhas  := 99               // Numero maximo de linhas na GetDados.
		_aAltEnch := nil              // Campos alteraveis na Enchoice (nil = todos).
		
		//��������������������������������������������������������������Ŀ
		//� Cria variaveis M->????? da Enchoice.                         �
		//����������������������������������������������������������������
		RegToMemory(_cAlias1, .F.)
		
		// Monta a aHeader.
		aHeader := {}
		_aArea := SX3->(GetArea())
		SX3->(dbSetOrder(1))  // X3_ARQUIVO+X3_ORDEM.
		SX3->(dbSeek(_cAlias2))
		Do While SX3->(!eof() .and. SX3->X3_ARQUIVO == _cAlias2)
			If SX3->(X3USO(X3_USADO) .and. cNivel >= X3_NIVEL)
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
		aCols[1, aScan(aHeader, {|x| AllTrim(x[2]) == "Z4_ITEM"})] := "01"
		aCols[1, len(aHeader) + 1] := .F.
		SX3->(RestArea(_aArea))
		
		// Exibe a tela de modelo 3.
		_lRet := Modelo3(_cTitulo, _cAlias1, _cAlias2, _aMyEncho, _cLinOk, _cTudoOk,;
		_nOpcE, _nOpcG, _cFieldOk, &(_cVirtual), _nLinhas, _aAltEnch)
		If _lRet  // Usuario confirmou a operacao.
			Begin Transaction
			
			// Marca o titulo (adiantamento) como conta prestada e
			// o tira do fluxo de caixa.
			RecLock("SE2", .F.)
			SE2->E2_ADF   	:= SE2->E2_NUM
			SE2->E2_FLUXO 	:= "N"
			SE2->E2_OBSADT 	:= cObs
			SE2->(msUnLock())

            // Posiciona na baixa do t�tulo original
            dbSelectArea("SE5")
            dbSetOrder(7)
            If dbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA, .F.)
               _cNumero  := SE5->E5_NUMERO
   	           _cParcela := SE5->E5_PARCELA
       	       _cClifor  := SE5->E5_CLIFOR
           	   _cLoja    := SE5->E5_LOJA
               _cBANCO   := SE5->E5_BANCO
               _cAGENCIA := SE5->E5_AGENCIA
               _cCONTA   := SE5->E5_CONTA   
               SA2->(dbSetOrder(1))  // A2_FILIAL + A2_COD + A2_LOJA.
   	           If SA2->(dbSeek(xFilial("SA2") + SE5->(E5_CLIFOR + E5_LOJA), .F.))
	           		_cBenef := Left(SA2->A2_NOME,30)
           	   Else             
               		_cBenef := ""
           	   EndIf    
            EndIf                
            
			// Grava os itens da prestacao de contas (SZ4).
			_nTotPrest := 0
			For _nAux1 := 1 to len(aCols)
				// Varre todos os itens.
				If !aCols[_nAux1, len(aHeader) + 1]
					RecLock("SZ4", .T.)
					SZ4->Z4_FILIAL := xFilial("SZ4")
					SZ4->Z4_NUM    := M->E2_NUM
					// Varre todos os campos do item.
					For _nAux2 := 1 to len(aHeader)
						// Soma os valores da prestacao.
						Do case
						   case AllTrim(aHeader[_nAux2, 2]) == "Z4_NUM"    
						        _cNum      := aCols[_nAux1, _nAux2]
                           case AllTrim(aHeader[_nAux2, 2]) == "Z4_ITEM"   
                                _cItem     := aCols[_nAux1, _nAux2]						   
                           case AllTrim(aHeader[_nAux2, 2]) == "Z4_NATUREZ"
                                _cNatSE5   := aCols[_nAux1, _nAux2]						   
                           case AllTrim(aHeader[_nAux2, 2]) == "Z4_NATDESC"
                                _cHistor   := aCols[_nAux1, _nAux2]						   
						   case AllTrim(aHeader[_nAux2, 2]) == "Z4_VALOR"  
						        _nValLiq   := aCols[_nAux1, _nAux2]                                                  
						        _nTotPrest += aCols[_nAux1, _nAux2]
                           case AllTrim(aHeader[_nAux2, 2]) == "Z4_DATA"   
                                _dCREDITO  := aCols[_nAux1, _nAux2]						   
						Endcase
						SZ4->(&(aHeader[_nAux2, 2])) := aCols[_nAux1, _nAux2]
					Next _nAux2
					SZ4->(msUnLock())

		            // Gera movimenta��o bancaria dos Itens                    
                   _cRP     := "P"         
                   _cNumbor := " "
                   SZ4SE5(_cNumero, _cItem, _cClifor, _cLoja, _cNumero, _cBenef, _nValLiq, _cNatSE5, _cBANCO, _cAGENCIA, _cCONTA, _dCREDITO, _cRP, _cNumbor)

				Endif
			Next _nAux1
			
            // Gera movimenta��o bancaria de estorno do t�tulo original
            _cRP     := "R"               
//			_nValLiq := SE2->E2_VALOR
            _nValLiq := _nTotPrest	//Alterado dia 02/03/10 pelo analista Emerson. Fazer o movimento de estorno pelo valor da Prestado Conta.
     

            DbSelectarea("SED")
            SED->(DbSetOrder(1))
            If cEmpAnt=='03'
	            SED->(DbSeek(xFilial("SED")+SE2->E2_NATUREZ))
            Else
            	If !SED->(DbSeek(xFilial("SED")+SE2->E2_NATUREZ))
            		dbOrderNickName('SUPORC')                  
            		DbSeek(xFilial("SED")+SE2->E2_NATUREZ)
            	EndIf
            EndIF
//          _cNatSE5 := "2.21.02" // SE2->E2_NATUREZ =="2.21.01"
            _cNatSE5 := SED->ED_NATEST
            _cNumbor := SE2->E2_NUMBOR
			_cNumAP  := SE2->E2_NUMAP            
            SZ4SE5(_cNumero, _cParcela, _cClifor, _cLoja, _cNumero, _cBenef, _nValLiq, _cNatSE5, _cBANCO, _cAGENCIA, _cCONTA, _dCREDITO, _cRP, _cNumbor, _cNumAp)

			// Gera o titulo de acerto da diferenca.
			_cNum     := M->E2_NUM
			_cFornece := M->E2_FORNECE
			_cLoja    := M->E2_LOJA
			_nDif     := SE2->E2_VALOR - _nTotPrest
/*			
			Do Case
				Case _nDif > 0
					// Gera titulo a receber.
					RecLock("SE1", .T.)
					SE1->E1_FILIAL  := xFilial("SE1")
					SE1->E1_TIPO    := "ACF"
					SE1->E1_PREFIXO := "ACF"
					SE1->E1_NUM     := _cNum
					SE1->E1_CLIENTE := _cFornece
					SE1->E1_LOJA    := _cLoja
					SE1->E1_NOMCLI  := U_GetCpoVal("A1_NOME", 1, xFilial("SA1") + _cFornece + _cLoja, .F.)
					SE1->E1_EMISSAO := dDataBase
					SE1->E1_VENCORI := DataValida(dDataBase + 1)
					SE1->E1_VENCTO  := DataValida(dDataBase + 1)
					SE1->E1_VENCREA := DataValida(dDataBase + 1)
					SE1->E1_VALOR   := _nDif
					SE1->E1_VLCRUZ  := _nDif
					SE1->E1_SALDO   := _nDif
					SE1->E1_STATUS  := "A"
					SE1->E1_FLUXO   := "N"
					SE1->E1_MOEDA   := 1
					SE1->E1_ORIGEM  := FunName()
					SE1->(msUnLock())
					
				Case _nDif < 0
					// Gera titulo a pagar.
					_nDif *= -(1 + (_nCPMFAliq / 100))  // Incrementa o CPFM.
					RecLock("SE2", .T.)
					SE2->E2_FILIAL  := xFilial("SE2")
					SE2->E2_TIPO    := "ACF"
					SE2->E2_PREFIXO := "ACF"
					SE2->E2_NUM     := _cNum
					SE2->E2_FORNECE := _cFornece
					SE2->E2_LOJA    := _cLoja
					SE2->E2_NOMFOR  := U_GetCpoVal("A2_NOME", 1, xFilial("SA2") + _cFornece + _cLoja, .F.)
					SE2->E2_EMISSAO := dDataBase
					SE2->E2_VENCTO  := DataValida(dDataBase + 1)
					SE2->E2_VENCREA := DataValida(dDataBase + 1)
					SE2->E2_VALOR   := _nDif
					SE2->E2_VLCRUZ  := _nDif
					SE2->E2_SALDO   := _nDif
					SE2->E2_MOEDA   := 1
					SE2->E2_FLUXO   := "N"
					SE2->E2_ORIGEM  := FunName()
					SE2->(msUnLock())
			EndCase
*/			
			End Transaction
		Endif
		
	Case _nOpc == 7  // Cancelar prestacao.
		
		// Trata os erros.
		If empty(E2_ADF)   // Baixado
			_cMsg := "N�o houve baixa da presta��o de conta para ser cancelada!!!"
			MsgAlert(_cMsg, "Aten��o")
			Return .F.
		Endif
		_lRet := U_cfina05a(2)
		If _lRet  // Usuario confirmou a operacao.
			Begin Transaction
			
			// Grava o numero do titulo a ser processado.
			_cNumTit := SE2->E2_NUM
			
			// Desmarca o titulo (adiantamento) como conta prestada e
			// o coloca de volta no fluxo de caixa.
			RecLock("SE2", .F.)
			SE2->E2_ADF   := ""
			SE2->E2_FLUXO := "S"
			SE2->(msUnLock())
			                                                                       
	        // Apaga as Movimentacoes Bancarias
   			_aDel := {}
            SE5->(dbSetOrder(7))
            If SE5->(dbSeek(xFilial("SE5")+"PC "+SE2->E2_NUM+SE2->E2_PARCELA+"   "+SE2->E2_FORNECE+SE2->E2_LOJA, .F.))
               While !Eof() .And. SE2->("PC "+E2_NUM+E2_PARCELA+"   "+E2_FORNECE+E2_LOJA)==SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
    			   aAdd(_aDel, SE5->(RecNo()))
                   SE5->(dbSkip())
			   EndDo
			EndIf
			For _nAux1 := 1 to len(_aDel)
				SE5->(dbGoTo(_aDel[_nAux1]))
				RecLock("SE5", .F.)
				SE5->(dbDelete())
				SE5->(msUnLock())
			Next _nAux1

			// Apaga os itens da prestacao de contas (SZ4).
			_aDel := {}
			SZ4->(dbSetOrder(1))  // Z4_FILIAL+Z4_NUM.
			SZ4->(dbSeek(xFilial("SZ4") + SE2->E2_NUM, .F.))
			Do While SZ4->(Z4_FILIAL + Z4_NUM) == xFilial("SZ4") + SE2->E2_NUM
				aAdd(_aDel, SZ4->(RecNo()))
				SZ4->(dbSkip())
			EndDo
			For _nAux1 := 1 to len(_aDel)
				SZ4->(dbGoTo(_aDel[_nAux1]))
				RecLock("SZ4", .F.)
				SZ4->(dbDelete())
				SZ4->(msUnLock())
			Next _nAux1
/*			
			// Apaga o titulo a receber ou a pagar gerado pela diferenca na prestacao.
			// Titulos a receber.
			_aDel := {}
			SE1->(dbSetOrder(1))  // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO.
			SE1->(dbSeek(xFilial("SE1") + "ACF" + _cNumTit, .F.))
			Do While SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM) == xFilial("SE1") + "ACF" + _cNumTit
				aAdd(_aDel, SE1->(RecNo()))
				SE1->(dbSkip())
			EndDo
			For _nAux1 := 1 to len(_aDel)
				SE1->(dbGoTo(_aDel[_nAux1]))
				RecLock("SE1", .F.)
				SE1->(dbDelete())
				SE1->(msUnLock())
			Next _nAux1
			
			// Titulos a pagar.
			// Limpa o filtro do cadastro de contas a pagar para que os registros
			// que nao fazem parte desse filtro possam ser apagados.
			_cFiltro := SE2->(dbFilter())  // Armazena o filtro padrao.
			_cAlias  := Alias()
			dbSelectArea("SE2")
			Set Filter to
			_aDel := {}
			SE2->(dbSetOrder(1))  // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.
			SE2->(dbSeek(xFilial("SE2") + "ACF" + _cNumTit, .F.))
			Do While SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM) == xFilial("SE2") + "ACF" + _cNumTit
				aAdd(_aDel, SE2->(RecNo()))
				SE2->(dbSkip())
			EndDo
			For _nAux1 := 1 to len(_aDel)
				SE2->(dbGoTo(_aDel[_nAux1]))
				RecLock("SE2", .F.)
				SE2->(dbDelete())
				SE2->(msUnLock())
			Next _nAux1
			
			// Refaz o filtro do cadastro de contas a pagar.
			Set Filter to &(_cFiltro)
			dbSelectArea(_cAlias)
*/			
			End Transaction
		Endif
		
	Case _nOpc == 999  // Legenda.
		Legenda()
		
	OtherWise
EndCase

// Retorna o posicionamento do alias SE2.
SE2->(RestArea(_aAreaE2))
Return(_lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA05b  �Autor  �Microsiga           � Data �  03/17/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida a digitacao do usuario na GetDados.                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� _nOpc:                                                     ���
���          � 1 - Para validar cada campo.                               ���
���          � 2 - Para validar a linha.                                  ���
���          � 3 - Para validar a aCols inteira.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Retorno   � .T. - Validacao ok.                                        ���
���esperado  � .F. - Nao validado.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function cfina05b(_nOpc)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _lRet := .F.
Local _nAux1
Local _nPsItem  := aScan(aHeader, {|x| AllTrim(x[2]) == "Z4_ITEM"})
Local _nPsNatur := aScan(aHeader, {|x| AllTrim(x[2]) == "Z4_NATUREZ"})
Local _nPsValor := aScan(aHeader, {|x| AllTrim(x[2]) == "Z4_VALOR"})
Local _nPsData  := aScan(aHeader, {|x| AllTrim(x[2]) == "Z4_DATA"})

Do Case
	Case _nOpc == 1  // Valida o campo.
		_lRet := .T.
		
	Case _nOpc == 2  // Valida a linha.
		If (_lRet := aCols[n, len(aHeader) + 1] .or.;
			!(empty(aCols[n, _nPsNatur]) .or.;
			empty(aCols[n, _nPsValor]) .or.;
			empty(aCols[n, _nPsData])))
			
			_nItem := val(aCols[len(aCols), _nPsItem]) + 1
		Else
			_cMsg := "Preencha todos os campos!!!"
			MsgAlert(_cMsg, "Aten��o")
		Endif
		
	Case _nOpc == 3  // Valida a aCols.
		If (_lRet := U_cfina05b(2))
			// Conta o total dos itens da prestacao de contas.
			_nTotal := 0
			For _nAux1 := 1 to len(aCols)
				If !aCols[_nAux1, len(aHeader) + 1]
					_nTotal += aCols[_nAux1, _nPsValor]
				Endif
			Next _nAux1
			
			Do Case
				Case M->E2_VALOR > _nTotal
					_cMsg := "O valor total da presta��o de conta (" +;
					AllTrim(Transform(_nTotal, tm(_nTotal, 14))) +;
					") � menor que o valor do adiantamento ao funcion�rio (" +;
					AllTrim(Transform(M->E2_VALOR, tm(M->E2_VALOR, 14))) + "). " + _EOL + _EOL +;
					"Todos os dados est�o corretos?"
//					"A finaliza��o da presta��o dessa conta implicar� na cria��o " +;
//					"de um t�tulo a receber do funcion�rio." + _EOL + _EOL +;
					
				Case M->E2_VALOR < _nTotal
					_cMsg := "O valor total da presta��o de conta (" +;
					AllTrim(Transform(_nTotal, tm(_nTotal, 14))) +;
					") � maior que o valor do adiantamento ao funcion�rio (" +;
					AllTrim(Transform(M->E2_VALOR, tm(M->E2_VALOR, 14))) + "). " + _EOL + _EOL +;
					"Todos os dados est�o corretos?"
//					"A finaliza��o da presta��o dessa conta implicar� na cria��o " +;
//					"de um t�tulo a pagar ao funcion�rio." + _EOL + _EOL +;
					
				Case M->E2_VALOR == _nTotal
					_cMsg := "O valor total da presta��o de conta (" +;
					AllTrim(Transform(_nTotal, tm(_nTotal, 14))) +;
					") bate exatamente com o valor do adiantamento ao funcion�rio (" +;
					AllTrim(Transform(M->E2_VALOR, tm(M->E2_VALOR, 14))) + ")." + _EOL + _EOL +;
					"Todos os dados est�o corretos?"
					
			EndCase
			_lRet := MsgYesNo(_cMsg, "Aten��o")
			If _lRet
				If (M->E2_VALOR > _nTotal) .or. (M->E2_VALOR < _nTotal)
					cObs := Space(50)
					DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Observacao da Diferen�a") FROM 0,0 TO 130,382 OF oDlg1 PIXEL STYLE DS_MODALFRAME
					oDlg1:lEscClose := .F.
					@ 06,06 TO 46,177 LABEL "Observacao" OF oDlg1 PIXEL
					@ 25, 15 MSGET cObs Valid(!Empty(cObs))  PICTURE "@!" SIZE 150,10 PIXEL OF oDlg1
					DEFINE SBUTTON FROM  050, 150 TYPE  1 ENABLE ACTION (oDLg1:End()) OF oDLg1
					ACTIVATE MSDIALOG oDlg1 CENTER
				EndIf
			Endif
		Endif
EndCase
Return(_lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Legenda   �Autor  � Felipe Raposo      � Data �  10/18/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Exibe a legenda ou retorna a matriz referente a legenda    ���
���          � para a mBrowse.                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� _uPar:                                                     ���
���          �      0 - Retorna a matriz.                                 ���
���          �    nil - Exibe a legenda na tela.                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Legenda(_uPar)

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local _uRet, _aFlag

_aLeg := {;
{"BR_VERDE",    "Adiantamento normal."},;
{"BR_AMARELO",  "Adiantamento baixado parcialmente."},;
{"BR_PRETO",    "Adiantamento baixado totalmente."},;
{"BR_VERMELHO", "Conta prestada."}}

If ValType(_uPar) != "U" .and. _uPar == 0
	_aFlag := {;
	{'!empty(E2_ADF)',       _aLeg[4][1]},;  // Vermelho.
	{'E2_SALDO == E2_VALOR', _aLeg[1][1]},;  // Verde.
	{'E2_SALDO >  0',        _aLeg[2][1]},;  // Amarelo.
	{'E2_SALDO == 0',        _aLeg[3][1]}}   // Preto.
	_uRet := _aFlag
Else
	BrwLegenda(cCadastro, "Legenda", _aLeg)
Endif
Return (_uRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SZ4SE5   �Autor  � Andy Pudja         � Data �  09/02/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria movimentacao bancaria, de acordo com os valores pas-  ���
���          � sados por parametro.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CIEE.                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SZ4SE5(_cNumero, _cParcela, _cClifor, _cLoja, _cdocumento, _cBenef, _nValLiq, _cNatSE5, _cBANCO, _cAGENCIA, _cCONTA, _dCREDITO, _cRP)

// Verifica se as variaveis foram passadas por parametro.
// Se nao foram, assumir o valor zero.

RecLock("SE5", .T.)
SE5->E5_FILIAL  := xFilial("SE5")
SE5->E5_MOEDA   := "PC"
SE5->E5_TIPODOC := "PC"      //_cTipoDoc
SE5->E5_RECPAG  := _cRP      // "P" ou "R"
SE5->E5_DATA    := _dCREDITO 
SE5->E5_VENCTO  := _dCREDITO 
SE5->E5_NUMERO  := _cNumero  // Numero do Bordero
SE5->E5_PREFIXO := "PC "     // _cE2Pref  
SE5->E5_TIPO    := ""        // _cE2Tipo
SE5->E5_VALOR   := _nValLiq
SE5->E5_VLDESCO := 0         // _nDesc
SE5->E5_VLJUROS := 0         // _nJuros
SE5->E5_VLMULTA := 0         // _nMulta
SE5->E5_NATUREZ := _cNatSE5  // NATUREZA
SE5->E5_BANCO   := _cBANCO
SE5->E5_AGENCIA := _cAGENCIA
SE5->E5_CONTA   := _cCONTA
SE5->E5_HISTOR  := "Prestacao de Conta"
SE5->E5_VLMOED2 := xMoeda(_nValLiq, 1, 2, dDataBase, 2)
SE5->E5_LA      := "N"
SE5->E5_CLIFOR  := _cClifor
SE5->E5_LOJA    := _cLoja
SE5->E5_DTDIGIT := _dCREDITO 
SE5->E5_MOTBX   := "NOR"
SE5->E5_RECONC  := "x"       // J� reconciliado
SE5->E5_SEQ     := "01"
SE5->E5_DTDISPO := _dCREDITO             
/*
If !Empty(_cParcela)
  SE5->E5_DOCUMEN := "PC "+_cNumero+"/"+_cParcela
Else                                       
  SE5->E5_DOCUMEN := "PC "+_cNumbor
EndIf  
*/
If _cRP == "P"
  If !Empty(_cParcela)
    SE5->E5_DOCUMEN := "PC "+_cNumero+"/"+_cParcela
  Else                                       
    SE5->E5_DOCUMEN := "PC "+_cNumbor
  EndIf  
Else
  If !Empty(_cNumAp)
    SE5->E5_DOCUMEN := ""
    SE5->E5_NUMAP   := _cNumAp
  Else
    SE5->E5_DOCUMEN := "PC "+_cNumbor      
  EndIf
EndIf
SE5->E5_BENEF   := _cBenef
SE5->(msUnLock())
Return
