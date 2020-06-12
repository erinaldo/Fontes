#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT130FOR  บ Autor ณ Felipe Raposo      บ Data ณ  19/06/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada para a escolha via MarkBrow dos fornece-  บฑฑ
ฑฑบ          ณ dores que farao parte da cotacao de compras.               บฑฑ
ฑฑบ          ณ Programa: MATA130                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Matriz multidimensional com a seguinte estrutura:          บฑฑ
ฑฑบ          ณ PARAMIXB[x][1] -> Codigo do fornecedor.                    บฑฑ
ฑฑบ          ณ PARAMIXB[x][2] -> Loja do fornecedor.                      บฑฑ
ฑฑบ          ณ PARAMIXB[x][3] -> ""  // Sempre.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Uma matriz semelhante a PARAMIXB.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MT130FOR()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aAreaSA2, _aRet := {}, _cFilSA2, _cMsg, _aCmps, _nOpc

// Essa variavel sera nula (tipo U) somente se for a primeira
// vez que passa por aqui.

If ValType(_PARAMIXB2) == "U"
	
	// Salva o que eh necessario antes do processamento.
//	_aAreaSA2 := SA2->(GetArea())
	
	// Filtra os registros do SA2 para exibir somente o que
	// estiver na variavel PARAMIXB.
//	_cFilSA2 := "aScan(PARAMIXB, {|x| x[1] + x[2] == A2_COD + A2_LOJA}) != 0"
//	SA2->(dbSetFilter({|| &_cFilSA2}, _cFilSA2))
//	SA2->(dbSetOrder(1))
//	SA2->(dbGoTop())

	_aTmp := {}
	aAdd(_aTmp,{"OK"      ,"C", 02,0})
	aAdd(_aTmp,{"CODIGO"  ,"C", 06,0})
	aAdd(_aTmp,{"COD"     ,"C", 06,0})
	aAdd(_aTmp,{"LOJA"    ,"C", 02,0})
	aAdd(_aTmp,{"NOME"    ,"C", 60,0})

	dbCreate("TMP",_aTmp)
	dbUseArea(.T.,,"TMP","TMP",.F.)
	_cIndTMP := CriaTrab(NIL,.F.)
	_cChave   := "CODIGO"
	IndRegua("TMP",_cIndTMP,_cChave,,,"Indice Temporario...")

	For _nI := 1 to Len(PARAMIXB)
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek(xFilial("SA2")+PARAMIXB[_nI,1]+PARAMIXB[_nI,2])
		If SA2->A2_MSBLQL <> "1" //Diferente de 1-Sim, nao esta bloqueado
			RecLock("TMP",.T.)
			TMP->CODIGO := PARAMIXB[_nI,1]+PARAMIXB[_nI,2]
			TMP->COD    := PARAMIXB[_nI,1]
			TMP->LOJA   := PARAMIXB[_nI,2]
			TMP->NOME   := alltrim(SA2->A2_NOME)
			MsUnLock()
		EndIf
	Next _nI

	DbSelectArea("TMP")
	DbGoTop()
	aCampos:= {}
	aAdd(aCampos,{"OK"      ,""         })
	aAdd(aCampos,{"CODIGO"  ,"Codigo"   })
	aAdd(aCampos,{"NOME"    ,"Nome"     })
	
	// Monta uma MarkBrow com os fornecedores para
	// serem escolhidos pelo usuario.
//	_aCmps := GetCmp("SA2", {"A2_OK"})
	//_nOpc := MontaBrowse("SA2", _aCmps, _aRet)
//	_nOpc := MontaBrowse("SA2", _aCmps)
	_nOpc := MontaBrowse("TMP", aCampos)
	// Monta a matriz que sera retornada, contendo os
	// fornecedores escolhidos pelo usuario.
	_aRet := {}

	If _nOpc == 1 
		TMP->(dbGoTop())
		Do While TMP->(!eof())
			If Marked("OK")     // Verifica se o registro foi marcado.
				aAdd(_aRet, {TMP->COD, TMP->LOJA, ""})
			EndIf
			TMP->(dbSkip())
		EndDo
		_PARAMIXB2 := _aRet
	Endif
	
	// Retorna as condicoes anteriores ao processamento.
//	SA2->(dbClearFilter())
//	SA2->(RestArea(_aAreaSA2))
ElseIf !(ValType(_PARAMIXB2) == "C" .and. _PARAMIXB2 == "Cancelado")
	// Se nao foi cancelado pelo usuario.
	_aRet := _PARAMIXB2
Endif

Return (_aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetCmp    บAutor  ณ Felipe Raposo      บ Data ณ  24/06/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para retornar os campos do alias passado por parame-บฑฑ
ฑฑบ          ณ tro. Os campos sao obtidos do dicionario de dados.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณAlias  - O alias da tabela que se deseja retornar os campos.บฑฑ
ฑฑบ          ณCampos - Os campos que virao na frente.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณUma matriz multidimensional com o seguinte lay-out.         บฑฑ
ฑฑบ          ณ_aRet[x][1] -> Campo                                        บฑฑ
ฑฑบ          ณ_aRet[x][2] -> Titulo                                       บฑฑ
ฑฑบ          ณ_aRet[x][3] -> Picture                                      บฑฑ
ฑฑบ          ณ_aRet[x][4] -> Tamanho                                      บฑฑ
ฑฑบ          ณ_aRet[x][5] -> Decimal                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCmp(_cAlias, _aCmps)
Local _aRet := {}, _aX3Area := SX3->(GetArea())

SX3->(dbSetOrder(2))
For _iAux1 := 1 to len(_aCmps)
	SX3->(dbSeek(_aCmps[_iAux1]))
	aAdd(_aRet, {SX3->X3_CAMPO, "","@!","2","0"})
Next _iAux1

SX3->(dbSetOrder(1)); SX3->(dbSeek(_cAlias))
Do While SX3->X3_ARQUIVO == _cAlias
	If  X3USO(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and.;
		SX3->X3_BROWSE == "S" .and. SX3->X3_CONTEXT != "V"
		aAdd(_aRet, {SX3->X3_CAMPO, AllTrim(SX3->X3_TITULO), SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL})
	Endif
	SX3->(dbSkip())
EndDo
SX3->(RestArea(_aX3Area))
Return (_aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณMontaBrowseบAutor ณFelipe Raposo       บ Data ณ  24/06/02   บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a MarkBrowse para a selecao dos fornecedores que     บฑฑ
ฑฑบ          ณ farao parte da cotacao de compra.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaBrowse(_cAlias, _aCmps)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nLin, _nLinTam, _nRetorno
Private cCadastro, _cCmpMark, _aOpc
_cCmpMark := _aCmps[1][1]
_aOpc := {_cAlias, _aCmps}
cCadastro := "Fornecedores - Cota็ใo " + SC1->C1_NUM + ' - ' +;
U_GetCpoVal("B1_DESC", 1, xFilial("SB1") + SC1->C1_PRODUTO, .F.) // Desc. do produto.
//SC1->C1_PRODUTO

_nLin := 06; _nLinTam := 17
@ 200, 001 to 450, 563 Dialog oDlg1 Title cCadastro
@ 006, 005 to 106, 220 Browse _cAlias Fields _aCmps mark _cCmpMark object _oMark
@ _nLin, 225 Button "_OK"             size 55, 15 action MarkOpc(_nRetorno := 01, .T.); _nLin += _nLinTam
@ _nLin, 225 Button "_Cancelar"       size 55, 15 action MarkOpc(_nRetorno := 99, .T.); _nLin += _nLinTam
@ _nLin, 225 Button "_Visualizar"     size 55, 15 action MarkOpc(_nRetorno := 05, .T.); _nLin += _nLinTam
@ _nLin, 225 Button "_Marcar tudo"    size 55, 15 action MarkOpc(_nRetorno := 02, .T.); _nLin += _nLinTam
@ _nLin, 225 Button "_Desmarcar tudo" size 55, 15 action MarkOpc(_nRetorno := 03, .T.); _nLin += _nLinTam
@ _nLin, 225 Button "_Inverter"       size 55, 15 action MarkOpc(_nRetorno := 04, .T.); _nLin += _nLinTam
MarkOpc(3, .F.)   // desmarca os fornecedores antes de exibi-los.
Activate dialog oDlg1 Centered

DbSelectArea("TMP")
DbCloseArea()
fErase("TMP.DBF")

Return (_nRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณMarkOpc   บAutor  ณ Felipe Raposo      บ Data ณ  24/06/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa uma funcao de acordo com o parametro passado:      บฑฑ
ฑฑบ          ณ 1 - Confirma processamento.                                บฑฑ
ฑฑบ          ณ 2 - Marca todos os itens da MarkBrowse.                    บฑฑ
ฑฑบ          ณ 3 - Desmarca todos os itens da MarkBrowse.                 บฑฑ
ฑฑบ          ณ 4 - Inverter a selecao.                                    บฑฑ
ฑฑบ          ณ 5 - Visualizar.                                            บฑฑ
ฑฑบ          ณ 99 - Cancelar processamento.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarkOpc(_nOpc, _lRefresh)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nPos, _cMarca, _cDesmarca
Local _cAlias, _aCmps, _lOk

_cAlias    := _aOpc[1]
//_aCmps     := _aOpc[2]
//_aRot      := _aOpc[3]
_cMarca    := GetMark()
_cDesmarca := ThisMark()

dbSelectArea(_cAlias)
Do Case
	Case _nOpc == 1  // Ok.
		_nPos := RecNo()
		_lOk  := .F.
		// Verificar se tem mais de um registro marcado.
		dbGoTop()
		Do While !eof() .and. !_lOk
			If Marked(_cCmpMark); _lOk := .T.; Endif
			dbSkip()
		EndDo
		If _lOk; Close(oDlg1); Endif
		dbGoTo(_nPos)
		
	Case _nOpc == 99  // Cancelar.
		U_MT130WF()  // Desmarca as solicitacoes de compra.
		_PARAMIXB2 := "Cancelado"
		Close(oDlg1)
		
	Case _nOpc == 2  // Marca tudo.
		_nPos := RecNo()
		dbGoTop()
		Do While !eof()
			RecLock(_cAlias, .F.)
			FieldPut(FieldPos(_cCmpMark), _cMarca)
			msUnLock()
			dbSkip()
		EndDo
		dbGoTo(_nPos)
		If _lRefresh; _oMark:oBrowse:Refresh(); Endif
		
	Case _nOpc == 3  // Desmarca tudo.
		_nPos := RecNo()
		dbGoTop()
		Do While !eof()
			RecLock(_cAlias, .F.)
			FieldPut(FieldPos(_cCmpMark), _cDesmarca)
			msUnLock()
			dbSkip()
		EndDo
		dbGoTo(_nPos)
		If _lRefresh; _oMark:oBrowse:Refresh(); Endif

	Case _nOpc == 4  // Inverter.
		_nPos := RecNo()
		dbGoTop()
		Do While !eof()
			_cCpoVal := If (Marked(_cCmpMark), _cDesmarca, _cMarca)
			RecLock(_cAlias, .F.)
			FieldPut(FieldPos(_cCmpMark), _cCpoVal)
			msUnLock()
			dbSkip()
		EndDo
		dbGoTo(_nPos)
		If _lRefresh; _oMark:oBrowse:Refresh(); Endif
		
	Case _nOpc == 5  // Visualizar
		AxVisual(_cAlias, RecNo(), 2)
		
EndCase
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT130WF   บAutor  ณ Felipe Raposo      บ Data ณ  11/09/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada  -  Programa: MATA130                     บฑฑ
ฑฑบ          ณ Apos a geracao das cotacoes.                               บฑฑ
ฑฑบ          ณ Executado apos atualizacao de arquivos na geracao de cota- บฑฑ
ฑฑบ          ณ coes                                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT130WF()
Private _aOpc, _cCmpMark
_PARAMIXB2 := nil
_cCmpMark := "C1_OK"
_aOpc := {"SC1"}
MarkOpc(3, .F.)   // desmarca as solicitacoes antes de exibi-las.
Return