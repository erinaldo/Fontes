#INCLUDE "rwmake.ch
#INCLUDE "totvs.ch"
#include "topconn.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOMA01
Atualizacao da cotacao de compra
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CCOMA01()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aAreaC8, _aCpos, _cPerg, _aSX1
Local _mFilComp, _mFilFech, _cUser, _cFiltro, _bFilBrw, _aIndexSC8 := {}

Private cCadastro, cDelFunc, cString

// Perguntas incluidas no sistema.
_cPerg := "CESTA05"
CriaSX1(_cPerg)

If Pergunte(_cPerg, .T.)
	
	// Armazena as condicoes do alias.
	_aAreaC8 := SC8->(GetArea())
	
	// Considera os parametros digitados pelo usuario.
	_mFilComp := (mv_par01 == 1)
	_mFilFech := (mv_par02 == 1)
//	_cUser    := If(empty(mv_par03), SubStr(cUsuario, 7, 15), mv_par03)
	_cUser    := If(empty(mv_par03), cUserName, mv_par03)
	
	// Filtra SC fechadas.
	_cFiltro := IIf (_mFilFech, "empty(C8_NUMPED)", "")
	
	// Filtra por comprador.
	_cFiltro += IIf (_mFilComp, IIf(empty(_cFiltro), "", " .and. ") + "alltrim(C8_XSOLICI) == '"+alltrim(_cUser) +"'", "")

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta um aRotina proprio.                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private aRotina := {;
	{"Pesquisar",      "AxPesqui",      0, 1},;
	{"Incluir",        "U_C2A01MAT(1)", 0, 4},;
	{"Alterar",        "U_C2A01MAT(2)", 0, 4},;
	{"Analisar",       "U_C2A01MAT(3)", 0, 4},;
	{"Fechar cota็ใo", "U_C2A01MAT(4)", 0, 4},;
	{"Excluir",        "U_C2A01MAT(5)", 0, 5},;
	{"Legenda",        "U_C2A01MAT(6)", 0, 4}}
	//{"Visualizar", "AxVisual", 0, 2},;
	//{"Alterar",    "AxAltera", 0, 4},;
	//{"Excluir",    "AxDeleta", 0, 5}}
	
	cCadastro := "Cota็ใo de compras"
	cDelFunc  := ".F."
	cString   := "SC8"
	_aCpos := {;   // Campo que aparecera no browser, antes dos outros.
	{"Cota็ใo",    "C8_NUM"},;
	{"Item",       "C8_ITEM"},;
	{"Fornecedor", "C8_FORNECE"},;
	{"Loja",       "C8_LOJA"}}
	dbSelectArea(cString)
	dbSetOrder(4)  // C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO.
	
	// Filtra o browser de acordo com os parametros informados pelo usuario.
	If !empty(_cFiltro)
		_bFilBrw := {|| FilBrowse(cString, @_aIndexSC8, @_cFiltro)}
		Eval(_bFilBrw)
	Endif

	// Exibe a tela com a lista de cotacoes ja filtrada.
	mBrowse(06, 01, 22, 75, cString, _aCpos,,,,, C2A01LEG(0))

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	EndFilBrw(cString, _aIndexSC8)
	
	// Retorna as condicoes anteriores do alias.
	SC8->(RestArea(_aAreaC8))
Endif
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C2A01MAT   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ  													 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
User Function C2A01MAT(_nOpc)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cMsg, _aCPAux1, _nAux1, _nAux2, _nAux3, _cAux1, _cAux2, _cAux3, _aAux1, _cFornAux
Local _aCotAux1, _cItem, _cCotAux, _cNumSC, _nPreco, _lPriX8 := .T.
Local _cC7_NUM, _aC7_NUM, _cGrpAprov, _cGrpCompr, _nTotLib, lFirstNiv
Local _aAreaA2, _aAreaB1, _aAreaC1, _aAreaC7, _aAreaC8, _aAreaE2, _aAreaY1
LOCAL _cNomeArq   := "SZI" + SM0->M0_CODFIL +"0"
// Armazenam as condicoes das tabelas antes do processamento.
Private _aCotProd,_nPrvOpc

// Variaveis do dialogo principal.
Private _cProdCot, _nJuros, _mObs,_dEmissao, aCols, aHeader, n
_mObs := SPACE(20)
// Variaveis do primeiro formulario.
Private _cCotacao1, _cFornCod1, _cPgtoCod1, _cFornLoj1, _cFornNom1, _cItem1, aVetor1, nList1, _nPrazo1
Private _nQTDE1, _nPRECO1, _nDESC1, _nVLDESC1, _nIPI1, _nISS1, _nFRETE1, _nDESP1, _nACERTO1, _nTotal1
Private _cNumPed1, _cNumSC1, _cItemSC1, _cCotSts1, _cNumPro1, _cIdent1

// Variaveis do segundo formulario.
Private _cCotacao2, _cFornCod2, _cPgtoCod2, _cFornLoj2, _cFornNom2, _cItem2, aVetor2, nList2, _nPrazo2
Private _nQTDE2, _nPRECO2, _nDESC2, _nVLDESC2, _nIPI2, _nISS2, _nFRETE2, _nDESP2, _nACERTO2, _nTotal2
Private _cNumPed2, _cNumSC2, _cItemSC2, _cCotSts2

// Variaveis do terceiro formulario.
Private _cCotacao3, _cFornCod3, _cPgtoCod3, _cFornLoj3, _cFornNom3, _cItem3, aVetor3, nList3, _nPrazo3
Private _nQTDE3, _nPRECO3, _nDESC3, _nVLDESC3, _nIPI3, _nISS3, _nFRETE3, _nDESP3, _nACERTO3, _nTotal3
Private _cNumPed3, _cNumSC3, _cItemSC3, _cCotSts3

// Variavel auxiliar ao processamento.
_nPrvOpc := _nOpc

// Armazenam as condicoes das tabelas antes do processamento.
_aAreaA2 := SA2->(GetArea())
_aAreaB1 := SB1->(GetArea())
_aAreaC1 := SC1->(GetArea())
_aAreaC7 := SC7->(GetArea())
_aAreaC8 := SC8->(GetArea())
_aAreaE2 := SE2->(GetArea())
_aAreaY1 := SY1->(GetArea())

// Valores iniciais das variaveis.
_nJuros := 0
_cFornCod1 := _cFornNom1 := _cFornCod2 := _cFornNom2 := _cFornCod3 := _cFornNom3 := Space(06)
_cPgtoCod1 := _cPgtoCod2 :=  _cPgtoCod3 := Space(03)
_cFornLoj1 := _cFornLoj2 := _cFornLoj3 := Space(02)
_cItem1 := _cItem2 := _cItem3 := Space(02)
_nPrazo1 := _nPrazo2 := _nPrazo3 := 0
aVetor1 := aVetor2  := aVetor3 := {{Trim(Transform(0, PesqPict('SZ3', 'Z3_VALOR'))), ctod("")}}
_nQTDE1 := _nPRECO1 := _nDESC1 := _nVLDESC1 := _nIPI1 := _nISS1 := _nFRETE1 := _nDESP1 := _nACERTO1 := _nTotal1 := 0
_nQTDE2 := _nPRECO2 := _nDESC2 := _nVLDESC2 := _nIPI2 := _nISS2 := _nFRETE2 := _nDESP2 := _nACERTO2 := _nTotal2 := 0
_nQTDE3 := _nPRECO3 := _nDESC3 := _nVLDESC3 := _nIPI3 := _nISS3 := _nFRETE3 := _nDESP3 := _nACERTO3 := _nTotal3 := 0
_dEmissao := CTOD("  /  /  ")
_cProdCot := SC8->C8_PRODUTO

Do Case
	Case _nOpc == 1  // Inclui cotacao.
		If empty(SC8->C8_NUMPED)
			_cCotacao1 := SC8->C8_NUM
			_cFornCod1 := CriaVar("C8_FORNECE")
			_cPgtoCod1 := CriaVar("C8_COND")
			_cFornLoj1 := CriaVar("C8_LOJA")
			_cItem1    := SC8->C8_ITEM
			_cFornNom1 := CriaVar("A2_NREDUZ")
			_nPrazo1   := CriaVar("C8_PRAZO")
			aVetor1    := U_C2A01CPG("", 1)
			_nQTDE1    := SC8->C8_QUANT
			_nPRECO1   := CriaVar("C8_PRECO")
			_nDESC1    := CriaVar("C8_DESC")
			_nVLDESC1  := CriaVar("C8_VLDESC")
			_nIPI1     := CriaVar("C8_ALIIPI")
			_nISS1     := CriaVar("C8_PICM")
			_nFRETE1   := CriaVar("C8_VALFRE")
			_nDESP1    := CriaVar("C8_DESPESA")
			_nACERTO1  := CriaVar("C8_XACERTO")  // Especifico.
			_nTotal1   := CriaVar("C8_TOTAL")
			_cNumPed1  := CriaVar("C8_NUMPED")
			_cNumSC1   := SC8->C8_NUMSC
			_cItemSC1  := SC8->C8_ITEMSC
			_cIdent1   := SC8->C8_IDENT
			Show1Form(_nOpc)
		Else
			_cMsg := "A cota็ใo " + SC8->C8_NUM + " jแ estแ encerrada!"
			MsgBox(_cMsg, "Aten็ใo", "INFO")
		Endif
		
	Case _nOpc == 2  // Alterar cotacao.
		If empty(SC8->C8_NUMPED)
			SA2->(dbSetOrder(1))  // A2_FILIAL+A2_COD+A2_LOJA.
			SA2->(dbSeek(xFilial("SA2") + SC8->(C8_FORNECE + C8_LOJA), .F.))
			// Atualiza campos.
			_cCotacao1 := SC8->C8_NUM
			_cFornCod1 := SC8->C8_FORNECE 
            _cPgtoCod1 := SC8->C8_COND
			_cFornLoj1 := SC8->C8_LOJA
			_cItem1    := SC8->C8_ITEM
			_cFornNom1 := SA2->A2_NREDUZ
			_nPrazo1   := SC8->C8_PRAZO
			aVetor1    := U_C2A01CPG(SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM), 1)
			_nQTDE1    := SC8->C8_QUANT
			_nPRECO1   := SC8->C8_PRECO
			_nDESC1    := SC8->C8_DESC
			_nVLDESC1  := SC8->C8_VLDESC
			_nIPI1     := SC8->C8_ALIIPI
			_nISS1     := SC8->C8_PICM
			_nFRETE1   := SC8->C8_VALFRE
			_nDESP1    := SC8->C8_DESPESA
			_nACERTO1  := SC8->C8_XACERTO
			_nTotal1   := SC8->C8_TOTAL
			_cNumPed1  := SC8->C8_NUMPED
			Show1Form(_nOpc)
		Else
			_cMsg := "A cota็ใo " + SC8->C8_NUM + " jแ estแ encerrada!"
			MsgBox(_cMsg, "Aten็ใo", "INFO")
		Endif
		
	Case _nOpc == 3  // Analisa cotacao.
		_cCotAux  := SC8->(C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO)
		_cNumSC   := SC8->C8_NUMSC
		SC8->(dbSetOrder(4))  // C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO.
		SC8->(dbGoTop()); SC8->(dbSeek(_cCotAux, .F.))  // Posiciona no primeiro registro da cotacao.
		_aCotProd := {}
		// Enquanto for a cotacao do mesmo produto.
		Do While SC8->(C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO) == _cCotAux
			If SC8->C8_TOTAL != 0 .and. SC8->C8_NUMSC == _cNumSC
				aAdd (_aCotProd, {SC8->(C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO), SC8->C8_TOTAL,SC8->(C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_IDENT)})
			Endif
			SC8->(dbSkip())
		EndDo
		// Ordena por total (segundo campo da matriz) em ordem crescente.
		_aCotProd := aSort(_aCotProd,,, { |x, y| x[2] < y[2] })
		If len(_aCotProd) > 0
			SC8->(dbSetOrder(1))  // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
			SA2->(dbSetOrder(1))  // A2_FILIAL+A2_COD+A2_LOJA.
			For _nAux1 := 1 to IIf (len(_aCotProd) > 3, 3, len(_aCotProd))
				_cAux1 := AllTrim(str(_nAux1))
				SC8->(dbSeek(xFilial("SC8") + _aCotProd[_nAux1, 1], .F.))
				SA2->(dbSeek(xFilial("SA2") + SC8->(C8_FORNECE + C8_LOJA), .F.))
				// Atualiza campos.
				_cCotacao&(_cAux1) := SC8->C8_NUM
				_cFornCod&(_cAux1) := SC8->C8_FORNECE
                _cPgtoCod&(_cAux1) := SC8->C8_COND				
				_cFornLoj&(_cAux1) := SC8->C8_LOJA
				_cItem&(_cAux1)    := SC8->C8_ITEM
				_cFornNom&(_cAux1) := SA2->A2_NREDUZ
				_nPrazo&(_cAux1)   := SC8->C8_PRAZO
				aVetor&(_cAux1)    := U_C2A01CPG(SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM), 1)
				_nQTDE&(_cAux1)    := SC8->C8_QUANT
				_nPRECO&(_cAux1)   := SC8->C8_PRECO
				_nDESC&(_cAux1)    := SC8->C8_DESC
				_nVLDESC&(_cAux1)  := SC8->C8_VLDESC
				_nIPI&(_cAux1)     := SC8->C8_ALIIPI
				_nISS&(_cAux1)     := SC8->C8_PICM
				_nFRETE&(_cAux1)   := SC8->C8_VALFRE
				_nDESP&(_cAux1)    := SC8->C8_DESPESA
				_nACERTO&(_cAux1)  := SC8->C8_XACERTO
				_nTotal&(_cAux1)   := SC8->C8_TOTAL
				_cNumPed&(_cAux1)  := SC8->C8_NUMPED
				_cCotSts&(_cAux1)  := SC8->C8_XCOTSTS
			Next _nAux1
			_mObs    := SC8->C8_XOBSMEM
			_dEmissao :=  SC8->C8_EMISSAO
			Show3Forms(_nOpc)
    		DbselecTarea("SZI")
            DBSETORDER(1)    
            IF DBSEEK(XFILIAL("SZI")+_cCotacao1)
               _cQuery := " DELETE FROM "+_cNomeArq+" WHERE ZI_NUMSC  = '" +_cCotacao1+"'"
               TCSQLEXEC(_cQuery)
               ENDIF              
             DbselecTarea("SC8")

		Else
			_cMsg := "Nใo existe nenhuma proposta para essa cota็ใo!!!"
			MsgAlert(_cMsg, "Aten็ใo")
		Endif
		
	Case _nOpc == 4  // Fechar cotacao.
		_cCotAux := SC8->C8_NUM
		_cNumSC  := SC8->C8_NUMSC
		_cAux1   := SC8->(C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO)
		
		If !empty(SC8->C8_NUMPED)
			_cMsg := "A cota็ใo " + SC8->C8_NUM + " jแ estแ encerrada!"
			MsgBox(_cMsg, "Solicita็ใo " + _cNumSC)
			Return //Exit
		Endif
		_cMsg := "Deseja fechar a cota็ใo " + SC8->C8_NUM + "?"
		If MsgYesNo(_cMsg, "Solicita็ใo " + _cNumSC)
			SC8->(dbSetOrder(3))  // C8_FILIAL+C8_NUM+C8_PRODUTO+C8_FORNECE+C8_LOJA+C8_NUMPED+C8_ITEMPED.
			SC8->(dbGoTop()); SC8->(dbSeek(xFilial("SC8") + _cCotAux, .F.))  // Posiciona no primeiro registro da cotacao.
			// Variaveis auxiliares.
			_aCotAux1 := {}  // Cotacao x Fornecedor.
			// _aCotAux1[n, 1] - Cotacao (RecNo).
			// _aCotAux1[n, 2] - Fornecedor + Loja.
			// _aCotAux1[n, 3] - Outra matriz contendo as parcelas.
			
			// Enquanto for a mesma cotacao.
			// Armazena em variaveis a(s) cotacao(oes) escolhida(s) para auxiliar
			// no processamento mais adiante.
			Do While SC8->(C8_FILIAL+C8_NUM) == xFilial("SC8") + _cCotAux
				// Status da cotacao.
				// 1 - Cotacao escolhida.
				// 2 - Cotacao nao escolhida.
				If SC8->C8_XCOTSTS == "1" .and. empty(SC8->C8_NUMPED)
					If SC8->C8_TOTAL > 0
						// C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO (SINDEX 4)
						_cAux1 := SC8->(C8_NUM + C8_IDENT + C8_PRODUTO)                       // Ordem 4 do SC8.
						_cAux2 := SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM)	// Ordem 1 do SZ3.
						// Matriz que contem a cotacao vencedora e o fornecedor vencedor.
						aAdd (_aCotAux1, {SC8->(RecNo()), SC8->(C8_FORNECE + C8_LOJA), U_C2A01CPG(_cAux2, 2)})
					Else
						_cMsg := "A cota็ใo escolhida nใo foi atualizada junto ao fornecedor!"
						MsgAlert(_cMsg, "Aten็ใo")
						Exit
					Endif
				Endif
				SC8->(dbSkip())
			EndDo
			
			// Testa se houve alguma cotacao escolhida para virar pedido.
			If len(_aCotAux1) <= 0
				_cMsg := "A cota็ใo " + _cCotAux + " nใo tem um fornecedor vencedor!"
				MsgBox(_cMsg, "Solicita็ใo " + _cNumSC)
				Return //Exit
			Endif
			
			// Ordena por fornecedor (segundo campo da matriz) em ordem crescente, para
			// poder aglutinar as cotacoes de um mesmo fornecedor em um unico pedido.
			_aCotAux1 := aSort(_aCotAux1,,, {|x, y| x[2] < y[2]})
			
			Begin Transaction
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Cria o pedido de compra.                                        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			SA2->(dbSetOrder(1))  // A2_FILIAL+A2_COD+A2_LOJA.
			SB1->(dbSetOrder(1))  // B1_FILIAL+B1_COD.
			SC1->(dbSetOrder(5))  // C1_FILIAL+C1_COTACAO+C1_PRODUTO+C1_IDENT.
			SC7->(dbSetOrder(1))  // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN.
			SC8->(dbSetOrder(4))  // C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO.
			SE2->(dbSetOrder(1))  // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.
			SY1->(dbSetOrder(3))  // Y1_FILIAL+Y1_USER.
			SZ3->(dbSetOrder(1))  // Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA.
			_cFornAux := ""; _aC7_NUM := {}
			
           _nItem    := 1 
			
			For _nAux1 := 1 to len(_aCotAux1)
				If _cFornAux != _aCotAux1[_nAux1, 2]
					If !_lPriX8
						ConfirmSX8()
					Endif
					_cC7_NUM  := GetSX8Num("SC7", "C7_NUM")
					_lPriX8 := .F.
					// Armazena os pedidos criados para processar o grupo
					// de liberacao de pedidos posteriormente.
					aAdd (_aC7_NUM, _cC7_NUM)
//					_nItem    := 1  // Na Grava็ใo do Pedido os itens estใo repetidos  CFB - 15/06/04 10H05
					_cFornAux := _aCotAux1[_nAux1, 2]
					If SC7->(dbSeek(xFilial("SC7") + _cC7_NUM, .F.))
						_cMsg := "Jแ existe o pedido de compra de n๚mero " + _cC7_NUM + CRLF +;
						"e o sistema gerou esse n๚mero novamente." + CRLF +;
						"Isso pode misturar os dois pedidos de compra com o mesmo n๚mero." + CRLF +;
						"Para evitar que isso ocorra o sistema irแ abortar." + CRLF + CRLF +;
						"Favor informar o administrador do sistema."
						MsgAlert(_cMsg, "Aten็ใo")
						"Erro forcado: num. do PC " + 1  // Forca o erro para o sistema abortar.
					Endif
				Endif
				// Gera o pedido de compra.
				// Ordem 4 - C1_FILIAL+C1_COTACAO+C1_PRODUTO+C1_IDENT
				SC8->(dbGoTo(_aCotAux1[_nAux1, 1]))
				SB1->(dbSeek(xFilial("SB1") + SC8->C8_PRODUTO, .F.))
				SC1->(dbSeek(xFilial("SC1") + SC8->(C8_NUM + C8_PRODUTO + C8_IDENT), .F.))
				_cItem := StrZero(_nItem++, len(SC7->C7_ITEM))
				/* Inclui o pedido */
				RecLock("SC7", .T.)
				SC7->C7_FILIAL  := xFilial("SC7")
				SC7->C7_FILENT  := xFilial("SC7")
				SC7->C7_NUM     := _cC7_NUM
				SC7->C7_FORNECE := SC8->C8_FORNECE
				SC7->C7_LOJA    := SC8->C8_LOJA
				SC7->C7_ITEM    := _cItem // SC8->C8_ITEMSC //_cItem  / Para o pedido estava gravando o mesmo item da cota็ใo qdo. deveria ser SEQUENCIAL CFB 15/06/04
				SC7->C7_NUMSC   := SC8->C8_NUMSC
				SC7->C7_ITEMSC  := SC8->C8_ITEMSC
				SC7->C7_QTDSOL  := SC8->C8_QUANT
				SC7->C7_NUMCOT  := SC8->C8_NUM
				SC7->C7_PRODUTO := SC8->C8_PRODUTO
				SC7->C7_DESCRI  := SB1->B1_DESC  // DESCR. PRODUTO.

				SC7->C7_ESPEC   := SB1->B1_XESPEC  // ESPECIFICACAO PRODUTO.
				
				SC7->C7_UM      := SC8->C8_UM
				SC7->C7_SEGUM   := SC8->C8_SEGUM
				SC7->C7_QUANT   := SC8->C8_QUANT
				SC7->C7_QTSEGUM := SC8->C8_QTSEGUM
//				_nPreco := SC8->(C8_TOTAL / C8_QUANT)
				_nPreco := SC8->C8_PRECO
				_nTotal := SC8->(C8_TOTAL - C8_DESPESA - C8_VALFRE - C8_VALIPI)
				// _nPreco := SC8->C8_PRECO - SC8->(C8_VLDESC / C8_QUANT)
				// Arredonda para baixo as casas apos os centavos.
				_nFator := 10 ^ TamSX3("C7_PRECO")[2]   // 10.000,00
				_nPreco := int(_nPreco * _nFator) / _nFator
				SC7->C7_PRECO   := _nPreco
				SC7->C7_TOTAL   := _nPreco * SC8->C8_QUANT
				SC7->C7_DESPESA := SC8->C8_DESPESA
				SC7->C7_VLDESC  := ((_nPreco * SC8->C8_QUANT) - _nTotal)  // DESCONTO ($).
				SC7->C7_VALFRE  := SC8->C8_VALFRE
				//SC8->(C8_QUANT * C8_PRECO - C8_VLDESC + C8_XACERTO)
				// O desconto nao saira destacado no pedido. Ele sera
				// calculado e embutido no valor unitario.
				// SC7->C7_DESC1   := SC8->C8_DESC1  // DESCONTO (%).
				// SC7->C7_DESC    := SC8->C8_DESC   // DESCONTO (%).
				// SC7->C7_VLDESC  := SC8->C8_VLDESC // DESCONTO ($).
				SC7->C7_BASEIPI := SC8->C8_BASEIPI  // IPI.
				SC7->C7_IPI     := SC8->C8_ALIIPI
				SC7->C7_VALIPI  := SC8->C8_VALIPI
				// SC7->C7_BASEICM :=  // ICMS.
				// SC7->C7_PICM    :=
				// SC7->C7_VALICM  :=
				SC7->C7_TES     := SB1->B1_TE
				SC7->C7_CC      := SC1->C1_CC
				SC7->C7_EMISSAO := dDataBase
				SC7->C7_DATPRF  := DataValida(SC8->C8_PRAZO + dDataBase) // DATA ENTREGA
				SC7->C7_TIPO    := 1
				SC7->C7_LOCAL   := SB1->B1_LOCPAD
				SC7->C7_OBS     := SC8->C8_OBS
				SC7->C7_COND    := SC8->C8_COND
				SC7->C7_FLUXO   := "S"
				SC7->C7_PENDEN  := "N"
				SC7->C7_USER    := RetCodUsr()  // __cUserID // Cod. do usuario.
				SC7->C7_TPFRETE := "C"   // CIF
				SC7->C7_MOEDA   := 1
				SC7->C7_TXMOEDA := 1
				SC7->C7_PENDEN  := "N"
				SC7->C7_CONAPRO := "L"
				SC7->C7_ESPEC	:= SC1->C1_XESPEC 		//Acrescentado pelo analista Emerson para trazer a ESPECIFICAO do produto. dia 23/02/2010

				SC7->C7_RATEIO	:= "2" 					//Acrescentado pelo analista Emerson dia 03/05/2012. Campo novo na versao 11 inicializador Padrao igual a NAO.
				/*
				// Aplicar a rotina de acordo com o programa de
				// inclusao de pedido de compra.
				SC7->C7_CONAPRO :=
				SC7->C7_GRUPCOM :=
				SC7->C7_APROV   :=
				*/
				SC7->(msUnLock())
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Cria os titulos a pagar no financeiro.                          ณ
				//ณ Caso o titulo ja exista, somente incrementa o valor.            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				SA2->(dbSeek(xFilial("SA2") + SC8->(C8_FORNECE + C8_LOJA), .F.))
				// Varre toda a matriz que contem a condicao de pagto. da cotacao,
				// ou seja, processa todas as parcelas.
				_nAux3 := len(_aCotAux1[_nAux1, 3])  // Parcelas.
				For _nAux2 := 1 to _nAux3
					_cCotAux := _aCotAux1[_nAux1, 3][_nAux2]
					SZ3->(dbSeek(xFilial("SZ3") + _cCotAux, .F.))
					If SZ3->Z3_TIPO == "P" .or.;   // Pagto. a partir do pedido.
						SZ3->Z3_TIPO == "D" // Uma data especifica.
						_cAux1 := IIf (_nAux3 > 1, char(64 + val(SZ3->Z3_PARCELA)), "")  // Parcela.
						_cAux2 := "PC " + _cC7_NUM + _cAux1  // Chave do titulo.
						// Indice 1 - E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA.
						If  SE2->(dbSeek(xFilial("SE2") + _cAux2, .F.)) .and.;
							SE2->E2_VENCTO == SZ3->Z3_DATA
							RecLock("SE2", .F.)
							SE2->E2_VALOR   += SZ3->Z3_VALOR
							SE2->E2_SALDO   += SZ3->Z3_VALOR
							SE2->E2_VLCRUZ  += SZ3->Z3_VALOR
							SE2->(msUnLock())
						Else
							// Encontra a ultima parcela e incrementa um, para
							// nao gerar chaves duplicadas.
							_nAux4 := _nAux3
							Do While SE2->(dbSeek(xFilial("SE2") + _cAux2, .F.))
								_nAux4 ++
								_cAux1 := char(64 + val(SZ3->Z3_PARCELA))
								_cAux2 := "PC " + _cC7_NUM + _cAux1  // Chave do titulo.
							EndDo
							RecLock("SE2", .T.)
							SE2->E2_FILIAL  := xFilial("SE2")
							SE2->E2_TIPO    := "PC"
							SE2->E2_NUM     := _cC7_NUM
							SE2->E2_PREFIXO := "PC"
							SE2->E2_PARCELA := _cAux1
							SE2->E2_FORNECE := SC8->C8_FORNECE
							SE2->E2_LOJA    := SC8->C8_LOJA
							SE2->E2_NOMFOR  := SA2->A2_NOME
							SE2->E2_EMISSAO := dDataBase
							SE2->E2_VENCTO  := SZ3->Z3_DATA
							SE2->E2_VENCREA := SZ3->Z3_DATA
							SE2->E2_VALOR   := SZ3->Z3_VALOR
							SE2->E2_EMIS1   := dDataBase
							SE2->E2_SALDO   := SZ3->Z3_VALOR
							SE2->E2_VENCORI := SZ3->Z3_DATA
							SE2->E2_MOEDA   := 1
							SE2->E2_RATEIO  := "N"
							SE2->E2_VLCRUZ  := SZ3->Z3_VALOR
							SE2->E2_FLUXO   := "S"
							SE2->E2_ORIGEM  := "FINA050" //"CESTA04"
							SE2->E2_DESDOBR := "N"
//							SE2->E2_MULTNAT := "2"
							SE2->E2_MULNATU := "2"							
							SE2->E2_PROJPMS := "2"
							SE2->E2_DIRF    := "2"
							SE2->E2_PEDIDO  := _cC7_NUM
							SE2->(msUnLock())
						Endif
					Endif
				Next _nAux2
				/**/
				
				// Variaveis auxiliares para a marcacao das cotacoes
				// e dos pedidos como fechados.
				_cAux1 := SC8->C8_NUM
				_cAux2 := SC8->C8_IDENT
				_cAux3 := SC8->C8_PRODUTO
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Atualiza a tabela de sol. compras (marca como SC atendida).     ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				_aAux1 := {}
				SC1->(dbGoTop()); SC1->(dbSeek(xFilial("SC1") + _cAux1 + _cAux3 + _cAux2, .T.))
				Do While SC1->(C1_FILIAL + C1_COTACAO + C1_PRODUTO + C1_IDENT) == xFilial("SC1") + _cAux1 + _cAux3 + _cAux2
					aAdd(_aAux1, SC1->(RecNo()))
					SC1->(dbSkip())
				EndDo
				For _nAux2 := 1 to len(_aAux1)
					SC1->(dbGoTo(_aAux1[_nAux2]))
					RecLock("SC1", .F.)
					SC1->C1_PEDIDO  := _cC7_NUM
					SC1->C1_ITEMPED := _cItem
					SC1->C1_FORNECE := SC8->C8_FORNECE
					SC1->C1_LOJA    := SC8->C8_LOJA
					SC1->C1_QUJE    += SC8->C8_QUANT
					SC1->C1_QUJE    := IIf (SC1->C1_QUJE > SC1->C1_QUANT, SC1->C1_QUANT, SC1->C1_QUJE)
					SC1->(msUnLock())
				Next _nAux2
				/**/
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Atualiza a tabela de cotacoes (marca como cotacao fechada).     ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				_aAux1 := {}
				SC8->(dbGoTop()); SC8->(dbSeek(xFilial("SC8") + _cAux1 + _cAux2 + _cAux3, .T.))
				Do While SC8->(C8_FILIAL + C8_NUM + C8_IDENT + C8_PRODUTO) == xFilial("SC8") + _cAux1 + _cAux2 + _cAux3
					aAdd(_aAux1, SC8->(RecNo()))
					SC8->(dbSkip())
				EndDo
				For _nAux2 := 1 to len(_aAux1)
					SC8->(dbGoTo(_aAux1[_nAux2]))
					RecLock("SC8", .F.)
					SC8->C8_NUMPED  := IIf (SC8->C8_XCOTSTS == "1", _cC7_NUM, Replicate("X", len(SC8->C8_NUMPED)))
					SC8->C8_ITEMPED := IIf (SC8->C8_XCOTSTS == "1", _cItem,   Replicate("X", len(SC8->C8_ITEMPED)))
					SC8->C8_MOTIVO  := IIf (SC8->C8_XCOTSTS == "1", "ENCERRADO AUTOMATICAMENTE", "")
					SC8->(msUnLock())
				Next _nAux2
				/**/
				
				// Ponto de entrada copiado do programa oficial.
				If ExistBlock("avalcot"); ExecBlock("avalcot"); Endif
				
			Next _nAux1
			ConfirmSX8()
			
			// Trecho do programa extraido do MATA120.PRX e adaptado para o CIEE.
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Gera arquivo de controle de alcadas SCR.                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			// Grupo de aprovador do ped. de compra.
			_cGrpAprov := SuperGetMv("MV_PCAPROV")
			For _nAux1 := 1 to len(_aC7_NUM)
				// Totaliza o pedido de compra.
				_nTotLib := 0
				SC7->(dbSeek(xFilial("SC7") + _aC7_NUM[_nAux1], .F.))
				Do While SC7->(C7_FILIAL + C7_NUM) == xFilial("SC7") + _aC7_NUM[_nAux1]
					_nTotLib += SC7->(C7_TOTAL + C7_DESPESA + C7_FRETE - C7_VLDESC)
					SC7->(dbSkip())
				EndDo
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Verifica o grupo de aprovacao do comprador.                  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If SY1->(dbSeek(xFilial("SY1") + RetCodUsr(), .F.))
					_cGrpAprov := If(!empty(SY1->Y1_GRAPROV), SY1->Y1_GRAPROV, _cGrpAprov)
					_cGrpCompr := SY1->Y1_GRUPCOM
				EndIf
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Ponto de entrada para alterar o grupo de aprovacao.          ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If ExistBlock("MT120APV")
					_cGrpAprov := SY1->(ExecBlock("MT120APV",.F.,.F.))
				EndIf
				
				MaAlcDoc({_aC7_NUM[_nAux1], "PC", _nTotLib,,, SC7->C7_APROV,, SC7->C7_MOEDA, SC7->C7_TXMOEDA, SC7->C7_EMISSAO}, SC7->C7_EMISSAO, 3)
				lFirstNiv := MaAlcDoc({_aC7_NUM[_nAux1], "PC", _nTotLib,,, _cGrpCompr,, SC7->C7_MOEDA, SC7->C7_TXMOEDA, SC7->C7_EMISSAO},, 1)
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Efetua a gravacao do campo de controle de aprovacao C7_CONAPRO  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				SC7->(dbSeek(xFilial("SC7") + _aC7_NUM[_nAux1]))
				Do While SC7->(C7_FILIAL + C7_NUM) == xFilial("SC7") + _aC7_NUM[_nAux1]
					RecLock("SC7", .F.)
					SC7->C7_GRUPCOM := _cGrpCompr
					SC7->C7_APROV   := _cGrpAprov
					SC7->C7_CONAPRO := IIf(lFirstNiv, "L", "B")
					SC7->(msUnLock())
					SC7->(dbSkip())
				EndDo
			Next _nAux1
			/**/
			
			End Transaction
		Endif  // Deseja fechar cotacao?
		
	Case _nOpc == 5  // Exclui.
		// Testa se a cotacao nao foi encerrada.
		If empty(SC8->C8_NUMPED)
			_cMsg := "Deseja excluir a cotacao inteira?"
			If MsgYesNo(_cMsg, "Aten็ใo")
				_cMsg := "Isso irแ excluir todos os ํtens em aberto da cotacao?" + CRLF +;
				"Deseja confirma?"
				If MsgYesNo(_cMsg, "Excluir cota็ใo " + SC8->C8_NUM)
					_aAux1 := {}
					_cAux1 := SC8->(C8_FILIAL+C8_NUM)
					_cAux2 := SC8->C8_NUM
					// Varre todos os itens da cotacao e armazena quais serao excluidos.
					SC8->(dbSetOrder(1))  // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
					Do While SC8->(C8_FILIAL+C8_NUM) == _cAux1
						If empty(C8_NUMPED)  // Se a cotacao nao estiver fechada, excluir.
							aAdd(_aAux1, SC8->(RecNo()))
						Endif
						SC8->(dbSkip())
					EndDo
					//
					// Exclui os itens da cotacao e marca SC como aberta.
					SC1->(dbSetOrder(5))  // C1_FILIAL+C1_COTACAO+C1_PRODUTO+C1_IDENT.
					For _nAux1 := 1 to len(_aAux1)
						// Exclui o item da cotacao.
						SC8->(dbGoto(_aAux1[_nAux1]))
						_cAux3 := SC8->(C8_PRODUTO + C8_IDENT)
						RecLock("SC8", .F.)
						SC8->(dbDelete())
						SC8->(msUnLock())
						// Marca SC como aberta.
						If SC1->(dbSeek(xFilial("SC1") + _cAux2 + _cAux3, .F.))
							RecLock("SC1", .F.)
							SC1->C1_COTACAO := ""
							SC1->C1_QUJE 	:= 0 //alterado dia 19/02/2013. Analista Emerson Natali. Ao excluir a Cotacao nao estava deixando a Solicitacao em aberta para o usuario Excluir. Faltava este campo.
							SC1->(msUnLock())
						Endif
					Next _nAux1
					//
				Endif
				
			Else
				// Exclui somente o item, caso o usuario confirme a operacao.
				SA2->(dbSetOrder(1))  // A2_FILIAL+A2_COD+A2_LOJA.
				SA2->(dbSeek(xFilial("SA2") + SC8->(C8_FORNECE + C8_LOJA), .F.))
				// Atualiza campos.
				_cCotacao1 := SC8->C8_NUM
				_cFornCod1 := SC8->C8_FORNECE
                _cPgtoCod1 := SC8->C8_COND				
				_cFornLoj1 := SC8->C8_LOJA
				_cItem1    := SC8->C8_ITEM
				_cFornNom1 := SA2->A2_NREDUZ
				_nPrazo1   := SC8->C8_PRAZO
				aVetor1    := U_C2A01CPG(SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM), 1)
				_nQTDE1    := SC8->C8_QUANT
				_nPRECO1   := SC8->C8_PRECO
				_nDESC1    := SC8->C8_DESC
				_nVLDESC1  := SC8->C8_VLDESC
				_nIPI1     := SC8->C8_ALIIPI
				_nISS1     := SC8->C8_PICM
				_nFRETE1   := SC8->C8_VALFRE
				_nDESP1    := SC8->C8_DESPESA
				_nACERTO1  := SC8->C8_XACERTO
				_nTotal1   := SC8->C8_TOTAL
				_cNumPed1  := SC8->C8_NUMPED
				Show1Form(_nOpc)
			Endif
		Else
			_cMsg := "A cota็ใo " + SC8->C8_NUM + " jแ estแ encerrada!"
			MsgInfo(_cMsg, "Aten็ใo")
		Endif
		
	Case _nOpc == 6  // Legenda.
		C2A01LEG()
EndCase

// Restaura as condicoes anteriores das tabelas.
SA2->(RestArea(_aAreaA2))
SB1->(RestArea(_aAreaB1))
SC1->(RestArea(_aAreaC1))
SC7->(RestArea(_aAreaC7))
SC8->(RestArea(_aAreaC8))
SE2->(RestArea(_aAreaE2))
SY1->(RestArea(_aAreaY1))
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C2A01CPO   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ  													 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C2A01CPO(_cForm, _cOpc)
Local _nTotItem, _lRet, _cMsg, _aArea, _nAux1, _nAux2
_cForm := AllTrim(str(_cForm))
_lRet  := .T.
Do Case
	Case _cOpc == "FORN"
		_aArea := SA2->(GetArea())
		If _cFornCod&(_cForm) != SA2->A2_COD
			SA2->(dbSetOrder(1))  // A2_FILIAL+A2_COD+A2_LOJA.
			SA2->(dbSeek(xFilial("SA2") + _cFornCod&(_cForm), .F.))
		Endif
        _cPgtoCod&(_cForm) := SA2->A2_COND
		_cFornLoj&(_cForm) := SA2->A2_LOJA
		oSayForn&(_cForm):cCaption := SA2->A2_NREDUZ
		oSayForn&(_cForm):Refresh()
		SA2->(RestArea(_aArea))
		
	Case _cOpc == "TOTAL"
		// Atualiza o campo "desconto".
		If _nDESC&(_cForm) != 0
			_nVLDESC&(_cForm) := (_nQTDE&(_cForm) * _nPRECO&(_cForm)) * (_nDESC&(_cForm) / 100)
		Endif
		
		// Atualiza o campo "total".
		/*_nTotItem := (_nQTDE&(_cForm) * _nPRECO&(_cForm) - _nVLDESC&(_cForm))
		_nTotal&(_cForm) := _nTotItem + _nFRETE&(_cForm) + _nDESP&(_cForm) +;
		(_nTotItem * _nIPI&(_cForm) / 100) + _nACERTO&(_cForm)*/
		
		// Atualiza o campo "total".
		_nTotal&(_cForm) := (_nQTDE&(_cForm) * _nPRECO&(_cForm)) - _nVLDESC&(_cForm) + _nACERTO&(_cForm)
		_nTotal&(_cForm) *= 1 + (_nIPI&(_cForm) / 100)
		_nTotal&(_cForm) += _nFRETE&(_cForm) + _nDESP&(_cForm)
		
		// Atualiza cond. pagto.
		// AtuPgto()   // A desenvolver.
		oMainMenu:Refresh()
		
	Case _cOpc == "TOTAL-ATU"
		// Atualiza o campo acerto.
		/* _nTotItem := (_nQTDE&(_cForm) * _nPRECO&(_cForm) - _nVLDESC&(_cForm))
		_nAux1 := _nTotItem + _nFRETE&(_cForm) + _nDESP&(_cForm) +;
		(_nTotItem * _nIPI&(_cForm) / 100)
		_nACERTO&(_cForm) := _nTotal&(_cForm) - _nAux1 */
		_nAux1 := _nQTDE&(_cForm) * _nPRECO&(_cForm) - _nVLDESC&(_cForm)
		_nAux2 := _nTotal&(_cForm) - (_nDESP&(_cForm) + _nFRETE&(_cForm))
		_nACERTO&(_cForm) := (_nAux2 / (1 + (_nIPI&(_cForm) / 100))) - (_nAux1)
		oMainMenu:Refresh()
		
	Case _cOpc == "JUROS"
		// Nao foi implementado o campo juros ainda.
		
EndCase
Return _lRet
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C2A01COT   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ  													 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C2A01COT()
Local _cChave1, _cChave2, _cChaveAux, _cParc, _cMsg, _nTotPag, _aCondPag
Local _nAux1, _nAux2, _cAux1, _cAux2, _cAux3    


If _nPrvOpc == 5  // Exclui.
	// Armazerna os itens de pagto a serem excluidos.
	_cAux1    := SC8->C8_NUM
	_cAux2    := SC8->C8_PRODUTO
	_cAux3    := SC8->C8_IDENT
	_aCondPag := U_C2A01CPG(SC8->(C8_NUM + C8_PRODUTO + C8_FORNECE + C8_LOJA + C8_ITEM), 2)
	SZ3->(dbSetOrder(1))  // Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA.
	
	Begin Transaction
	// Exclui a cotacao.
	RecLock("SC8", .F.)
	SC8->(dbDelete())
	SC8->(msUnLock())
	//
	
	// Varre excluindo todos os itens de pagto da cotacao.
	For _nAux1 := 1 to len(_aCondPag)
		SZ3->(dbSeek(xFilial("SZ3") + _aCondPag[_nAux1], .F.))
		RecLock("SZ3", .F.)
		SZ3->(dbDelete())
		SZ3->(msUnLock())
	Next _nAux1
	//
	
	// Se for o ultimo item da cotacao marcar SC como aberta.
	SC8->(dbSetOrder(4))  // C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO.
	If !SC8->(dbSeek(xFilial("SC8") + _cAux1 + _cAux3 + _cAux2, .F.))
		SC1->(dbSetOrder(5))  // C1_FILIAL+C1_COTACAO+C1_PRODUTO+C1_IDENT.
		SC1->(dbSeek(xFilial("SC1") + _cAux1 + _cAux2 + _cAux3, .T.))
		RecLock("SC1", .F.)
		SC1->C1_COTACAO := ""
		SC1->(msUnLock())
	Endif
	//
	End Transaction
Else
	// Acerta a opcao escolhida em caso de opcao analise.
	If _nPrvOpc == 3; _nFornOpc -= 1; Endif
	
	// Acerta os indices dos aliases.
	SZ3->(dbSetOrder(1))  // Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA.
	SC8->(dbSetOrder(1))  // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
	
	// Verifica as condicoes de pagto antes da gravacao.
	For _nAux1 := 1 to IIf(_nPrvOpc == 3, 3, 1)
		_cAux1 := AllTrim(str(_nAux1))
		If !empty(_cFornCod&(_cAux1))
			_nTotPag := 0
			For _nAux2 := 1 to len(aVetor&(_cAux1)) // len(aCols&(_cAux1))
				_cAux2 := StrTran(aVetor&(_cAux1)[_nAux2, 1], ".", "")
				_cAux2 := StrTran(_cAux2, ",", ".")
				_nTotPag += val(_cAux2)
			Next _nAux2
			// Se a diferenca for menor que um centavo, ignorar e permitir a confirmacao.
			If (_nTotPag - _nTotal&(_cAux1) >= 0.01)
				_cMsg := "Valor total para pagamento incorreto!" + CRLF +;
				"Valor da solicitacao.......: " + Transform(_nTotal&(_cAux1), PesqPict('SZ3', 'Z3_VALOR')) + CRLF +;
				"Valor total da cond. pagto.: " + Transform(_nTotPag, PesqPict('SZ3', 'Z3_VALOR')) + CRLF + CRLF +;
				"Favor verificar!"
				MsgBox(_cMsg, "Aten็ใo - cota็ใo " + AllTrim(str(_nAux1)))
				Return
			Endif
		Endif
	Next _nAux1
	
	// Grava a cotacao.
	Begin Transaction
	For _nAux1 := 1 to IIf(_nPrvOpc == 3, 3, 1)
		_cAux1 := AllTrim(str(_nAux1))
		// Verifica se a planilha esta ativa antes de gravar os dados.
		If !empty(_cFornCod&(_cAux1))
			
			Do Case
				Case _nPrvOpc == 3  // Analisar.
					SC8->(dbSetOrder(1))  // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
					SC8->(dbSeek(xFilial("SC8") + _aCotProd[_nAux1, 1], .F.))
					// Armazena a sol. de compras para aglutinacao no momento da escolha.
					_cNumSC := SC8->C8_NUMSC
					RecLock("SC8", .F.)
					
				Case _nPrvOpc == 2  // Alterar.
					RecLock("SC8", .F.)
					
				Case _nPrvOpc == 1  // Incluir.
					
					// Busca o numero da proxima proposta.
					_cNumPro1 := "01"
					SC8->(dbSetOrder(4))  // C8_FILIAL+C8_NUM+C8_IDENT+C8_PRODUTO.
					SC8->(dbSeek(xFilial("SC8") + _cCotacao1 + _cIdent1, .F.))
					Do While SC8->(C8_FILIAL + C8_NUM + C8_IDENT) == xFilial("SC8") + _cCotacao1 + _cIdent1
						If SC8->(C8_FORNECE + C8_LOJA) == _cFornCod1 + _cFornLoj1
							_cNumPro1 := IIf(_cNumPro1 > SC8->C8_NUMPRO, _cNumPro1, Soma1(SC8->C8_NUMPRO))
						Endif
						SC8->(dbSkip())
					EndDo
					
					SB1->(dbSeek(xFilial("SB1") + _cProdCot, .F.))
					RecLock("SC8", .T.)
					SC8->C8_FILIAL  := xFilial("SC8")
					SC8->C8_FILENT  := xFilial("SC8")
					SC8->C8_NUM     := _cCotacao1
					SC8->C8_ITEM    := _cItem1  // StrZero(_nAux2 + 1, len(SC8->C8_ITEM))
					SC8->C8_PRODUTO := _cProdCot
					SC8->C8_NUMPRO  := _cNumPro1
					SC8->C8_NUMSC   := _cNumSC1
					SC8->C8_ITEMSC  := _cItemSC1
					SC8->C8_IDENT   := _cIdent1  // StrZero(val(_cItemSC1), len(SC8->C8_IDENT))
					SC8->C8_TES     := SB1->B1_TE
					SC8->C8_UM      := SB1->B1_UM
					SC8->C8_SEGUM   := SB1->B1_SEGUM
					SC8->C8_QTSEGUM := _nQTDE1 * ;
					IIf(SB1->B1_TIPCONV == "M", SC8->C8_QTSEGUM, 1 / SC8->C8_QTSEGUM)
					SC8->C8_EMISSAO := dDataBase
					SC8->C8_TPFRETE := "C"
					SC8->C8_MOEDA   := 1
					//SC8->C8_VALIDA  := dDataBase
					//SC8->C8_DATPRF  := dDataBase
					
				OtherWise
					_cMsg := IIf(Type('_nPrvOpc') == "N",;
					"_nPrvOpc: " + AllTrim(str(_nPrvOpc)) + " invแlido!",;
					"Type('_nPrvOpc'): " + Type('_nPrvOpc') + " invแlido!") + CRLF +;
					"Informe o erro a um administrador do sistema"
					MsgAlert(_cMsg, "Erro de processamento!!!")
					Return //Exit
			EndCase
			SC8->C8_FORNECE := _cFornCod&(_cAux1)
			SC8->C8_COND    := _cPgtoCod&(_cAux1)                 
			SC8->C8_LOJA    := _cFornLoj&(_cAux1)
			SC8->C8_PRAZO   := _nPrazo&(_cAux1)
			SC8->C8_QUANT   := _nQTDE&(_cAux1)
			SC8->C8_PRECO   := _nPRECO&(_cAux1)
			SC8->C8_XACERTO  := _nACERTO&(_cAux1)
			SC8->C8_TOTAL   := _nTotal&(_cAux1)
			SC8->C8_DESC    := _nDESC&(_cAux1)     // DESCONTO (%).
			SC8->C8_VLDESC  := _nVLDESC&(_cAux1)   // DESCONTO ($).
			SC8->C8_BASEIPI := _nTotal&(_cAux1) - _nFRETE&(_cAux1) - _nDESP&(_cAux1)  // _nPRECO&(_cAux1) * _nQTDE&(_cAux1) - _nVLDESC&(_cAux1).
			SC8->C8_ALIIPI  := _nIPI&(_cAux1)
			SC8->C8_VALIPI  := (_nPRECO&(_cAux1) * _nQTDE&(_cAux1) - _nVLDESC&(_cAux1)) * _nIPI&(_cAux1) / 100
			SC8->C8_PICM    := _nISS&(_cAux1)
			SC8->C8_VALFRE  := _nFRETE&(_cAux1)
			SC8->C8_DESPESA := _nDESP&(_cAux1)
			// SC8->C8_COND    := "999"  // Cond. Pagto. especifica CIEE.
			SC8->(msUnLock())
			
			// Grava a condicao de pagamento.
			_cChaveAux := xFilial("SZ3") + _cCotacao&(_cAux1) + _cProdCot +;
			_cFornCod&(_cAux1) + _cFornLoj&(_cAux1) + _cItem&(_cAux1)
			// Varre toda a aCols (todos os registros).
			For _nAux2 := 1 to len(aCols&(_cAux1))
				
				// Verifica se a linha esta marcada como apagada.
				_lLinDel := aCols&(_cAux1)[_nAux2, len(aHeader) + 1]
				
				// Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA
				// _aItens := {"Z3_PARCELA", "Z3_DATA", "Z3_PERCENT", "Z3_VALOR"}
				_cParc := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_PARCELA"})]
				_cChave := _cChaveAux + _cParc
				
				If SZ3->(dbSeek(_cChave))
					RecLock("SZ3", .F.)  // Abre registro para edicao.
					If _lLinDel; SZ3->(dbDelete()); Endif
				ElseIf !_lLinDel
					RecLock("SZ3", .T.)  // Cria novo registro.
					SZ3->Z3_FILIAL  := xFilial("SZ3")
					SZ3->Z3_NUMCOT  := _cCotacao&(_cAux1)
					SZ3->Z3_PRODUTO := _cProdCot
					SZ3->Z3_FORNECE := _cFornCod&(_cAux1)
					SZ3->Z3_LOJA    := _cFornLoj&(_cAux1)
					SZ3->Z3_ITEM    := _cItem&(_cAux1)
					SZ3->Z3_PARCELA := _cParc
				Endif
				// Se a linha nao estiver apagada, incluir na tabela.
				If !_lLinDel
					SZ3->Z3_DIAS    := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_DIAS"})]
					SZ3->Z3_TIPO    := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})]
					SZ3->Z3_DATA    := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_DATA"})]
					SZ3->Z3_PERCENT := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_PERCENT"})]
					SZ3->Z3_VALOR   := aCols&(_cAux1)[_nAux2, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_VALOR"})]
				Endif
				SZ3->(msUnLock())
			Next _nAux2
		Endif
	Next _nAux1
	
	// Atualiza o status da cotacao e alguns outros campos.
	// 1 - Cotacao escolhida.
	// 2 - Cotacao nao escolhida.
	If _nPrvOpc == 3  // Analisar.
		_cAux2 := AllTrim(str(_nFornOpc))
		_cCotAux  := SC8->(C8_FILIAL+C8_NUM+C8_PRODUTO)
		SC8->(dbSetOrder(3))  // C8_FILIAL+C8_NUM+C8_PRODUTO+C8_FORNECE+C8_LOJA+C8_NUMPED+C8_ITEMPED.
		SC8->(dbGoTop()); SC8->(dbSeek(_cCotAux, .F.))  // Posiciona no primeiro registro da cotacao.
		// Enquanto for a cotacao do mesmo produto.
		Do While SC8->(C8_FILIAL+C8_NUM+C8_PRODUTO) == _cCotAux
			// Escolhe a cotacao aglutinando por sol. de compras.
			If SC8->C8_NUMSC == _cNumSC
				RecLock("SC8", .F.)                  
				If _nFornOpc = 0 // Em Aberto
				  SC8->C8_XCOTSTS := "2"
				EndIf
				If _nFornOpc > 0 // Escolheu um Fornecedor                                            
				  If SC8->(C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_IDENT) == _aCotProd[_nFornOpc, 3]
				     SC8->C8_XCOTSTS := "1"
				  Else 
			         If SC8->C8_XCOTSTS <> "1"
				        SC8->C8_XCOTSTS := "2"
				     EndIf
                  EndIf
				EndIf
			  
/*
				SC8->C8_XCOTSTS := IIf ((_nFornOpc > 0 .and.;
				SC8->(C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_IDENT) == _aCotProd[_nFornOpc, 3]),;
				"1", "2")
*/				
				SC8->C8_XOBSMEM := _mObs
				SC8->(msUnLock())
			Endif
			SC8->(dbSkip())
		EndDo
	Endif
	End Transaction
Endif        
oMainMenu:end()  // Fecha a tela.
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C2A01LEG   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ  													 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C2A01LEG(_uPar)
Local _uRet, _aFlag

_aLeg := {;
{"BR_AMARELO",  "Cota็ใo em aberto (nใo cotada)."},;
{"BR_VERDE",    "Cota็ใo em anแlise."},;
{"BR_AZUL",     "Cota็ใo escolhida."},;
{"BR_VERMELHO", "Cota็ใo encerrada."}}

If ValType(_uPar) != "U" .and. _uPar == 0
	_aFlag := {;
	{'!empty(C8_NUMPED)',                        _aLeg[4][1]},;  // Vermelho.
	{' empty(C8_NUMPED) .and. C8_XCOTSTS == "1"', _aLeg[3][1]},;  // Azul
	{' empty(C8_NUMPED) .and. C8_TOTAL == 0',    _aLeg[1][1]},;  // Amarelo.
	{' empty(C8_NUMPED) .and. C8_TOTAL != 0',    _aLeg[2][1]}}   // Verde
	_uRet := _aFlag
Else
	BrwLegenda(cCadastro, "Legenda", _aLeg)
Endif
Return (_uRet)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C2A01CPG   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ  													 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
User Function C2A01CPG(_cCotacao, _nTipo)
Local _aRet, _aAux1, _aEmpty, _aAreaZ3
_aRet := _aAux1 := _aEmpty := {}
_aAreaZ3 := SZ3->(GetArea())
SZ3->(dbSetOrder(1))  // Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA.
SZ3->(dbSeek(xFilial("SZ3") + _cCotacao, .F.))

Do While xFilial("SZ3") + _cCotacao == SZ3->(Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM)
	Do Case
		Case _nTipo == 1
			_aAux1  := {Trim(Transform(SZ3->Z3_VALOR, PesqPict('SZ3', 'Z3_VALOR'))),;
			SZ3->Z3_DATA,;
			SZ3->(Z3_FILIAL+Z3_NUMCOT+Z3_PRODUTO+Z3_FORNECE+Z3_LOJA+Z3_ITEM+Z3_PARCELA)}
		Case _nTipo == 2
			_aAux1  := SZ3->(Z3_NUMCOT + Z3_PRODUTO + Z3_FORNECE + Z3_LOJA + Z3_ITEM + Z3_PARCELA)
	EndCase
	aAdd(_aRet, _aAux1)
	SZ3->(dbSkip())
EndDo

// Valor a ser retornado caso nao exista cond. de pagamento para essa cotacao.
_aEmpty := IIf(_nTipo == 1, {{Trim(Transform(0, PesqPict('SZ3', 'Z3_VALOR'))), ctod("")}}, {})
_aRet := IIf(empty(_aRet), _aEmpty, _aRet)

SZ3->(RestArea(_aAreaZ3))
Return (_aRet)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C2A01TPG   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescrio ณ  													 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
User Function C2A01TPG(_nDias)
Local _nLin, _nLinTam, _oDlg2, _dPagto, _nOpcAux
_dPagto := ctod("")
_nLin := 06; _nLinTam := 17
@ 000, 000 to 140, 200 Dialog _oDlg2 Title "Tipo de pagamento"
@ _nLin, 012 Say "Data de pagamento a partir do"; _nLin += 12
@ _nLin, 012 Button "_Nota Fiscal (entrada)" size 75, 15 action (_nOpcAux := 2, _oDlg2:end()); _nLin += _nLinTam
@ _nLin, 012 Button "_Pedido"                size 75, 15 action (_nOpcAux := 1, _oDlg2:end()); _nLin += _nLinTam
@ _nLin, 012 Button "_Data Especํcifa"       size 75, 15 action (_nOpcAux := 3, _oDlg2:end()); _nLin += _nLinTam
Activate dialog _oDlg2 Centered
Do Case
	Case _nOpcAux == 1  // A partir do pedido.
		aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})] := "P"
		_dPagto := DataValida(dDataBase + _nDias)
		
	Case _nOpcAux == 2  // A partir da NF.
		aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})] := "N"
		
	Case _nOpcAux == 3  // Data especifica
		aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})] := "D"
EndCase
Return(_dPagto)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C2A01IMP   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO QUE IMPRIME O CONTEUDO DA TELA DE COTACAO EM UM     บฑฑ
ฑฑบ          ณ RELATORIO PELO CRYSTAL REPORTS                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C2A01IMP()

DBSelectArea("SZI")

// Grava a cotacao para impressao
DBSelectArea("SB1")
DBSETORDER(1)
DBSEEK(XFILIAL("SB1")+_cProdCot)

_cDESCPRO    := SB1->B1_DESC

DBSelectArea("SZI")	
DBSETORDER(1)

If !empty(_cFornCod1)
	
	RecLock("SZI",.T.)
    SZI->ZI_FILIAL     := XFILIAL("SZI")
	SZI->ZI_PRODUTO    := _cProdCot
	SZI->ZI_DESCPRO    := _cDESCPRO 
	SZI->ZI_NUMSC      := _cCotacao1
 	SZI->ZI_OBS        := _mObs 
    SZI->ZI_EMISSAO    := _dEmissao               
    
    // INDICA A COLUNA DO VENCEDOR 
	DO CASE
		CASE _cCotSts1 == "1"
   	           SZI->ZI_VENCEDO := "1"
	  	CASE _cCotSts2 == "1"
   	           SZI->ZI_VENCEDO := "2"
	  	CASE _cCotSts3 == "1"
   	           SZI->ZI_VENCEDO := "3"
	ENDCASE
	
	SZI->ZI_CODFOR1    := _cFornCod1
	SZI->ZI_NOMFOR     := _cFornNom1 
	SZI->ZI_PRAZO      := _nPrazo1
	SZI->ZI_QTD        := _nQTDE1
	SZI->ZI_PRECO      := _nPRECO1
	SZI->ZI_TOTAL      := _nTotal1
	SZI->ZI_DESCONT    := _nDESC1     // DESCONTO (%).
	SZI->ZI_VLDESC     := _nVLDESC1   // DESCONTO ($).
	SZI->ZI_VALIPI     := (_nPRECO1 * _nQTDE1 - _nVLDESC1) * _nIPI1 / 100
	SZI->ZI_PICM       := _nISS1
	SZI->ZI_COND 	   := POSICIONE("SE4",1,XFILIAL("SE4")+_cPgtoCod1,"E4_DESCRI")
    SZI->ZI_CODFOR2    := _cFornCod2
	SZI->ZI_NOMFOR2    := _cFornNom2 
	SZI->ZI_PRAZO2     := _nPrazo2
	SZI->ZI_QTD2       := _nQTDE2
	SZI->ZI_PRECO2     := _nPRECO2
	SZI->ZI_TOTAL2     := _nTotal2
	SZI->ZI_DESCON2    := _nDESC2     // DESCONTO (%).
	SZI->ZI_VLDESC2    := _nVLDESC2   // DESCONTO ($).
	SZI->ZI_VALIPI2    := (_nPRECO2 * _nQTDE2 - _nVLDESC2) * _nIPI2 / 100
	SZI->ZI_PICM2      := _nISS2    
	SZI->ZI_COND2	   := POSICIONE("SE4",1,XFILIAL("SE4")+_cPgtoCod2,"E4_DESCRI")
    SZI->ZI_CODFOR3    := _cFornCod3
	SZI->ZI_NOMFOR3    := _cFornNom3 
	SZI->ZI_PRAZO3     := _nPrazo3
	SZI->ZI_QTD3       := _nQTDE3
	SZI->ZI_PRECO3     := _nPRECO3
	SZI->ZI_TOTAL3     := _nTotal3
	SZI->ZI_DESCON3    := _nDESC3     // DESCONTO (%).
	SZI->ZI_VLDESC3    := _nVLDESC3   // DESCONTO ($).
	SZI->ZI_VALIPI3    := (_nPRECO3 * _nQTDE3 - _nVLDESC3) * _nIPI3 / 100
	SZI->ZI_PICM3      := _nISS3
	SZI->ZI_COND3	   := POSICIONE("SE4",1,XFILIAL("SE4")+_cPgtoCod3,"E4_DESCRI")

	SZI->(msUnLock())
ENDIF

_COBS   := IIF(EMPTY(_mObs),SPACE(10),substr(ALLTRIM(_mObs),1,250) )


C2A01GER(SZI->(RECNO()),_COBS)

RETURN 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C2A01GER   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Gera relat๓rio										      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C2A01GER(nRecSZI,_COBS)     
Local cLogo     := FisxLogo("1") 
LOCAL oPrint	:= NIL
local cPtPdf	:= "C:\spool\"  
LOCAL oFont1 	:= TFont():New('Times New Roman',,-12,.T.)
LOCAL oFont2 	:= TFont():New('Times New Roman',,-12,.T.,.T.)
LOCAL oFont3 	:= TFont():New('Times New Roman',,-14,.T.,.T.)  
LOCAL oFont4 	:= TFont():New('Times New Roman',,-11,.T.)
LOCAL aTexto	:= {}
LOCAL nLin		:= 0 

SZI->(dbgoto(nRecSZI))
IF SZI->(!EOF())
	
	IF !FILE(cPtPdf)             
		MontaDir(cPtPdf)
	ENDIF 
	
	oPrint:=FWMSPrinter():New(SZI->ZI_NUMSC,6,.F.,"\spool\",.t.,.F.,,,.T.,,,.T.)
	oPrint:SetLandscape()
	oPrint:cPathPDF:= cPtPdf   
	
	oPrint:StartPage()             
	
	oPrint:Line(40,115,40,720,,"+1") 
	oPrint:Line(160,115,160,720,,"+1")
	oPrint:Line(40,115,160,115,,"+1")
	oPrint:Line(40,720,160,720,,"+1")
	oPrint:Line(40,410,160,410,,"+1")    
	
	oPrint:SayBitmap(50,225,cLogo,50,30)
	oPrint:Say(105,150,"CENTRO DE INTEGRAวรO EMPRESA ESCOLA",oFont1,,0)
	oPrint:Say(58,515,"Mapa de Cota็๕es",oFont3,,0)
	oPrint:Say(80,415,"Cota็๕es N." ,oFont1,,0)
	oPrint:Say(80,470,": "+SZI->ZI_NUMSC ,oFont1,,0)
	oPrint:Say(100,415,"Produto",oFont1,,0)
	oPrint:Say(100,470,": " + SZI->ZI_PRODUTO ,oFont1,,0)
 	
 	aTexto	:= C2A01QBRA(1,SZI->ZI_DESCPRO,30)
 		
  	nLin 	:= 120
  	FOR cCntb:= 1 TO LEN(aTexto)
  		oPrint:Say(nLin,475,aTexto[cCntb][2] ,oFont1,,0)
  		nLin+=10
  	NEXT cCntb  	  			                                                         

	oPrint:Line(165,115,165,720,,"+1") 
	oPrint:Line(440,115,440,720,,"+1")
	oPrint:Line(165,115,440,115,,"+1")
	oPrint:Line(165,720,440,720,,"+1")
	oPrint:Line(165,410,365,410,,"+1")
	oPrint:Line(365,115,365,720,,"+1") 
	oPrint:Line(165,260,365,260,,"+1")
	oPrint:Line(165,565,365,565,,"+1")
	
	oPrint:Line(190,115,190,720,,"+1")
	oPrint:Line(220,115,220,720,,"+1")
	oPrint:Line(250,115,250,720,,"+1")
	oPrint:Line(280,115,280,720,,"+1")
	oPrint:Line(310,115,310,720,,"+1")
	oPrint:Line(340,115,340,720,,"+1")
	
	oPrint:Say(180,120,"Fornecedor",oFont1,,0)
	oPrint:Say(210,120,"Quantidade",oFont1,,0)  
	oPrint:Say(240,120,"Pre็o unitแrio",oFont1,,0) 
	oPrint:Say(270,120,"Valor desconto",oFont1,,0) 
	oPrint:Say(298,120,"Pre็o total",oFont1,,0) 
	oPrint:Say(325,120,"Condi็ใo de pagamento",oFont1,,0) 
	oPrint:Say(355,120,"Prazo de entrega",oFont1,,0) 
	
	oPrint:Say(180,265,SZI->ZI_NOMFOR,oFont2,,0)
    oPrint:SayAlign(200,300, TRANSFORM(SZI->ZI_QTD,PESQPICT("SZI","ZI_QTD")),oFont2,100, , , 1, 0 )  
	oPrint:SayAlign(230,300, TRANSFORM(SZI->ZI_PRECO,PESQPICT("SZI","ZI_PRECO")),oFont2,100, , , 1, 0 )
    oPrint:SayAlign(260,300, TRANSFORM(SZI->ZI_VLDESC,PESQPICT("SZI","ZI_VLDESC")),oFont2,100, , , 1, 0 ) 
    oPrint:SayAlign(287,300, TRANSFORM(SZI->ZI_TOTAL,PESQPICT("SZI","ZI_TOTAL")),oFont2,100, , , 1, 0 ) 
    oPrint:SayAlign(317,300, TRIM(SZI->ZI_COND),oFont2,100, , , 1, 0 )  
    oPrint:SayAlign(345,300, CVALTOCHAR(SZI->ZI_PRAZO)+" Dias",oFont2,100, , , 1, 0 )  
    
	oPrint:Say(180,415,SZI->ZI_NOMFOR2,oFont1,,0)
	oPrint:SayAlign(200,450, TRANSFORM(SZI->ZI_QTD2,PESQPICT("SZI","ZI_QTD2")),oFont1,100, , , 1, 0 )  
	oPrint:SayAlign(230,450, TRANSFORM(SZI->ZI_PRECO2,PESQPICT("SZI","ZI_PRECO2")),oFont1,100, , , 1, 0 )
    oPrint:SayAlign(260,450, TRANSFORM(SZI->ZI_VLDESC2,PESQPICT("SZI","ZI_VLDESC2")),oFont1,100, , , 1, 0 ) 
    oPrint:SayAlign(287,450, TRANSFORM(SZI->ZI_TOTAL2,PESQPICT("SZI","ZI_TOTAL2")),oFont1,100, , , 1, 0 ) 
    oPrint:SayAlign(317,450, TRIM(SZI->ZI_COND2),oFont1,100, , , 1, 0 )  
    oPrint:SayAlign(345,450, CVALTOCHAR(SZI->ZI_PRAZO2)+" Dias",oFont1,100, , , 1, 0 )
    
	oPrint:Say(180,570,SZI->ZI_NOMFOR3,oFont1,,0)
	oPrint:SayAlign(200,605, TRANSFORM(SZI->ZI_QTD3,PESQPICT("SZI","ZI_QTD3")),oFont1,100, , , 1, 0 )  
	oPrint:SayAlign(230,605, TRANSFORM(SZI->ZI_PRECO3,PESQPICT("SZI","ZI_PRECO3")),oFont1,100, , , 1, 0 )
    oPrint:SayAlign(260,605, TRANSFORM(SZI->ZI_VLDESC3,PESQPICT("SZI","ZI_VLDESC3")),oFont1,100, , , 1, 0 ) 
    oPrint:SayAlign(287,605, TRANSFORM(SZI->ZI_TOTAL3,PESQPICT("SZI","ZI_TOTAL3")),oFont1,100, , , 1, 0 ) 
    oPrint:SayAlign(317,605, TRIM(SZI->ZI_COND3),oFont1,100, , , 1, 0 )  
    oPrint:SayAlign(345,605, CVALTOCHAR(SZI->ZI_PRAZO3)+" Dias",oFont1,100, , , 1, 0 )
    
 	aTexto	:= C2A01QBRA(1,_COBS,140)
 		
  	nLin 	:= 380
  	FOR cCntb:= 1 TO LEN(aTexto)
  		oPrint:Say(nLin,120,aTexto[cCntb][2] ,oFont1,,0)
  		nLin+=10
  	NEXT cCntb     
     
	oPrint:EndPage()	                            
	
	oPrint:Print() 	    
	FreeObj(oPrint)
endif


RETURN    
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C2A01QBRA  บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza quebra do relat๓rio								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C2A01QBRA(nIdent,cDescri,nLenDesc)
LOCAL aTexto	:= {}
LOCAL aTxtEsp1	:= {}      
LOCAL aTxtEsp2	:= {}
LOCAL cDesAux	:= ""

aTxtEsp1:= StrTokArr(cDescri,CRLF,.T.) 

FOR cCnta:= 1 TO LEN(aTxtEsp1) 
  		
	IF LEN(aTxtEsp1[cCnta]) <= nLenDesc
  		AADD(aTexto,{nIdent,aTxtEsp1[cCnta]})
 	ELSE 
  		aTxtEsp2:= StrTokArr(aTxtEsp1[cCnta]," ",.T.)
  		cDesAux := ""
  		FOR cCntb:= 1 TO LEN(aTxtEsp2)
  			IF LEN(cDesAux) <= nLenDesc
  				cDesAux+= aTxtEsp2[cCntb]+" " 
  				IF cCntb == LEN(aTxtEsp2)
  					AADD(aTexto,{nIdent,cDesAux})
  				ENDIF		  				
  			ELSE    
  				AADD(aTexto,{1,cDesAux})
  				cDesAux := ""  
  				cDesAux+= aTxtEsp2[cCntb]+" "
  			ENDIF		  		
  		NEXT cCntb  
	ENDIF
NEXT cCnta 
  	
return aTexto  
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CriaSX1    บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Parametros da rotina									      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/ 
Static Function CriaSX1(cPerg)  
LOCAL aArea    	:= GetArea()
LOCAL aAreaDic 	:= SX1->( GetArea() )
LOCAL aEstrut  	:= {}
LOCAL aStruDic 	:= SX1->( dbStruct() )
LOCAL aSX1		:= {}
LOCAL nXa       := 0
LOCAL nXb       := 0
LOCAL nXc		:= 0
LOCAL nTam1    	:= Len( SX1->X1_GRUPO )
LOCAL nTam2    	:= Len( SX1->X1_ORDEM )
LOCAL lAtuHelp 	:= .F.            
LOCAL aHelp		:= {}	

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , 'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , 'X1_VAR01'  , 'X1_DEF01'  , ;
             'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , 'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', ;
             'X1_CNT02'  , 'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , 'X1_VAR04'  , ;
             'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , 'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', ;
             'X1_DEFENG5', 'X1_CNT05'  , 'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }

aAdd( aSX1, {cPerg,'01','Exibe p/ comprador','Exibe p/ comprador','Exibe p/ comprador','mv_ch1','N',1,0,2,'C','','mv_par01','Sim','Si','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {cPerg,'02','Filtra cot. atendida','Filtra cot. atendida','Filtra cot. atendida','mv_ch2','N',1,0,2,'C','','mv_par02','Sim','Si','Yes','','','Nao','No','No','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {cPerg,'03','Comprador','Comprador','Comprador','mv_ch3','C',15,0,1,'G','','mv_par03','','','','','','','','','','','','','','','','','','','','','','','','','US3','','','','',''} )

//
// Atualizando dicionแrio
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aSX1 )
	If !SX1->( dbSeek( PadR( aSX1[nXa][1], nTam1 ) + PadR( aSX1[nXa][2], nTam2 ) ) )
		lAtuHelp:= .T.
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aSX1[nXa] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aSX1[nXa][nXb] ) )
			EndIf
		Next nXb
		MsUnLock()
	EndIf		
Next nXa

// Atualiza Helps
IF lAtuHelp        
	AADD(aHelp, {'01',{'Exibe para o comprador.'},{''},{''}}) 
	AADD(aHelp, {'02',{'Filtra a cota็ใo atendida.'},{''},{''}}) 
	AADD(aHelp, {'03',{'C๓digo do comprador.'},{''},{''}}) 
		
	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	

EndIf	

RestArea( aAreaDic )
RestArea( aArea )   
RETURN     
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ Show1Form  บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ 						    								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function Show1Form(_nOpc)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cAux1

// Objetos do dialogo principal que contera os tres formularios.
Private oMainMenu,oSayJuros,oGetJuros,oLbxPgtoN,oSBtnOk,oSBtnCancel

// Objetos do primeiro formulario.
Private oGrpForn1,oGrpProp1,oGrpPag1,oLbxPgto1,oGrpPrazo1,aCols1
Private oSayForn1,oSayQtde1,oSayPrc1,oSayDesc1,oSayIPI1,oSayISS1,oSayFrete1,oSayDesp1,oSayTotal1,oSayPrazo1
Private oGetForn1,oGetQtde1,oGetPrc1,oGetDesc1,oGetIPI1,oGetISS1,oGetFrete1,oGetDesp1,oGetTotal1,oGetPrazo1

Do Case
	Case _nOpc == 1
		_cAux1 := "Incluir"
	Case _nOpc == 2
		_cAux1 := "Atualizar"
	Case _nOpc == 5
		_cAux1 := "Excluir"
	OtherWise
		_cAux1 := "Erro ShowForm1"
EndCase

oMainMenu := MSDIALOG():Create()
oMainMenu:cName     := "oMainMenu"
oMainMenu:cCaption  := _cAux1
oMainMenu:nLeft     := 0
oMainMenu:nTop      := 0
oMainMenu:nWidth    := 223
oMainMenu:nHeight   := 525 // 505
oMainMenu:lShowHint := .T.
oMainMenu:lCentered := .T.

aCols1  := {}

// Exibe o formulario numero 1.
ShowForm(000,0,1,.T.)
oGetForn1:lReadOnly := (_nOpc != 1)  // .F.

// Exibe barra de opcoes.
ShowButtons(092, 465)  // Exibe botoes.
oMainMenu:Activate()
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ Show3Forms บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ 						    								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function Show3Forms(_nOpc)
Local _nIMP
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Objetos do dialogo principal que contera os tres formularios.
Private oMainMenu,oSayJuros,oGetJuros
Private oGrpOpc,oGrpObs,oRadioForn,_nFornOpc,oMemo,oSBtnOk,oSBtnCancel,oSBtnIMP
Private oDlgPgto, oLbxPgtoN

// Objetos do primeiro formulario.
Private oGrpForn1,oGrpProp1,oGrpPag1,oLbxPgto1,oGrpPrazo1,aCols1
Private oSayForn1,oSayQtde1,oSayPrc1,oSayDesc1,oSayIPI1,oSayISS1,oSayFrete1,oSayDesp1,oSayTotal1,oSayPrazo1
Private oGetForn1,oGetQtde1,oGetPrc1,oGetDesc1,oGetIPI1,oGetISS1,oGetFrete1,oGetDesp1,oGetTotal1,oGetPrazo1

// Objetos do segundo formulario.
Private oGrpForn2,oGrpProp2,oGrpPag2,oLbxPgto2,oGrpPrazo2,aCols2
Private oSayForn2,oSayQtde2,oSayPrc2,oSayDesc2,oSayIPI2,oSayISS2,oSayFrete2,oSayDesp2,oSayTotal2,oSayPrazo2
Private oGetForn2,oGetQtde2,oGetPrc2,oGetDesc2,oGetIPI2,oGetISS2,oGetFrete2,oGetDesp2,oGetTotal2,oGetPrazo2

// Objetos do terceiro formulario.
Private oGrpForn3,oGrpProp3,oGrpPag3,oLbxPgto3,oGrpPrazo3,aCols3
Private oSayForn3,oSayQtde3,oSayPrc3,oSayDesc3,oSayIPI3,oSayISS3,oSayFrete3,oSayDesp3,oSayTotal3,oSayPrazo3
Private oGetForn3,oGetQtde3,oGetPrc3,oGetDesc3,oGetIPI3,oGetISS3,oGetFrete3,oGetDesp3,oGetTotal3,oGetPrazo3
_nIMP := _nOpc
oMainMenu := MSDIALOG():Create()
oMainMenu:cName     := "oMainMenu"
oMainMenu:cCaption  := "Atualiza็ใo de Compras"
oMainMenu:nLeft     := 0
oMainMenu:nTop      := 0
oMainMenu:nWidth    := 800
oMainMenu:nHeight   := 500 // 480
oMainMenu:lCentered := .T.

aCols1 := aCols2 := aCols3 := {}

// Exibe o formulario numero 1.
ShowForm(000, 0, 1 ,.F.)
// Exibe o formulario numero 2.
ShowForm(210, 0, 2 ,.F.)
// Exibe o formulario numero 3.
ShowForm(420, 0, 3 ,.F.)

// Exibe barra de opcoes.
_nFornOpc := GetEscolha()
ShowControl(630, 0,_nIMP)
oMainMenu:Activate()
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ ShowForm   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ 						    								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function ShowForm(_nLeft, _nTop, _cForm, _lWrite)

// Auxiliares nas coordedadas dos objetos.
Local a1, a2, a3, a4, _lReadOnly, _lAltPagto

_cForm := AllTrim(str(_cForm))
// Verifica se a planilha esta ativa antes ativar os objetos.
_lReadOnly := !(_lWrite .or. (!empty(_cFornCod&(_cForm)) .and. empty(_cNumPed&(_cForm))))

// TGROUP()

oGrpForn&(_cForm) := TGROUP():Create(oMainMenu)
oGrpForn&(_cForm):cName := "oGrpForn" + _cForm
oGrpForn&(_cForm):cCaption := "Fornecedor"
oGrpForn&(_cForm):nLeft   := _nLeft + 008
oGrpForn&(_cForm):nTop    := _nTop  + 003
oGrpForn&(_cForm):nWidth  := 205
oGrpForn&(_cForm):nHeight := 041

oGrpProp&(_cForm):= TGROUP():Create(oMainMenu)
oGrpProp&(_cForm):cName := "oGrpProp" + _cForm
oGrpProp&(_cForm):cCaption := "Proposta"
oGrpProp&(_cForm):nLeft   := _nLeft + 008
oGrpProp&(_cForm):nTop    := _nTop  + 048
oGrpProp&(_cForm):nWidth  := 205
oGrpProp&(_cForm):nHeight := 248  //228

oGrpPag&(_cForm) := TGROUP():Create(oMainMenu)
oGrpPag&(_cForm):cName := "oGrpPag" + _cForm
oGrpPag&(_cForm):cCaption := "Pagamento"
oGrpPag&(_cForm):nLeft   := _nLeft + 008
oGrpPag&(_cForm):nTop    := _nTop  + 300 //280
oGrpPag&(_cForm):nWidth  := 205
oGrpPag&(_cForm):nHeight := 115

oGrpPrazo&(_cForm) := TGROUP():Create(oMainMenu)
oGrpPrazo&(_cForm):cName := "oGrpPrazo" + _cForm
oGrpPrazo&(_cForm):cCaption := "Prazo de entrega"
oGrpPrazo&(_cForm):nLeft   := _nLeft + 008
oGrpPrazo&(_cForm):nTop    := _nTop  + 420 //400
oGrpPrazo&(_cForm):nWidth  := 205
oGrpPrazo&(_cForm):nHeight := 041

// TSay()

oSayForn&(_cForm) := TSAY():Create(oMainMenu)
oSayForn&(_cForm):cName := "oSayForn" + _cForm
oSayForn&(_cForm):cCaption := _cFornNom&(_cForm)
oSayForn&(_cForm):nLeft   := _nLeft + 83
oSayForn&(_cForm):nTop    := _nTop  + 18
oSayForn&(_cForm):nWidth  := 114
oSayForn&(_cForm):nHeight := 17

oSayQtde&(_cForm) := TSAY():Create(oMainMenu)
oSayQtde&(_cForm):cName := "oSayQtde" + _cForm
oSayQtde&(_cForm):cCaption := "Qtde" // + U_GetCpoVal("B1_UM", 1, xFilial("SB1") + SC8->C8_PRODUTO, .F.)
oSayQtde&(_cForm):nLeft   := _nLeft + 14
oSayQtde&(_cForm):nTop    := _nTop  + 68
oSayQtde&(_cForm):nWidth  := 65
oSayQtde&(_cForm):nHeight := 17

oSayPrc&(_cForm) := TSAY():Create(oMainMenu)
oSayPrc&(_cForm):cName := "oSayPrc" + _cForm
oSayPrc&(_cForm):cCaption := "Pre็o $"
oSayPrc&(_cForm):nLeft   := _nLeft + 14
oSayPrc&(_cForm):nTop    := _nTop  + 88
oSayPrc&(_cForm):nWidth  := 65
oSayPrc&(_cForm):nHeight := 17

oSayDesc&(_cForm) := TSAY():Create(oMainMenu)
oSayDesc&(_cForm):cName := "oSayDesc" + _cForm
oSayDesc&(_cForm):cCaption := "Desc  %"
oSayDesc&(_cForm):nLeft   := _nLeft + 14
oSayDesc&(_cForm):nTop    := _nTop  + 108
oSayDesc&(_cForm):nWidth  := 65
oSayDesc&(_cForm):nHeight := 17

oSayVlDesc&(_cForm) := TSAY():Create(oMainMenu)
oSayVlDesc&(_cForm):cName := "oSayDesc" + _cForm
oSayVlDesc&(_cForm):cCaption := "Desc  $"
oSayVlDesc&(_cForm):nLeft   := _nLeft + 14
oSayVlDesc&(_cForm):nTop    := _nTop  + 128
oSayVlDesc&(_cForm):nWidth  := 65
oSayVlDesc&(_cForm):nHeight := 17

oSayIPI&(_cForm) := TSAY():Create(oMainMenu)
oSayIPI&(_cForm):cName := "oSayIPI" + _cForm
oSayIPI&(_cForm):cCaption := "IPI %"
oSayIPI&(_cForm):nLeft   := _nLeft + 14
oSayIPI&(_cForm):nTop    := _nTop  + 148
oSayIPI&(_cForm):nWidth  := 65
oSayIPI&(_cForm):nHeight := 17

oSayISS&(_cForm) := TSAY():Create(oMainMenu)
oSayISS&(_cForm):cName := "oSayISS" + _cForm
oSayISS&(_cForm):cCaption := "ISS %"
oSayISS&(_cForm):nLeft   := _nLeft + 14
oSayISS&(_cForm):nTop    := _nTop  + 168
oSayISS&(_cForm):nWidth  := 65
oSayISS&(_cForm):nHeight := 17

oSayFrete&(_cForm) := TSAY():Create(oMainMenu)
oSayFrete&(_cForm):cName := "oSayFrete" + _cForm
oSayFrete&(_cForm):cCaption := "Frete $"
oSayFrete&(_cForm):nLeft   := _nLeft + 14
oSayFrete&(_cForm):nTop    := _nTop  + 188
oSayFrete&(_cForm):nWidth  := 65
oSayFrete&(_cForm):nHeight := 17

oSayDesp&(_cForm) := TSAY():Create(oMainMenu)
oSayDesp&(_cForm):cName := "oSayDesp" + _cForm
oSayDesp&(_cForm):cCaption := "Desp $"
oSayDesp&(_cForm):nLeft   := _nLeft + 14
oSayDesp&(_cForm):nTop    := _nTop  + 208
oSayDesp&(_cForm):nWidth  := 65
oSayDesp&(_cForm):nHeight := 17

oSayAcert&(_cForm) := TSAY():Create(oMainMenu)
oSayAcert&(_cForm):cName := "oSayAcert" + _cForm
oSayAcert&(_cForm):cCaption := "Acerto  $"
oSayAcert&(_cForm):nLeft   := _nLeft + 14
oSayAcert&(_cForm):nTop    := _nTop  + 228
oSayAcert&(_cForm):nWidth  := 65
oSayAcert&(_cForm):nHeight := 17

oSayTotal&(_cForm) := TSAY():Create(oMainMenu)
oSayTotal&(_cForm):cName := "oSayTotal" + _cForm
oSayTotal&(_cForm):cCaption := "Total $"
oSayTotal&(_cForm):nLeft   := _nLeft + 14
oSayTotal&(_cForm):nTop    := _nTop  + 270  // 250
oSayTotal&(_cForm):nWidth  := 65
oSayTotal&(_cForm):nHeight := 17

// Crystal
oSayPgto&(_cForm) := TSAY():Create(oMainMenu)
oSayPgto&(_cForm):cName := "oSayPgto" + _cForm
oSayPgto&(_cForm):cCaption := "Cond Pgto"
oSayPgto&(_cForm):nLeft   := _nLeft + 14
oSayPgto&(_cForm):nTop    := _nTop  + 320 // 414
oSayPgto&(_cForm):nWidth  := 65
oSayPgto&(_cForm):nHeight := 17
// Crystal

oSayPrazo&(_cForm) := TSAY():Create(oMainMenu)
oSayPrazo&(_cForm):cName := "oSayPrazo" + _cForm
oSayPrazo&(_cForm):cCaption := "Entrega (dias)"
oSayPrazo&(_cForm):nLeft   := _nLeft + 14
oSayPrazo&(_cForm):nTop    := _nTop  + 434 // 414
oSayPrazo&(_cForm):nWidth  := 65
oSayPrazo&(_cForm):nHeight := 17

// TGet()

oGetForn&(_cForm) := TGET():Create(oMainMenu)
oGetForn&(_cForm):cName := "oGetForn" + _cForm
oGetForn&(_cForm):nLeft   := _nLeft + 014
oGetForn&(_cForm):nTop    := _nTop  + 018
oGetForn&(_cForm):nWidth  := 65
oGetForn&(_cForm):nHeight := 21
oGetForn&(_cForm):cVariable := "_cFornCod" + _cForm
oGetForn&(_cForm):bSetGet := {|u| If(PCount()>0,_cFornCod&(_cForm):=u,_cFornCod&(_cForm)) }
oGetForn&(_cForm):cF3 := "SA2"
oGetForn&(_cForm):Picture := PesqPict('SA2', 'A2_COD')
oGetForn&(_cForm):bValid  := {|| C2A01CPO(val(_cForm), "FORN") }
oGetForn&(_cForm):lReadOnly := .T.

oGetQtde&(_cForm) := TGET():Create(oMainMenu)
oGetQtde&(_cForm):cName := "oGetQtde" + _cForm
oGetQtde&(_cForm):nLeft   := _nLeft + 072 // 087
oGetQtde&(_cForm):nTop    := _nTop  + 068
oGetQtde&(_cForm):nWidth  := 114
oGetQtde&(_cForm):nHeight := 21
oGetQtde&(_cForm):cVariable := "_nQTDE" + _cForm
oGetQtde&(_cForm):bSetGet := {|u| If(PCount()>0,_nQTDE&(_cForm):=u,_nQTDE&(_cForm)) }
oGetQtde&(_cForm):Picture := PesqPict('SC8', 'C8_QUANT')
oGetQtde&(_cForm):bChange := {|| C2A01CPO(val(_cForm), "TOTAL") }
oGetQtde&(_cForm):lReadOnly := _lReadOnly

oGetPrc&(_cForm) := TGET():Create(oMainMenu)
oGetPrc&(_cForm):cName := "oGetPrc" + _cForm
oGetPrc&(_cForm):nLeft   := _nLeft + 072
oGetPrc&(_cForm):nTop    := _nTop  + 088
oGetPrc&(_cForm):nWidth  := 114
oGetPrc&(_cForm):nHeight := 21
oGetPrc&(_cForm):cVariable := "_nPRECO" + _cForm
oGetPrc&(_cForm):bSetGet := {|u| If(PCount()>0,_nPRECO&(_cForm):=u,_nPRECO&(_cForm)) }
oGetPrc&(_cForm):Picture := PesqPict('SC8', 'C8_PRECO')
oGetPrc&(_cForm):bChange := {|| C2A01CPO(val(_cForm), "TOTAL") }
oGetPrc&(_cForm):lReadOnly := _lReadOnly

oGetDesc&(_cForm) := TGET():Create(oMainMenu)
oGetDesc&(_cForm):cName := "oGetDesc" + _cForm
oGetDesc&(_cForm):nLeft   := _nLeft + 072 // 087
oGetDesc&(_cForm):nTop    := _nTop  + 108
oGetDesc&(_cForm):nWidth  := 114
oGetDesc&(_cForm):nHeight := 21
oGetDesc&(_cForm):cVariable := "_nDESC" + _cForm
oGetDesc&(_cForm):bSetGet := {|u| If(PCount()>0,_nDESC&(_cForm):=u,_nDESC&(_cForm)) }
oGetDesc&(_cForm):Picture := PesqPict('SC8', 'C8_DESC')
oGetDesc&(_cForm):bChange := {|| (_nVLDESC&(_cForm) := _nDESC&(_cForm) * (_nQTDE&(_cForm) * _nPRECO&(_cForm)) / 100, C2A01CPO(val(_cForm), "TOTAL")) }
oGetDesc&(_cForm):lReadOnly := _lReadOnly

oGetVlDsc&(_cForm) := TGET():Create(oMainMenu)
oGetVlDsc&(_cForm):cName := "oGetVlDsc" + _cForm
oGetVlDsc&(_cForm):nLeft   := _nLeft + 072 // 087
oGetVlDsc&(_cForm):nTop    := _nTop  + 128
oGetVlDsc&(_cForm):nWidth  := 114
oGetVlDsc&(_cForm):nHeight := 21
oGetVlDsc&(_cForm):cVariable := "_nVLDESC" + _cForm
oGetVlDsc&(_cForm):bSetGet := {|u| If(PCount()>0,_nVLDESC&(_cForm):=u,_nVLDESC&(_cForm)) }
oGetVlDsc&(_cForm):Picture := PesqPict('SC8', 'C8_VLDESC')
oGetVlDsc&(_cForm):bChange := {|| (_nDESC&(_cForm) := 0, C2A01CPO(val(_cForm), "TOTAL")) }
oGetVlDsc&(_cForm):lReadOnly := _lReadOnly

oGetIPI&(_cForm) := TGET():Create(oMainMenu)
oGetIPI&(_cForm):cName := "oGetIPI" + _cForm
oGetIPI&(_cForm):nLeft   := _nLeft + 072 // 087
oGetIPI&(_cForm):nTop    := _nTop  + 148
oGetIPI&(_cForm):nWidth  := 114
oGetIPI&(_cForm):nHeight := 21
oGetIPI&(_cForm):cVariable := "_nIPI" + _cForm
oGetIPI&(_cForm):bSetGet := {|u| If(PCount()>0,_nIPI&(_cForm):=u,_nIPI&(_cForm)) }
oGetIPI&(_cForm):Picture := PesqPict('SC8', 'C8_ALIIPI')
oGetIPI&(_cForm):bChange := {|| C2A01CPO(val(_cForm), "TOTAL") }
oGetIPI&(_cForm):lReadOnly := _lReadOnly

oGetISS&(_cForm) := TGET():Create(oMainMenu)
oGetISS&(_cForm):cName := "oGetISS" + _cForm
oGetISS&(_cForm):nLeft   := _nLeft + 072 // 087
oGetISS&(_cForm):nTop    := _nTop  + 168
oGetISS&(_cForm):nWidth  := 114
oGetISS&(_cForm):nHeight := 21
oGetISS&(_cForm):cVariable := "_nISS" + _cForm
oGetISS&(_cForm):bSetGet := {|u| If(PCount()>0,_nISS&(_cForm):=u,_nISS&(_cForm)) }
oGetISS&(_cForm):Picture := PesqPict('SC8', 'C8_ALIIPI')
oGetISS&(_cForm):bChange := {|| C2A01CPO(val(_cForm), "TOTAL") }
oGetISS&(_cForm):lReadOnly := _lReadOnly

oGetFrete&(_cForm) := TGET():Create(oMainMenu)
oGetFrete&(_cForm):cName := "oGetFrete" + _cForm
oGetFrete&(_cForm):nLeft   := _nLeft + 072 // 087
oGetFrete&(_cForm):nTop    := _nTop  + 188
oGetFrete&(_cForm):nWidth  := 114
oGetFrete&(_cForm):nHeight := 21
oGetFrete&(_cForm):cVariable := "_nFRETE" + _cForm
oGetFrete&(_cForm):bSetGet := {|u| If(PCount()>0,_nFRETE&(_cForm):=u,_nFRETE&(_cForm)) }
oGetFrete&(_cForm):Picture := PesqPict('SC8', 'C8_VALFRE')
oGetFrete&(_cForm):bChange := {|| C2A01CPO(val(_cForm), "TOTAL") }
oGetFrete&(_cForm):lReadOnly := _lReadOnly

oGetDesp&(_cForm) := TGET():Create(oMainMenu)
oGetDesp&(_cForm):cName := "oGetDesp" + _cForm
oGetDesp&(_cForm):nLeft   := _nLeft + 072 // 087
oGetDesp&(_cForm):nTop    := _nTop  + 208
oGetDesp&(_cForm):nWidth  := 114
oGetDesp&(_cForm):nHeight := 21
oGetDesp&(_cForm):cVariable := "_nDESP" + _cForm
oGetDesp&(_cForm):bSetGet := {|u| If(PCount()>0,_nDESP&(_cForm):=u,_nDESP&(_cForm)) }
oGetDesp&(_cForm):Picture := PesqPict('SC8', 'C8_VLDESC')
oGetDesp&(_cForm):bChange := {|| C2A01CPO(val(_cForm), "TOTAL") }
oGetDesp&(_cForm):lReadOnly := _lReadOnly

oGetAcert&(_cForm) := TGET():Create(oMainMenu)
oGetAcert&(_cForm):cName := "oGetAcert" + _cForm
oGetAcert&(_cForm):nLeft   := _nLeft + 072 // 087
oGetAcert&(_cForm):nTop    := _nTop  + 228
oGetAcert&(_cForm):nWidth  := 114
oGetAcert&(_cForm):nHeight := 21
oGetAcert&(_cForm):cVariable := "_nACERTO" + _cForm
oGetAcert&(_cForm):bSetGet := {|u| If(PCount()>0,_nACERTO&(_cForm):=u,_nACERTO&(_cForm)) }
oGetAcert&(_cForm):Picture := PesqPict('SC8', 'C8_XACERTO')
oGetAcert&(_cForm):bChange := {|| C2A01CPO(val(_cForm), "TOTAL") }
oGetAcert&(_cForm):lReadOnly := _lReadOnly

oGetTotal&(_cForm) := TGET():Create(oMainMenu)
oGetTotal&(_cForm):cName := "oGetTotal" + _cForm
oGetTotal&(_cForm):nLeft   := _nLeft + 072 // 087
oGetTotal&(_cForm):nTop    := _nTop  + 270 //250
oGetTotal&(_cForm):nWidth  := 114
oGetTotal&(_cForm):nHeight := 21
oGetTotal&(_cForm):cVariable := "_nTotal" + _cForm
oGetTotal&(_cForm):bSetGet := {|u| If(PCount()>0,_nTotal&(_cForm):=u,_nTotal&(_cForm)) }
oGetTotal&(_cForm):Picture := PesqPict('SC8', 'C8_TOTAL')
oGetTotal&(_cForm):bChange := {|| C2A01CPO(val(_cForm), "TOTAL-ATU") }
oGetTotal&(_cForm):lReadOnly := _lReadOnly

/* Cond. pagto */
// Coordenadas.
a1 := 11.15 // 10.45 // 9.75   // Top (a cada 1 unidade dos outros objetos, mover 0,035 desse).
a2 := 0.75 + (13.1 * (val(_cForm) - 1))  // Left
a3 := 97.5  // Width
a4 := 48    // Height

// Permite a alteracao da condicao de pagamento de cotacoes que nao tenham sido fechadas ou as 
// que tenham vencido. Nao permite a alteracao de cotacoes fechadas mas que tenham perdido.
// Index 1 - C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
If !_lReadOnly
	_lAltPagto := .T.   // Se a cotacao estiver em aberto.
ElseIf empty(_cFornCod&(_cForm) + _cFornLoj&(_cForm))
	_lAltPagto := .F.   // Se nao existir a cotacao.
Else
	// Consulta se a cotacao foi fechada e o pedido ainda nao foi baixado.
	_aAreaC8 := SC8->(GetArea())
	SC8->(dbSetOrder(1))  // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO.
	SC8->(dbSeek(xFilial("SC8") + _cCotacao&(_cForm) + _cFornCod&(_cForm) + _cFornLoj&(_cForm) + _cItem&(_cForm), .F.))
	If SC8->C8_NUMPED != Replicate("X", len(SC8->C8_NUMPED)) .and. !empty(SC8->(C8_NUMPED + C8_ITEMPED))
		_aAreaC7 := SC7->(GetArea())
		SC7->(dbSetOrder(1))  // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
		SC7->(dbSeek(xFilial("SC7") + SC8->(C8_NUMPED + C8_ITEMPED), .F.))
		If SC7->C7_QUJE != 0
			_lAltPagto := .F.   // Pedido ja entregue (parcial ou total).
		Else
			_lAltPagto := .F.   // Pedido ainda em aberto.
		Endif
		SC7->(RestArea(_aAreaC7))
	Else
		_lAltPagto := .F.   // Cotacao perdida.
	Endif
	SC8->(RestArea(_aAreaC8))
Endif
//_lAltPagto := !_lReadOnly

/* Crystal
oLbxPgto&(_cForm) := TWBrowse():New(a1, a2, a3, a4,, {"Parcela", "Dia"},, oMainMenu;
,,,,,{|a1, a2| AltCondPag(_nTotal&(_cForm), aVetor&(_cForm), _cForm, _lAltPagto)},,,,,,,,,,,,,,)
oLbxPgto&(_cForm):cVariable := "aVetor" + _cForm
oLbxPgto&(_cForm):SetArray(aVetor&(_cForm))
oLbxPgto&(_cForm):bLine := {|| {aVetor&(_cForm)[oLbxPgto&(_cForm):nAt,1], aVetor&(_cForm)[oLbxPgto&(_cForm):nAt,2]}}
*/        

//Crystal Begin

oGetPgto&(_cForm) := TGET():Create(oMainMenu)
oGetPgto&(_cForm):cName := "oGetPgto" + _cForm
oGetPgto&(_cForm):nLeft   := _nLeft + 087
oGetPgto&(_cForm):nTop    := _nTop  + 320
oGetPgto&(_cForm):nWidth  := 65
oGetPgto&(_cForm):nHeight := 21
oGetPgto&(_cForm):cVariable := "_cPgtoCod" + _cForm
oGetPgto&(_cForm):bSetGet := {|u| If(PCount()>0,_cPgtoCod&(_cForm):=u,_cPgtoCod&(_cForm)) }
oGetPgto&(_cForm):cF3 := "SE4"
oGetPgto&(_cForm):Picture := PesqPict('SE4', 'E4_CODIGO')
oGetPgto&(_cForm):bValid  := {|| C2A01CPO(val(_cForm), "COND") }
oGetPgto&(_cForm):lReadOnly := _lReadOnly
//Crystal End



oGetPrazo&(_cForm) := TGET():Create(oMainMenu)
oGetPrazo&(_cForm):cName := "oGetPrazo" + _cForm
oGetPrazo&(_cForm):nLeft   := _nLeft + 087
oGetPrazo&(_cForm):nTop    := _nTop  + 434 // 414
oGetPrazo&(_cForm):nWidth  := 114
oGetPrazo&(_cForm):nHeight := 21
oGetPrazo&(_cForm):cVariable := "_nPrazo" + _cForm
oGetPrazo&(_cForm):bSetGet := {|u| If(PCount()>0,_nPrazo&(_cForm):=u,_nPrazo&(_cForm)) }
oGetPrazo&(_cForm):Picture := "@E 999,999"
oGetPrazo&(_cForm):lReadOnly := _lReadOnly

Return .T.
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณShowControl บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ 						    								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function ShowControl(_nLeft, _nTop,_nIMP)

// TGROUP()
oGrpOpc := TGROUP():Create(oMainMenu)
oGrpOpc:cName := "oGrpOpc"
oGrpOpc:cCaption := "Op็๕es"
oGrpOpc:nLeft   := _nLeft + 008
oGrpOpc:nTop    := _nTop  + 003
oGrpOpc:nWidth  := 150
oGrpOpc:nHeight := 87

oGrpObs := TGROUP():Create(oMainMenu)
oGrpObs:cName := "oGrpObs"
oGrpObs:cCaption := "Observa็๕es"
oGrpObs:nLeft   := _nLeft + 008
oGrpObs:nTop    := _nTop  + 094
oGrpObs:nWidth  := 150
oGrpObs:nHeight := 217 //120

// Radio Button
oRadioForn := TRADMENU():Create(oMainMenu)
oRadioForn:cName := "oRadioForn"
oRadioForn:cCaption := "oRadioForn"
oRadioForn:nLeft   := _nLeft + 020
oRadioForn:nTop    := _nTop  + 020
oRadioForn:nWidth  := 122
oRadioForn:nHeight := 50
_aItems := {"Em aberto"}
If !empty(_cFornCod1); aAdd(_aItems, oSayForn1:cCaption); Endif
If !empty(_cFornCod2); aAdd(_aItems, oSayForn2:cCaption); Endif
If !empty(_cFornCod3); aAdd(_aItems, oSayForn3:cCaption); Endif
oRadioForn:aItems  := _aItems
oRadioForn:cVariable := "_nFornOpc"
oRadioForn:bSetGet   := {|u| If(PCount() > 0, _nFornOpc := u, _nFornOpc)}

// Texto memo
@ 053, 323 Get _mObs Size 067, 100 MEMO Object oMemo

//ShowButtons(_nLeft + 040, _nTop  + 418)  // Exibe botoes.
ShowButtons(_nLeft + 040, _nTop  + 438,_nIMP)  // Exibe botoes.

Return .T.
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณShowButtons บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ 						    								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function ShowButtons(_nLeft, _nTop,_nFLAG)
// Botoes.

oSBtnOk := SBUTTON():Create(oMainMenu)
oSBtnOk:cName := "oSBtnOk"
oSBtnOk:cCaption := "Ok"
oSBtnOk:nLeft   := _nLeft
oSBtnOk:nTop    := _nTop
oSBtnOk:nWidth  := 52
oSBtnOk:nHeight := 22
oSBtnOk:nType := 1  // Ok.
oSBtnOk:bAction := {|| C2A01COT()}

oSBtnCancel := SBUTTON():Create(oMainMenu)
oSBtnCancel:cName := "oSBtnCancel"
oSBtnCancel:cCaption := "Cancel"
oSBtnCancel:nLeft   := _nLeft + 066
oSBtnCancel:nTop    := _nTop
oSBtnCancel:nWidth  := 52
oSBtnCancel:nHeight := 22
oSBtnCancel:nType := 2  // Cancelar
oSBtnCancel:bAction := {|| oMainMenu:end()}

IF _nFLAG == 3 
oSBtnIMP := SBUTTON():Create(oMainMenu)
oSBtnIMP:cName := "oSBtnIMP"
oSBtnIMP:cCaption := "IMP"
oSBtnIMP:nLeft   := _nLeft
oSBtnIMP:nTop    := _nTop - 40
oSBtnIMP:nWidth  := 52
oSBtnIMP:nHeight := 22
oSBtnIMP:nType := 6  // Ok.
oSBtnIMP:bAction := {|| C2A01IMP()}
ENDIF

Return .T.
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ AltCondPag บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ 						    								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function AltCondPag(_nTotPar, _aVetor, _cFormPar, _lActive)
Local _aItens, _nAux1, _lDel
Private _cAlias, _aColsAnt
Private _nTotal, _cForm

_aItens := {"Z3_PARCELA", "Z3_DIAS", "Z3_TIPO", "Z3_DATA", "Z3_PERCENT", "Z3_VALOR"}
_nTotal := _nTotPar
_cForm := _cFormPar

// Monta a aHeader.
aHeader := {}
SX3->(dbSetOrder(2))  // X3_CAMPO.
For _nAux1 := 1 to len(_aItens)
	SX3->(dbSeek(_aItens[_nAux1]))
	aAdd(aHeader, {SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL, SX3->X3_VLDUSER, SX3->X3_USADO,;
	SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT})
Next _nAux1

// Monta a aCols.
n := 1
If !empty(aCols&(_cFormPar))
	// Restaura aCols ja montada e editada.
	aCols := aCols&(_cFormPar)
ElseIf len(aVetor&(_cFormPar)) == 1 .and. len(aVetor&(_cFormPar)[1]) < 3
	// Monta aCols vazia caso nao exista registro no cadastro de pagamento (SZ3).
	aCols := Array(1, len(aHeader) + 1)
	For _nAux1 := 1 to len(aHeader)
		SX3->(dbSeek(aHeader[_nAux1, 2], .F.))
		aCols[1, _nAux1] := IIf (!empty(SX3->X3_RELACAO), &(SX3->X3_RELACAO),;
		CriaVar(aHeader[_nAux1, 2]))
	Next _nAux1
	aCols[1, len(aHeader) + 1] := .F.  // Campo deletado: marcar como false.
Else
	// Monta aCols caso exista registro no cadastro de pagamento (SZ3).
	_cAlias := Alias()
	dbSelectArea("SZ3")
	aCols := {}
	For _nAux1 := 1 to len(aVetor&(_cFormPar))
		aAdd(aCols, Array(len(aHeader) + 1))
		SZ3->(dbSeek(aVetor&(_cFormPar)[_nAux1, 3]))
		For _nAux2 := 1 to len(aHeader)
			aCols[_nAux1, _nAux2] := FieldGet(FieldPos(aHeader[_nAux2, 2]))
		Next _nAux2
		aCols[_nAux1, len(aHeader) + 1] := .F.
	Next _nAux1
	dbSelectArea(_cAlias)
Endif
// Salva a aCols, caso o usuario cancela a operacao.
_aColsAnt := aCols

@ 000,000 to 200,390 Dialog oDlgPgto title cCadastro
@ 000,003 to 085,194 title "Condi็ใo de pagamento"
// Multiline
//@ 006,006 to 080,190 MultiLine;
//delete Valid VldLinha() Object oLbxPgtoN freeze 1
//oLbxPgtoN:oBrowse:lActive := _lActive
_lDel := .T.
oLbxPgtoN  := IW_MultiLine(006, 006, 080, 190, _lActive, _lDel, {|| VldLinha()}, 1)
oLbxPgtoN:nMax := 99


@ 085,134 BmpButton Type 1 Action CondPagOk() Object oBtnOk //VldTudo()
@ 085,166 BmpButton Type 2 Action (oDlgPgto:end(), aCols := _aColsAnt) Object oBtnCan

//oBtnOk:SetFocus()
Activate Dialog oDlgPgto Centered
aCols&(_cFormPar) := aCols
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CondPagOk  บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ 						    								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function CondPagOk()
Local _nAux1
If VldTudo()
	aVetor&(_cForm)	 := {}
	For _nAux1 := 1 to len(aCols)
		If !(aCols[_nAux1, len(aHeader) + 1])
			aAdd(aVetor&(_cForm),{;
			Trim(Transform(aCols[_nAux1, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_VALOR"})], PesqPict('SZ3', 'Z3_VALOR'))),;
			aCols[_nAux1, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_DATA"})]})
		Endif
	Next _nAux1
	oLbxPgto&(_cForm):cVariable := "aVetor" + _cForm
	oLbxPgto&(_cForm):SetArray(aVetor&(_cForm))
	oLbxPgto&(_cForm):bLine := {|| {aVetor&(_cForm)[oLbxPgto&(_cForm):nAt,1], aVetor&(_cForm)[oLbxPgto&(_cForm):nAt,2]}}
	oLbxPgto&(_cForm):Refresh()
	oLbxPgto&(_cForm):bLine := {|| {}}
Endif
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ VldLinha   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ 						    								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function VldLinha()
Local _lRet, _cMsg, _nAux1
If !(_lRet := aCols[n, len(aHeader) + 1])
	_cMsg := ""
	Do Case
		Case empty(aCols[n, _nAux1 := aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})])
			_cMsg := "Digite um valor vแlido no campo " + AllTrim(aHeader[_nAux1, 1]) + "!"
			
		Case empty(aCols[n, _nAux1 := aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_VALOR"})]) .or.;
			aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_VALOR"})] > _nTotal
			_cMsg := "Digite um valor vแlido no campo " + AllTrim(aHeader[_nAux1, 1]) + "!"
			
		Case empty(aCols[n, _nAux1 := aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_DATA"})]) .and.;
			aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})] != "N"
			_cMsg := "Digite um valor vแlido no campo " + AllTrim(aHeader[_nAux1, 1]) + "!"
			
		Case aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_TIPO"})] == "N"
			aCols[n, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_DATA"})] := ctod('')
			_lRet := .T.
			
		OtherWise
			_lRet := .T.
	EndCase
	If !empty(_cMsg); MsgAlert(_cMsg, "Aten็ใo"); Endif
Endif
Return(_lRet)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ  VldTudo   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ 						    								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function VldTudo()
Local _lRet, _cMsg, _nAux1, _nTotPerc, _nTotValor

// Valida o total.
_nTotPerc := _nTotValor := 0
_lTipoVaz := .F.
For _nAux1 := 1 to len(aCols)
	// Soma somente se a linha nao estiver apagada.
	If !aCols[_nAux1, len(aHeader) + 1]
		_nTotPerc  += aCols[_nAux1, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_PERCENT"})]
		_nTotValor += aCols[_nAux1, aScan(aHeader, {|x| AllTrim(x[2]) == "Z3_VALOR"})]
	Endif
Next _nAux1

_lRet := .F.
Do Case
	Case !(_nTotPerc == 100)
		_cMsg := "O total nใo bate 100%"
		MsgAlert(_cMsg, "Aten็ใo  -  " + Transform(_nTotPerc, PesqPict('SZ3', 'Z3_PERCENT')))
	Case !(_nTotValor == _nTotal)
		_cMsg := "O valor total nใo bate com " + Transform(_nTotal, PesqPict('SZ3', 'Z3_VALOR'))
		MsgAlert(_cMsg, "Aten็ใo  -  " + Transform(_nTotValor, PesqPict('SZ3', 'Z3_VALOR')))
	OtherWise
		_lRet := .T.
EndCase

// Se tudo correto, fecha a janela de pagamentos.
If _lRet; oDlgPgto:end(); Endif
Return(_lRet)
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ GetEscolha บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ 						    								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function GetEscolha()
Local _nAux1, _cAux1, _nRet := 1
For _nAux1 := 1 to 3
	_cAux1 := AllTrim(str(_nAux1))
	If !empty(_cFornCod&(_cAux1)) .and. _cCotSts&(_cAux1) == "1"
		_nRet += _nAux1
		Exit  // Sai do looping.
	Endif
Next _nAux1
Return(_nRet)